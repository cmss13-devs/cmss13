'''
    changelog.py
'''

import re

# Valid change types
VALID_CL_TYPES = (
    "bugfix",
    "wip",
    "tweak",
    "soundadd",
    "sounddel",
    "rscadd",
    "rscdel",
    "imageadd",
    "imagedel",
    "maptweak",
    "spellcheck",
    "experiment"
)

# CL regexps
CL_REGEX_START = re.compile(r':cl:\s*([a-zA-Z0-9_\s\+\-@\(\)\",]{1,64})?')
CL_REGEX_ENTRY = re.compile(r'\s*(\w+):\s*(.+)')
CL_REGEX_END = re.compile(r'\/:cl:')

CL_REGEX_COMMENT_START = re.compile(r'<!--')
CL_REGEX_COMMENT_END = re.compile(r'-->')

class Changelog:
    '''
        Holds a full changelog
    '''

    def __init__(self):
        # The author of the changelog
        self.author = None
        # Changes in this changelog, stored as a list of dictionaries
        self.changes = []

    # set the author of the changelog
    def set_author(self, author):
        '''
            Sets the author of the changelog

            :param author: The new author of the changelog
        '''

        self.author = author

    def get_author(self):
        '''
            :return author: The author of this changelog
        '''

        return self.author

    def add_change(self, change_type, log):
        '''
            Adds a new change to the changelog

            :param change_type: The type of the change
            :param log: The log message
        '''

        if change_type in VALID_CL_TYPES:
            # escape quotes
            safe_log = log.replace("\"", "\\\"")
            self.changes.append({"type": change_type, "log": safe_log})

    def parse_changelog(self, it):
        '''
            Parses a text for a changelog

            :param data: The text to parse
            :return success: Whether or not the text was succesfully parsed into a changelog
        '''

        in_cl = False
        in_comment = False

        try:
            while True:
                line = next(it)

                # Don't parse comments
                if in_comment:
                    end_comment_match = CL_REGEX_COMMENT_END.search(line)
                    if not end_comment_match:
                        continue
                    in_comment = False

                comment_match = CL_REGEX_COMMENT_START.search(line)
                if comment_match:
                    end_comment_match = CL_REGEX_COMMENT_END.search(line)
                    if not end_comment_match:
                        in_comment = True
                    continue

                # Look for the start of the changelog
                if not in_cl:
                    cl_start_match = CL_REGEX_START.search(line)
                    if not cl_start_match:
                        continue

                    in_cl = True
                    if cl_start_match.group(1):
                        # The author is captured first by the regex
                        self.author = cl_start_match.group(1)
                else:
                    # This might be the end of the changelog
                    cl_end_match = CL_REGEX_END.search(line)
                    if cl_end_match and cl_end_match.group(0):
                        return True

                    cl_entry_match = CL_REGEX_ENTRY.search(line)
                    if cl_entry_match:
                        # The first capture group contains the changelog type
                        # The second capture contains the log message
                        match_groups = (cl_entry_match.group(1), cl_entry_match.group(2))
                        if(match_groups[0] and match_groups[1]):
                            # Add the change to the changelog
                            self.add_change(match_groups[0], match_groups[1])
        except StopIteration:
            pass
        return False


    def dump_yaml(self, file_name, directory = ""):
        '''
            Writes the changelog to a YAML file

            :param file_name: The name the changelog file should be given
            :param directory: The directory to store the file in.
        '''

        if not self.changes:
            return

        with open("{}{}.yml".format(directory, file_name), "w+") as file:
            data = "author: \'{}\'\ndelete-after: true\nchanges:\n{}"
            change_data = ""

            for change in self.changes:
                escaped = change["log"]
                escaped = escaped.replace("'", "''")
                change_data += "  - {}: \'{}\'\n".format(change["type"], escaped)

            file.write(data.format(self.author, change_data))
