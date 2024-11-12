import os
import sys
import pygit2

from .dmm import *
from .mapmerge import merge_map

def has_tgm_header(fname):
    with open(fname, 'r', encoding=ENCODING) as f:
        data = f.read()
        return data.startswith(TGM_HEADER)

def _self_test():
    repo = pygit2.Repository(pygit2.discover_repository(os.getcwd()))
    count = 0
    for dirpath, dirnames, filenames in os.walk('.'):
        if '.git' in dirnames:
            dirnames.remove('.git')
        for filename in filenames:
            if filename.endswith('.dmm'):
                fullpath = os.path.join(dirpath, filename)
                path = fullpath.removeprefix(".\\").replace("\\", "/")
                try:
                    # test: can we load every DMM in the tree
                    index_map = DMM.from_file(fullpath)

                    # test: is every DMM in TGM format
                    if not has_tgm_header(fullpath):
                        raise Exception('Map is not in TGM format! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')

                    # test: does every DMM convert cleanly
                    try:
                        head_blob = repo[repo[repo.head.target].tree[path].id]
                    except KeyError:
                        # New map, no entry in HEAD
                        merged_map = merge_map(index_map, index_map)
                        originalBytes = index_map.to_bytes()
                        mergedBytes = merged_map.to_bytes()
                        if originalBytes != mergedBytes:
                            raise Exception('New map is pending updates! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')
                    else:
                        # Entry in HEAD, merge the index over it
                        head_map = DMM.from_bytes(head_blob.read_raw())
                        merged_map = merge_map(index_map, head_map)
                        originalBytes = index_map.to_bytes()
                        mergedBytes = merged_map.to_bytes()
                        if originalBytes != mergedBytes:
                            raise Exception('Map is pending updates! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')
                except Exception:
                    print('Failed on:', fullpath)
                    raise
                count += 1

    print(f"{os.path.relpath(__file__)}: successfully parsed {count} .dmm files")


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
