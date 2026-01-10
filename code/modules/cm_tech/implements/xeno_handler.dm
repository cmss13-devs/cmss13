//Xenomorphs, hostile to everyone.
/datum/emergency_call/xeno_handler
	name = "Xenomorph Handler"
	mob_max = 8
	probability = 0
	auto_shuttle_launch = TRUE //because xenos can't use the shuttle console.
	hostility = FALSE
	spawn_max_amount = TRUE

/datum/emergency_call/xeno_handler/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], corrupted xenos with a trainer have been sent your way."
	objectives = "Listen to the human that gives you directives, they are your master. If you are this human, give orders to the Xenomorphs. They are expected to listen to you."


/datum/emergency_call/xeno_handler/spawn_items()
	var/turf/drop_spawn = get_spawn_point(TRUE)
	if(istype(drop_spawn))
		new /obj/effect/alien/weeds/node(drop_spawn, null, null, GLOB.hive_datum[XENO_HIVE_TAMED]) //drop some weeds for xeno plasma regen.

/datum/emergency_call/xeno_handler/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/datum/hive_status/corrupted/tamed/hive = GLOB.hive_datum[XENO_HIVE_TAMED]

	var/mob/living/carbon/new_mob
	if(!leader)
		new_mob = new/mob/living/carbon/human(spawn_loc)
		new_mob.create_hud()
		arm_equipment(new_mob, /datum/equipment_preset/pmc/commando/dogcatcher, TRUE, TRUE)

		hive.make_leader(new_mob)
		leader = new_mob


	else
		var/picked = pick(/mob/living/carbon/xenomorph/drone, /mob/living/carbon/xenomorph/spitter, /mob/living/carbon/xenomorph/lurker)
		new_mob = new picked(spawn_loc, null, XENO_HIVE_TAMED)
		var/mob/living/carbon/xenomorph/X = new_mob
		X.iff_tag = new /obj/item/iff_tag/pmc_handler(X)
	if(M)
		M.transfer_to(new_mob, TRUE)
	else
		new_mob.away_timer = XENO_LEAVE_TIMER
		new_mob.free_for_ghosts()
