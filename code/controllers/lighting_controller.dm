var/global/datum/controller/lighting/lighting_controller

/datum/controller/lighting
	var/processing = 0
	var/processing_interval = 7	//setting this too low will probably kill the server. Don't be silly with it!
	var/process_cost = 0
	var/iteration = 0

	var/lighting_states = 7

	var/list/lights = list()
	var/lights_workload_max = 0


	var/list/changed_turfs = list()
	var/changed_turfs_workload_max = 0


/datum/controller/lighting/New()
	lighting_states = max(0, LIGHTING_STATES)
	if(lighting_controller != src)
		if(istype(lighting_controller,/datum/controller/lighting))
			Recover()	//if we are replacing an existing lighting_controller (due to a crash) we attempt to preserve as much as we can
			qdel(lighting_controller)
		lighting_controller = src
	lighting_controller.Initialize()

/datum/controller/lighting/proc/process()
	while(processing)
		iteration++
		var/thing
		var/datum/light_source/L
		for(thing in global_changed_lights)
			L = thing
			if(L)
				L.check()

		//Operating under the assumpting that Cut() is O(n) because DM is dumb
		global_changed_lights = list()

		var/turf/T
		for(thing in changed_turfs)
			T = thing
			if(T)
				if(T.lighting_changed)
					T.shift_to_subarea()

		changed_turfs = list()

		sleep(processing_interval)

//same as above except it attempts to shift ALL turfs in the world regardless of lighting_changed status
//Does not loop. Should be run prior to process() being called for the first time.
//Note: if we get additional z-levels at runtime (e.g. if the gateway thin ever gets finished) we can initialize specific
//z-levels with the z_level argument
/datum/controller/lighting/proc/Initialize(var/z_level)
	processing = 0

	for(var/thing in global_changed_lights)
		var/datum/light_source/L = thing
		if(L)
			L.check()
	global_changed_lights.Cut()


	var/z_start = 1
	var/z_finish = world.maxz
	if(z_level)
		z_level = round(z_level,1)
		if(z_level > 0 && z_level <= world.maxz)
			z_start = z_level
			z_finish = z_level

	var/list/init_turfs = block(locate(1,1,z_start),locate(world.maxx,world.maxy,z_finish))

	for(var/turf/thing in init_turfs)
		if(istype(thing))
			thing.shift_to_subarea()
/*
	for(var/k=z_start,k<=z_finish,k++)
		for(var/i=1,i<=world.maxx,i++)
			for(var/j=1,j<=world.maxy,j++)
				var/turf/T = locate(i,j,k)
				if(T)	T.shift_to_subarea()
*/
	changed_turfs.Cut()		// reset the changed list
	processing = 1
	spawn(1) //gvd is this what they forgot
		process() //Start the processor loop

//Used to strip valid information from an existing controller and transfer it to a replacement
//It works by using spawn(-1) to transfer the data, if there is a runtime the data does not get transfered but the loop
//does not crash
/datum/controller/lighting/proc/Recover()
	if(!istype(lighting_controller.changed_turfs,/list))
		lighting_controller.changed_turfs = null
		lighting_controller.changed_turfs = list()
	global_changed_lights = null
	global_changed_lights = list()


/*
	for(var/thing in lighting_controller.changed_lights)
		var/datum/light_source/L = thing
		spawn(-1)			//so we don't crash the loop (inefficient)
			if(istype(L)
				L.check()

	for(var/thing in lighting_controller.changed_turfs)
		var/turf/T = thing
		if(istype(T) && T.lighting_changed)
			spawn(-1)
				T.shift_to_subarea()
*/
	lighting_controller.Initialize()

	var/msg = "## DEBUG: [time2text(world.timeofday)] lighting_controller restarted. Reports:\n"
	for(var/varname in lighting_controller.vars)
		switch(varname)
			if("tag","bestF","type","parent_type","vars")	continue
			else
				var/varval1 = lighting_controller.vars[varname]
				var/varval2 = vars[varname]
				if(istype(varval1,/list))
					varval1 = "/list([length(varval1)])"
					varval2 = "/list([length(varval2)])"
				msg += "\t [varname] = [varval1] -> [varval2]\n"
	world.log << msg

#undef LIGHTING_ICON
#undef LIGHTING_STATES
