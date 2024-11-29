
GLOBAL_LIST_INIT_TYPED(admin_ranks_by_id, /datum/view_record/admin_rank, list())
GLOBAL_PROTECT(admin_ranks_by_id)

GLOBAL_LIST_INIT_TYPED(admin_ranks, /datum/view_record/admin_rank, load_ranks())
GLOBAL_PROTECT(admin_ranks)

GLOBAL_LIST_INIT_TYPED(db_admin_datums, /datum/view_record/admin_holder, load_admins())
GLOBAL_PROTECT(db_admin_datums)

/proc/load_ranks()
	WAIT_DB_READY
	var/list/named_ranks = list()
	var/list/datum/view_record/admin_rank/ranks = DB_VIEW(/datum/view_record/admin_rank)
	for(var/datum/view_record/admin_rank/rank as anything in ranks)
		named_ranks[rank.rank_name] = rank
		GLOB.admin_ranks_by_id["[rank.id]"] = rank
	return named_ranks

/proc/load_admins()
	WAIT_DB_READY
	var/list/ckeyed_admins = list()
	var/list/datum/view_record/admin_holder/admins = DB_VIEW(/datum/view_record/admin_holder)
	var/list/datum/admins/existing_admins = GLOB.admin_datums
	for(var/admin_ckey in existing_admins)
		existing_admins[admin_ckey].disassociate()

	GLOB.admin_datums = list()
	for(var/datum/view_record/admin_holder/admin as anything in admins)
		ckeyed_admins[admin.ckey] = admin
		var/datum/admins/admin_holder = existing_admins[admin.ckey]
		existing_admins -= admin.ckey
		if(!admin_holder)
			admin_holder = new /datum/admins(admin.ckey)
		else
			GLOB.admin_datums[admin.ckey] = admin_holder

		if(GLOB.directory[admin.ckey])
			admin_holder.associate(GLOB.directory[admin.ckey], admin)

	QDEL_NULL_LIST(existing_admins)
	return ckeyed_admins

BSQL_PROTECT_DATUM(/datum/admins)

/datum/entity/admin_rank
	var/rank_name
	var/text_rights
	var/rights = NO_FLAGS

BSQL_PROTECT_DATUM(/datum/entity/admin_rank)

/datum/entity_meta/admin_rank
	entity_type = /datum/entity/admin_rank
	table_name = "admin_ranks"
	field_types = list(
		"rank_name" = DB_FIELDTYPE_STRING_MEDIUM,
		"text_rights" = DB_FIELDTYPE_STRING_MAX,
	)

/datum/entity_meta/admin_rank/map(datum/entity/admin_rank/rank, list/values)
	..()
	if(values["text_rights"])
		rank.rights = rights2flags(values["text_rights"])

/datum/entity_meta/admin_rank/unmap(datum/entity/admin_rank/rank)
	. = ..()
	if(length(rank.rights))
		.["text_rights"] = flags2rights(rank.rights)

/datum/view_record/admin_rank
	var/rank_name
	var/text_rights
	var/rights = NO_FLAGS

BSQL_PROTECT_DATUM(/datum/view_record/admin_rank)

/datum/entity_view_meta/admin_rank
	root_record_type = /datum/entity/admin_rank
	destination_entity = /datum/view_record/admin_rank
	fields = list(
		"rank_name",
		"text_rights",
	)

/datum/entity_view_meta/admin_rank/map(datum/view_record/admin_rank/rank, list/values)
	..()
	if(values["text_rights"])
		rank.rights = rights2flags(values["text_rights"])

/datum/entity/admin_holder
	var/player_id
	var/rank_id
	var/extra_titles_encoded
	var/list/extra_titles
	var/list/rank_ids_extra

BSQL_PROTECT_DATUM(/datum/entity/admin_holder)

/datum/entity_meta/admin_holder
	entity_type = /datum/entity/admin_holder
	table_name = "admins"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"rank_id" = DB_FIELDTYPE_BIGINT,
		"extra_titles_encoded" = DB_FIELDTYPE_STRING_MAX,
	)

/datum/entity_meta/admin_holder/map(datum/entity/admin_holder/admin, list/values)
	..()
	if(values["extra_titles_encoded"])
		admin.rank_ids_extra = json_decode(values["extra_titles_encoded"])
		for(var/rank_id as anything in admin.rank_ids_extra)
			var/datum/view_record/admin_rank/admin_rank = SAFEPICK(DB_VIEW(/datum/view_record/admin_rank, DB_COMP("id", DB_EQUALS, text2num(rank_id))))
			if(!admin_rank)
				continue
			admin.extra_titles += admin_rank.rank_name

/datum/entity_meta/admin_holder/unmap(datum/entity/admin_holder/admin)
	. = ..()
	if(length(admin.rank_ids_extra))
		.["extra_titles_encoded"] = json_encode(admin.rank_ids_extra)

/datum/entity_link/player_to_admin_holder
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/admin_holder
	child_field = "player_id"

	parent_name = "player"
	child_name = "admin_holder"

/datum/entity_link/admin_rank_to_admin_holder
	parent_entity = /datum/entity/admin_rank
	child_entity = /datum/entity/admin_holder
	child_field = "rank_id"

	parent_name = "admin_rank"
	child_name = "admin_holder"

/datum/view_record/admin_holder
	var/player_id
	var/rank_id
	var/extra_titles_encoded
	var/ckey

	var/list/extra_titles = list()
	var/rank_name
	var/datum/view_record/admin_rank/admin_rank
	var/list/ref_vars

BSQL_PROTECT_DATUM(/datum/view_record/admin_holder)

/datum/entity_view_meta/admin_holder
	root_record_type = /datum/entity/admin_holder
	destination_entity = /datum/view_record/admin_holder
	fields = list(
		"player_id",
		"rank_id",
		"extra_titles_encoded",
		"ckey" = "player.ckey",
		"rank_name" = "admin_rank.rank_name",
	)

/datum/entity_view_meta/admin_holder/map(datum/view_record/admin_holder/admin, list/values)
	..()
	admin.admin_rank = GLOB.admin_ranks[admin.rank_name]
	if(values["extra_titles_encoded"])
		var/list/decoded = json_decode(values["extra_titles_encoded"])
		if(length(decoded))
			for(var/srank in decoded)
				admin.extra_titles += srank

	if(admin.ref_vars && admin.admin_rank)
		admin.ref_vars["rank"] = admin.admin_rank.rank_name
		admin.ref_vars["rights"] = admin.admin_rank.rights

/datum/entity_view_meta/admin_holder/vv_edit_var(var_name, var_value)
	return FALSE

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

/client/proc/check_localhost_admin_datum()
	set waitfor = FALSE
	UNTIL(player_data)
	if(admin_holder)
		return

	var/list/return_value = list()
	DB_FILTER(/datum/entity/admin_rank, DB_COMP("rank_name", DB_EQUALS, "!localhost!"), CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(localhost_rank_check), return_value))
	UNTIL(length(return_value))
	var/datum/entity/admin_rank/rank = return_value[1]
	if(!rank.id)
		return

	return_value.Cut()
	DB_FILTER(/datum/entity/admin_holder, DB_COMP("player_id", DB_EQUALS, player_data.id), CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(localhost_entity_check), player_data.id, rank.id, return_value))
	UNTIL(length(return_value))
	if(admin_holder)
		return

	sleep(5 SECONDS)// If you do it too fast, you will fuck yourself, or gain aorta rupture
	GLOB.admin_ranks = load_ranks()
	GLOB.db_admin_datums = load_admins()

/proc/localhost_rank_check(list/return_value, list/datum/entity/admin_rank/ranks)
	var/datum/entity/admin_rank/rank
	if(!length(ranks))
		rank = DB_ENTITY(/datum/entity/admin_rank)
		rank.rank_name = "!localhost!"
		rank.rights = RL_HOST
		rank.text_rights = "host"
		rank.save()
		rank.sync()
	else
		rank = ranks[length(ranks)]

	return_value += rank

/proc/localhost_entity_check(localhost_id, rank_id, list/return_value, list/datum/entity/admin_holder/admins)
	var/datum/entity/admin_holder/admin
	if(!length(admins))
		admin = DB_ENTITY(/datum/entity/admin_holder)
		admin.player_id = localhost_id
		admin.rank_id = rank_id
		admin.save()
	else
		admin = admins[length(admins)]

	return_value += admin

/datum/admins/New(ckey)
	if(!ckey)
		error("Admin datum created without a ckey argument. Datum has been deleted")
		qdel(src)
		return

	href_token = GenerateToken()
	GLOB.admin_datums[ckey] = src

/client/proc/deadmin()
	if(IsAdminAdvancedProcCall())
		alert_proccall("deadmin")
		return PROC_BLOCKED
	if(admin_holder)
		admin_holder.disassociate()
	return TRUE

/client/proc/readmin()
	if(GLOB.admin_datums[ckey])
		GLOB.admin_datums[ckey].associate(src, GLOB.db_admin_datums[ckey])
	return TRUE
