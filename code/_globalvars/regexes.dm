//These are a bunch of regex datums for use /((any|every|no|some|head|foot)where(wolf)?\sand\s)+(\.[\.\s]+\s?where\?)?/i
GLOBAL_DATUM_INIT(is_http_protocol, /regex, regex("^https?://"))

//All characters forbidden by filenames: ", \, \n, \t, /, ?, %, *, :, |, <, >, ..
GLOBAL_DATUM_INIT(filename_forbidden_chars, /regex, regex(@{""|[\\\n\t/?%*:|<>]|\.\."}, "g"))
GLOBAL_PROTECT(filename_forbidden_chars)
// had to use the OR operator for quotes instead of putting them in the character class because it breaks the syntax highlighting otherwise.
