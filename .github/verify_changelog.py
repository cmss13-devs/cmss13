import os, re
from enum import Enum
from github import Github

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

class Result(Enum):
    INVALID = -1
    VALID = 0
    MISSING = 1

def validate_changelog(pr):
    changelog_match = re.search(r"🆑(.*)/🆑", pr.body, re.S | re.M)
    if changelog_match is None:
        changelog_match = re.search(r":cl:(.*)/:cl:", pr.body, re.S | re.M)
        if changelog_match is None:
            return Result.MISSING

    lines = changelog_match.group(2).split('\n')
    for line in lines:
        line = line.strip()
        if not line:
            continue

        contentSplit = line.split(":")

        key = contentSplit.pop(0).strip()
        content = ":".join(contentSplit).strip()

        if not key in changelogToPrefix: # some key that we didn't expect
            print("Invalid changelog entry: " + line)
            return Result.INVALID

        if content in changelogToPrefix[key][1]: # They left the template entry in
            print("Invalid changelog entry: " + line)
            return Result.INVALID

    return Result.VALID

def main():
    g = Github(os.environ["TOKEN"])
    repo = g.get_repo(os.environ['REPO'])

    pr = repo.get_pull(int(os.environ["PR_NUMBER"]))
    if not pr:
        print("Not a PR.")
        return Result.INVALID

    result = validate_changelog(pr)

    if result == Result.MISSING:
        print("No changelog detected.")

    return result


if __name__ == '__main__':
    main()
