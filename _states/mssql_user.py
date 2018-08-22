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

    if __salt__['mssql.user_exists'](name, **kwargs):
        ret['result'] = True
        ret['comment'] = 'User "{}" already exists'.format(name)
        return ret

    if __salt__['mssql.user_create'](name, **kwargs):
        ret['result'] = True
        ret['comment'] = 'User "{}" created'.format(name)
        ret['changes'][name] = 'Present'

    return ret
