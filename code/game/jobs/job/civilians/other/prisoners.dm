#define PRISONER_TO_TOTAL_SPAWN_RATIO 1/11

/datum/job/civilian/prisoner
	title = JOB_PRISONER
	selection_class = "job_special"
	// For the roundstart precount, then gets further limited by set_spawn_positions.
	total_positions = 8
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_CUSTOM_SPAWN
	late_joinable = FALSE

	handle_equipment = TRUE
	handle_spawn = TRUE

	var/static/list/spawnable_turfs

/datum/job/civilian/prisoner/set_spawn_positions(var/count)
	spawn_positions = Clamp((round(count * PRISONER_TO_TOTAL_SPAWN_RATIO)), 2, 8)
	total_positions = spawn_positions

/datum/job/civilian/prisoner/setup_equipment(mob/living/carbon/human/human)
	var/spawn_equipment_type
	switch(rand(1, 100))
		if(1 to 80)
			spawn_equipment_type = /datum/equipment_preset/uscm_ship/prisoner
		if(81 to 95)
			spawn_equipment_type = /datum/equipment_preset/uscm_ship/prisoner/clf
		if(96 to 100)
			spawn_equipment_type = /datum/equipment_preset/uscm_ship/prisoner/clf/leader
	arm_equipment(human, spawn_equipment_type, TRUE, TRUE)

/datum/job/civilian/prisoner/setup_spawn(mob/living/carbon/human/human)
	var/list/all_areas_list = all_areas
	if(!length(spawnable_turfs))
		spawnable_turfs = list()
		var/list/area/spawn_areas = list()

		var/area/spawn_area = locate(/area/almayer/shipboard/brig/cells) in all_areas_list
		spawn_areas += spawn_area
		for(var/area/related_spawn_area as anything in spawn_area.related)
			spawn_areas += related_spawn_area

		for(var/area/spawn_zone in spawn_areas)
			for(var/turf/open/spawn_turf in spawn_zone.contents)
				for(var/obj/object in spawn_turf.contents)
					if(object.density)
						continue
				spawnable_turfs += spawn_turf
	if(length(spawnable_turfs))
		human.forceMove(pick(spawnable_turfs))
