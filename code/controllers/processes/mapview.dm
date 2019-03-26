//var/global/current_squad_overlay = 1
/var/global/next_map_gen = 0

datum/controller/process/mapview
	var/list/map_machines

datum/controller/process/mapview/setup()
	name = "Mapview"
	schedule_interval = 20 //1 seconds
	map_machines = list()
	for(var/obj/machinery/C in machines)
		if(istype(C, /obj/machinery/computer/communications) || istype(C, /obj/machinery/prop/almayer/CICmap) || istype(C, /obj/machinery/computer/overwatch))
			map_machines += C

	generate_marine_mapview()
	generate_xeno_mapview()

datum/controller/process/mapview/doWork()

	if(world.time > next_map_gen)
		generate_xeno_mapview()
		individual_ticks++
		next_map_gen = world.time + MINUTES_10

	for(var/mob/living/carbon/Xenomorph/Queen/Q in living_xeno_list)
		if(Q.map_view)
			overlay_xeno_mapview(Q.hivenumber)
			individual_ticks++
			break

	if(RoleAuthority)
		//if(current_squad_overlay == 5)
		//world << "overlay_marine_mapview(all squads)"
		var/update = 0
		for(var/obj/machinery/MM in map_machines)
			var/obj/machinery/computer/communications/C = MM
			if(istype(C) && C.current_mapviewer)
				overlay_marine_mapview()
				update = 1
				C.update_mapview()
				individual_ticks++

			var/obj/machinery/prop/almayer/CICmap/M = MM
			if(istype(M) && M.current_viewers.len)
				if(!update)
					overlay_marine_mapview()
				M.update_mapview()
				individual_ticks++

			var/obj/machinery/computer/overwatch/O = MM
			if(istype(O) && O.current_squad && O.current_mapviewer)
				overlay_marine_mapview(O.current_squad)
				O.update_mapview()
				individual_ticks++