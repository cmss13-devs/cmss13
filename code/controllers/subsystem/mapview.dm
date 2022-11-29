SUBSYSTEM_DEF(mapview)
	name          = "Mapview"
	wait          = 1 MINUTES
	flags         = SS_POST_FIRE_TIMING
	runlevels     = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	priority      = SS_PRIORITY_MAPVIEW
	init_order    = SS_INIT_MAPVIEW
	var/list/map_machines = list()
	var/ready = FALSE
	var/updated = FALSE
	var/list/currentrun

/datum/controller/subsystem/mapview/Initialize(start_timeofday)
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, .proc/pre_round_start)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapview/proc/pre_round_start()
	SIGNAL_HANDLER
	generate_tacmap(TACMAP_BASE_OCCLUDED) // for orbital forces
	generate_tacmap(TACMAP_BASE_OPEN) // for groundside forces
	ready = TRUE

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
				overlay_tacmap(TACMAP_DEFAULT)
			C.update_mapview()
			updated = TRUE

		var/obj/structure/machinery/prop/almayer/CICmap/M = MM
		if(istype(M) && M.current_viewers.len)
			M.update_mapview()

		var/obj/structure/machinery/computer/overwatch/O = MM
		if(istype(O) && O.current_squad && O.current_mapviewer)
			O.update_mapview()

		if (MC_TICK_CHECK)
			return
