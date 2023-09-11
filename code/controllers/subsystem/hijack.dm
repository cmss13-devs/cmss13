
#define EVACUATION_TYPE_NONE 0
#define EVACUATION_TYPE_ADDITIVE 1
#define EVACUATION_TYPE_MULTIPLICATIVE 2

SUBSYSTEM_DEF(hijack)
	name   = "Hijack"
	wait   = 2 SECONDS
	flags  = SS_KEEP_TIMING
	init_order = SS_INIT_HIJACK
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

/datum/controller/subsystem/hijack/stat_entry(msg)
	..()
	if(!SSticker.mode.is_in_endgame)
		msg += " Not Hijack"
		return

	//Add current progress and change last fire() - Morrow


/datum/controller/subsystem/hijack/fire(resumed = FALSE)
	if(!SSticker.mode.is_in_endgame)
		return

	if(current_progress >= required_progress)
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

///Called when the xeno dropship crashes into the Almayer and announces the current status of various objectives to all sides
/datum/controller/subsystem/hijack/proc/announce_status_on_crash()
	//todo - Morrow

	/*
	[b]ARES Emergency Procedures[/b]

	[cycled_area_name] - [status ? "Online" : "Offline"]

	Maintain functionality for safe lifeboat evacuation.

	*/


///Called when an area power status is changed to announce that it has been changed
/datum/controller/subsystem/hijack/proc/announce_area_power_change(area/changed_area)
	//todo - Morrow

	var/status = changed_area.power_equip

	/*

	[b]ARES Emergency Procedures[/b]

	[changed_area] - [status ? "Online" : "Offline"]

	*/

/datum/controller/subsystem/hijack/proc/announce_to_xenos()
	switch(xeno_announce_checkpoint / initial(xeno_announce_checkpoint))
		if(1)
			//Announce 25%
		if(2)
			//Announce 50%
		if(3)
			//Announce 75%
		if(4)
			//Announce complete


/* - Morrow

During hijack give a readout in stat for estimated time remaining until evac is fully ready as well as progress

Remove old timer for evac preparations

*/
