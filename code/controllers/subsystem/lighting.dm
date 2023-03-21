SUBSYSTEM_DEF(lighting)
	name   = "Lighting"
	init_order = SS_INIT_LIGHTING
	priority   = SS_PRIORITY_LIGHTING
	wait   = 0.4 SECONDS
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

	var/list/datum/light_source/lights_current = list()
	var/list/datum/light_source/lights = list()

	var/list/turf/changed_turfs_current = list()
	var/list/turf/changed_turfs = list()


/datum/controller/subsystem/lighting/stat_entry(msg)
	msg = "L:[lights.len]; T:[changed_turfs.len]"
	return ..()

/datum/controller/subsystem/lighting/Initialize(timeofday)
	for(var/thing in lights)
		var/datum/light_source/current_light = thing
		if(current_light)
			current_light.check()
	lights.Cut()


	var/z_start = 1
	var/z_finish = world.maxz

	var/list/init_turfs = block(locate(1,1,z_start),locate(world.maxx,world.maxy,z_finish))

	for(var/turf/thing in init_turfs)
		if(istype(thing))
			thing.shift_to_subarea()

	return SS_INIT_SUCCESS


/datum/controller/subsystem/lighting/fire(resumed = FALSE)
	if(!resumed)
		lights_current = lights
		lights = list()
		changed_turfs_current = changed_turfs
		changed_turfs = list()


	while(lights_current.len)
		var/datum/light_source/current_light = lights_current[lights_current.len]
		lights_current.len--
		if(!current_light)
			continue
		if(!current_light.owner || current_light.changed)
			current_light.check()
		if(MC_TICK_CHECK)
			return

	while(changed_turfs_current.len)
		var/turf/curent_turf = changed_turfs_current[changed_turfs_current.len]
		changed_turfs_current.len--
		if(!curent_turf)
			continue
		if(curent_turf.lighting_changed)
			if(curent_turf.lighting_lumcount != curent_turf.cached_lumcount)
				curent_turf.cached_lumcount = curent_turf.lighting_lumcount
				curent_turf.shift_to_subarea()
			curent_turf.lighting_changed = FALSE
		if (MC_TICK_CHECK)
			return
