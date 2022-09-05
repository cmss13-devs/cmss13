datum

var/global/enable_power_update_profiling = 0

var/global/power_profiled_time = 0
var/global/power_last_profile_time = 0
var/global/list/power_update_requests_by_machine = list()
var/global/list/power_update_requests_by_area = list()

/proc/log_power_update_request(area/A, obj/structure/machinery/M)
	if (!enable_power_update_profiling)
		return

	var/machine_type = "[M.type]"
	if (machine_type in power_update_requests_by_machine)
		power_update_requests_by_machine[machine_type]++
	else
		power_update_requests_by_machine[machine_type] = 1

	if (A.name in power_update_requests_by_area)
		power_update_requests_by_area[A.name]++
	else
		power_update_requests_by_area[A.name] = 1

	power_profiled_time += (world.time - power_last_profile_time)
	power_last_profile_time = world.time

/client/proc/toggle_power_update_profiling()
	set name = "Toggle Area Power Update Profiling"
	set desc = "Toggles the recording of area power update requests."
	set category = "Debug.Profiling"
	if(!check_rights(R_DEBUG))	return
	if(!ishost(usr) || alert("Are you sure you want to do this?",, "Yes", "No") == "No") return
	if(enable_power_update_profiling)
		enable_power_update_profiling = 0

		to_chat(usr, "Area power update profiling disabled.")
		message_staff("[key_name(src)] toggled area power update profiling off.")
	else
		enable_power_update_profiling = 1
		power_last_profile_time = world.time

		to_chat(usr, "Area power update profiling enabled.")
		message_staff("[key_name(src)] toggled area power update profiling on.")



/client/proc/view_power_update_stats_machines()
	set name = "View Area Power Update Statistics By Machines"
	set desc = "See which types of machines are triggering area power updates."
	set category = "Debug.Profiling"

	if(!check_rights(R_DEBUG))	return

	to_chat(usr, "Total profiling time: [power_profiled_time] ticks")
	for (var/M in power_update_requests_by_machine)
		to_chat(usr, "[M] = [power_update_requests_by_machine[M]]")

/client/proc/view_power_update_stats_area()
	set name = "View Area Power Update Statistics By Area"
	set desc = "See which areas are having area power updates."
	set category = "Debug.Profiling"

	if(!check_rights(R_DEBUG))	return

	to_chat(usr, "Total profiling time: [power_profiled_time] ticks")
	to_chat(usr, "Total profiling time: [power_profiled_time] ticks")
	for (var/A in power_update_requests_by_area)
		to_chat(usr, "[A] = [power_update_requests_by_area[A]]")
