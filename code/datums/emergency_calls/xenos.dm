
//Xenomorphs, hostile to everyone.
/datum/emergency_call/xenos
	name = "Xenomorphs (Squad)"
	mob_max = 7
	probability = 10
	auto_shuttle_launch = TRUE //because xenos can't use the shuttle console.
	hostility = TRUE

/datum/emergency_call/xenos/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USS Vriess respond-- #&...*#&^#.. signal.. oh god, they're in the vent---... Priority Warning: Signal lost."
	objectives = "For the Empress!"


/datum/emergency_call/xenos/spawn_items()
	var/turf/drop_spawn	= get_spawn_point(TRUE)
	if(istype(drop_spawn))
		new /obj/effect/alien/weeds/node(drop_spawn) //drop some weeds for xeno plasma regen.

/datum/emergency_call/xenos/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) 
		return //Didn't find a useable spawn point.

	var/mob/current_mob = M.current

	var/mob/living/carbon/Xenomorph/new_xeno
	if(!leader)
		new_xeno = new /mob/living/carbon/Xenomorph/Ravager(spawn_loc)
		leader = new_xeno
	else
		var/picked = pick(/mob/living/carbon/Xenomorph/Drone, /mob/living/carbon/Xenomorph/Spitter, /mob/living/carbon/Xenomorph/Lurker)
		new_xeno = new picked(spawn_loc)

	M.transfer_to(new_xeno, TRUE)

	QDEL_NULL(current_mob)


/datum/emergency_call/xenos/platoon
	name = "Xenomorphs (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
