SUBSYSTEM_DEF(admin)
	name          = "Admin"
	wait          = 5 MINUTES
	flags		  = SS_NO_INIT | SS_KEEP_TIMING
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	var/list/currentrun = list()
	var/times_repeated = 0

/datum/controller/subsystem/admin/stat_entry(msg)
	msg = "P:[unansweredAhelps.len]"
	return ..()

/datum/controller/subsystem/admin/fire(resumed = FALSE)
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
