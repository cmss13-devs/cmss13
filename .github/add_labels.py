import os, re
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
	'server': ["Server", ["something server ops should know"]]
}

fileToPrefix = {
	'wav': 'Sound',
	'ogg': 'Sound',
	'dmm': 'Mapping',

	'js': 'UI',
	'tsx': 'UI',
	'ts': 'UI',
	'jsx': 'UI',
	'scss': 'UI',

	'dmi': "Sprites",
}

githubLabel = "Github"

def get_labels(pr):
	labels = {}

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
			return labels
	lines = changelog_match.group(1).split('\n')
	for line in lines:
		line = line.strip()
		if not line:
			continue

		contentSplit = line.split(":")

		key = contentSplit.pop(0).strip()
		content = ":".join(contentSplit).strip()

		if not key in changelogToPrefix:
			continue

		if content in changelogToPrefix[key][1]:
			continue

		labels[changelogToPrefix[key][0]] = True

	return list(labels)

def main():
	g = Github(os.environ["TOKEN"])
	repo = g.get_repo(os.environ['REPO'])

	pr = repo.get_pull(int(os.environ["PR_NUMBER"]))
	if not pr:
		print("Not a PR.")
		return

	labels = get_labels(pr)

	if labels is None: # no labels to add
		print("No labels to add.")
		return

	for label in labels:
		pr.add_to_labels(label)


if __name__ == '__main__':
	main()
