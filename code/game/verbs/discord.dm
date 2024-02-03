/client/verb/discord_connect()
	set name = "Discord Certify"
	set category = "OOC"

	var/total_playtime = get_total_xeno_playtime(skip_cache = TRUE) + get_total_human_playtime(skip_cache = TRUE)

	if(total_playtime < CONFIG_GET(number/certification_minutes))
		to_chat(src, SPAN_ALERTWARNING("You don't have enough minutes - [CONFIG_GET(number/certification_minutes) - total_playtime] remaining."))
		return

	if(!player_data)
		load_player_data()

	if(player_data.discord_link)
		to_chat(src, SPAN_ALERTWARNING("You already have a linked Discord. Ask an Admin to remove it."))
		return

	var/datum/view_record/discord_identifier/ident = locate() in DB_VIEW(/datum/view_record/discord_identifier, DB_AND(
		DB_COMP("playerid", DB_EQUALS, player_data.id),
		DB_COMP("realtime", DB_GREATER, world.realtime - 4 HOURS),
		DB_COMP("used", DB_EQUALS, FALSE)
		))

	if(ident)
		to_chat(src, SPAN_ALERTWARNING("Existing verification within expiry. Opening pop-up."))
		show_browser(src, "Your one time password is [ident.identifier]. Please use [CONFIG_GET(string/bot_prefix)][CONFIG_GET(string/bot_command)] [ident.identifier] to certify.", "One Time Password", "one-time-pass")
		return

	var/datum/entity/discord_identifier/new_identifier = DB_ENTITY(/datum/entity/discord_identifier)

	var/not_unique = TRUE
	var/long_list = GLOB.operation_postfixes + GLOB.operation_prefixes + GLOB.operation_titles
	var/token

	while(not_unique)
		token = replacetext(trim("[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]"), " ", "")
		not_unique = locate(/datum/view_record/discord_identifier) in DB_VIEW(/datum/view_record/discord_identifier, DB_COMP("identifier", DB_EQUALS, token))

	new_identifier.identifier = token
	new_identifier.playerid = player_data.id
	new_identifier.save()

	show_browser(src, "Your one time password is [token]. Please use [CONFIG_GET(string/bot_prefix)][CONFIG_GET(string/bot_command)] [token] to certify.", "One Time Password", "one-time-pass")
