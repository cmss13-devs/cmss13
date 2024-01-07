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
		var/datum/caste_datum/C = GLOB.RoleAuthority.castes_by_name[XENO_CASTE_QUEEN]
		return C.can_play_caste(client)
	if(job == JOB_SURVIVOR)
		var/datum/job/J = GLOB.RoleAuthority.roles_by_path[/datum/job/civilian/survivor]
		return J.can_play_role(client)
	return TRUE

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
