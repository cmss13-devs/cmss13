import os, re
from github import Github, GithubException

# Format - Key: Array[Label, [StringsToIgnore]]
changelogToPrefix = {
    'fix': ["Fix", ["fixed a few things"]],
    'qol': ["Quality of Life", ["made something easier to use"]],
    'add': ["Feature", ["Added new mechanics or gameplay changes", "Added more things"]],
    'del': ["Removal", ["Removed old things"]],
    'spellcheck': ["Grammar and Formatting", ["fixed a few typos"]],
    'balance': ["Balance", ["rebalanced something"]],
    'code': ["Code Improvement", ["changed some code"]],
    'refactor': ["Refactor", ["refactored some code"]],
    'config': ["Config", ["changed some config setting"]],
    'admin': ["Admin", ["messed with admin stuff"]],
    'server': ["Server", ["something server ops should know"]],
    'soundadd': ["Sound", ["added a new sound thingy"]],
    'sounddel': ["Sound", ["removed an old sound thingy"]],
    'imageadd': ["Sprites", ["added some icons and images"]],
    'imagedel': ["Sprites", ["deleted some icons and images"]],
    'mapadd': ["Mapping", ["added a new map or section to a map"]],
    'maptweak': ["Mapping", ["tweaked a map"]],
    'ui' : ["UI", ["changed something relating to user interfaces"]]
}

fileToPrefix = {
    'wav': 'Sound',
    'ogg': 'Sound',
    'mp3': 'Sound', ## Can't believe they forgot about the best sound format
    'dmm': 'Mapping',

    'js': 'UI',
    'tsx': 'UI',
    'ts': 'UI',
    'jsx': 'UI',
    'scss': 'UI',

    'dmi': "Sprites",
}

githubLabel = "Github"
missingLogLabel = "Missing Changelog"

def get_labels(pr):
    labels = {}
    failed = False

    files = pr.get_files()
    for file in files:
        prefix = file.filename.split(".")[-1]
        if file.filename.startswith(".github"):
            labels[githubLabel] = True
        if not prefix in fileToPrefix:
            continue
        labels[fileToPrefix[prefix]] = True

    changelog_match = re.search(r"🆑(.*)/🆑", pr.body, re.S | re.M)
    if changelog_match is None:
        changelog_match = re.search(r":cl:(.*)/:cl:", pr.body, re.S | re.M)
        if changelog_match is None:
            print("::warning ::No changelog detected.")
            labels[missingLogLabel] = True
            return labels, False

    lines = changelog_match.group(1).split('\n')
    failed = len(lines) <= 2 # Make sure its not an empty changelog
    if failed:
        print("::error ::Empty changelog.")

    for line in lines[1:-1]: # Skip first line with authors and last
        line = line.strip()
        if not line:
            continue

        contentSplit = line.split(":")

        key = contentSplit.pop(0).strip()
        content = ":".join(contentSplit).strip()

        if not key in changelogToPrefix: # Some key that we didn't expect
            print(f"::error ::Invalid changelog entry: {line}")
            failed = True
            continue

        if content in changelogToPrefix[key][1]: # They left the template entry in
            print(f"::error ::Invalid changelog entry: {line}")
            failed = True
            continue

        labels[changelogToPrefix[key][0]] = True

    return list(labels), failed

def main():
    g = Github(os.environ["TOKEN"])
    repo = g.get_repo(os.environ['REPO'])

    pr = repo.get_pull(int(os.environ["PR_NUMBER"]))
    if not pr:
        print("::warning ::Not a PR.")
        return

    labels, failed = get_labels(pr)

    if not missingLogLabel in labels:
        try:
            pr.remove_from_labels(missingLogLabel)
        except GithubException as e:
            if e.status == 404:
                pass # 404 if we try to remove a label that isn't set

    for label in labels:
        pr.add_to_labels(label)

    if failed:
        exit(1)

if __name__ == '__main__':
    main()
