import yaml, os, re, argparse
from github import Github, InputGitAuthor

opt = argparse.ArgumentParser()
opt.add_argument('ymlDir', help='The directory of YAML changelogs we will use.')

args = opt.parse_args()

prefixToActual = {
	'fix': 'bugfix',
	'sound': 'soundadd',
	'add': 'rscadd',
	'del': 'rscdel',
	'sprite': 'imageadd',
	'code': 'code_imp',
}

def parse_pr_changelog(pr):
	yaml_object = {}
	changelog_match = re.search(r"🆑(.*)/🆑", pr.body, re.S | re.M)
	if changelog_match is None:
		changelog_match = re.search(r":cl:(.*)/:cl:", pr.body, re.S | re.M)
		if changelog_match is None:
			return
	lines = changelog_match.group(1).split('\n')
	entries = []
	for index, line in enumerate(lines):
		line = line.strip()
		if index == 0:
			author = line.strip()
			if not author or author == "John Titor":
				author = pr.user.login
				print("Author not set, substituting", author)
			yaml_object["author"] = author
			continue
		if not line:
			continue

		splitData = line.split(":")

		if len(splitData) < 2:
			continue

		key = splitData.pop(0).strip()
		content = ":".join(splitData).strip()
		if key in prefixToActual:
			key = prefixToActual[key]
		entries.append({
			key: content
		})
	yaml_object["changes"] = entries
	return yaml_object

def main():
	g = Github()
	repo = g.get_repo(os.environ['REPO'])

	commit = repo.get_commit(os.environ["GITHUB_SHA"])
	pulls = commit.get_pulls()
	if not pulls.totalCount:
		print("Not a PR.")
		return
	pr = pulls[0]

	pr_data = parse_pr_changelog(pr)

	if pr_data is None: # no changelog
		print("No changelog provided.")
		return

	with open(os.path.join(args.ymlDir, "{}-{}.yml".format(os.environ["GITHUB_ACTOR"], os.environ["GITHUB_SHA"])), 'w') as file:
		yaml.dump(pr_data, file, default_flow_style=False, allow_unicode=True)

if __name__ == '__main__':
	main()
