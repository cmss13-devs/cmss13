var/list/datum/admins/admin_datums = list()

/datum/admins
	var/rank			= "Temporary Admin"
	var/client/owner	= null
	var/rights = 0
	var/fakekey			= null

	var/list/datum/marked_datums = list()

	var/admincaster_screen = 0	//See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as admin_holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature	//What you'll sign the newsfeeds as

	var/href_token

/datum/admins/New(initial_rank = "Temporary Admin", initial_rights = 0, ckey)
	if(!ckey)
		error("Admin datum created without a ckey argument. Datum has been deleted")
		qdel(src)
		return
	admincaster_signature = "Weston-Yamada Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"
	rank = initial_rank
	rights = initial_rights
	admin_datums[ckey] = src

/datum/admins/proc/associate(client/C)
	if(istype(C))
		owner = C
		owner.admin_holder = src
		owner.add_admin_verbs()
		owner.add_admin_whitelists()
		GLOB.admins |= C
		if(owner.admin_holder.rights & R_PROFILER)
			if(!world.GetConfig("admin", C.ckey))
				world.SetConfig("APP/admin", C.ckey, "role = coder")

/datum/admins/proc/disassociate()
	if(owner)
		GLOB.admins -= owner
		owner.remove_admin_verbs()
		owner.admin_holder = null
		owner = null

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

proc/admin_proc()
	if(!check_rights(R_ADMIN)) return
	to_world("you have enough rights!")

NOTE: it checks usr! not src! So if you're checking somebody's rank in a proc which they did not call
you will have to do something like if(client.admin_holder.rights & R_ADMIN) yourself.
*/
/proc/check_client_rights(var/client/C, rights_required, show_msg = TRUE)
	if(!C)
		return FALSE

	if(rights_required)
		if(C.admin_holder)
			if(rights_required & C.admin_holder.rights)
				return TRUE
			else
				if(show_msg)
					to_chat(C, SPAN_DANGER("Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required,"")]."))
	else
		if(C.admin_holder)
			return TRUE
		else
			if(show_msg)
				to_chat(C, SPAN_DANGER("Error: You are not an admin."))
	return FALSE

/proc/check_rights(rights_required, show_msg=TRUE)
	if(usr && usr.client)
		return check_client_rights(usr.client, rights_required, show_msg)
	return FALSE

//probably a bit iffy - will hopefully figure out a better solution
/proc/check_if_greater_rights_than(client/other)
	if(usr && usr.client)
		if(usr.client.admin_holder)
			if(!other || !other.admin_holder)
				return 1
			if(usr.client.admin_holder.rights != other.admin_holder.rights)
				if( (usr.client.admin_holder.rights & other.admin_holder.rights) == other.admin_holder.rights )
					return 1	//we have all the rights they have and more
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

/proc/IsAdminAdvancedProcCall()
	return usr?.client && GLOB.AdminProcCaller == usr.client.ckey

/proc/WrapAdminProcCall(datum/target, procname, list/arguments)
	if(target && procname == "Del")
		to_chat(usr, "Calling Del() is not allowed")
		return

	if(target != GLOBAL_PROC && !target.CanProcCall(procname))
		to_chat(usr, "Proccall on [target.type]/proc/[procname] is disallowed!")
		return

	var/current_caller = GLOB.AdminProcCaller
	var/ckey = usr ? usr.client.ckey : GLOB.AdminProcCaller
	if(!ckey)
		CRASH("WrapAdminProcCall with no ckey: [target] [procname] [english_list(arguments)]")

	if(current_caller && current_caller != ckey)
		if(!GLOB.AdminProcCallSpamPrevention[ckey])
			to_chat(usr, "<span class='adminnotice'>Another set of admin called procs are still running, your proc will be run after theirs finish.</span>")
			GLOB.AdminProcCallSpamPrevention[ckey] = TRUE
			UNTIL(!GLOB.AdminProcCaller)
			to_chat(usr, "<span class='adminnotice'>Running your proc</span>")
			GLOB.AdminProcCallSpamPrevention -= ckey
		else
			UNTIL(!GLOB.AdminProcCaller)

	GLOB.LastAdminCalledProc = procname
	if(target != GLOBAL_PROC)
		GLOB.LastAdminCalledTargetRef = "[REF(target)]"

	GLOB.AdminProcCaller = ckey	//if this runtimes, too bad for you
	++GLOB.AdminProcCallCount
	. = world.WrapAdminProcCall(target, procname, arguments)
	if(--GLOB.AdminProcCallCount == 0)
		GLOB.AdminProcCaller = null


/world/proc/WrapAdminProcCall(datum/target, procname, list/arguments)
	if(target == GLOBAL_PROC)
		return call(procname)(arglist(arguments))
	else if(target != world)
		return call(target, procname)(arglist(arguments))
	else
		log_admin_private("[key_name(usr)] attempted to call world/proc/[procname] with arguments: [english_list(arguments)]")

/datum/proc/CanProcCall(procname)
	return TRUE
