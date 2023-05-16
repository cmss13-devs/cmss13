/datum/map_template/interior
	name = "Base Interior Template"
	var/prefix = "maps/interiors/"
	var/interior_id = "SHOULD NEVER EXIST"


/datum/map_template/interior/New()
	if(interior_id == "SHOULD NEVER EXIST")
		stack_trace("invalid interior datum")
	mappath = "[prefix][interior_id].dmm"
	return ..()

/datum/map_template/interior/apc
	name = "APC"
	interior_id = "apc"

/datum/map_template/interior/apc_command
	name = "Command APC"
	interior_id = "apc_command"

/datum/map_template/interior/apc_med
	name = "Med APC"
	interior_id = "apc_med"

/datum/map_template/interior/apc_no_fpw
	name = "APC - No FPW"
	interior_id = "apc_no_fpw"

/datum/map_template/interior/fancy_locker
	name = "Fancy Locker"
	interior_id = "fancylocker"

/datum/map_template/interior/tank
	name = "Tank"
	interior_id = "tank"

/datum/map_template/interior/van
	name = "Van"
	interior_id = "van"
