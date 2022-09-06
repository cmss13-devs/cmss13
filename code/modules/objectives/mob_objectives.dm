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
	var/list/scored_corpses = list()

/datum/cm_objective/recover_corpses/New()
	. = ..()

	RegisterSignal(SSdcs, list(
		COMSIG_GLOB_MARINE_DEATH,
		COMSIG_GLOB_XENO_DEATH
	), .proc/handle_mob_deaths)

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
		objective_spawn_corpse.Remove(spawner)

/datum/cm_objective/recover_corpses/post_round_start()
	activate()

/datum/cm_objective/recover_corpses/proc/handle_mob_deaths(datum/source, mob/living/carbon/dead_mob, gibbed)
	SIGNAL_HANDLER

	if(!iscarbon(dead_mob))
		return

	// This mob has already been scored before
	if(LAZYISIN(scored_corpses, dead_mob))
		return

	LAZYDISTINCTADD(corpses, dead_mob)
	RegisterSignal(dead_mob, COMSIG_PARENT_QDELETING, .proc/handle_corpse_deletion)
	RegisterSignal(dead_mob, COMSIG_LIVING_REJUVENATED, .proc/handle_mob_revival)

	if (isXeno(dead_mob))
		RegisterSignal(dead_mob, COMSIG_XENO_REVIVED, .proc/handle_mob_revival)
	else
		RegisterSignal(dead_mob, COMSIG_HUMAN_REVIVED, .proc/handle_mob_revival)


/datum/cm_objective/recover_corpses/proc/handle_mob_revival(mob/living/carbon/revived_mob)
	SIGNAL_HANDLER

	UnregisterSignal(revived_mob, list(COMSIG_LIVING_REJUVENATED, COMSIG_PARENT_QDELETING))

	if (isXeno(revived_mob))
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

	if (isXeno(deleted_mob))
		UnregisterSignal(deleted_mob, COMSIG_XENO_REVIVED)
	else
		UnregisterSignal(deleted_mob, COMSIG_HUMAN_REVIVED)

	LAZYREMOVE(corpses, deleted_mob)

/// Get score value for a given corpse
/datum/cm_objective/recover_corpses/proc/score_corpse(mob/target)
	var/value = 0

	if(isYautja(target))
		value = OBJECTIVE_ABSOLUTE_VALUE

	else if(isXeno(target))
		var/mob/living/carbon/Xenomorph/X = target
		switch(X.tier)
			if(1)
				if(isXenoPredalien(X))
					value = OBJECTIVE_ABSOLUTE_VALUE
				else value = OBJECTIVE_LOW_VALUE
			if(2)
				value = OBJECTIVE_MEDIUM_VALUE
			if(3)
				value = OBJECTIVE_EXTREME_VALUE
			else
				if(isXenoQueen(X)) //Queen is Tier 0 for some reason...
					value = OBJECTIVE_ABSOLUTE_VALUE

	else if(isHumanSynthStrict(target))
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
			scored_corpses += target

			if (isXeno(target))
				UnregisterSignal(target, COMSIG_XENO_REVIVED)
			else
				UnregisterSignal(target, COMSIG_HUMAN_REVIVED)
