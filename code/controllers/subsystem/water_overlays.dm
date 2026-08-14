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
			"64" = 'icons/effects/water_overlay_effects/_64.dmi', //most xenos
			"88" = 'icons/effects/water_overlay_effects/_88.dmi',   //queen
	)

/datum/controller/subsystem/water_overlays/Initialize()
	for(var/turf/T in GLOB.turfs)	//we're gonna cut down on the turfs we're gonna check to improve game start lag, ignoring water in nightmares...
		if(is_water(T))				//maybe we can add their neighbors to turfs_to_process when placing the nightmares...  someone should
			found_waters |= T
			for(var/direction in GLOB.alldirs)
				var/turf/found_turf = get_step(T, direction)
				if(found_turf && !is_water(found_turf))
					turfs_to_process |= found_turf
		CHECK_TICK
	generate_water_display_icons()	//nightmares should only have water in their base maps, since we only generate overlays for basemap water turfs (otherwise we could do this at gamestart and add ~3 seconds of lag as this runs)
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
