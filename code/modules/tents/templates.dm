/datum/map_template/tent
	name = "Base Tent"
	var/map_id = "change this"

/datum/map_template/tent/New()
	mappath = "maps/tents/[map_id].dmm"
	return ..()

/datum/map_template/tent/cmd
	name = "CMD Tent"
	map_id = "tent_cmd"

/datum/map_template/tent/med
	name = "MED Tent"
	map_id = "tent_med"

/datum/map_template/tent/big
	name = "Big Tent"
	map_id = "tent_big"

/datum/map_template/tent/reqs
	name = "Reqs Tent"
	map_id = "tent_reqs"

/datum/map_template/tent/cmda
	name = "CMD Tent alpha"
	map_id = "tent_cmd_alpha"

/datum/map_template/tent/cmdb
	name = "CMD Tent bravo"
	map_id = "tent_cmd_bravo"

/datum/map_template/tent/cmdc
	name = "CMD Tent charlie"
	map_id = "tent_cmd_charlie"
