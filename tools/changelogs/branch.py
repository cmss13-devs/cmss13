'''
    branch.py
'''

import re
import requests
import dateutil.parser as dateparser

DEFAULT_DATE = "0001-01-1T00:00:00.000Z"
LIST_MRS_URL = "https://gitlab.com/api/v4/projects/{}/merge_requests?scope=all&sort=asc&target_branch={}&state=merged"

class Branch:
    '''
        Represents a GitLab branch and provides some useful
        functions for retrieving Merge Requests targeting the branch
    '''

    # The project ID of the project this branch belongs to
    pid = -1

    # Name of the branch
    name = ""

    # The date of the latest MR that was processed on this branch
    latest_mr_date = DEFAULT_DATE

    def __init__(self, pid, name):
        self.pid = pid
        self.name = name

    def set_latest_mr_date(self, latest_mr_date):
        '''
            Sets the date of the MR that was most lately processed

            :param latest_mr_date: Update date of the most lately processed MR
        '''

        if not latest_mr_date:
            self.latest_mr_date = DEFAULT_DATE

        self.latest_mr_date = latest_mr_date

    def get_latest_mr_date(self):
        '''
            :return latest mr date: The date of the MR that was processed most lately
        '''

        return self.latest_mr_date

    def fetch_new_mrs(self, pat):
        '''
            Fetches all MRs that were updated after the most lately processed MR

            :param pat: The personal access token to use

            :return mrs: A list of merge requests updated after latest_mr_date
            :return status code: The status code from the GET request
        '''

        # Get all merged MRs on the branch
        get_url = LIST_MRS_URL.format(self.pid, self.name)

        # Only fetch MRs that have been updated after the given date
        if self.latest_mr_date:
            get_url += "&updated_after={}".format(self.latest_mr_date)

        # Get the MRs
        resp = requests.get(get_url, headers={"Private-Token": pat, "Content-Type": "application/json"})
        mrs = resp.json()

        # No MRs were fetched, i.e. there were no new ones
        if not mrs:
            return (mrs, resp.status_code)

        # Request failed
        if resp.status_code != 200:
            return (mrs, resp.status_code)

        # In the very special case that the merge time of the latest MR is the exact same
        # as its update time, the MR that was processed last gets into the list of MRs

        # Usually there's a few milliseconds of delay between the MR updating and the MR
        # being merged, but it is technically possible, so better safe than sorry
        for merge_request in mrs:
            mr_merged_at = merge_request.get("merged_at")
            
            if mr_merged_at is None:
                continue
                       
            latest_date = dateparser.parse(self.latest_mr_date)
            
            mr_merged_date = dateparser.parse(mr_merged_at)

            # If this has happened, remove the troublemaker from the list of MRs
            if latest_date == mr_merged_date:
                mrs.remove(merge_request)

        return (mrs, resp.status_code)

    def load_latest_mr_date(self, file_name):
        '''
            Loads the latest MR date from the given file

            :param file: The file to look for the MR date in
            :return success: Whether or not the latest MR date was loaded
        '''

        mr_date_pattern = re.compile("{};(.*)".format(self.name))

        try:
            file = open(file_name, "r+")

            for line in file.readlines():
                match = mr_date_pattern.search(line)
                if not match.group(0):
                    continue

                self.set_latest_mr_date(match.group(1))
                return True

            file.close()
        except IOError:
            pass

        return False

    def save_latest_mr_date(self, file_name):
        '''
            Saves the latest MR date to the given file

            :param file: The file to save the latest MR date to
        '''

        mr_date_pattern = re.compile("{};(.*)".format(self.name))

        lines = []

        # Write lines to a list of lines
        with open(file_name, "w+") as file:
            found_line = False

            for line in file.readlines():
                match = mr_date_pattern.search(line)

                # Didn't find our branch on this line, so write the original line and move on
                if not match.group(0):
                    lines.append("{}".format(line))
                    continue

                # We found our line, so replace it with the new latest MR date
                found_line = True
                lines.append("{};{}".format(self.name, self.latest_mr_date))
            
            if not found_line:
                # We didn't find a line for the branch, so append one
                lines.append("{};{}".format(self.name, self.latest_mr_date))

            # Then write the lines back into the file
            file.seek(0)
            file.write('\n'.join(lines))
