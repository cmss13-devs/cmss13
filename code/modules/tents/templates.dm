/datum/map_template/tent
	name = "Base Tent"
	var/map_id = "change this"

/datum/map_template/tent/New()
	mappath = "maps/tents/[map_id].dmm"
	return ..()

/datum/map_template/tent/cmd
	name = "CMD Tent"
	map_id = "tent_cmd"
