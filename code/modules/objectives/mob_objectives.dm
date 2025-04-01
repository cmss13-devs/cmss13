// --------------------------------------------
// *** Recover the dead ***
// --------------------------------------------
/datum/cm_objective/recover_corpses
	name = "Recover corpses"
	objective_flags = OBJECTIVE_DO_NOT_TREE
	state = OBJECTIVE_ACTIVE
	controller = TREE_MARINE
	/// List of list of active corpses per tech-faction ownership
	var/list/corpses = list()
	var/list/scored_other_corpses = list()
	var/list/scored_humansynth_corpses = list()
	var/max_humans = FALSE

/datum/cm_objective/recover_corpses/New()
	. = ..()

	RegisterSignal(SSdcs, list(
		COMSIG_GLOB_MARINE_DEATH,
		COMSIG_GLOB_XENO_DEATH
	), PROC_REF(handle_mob_deaths))

/datum/cm_objective/recover_corpses/Destroy()
	corpses = null
	. = ..()

/datum/cm_objective/recover_corpses/proc/generate_corpses(numCorpsesToSpawn)
	var/list/obj/effect/landmark/corpsespawner/objective_spawn_corpse = GLOB.corpse_spawns.Copy()
	while(numCorpsesToSpawn--)
		if(!length(objective_spawn_corpse))
			break
		var/obj/effect/landmark/corpsespawner/spawner = pick(objective_spawn_corpse)
		var/turf/spawnpoint = get_turf(spawner)
		if(spawnpoint)
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(spawnpoint)
			M.create_hud() //Need to generate hud before we can equip anything apparently...
			arm_equipment(M, spawner.equip_path, TRUE, FALSE)
			for(var/obj/structure/bed/nest/found_nest in spawnpoint)
				for(var/turf/the_turf in list(get_step(found_nest, NORTH),get_step(found_nest, EAST),get_step(found_nest, WEST)))
					if(the_turf.density)
						found_nest.dir = get_dir(found_nest, the_turf)
						found_nest.pixel_x = found_nest.buckling_x["[found_nest.dir]"]
						found_nest.pixel_y = found_nest.buckling_y["[found_nest.dir]"]
						M.dir = get_dir(the_turf,found_nest)
				if(!found_nest.buckled_mob)
					found_nest.do_buckle(M,M)
		objective_spawn_corpse.Remove(spawner)

/datum/cm_objective/recover_corpses/post_round_start()
	activate()

/datum/cm_objective/recover_corpses/proc/handle_mob_deaths(datum/source, mob/living/carbon/dead_mob, gibbed)
	SIGNAL_HANDLER

	if(!iscarbon(dead_mob))
		return

	// This mob has already been scored before
	if(LAZYISIN(scored_other_corpses, dead_mob) || LAZYISIN(scored_humansynth_corpses, dead_mob))
		return

	LAZYDISTINCTADD(corpses, dead_mob)
	RegisterSignal(dead_mob, COMSIG_PARENT_QDELETING, PROC_REF(handle_corpse_deletion))
	RegisterSignal(dead_mob, COMSIG_LIVING_REJUVENATED, PROC_REF(handle_mob_revival))

	if (isxeno(dead_mob))
		RegisterSignal(dead_mob, COMSIG_XENO_REVIVED, PROC_REF(handle_mob_revival))
	else
		RegisterSignal(dead_mob, COMSIG_HUMAN_REVIVED, PROC_REF(handle_mob_revival))


/datum/cm_objective/recover_corpses/proc/handle_mob_revival(mob/living/carbon/revived_mob)
	SIGNAL_HANDLER

	UnregisterSignal(revived_mob, list(COMSIG_LIVING_REJUVENATED, COMSIG_PARENT_QDELETING))

	if (isxeno(revived_mob))
		UnregisterSignal(revived_mob, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(revived_mob, COMSIG_HUMAN_REVIVED)

	LAZYREMOVE(corpses, revived_mob)


/datum/cm_objective/recover_corpses/proc/handle_corpse_deletion(mob/living/carbon/deleted_mob)
	SIGNAL_HANDLER

	UnregisterSignal(deleted_mob, list(
		COMSIG_LIVING_REJUVENATED,
		COMSIG_PARENT_QDELETING
	))

	if (isxeno(deleted_mob))
		UnregisterSignal(deleted_mob, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(deleted_mob, COMSIG_HUMAN_REVIVED)

	LAZYREMOVE(corpses, deleted_mob)

/// Get score value for a given corpse
/datum/cm_objective/recover_corpses/proc/score_corpse(mob/target)
	var/value = 0

	if(isyautja(target))
		value = OBJECTIVE_ABSOLUTE_VALUE

	else if(isxeno(target))
		var/mob/living/carbon/xenomorph/X = target
		switch(X.tier)
			if(1)
				if(ispredalien(X))
					value = OBJECTIVE_ABSOLUTE_VALUE
				else
					value = OBJECTIVE_LOW_VALUE
			if(2)
				value = OBJECTIVE_MEDIUM_VALUE
			if(3)
				value = OBJECTIVE_EXTREME_VALUE
			else
				if(isqueen(X)) //Queen is Tier 0 for some reason...
					value = OBJECTIVE_ABSOLUTE_VALUE

	else if(ishumansynth_strict(target))
		if(length(scored_humansynth_corpses) <= 48) // Limit human corpse recovery to 5 total points (.1 each)
			return OBJECTIVE_LOW_VALUE
		if(!max_humans)
			marine_announcement("Maximum intel points for non-xenomorph corpses has been achieved.", "Intel Announcement", 'sound/misc/notice2.ogg')
			max_humans = TRUE
			return OBJECTIVE_LOW_VALUE

	return value

/datum/cm_objective/recover_corpses/process()

	for(var/mob/target as anything in corpses)
		if(QDELETED(target))
			LAZYREMOVE(corpses, target)
			continue

		// Get the corpse value
		var/corpse_val = score_corpse(target)

		// Add points depending on who controls it
		var/turf/T = get_turf(target)
		var/area/A = get_area(T)
		if(istype(A, /area/almayer/medical/morgue) || istype(A, /area/almayer/medical/containment))
			SSobjectives.statistics["corpses_recovered"]++
			SSobjectives.statistics["corpses_total_points_earned"] += corpse_val
			award_points(corpse_val)

			corpses -= target
			if(ishumansynth_strict(target))
				scored_humansynth_corpses += target
			else
				scored_other_corpses += target

			if (isxeno(target))
				UnregisterSignal(target, COMSIG_XENO_REVIVED)
			else
				UnregisterSignal(target, COMSIG_HUMAN_REVIVED)

// --------------------------------------------
// *** Get a mob to an area/level ***
// --------------------------------------------
#define MOB_CAN_COMPLETE_AFTER_DEATH 1
#define MOB_FAILS_ON_DEATH 2

/datum/cm_objective/move_mob
	var/area/destination
	var/mob/living/target
	var/mob_can_die = MOB_CAN_COMPLETE_AFTER_DEATH
	objective_flags = OBJECTIVE_DO_NOT_TREE


/datum/cm_objective/move_mob/New(mob/living/survivor)
	if(istype(survivor, /mob/living))
		target = survivor
		RegisterSignal(survivor, COMSIG_MOB_DEATH, PROC_REF(handle_death))
		RegisterSignal(survivor, COMSIG_PARENT_QDELETING, PROC_REF(handle_corpse_deletion))
	activate()
	. = ..()

/datum/cm_objective/move_mob/Destroy()
	UnregisterSignal(target, list(
		COMSIG_MOB_DEATH,
		COMSIG_PARENT_QDELETING,
		COMSIG_LIVING_REJUVENATED,
	))
	if (isxeno(target))
		UnregisterSignal(target, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(target, COMSIG_HUMAN_REVIVED)
	destination = null
	target = null
	return ..()

/datum/cm_objective/move_mob/proc/handle_corpse_deletion(mob/living/carbon/deleted_mob)
	SIGNAL_HANDLER

	qdel(src)

/datum/cm_objective/move_mob/proc/handle_death(mob/living/carbon/dead_mob)
	SIGNAL_HANDLER

	if(mob_can_die == MOB_FAILS_ON_DEATH)
		deactivate()
		if (isxeno(dead_mob))
			RegisterSignal(dead_mob, COMSIG_XENO_REVIVED, PROC_REF(handle_mob_revival))
		else
			RegisterSignal(dead_mob, COMSIG_HUMAN_REVIVED, PROC_REF(handle_mob_revival))
		RegisterSignal(dead_mob, COMSIG_LIVING_REJUVENATED, PROC_REF(handle_mob_revival))

/datum/cm_objective/move_mob/proc/handle_mob_revival(mob/living/carbon/revived_mob)
	SIGNAL_HANDLER

	UnregisterSignal(revived_mob, list(COMSIG_LIVING_REJUVENATED))

	if (isxeno(revived_mob))
		UnregisterSignal(revived_mob, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(revived_mob, COMSIG_HUMAN_REVIVED)
	activate()

/datum/cm_objective/move_mob/check_completion()
	. = ..()
	if(istype(get_area(target),destination))
		if(target.stat != DEAD || mob_can_die & MOB_CAN_COMPLETE_AFTER_DEATH)
			complete()
			return TRUE

/datum/cm_objective/move_mob/complete()
	SSobjectives.statistics["survivors_rescued"]++
	SSobjectives.statistics["survivors_rescued_total_points_earned"] += value
	award_points()
	deactivate()

/datum/cm_objective/move_mob/almayer
	destination = /area/almayer

/datum/cm_objective/move_mob/almayer/survivor
	name = "Rescue the Survivor"
	mob_can_die = MOB_FAILS_ON_DEATH
	value = OBJECTIVE_EXTREME_VALUE

/datum/cm_objective/move_mob/almayer/vip
	name = "Rescue the VIP"
	mob_can_die = MOB_FAILS_ON_DEATH
	value = OBJECTIVE_ABSOLUTE_VALUE
	objective_flags = OBJECTIVE_DO_NOT_TREE
