var/list/datum/admins/admin_datums = list()

GLOBAL_VAR_INIT(href_token, GenerateToken())
GLOBAL_PROTECT(href_token)

/datum/admins
	var/rank = "Temporary Admin"
	var/list/extra_titles = null
	var/client/owner = null
	var/rights = 0
	var/fakekey = null

	var/admincaster_screen = 0 //See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as admin_holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature //What you'll sign the newsfeeds as

	var/href_token

	var/datum/marked_datum
	var/list/datum/tagged_datums

	///Whether this admin is invisiminning
	var/invisimined = FALSE

	var/datum/filter_editor/filteriffic
	var/datum/particle_editor/particle_test

/datum/admins/New(initial_rank = "Temporary Admin", initial_rights = 0, ckey, list/new_extra_titles)
	if(!ckey)
		error("Admin datum created without a ckey argument. Datum has been deleted")
		qdel(src)
		return
	admincaster_signature = "Weyland-Yutani Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"
	rank = initial_rank
	rights = initial_rights
	href_token = GenerateToken()
	admin_datums[ckey] = src
	extra_titles = new_extra_titles

// Letting admins edit their own permission giver is a poor idea
/datum/admins/vv_edit_var(var_name, var_value)
	return FALSE

/datum/admins/proc/associate(client/C)
	if(istype(C))
		owner = C
		owner.admin_holder = src
		owner.add_admin_verbs()
		owner.add_admin_whitelists()
		owner.tgui_say.load()
		owner.update_special_keybinds()
		GLOB.admins |= C
		if(owner.admin_holder.rights & R_PROFILER)
			if(!world.GetConfig("admin", C.ckey))
				world.SetConfig("APP/admin", C.ckey, "role = coder")

/datum/admins/proc/disassociate()
	if(owner)
		GLOB.admins -= owner
		owner.remove_admin_verbs()
		owner.admin_holder = null
		owner.tgui_say.load()
		owner.update_special_keybinds()
		owner = null

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

/proc/admin_proc()
	if(!check_rights(R_ADMIN)) return
	to_world("you have enough rights!")

NOTE: it checks usr! not src! So if you're checking somebody's rank in a proc which they did not call
you will have to do something like if(client.admin_holder.rights & R_ADMIN) yourself.
*/
/proc/check_client_rights(client/C, rights_required, show_msg = TRUE)
	if(!C)
		return FALSE

	if(rights_required)
		if(C.admin_holder)
			if(rights_required & C.admin_holder.rights)
				return TRUE
			else
				if(show_msg && C.prefs.show_permission_errors)
					to_chat(C, SPAN_DANGER("Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required,"")]."))
	else
		if(C.admin_holder)
			return TRUE
		else
			if(show_msg && C.prefs.show_permission_errors)
				to_chat(C, SPAN_DANGER("Error: You are not an admin."))
	return FALSE

/proc/check_rights(rights_required, show_msg=TRUE)
	if(usr && usr.client)
		return check_client_rights(usr.client, rights_required, show_msg)
	return FALSE

/proc/check_other_rights(client/other, rights_required, show_msg = TRUE)
	if(!other)
		return FALSE
	if(rights_required && other.admin_holder?.rank)
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
			if(usr.client.admin_holder.rights != other.admin_holder.rights)
				if( (usr.client.admin_holder.rights & other.admin_holder.rights) == other.admin_holder.rights )
					return 1 //we have all the rights they have and more
		to_chat(usr, "<font color='red'>Error: Cannot proceed. They have more or equal rights to us.</font>")
	return 0

/client/proc/deadmin()
	if(admin_holder)
		admin_holder.disassociate()
		QDEL_NULL(admin_holder)
	return 1

/client/proc/readmin()
	if(admin_datums[ckey])
		admin_datums[ckey].associate(src)
	return 1

/datum/admins/proc/check_for_rights(rights_required)
	if(rights_required && !(rights_required & rights))
		return FALSE
	return TRUE

/// gets the role dependant data for tgui-say
/datum/admins/proc/get_tgui_say_roles()
	var/roles = list()
	if(check_for_rights(R_ADMIN))
		roles += "Admin"
	if(check_for_rights(R_MOD))
		roles += "Mod"
	if(check_for_rights(R_MENTOR))
		roles += "Mentor"
	return roles

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
		var/datum/admins/holder = C.admin_holder
		if(holder)
			tok = holder.href_token
	return tok

/proc/HrefToken(forceGlobal = FALSE)
	return "admin_token=[RawHrefToken(forceGlobal)]"
