// Transitional helper for old style messages
//
// This is PURPOSEDLY a to_chat wrapper, and not SPAN macros,
// so you CAN'T end up shoving result somewhere else,
// as these things use display: block.
//
// This is fringe enough as is, and if you want anything
// specific, just do it properly for your message as a whole.

/proc/to_chat_spaced(target, html, type, text,
		avoid_highlighting = FALSE,
		margin_top = 1, 
		margin_bottom = 1,
		margin_left = 0
)
	if(html)
		html = "<span style='display: block; margin: [margin_top]em 0 [margin_bottom]em [margin_left]em;'>[html]</span>"
	return to_chat(target, html = html, type = type, text = text, avoid_highlighting = avoid_highlighting)