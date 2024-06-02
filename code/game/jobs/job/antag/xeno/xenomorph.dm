
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
	return max((floor(count * XENO_TO_TOTAL_SPAWN_RATIO)), 0)

/datum/job/antag/xenos/set_spawn_positions(count)
	spawn_positions = max((floor(count * XENO_TO_TOTAL_SPAWN_RATIO)), 1)
	total_positions = spawn_positions

/datum/job/antag/xenos/spawn_in_player(mob/new_player/NP)
	. = ..()
	var/mob/living/carbon/human/H = .

	transform_to_xeno(H, XENO_HIVE_NORMAL)

/datum/job/antag/xenos/proc/transform_to_xeno(mob/living/carbon/human/human_to_transform, hive_index)
	var/datum/mind/new_xeno = human_to_transform.mind
	new_xeno.setup_xeno_stats()
	var/datum/hive_status/hive = GLOB.hive_datum[hive_index]

	human_to_transform.first_xeno = TRUE
	human_to_transform.set_stat(UNCONSCIOUS)
	human_to_transform.forceMove(get_turf(pick(GLOB.xeno_spawns)))

	var/list/survivor_types = list(
		/datum/equipment_preset/survivor/scientist,
		/datum/equipment_preset/survivor/doctor,
		/datum/equipment_preset/survivor/security,
		/datum/equipment_preset/survivor/engineer
	)
	arm_equipment(human_to_transform, pick(survivor_types), FALSE, FALSE)

	for(var/obj/item/device/radio/radio in human_to_transform.contents_recursive())
		radio.listening = FALSE

	human_to_transform.job = title
	human_to_transform.apply_damage(50, BRUTE)
	human_to_transform.spawned_corpse = TRUE

	//placing the nests on walls logic
	var/count = 0
	var/obj/structure/bed/nest/start_nest
	var/list/turf/list_to_search = list(get_turf(human_to_transform))
	while(isnull(start_nest))
		count++
		var/list/turf/new_entries = list()
		for(var/turf/turf_to_search in list_to_search)
			new_entries |=  list(get_step(turf_to_search, NORTH), get_step(turf_to_search, SOUTH), get_step(turf_to_search, EAST), get_step(turf_to_search, WEST))
		var/list/turf/bad_entries = list()
		for(var/turf/open/found_open_turf in new_entries)
			for(var/obj/found_object in found_open_turf)
				if(istype(found_object, /obj/structure/window/framed) || found_object.density)
					bad_entries |= found_open_turf
		for(var/turf/closed/wall/wall_in_range in new_entries)
			var/list/turf/neighbor_turfs = list(get_step(wall_in_range, SOUTH), get_step(wall_in_range, EAST), get_step(wall_in_range, WEST))
			for(var/turf/open/ground_in_range in neighbor_turfs)
				var/area/in_range_area = get_area(ground_in_range)
				if(in_range_area.flags_area & AREA_NOTUNNEL)
					continue
				var/finish_proc = TRUE
				for(var/obj/found_object in ground_in_range)
					if(istype(found_object, /obj/structure/bed/nest/) || found_object.density)
						finish_proc = FALSE
						break
				if(finish_proc)
					human_to_transform.forceMove(ground_in_range)
					start_nest = new /obj/structure/bed/nest(human_to_transform.loc) //Create a new nest for the host
					start_nest.dir = get_dir(human_to_transform,wall_in_range)
					break
			bad_entries |= wall_in_range //no viable turfs found for this wall; we remove it
		new_entries -= bad_entries
		list_to_search = new_entries
		if(count > 20) // we dont got all day, we got a game to play baby!
			start_nest = new /obj/structure/bed/nest(human_to_transform.loc)
			start_nest.dir = NORTH
			break

	human_to_transform.statistic_exempt = TRUE
	human_to_transform.set_buckled(start_nest)
	human_to_transform.setDir(start_nest.dir)
	start_nest.buckled_mob = human_to_transform
	start_nest.afterbuckle(human_to_transform)

	var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(human_to_transform) //Put the initial larva in a host
	embryo.stage = 5 //Give the embryo a head-start (make the larva burst instantly)
	embryo.hivenumber = hive.hivenumber


/datum/job/antag/xenos/equip_job(mob/living/M)
	return
