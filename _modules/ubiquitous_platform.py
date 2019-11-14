from logging import getLogger
from operator import itemgetter
from os import chown, scandir, unlink
from os.path import islink, join
from shutil import rmtree


RELEASE_ROOT = '{home_dir}/releases'
RELEASE_DIR = '{home_dir}/releases/{release}'

APP_INSTALL_CONFIG = 'ubiquitous_platform_{}.install_config'

NGINX_EXTRA_CONFIG = '/etc/nginx/sites-extra/{basename}.{config}.conf'

PHP_FPM_EXTRA_CONFIG = '/etc/php/{php_version}/fpm/pools-extra/{basename}.{config}.conf'
PHP_FPM_VARIANT_AVAILABLE = '/etc/php/{php_version}/fpm/pools-available/{basename}.{variant}.conf'
PHP_FPM_VARIANT_ENABLED = '/etc/php/{php_version}/fpm/pools-enabled/{basename}.{variant}.conf'
PHP_FPM_SERVICE = 'php{}-fpm'
PHP_FPM_VARIANTS = ['blue', 'green']
PHP_FPM_DEFAULT_VARIANT = PHP_FPM_VARIANTS[0]


log = getLogger(__name__)


def _chown_r(target, user, group=None):
    """
    Recursively set the permissions on a directory.

    :param str target: Target file.
    :param str user: User name.
    :param str group: Group name (optional).
    """
    ownership = "{}:{}".format(user, group) if group else user
    ret = __salt__['cmd.run_all']([
        'chown', '-R', ownership, target,
    ])
    return ret['retcode'] == 0

def _reload_or_restart_service(service):
    """
    Reload the specified service, then restart if it's not working.

    :param str service: The name of the service.
    :return bool: True on success, else failure.
    """
    ret = __salt__['service.reload'](service)
    if not ret:
        ret = __salt__['service.restart'](service)
    return ret


def _php_fpm_pool_variants(basename):
    """
    Retrieve the active states of the blue/green variants.

    :param str basename: Platform basename.
    :return dict[str, bool]: Variant states.
    """
    platform = get_config(basename)
    ret = {}
    for variant in PHP_FPM_VARIANTS:
        link = PHP_FPM_VARIANT_ENABLED.format(
                php_version=platform['php']['version'],
                basename=basename, variant=variant)
        ret[variant] = islink(link)
    return ret


def _php_fpm_pool_disable_variant(basename, variant):
    """
    Disable the named pool variant.

    :param str basename: Platform basename.
    :param str variant: Variant name.
    """
    platform = get_config(basename)
    link = PHP_FPM_VARIANT_ENABLED.format(
            php_version=platform['php']['version'],
            basename=basename,
            variant=variant)
    __salt__['file.remove'](link)


def _php_fpm_pool_enable_variant(basename, variant):
    """
    Enable the named pool variant.

    :param str basename: Platform basename.
    :param str variant: Variant name.
    """
    platform = get_config(basename)
    subs = {
        'php_version': platform['php']['version'],
        'basename': basename,
        'variant': variant,
    }
    source = PHP_FPM_VARIANT_AVAILABLE.format(**subs)
    dest = PHP_FPM_VARIANT_ENABLED.format(**subs)
    __salt__['file.symlink'](source, dest)


def _find_chmod(runas, dest, objtype, mode):
    """
    Recursively change the mode on files or directories.

    :param str runas: The name of the user as whom to run `find`.
    :param str dest: The directory to search.
    :param str objtype: The type of object to change (e.g. "d" for directories, "f" for files).
    :param str mode: The new mode of the objects.
    """
    __salt__['cmd.run_all']([
        'find', dest,
        '-type', objtype,
        '-exec', 'chmod', mode, '{}', ';',
    ], runas=runas)


def get_config(basename):
    """
    Retrieve configuration for the named platform from the pillar.

    :param str basename: Platform basename.
    :return dict: Pillar configuration.
    """
    for domain, config in __salt__['pillar.get']('platforms', {}).items():
        if config['basename'] == basename:
            config['domain'] = domain
            return config

    raise KeyError('no platform with basename {}'.format(basename))


def get_release_dir(basename, release):
    """
    Get the path to the given release.

    :param str basename: Platform basename.
    :param str release: Release name.
    :return str: Release directory path.
    """
    platform = get_config(basename)
    return RELEASE_DIR.format(
            home_dir=platform['user']['home'], release=release)


def install_release(basename, release, source):
    """
    Install release from source directory.

    :param str basename: Platform basename.
    :param str release: Release name.
    :param str source: Source directory path.
    :return bool: True on success, else False.
    """
    platform = get_config(basename)
    install_config = __salt__[APP_INSTALL_CONFIG.format(platform['role'])]
    dest = get_release_dir(basename, release)

    __salt__['file.copy'](source, dest, recurse=True, remove_existing=True)

    _chown_r(dest, platform['user']['name'], platform['user']['name'])
    _find_chmod(platform['user']['name'], dest, 'd', '0770')
    _find_chmod(platform['user']['name'], dest, 'f', '0750')
    install_config(basename, release)
    return True


def get_current_release(basename):
    """
    Get the current release name.

    :param str basename: Platform basename.
    :return str: Release name.
    """
    platform = get_config(basename)
    current = join(platform['user']['home'], 'current')
    release_dir = __salt__['file.readlink'](current)
    return __salt__['file.basename'](release_dir)


def set_current_release(basename, release):
    """
    Set the current release.

    :param str basename: Platform basename.
    :param str release: Release name.
    :return bool: True on success, else False.
    """
    platform = get_config(basename)
    source = get_release_dir(basename, release)
    dest = join(platform['user']['home'], 'current')
    ret = __salt__['cmd.run_all']([
        'ln', '-sfn', source, dest,
    ], runas=platform['user']['name'])
    return ret['retcode'] == 0


def php_fpm_rollover(basename):
    """
    Switch between the blue/green pools.

    :param str basename: Platform basename.
    :return bool: True on success, else False.
    """
    platform = get_config(basename)
    service = PHP_FPM_SERVICE.format(platform['php']['version'])
    variants = _php_fpm_pool_variants(basename)

    if not __salt__['service.status'](service):
        log.warn('service {} was not in the running state; aborting'.format(service))
        return

    # Handle the two corner cases:
    # 1. Multiple active variants, probably caused by the failure of a previous
    #    rollover attempt. Remove "enabled" links for all but the first
    #    variants, then restart PHP-FPM once.
    # 2. No active variants, probably because it's our first time setting the
    #    active variant for this platform.
    active_variants = 0
    for variant, status in variants.items():
        if status:
            active_variants += 1
        if active_variants > 1:
            log.warn('found multiple active variants for pool {}; disabling {}'.format(
                    basename, variant))
            _php_fpm_pool_disable_variant(basename, variant)
            variants[variant] = False
    if active_variants > 1:
        _reload_or_restart_service(service)
    elif active_variants == 0:
        log.warning('no active variant variant for pool {}; defaulting to {}'.format(
                basename, PHP_FPM_DEFAULT_VARIANT))
        variants[PHP_FPM_DEFAULT_VARIANT] = True

    old_variant = next(variant for variant, status in variants.items() if status)
    new_variant = next(variant for variant, status in variants.items() if not status)
    log.debug('swapping pool {} variant from {} to {}'.format(
            basename, old_variant, new_variant))

    _php_fpm_pool_enable_variant(basename, new_variant)
    # FIXME: this would be the place to reload FPM and prime the new pool
    #        before we complete the rollover. To do this we'd need to figure
    #        out how to atomically switch between releases on the web server.
    _php_fpm_pool_disable_variant(basename, old_variant)
    _reload_or_restart_service(service)


def prune_releases(basename, keep_releases, dry_run=False):
    """
    Prune old releases.

    Remove non-current releases that are installed under the specified
    platform's release repository. Can be used to free up disk space. The
    current release is always exempt from removal.

    :param str basename: Platform basename.
    :param int keep_releases: Number of releases to retain.
    :param bool dry_run: Plan which releases would be removed, but don't do it.
    """
    if keep_releases < 0:
        raise ValueError("Number of releases to keep must be >= 0")

    platform = get_config(basename)
    release_dir = RELEASE_ROOT.format(home_dir=platform['user']['home'])
    current_release = get_current_release(basename)

    log.debug('release directory is {}, current release is {}'.format(
            release_dir, current_release))

    installed_releases = [(d.name, d.stat().st_ctime) for d in scandir(release_dir)]
    removal_candidates = [name for name, ctime in sorted(installed_releases, key=itemgetter(1))]
    log.debug('installed releases are {}'.format(removal_candidates))

    removal_candidates.remove(current_release)

    to_remove = removal_candidates if keep_releases == 0 else removal_candidates[:-keep_releases]
    log.debug('removing releases {}'.format(to_remove))

    if not dry_run:
        for release in to_remove:
            release_dir = get_release_dir(basename, release)
            log.info('removing release dir {}'.format(release_dir))
            rmtree(release_dir)

    return to_remove
