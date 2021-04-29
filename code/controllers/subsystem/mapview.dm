SUBSYSTEM_DEF(mapview)
	name          = "Mapview"
	wait          = 2 SECONDS
	flags         = SS_POST_FIRE_TIMING | SS_DISABLE_FOR_TESTING
	runlevels     = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	priority      = SS_PRIORITY_MAPVIEW
	init_order    = SS_INIT_MAPVIEW
	var/list/map_machines
	var/ready = FALSE
	var/updated = FALSE
	var/list/currentrun

/datum/controller/subsystem/mapview/Initialize(start_timeofday)
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, .proc/pre_round_start)
	return ..()

/datum/controller/subsystem/mapview/proc/pre_round_start()
	SIGNAL_HANDLER
	generate_marine_mapview()
	create_map_machines()
	ready = TRUE

/datum/controller/subsystem/mapview/proc/create_map_machines()
	map_machines = list()
	for(var/obj/structure/machinery/C in machines)
		if(istype(C, /obj/structure/machinery/computer/communications) || istype(C, /obj/structure/machinery/prop/almayer/CICmap) || istype(C, /obj/structure/machinery/computer/overwatch))
			map_machines += C

/datum/controller/subsystem/mapview/fire(resumed = FALSE)
	if(!ready || !RoleAuthority)
		return
	if(!resumed)
		currentrun = map_machines.Copy()
		updated = FALSE

	while(length(currentrun))
		var/obj/structure/machinery/MM = currentrun[currentrun.len]
		currentrun.len--

		var/obj/structure/machinery/computer/communications/C = MM
		if(istype(C) && C.current_mapviewer)
			if(!updated)
				overlay_marine_mapview()
			C.update_mapview()
			updated = TRUE

		var/obj/structure/machinery/prop/almayer/CICmap/M = MM
		if(istype(M) && M.current_viewers.len)
			if(!updated)
				overlay_marine_mapview()
			M.update_mapview()
			updated = TRUE

		var/obj/structure/machinery/computer/overwatch/O = MM
		if(istype(O) && O.current_squad && O.current_mapviewer)
			O.update_mapview()

		if (MC_TICK_CHECK)
			return
