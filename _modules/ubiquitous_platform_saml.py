from os.path import join


CONFIG_DIR_MODE = '770'
CONFIG_FILE_MODE = '640'

CONFIG_PHP_TEMPLATE = 'salt://app-saml/saml/config.php.jinja'
CONFIG_PHP_TEMPLATE_FORMAT = 'jinja'


def install_config(basename, release):
    """
    Install SimpleSAMLphp configuration.

    :param str basename: Platform basename.
    :param str release: Release name.
    :return bool: True on success, else False.
    """
    platform = __salt__['ubiquitous_platform.get_config'](basename)
    release_dir = __salt__['ubiquitous_platform.get_release_dir'](basename, release)

    def _directory(name, **kwargs):
        state = {
            'user': platform['user']['name'],
            'group': platform['user']['name'],
            'mode': CONFIG_DIR_MODE,
        }

        state.update(kwargs)
        return __salt__['state.single'](
                'file.directory', join(release_dir, name), **state)

    def _file(name, **kwargs):
        state = {
            'saltenv': __opts__['saltenv'],
            'user': platform['user']['name'],
            'group': platform['user']['name'],
            'mode': CONFIG_FILE_MODE,
        }

        state.update(kwargs)
        return __salt__['state.single'](
                'file.managed', join(release_dir, name), **state)

    ret = []
    ret.append(_directory('config'))
    ret.append(_directory('cert'))
    ret.append(_directory('metadata'))
    ret.append(_directory('modules'))

    for file, contents in platform['saml']['config'].items():
        ret.append(_file(
                'config/{}.php'.format(file), source=CONFIG_PHP_TEMPLATE,
                template='jinja', context={'contents': contents}))

    for module, status in platform['saml']['modules'].items():
        directory = 'modules/{}'.format(module)
        filename = '{}/enable'.format(directory)
        if status:
            ret.append(_directory(directory))
            ret.append(_file(filename))
        else:
            ret.append(__salt__['state.single']('file.absent', filename))

    for cert, contents in platform['saml']['cert'].items():
        ret.append(_file('cert/{}'.format(cert), contents=contents))

    for file, contents in platform['saml']['metadata'].items():
        ret.append(_file(
                'metadata/{}.php'.format(file), source=CONFIG_PHP_TEMPLATE,
                template=CONFIG_PHP_TEMPLATE_FORMAT, context={'contents': contents}))

    return ret
