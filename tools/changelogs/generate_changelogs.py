'''
    generate_changelogs.py

    Script for automatically generating YAML changelog files from merge request descriptions
'''

from os import environ
from sys import argv
import datetime
import dateutil.parser as dateparser

from branch import Branch
from changelog import Changelog

DATE_FORMAT = "%d.%m.%Y %H:%M:%S"
MR_DATES_FILE = "last_mr_dates.txt"

def generate_changelogs(pid, branch, directory):
    '''
        Generates changelogs from MR descriptions on the given branch

        :param pid: The project ID of the project to work with
        :param branch: The name of the target branch for which we look for MRs
    '''

    # Load the latest MR date on the branch
    working_branch = Branch(pid, branch)
    working_branch.load_latest_mr_date(str(pid)+'.txt')

    # Show when the merge date of the MR we processed last run
    last_mr_date = working_branch.get_latest_mr_date()
    if last_mr_date:
        print("Latest update date:")

        last_processed_date = dateparser.parse(last_mr_date)
        print("    {} - {}".format(branch, last_processed_date.strftime(DATE_FORMAT)))

    # Fetch new MRs on the branch
    mrs, status_code = working_branch.fetch_new_mrs()

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
    processed_miids = []
    while mrs:
        stalling = True
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

            # Push last update date forward
            latest_update_date = dateparser.parse(working_branch.get_latest_mr_date())
            mr_updated_date = dateparser.parse(merge_request.get("updated_at"))
            if mr_updated_date > latest_update_date:
                working_branch.set_latest_mr_date(merge_request.get("updated_at"))
                stalling = False

            # Check this wasn't already done, too
            if iid in processed_miids: 
                continue
            processed_miids.append(iid)

            # Check if this MR was merged later after our starting point
            if merge_request.get("merged_at") is None:
                continue
            mr_merged_date = dateparser.parse(merge_request.get("merged_at"))
            if mr_merged_date <= initial_latest_mr_date:
                continue

            # Find an author for the CL (this is for fallbacks)
            author = merge_request.get("author")
            user = "somebody"
            if author:
                user = author.get("username")

            # Make the changelog
            print("Parsing MR #{}    {}".format(iid, title))
            print("#{} was last updated {}".format(iid, mr_updated_date.strftime(DATE_FORMAT)))
            changelog = Changelog()
            success = changelog.parse_changelog(merge_request.get("description"))
            mrs_parsed += 1

            # No changelog found :(
            if not success:
                continue

            if not changelog.author:
                changelog.set_author(user) # Fallback to gitlab username as CL author

            # make a YAML file for the changelog
            file_name = "{}-merge_request-{}@{}".format(user, merge_request.get("id"), mr_merged_date.date().strftime("%d-%m-%Y"))
            changelog.dump_yaml(file_name, directory)
            print("Generated changelog for MR #{}    {}".format(iid, file_name))
            cls_generated += 1

        # If we have no newer date, we bump time ahead and pray that someone didn't
        # mass reference a MR and we'd have more than a few dozens updated same second...
        # Look it's best i'll manage with this mess, branch.py needs proper pagination somehow
        if stalling:
            last_update_date = dateparser.parse(working_branch.get_latest_mr_date()) + datetime.timedelta(seconds = 1)
            working_branch.set_latest_mr_date(last_update_date.isoformat())

        # Fetch new MRs to process
        print("Requesting more MRs...")
        mrs, status_code = working_branch.fetch_new_mrs()

    print("--------------------")
    # High quality fluffprint
    print("Parsed {} merge request{}.".format(mrs_parsed, "" if mrs_parsed == 1 else "s"))
    print("{} changelog{} generated.".format(cls_generated, " was" if cls_generated == 1 else "s were"))

    # Save our progress on changelog generation
    working_branch.save_latest_mr_date(str(pid)+'.txt')

if __name__ == "__main__":
    if len(argv) < 4:
        PID = environ["GITLAB_CHANGELOG_PID"]
    else :
        PID = argv[3]

    generate_changelogs(PID, argv[1], argv[2])
