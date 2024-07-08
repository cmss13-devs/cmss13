from typing import Optional

class MaplintError(Exception):
    """Linting error with associated filename and line number."""

    file_name = "unknown"
    """The DMM file name the exception occurred in"""

    line_number = 1
    """The line the error occurred on"""

    coordinates: Optional[str] = None
    """The optional coordinates"""

    pop_id: Optional[str] = None
    """The optional pop ID"""

    help: Optional[str] = None
    """The optional help message"""

    dm_suggestion: Optional[str] = None
    """The optional dm code suggestion"""

    path_suggestion: Optional[str] = None
    """The optional UpdatePaths suggestion"""

    def __init__(self, message: str, file_name: str, line_number = 1, dm_suggestion = "", path_suggestion = ""):
        Exception.__init__(self, message)

        self.file_name = file_name
        self.line_number = line_number
        self.dm_suggestion = dm_suggestion
        self.path_suggestion = path_suggestion

class MapParseError(Exception):
    """A parsing error that must be upgrading to a linting error by parse()."""
    pass
