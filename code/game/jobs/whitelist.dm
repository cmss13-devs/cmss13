#define WHITELISTFILE "data/whitelist.txt"

GLOBAL_LIST_FILE_LOAD(whitelist, WHITELISTFILE)

/proc/check_whitelist(mob/M /*, rank*/)
	if(!CONFIG_GET(flag/usewhitelist) || !GLOB.whitelist)
		return 0
	return ("[M.ckey]" in GLOB.whitelist)

/proc/can_play_special_job(client/client, job)
	if(client.admin_holder && (client.admin_holder.rights & R_ADMIN))
		return TRUE
	if(job == XENO_CASTE_QUEEN)
		var/datum/caste_datum/C = RoleAuthority.castes_by_name[XENO_CASTE_QUEEN]
		return C.can_play_caste(client)
	if(job == JOB_SURVIVOR)
		var/datum/job/J = RoleAuthority.roles_by_path[/datum/job/civilian/survivor]
		return J.can_play_role(client)
	return TRUE

GLOBAL_LIST_FILE_LOAD(alien_whitelist, "config/alienwhitelist.txt")

//todo: admin aliens
/proc/is_alien_whitelisted(mob/M, species)
	if(!CONFIG_GET(flag/usealienwhitelist)) //If there's not config to use the whitelist.
		return 1
	if(species == "human" || species == "Human")
		return 1
// if(check_rights(R_ADMIN, 0)) //Admins are not automatically considered to be whitelisted anymore. ~N
// return 1 //This actually screwed up a bunch of procs, but I only noticed it with the wrong spawn point.
	if(!CONFIG_GET(flag/usealienwhitelist) || !GLOB.alien_whitelist)
		return 0
	if(M && species)
		for (var/s in GLOB.alien_whitelist)
			if(findtext(lowertext(s),"[lowertext(M.key)] - [species]"))
				return 1
			//if(findtext(lowertext(s),"[lowertext(M.key)] - [species] Elder")) //Unnecessary.
			// return 1
			if(findtext(lowertext(s),"[lowertext(M.key)] - All"))
				return 1
	return 0

/// returns a list of strings containing the whitelists held by a specific ckey
/proc/get_whitelisted_roles(ckey)
	var/datum/entity/player/player = get_player_from_key(ckey)
	if(player.check_whitelist_status(WHITELIST_YAUTJA))
		LAZYADD(., "predator")
	if(player.check_whitelist_status(WHITELIST_COMMANDER))
		LAZYADD(., "commander")
	if(player.check_whitelist_status(WHITELIST_SYNTHETIC))
		LAZYADD(., "synthetic")

/client/proc/whitelist_panel()
	set name = "Whitelist Panel"
	set category = "Admin.Panels"

	var/data = "<hr><b>Whitelists:</b> <a href='?src=\ref[src];[HrefToken()];change_whitelist=[TRUE]'>Add Whitelist</a> <hr><table border=1 rules=all frame=void cellspacing=0 cellpadding=3>"

	var/list/datum/view_record/players/players_view = DB_VIEW(/datum/view_record/players, DB_COMP("whitelist_status", DB_NOTEQUAL, ""))

	for(var/datum/view_record/players/whitelistee in players_view)
		data += "<tr><td> <a href='?src=\ref[src];[HrefToken()];change_whitelist=[whitelistee.ckey]'>(CHANGE)</a> Key: <b>[whitelistee.ckey]</b></td> <td>Whitelists: [whitelistee.whitelist_status]</td></tr>"

	data += "</table>"

	show_browser(usr, data, "Whitelist Panel", "whitelist_panel", "size=857x400")

/client/load_player_data_info(datum/entity/player/player)
	. = ..()

	if(WHITELISTS_LEADER & player.whitelist_flags)
		add_verb(src, /client/proc/whitelist_panel)

#undef WHITELISTFILE
