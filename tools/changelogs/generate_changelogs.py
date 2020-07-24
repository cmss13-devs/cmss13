'''
    generate_changelogs.py

    Script for automatically generating YAML changelog files from merge request descriptions
'''

from os import environ
from sys import argv
import dateutil.parser as dateparser

from branch import Branch
from changelog import Changelog

DATE_FORMAT = "%d.%m.%Y %H:%M:%S"
MR_DATES_FILE = "last_mr_dates.txt"

def generate_changelogs(pid, branch, pat):
    '''
        Generates changelogs from MR descriptions on the given branch

        :param pid: The project ID of the project to work with
        :param branch: The name of the target branch for which we look for MRs
        :param pat: The personal access token to use
    '''

    # Load the latest MR date on the branch
    working_branch = Branch(pid, branch)
    working_branch.load_latest_mr_date(MR_DATES_FILE)

    # Show when the merge date of the MR we processed last run
    last_mr_date = working_branch.get_latest_mr_date()
    if last_mr_date:
        print("Latest merge date:")

        last_processed_date = dateparser.parse(last_mr_date)
        print("    {} - {}".format(branch, last_processed_date.strftime(DATE_FORMAT)))

    # Fetch new MRs on the branch
    mrs, status_code = working_branch.fetch_new_mrs(pat)

    # Didn't fetch any MRs
    if not mrs:
        print("No new MRs to parse.")
        return

    print("Parsing merge requests. This may take a while...")
    print("--------------------")

    # Fun facts to track
    mrs_parsed = 0
    cls_generated = 0

    # This is stored to make sure we parse all MRs merged after
    # the MR most lately processed in the previous script run,
    # even if the MRs were merged "out of order" by issue number.
    initial_latest_mr_date = dateparser.parse(working_branch.get_latest_mr_date())

    # Keep fetching changelogs until there are none left to parse
    while mrs:
        if status_code == 429:
            print("Rate limit hit for the API. Try running the script again later.")
            break

        if status_code != 200:
            print("Failed to fetch additional MRs! (Status code: {})".format(status_code))
            break

        # Go through all the MRs and make changelogs
        for merge_request in mrs:
            iid = merge_request.get("iid")
            title = merge_request.get("title")

            # Check if this MR was merged later than the current most lately merged MR
            latest_mr_date = dateparser.parse(working_branch.get_latest_mr_date())
            if merge_request.get("merged_at") is None:
                continue
            mr_merged_date = dateparser.parse(merge_request.get("merged_at"))

            # This can happen if someone updates the MR between the script being run
            # So this prevents re-processing processed MRs
            if mr_merged_date < initial_latest_mr_date:
                continue

            # Update the latest MR date
            if mr_merged_date > latest_mr_date:
                working_branch.set_latest_mr_date(merge_request.get("merged_at"))


            # Find an author for the CL (this is for fallbacks)
            author = merge_request.get("author")
            user = "somebody"
            if author:
                user = author.get("username")

            # Make the changelog
            print("Parsing MR #{}    {}".format(iid, title))
            changelog = Changelog()
            success = changelog.parse_changelog(merge_request.get("description"))
            mrs_parsed += 1

            # No changelog found :(
            if not success:
                continue

            if not changelog.author:
                changelog.set_author(user) # Fallback to gitlab username as CL author

            # make a YAML file for the changelog
            file_name = "{}-merge_request-{}".format(user, merge_request.get("id"))
            changelog.dump_yaml(file_name)
            print("Generated changelog for MR #{}    {}".format(iid, file_name))
            cls_generated += 1

        # Fetch new MRs to process
        mrs, status_code = working_branch.fetch_new_mrs(pat)

    print("--------------------")
    # High quality fluffprint
    print("Parsed {} merge request{}.".format(mrs_parsed, "" if mrs_parsed == 1 else "s"))
    print("{} changelog{} generated.".format(cls_generated, " was" if cls_generated == 1 else "s were"))

    # Save our progress on changelog generation
    working_branch.save_latest_mr_date(MR_DATES_FILE)

if __name__ == "__main__":
    if argv[2] is None:
        PID = environ["GITLAB_CHANGELOG_PID"]
        PAT = environ["GITLAB_CHANGELOG_PAT"]
    else :
        PID = argv[2]
        PAT = argv{3]}

    generate_changelogs(PID, argv[1], PAT)
