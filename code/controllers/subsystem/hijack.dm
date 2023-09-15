
#define EVACUATION_TYPE_NONE 0
#define EVACUATION_TYPE_ADDITIVE 1
#define EVACUATION_TYPE_MULTIPLICATIVE 2

#define HIJACK_ANNOUNCE "ARES Emergency Procedures"
#define XENO_HIJACK_ANNOUNCE "You sense something unusual..."

#define EVACUATION_STATUS_NOT_INITIATED 0
#define EVACUATION_STATUS_INITIATED 1

#define HIJACK_OBJECTIVES_NOT_STARTED 0
#define HIJACK_OBJECTIVES_STARTED 1
#define HIJACK_OBJECTIVES_COMPLETE 2

SUBSYSTEM_DEF(hijack)
	name   = "Hijack"
	wait   = 2 SECONDS
	flags  = SS_NO_INIT | SS_KEEP_TIMING
	priority   = SS_PRIORITY_HIJACK

	///Required progress to evacuate safely via lifeboats
	var/required_progress = 100

	///Current progress towards evacuating safely via lifeboats
	var/current_progress = 0

	///The estimated time left to get to the safe evacuation point
	var/estimated_time_left = 0

	///Areas that are marked as having progress, assoc list that is progress_area = boolean, the boolean indicating if it was progressing or not on the last fire()
	var/list/progress_areas = list()

	///The areas that need cycled through currently
	var/list/current_run = list()

	///The progress of the current run that needs to be added at the end of the current run
	var/current_run_progress_additive = 0

	///Holds what the current_run_progress_additive should be multiplied by at the end of the current run
	var/current_run_progress_multiplicative = 1

	///Holds the progress change from last run
	var/last_run_progress_change = 0

	///Holds the next % point it should be announced to xenos, increments on itself
	var/xeno_announce_checkpoint = 25

	///What stage of evacuation we are currently on
	var/evac_status = EVACUATION_STATUS_NOT_INITIATED

	///What stage of hijack are we currently on
	var/hijack_status = HIJACK_OBJECTIVES_NOT_STARTED

	///Whether or not evacuation has been disabled by admins
	var/evac_admin_denied = FALSE

	///Whether or not self destruct has been disabled by admins
	//var/evac_self_destruct_denied = FALSE // Re-enable for SD stuff - Morrow

/datum/controller/subsystem/hijack/stat_entry(msg)
	if(!SSticker?.mode?.is_in_endgame)
		msg = " Not Hijack"
		return ..()

	if(current_progress >= required_progress)
		msg = " Complete"
		return ..()

	msg = " Progress: [current_progress] | Last run: [last_run_progress_change]"
	return ..()

/datum/controller/subsystem/hijack/fire(resumed = FALSE)
	if(!SSticker?.mode?.is_in_endgame)
		return

	if(hijack_status < HIJACK_OBJECTIVES_STARTED)
		hijack_status = HIJACK_OBJECTIVES_STARTED

	if(current_progress >= required_progress)
		if(hijack_status < HIJACK_OBJECTIVES_COMPLETE)
			hijack_status = HIJACK_OBJECTIVES_COMPLETE
		return

	if(!resumed)
		current_run = progress_areas.Copy()

	for(var/area/almayer/cycled_area as anything in current_run)
		current_run -= cycled_area

		if(progress_areas[cycled_area] != cycled_area.power_equip)
			progress_areas[cycled_area] = !progress_areas[cycled_area]
			announce_area_power_change(cycled_area)

		if(progress_areas[cycled_area])
			switch(cycled_area.hijack_evacuation_type)
				if(EVACUATION_TYPE_ADDITIVE)
					current_run_progress_additive += cycled_area.hijack_evacuation_weight
				if(EVACUATION_TYPE_MULTIPLICATIVE)
					current_run_progress_multiplicative *= cycled_area.hijack_evacuation_weight

		if (MC_TICK_CHECK)
			return

	last_run_progress_change = current_run_progress_additive * current_run_progress_multiplicative
	current_progress += last_run_progress_change

	if(last_run_progress_change)
		estimated_time_left = ((required_progress - current_progress) / last_run_progress_change) * wait
	else
		estimated_time_left = INFINITY

	if(current_progress >= xeno_announce_checkpoint)
		announce_to_xenos()
		xeno_announce_checkpoint += initial(xeno_announce_checkpoint)

	current_run_progress_additive = 0
	current_run_progress_multiplicative = 1

///Called when the xeno dropship crashes into the Almayer and announces the current status of various objectives to marines
/datum/controller/subsystem/hijack/proc/announce_status_on_crash()
	var/message = ""

	for(var/area/cycled_area as anything in progress_areas)
		message += "[cycled_area] - [cycled_area.power_equip ? "Online" : "Offline"]\n"

	message += "\nMaintain fueling functionality for optimal lifeboat usage."

	marine_announcement(message, HIJACK_ANNOUNCE)

///Called when an area power status is changed to announce that it has been changed
/datum/controller/subsystem/hijack/proc/announce_area_power_change(area/changed_area)
	var/message = "[changed_area] - [changed_area.power_equip ? "Online" : "Offline"]"

	marine_announcement(message, HIJACK_ANNOUNCE)

///Called to announce to xenos the state of evacuation progression
/datum/controller/subsystem/hijack/proc/announce_to_xenos()
	var/xeno_announce = xeno_announce_checkpoint / initial(xeno_announce_checkpoint)

	var/warning_areas = ""

	for(var/area/cycled_area as anything in progress_areas)
		if(cycled_area.power_equip)
			warning_areas += "[cycled_area], "

	if(warning_areas)
		warning_areas = copytext(warning_areas, 1, -2)

	var/datum/hive_status/hive
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		if(!length(hive.totalXenos))
			continue

		switch(xeno_announce)
			if(1)
				xeno_announcement(SPAN_XENOANNOUNCE("The talls are a quarter of the way towards their goals. Disable the following areas: [warning_areas]"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)
			if(2)
				xeno_announcement(SPAN_XENOANNOUNCE("The talls are half way towards their goals. Disable the following areas: [warning_areas]"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)
			if(3)
				xeno_announcement(SPAN_XENOANNOUNCE("The talls are three quarters of the way towards their goals. Disable the following areas: [warning_areas]"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)
			if(4)
				xeno_announcement(SPAN_XENOANNOUNCE("The talls have completed their goals!"), hive.hivenumber, XENO_HIJACK_ANNOUNCE)

/// Passes the ETA for status panels
/datum/controller/subsystem/hijack/proc/get_status_panel_eta()
	switch(hijack_status)
		if(HIJACK_OBJECTIVES_STARTED)
			if(estimated_time_left == INFINITY)
				return "Never"
			return "[estimated_time_left]"

		if(HIJACK_OBJECTIVES_COMPLETE)
			return "Complete"



//~~~~~~~~~~~~~~~~~~~~~~~~ EVAC STUFF ~~~~~~~~~~~~~~~~~~~~~~~~//

/// Initiates evacuation by announcing and then prepping all lifepods/lifeboats
/datum/controller/subsystem/hijack/proc/initiate_evacuation()
	if(evac_status == EVACUATION_STATUS_NOT_INITIATED && !(evac_admin_denied & FLAGS_EVACUATION_DENY))
		evac_status = EVACUATION_STATUS_INITIATED
		ai_announcement("Attention. Emergency. All personnel must evacuate immediately.", 'sound/AI/evacuate.ogg')

		for(var/obj/structure/machinery/status_display/cycled_status_display in machines)
			if(is_mainship_level(cycled_status_display.z))
				cycled_status_display.set_picture("evac")
		for(var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle in SSshuttle.mobile)
			shuttle.prepare_evac()
		activate_lifeboats()
		return TRUE

/// Cancels evacuation, tells lifepods/lifeboats and status_displays
/datum/controller/subsystem/hijack/proc/cancel_evacuation()
	if(evac_status == EVACUATION_STATUS_INITIATED)
		evac_status = EVACUATION_STATUS_NOT_INITIATED
		deactivate_lifeboats()
		ai_announcement("Evacuation has been cancelled.", 'sound/AI/evacuate_cancelled.ogg')

		for(var/obj/structure/machinery/status_display/cycled_status_display in machines)
			if(is_mainship_level(cycled_status_display.z))
				cycled_status_display.set_sec_level_picture()

		for(var/obj/docking_port/mobile/crashable/escape_shuttle/shuttle in SSshuttle.mobile)
			shuttle.cancel_evac()
		return TRUE

/// Opens the lifeboat doors and gets them ready to launch
/datum/controller/subsystem/hijack/proc/activate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.status = LIFEBOAT_ACTIVE
			lifeboat_dock.open_dock()

/// Turns off ability to manually take off lifeboats
/datum/controller/subsystem/hijack/proc/deactivate_lifeboats()
	for(var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock in GLOB.lifeboat_almayer_docks)
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = lifeboat_dock.get_docked()
		if(lifeboat && lifeboat.available)
			lifeboat.status = LIFEBOAT_INACTIVE




/* - Morrow

To do:

Calibrate numbers to make sure objectives don't finish too early or late

Self destruct code
	Thinking something like finish main objectives and then can blow fuel resevoir as a "self destruct" via engineering and a hold

Testing:
New nuclear bomb explosion
status display change from cancel_evacuation()
Round actually ending with get_affected_zlevel() move
Verify crash chances are working correctly for crashable shuttles
Check that emergency cryo kits work


*/
