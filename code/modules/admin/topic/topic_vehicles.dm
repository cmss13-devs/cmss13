/datum/admins/proc/topic_vehicles(var/href)
	switch(href)
		if("remove_clamp")
			owner.remove_clamp_from_vic()
		if("remove_players")
			owner.remove_players_from_vic()

/client/proc/remove_players_from_vic()
	set name = "Remove All From Tank"
	set category = null

	for(var/obj/vehicle/multitile/CA in view())
		CA.handle_all_modules_broken()
		log_admin("[src] forcibly removed all players from [CA]")
		message_admins("[src] forcibly removed all players from [CA]")

/client/proc/remove_clamp_from_vic()
	set name = "Remove Clamp From Vehicle"
	set category = null

	for(var/obj/vehicle/multitile/CA in view())
		if(!CA.clamped)
			return
		CA.detach_clamp()
		log_admin("[src] forcibly removed Vehicle Clamp [CA]")
		message_admins("[src] forcibly removed Vehicle Clamp [CA]")
