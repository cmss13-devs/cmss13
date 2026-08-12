SUBSYSTEM_DEF(water_overlays)
	name = "Water Overlays"
	init_order = SS_INIT_WATEROVERLAYS
	flags = SS_NO_FIRE
	var/stat = WATEROVERLAY_STATUS_STANDBY
	var/start_time = 0
	var/list/turfs_to_process = list()

/datum/controller/subsystem/water_overlays/Initialize()
	generate_water_display_icons()
	for(var/turf/T in GLOB.turfs)	//we're gonna cut down on the turfs we're gonna check to improve game start lag, ignoring water in nightmares...
		if(is_water(T))				//maybe we can add their neighbors to turfs_to_process when placing the nightmares...  someone should
			for(var/direction in GLOB.alldirs)
				var/turf/found_turf = get_step(T, direction)
				if(found_turf && !is_water(found_turf))
					turfs_to_process |= found_turf
		CHECK_TICK
	return SS_INIT_SUCCESS

/datum/controller/subsystem/water_overlays/proc/fix_water_neighbor_layers()
	if(stat == WATEROVERLAY_STATUS_DONE)
		return
	else
		start_time = world.time
		stat = WATEROVERLAY_STATUS_RUNNING
		var/list/altered_turfs = list()
		for(var/turf/T in turfs_to_process)
			if(T in altered_turfs)
				continue
			altered_turfs |= T.fix_water_clipping_layers(altered_turfs)
		for(var/turf/T in altered_turfs)
			T.fix_water_clipping_layers_final()
		stat = WATEROVERLAY_STATUS_DONE
