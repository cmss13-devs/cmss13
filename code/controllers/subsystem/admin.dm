var/datum/subsystem/admin/SSadmin

/datum/subsystem/admin
	name          = "Admin"
	wait          = SS_WAIT_ADMIN
	flags		  = SS_FIRE_IN_LOBBY | SS_NO_INIT | SS_KEEP_TIMING

	var/list/currentrun = list()
	var/times_repeated = 0

/datum/subsystem/admin/New()
	NEW_SS_GLOBAL(SSadmin)

/datum/subsystem/admin/stat_entry()
	..("P:[unansweredAhelps.len]")

/datum/subsystem/admin/fire(resumed = FALSE)
	if (!resumed)
		currentrun = unansweredAhelps.Copy()

	if(!currentrun.len)
		times_repeated = 0
		return

	var/msg = "<font color='#009900'><b>Unheard Ahelps (Repeated [times_repeated] times):</b></font>"

	while (currentrun.len)
		var/ahelp_msg = currentrun[currentrun.len]
		currentrun.len--
	
		if (!ahelp_msg)
			continue

		msg += unansweredAhelps[ahelp_msg] + "\n"

		if (MC_TICK_CHECK)
			return
	
	var/list/current_staff = get_staff_by_category()
	current_staff = current_staff["admins"]
	if(current_staff.len)
		for(var/client/X in current_staff)
			if(X.prefs.toggles_sound & SOUND_ADMINHELP)
				sound_to(X, 'sound/effects/adminhelp_new.ogg')
			to_chat(X, msg)
	times_repeated++
