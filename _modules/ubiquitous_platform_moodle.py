from os.path import join


def install_config(basename, release):
    """
    Install Moodle configuration.

    :param str basename: Platform basename.
    :param str release: Release name.
    :return bool: True on success, else False.
    """
    platform = __salt__['ubiquitous_platform.get_config'](basename)
    release_dir = __salt__['ubiquitous_platform.get_release_dir'](basename, release)
    source = join(platform['user']['home'], 'config.php')
    dest = join(release_dir, 'config.php')
    return __salt__['file.copy'](source, dest)
