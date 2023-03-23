
/proc/power_failure(announce = 1)
	var/ship_zlevels = SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP)

	for(var/obj/structure/machinery/power/smes/smes in machines)
		if(!is_mainship_level(smes.z))
			continue
		smes.last_charge = smes.charge
		smes.last_output = smes.output_level
		smes.last_outputting = smes.outputting
		smes.charge = 0
		smes.output_level = 0
		smes.outputting = 0
		smes.updateicon()
		smes.power_change()

	for(var/obj/structure/machinery/power/apc/apc_cell in machines)
		if(!is_mainship_level(apc_cell.z) && apc_cell.cell)
			apc_cell.cell.charge = 0

	playsound_z(ship_zlevels, 'sound/effects/powerloss.ogg')

	sleep(100)
	if(announce)
		marine_announcement("Abnormal activity detected in the ship power system. As a precaution, power must be shut down for an indefinite duration.", "Critical Power Failure", 'sound/AI/poweroff.ogg')

/proc/power_restore(announce = 1)
	for(var/obj/structure/machinery/power/smes/smes in machines)
		if(!is_mainship_level(smes.z))
			continue
		smes.charge = smes.capacity
		smes.output_level = smes.output_level_max
		smes.outputting = 1
		smes.updateicon()
		smes.power_change()

	for(var/obj/structure/machinery/power/apc/apc_cell in machines)
		if(apc_cell.cell && is_mainship_level(apc_cell.z))
			apc_cell.cell.charge = apc_cell.cell.maxcharge

	sleep(100)
	if(announce)
		marine_announcement("Power has been restored. Reason: Unknown.", "Power Systems Nominal", 'sound/AI/poweron.ogg')

/proc/power_restore_quick(announce = 1)

	for(var/obj/structure/machinery/power/smes/smes in machines)
		if(!is_mainship_level(smes.z)) // Ship only
			continue
		smes.charge = smes.capacity
		smes.output_level = smes.output_level_max
		smes.outputting = 1
		smes.updateicon()
		smes.power_change()

	sleep(100)
	if(announce)
		marine_announcement("Power has been restored. Reason: Unknown.", "Power Systems Nominal", 'sound/AI/poweron.ogg')

/proc/power_restore_everything(announce = 1)

	for(var/obj/structure/machinery/power/smes/smes in machines)
		smes.charge = smes.capacity
		smes.output_level = smes.output_level_max
		smes.outputting = 1
		smes.updateicon()
		smes.power_change()

	for(var/obj/structure/machinery/power/apc/apc_cell in machines)
		if(apc_cell.cell)
			apc_cell.cell.charge = apc_cell.cell.maxcharge

	sleep(100)
	if(announce)
		marine_announcement("Power has been restored. Reason: Unknown.", "Power Systems Nominal", 'sound/AI/poweron.ogg')

/proc/power_restore_ship_reactors(announce = 1)
	for(var/obj/structure/machinery/power/fusion_engine/FE in machines)
		FE.buildstate = 0
		FE.is_on = 1
		FE.fusion_cell = new
		FE.power_gen_percent = 98
		FE.update_icon()
		FE.start_processing()
		FE.power_change()

	sleep(100)
	if(announce)
		marine_announcement("Power has been restored. Reason: Unknown.", "Power Systems Nominal", 'sound/AI/poweron.ogg')
