import os
import sys
import pygit2

from .dmm import *
from .mapmerge import merge_map

def has_tgm_header(fname):
    with open(fname, 'r', encoding=ENCODING) as f:
        data = f.read(len(TGM_HEADER))
        return data.startswith(TGM_HEADER)

class LintException(Exception):
    pass

def _self_test():
    repo = pygit2.Repository(pygit2.discover_repository(os.getcwd()))

    # Read the HEAD and ancestor commits
    # Assumption: origin on the runner is what we'd normally call upstream
    ancestor = repo.merge_base(repo.head.target, repo.revparse_single("refs/remotes/origin/master").id)
    ancestor_commit = None
    if not ancestor:
        print("Unable to determine merge base!")
    else:
        ancestor_commit = repo[ancestor]
        print("Determined ancestor commit SHA to be:", ancestor)

    count = 0
    for dirpath, dirnames, filenames in os.walk('.'):
        if '.git' in dirnames:
            dirnames.remove('.git')
        for filename in filenames:
            if filename.endswith('.dmm'):
                fullpath = os.path.join(dirpath, filename)
                path = fullpath.replace("\\", "/").removeprefix("./")
                try:
                    # test: can we load every DMM in the tree
                    index_map = DMM.from_file(fullpath)

                    # test: is every DMM in TGM format
                    if not has_tgm_header(fullpath):
                        raise LintException('Map is not in TGM format! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')

                    # test: does every DMM convert cleanly
                    if ancestor_commit:
                        try:
                            ancestor_blob = ancestor_commit.tree[path]
                        except KeyError:
                            print("New map? Could not find ancestor version of", path)
                            # New map, no entry in HEAD
                            merged_map = merge_map(index_map, index_map)
                            original_bytes = index_map.to_bytes()
                            merged_bytes = merged_map.to_bytes()
                            if original_bytes != merged_bytes:
                                raise LintException('New map is pending updates! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')
                        else:
                            # Entry in HEAD, merge the index over it
                            ancestor_map = DMM.from_bytes(ancestor_blob.read_raw())
                            merged_map = merge_map(index_map, ancestor_map)
                            original_bytes = index_map.to_bytes()
                            merged_bytes = merged_map.to_bytes()
                            if original_bytes != merged_bytes:
                                raise LintException('Map is pending updates! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')
                except LintException as error:
                    print('Failed on:', path)
                    print(error)
                except Exception:
                    print('Failed on:', path)
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
