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
    ancestor = None
    ancestor_commit = None
    try:
        # if HEAD is a merge commit:
        ancestor = repo.merge_base(repo.revparse_single("HEAD^2").id, repo.revparse_single("refs/remotes/origin/master").id)
    except KeyError:
        # if HEAD isn't a merge commit:
        ancestor = repo.merge_base(repo.head.target, repo.revparse_single("refs/remotes/origin/master").id)
        pass
    if not ancestor:
        print("Unable to determine merge base!")
    else:
        ancestor_commit = repo[ancestor]
        print("Determined ancestor commit SHA to be:", ancestor)

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
                    index_map = DMM.from_file(fullpath)

                    # test: is every DMM in TGM format
                    if not has_tgm_header(fullpath):
                        raise LintException('Map is not in TGM format! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')

                    # test: does every DMM convert cleanly
                    if ancestor_commit:
                        try:
                            ancestor_blob = ancestor_commit.tree[path]
                        except KeyError:
                            # New map, no entry in ancestor
                            print("New map? Could not find ancestor version of", path)
                            merged_map = merge_map(index_map, index_map) # basically only tests unused keys
                            original_bytes = index_map.to_bytes()
                            merged_bytes = merged_map.to_bytes()
                            if original_bytes != merged_bytes:
                                raise LintException('New map is pending updates! Please run `/tools/mapmerge2/I Forgot To Map Merge.bat`')
                        else:
                            # Entry in ancestor, merge the index over it
                            ancestor_map = DMM.from_bytes(ancestor_blob.read_raw())
                            merged_map = merge_map(index_map, ancestor_map)
                            original_bytes = index_map.to_bytes()
                            merged_bytes = merged_map.to_bytes()
                            if original_bytes != merged_bytes:
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

    print(f"{os.path.relpath(__file__)}: {green(f'successfully parsed {count-failed} .dmm files')}")
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
