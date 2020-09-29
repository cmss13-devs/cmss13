SUBSYSTEM_DEF(tracking)
	name          = "Tracking"
	wait          = 2 SECONDS
	priority      = SS_PRIORITY_TRACKING
	flags         = SS_DISABLE_FOR_TESTING

	// Mobs add themselves to the tracking, so it gets a bit finnicky. Make sure leaders get set in the proper places, removed and added.

	// A list split into each squad/hive, where each squad/hive has a list of all their mobs
	var/list/tracked_mobs = list()

	// A quicker reference lookup
	var/list/mobs_in_processing = list()

	// A list of leaders mapped to their respective list
	var/list/leaders = list()

	var/list/currentrun = list()

/datum/controller/subsystem/tracking/Initialize(start_timeofday)
	initialize_trackers()
	return ..()


/datum/controller/subsystem/tracking/stat_entry()
	var/mobs = 0
	for(var/tracked_group in tracked_mobs)
		mobs += length(tracked_mobs[tracked_group])
	..("P:[mobs]")


/datum/controller/subsystem/tracking/fire(resumed = FALSE)
	if(!resumed)
		currentrun = copyListList(tracked_mobs)

	for(var/tracked_group in currentrun)
		for(var/mob/living/current_mob in currentrun[tracked_group])
			currentrun[tracked_group] -= current_mob
			if(!current_mob)
				stop_tracking(tracked_group, current_mob)
				continue
			if(ishuman(current_mob))
				var/mob/living/carbon/human/human_mob = current_mob
				human_mob.locate_squad_leader()
			else if(isXeno(current_mob))
				var/mob/living/carbon/Xenomorph/xeno_mob = current_mob
				xeno_mob.queen_locator()
			if (MC_TICK_CHECK)
				return
		currentrun -= tracked_group

/datum/controller/subsystem/tracking/proc/start_tracking(var/tracked_group, var/mob/living/carbon/mob)
	if(!mob)
		return FALSE
	if(mobs_in_processing[mob] == tracked_group)
		return TRUE // already tracking this squad leader
	if(mobs_in_processing[mob])
		stop_tracking(mobs_in_processing[mob], mob) // remove from tracking the other squad
	mobs_in_processing[mob] = tracked_group

	if(tracked_mobs[tracked_group])
		tracked_mobs[tracked_group] += mob

/datum/controller/subsystem/tracking/proc/stop_tracking(var/tracked_group, var/mob/living/carbon/mob)
	if(!mobs_in_processing[mob])
		return TRUE // already removed
	var/tracking_id = mobs_in_processing[mob]
	mobs_in_processing.Remove(mob)

	if(tracking_id != tracked_group)
		tracked_mobs[tracked_group] -= mob
		
	if(tracked_mobs[tracking_id])
		tracked_mobs[tracking_id] -= mob

/datum/controller/subsystem/tracking/proc/set_leader(var/tracked_group, var/mob/living/carbon/mob)
	if(leaders[tracked_group])
		delete_leader(tracked_group)

	leaders[tracked_group] = mob

/datum/controller/subsystem/tracking/proc/delete_leader(var/tracked_group)
	leaders.Remove(tracked_group)

/datum/controller/subsystem/tracking/proc/setup_trackers(mob/mob, var/tracked_group)
	if(!tracked_group)
		tracked_group = "tracked_[tracked_mobs.len]"

	tracked_mobs[tracked_group] = list()
	leaders[tracked_group] = mob
	return tracked_group


/datum/controller/subsystem/tracking/proc/initialize_trackers()
	setup_trackers(null, "marine_sl")
	for(var/datum/hive_status/hive in hive_datum)
		setup_trackers(null, "hive_[hive.hivenumber]")