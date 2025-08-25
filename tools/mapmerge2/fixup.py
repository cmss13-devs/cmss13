#!/usr/bin/env python3
import os
import pygit2
from . import dmm
from .mapmerge import merge_map


STATUS_INDEX = (pygit2.GIT_STATUS_INDEX_NEW
    | pygit2.GIT_STATUS_INDEX_MODIFIED
    | pygit2.GIT_STATUS_INDEX_DELETED
    | pygit2.GIT_STATUS_INDEX_RENAMED
    | pygit2.GIT_STATUS_INDEX_TYPECHANGE
)
STATUS_WT = (pygit2.GIT_STATUS_WT_NEW
    | pygit2.GIT_STATUS_WT_MODIFIED
    | pygit2.GIT_STATUS_WT_DELETED
    | pygit2.GIT_STATUS_WT_RENAMED
    | pygit2.GIT_STATUS_WT_TYPECHANGE
)
ABBREV_LEN = 12
TGM_HEADER = dmm.TGM_HEADER.encode(dmm.ENCODING)


def walk_tree(tree, *, _prefix=''):
    for child in tree:
        if isinstance(child, pygit2.Tree):
            yield from walk_tree(child, _prefix=f'{_prefix}{child.name}/')
        else:
            yield f'{_prefix}{child.name}', child


def insert_into_tree(repo, tree_builder, path, blob_oid):
    try:
        first, rest = path.split('/', 1)
    except ValueError:
        tree_builder.insert(path, blob_oid, pygit2.GIT_FILEMODE_BLOB)
    else:
        inner = repo.TreeBuilder(tree_builder.get(first))
        insert_into_tree(repo, inner, rest, blob_oid)
        tree_builder.insert(first, inner.write(), pygit2.GIT_FILEMODE_TREE)


def main(repo : pygit2.Repository):
    if repo.index.conflicts:
        print("You need to resolve merge conflicts first.")
        return 1

    # Ensure the index is clean.
    for path, status in repo.status().items():
        if status & pygit2.GIT_STATUS_IGNORED:
            continue
        if status & STATUS_INDEX:
            print("You have changes staged for commit. Commit them or unstage them first.")
            print("If you are about to commit maps for the first time and can't use hooks, run `Run Before Committing.bat`.")
            return 1
        if path.endswith(".dmm") and (status & STATUS_WT):
            print("You have modified maps. Commit them first.")
            print("If you are about to commit maps for the first time and can't use hooks, run `Run Before Committing.bat`.")
            return 1

    # Set up upstream remote if needed
    try:
        repo.remotes.create("upstream", "https://github.com/cmss13-devs/cmss13.git")
    except ValueError:
        pass
    else:
        print("Adding upstream remote...")

    # Read the HEAD and ancestor commits.
    head_commit = repo[repo.head.target]
    repo.remotes["upstream"].fetch()
    ancestor = repo.merge_base(repo.head.target, repo.revparse_single("refs/remotes/upstream/master").id)
    if not ancestor:
        print("Unable to automatically fix anything because merge base could not be determined.")
        return 1
    ancestor_commit = repo[ancestor]
    print("Determined ancestor commit SHA to be:", ancestor)

    # Walk the head commit tree and convert as needed
    converted = {}
    commit_message_lines = []
    for path, blob in walk_tree(head_commit.tree):
        if path.endswith(".dmm"):
            head_data = blob.read_raw()
            head_map = dmm.DMM.from_bytes(head_data)

            # test: does every DMM convert cleanly (including TGM conversion)
            try:
                ancestor_blob = ancestor_commit.tree[path]
            except KeyError:
                # New map, no entry in ancestor
                merged_map = merge_map(head_map, head_map)
                merged_bytes = merged_map.to_bytes()
                if head_data != merged_bytes:
                    print(f"Updating new map: {path}")
                    commit_message_lines.append(f"{'new':{ABBREV_LEN}}: {path}")
                    converted[path] = merged_map
            else:
                # Entry in ancestor
                ancestor_map = dmm.DMM.from_bytes(ancestor_blob.read_raw())
                merged_map = merge_map(head_map, ancestor_map)
                merged_bytes = merged_map.to_bytes()
                if head_data != merged_bytes:
                    print(f"Updating map: {path}")
                    str_id = str(ancestor_commit.id)[:ABBREV_LEN]
                    commit_message_lines.append(f"{str_id}: {path}")
                    converted[path] = merged_map

    if not converted:
        print("All committed maps appear to be okay.")
        print("If you are about to commit maps for the first time and can't use hooks, run `Run Before Committing.bat`.")
        return 1

    # Okay, do the actual work.
    tree_builder = repo.TreeBuilder(head_commit.tree)
    for path, merged_map in converted.items():
        blob_oid = repo.create_blob(merged_map.to_bytes())
        insert_into_tree(repo, tree_builder, path, blob_oid)
        repo.index.add(pygit2.IndexEntry(path, blob_oid, repo.index[path].mode))
        merged_map.to_file(os.path.join(repo.workdir, path))

    # Save the index.
    repo.index.write()

    # Commit the index to the current branch.
    signature = pygit2.Signature(repo.config['user.name'], repo.config['user.email'])
    joined = "\n".join(commit_message_lines)
    repo.create_commit(
        repo.head.name,
        signature,  # author
        signature,  # committer
        f'Fixup maps in TGM format\n\n{joined}\n\nAutomatically commited by: {os.path.relpath(__file__, repo.workdir)}',
        tree_builder.write(),
        [head_commit.id],
    )

    # Success.
    print("Successfully committed a fixup. Push as needed.")
    return 0


if __name__ == '__main__':
    exit(main(pygit2.Repository(pygit2.discover_repository(os.getcwd()))))
