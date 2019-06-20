from os.path import join


CONFIG_TEMPLATE = 'salt://app-moodle/moodle/config.php.jinja'
CONFIG_TEMPLATE_FORMAT = 'jinja'
CONFIG_DESTINATION = '{release_dir}/config.php'
CONFIG_MODE = '660'

ALTERNATIVE_COMPONENT_CACHE_SCRIPT = '{release_dir}/admin/cli/alternative_component_cache.php'
PHP_CLI = 'php{php_version}'


def install_config(basename, release):
    """
    Install Moodle configuration.

    :param str basename: Platform basename.
    :param str release: Release name.
    :return bool: True on success, else False.
    """
    def template(contents, context):
        return __salt__['file.apply_template_on_contents'](
                contents, CONFIG_TEMPLATE_FORMAT, context,
                defaults={}, saltenv=__opts__['saltenv'])

    platform = __salt__['ubiquitous_platform.get_config'](basename)
    release_dir = __salt__['ubiquitous_platform.get_release_dir'](basename, release)
    dest = CONFIG_DESTINATION.format(release_dir=release_dir)

    context = {
        'domain': platform['domain'],
        'release': {
            'name': release,
            'dir': release_dir,
        },
    }

    for k in ['pre_bootstrap', 'post_bootstrap']:
        try:
            contents = platform['moodle'][k]
        except KeyError:
            contents = ''
        context[k] = template(contents, context)

    state = {
        'saltenv': __opts__['saltenv'],
        'source': CONFIG_TEMPLATE,
        'template': CONFIG_TEMPLATE_FORMAT,
        'context': context,
        'user': platform['user']['name'],
        'group': platform['user']['name'],
        'mode': CONFIG_MODE,
    }
    ret_config = __salt__['state.single']('file.managed', dest, **state)

    ret_component_cache = None
    alternative_component_cache_script = ALTERNATIVE_COMPONENT_CACHE_SCRIPT.format(
            release_dir=release_dir)
    if platform['moodle'].get('use_alternative_component_cache', False):
        ret_component_cache = __salt__['cmd.run_all']([
            PHP_CLI.format(php_version=platform['php']['version']),
            alternative_component_cache_script,
            '--rebuild',
        ], runas=platform['user']['name'])

    return {
        'config': ret_config,
        'component_cache': ret_component_cache,
    }
