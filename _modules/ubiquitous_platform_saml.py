from os.path import join


def install_config(basename, release):
    """
    Install SimpleSAMLphp configuration.

    :param str basename: Platform basename.
    :param str release: Release name.
    :return bool: True on success, else False.
    """
    platform = __salt__['ubiquitous_platform.get_config'](basename)
    source = join(platform['user']['home'], 'conf')
    dest = __salt__['ubiquitous_platform.get_release_dir'](basename, release)
    return __salt__['file.copy'](source, dest, recurse=True)
