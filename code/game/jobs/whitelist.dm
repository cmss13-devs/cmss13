#define WHITELISTFILE "data/whitelist.txt"

GLOBAL_LIST_FILE_LOAD(whitelist, WHITELISTFILE)

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!CONFIG_GET(flag/usewhitelist) || !GLOB.whitelist)
		return 0
	return ("[M.ckey]" in GLOB.whitelist)

/proc/can_play_special_job(var/client/client, var/job)
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
/proc/is_alien_whitelisted(mob/M, var/species)
	if(!CONFIG_GET(flag/usealienwhitelist)) //If there's not config to use the whitelist.
		return 1
	if(species == "human" || species == "Human")
		return 1
//	if(check_rights(R_ADMIN, 0)) //Admins are not automatically considered to be whitelisted anymore. ~N
//		return 1				//This actually screwed up a bunch of procs, but I only noticed it with the wrong spawn point.
	if(!CONFIG_GET(flag/usealienwhitelist) || !GLOB.alien_whitelist)
		return 0
	if(M && species)
		for (var/s in GLOB.alien_whitelist)
			if(findtext(lowertext(s),"[lowertext(M.key)] - [species]"))
				return 1
			//if(findtext(lowertext(s),"[lowertext(M.key)] - [species] Elder")) //Unnecessary.
			//	return 1
			if(findtext(lowertext(s),"[lowertext(M.key)] - All"))
				return 1
	return 0

#undef WHITELISTFILE
