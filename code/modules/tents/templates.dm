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

/datum/map_template/tent/mess
	name = "Mess Tent"
	map_id = "tent_mess"
