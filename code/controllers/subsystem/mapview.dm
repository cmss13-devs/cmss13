//var/global/current_squad_overlay = 1
/var/global/next_map_gen = 0

var/datum/subsystem/mapview/SSmapview

/datum/subsystem/mapview
	name          = "Mapview"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_MAPVIEW
	display_order = SS_DISPLAY_UNSPECIFIED
	var/list/map_machines

/datum/subsystem/mapview/New()
	NEW_SS_GLOBAL(SSmapview)
	spawn(20)
		create_map_machines()

/datum/subsystem/mapview/proc/create_map_machines()
	map_machines = list()
	for(var/obj/structure/machinery/C in machines)
		if(istype(C, /obj/structure/machinery/computer/communications) || istype(C, /obj/structure/machinery/prop/almayer/CICmap) || istype(C, /obj/structure/machinery/computer/overwatch))
			map_machines += C

///datum/subsystem/mob/stat_entry()
//	..("P:[mob_list.len]")

/datum/subsystem/mapview/fire(resumed = FALSE)

	if(world.time > next_map_gen)
		generate_xeno_mapview()
		next_map_gen = world.time + 6000

	if (MC_TICK_CHECK)
		return

	for(var/mob/living/carbon/Xenomorph/Queen/Q in living_xeno_list)
		if(Q.map_view)
			Q.update_mapview(FALSE, TRUE)
			break

	if (MC_TICK_CHECK)
		return

	if(RoleAuthority)
		//if(current_squad_overlay == 5)
		var/update = 0
		for(var/obj/structure/machinery/MM in map_machines)
			var/obj/structure/machinery/computer/communications/C = MM
			if(istype(C) && C.current_mapviewer)
				overlay_marine_mapview()
				update = 1
				C.update_mapview()

			var/obj/structure/machinery/prop/almayer/CICmap/M = MM
			if(istype(M) && M.current_viewers.len)
				if(!update)
					overlay_marine_mapview()
				M.update_mapview()

			var/obj/structure/machinery/computer/overwatch/O = MM
			if(istype(O) && O.current_squad && O.current_mapviewer)
				O.update_mapview()

				if (MC_TICK_CHECK)
					return
	//current_squad_overlay++
	//if(current_squad_overlay > 5) current_squad_overlay = 1
