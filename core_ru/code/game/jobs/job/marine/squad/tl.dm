/datum/job/marine/tl/get_total_positions(latejoin = FALSE)
	var/real_max_positions = 0
	for(var/datum/squad/squad in GLOB.RoleAuthority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_MARINE && squad.name != "Root")
			real_max_positions += squad.roles_cap[title]

	if(real_max_positions > total_positions_so_far)
		total_positions_so_far = real_max_positions

	spawn_positions = real_max_positions

	return real_max_positions
