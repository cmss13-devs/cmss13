GLOBAL_LIST_EMPTY(admin_ranks) //list of all admin_rank datums
GLOBAL_PROTECT(admin_ranks)

/datum/entity/admin_rank
	var/rank = "NoRank"
	var/rights = R_DEFAULT

BSQL_PROTECT_DATUM(/datum/entity/admin_rank)

/datum/entity_meta/admin_rank
	entity_type = /datum/entity/admin_rank
	table_name = "admin_ranks"
	field_types = list(
		"rank" = DB_FIELDTYPE_STRING_MEDIUM,
		"rights" = DB_FIELDTYPE_STRING_MAX,
	)

/datum/entity_meta/admin_rank/map(datum/entity/admin_rank/rank, list/values)
	..()
	if(values["rights"])
		rank.rights = rights2flags(values["rights"])

/datum/entity_meta/admin_rank/unmap(datum/entity/admin_rank/rank)
	. = ..()
	if(length(rank.rights))
		.["rights"] = flags2rights(rank.rights)

/proc/rights2flags(text_rights)
	var/rights = NO_FLAGS
	var/list/list_rights = splittext(text_rights, "|")
	for(var/right in list_rights)
		switch(right)
			if("buildmode")
				rights |= R_BUILDMODE
			if("admin")
				rights |= R_ADMIN
			if("ban")
				rights |= R_BAN
			if("server")
				rights |= R_SERVER
			if("debug")
				rights |= R_DEBUG
			if("permissions")
				rights |= R_PERMISSIONS
			if("possess")
				rights |= R_POSSESS
			if("stealth")
				rights |= R_STEALTH
			if("color")
				rights |= R_COLOR
			if("varedit")
				rights |= R_VAREDIT
			if("event")
				rights |= R_EVENT
			if("sounds")
				rights |= R_SOUNDS
			if("nolock")
				rights |= R_NOLOCK
			if("spawn")
				rights |= R_SPAWN
			if("mod")
				rights |= R_MOD
			if("mentor")
				rights |= R_MENTOR
			if("profiler")
				rights |= R_PROFILER
			if("host")
				rights |= RL_HOST
			if("everything")
				rights |= RL_EVERYTHING
	return rights

/proc/flags2rights(rights)
	var/text_rights = ""
	if(rights & R_BUILDMODE)
		text_rights += "build|"
	if(rights & R_ADMIN)
		text_rights += "admin|"
	if(rights & R_BAN)
		text_rights += "ban|"
	if(rights & R_SERVER)
		text_rights += "server|"
	if(rights & R_DEBUG)
		text_rights += "debug|"
	if(rights & R_PERMISSIONS)
		text_rights += "permissions|"
	if(rights & R_POSSESS)
		text_rights += "possess|"
	if(rights & R_STEALTH)
		text_rights += "stealth|"
	if(rights & R_COLOR)
		text_rights += "color|"
	if(rights & R_VAREDIT)
		text_rights += "varedit|"
	if(rights & R_EVENT)
		text_rights += "event|"
	if(rights & R_SOUNDS)
		text_rights += "sounds|"
	if(rights & R_NOLOCK)
		text_rights += "nolock|"
	if(rights & R_SPAWN)
		text_rights += "spawn|"
	if(rights & R_MOD)
		text_rights += "mod|"
	if(rights & R_MENTOR)
		text_rights += "mentor|"
	if(rights & R_PROFILER)
		text_rights += "profiler|"
	if(rights & RL_HOST)
		text_rights += "host|"
	if(rights & RL_EVERYTHING)
		text_rights += "everything|"
	return text_rights
