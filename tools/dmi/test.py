import os
import sys
from dmi import *


def _self_test():
    # test: can we load every DMI in the tree
    count = 0
    failed = 0
    for dirpath, dirnames, filenames in os.walk('.'):
        if '.git' in dirnames:
            dirnames.remove('.git')
        for filename in filenames:
            if filename.endswith('.dmi'):
                fullpath = os.path.join(dirpath, filename)
                try:
                    dmi = Dmi.from_file(fullpath)
                    dmi_states = dmi.states
                    number_of_icon_states = len(dmi.states)
                    if number_of_icon_states > 512:
                        print("{0} has too many icon states: {1}/512.".format(fullpath, number_of_icon_states))
                        failed += 1
                    existing_states = []
                    for state in dmi_states:
                        if state.name in existing_states:
                            print("{0} has a duplicate state '{1}'.".format(fullpath, state.name))
                            failed += 1
                            continue
                        existing_states.append(state.name)
                except Exception:
                    print('Failed on:', fullpath)
                    failed += 1
                    raise
                count += 1

    print(f"{os.path.relpath(__file__)}: successfully parsed {count-failed} .dmi files")
    if failed > 0:
        print(f"{os.path.relpath(__file__)}: failed to parse {failed} .dmi files")
        exit(1)


def _usage():
    print(f"Usage:")
    print(f"    tools{os.sep}bootstrap{os.sep}python -m {__spec__.name}")
    exit(1)


def _main():
    if len(sys.argv) == 1:
        return _self_test()

    return _usage()


if __name__ == '__main__':
    _main()
