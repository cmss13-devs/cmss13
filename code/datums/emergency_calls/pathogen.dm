//Pathogen Creatures, hostile to everyone.
/datum/emergency_call/pathogen
	name = "Pathogen Creatures (Squad)"
	mob_max = 7
	probability = 5
	auto_shuttle_launch = TRUE //because xenos can't use the shuttle console.
	hostility = TRUE

/datum/emergency_call/pathogen/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USS Vriess respond-- #&...*#&^#.. signal... oh god, WHAT THE HELL IS THAT THI---... Priority Warning: Signal lost."
	objectives = "For the Overmind!"


/datum/emergency_call/pathogen/spawn_items()
	var/turf/drop_spawn = get_spawn_point(TRUE)
	if(istype(drop_spawn))
		new /obj/effect/alien/weeds/node/pathogen(drop_spawn) //drop some weeds for xeno plasma regen.

/datum/emergency_call/pathogen/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/current_mob = M.current

	var/mob/living/carbon/xenomorph/new_creature
	if(!leader)
		new_creature = new /mob/living/carbon/xenomorph/venator(spawn_loc)
		leader = new_creature
	else
		var/picked = pick(/mob/living/carbon/xenomorph/neomorph, /mob/living/carbon/xenomorph/blight)
		new_creature = new picked(spawn_loc)

	M.transfer_to(new_creature, TRUE)

	QDEL_NULL(current_mob)

/datum/emergency_call/pathogen/platoon
	name = "Pathogen Creatures (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
