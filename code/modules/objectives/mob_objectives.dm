// --------------------------------------------
// *** Eliminate Mobs ***
// --------------------------------------------
#define ELIMINATE_Z_LEVEL 1
#define ELIMINATE_AREA 2

/datum/cm_objective/eliminate
	var/mob_type = /mob/living
	var/elimination_type // see defines above
	var/list/z_levels = list()
	var/list/areas_to_clear = list()
	var/include_vents = 0
	objective_flags = OBJ_CAN_BE_UNCOMPLETED

/datum/cm_objective/eliminate/proc/is_valid_mob(mob/living/M)
	if(!istype(M, mob_type))
		return 0
	return 1

/datum/cm_objective/eliminate/check_completion()
	. = ..()
	var/mob_count = 0
	for(var/mob/M in living_mob_list)
		if(!is_valid_mob(M))
			continue
		switch(elimination_type)
			if(ELIMINATE_Z_LEVEL)
				if((M.z in z_levels) || (include_vents && M.loc.z in z_levels))
					mob_count++
				else
					continue
			if(ELIMINATE_AREA)
				if((isturf(M.loc) && get_area(M) in areas_to_clear) || (include_vents && get_area(M) in areas_to_clear))
					mob_count++
				else
					continue
	if(mob_count > 0)
		uncomplete()
		return 0
	else
		complete()
		return 1

/datum/cm_objective/eliminate/xenomorph
	mob_type = /mob/living/carbon/Xenomorph
	var/hivenumber = XENO_HIVE_NORMAL

/datum/cm_objective/eliminate/xenomorph/is_valid_mob(mob/living/carbon/Xenomorph/X)
	. = ..()
	if(X.hivenumber != hivenumber)
		return 0

/datum/cm_objective/eliminate/xenomorph/queen
	mob_type = /mob/living/carbon/Xenomorph/Queen

/datum/cm_objective/eliminate/xenomorph/ship
	elimination_type = ELIMINATE_Z_LEVEL
	z_levels = list(MAIN_SHIP_Z_LEVEL)

/datum/cm_objective/eliminate/xenomorph/queen/ship
	elimination_type = ELIMINATE_Z_LEVEL
	z_levels = list(MAIN_SHIP_Z_LEVEL)

// --------------------------------------------
// *** Get a mob to an area/level ***
// --------------------------------------------
#define MOB_CAN_COMPLETE_AFTER_DEATH 1
#define MOB_FAILS_ON_DEATH 2

/datum/cm_objective/move_mob
	var/area/destination
	var/mob/living/target
	var/mob_can_die = MOB_CAN_COMPLETE_AFTER_DEATH
	objective_flags = OBJ_DO_NOT_TREE | OBJ_FAILABLE


/datum/cm_objective/move_mob/New(var/mob/living/H)
	if(istype(H, /mob/living))
		target = H
	. = ..()

/datum/cm_objective/move_mob/check_completion()
	. = ..()
	if(target.stat == DEAD && mob_can_die & MOB_FAILS_ON_DEATH)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(!H.check_tod() || !H.is_revivable()) // they went unrevivable
				fail()
				return 0
		else
			fail()
			return 0
	if(istype(get_area(target),destination))
		if(target.stat != DEAD || mob_can_die & MOB_CAN_COMPLETE_AFTER_DEATH)
			complete()
			return 1

/datum/cm_objective/move_mob/almayer
	destination = /area/almayer

/datum/cm_objective/move_mob/almayer/survivor
	name = "Rescue the Survivor"
	mob_can_die = MOB_FAILS_ON_DEATH
	priority = OBJECTIVE_ABSOLUTE_VALUE
	display_category = "Rescue the Survivors"

/datum/cm_objective/move_mob/almayer/vip
	name = "Rescue the VIP"
	mob_can_die = MOB_FAILS_ON_DEATH
	priority = OBJECTIVE_ABSOLUTE_VALUE
	display_category = "Rescue the VIP"
	objective_flags = OBJ_DO_NOT_TREE | OBJ_FAILABLE | OBJ_CAN_BE_UNCOMPLETED

/mob/living/carbon/human/vip

/mob/living/carbon/human/vip/New()
	..()
	new /datum/cm_objective/move_mob/almayer/vip(src)

/mob/living/carbon/human/survivor

/mob/living/carbon/human/survivor/New()
	..()
	new /datum/cm_objective/move_mob/almayer/survivor(src)

// --------------------------------------------
// *** Minimise losses ***
// --------------------------------------------
/*
#define PASSED_NO_THRESHOLD 0
#define PASSED_GOOD_THRESHOLD 1
#define PASSED_POOR_THRESHOLD 2
#define PASSED_FAIL_THRESHOLD 3

/datum/cm_objective/minimise_losses
	var/fail_threshold = 75
	var/poor_threshold = 50
	var/good_threshold = 25
	priority = OBJECTIVE_EXTREME_VALUE
	var/last_threshold = PASSED_NO_THRESHOLD
	objective_flags = OBJ_DO_NOT_TREE

/datum/cm_objective/minimise_losses/proc/get_loss_percentage()
	return 0

/datum/cm_objective/minimise_losses/get_point_value()
	. = ..()
	if(!is_failed())
		switch(last_threshold)
			if(PASSED_NO_THRESHOLD)
				return priority
			if(PASSED_GOOD_THRESHOLD)
				return priority / 2
			if(PASSED_POOR_THRESHOLD)
				return priority / 4

/datum/cm_objective/minimise_losses/proc/announce_losses(var/threshold_crossed, var/failed = 0)
	var/message = "Warning, casulties have exceeded [threshold_crossed]%"
	if(failed)
		message += "\nThe operation has failed, begin strategic withdrawl."
	marine_announcement(message, "[MAIN_AI_SYSTEM]", 'sound/AI/commandreport.ogg')

/datum/cm_objective/minimise_losses/check_completion()
	. = ..()
	if(get_loss_percentage() >= fail_threshold)
		if(!is_failed())
			last_threshold = PASSED_FAIL_THRESHOLD
			announce_losses(fail_threshold, 1)
		fail()
		return 0

	switch(get_loss_percentage())
		if(poor_threshold to fail_threshold)
			if(last_threshold < PASSED_POOR_THRESHOLD)
				last_threshold = PASSED_POOR_THRESHOLD
				announce_losses(poor_threshold)
		if(good_threshold to poor_threshold)
			if(last_threshold < PASSED_GOOD_THRESHOLD)
				last_threshold = PASSED_GOOD_THRESHOLD
				announce_losses(good_threshold)
	return 0

/datum/cm_objective/minimise_losses/squad_marines
	name = "Minimise Marine Losses"
	display_flags = OBJ_DISPLAY_AT_END
	priority = OBJECTIVE_ABSOLUTE_VALUE

/datum/cm_objective/minimise_losses/squad_marines/get_loss_percentage()
	var/total_marines = 0
	var/total_alive = 0
	for(var/datum/squad/S in RoleAuthority.squads)
		total_marines += S.count
		for(var/mob/living/carbon/human/H in S.marines_list)
			if(H.stat != DEAD)
				total_alive++
	var/total_dead = total_marines - total_alive
	if(total_marines > 0) // protect against divide by zero
		return round(100.0 * total_dead / total_marines)
	else
		return 0

/datum/cm_objective/minimise_losses/squad_marines/get_completion_status()
	return "[get_loss_percentage()]% Losses"

/datum/cm_objective/minimise_losses/get_point_value()
	if(world.time < MINUTES_30)
		//We don't count this objective for the first 30 minures
		//Otherwise LV might get a lot of points before Marines drop due to tcomms being given for free...
		return 0
	return (1.0 - get_loss_percentage()) / 100 * priority

/datum/cm_objective/minimise_losses/total_point_value()
	return priority
*/

// --------------------------------------------
// *** Recover the dead ***
// --------------------------------------------
/datum/cm_objective/recover_corpses
	name = "Recover the Dead"
	var/list/corpses = list()
	objective_flags = OBJ_PROCESS_ON_DEMAND | OBJ_DO_NOT_TREE
	var/points_per_corpse = 5
	var/area/recovery_area = /area/almayer/medical/morgue
	//We count how many corpses we recovered and are not processing anymore
	//So we can cremate them and so on rather than turn the morgue trays into a clown car
	var/recovered_corpses_count = 0

/datum/cm_objective/recover_corpses/get_point_value()
	var/points = 0
	for(var/mob/H in corpses)
		if(istype(get_area(H),recovery_area))
			if(objective_flags & OBJ_CAN_BE_UNCOMPLETED)
				points++
			else
				recovered_corpses_count++
				corpses -= H
	return (recovered_corpses_count + points) * points_per_corpse

/datum/cm_objective/recover_corpses/total_point_value()
	return (corpses.len + recovered_corpses_count) * points_per_corpse

/datum/cm_objective/recover_corpses/get_completion_status()
	var/percentage = 0
	var/total = total_point_value()
	if(total)
		var/value = get_point_value()
		percentage = value*100.0/total
	return "[percentage]% Recovered"

/datum/cm_objective/recover_corpses/colonists
	name = "Recover Colonist Bodies"
	points_per_corpse = 5
	display_flags = OBJ_DISPLAY_AT_END

/datum/cm_objective/recover_corpses/colonists/post_round_start()
	var/turf/T
	for(var/mob/living/carbon/human/H in human_mob_list)
		T = get_turf(H)
		if(!(T.z in SURFACE_Z_LEVELS))
			continue
		if(H.stat != DEAD)
			continue
		corpses += H

/datum/cm_objective/recover_corpses/marines
	name = "Recover KIA Marines"
	display_flags = OBJ_DISPLAY_AT_END

/datum/cm_objective/recover_corpses/marines/proc/add_marine(var/mob/living/carbon/human/H)
	if(!(H in corpses))
		corpses += H

/datum/cm_objective/recover_corpses/marines/proc/remove_marine(var/mob/living/carbon/human/H)
	corpses -= H

/hook/death/proc/handle_marine_deaths(var/mob/living/carbon/human/H, var/gibbed)
	if(!istype(H))
		return 1
	if(!istype(H.assigned_squad) || gibbed || !objectives_controller)
		return 1
	objectives_controller.marines.add_marine(H)
	return 1

/hook/clone/proc/handle_marine_revival(var/mob/living/carbon/human/H)
	objectives_controller.marines.remove_marine(H)
	return 1

/datum/cm_objective/recover_corpses/xenos
	name = "Recover Xeno corpse specimens"
	display_flags = OBJ_DISPLAY_AT_END
	points_per_corpse = 50
	recovery_area = /area/almayer/medical/containment/cell

/datum/cm_objective/recover_corpses/xenos/proc/add_xeno(var/mob/living/carbon/Xenomorph/X)
	if(!(X in corpses))
		corpses += X

/datum/cm_objective/recover_corpses/xenos/proc/remove_xeno(var/mob/living/carbon/Xenomorph/X)
	corpses -= X

/hook/death/proc/handle_xeno_deaths(var/mob/living/carbon/Xenomorph/X, var/gibbed)
	if(!istype(X) || gibbed || !objectives_controller)
		return 1
	objectives_controller.xenos.add_xeno(X)
	return 1
