#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

ALTER_FORMAT = 'ALTER DATABASE {} {}'

def present(name, alter=[], **kwargs):
    ret = {
        'name': name,
        'result': False,
        'changes': {},
        'comment': '',
    }

    if __salt__['mssql.db_exists'](name, **kwargs):
        ret['result'] = True
        ret['comment'] = 'Database "{}" already exists'.format(name)
        return ret

    if __salt__['mssql.db_create'](name, **kwargs):
        for alter_stmt in alter:
            query = ALTER_FORMAT.format(name, alter_stmt)
            __salt__['mssql.tsql_query'](query, autocommit=True, **kwargs)

        ret['result'] = True
        ret['comment'] = 'Database "{}" created'.format(name)
        ret['changes'][name] = 'Present'

    return ret
