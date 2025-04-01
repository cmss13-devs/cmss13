
/proc/power_failure(announce = 1)
	var/ship_zlevels = SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP)

	for(var/obj/structure/machinery/power/smes/S in GLOB.machines)
		if(!is_mainship_level(S.z))
			continue
		S.last_charge = S.charge
		S.last_output = S.output_level
		S.last_outputting = S.outputting
		S.charge = 0
		S.output_level = 0
		S.outputting = 0
		S.updateicon()
		S.power_change()

	for(var/obj/structure/machinery/power/apc/C in GLOB.machines)
		if(!is_mainship_level(C.z) && C.cell)
			C.cell.charge = 0

	playsound_z(ship_zlevels, 'sound/effects/powerloss.ogg')

	sleep(100)
	if(announce)
		marine_announcement("Abnormal activity detected in the ship power system. As a precaution, power must be shut down for an indefinite duration.", "Critical Power Failure", 'sound/AI/poweroff.ogg')

/proc/power_restore(announce = 1)
	for(var/obj/structure/machinery/power/smes/S in GLOB.machines)
		if(!is_mainship_level(S.z))
			continue
		S.charge = S.capacity
		S.output_level = S.output_level_max
		S.outputting = 1
		S.updateicon()
		S.power_change()

	for(var/obj/structure/machinery/power/apc/C in GLOB.machines)
		if(C.cell && is_mainship_level(C.z))
			C.cell.charge = C.cell.maxcharge

	sleep(100)
	if(announce)
		marine_announcement("Power has been restored. Reason: Unknown.", "Power Systems Nominal", 'sound/AI/poweron.ogg')

/proc/power_restore_quick(announce = 1)

	for(var/obj/structure/machinery/power/smes/S in GLOB.machines)
		if(!is_mainship_level(S.z)) // Ship only
			continue
		S.charge = S.capacity
		S.output_level = S.output_level_max
		S.outputting = 1
		S.updateicon()
		S.power_change()

	sleep(100)
	if(announce)
		marine_announcement("Power has been restored. Reason: Unknown.", "Power Systems Nominal", 'sound/AI/poweron.ogg')

/proc/power_restore_everything(announce = 1)

	for(var/obj/structure/machinery/power/smes/S in GLOB.machines)
		S.charge = S.capacity
		S.output_level = S.output_level_max
		S.outputting = 1
		S.updateicon()
		S.power_change()

	for(var/obj/structure/machinery/power/apc/C in GLOB.machines)
		if(C.cell)
			C.cell.charge = C.cell.maxcharge

	sleep(100)
	if(announce)
		marine_announcement("Power has been restored. Reason: Unknown.", "Power Systems Nominal", 'sound/AI/poweron.ogg')

/proc/power_restore_ship_reactors(announce = TRUE)
	for(var/obj/structure/machinery/power/reactor/reactor in GLOB.machines)
		if(!is_mainship_level(reactor.z)) //Only ship reactors should be repaired
			continue
		reactor.buildstate = 0
		if(reactor.require_fusion_cell && !reactor.fusion_cell)
			reactor.fusion_cell = new
		reactor.power_gen_percent = 98
		reactor.start_functioning(TRUE)

	if(announce)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(marine_announcement), "Power has been restored. Reason: Unknown.", "Power Systems Nominal", 'sound/AI/poweron.ogg'), 10 SECONDS)
