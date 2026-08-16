SUBSYSTEM_DEF(water_overlays)
	name = "Water Overlays"
	init_order = SS_INIT_WATEROVERLAYS
	flags = SS_NO_FIRE
	var/stat = WATEROVERLAY_STATUS_STANDBY
	var/start_time = 0
	var/list/turfs_to_process = list()
	var/list/texture_sizes = list(32, 48, 64, 88)
	var/list/found_waters = list()
	var/list/water_overlay_icons = list()
	var/list/water_overlay_special = list(
		"32" = list(
			/mob/living/carbon/human = null,
			/mob/living/carbon/xenomorph/larva = "culling_larva",
		),
		"48" = list(
			/mob/living/carbon/xenomorph/facehugger = "culling_facehugger",
		),
		"64" = list(),
		"88" = list()
	)
	var/list/water_overlay_icon_paths = list(
			"32" = 'icons/effects/water_overlay_effects/_32.dmi',   //humans, etc
			"48" = 'icons/effects/water_overlay_effects/_48.dmi',   //facehugger, drone
			"64" = 'icons/effects/water_overlay_effects/_64.dmi',	//most xenos
			"88" = 'icons/effects/water_overlay_effects/_88.dmi',   //queen
	)

/datum/controller/subsystem/water_overlays/Initialize()
	for(var/turf/search_turf in GLOB.turfs)	//we're gonna cut down on the turfs we're gonna check to improve game start lag, ignoring water in nightmares...
		if(is_water(search_turf))
			var/turf/open/found_water = search_turf
			var/turf/open/water_turf = found_water.water_type
			found_waters["[found_water.water_type][water_turf.icon][water_turf.icon_state][found_water.depth]"] = list(water_turf.icon, water_turf.icon_state, found_water.depth, found_water.water_type)
			for(var/direction in GLOB.alldirs)
				var/turf/found_turf = get_step(search_turf, direction)
				if(found_turf && !is_water(found_turf))
					turfs_to_process |= found_turf
		for(var/obj/search_object in search_turf.contents)		//blocker/water objects can create water, we need to create overlays for those too
			if(ispath(search_object.type, /obj/effect/blocker/water))
				var/obj/effect/blocker/water/found_blocker = search_object
				found_waters["[found_blocker.water_type][found_blocker.water_type][found_blocker.icon][found_blocker.icon_state][found_blocker.created_depth]"] = list(found_blocker.icon, found_blocker.icon_state, found_blocker.created_depth, found_blocker.water_type)
		CHECK_TICK
	generate_water_display_icons()	//nightmares should only have water in their base maps, since we only generate overlays for basemap water turfs
	return SS_INIT_SUCCESS

/datum/controller/subsystem/water_overlays/proc/fix_water_neighbor_layers()
	start_time = world.time
	stat = WATEROVERLAY_STATUS_RUNNING
	var/list/altered_turfs = list()
	for(var/turf/current_turf in turfs_to_process)
		if(current_turf in altered_turfs)
			continue
		altered_turfs |= current_turf.fix_water_clipping_layers(altered_turfs)
	for(var/turf/current_turf in altered_turfs)
		current_turf.fix_water_clipping_layers_final()
	stat = WATEROVERLAY_STATUS_DONE
