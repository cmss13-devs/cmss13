GLOBAL_LIST_INIT_TYPED(admin_ranks, /datum/view_record/admin_rank, load_ranks())
GLOBAL_PROTECT(admin_ranks)

GLOBAL_LIST_INIT_TYPED(admin_datums, /datum/view_record/admin_holder, load_admins())
GLOBAL_PROTECT(admin_datums)

GLOBAL_VAR_INIT(href_token, GenerateToken())
GLOBAL_PROTECT(href_token)

/proc/load_ranks()
	WAIT_DB_READY
	var/list/named_ranks = list()
	var/list/datum/view_record/admin_rank/ranks = DB_VIEW(/datum/view_record/admin_rank)
	for(var/datum/view_record/admin_rank/rank as anything in ranks)
		named_ranks[rank.rank] = rank
	return named_ranks

/proc/load_admins()
	WAIT_DB_READY
	var/list/ckeyed_admins = list()
	var/list/datum/view_record/admin_holder/admins = DB_VIEW(/datum/view_record/admin_holder)
	for(var/datum/view_record/admin_holder/admin as anything in admins)
		ckeyed_admins[admin.ckey] = admin
	return ckeyed_admins

/datum/entity/admin_rank
	var/rank
	var/text_rights
	var/rights = NO_FLAGS

BSQL_PROTECT_DATUM(/datum/entity/admin_rank)

/datum/entity_meta/admin_rank
	entity_type = /datum/entity/admin_rank
	table_name = "admin_ranks"
	field_types = list(
		"rank" = DB_FIELDTYPE_STRING_MEDIUM,
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
	var/rank
	var/text_rights
	var/rights = NO_FLAGS

/datum/entity_view_meta/admin_rank
	root_record_type = /datum/entity/admin_rank
	destination_entity = /datum/view_record/admin_rank
	fields = list(
		"rank",
		"text_rights",
	)

/datum/entity_view_meta/admin_rank/map(datum/view_record/admin_rank/rank, list/values)
	..()
	if(values["text_rights"])
		rank.rights = rights2flags(values["text_rights"])

/datum/entity/admin_holder
	var/admin_id
	var/ckey
	var/rank
	var/extra_titles_encoded
	var/list/extra_titles = list()

BSQL_PROTECT_DATUM(/datum/entity/admin_holder)

/datum/entity_meta/admin_holder
	entity_type = /datum/entity/admin_holder
	table_name = "admins"
	field_types = list(
		"admin_id" = DB_FIELDTYPE_BIGINT,
		"ckey" = DB_FIELDTYPE_STRING_MEDIUM,
		"rank" = DB_FIELDTYPE_STRING_MEDIUM,
		"extra_titles_encoded" = DB_FIELDTYPE_STRING_MAX,
	)

/datum/entity_meta/admin_holder/map(datum/entity/admin_holder/admin, list/values)
	..()
	if(values["extra_titles_encoded"])
		admin.extra_titles = json_decode(values["extra_titles_encoded"])

/datum/entity_meta/admin_holder/unmap(datum/entity/admin_holder/admin)
	. = ..()
	if(length(admin.extra_titles))
		.["extra_titles_encoded"] = json_encode(admin.extra_titles)

/datum/view_record/admin_holder
	var/admin_id
	var/ckey
	var/rank
	var/extra_titles_encoded
	var/list/extra_titles = list()

	var/datum/view_record/admin_rank/admin_rank

	var/client/owner = null
	var/fakekey = null

	var/href_token

	var/datum/marked_datum
	var/list/datum/tagged_datums

	///Whether this admin is invisiminning
	var/invisimined = FALSE

	var/datum/filter_editor/filteriffic
	var/datum/particle_editor/particle_test

/datum/entity_view_meta/admin_holder
	root_record_type = /datum/entity/admin_holder
	destination_entity = /datum/view_record/admin_holder
	fields = list(
		"admin_id",
		"ckey",
		"rank",
		"extra_titles_encoded",
	)

/datum/entity_view_meta/admin_holder/map(datum/view_record/admin_holder/admin, list/values)
	..()
	admin.admin_rank = GLOB.admin_ranks[admin.rank]
	admin.href_token = GenerateToken()
	if(values["extra_titles_encoded"])
		admin.extra_titles = json_decode(values["extra_titles_encoded"])

/datum/view_record/admin_holder/proc/associate(client/admin_client)
	if(istype(admin_client))
		if(rank in GLOB.admin_ranks)
			admin_rank = GLOB.admin_ranks[rank]
		else
			stack_trace("Warning, admins missconfiguration in DB")
		owner = admin_client
		owner.admin_holder = src
		owner.add_admin_verbs()
		owner.tgui_say.load()
		owner.update_special_keybinds()
		GLOB.admins |= admin_client
		if(admin_rank.rights & R_PROFILER)
			if(!world.GetConfig("admin", admin_client.ckey))
				world.SetConfig("APP/admin", admin_client.ckey, "role = coder")

/datum/view_record/admin_holder/proc/disassociate()
	if(owner)
		GLOB.admins -= owner
		owner.remove_admin_verbs()
		owner.admin_holder = null
		owner.tgui_say.load()
		owner.update_special_keybinds()
		owner = null

/proc/check_client_rights(client/admin, rights_required, show_msg = TRUE)
	if(!admin)
		return FALSE

	if(rights_required)
		if(admin.admin_holder)
			if(rights_required & admin.admin_holder.admin_rank.rights)
				return TRUE
			else
				if(show_msg && admin.prefs.show_permission_errors)
					to_chat(admin, SPAN_DANGER("Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required,"")]."))
	else
		if(admin.admin_holder)
			return TRUE
		else
			if(show_msg && admin.prefs.show_permission_errors)
				to_chat(admin, SPAN_DANGER("Error: You are not an admin."))
	return FALSE

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

/proc/admin_proc()
	if(!check_rights(R_ADMIN))
		return
	to_world("you have enough rights!")

NOTE: it checks usr! not src! So if you're checking somebody's rank in a proc which they did not call
you will have to do something like if(client.admin_holder.admin_rank.rights & R_ADMIN) yourself.
*/
/proc/check_rights(rights_required, show_msg=TRUE)
	if(usr && usr.client)
		return check_client_rights(usr.client, rights_required, show_msg)
	return FALSE

/proc/check_other_rights(client/other, rights_required, show_msg = TRUE)
	if(!other)
		return FALSE
	if(rights_required && other.admin_holder?.admin_rank?.rank)
		if(check_client_rights(usr.client, rights_required, show_msg))
			return TRUE
		else if(show_msg)
			to_chat(usr, SPAN_WARNING("You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required," ")]."))
	else
		if(other.admin_holder)
			return TRUE
		else if(show_msg)
			to_chat(usr, SPAN_WARNING("You are not a holder."))
	return FALSE

//probably a bit iffy - will hopefully figure out a better solution
/proc/check_if_greater_rights_than(client/other)
	if(usr && usr.client)
		if(usr.client.admin_holder)
			if(!other || !other.admin_holder)
				return 1
			if(usr.client.admin_holder.admin_rank.rights != other.admin_holder.admin_rank.rights)
				if( (usr.client.admin_holder.admin_rank.rights & other.admin_holder.admin_rank.rights) == other.admin_holder.admin_rank.rights )
					return 1 //we have all the rights they have and more
		to_chat(usr, "<font color='red'>Error: Cannot proceed. They have more or equal rights to us.</font>")
	return 0

/client/proc/deadmin()
	if(IsAdminAdvancedProcCall())
		alert_proccall("deadmin")
		return PROC_BLOCKED
	if(admin_holder)
		admin_holder.disassociate()
	return TRUE

/client/proc/readmin()
	if(admin_holder)
		admin_holder.associate(src)
	return TRUE

/datum/view_record/admin_holder/proc/check_for_rights(rights_required)
	if(rights_required && !(rights_required & admin_rank.rights))
		return FALSE
	return TRUE

/// gets any additional channels for tgui-say (admin & mentor)
/datum/view_record/admin_holder/proc/get_tgui_say_extra_channels()
	var/extra_channels = list()
	if(check_for_rights(R_ADMIN) || check_for_rights(R_MOD))
		extra_channels += ADMIN_CHANNEL
	if(check_for_rights(R_MENTOR))
		extra_channels += MENTOR_CHANNEL
	return extra_channels

/datum/proc/CanProcCall(procname)
	return TRUE

//This proc checks whether subject has at least ONE of the rights specified in rights_required.
/proc/check_rights_for(client/subject, rights_required)
	if(subject?.admin_holder)
		return subject.admin_holder.check_for_rights(rights_required)
	return FALSE

/proc/GenerateToken()
	. = ""
	for(var/I in 1 to 32)
		. += "[rand(10)]"

/proc/RawHrefToken(forceGlobal = FALSE)
	var/tok = GLOB.href_token
	if(!forceGlobal && usr)
		var/client/admin = usr.client
		if(!admin)
			CRASH("No client for HrefToken()!")
		if(admin.admin_holder)
			tok = admin.admin_holder.href_token
	return tok

/proc/HrefToken(forceGlobal = FALSE)
	return "admin_token=[RawHrefToken(forceGlobal)]"


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

/proc/localhost_rank_check(client/admin_client, list/datum/entity/admin_rank/ranks)
	var/datum/entity/admin_rank/rank
	if(!length(ranks))
		rank = DB_ENTITY(/datum/entity/admin_rank)
		rank.rank = "!localhost!"
		rank.rights = RL_HOST
		rank.text_rights = "host"
		rank.save()
	else
		rank = ranks[length(ranks)]

	DB_FILTER(/datum/entity/admin_holder, DB_COMP("ckey", DB_EQUALS, admin_client.ckey), CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(localhost_entity_check), admin_client, rank))

/proc/localhost_entity_check(client/admin_client, datum/entity/admin_rank/rank, list/datum/entity/admin_holder/admins)
	var/datum/entity/admin_holder/admin
	if(!length(admins))
		admin = DB_ENTITY(/datum/entity/admin_holder)
		admin.admin_id = admin_client.player_data.id
		admin.ckey = admin_client.ckey
		admin.rank = rank.rank
		admin.save()
	else
		admin = admins[length(admins)]

	if(!admin_client.admin_holder)
		GLOB.admin_ranks = load_ranks()
		GLOB.admin_datums = load_admins()
		admin_client.player_data.admin_id = admin.id
		GLOB.admin_datums[admin_client.ckey].associate(admin_client)
