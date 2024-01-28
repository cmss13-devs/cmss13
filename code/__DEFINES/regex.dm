/*
	REGEX System Ported from Aurorastation, includes chat-markup like bolding and italicizing, as well as converting urls into actual clickable url elements.area
*/

// Global REGEX datums for regular use without recompiling

// The lazy URL finder. Lazy in that it matches the bare minimum
// Replicates BYOND's own URL parser in functionality.
GLOBAL_DATUM(url_find_lazy, /regex)

// REGEX datums used for process_chat_markup.
GLOBAL_DATUM(markup_bold, /regex)
GLOBAL_DATUM(markup_italics, /regex)
GLOBAL_DATUM(markup_strike, /regex)
GLOBAL_DATUM(markup_underline, /regex)

// Global list for mark-up REGEX datums.
// Initialized in the hook, to avoid passing by null value.
GLOBAL_LIST_EMPTY(markup_regex)

// Global list for mark-up REGEX tag collection.
GLOBAL_LIST_INIT(markup_tags, list("/" = list("<i>", "</i>"),
						"*" = list("<b>", "</b>"),
						"~" = list("<strike>", "</strike>"),
						"_" = list("<u>", "</u>")))

/proc/initialize_global_regex()
	GLOB.url_find_lazy = new(@"((https?|byond):\/\/[^\s]*)", "g")

	GLOB.markup_bold = new("((\\W|^)\\*)(\[^\\*\]*)(\\*(\\W|$))", "g")
	GLOB.markup_italics = new("((\\W|^)\\/)(\[^\\/\]*)(\\/(\\W|$))", "g")
	GLOB.markup_strike = new("((\\W|^)\\~)(\[^\\~\]*)(\\~(\\W|$))", "g")
	GLOB.markup_underline = new("((\\W|^)\\_)(\[^\\_\]*)(\\_(\\W|$))", "g")

	// List needs to be initialized here, due to DM mixing and matching pass-by-value and -reference as it chooses.
	GLOB.markup_regex = list(
		"/" = GLOB.markup_italics,
		"*" = GLOB.markup_bold,
		"~" = GLOB.markup_strike,
		"_" = GLOB.markup_underline,
	)

	return 1

GLOBAL_DATUM_INIT(is_color, /regex, regex("^#\[0-9a-fA-F]{6}$"))

#define REGEX_FLAG_GLOBAL "g"
#define REGEX_FLAG_INSENSITIVE "i"
