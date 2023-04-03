
#define XENO_TO_TOTAL_SPAWN_RATIO 1/4

/datum/job/antag/xenos
	title = JOB_XENOMORPH
	role_ban_alternative = "Alien"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_CUSTOM_SPAWN
	supervisors = "Queen"
	selection_class = "job_xeno"
	// Unlimited for the precount purposes, later set_spawn_positions gets called and sets
	// a proper limit.
	spawn_positions = -1
	total_positions = -1

/datum/job/antag/xenos/proc/calculate_extra_spawn_positions(count)
	return max((round(count * XENO_TO_TOTAL_SPAWN_RATIO)), 0)

/datum/job/antag/xenos/set_spawn_positions(count)
	spawn_positions = max((round(count * XENO_TO_TOTAL_SPAWN_RATIO)), 1)
	total_positions = spawn_positions

/datum/job/antag/xenos/spawn_in_player(mob/new_player/NP)
	. = ..()
	var/mob/living/carbon/human/H = .

	transform_to_xeno(H, XENO_HIVE_NORMAL)

/datum/job/antag/xenos/proc/transform_to_xeno(mob/living/carbon/human/H, hive_index)
	var/datum/mind/new_xeno = H.mind
	new_xeno.setup_xeno_stats()
	var/datum/hive_status/hive = GLOB.hive_datum[hive_index]

	H.first_xeno = TRUE
	H.set_stat(UNCONSCIOUS)
	H.forceMove(get_turf(pick(GLOB.xeno_spawns)))

	var/list/survivor_types = list(
		/datum/equipment_preset/survivor/scientist,
		/datum/equipment_preset/survivor/doctor,
		/datum/equipment_preset/survivor/security,
		/datum/equipment_preset/survivor/engineer
	)
	arm_equipment(H, pick(survivor_types), FALSE, FALSE)

	for(var/obj/item/device/radio/radio in H.contents_recursive())
		radio.listening = FALSE

	H.job = title
	H.apply_damage(50, BRUTE)
	H.spawned_corpse = TRUE

	var/obj/structure/bed/nest/start_nest = new /obj/structure/bed/nest(H.loc) //Create a new nest for the host
	H.statistic_exempt = TRUE
	H.buckled = start_nest
	H.setDir(start_nest.dir)
	H.update_canmove()
	start_nest.buckled_mob = H
	start_nest.afterbuckle(H)

	var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H) //Put the initial larva in a host
	embryo.stage = 5 //Give the embryo a head-start (make the larva burst instantly)
	embryo.hivenumber = hive.hivenumber

/datum/job/antag/xenos/equip_job(mob/living/M)
	return
