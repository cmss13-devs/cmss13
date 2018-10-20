// Clickable stat() button.
/obj/effect/statclick
	var/target

/obj/effect/statclick/New(text, target)
	name = text
	src.target = target

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!usr.client.holder)
		return
	if(!class)
		if(istype(target, /datum/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")


// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe", "Supply Shuttle"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if (!holder)
		return

	switch (controller)
		if ("Master")
			new/datum/controller/master()
			feedback_add_details("admin_verb","RMC")
		if ("Failsafe")
			new /datum/controller/failsafe()
			feedback_add_details("admin_verb","RFailsafe")

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")



/client/proc/debug_controller(controller in list("Cameras", "Configuration", "Shuttle Controller", "failsafe", "Garbage", "Jobs", "Master", "Radio", "Sun", "Ticker", "Vote"))
	set category = "Debug"
	set name = "debug controller"
	set desc = "debug the various periodic loop controllers for the game (be careful!)."

	if (!holder)
		return

	switch (controller)
		if ("Master")
			debug_variables(Master)
			feedback_add_details("admin_verb", "dmaster")
		if ("failsafe")
			debug_variables(Failsafe)
			feedback_add_details("admin_verb", "dfailsafe")
		if("Ticker")
			debug_variables(ticker)
			feedback_add_details("admin_verb","DTicker")
		if("Jobs")
			debug_variables(RoleAuthority)
			feedback_add_details("admin_verb","DJobs")
		if("Sun")
			debug_variables(sun)
			feedback_add_details("admin_verb","DSun")
		if("Radio")
			debug_variables(radio_controller)
			feedback_add_details("admin_verb","DRadio")
		if("Shuttle Controller")
			debug_variables(shuttle_controller)
			feedback_add_details("admin_verb","DEmergency")
		if("Configuration")
			debug_variables(config)
			feedback_add_details("admin_verb","DConf")
		if("Cameras")
			debug_variables(cameranet)
			feedback_add_details("admin_verb","DCameras")
		if("Garbage")
			debug_variables(garbageCollector)
			feedback_add_details("admin_verb","DGarbage")
		if("Vote")
			debug_variables(vote)
			feedback_add_details("admin_verb","DprocessVote")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
