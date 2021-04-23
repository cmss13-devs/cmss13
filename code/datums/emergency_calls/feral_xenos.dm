
//Feral Xenomorphs, hostile to TRULY everyone.
/datum/emergency_call/feral_xenos
	name = "Xenomorphs (Feral)"
	mob_min = 1
	mob_max = 8
	max_medics = 2 //Support T2 castes
	max_engineers = 3 //Combat T2 castes
	probability = 5
	auto_shuttle_launch = TRUE //because xenos can't use the shuttle console.
	hostility = TRUE

/datum/emergency_call/feral_xenos/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USS Vriess respond-- #&...*#&^#.. signal.. oh god, they're in the vent---... Priority Warning: Signal lost."
	objectives = "Destroy everything!"

/datum/emergency_call/feral_xenos/spawn_items()
	var/turf/drop_spawn	= get_spawn_point(TRUE)
	if(istype(drop_spawn))
		//drop some weeds for xeno plasma regen.
		new /obj/effect/alien/weeds/node/feral(drop_spawn)

/datum/emergency_call/feral_xenos/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) 
		return //Didn't find a useable spawn point.

	var/mob/current_mob = M.current

	var/mob/living/carbon/Xenomorph/new_xeno
	if(!leader)
		var/picked = pick(/mob/living/carbon/Xenomorph/Ravager, /mob/living/carbon/Xenomorph/Praetorian)
		new_xeno = new picked(spawn_loc)
		leader = new_xeno

	else if(medics < max_medics)
		medics++
		var/picked = pick(/mob/living/carbon/Xenomorph/Drone, /mob/living/carbon/Xenomorph/Hivelord, /mob/living/carbon/Xenomorph/Burrower)
		new_xeno = new picked(spawn_loc)

	else if(engineers < max_engineers)
		engineers++
		var/picked = pick(/mob/living/carbon/Xenomorph/Warrior, /mob/living/carbon/Xenomorph/Lurker, /mob/living/carbon/Xenomorph/Spitter)
		new_xeno = new picked(spawn_loc)

	else
		var/picked = pick(/mob/living/carbon/Xenomorph/Drone, /mob/living/carbon/Xenomorph/Runner, /mob/living/carbon/Xenomorph/Defender)
		new_xeno = new picked(spawn_loc)

	M.transfer_to(new_xeno, TRUE)
	new_xeno.set_hive_and_update(XENO_HIVE_FERAL)

	QDEL_NULL(current_mob)


/datum/emergency_call/feral_xenos/platoon
	name = "Xenomorphs (Feral Platoon)"
	mob_min = 1
	mob_max = 30
	probability = 0
