SUBSYSTEM_DEF(minimaps_update)
	name = "Minimaps Update"
	wait = 30 SECONDS
	flags = SS_POST_FIRE_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	priority = SS_PRIORITY_MAPVIEW
	init_order = SS_INIT_MAPVIEW
	var/list/minimap_added

/datum/controller/subsystem/minimaps_update/Initialize(start_timeofday)
	minimap_added = list()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/minimaps_update/fire(resumed = FALSE)
	update_xenos_in_tower_range()

/datum/controller/subsystem/minimaps_update/proc/update_xenos_in_tower_range()
	if(SSticker.toweractive)
		add_xenos_to_minimap()
	else

		if(length(GLOB.command_apc_list))
			for(var/obj/vehicle/multitile/apc/command/current_apc as anything in GLOB.command_apc_list)

				var/turf/apc_turf = get_turf(current_apc)
				if(current_apc.health == 0 || !current_apc.visible_in_tacmap || !is_ground_level(apc_turf))
					continue

				for(var/mob/living/carbon/Xenomorph/current_xeno as anything in GLOB.living_xeno_list)
					var/turf/xeno_turf = get_turf(current_xeno)
					if(!is_ground_level(xeno_turf))
						continue

					if(get_dist(current_apc, current_xeno) <= current_apc.sensor_radius)
						if(WEAKREF(current_xeno) in minimap_added)
							return

						SSminimaps.add_marker(current_xeno, current_xeno.z, hud_flags = MINIMAP_FLAG_MARINE, iconstate = current_xeno.caste.minimap_icon)
						minimap_added += WEAKREF(current_xeno)
					else
						if(WEAKREF(current_xeno) in minimap_added)
							SSminimaps.remove_marker(current_xeno, MINIMAP_FLAG_MARINE)
							minimap_added -= current_xeno

/datum/controller/subsystem/minimaps_update/proc/remove_xenos_from_minimap()
	for(var/mob/living/carbon/Xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		if(WEAKREF(current_xeno) in minimap_added)
			SSminimaps.remove_marker(current_xeno, MINIMAP_FLAG_MARINE)
			minimap_added -= current_xeno

/datum/controller/subsystem/minimaps_update/proc/add_xenos_to_minimap()
	for(var/mob/living/carbon/Xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		if(WEAKREF(current_xeno) in minimap_added)
			return

		SSminimaps.add_marker(current_xeno, current_xeno.z, hud_flags = MINIMAP_FLAG_MARINE, iconstate = current_xeno.caste.minimap_icon)
		minimap_added += WEAKREF(current_xeno)
