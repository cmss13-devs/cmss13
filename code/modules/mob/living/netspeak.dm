GLOBAL_LIST_INIT(netspeak_replacements, list(
	// ===== EMOTE REPLACEMENTS =====
	// These trigger character animations and visual effects
	// Format: "trigger" = list("type" = "action", "emote" = "emote_key")

	"lol" = list("type" = "action", "emote" = "laugh"),
	"lmao" = list("type" = "action", "emote" = "laugh"),
	"rofl" = list("type" = "action", "emote" = "laugh"),
	"idk" = list("type" = "action", "emote" = "shrug"),
	"o7" = list("type" = "action", "emote" = "salute"),

	// Shortcuts, (not really netspeak but useful)
	"www" = list("type" = "action", "emote" = "warcry"),

	// ===== TEXT REPLACEMENTS =====
	// These convert netspeak into proper language
	// Format: "trigger" = list("type" = "text", "replacement" = "proper_text")

	"tbh" = list("type" = "text", "replacement" = "to be honest"),
	"ngl" = list("type" = "text", "replacement" = "not gonna lie"),
	"omg" = list("type" = "text", "replacement" = "oh my god"),
	"omfg" = list("type" = "text", "replacement" = "oh my fucking god"),
	"wtf" = list("type" = "text", "replacement" = "what the fuck"),
	"brb" = list("type" = "text", "replacement" = "be right back"),
	"gtg" = list("type" = "text", "replacement" = "got to go"),
	"ttyl" = list("type" = "text", "replacement" = "talk to you later"),
	"btw" = list("type" = "text", "replacement" = "by the way"),
	"imo" = list("type" = "text", "replacement" = "in my opinion"),
	"imho" = list("type" = "text", "replacement" = "in my honest opinion"),
	"rn" = list("type" = "text", "replacement" = "right now"),
	"nvm" = list("type" = "text", "replacement" = "never mind"),
	"fyi" = list("type" = "text", "replacement" = "for your information"),
	"gg" = list("type" = "text", "replacement" = "good game"),
	"wp" = list("type" = "text", "replacement" = "well played"),
	"ez" = list("type" = "text", "replacement" = "easy"),
	"ty" = list("type" = "text", "replacement" = "thank you"),
	"tysm" = list("type" = "text", "replacement" = "thank you so much"),
	"thx" = list("type" = "text", "replacement" = "thanks"),
	"yw" = list("type" = "text", "replacement" = "you're welcome"),
	"np" = list("type" = "text", "replacement" = "no problem"),
	"ofc" = list("type" = "text", "replacement" = "of course"),
	"pls" = list("type" = "text", "replacement" = "please"),
	"plz" = list("type" = "text", "replacement" = "please"),
	"idc" = list("type" = "text", "replacement" = "I don't care"),
	"ikr" = list("type" = "text", "replacement" = "I know, right"),
	"tfw" = list("type" = "text", "replacement" = "that feeling when"),
	"mfw" = list("type" = "text", "replacement" = "my face when"),
	"ngl" = list("type" = "text", "replacement" = "not gonna lie"),
	"fr" = list("type" = "text", "replacement" = "for real"),
	"rip" = list("type" = "text", "replacement" = "rest in peace"),
	"tho" = list("type" = "text", "replacement" = "though"),
	"wym" = list("type" = "text", "replacement" = "what you mean"),
	"wdym" = list("type" = "text", "replacement" = "what do you mean"),
	"nvm" = list("type" = "text", "replacement" = "never mind"),
	"bc" = list("type" = "text", "replacement" = "because"),
	"cuz" = list("type" = "text", "replacement" = "because"),
	"tf" = list("type" = "text", "replacement" = "the fuck"),
	"lmk" = list("type" = "text", "replacement" = "let me know"),
	"hru" = list("type" = "text", "replacement" = "how are you"),
	"wyd" = list("type" = "text", "replacement" = "what are you doing"),
	"ez" = list("type" = "text", "replacement" = "easy"),
	"l8r" = list("type" = "text", "replacement" = "later"),
	"ttyl" = list("type" = "text", "replacement" = "talk to you later"),
	"omw" = list("type" = "text", "replacement" = "on my way"),
	"b4" = list("type" = "text", "replacement" = "before"),
))

/// Replace netspeak in a message with proper language or an emote
/proc/replace_netspeak(message, mob/user, mob_type)
	var/list/words = splittext(message, " ")
	var/list/replaced_words = list()
	var/did_emote = FALSE

	for(var/word in words)
		var/lword = lowertext(word)

		var/punctuation = ""
		var/after_punctuation = ""

		var/punct_pos = findtext(lword, ",") || findtext(lword, ".") || findtext(lword, "!") || findtext(lword, "?")
		if(punct_pos)
			punctuation = copytext(lword, punct_pos, punct_pos + 1)
			after_punctuation = copytext(lword, punct_pos + 1)
			lword = copytext(lword, 1, punct_pos)
		else if(length(lword) > 0)
			var/last_char = copytext(lword, length(lword))
			if(last_char in list("!", "?", ".", ","))
				punctuation = last_char
				lword = copytext(lword, 1, length(lword))

		var/clean_word = lword

		if(GLOB.netspeak_replacements[clean_word])
			var/list/replacement_data = GLOB.netspeak_replacements[clean_word]
			if(replacement_data["type"] == "action")
				if (isxeno(user))
					// If the user is a xenomorph, pick a random emote
					var/random_emote = pick("hiss", "growl", "roar")
					user.emote(random_emote, intentional = TRUE)
				else
					user.emote(replacement_data["emote"], intentional = TRUE)
				did_emote = TRUE
				if(after_punctuation != "")
					replaced_words += "[punctuation][after_punctuation]"
				continue
			else // "text" type
				replaced_words += "[replacement_data["replacement"]][punctuation][after_punctuation]"
		else
			replaced_words += word

	if(did_emote && !length(replaced_words))
		return null

	return capitalize(jointext(replaced_words, " "))
