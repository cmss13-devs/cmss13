/datum/unit_test/areas_unpowered
	/// Assoc list per area containing an assoc list per machine.type containing count of that type
	var/list/areas_with_machines = list()

/datum/unit_test/areas_unpowered/proc/determine_areas_needing_power()
	for(var/obj/structure/machinery/machine as anything in GLOB.machines)
		if(machine.needs_power)
			var/area/machine_area = get_step(machine, 0)?.loc // get_area without the area check
			if(!areas_with_machines[machine_area])
				areas_with_machines[machine_area] = list()
			areas_with_machines[machine_area][machine.type]++

/datum/unit_test/areas_unpowered/Run()
	determine_areas_needing_power()

	for(var/area/cur_area as anything in areas_with_machines)
		if(!cur_area.requires_power)
			continue
		if(cur_area.unlimited_power)
			continue
		if(cur_area.always_unpowered)
			continue

		var/apc_count = 0
		for(var/obj/structure/machinery/power/apc/cur_apc in cur_area)
			apc_count++

		if(apc_count == 1)
			continue // Pass
		if(apc_count > 1)
			TEST_FAIL("[cur_area] ([cur_area.type]) has [apc_count] APCs!")
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
				if(i != machine_type_count && i < 5)
					machine_notes += ", "

		TEST_FAIL("[cur_area] ([cur_area.type]) lacks an APC but requires power for [machine_total_count] machine\s!\n\t[machine_notes]")
