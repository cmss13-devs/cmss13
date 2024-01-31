GLOBAL_VAR_INIT(enable_power_update_profiling, FALSE)

GLOBAL_VAR_INIT(power_profiled_time, 0)
GLOBAL_VAR_INIT(power_last_profile_time, 0)
GLOBAL_LIST_EMPTY(power_update_requests_by_machine)
GLOBAL_LIST_EMPTY(power_update_requests_by_area)

/proc/log_power_update_request(area/A, obj/structure/machinery/M)
	if (!GLOB.enable_power_update_profiling)
		return

	var/machine_type = "[M.type]"
	if (machine_type in GLOB.power_update_requests_by_machine)
		GLOB.power_update_requests_by_machine[machine_type]++
	else
		GLOB.power_update_requests_by_machine[machine_type] = 1

	if (A.name in GLOB.power_update_requests_by_area)
		GLOB.power_update_requests_by_area[A.name]++
	else
		GLOB.power_update_requests_by_area[A.name] = 1

	GLOB.power_profiled_time += (world.time - GLOB.power_last_profile_time)
	GLOB.power_last_profile_time = world.time

/client/proc/toggle_power_update_profiling()
	set name = "Toggle Area Power Update Profiling"
	set desc = "Toggles the recording of area power update requests."
	set category = "Debug.Profiling"
	if(!check_rights(R_DEBUG)) return
	if(!ishost(usr) || alert("Are you sure you want to do this?",, "Yes", "No") != "Yes") return
	if(GLOB.enable_power_update_profiling)
		GLOB.enable_power_update_profiling = 0

		to_chat(usr, "Area power update profiling disabled.")
		message_admins("[key_name(src)] toggled area power update profiling off.")
	else
		GLOB.enable_power_update_profiling = 1
		GLOB.power_last_profile_time = world.time

		to_chat(usr, "Area power update profiling enabled.")
		message_admins("[key_name(src)] toggled area power update profiling on.")



/client/proc/view_power_update_stats_machines()
	set name = "View Area Power Update Statistics By Machines"
	set desc = "See which types of machines are triggering area power updates."
	set category = "Debug.Profiling"

	if(!check_rights(R_DEBUG)) return

	to_chat(usr, "Total profiling time: [GLOB.power_profiled_time] ticks")
	for (var/M in GLOB.power_update_requests_by_machine)
		to_chat(usr, "[M] = [GLOB.power_update_requests_by_machine[M]]")

/client/proc/view_power_update_stats_area()
	set name = "View Area Power Update Statistics By Area"
	set desc = "See which areas are having area power updates."
	set category = "Debug.Profiling"

	if(!check_rights(R_DEBUG)) return

	to_chat(usr, "Total profiling time: [GLOB.power_profiled_time] ticks")
	to_chat(usr, "Total profiling time: [GLOB.power_profiled_time] ticks")
	for (var/A in GLOB.power_update_requests_by_area)
		to_chat(usr, "[A] = [GLOB.power_update_requests_by_area[A]]")
