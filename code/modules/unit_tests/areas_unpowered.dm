/datum/unit_test/areas_unpowered
	priority = TEST_PRE // Don't want machines from other tests
	stage = TEST_STAGE_GAME

	/// Assoc list per area containing an assoc list per machine.type containing count of that type
	var/list/areas_with_machines = list()
	/// Assoc list of machine.types containing notes that don't have an area
	var/list/types_with_no_area = list()
	/// List of floor turf types that aren't suitable for terminals
	var/list/floor_turfs_unsuitable = list(/turf/open/floor/almayer/empty, /turf/open/floor/holofloor)

/datum/unit_test/areas_unpowered/pre_game
	stage = TEST_STAGE_PREGAME // Also run the test during pregame to test w/o nightmare inserts

/datum/unit_test/areas_unpowered/pre_game/Run()
	return ..() // Just to satisfy Tgstation Test Explorer extension

/datum/unit_test/areas_unpowered/proc/determine_areas_needing_power()
	for(var/obj/structure/machinery/machine as anything in GLOB.machines)
		if(!machine)
			types_with_no_area[""] = "NULL at Invalid location"
			continue
		if(machine.needs_power)
			var/area/machine_area = get_step(machine, 0)?.loc // get_area without the area check
			if(!machine_area)
				if(!types_with_no_area[machine.type])
					types_with_no_area[machine.type] = "[machine][QDELETED(machine) ? " (QDELETED)" : ""] at [get_location_in_text(machine, FALSE)]"
				continue
			if(!areas_with_machines[machine_area])
				areas_with_machines[machine_area] = list()
			areas_with_machines[machine_area][machine.type]++

/datum/unit_test/areas_unpowered/Run()
	determine_areas_needing_power()

	for(var/bad_machine_type in types_with_no_area)
		TEST_FAIL("[types_with_no_area[bad_machine_type]] ([bad_machine_type]) has no area!")

	for(var/area/cur_area as anything in areas_with_machines)
		var/list/found_apcs = list()
		var/any_inaccessible = FALSE
		for(var/obj/structure/machinery/power/apc/cur_apc in cur_area)
			found_apcs += cur_apc
			var/turf/apc_turf = cur_apc.loc
			if(!istype(apc_turf, /turf/open/floor) && apc_turf.intact_tile)
				any_inaccessible = TRUE
			else if(is_type_in_list(apc_turf, floor_turfs_unsuitable))
				any_inaccessible = TRUE

		var/apc_count = length(found_apcs)
		if(apc_count == 1)
			if(any_inaccessible)
				var/obj/structure/machinery/power/apc/cur_apc = found_apcs[1]
				var/apc_notes = "APC loc: ([cur_apc.x],[cur_apc.y]) [cur_apc.loc?.type]"
				TEST_FAIL("[cur_area] ([cur_area.type]) has an APC with an inaccessible terminal!\n\t[apc_notes]")
			continue // Pass
		if(apc_count > 1)
			var/apc_notes = "APC locs: "
			for(var/i in 1 to apc_count)
				var/obj/structure/machinery/power/apc/cur_apc = found_apcs[i]
				apc_notes += "([cur_apc.x],[cur_apc.y])"
				if(i != apc_count)
					apc_notes += ", "
			TEST_FAIL("[cur_area] ([cur_area.type]) has [apc_count] APCs!\n\t[apc_notes]")
			continue

		if(!cur_area.requires_power)
			continue
		if(cur_area.unlimited_power)
			continue
		if(cur_area.always_unpowered)
			continue

		// Count all machines and note the first 5 types
		var/machine_type_count = length(areas_with_machines[cur_area])
		var/machine_total_count = 0
		var/i = 0
		var/machine_notes = "Machine types: "
		for(var/machine_type in areas_with_machines[cur_area])
			machine_total_count += areas_with_machines[cur_area][machine_type]
			if(++i <= 5)
				machine_notes += "[machine_type]"
				if(i != machine_type_count)
					machine_notes += ", "

		if(machine_type_count > 5)
			machine_notes += "..."

		TEST_FAIL("[cur_area] ([cur_area.type]) lacks an APC but requires power for [machine_total_count] machine\s!\n\t[machine_notes]")
