#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

def present(name, **kwargs):
    ret = {
        'name': name,
        'result': False,
        'changes': {},
        'comment': '',
    }

    if __salt__['mssql.login_exists'](name, **kwargs):
        ret['result'] = True
        ret['comment'] = 'Login "{}" already exists'.format(name)
        return ret

    if __salt__['mssql.login_create'](name, **kwargs):
        ret['result'] = True
        ret['comment'] = 'Login "{}" created'.format(name)
        ret['changes'][name] = 'Present'

    return ret
