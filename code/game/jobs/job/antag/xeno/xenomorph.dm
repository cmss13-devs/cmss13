
#define XENO_TO_MARINES_SPAWN_RATIO 1/3

/datum/job/antag/xenos
	title = JOB_XENOMORPH
	role_ban_alternative = "Alien"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_CUSTOM_SPAWN
	supervisors = "Queen"
	selection_class = "job_xeno"

/datum/job/antag/xenos/set_spawn_positions(var/count)
	spawn_positions = max((round(count * XENO_TO_MARINES_SPAWN_RATIO)), 1)
	total_positions = spawn_positions

/datum/job/antag/xenos/spawn_in_player(var/mob/new_player/NP)
	. = ..()
	var/mob/living/carbon/human/H = .

	transform_to_xeno(H, XENO_HIVE_NORMAL)

/datum/job/antag/xenos/proc/transform_to_xeno(var/mob/living/carbon/human/H, var/hive_index)
	var/datum/mind/new_xeno = H.mind
	new_xeno.setup_xeno_stats()
	var/datum/hive_status/hive = hive_datum[hive_index]

	H.first_xeno = TRUE
	H.stat = 1
	H.forceMove(get_turf(pick(GLOB.xeno_spawns)))

	var/list/survivor_types = list(
		"Survivor - Scientist",
		"Survivor - Doctor",
		"Survivor - Security",
		"Survivor - Engineer"
	)
	arm_equipment(H, pick(survivor_types), FALSE, FALSE)

	H.job = title
	H.apply_damage(50, BRUTE)
	H.spawned_corpse = TRUE

	var/obj/structure/bed/nest/start_nest = new /obj/structure/bed/nest(H.loc) //Create a new nest for the host
	H.statistic_exempt = TRUE
	H.buckled = start_nest
	H.dir = start_nest.dir
	H.update_canmove()
	start_nest.buckled_mob = H
	start_nest.afterbuckle(H)

	var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H) //Put the initial larva in a host
	embryo.stage = 5 //Give the embryo a head-start (make the larva burst instantly)
	embryo.hivenumber = hive.hivenumber

/datum/job/antag/xenos/equip_job(mob/living/M)
	return
