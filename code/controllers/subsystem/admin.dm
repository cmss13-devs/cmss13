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

	for(var/client/C in GLOB.admins)
		if(C && C.admin_holder && (C.admin_holder.rights & R_MOD))
			if(C.prefs.toggles_sound & SOUND_ADMINHELP)
				sound_to(C, 'sound/effects/adminhelp_new.ogg')
			to_chat(C, msg)
	times_repeated++
