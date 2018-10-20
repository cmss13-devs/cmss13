//var/global/current_squad_overlay = 1
/var/global/next_map_gen = 0

datum/controller/process/mapview

datum/controller/process/mapview/setup()
	name = "Mapview"
	schedule_interval = 20 //1 seconds
	generate_marine_mapview()
	generate_xeno_mapview()

datum/controller/process/mapview/doWork()

	if(world.time > next_map_gen)
		generate_xeno_mapview()
		next_map_gen = world.time + 6000

	for(var/mob/living/carbon/Xenomorph/Queen/Q in living_xeno_list)
		if(Q.map_view)
			overlay_xeno_mapview()
			break

	if(RoleAuthority)
		//if(current_squad_overlay == 5)
		//world << "overlay_marine_mapview(all squads)"
		var/update = 0
		for(var/obj/machinery/computer/communications/C in machines)
			if(C.current_mapviewer)
				overlay_marine_mapview()
				update = 1
				C.update_mapview()

		for(var/obj/machinery/prop/almayer/CICmap/M in machines)
			if(M.current_viewers.len)
				if(!update)
					overlay_marine_mapview()
				M.update_mapview()

		for(var/obj/machinery/computer/overwatch/O in machines)
			if(O.current_squad && O.current_mapviewer) // only actually update if someone is using it
				//world << "overlay_marine_mapview([O.current_squad.name])"
				overlay_marine_mapview(O.current_squad)
				O.update_mapview()
	//current_squad_overlay++
	//if(current_squad_overlay > 5) current_squad_overlay = 1
