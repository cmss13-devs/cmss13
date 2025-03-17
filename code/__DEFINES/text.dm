/// Prepares a text to be used for maptext. Use this so it doesn't look hideous.
#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}

/// Prepares a text to be used for maptext, using a font that can handle larger text better.
#define MAPTEXT_VCR_OSD_MONO(text) {"<span style='font-family: \"VCR OSD Mono\"'>[##text]</span>"}

/// Macro from Lummox used to get height from a MeasureText proc
#define WXH_TO_HEIGHT(x) text2num(copytext(x, findtextEx(x, "x") + 1))

/// Removes characters incompatible with file names.
#define SANITIZE_FILENAME(text) (GLOB.filename_forbidden_chars.Replace(text, ""))

/// Simply removes the < and > characters, and limits the length of the message.
#define STRIP_HTML_SIMPLE(text, limit) (GLOB.angular_brackets.Replace(copytext(text, 1, limit), ""))

/// defines related to text related procs

#define SHOW_MESSAGE_VISIBLE 1
#define SHOW_MESSAGE_AUDIBLE 2

//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
#define MAX_MESSAGE_LEN 1024
#define MAX_EMOTE_LEN 256
#define MAX_PAPER_MESSAGE_LEN 3072
#define MAX_BOOK_MESSAGE_LEN 9216
#define MAX_NAME_LEN 28

#define MAX_MESSAGE_CHUNKS 20
