#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

MAIN_CF = '/etc/postfix/main.cf'

def set_main(name, values, path=MAIN_CF):
    ret = {
        'name': name,
        'result': False,
        'changes': {},
        'comment': '',
    }

    current_values = __salt__['postfix.show_main'](path)
    for key, value in values.items():
        current_value = None
        if key in current_values:
            current_value = current_values[key]

        if value == current_value:
            continue

        ret_set = __salt__['postfix.set_main'](key, value, path)
        ret['changes'][key] = {
            'old': current_value,
            'new': value,
        }

    ret['result'] = True
    if len(ret['changes']):
        ret['comment'] = 'Configuration changed'

    return ret
