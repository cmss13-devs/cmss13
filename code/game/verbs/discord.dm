/client/verb/discord_connect()
	set name = "Discord Certify"
	set category = "OOC"

	var/total_playtime = get_total_xeno_playtime() + get_total_human_playtime()

	if(!total_playtime > CONFIG_GET(number/certification_minutes))
		to_chat(src, SPAN_ALERTWARNING("You don't have enough minutes - [CONFIG_GET(number/certification_minutes) - total_playtime] remaining."))
		return

	if(player_data.discord_id)
		to_chat(src, SPAN_ALERTWARNING("You already have a linked Discord. Ask an Admin to remove it."))
		return

	var/datum/entity/discord_identifier/new_identifier = DB_ENTITY(/datum/entity/discord_identifier)

	var/not_unique = TRUE
	var/token

	var/long_list = operation_postfixes + operation_prefixes + operation_titles
	while(not_unique)
		token = trim("[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]")

		not_unique = DB_EKEY(/datum/entity/discord_identifier, token)

	new_identifier.identifier = token
	new_identifier.playerid = player_data.id
	new_identifier.suspicious = world.IsBanned(ckey, address, computer_id, real_bans_only = TRUE)
	show_browser(src, "Your one time password is [token]. Please use [CONFIG_GET(string/bot_prefix)][CONFIG_GET(string/bot_command)] [token] to certify.")

