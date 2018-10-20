//var/global/current_squad_overlay = 1
/var/global/next_map_gen = 0

var/datum/subsystem/mapview/SSmapview


/datum/subsystem/mapview
	name          = "Mapview"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_MAPVIEW
	display_order = SS_DISPLAY_UNSPECIFIED

/datum/subsystem/mapview/New()
	NEW_SS_GLOBAL(SSmapview)

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
			overlay_xeno_mapview()
			break

	if (MC_TICK_CHECK)
		return

	if(RoleAuthority)
		//if(current_squad_overlay == 5)
		//to_chat(world, "overlay_marine_mapview(all squads)")
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
				//to_chat(world, "overlay_marine_mapview([O.current_squad.name])")
				overlay_marine_mapview(O.current_squad)
				O.update_mapview()

				if (MC_TICK_CHECK)
					return
	//current_squad_overlay++
	//if(current_squad_overlay > 5) current_squad_overlay = 1
