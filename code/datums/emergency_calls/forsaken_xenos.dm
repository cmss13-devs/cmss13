/datum/emergency_call/forsaken_xenos
	name = "Xenomorphs Groundside (Forsaken)"
	mob_min = 1
	mob_max = 4
	hostility = TRUE
	name_of_spawn = /obj/effect/landmark/ert_spawns/groundside_xeno
	objectives = "You have been left behind to safeguard the abandoned colony. Do not allow trespassers."

/datum/emergency_call/forsaken_xenos/spawn_items()
	var/turf/drop_spawn = get_spawn_point(TRUE)
	if(istype(drop_spawn))
		//drop some weeds for xeno plasma regen.
		new /obj/effect/alien/weeds/node/forsaken(drop_spawn)

/datum/emergency_call/forsaken_xenos/create_member(datum/mind/new_member, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/current_mob = new_member.current

	var/picked
	var/mob/living/carbon/xenomorph/new_xeno
	if(!leader)
		picked = pick(/mob/living/carbon/xenomorph/warrior, /mob/living/carbon/xenomorph/lurker, /mob/living/carbon/xenomorph/spitter)
		leader = new_xeno
	else
		picked = pick(/mob/living/carbon/xenomorph/drone, /mob/living/carbon/xenomorph/runner)

	new_xeno = new picked(spawn_loc)

	new_member.transfer_to(new_xeno, TRUE)

	new_xeno.set_hive_and_update(XENO_HIVE_FORSAKEN)
	new_xeno.lock_evolve = TRUE

	QDEL_NULL(current_mob)
