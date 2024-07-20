GLOBAL_LIST_EMPTY(admin_ranks) //list of all admin_rank datums
GLOBAL_PROTECT(admin_ranks)

GLOBAL_LIST_INIT_TYPED(admin_datums, /datum/entity/admins, load_admins())

/proc/load_admins()
	WAIT_DB_READY

//TODO: DO SEPARATE TABLE FOR ADMINS, TO INIT IT FROM THERE
GLOBAL_VAR_INIT(href_token, GenerateToken())
GLOBAL_PROTECT(href_token)

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

	var/datum/entity/admins/D = new /datum/entity/admins(GLOB.admin_ranks[admin_status], ckey, extra_titles)

	//find the client for a ckey if they are connected and associate them with the new admin datum
	D.associate(GLOB.directory[ckey])

/datum/entity/admins
	var/extra_titles_text


// UNTRACKED FIELDS
	var/datum/entity/admin_rank/admin_rank
	var/list/extra_titles = null
	var/client/owner = null
	var/fakekey = null

	var/href_token

	var/datum/marked_datum
	var/list/datum/tagged_datums

	///Whether this admin is invisiminning
	var/invisimined = FALSE

	var/datum/filter_editor/filteriffic
	var/datum/particle_editor/particle_test

/datum/entity_meta/admins
	entity_type = /datum/entity/admins
	table_name = "admins"
	field_types = list(
		"admin_id" = DB_FIELDTYPE_BIGINT,
		"extra_titles_text" = DB_FIELDTYPE_STRING_MAX,
	)

/datum/entity_link/admin_to_player_job_bans
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player_job_ban
	child_field = "admin_id"

	parent_name = "admin"

/datum/entity_meta/chemical_information/map(datum/entity/chemical_information/ET, list/values)
	..()
	if(values["properties_text"])
		ET.properties = json_decode(values["properties_text"])

/datum/entity_meta/chemical_information/unmap(datum/entity/chemical_information/ET)
	. = ..()
	if(length(ET.properties))
		.["properties_text"] = json_encode(ET.properties)

/datum/entity/admins/New(admin_rank_ref, ckey, list/new_extra_titles)
	if(!ckey)
		error("Admin datum created without a ckey argument. Datum has been deleted")
		qdel(src)
		return
	admin_rank = admin_rank_ref
	href_token = GenerateToken()
	GLOB.admin_datums[ckey] = src
	extra_titles = new_extra_titles

// Letting admins edit their own permission giver is a poor idea
/datum/entity/admins/vv_edit_var(var_name, var_value)
	return FALSE

/datum/entity/admins/proc/associate(client/C)
	if(istype(C))
		owner = C
		owner.admin_holder = src
		owner.add_admin_verbs()
		owner.tgui_say.load()
		owner.update_special_keybinds()
		GLOB.admins |= C
		if(admin_rank.rights & R_PROFILER)
			if(!world.GetConfig("admin", C.ckey))
				world.SetConfig("APP/admin", C.ckey, "role = coder")

/datum/entity/admins/proc/disassociate()
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
		QDEL_NULL(admin_holder)
	return TRUE

/client/proc/readmin()
	if(GLOB.admin_datums[ckey])
		GLOB.admin_datums[ckey].associate(src)
	return TRUE

/datum/entity/admins/proc/check_for_rights(rights_required)
	if(rights_required && !(rights_required & admin_rank.rights))
		return FALSE
	return TRUE

/// gets any additional channels for tgui-say (admin & mentor)
/datum/entity/admins/proc/get_tgui_say_extra_channels()
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
		var/client/C = usr.client
		if(!C)
			CRASH("No client for HrefToken()!")
		var/datum/entity/admins/holder = C.admin_holder
		if(holder)
			tok = holder.href_token
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
