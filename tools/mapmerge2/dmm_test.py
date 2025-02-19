import os
import sys
import pygit2

from .dmm import *
from .mapmerge import merge_map

def green(text):
    return "\033[32m" + str(text) + "\033[0m"

def red(text):
    return "\033[31m" + str(text) + "\033[0m"

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
    head = repo.head.target
    initial_head_commit = repo[head]
    upstream = repo.revparse_single("refs/remotes/origin/master").id
    ancestor = repo.merge_base(head, upstream)
    ancestor_commit = None
    if len(initial_head_commit.parent_ids) != 1: # if HEAD is a merge commit:
        for parent in initial_head_commit.parent_ids:
            if parent == upstream:
                continue
            head = parent
            ancestor = repo.merge_base(head, upstream)

    if not ancestor:
        print("Unable to determine merge base!")
    else:
        ancestor_commit = repo[ancestor]
        print("Determined ancestor commit SHA to be:", ancestor)

    # Figure out what maps have been modified
    modified_maps = []
    diff = repo.diff(head, ancestor)
    for delta in diff.deltas:
        cur_path = delta.new_file.path
        if cur_path.endswith('.dmm'):
            modified_maps.append(cur_path)

    # Actually perform the testing
    count = 0
    failed = 0
    for dirpath, dirnames, filenames in os.walk('.'):
        if '.git' in dirnames:
            dirnames.remove('.git')
        for filename in filenames:
            if filename.endswith('.dmm'):
                fullpath = os.path.join(dirpath, filename)
                path = fullpath.replace("\\", "/").removeprefix("./")
                try:
                    # test: can we load every DMM
                    index_data = DMM.from_file_bytes(fullpath)
                    index_map = DMM.from_bytes(index_data)

                    # test: is every DMM in TGM format
                    if not has_tgm_header(fullpath):
                        raise LintException('Map is not in TGM format! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')

                    # test: does every DMM convert cleanly
                    if ancestor_commit and (path in modified_maps):
                        try:
                            ancestor_blob = ancestor_commit.tree[path]
                        except KeyError:
                            # New map, no entry in ancestor
                            print("New map? Could not find ancestor version of", path)
                            merged_map = merge_map(index_map, index_map) # basically only tests unused keys
                            merged_bytes = merged_map.to_bytes()
                            if index_data != merged_bytes:
                                raise LintException('New map is pending updates! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')
                        else:
                            # Entry in ancestor, merge the index over it
                            ancestor_map = DMM.from_bytes(ancestor_blob.read_raw())
                            merged_map = merge_map(index_map, ancestor_map)
                            merged_bytes = merged_map.to_bytes()
                            if index_data != merged_bytes:
                                raise LintException('Map is pending updates! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')

                except LintException as error:
                    failed += 1
                    print(red(f'Failed on: {path}'))
                    print(error)
                except Exception:
                    failed += 1
                    print(red(f'Failed on: {path}'))
                    raise
                count += 1

    print(f"{os.path.relpath(__file__)}: {green(f'successfully parsed {count-failed} .dmm files ({len(modified_maps)} modified)')}")
    if failed > 0:
        print(f"{os.path.relpath(__file__)}: {red(f'failed to parse {failed} .dmm files')}")
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
