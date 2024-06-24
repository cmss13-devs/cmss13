
//Removes a few problematic characters
/proc/sanitize_simple(text, list/repl_chars = list("\n"=" ","\t"=" ","�"=" "))
	for(var/char in repl_chars)
		text = replacetext_char(text, char, repl_chars[char])
	return text

/proc/readd_quotes(text)
	var/list/repl_chars = list("&#34;" = "\"", "&#39;" = "'")
	for(var/char in repl_chars)
		text = replacetext_char(text, char, repl_chars[char])
	return text

//Runs sanitize and strip_html_simple
//I believe strip_html_simple() is required to run first to prevent '<' from displaying as '&lt;' after sanitize() calls byond's html_encode()
/proc/strip_html(text, limit=MAX_MESSAGE_LEN)
	return copytext_char((sanitize(strip_html_simple(text))), 1, limit)

//Runs byond's sanitization proc along-side strip_html_simple
//I believe strip_html_simple() is required to run first to prevent '<' from displaying as '&lt;' that html_encode() would cause
/proc/adminscrub(text, limit=MAX_MESSAGE_LEN)
	return copytext_char((html_encode(strip_html_simple(text))), 1, limit)

//Returns a string with the first element of the string capitalized.
/proc/capitalize(t as text)
	return uppertext(copytext_char(t, 1, 2)) + copytext_char(t, 2)

/proc/strip_improper(input_text)
	return replacetext_char(replacetext_char(input_text, "\proper", ""), "\improper", "")
