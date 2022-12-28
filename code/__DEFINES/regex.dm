/*
	REGEX System Ported from Aurorastation, includes chat-markup like bolding and italicizing, as well as converting urls into actual clickable url elements.area
*/

// Global REGEX datums for regular use without recompiling

// The lazy URL finder. Lazy in that it matches the bare minimum
// Replicates BYOND's own URL parser in functionality.
GLOBAL_DATUM_INIT(url_find_lazy, /regex, regex(@"((https?|byond):\/\/[^\s]*)", "g"))
// REGEX datums used for process_chat_markup.
GLOBAL_DATUM_INIT(markup_bold, /regex, regex("((\\W|^)\\*)(\[^\\*\]*)(\\*(\\W|$))", "g"))
GLOBAL_DATUM_INIT(markup_italics, /regex, regex("((\\W|^)\\/)(\[^\\/\]*)(\\/(\\W|$))", "g"))
GLOBAL_DATUM_INIT(markup_strike, /regex, regex("((\\W|^)\\~)(\[^\\~\]*)(\\~(\\W|$))", "g"))
GLOBAL_DATUM_INIT(markup_underline, /regex, regex("((\\W|^)\\_)(\[^\\_\]*)(\\_(\\W|$))", "g"))

// Global list for mark-up REGEX datums.
// Initialized in the hook, to avoid passing by null value.
GLOBAL_LIST_EMPTY(markup_regex)

// Global list for mark-up REGEX tag collection.
GLOBAL_LIST_INIT(markup_tags, list(
						"/" = list("<i>", "</i>"),
						"*" = list("<b>", "</b>"),
						"~" = list("<strike>", "</strike>"),
						"_" = list("<u>", "</u>")))

/proc/initialize_global_regex()
	// List needs to be initialized here, due to DM mixing and matching pass-by-value and -reference as it chooses.
	GLOB.markup_regex = list(
						"/" = GLOB.markup_italics,
						"*" = GLOB.markup_bold,
						"~" = GLOB.markup_strike,
						"_" = GLOB.markup_underline)

	return 1
