var/datum/subsystem/lighting/SSlighting


/datum/subsystem/lighting
	name          = "Lighting"
	init_order    = SS_INIT_LIGHTING
	display_order = SS_DISPLAY_LIGHTING
	priority      = SS_PRIORITY_LIGHTING
	wait          = 4
	flags         = SS_FIRE_IN_LOBBY

	var/list/datum/light_source/lights_current = list()
	var/list/datum/light_source/lights = list()

	var/list/turf/changed_turfs_current = list()
	var/list/turf/changed_turfs = list()


/datum/subsystem/lighting/New()
	NEW_SS_GLOBAL(SSlighting)

/datum/subsystem/lighting/stat_entry()
	..("L:[lights.len]; T:[changed_turfs.len]")

/datum/subsystem/lighting/Initialize(timeofday)
	for(var/thing in lights)
		var/datum/light_source/L = thing
		if(L)
			L.check()
	lights.Cut()


	var/z_start = 1
	var/z_finish = world.maxz

	var/list/init_turfs = block(locate(1,1,z_start),locate(world.maxx,world.maxy,z_finish))

	for(var/turf/thing in init_turfs)
		if(istype(thing))
			thing.shift_to_subarea()

	..()


/datum/subsystem/lighting/fire(resumed = FALSE)
	if (!resumed)
		lights_current = lights.Copy()
		lights = list()
		changed_turfs_current = changed_turfs.Copy()
		changed_turfs = list()


	while (lights_current.len)
		var/datum/light_source/L = lights_current[lights_current.len]
		lights_current.len--
		if (!L)
			continue
		L.check()
		if (MC_TICK_CHECK)
			return
	
	while (changed_turfs_current.len)
		var/turf/T = changed_turfs_current[changed_turfs_current.len]
		changed_turfs_current.len--
		if(!T)
			continue
		if(T.lighting_changed)
			T.shift_to_subarea()
		if (MC_TICK_CHECK)
			return