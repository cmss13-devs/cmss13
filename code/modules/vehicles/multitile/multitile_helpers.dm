
/client/proc/remove_players_from_vehicle()
	set name = "Remove All From Tank"
	set category = "Admin"

	for(var/obj/vehicle/multitile/R in view())
		R.remove_all_players()
		message_staff("[src] forcibly removed all players from [R]")

/client/proc/remove_clamp_from_vehicle()
	set name = "Remove Clamp From Vehicle"
	set category = "Admin"

	for(var/obj/vehicle/multitile/R in view())
		if(!R.clamped)
			return
		R.detach_clamp()
		message_staff("[src] forcibly removed Vehicle Clamp [R]")