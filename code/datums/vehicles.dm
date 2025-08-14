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

/datum/map_template/interior/apc_pmc
	name = "W-Y APC"
	interior_id = "apc_pmc"

/datum/map_template/interior/apc_command
	name = "Command APC"
	interior_id = "apc_command"

/datum/map_template/interior/apc_med
	name = "Med APC"
	interior_id = "apc_med"

/datum/map_template/interior/apc_no_fpw
	name = "APC - No FPW"
	interior_id = "apc_no_fpw"

/datum/map_template/interior/tank
	name = "Tank"
	interior_id = "tank"

/datum/map_template/interior/van
	name = "Van"
	interior_id = "van"

/datum/map_template/interior/clf_van
	name = "CLF Technical"
	interior_id = "clf_van"

/datum/map_template/interior/box_van
	name = "Box Van"
	interior_id = "box_van"

/datum/map_template/interior/pizza_van
	name = "Pizza-Galaxy Van"
	interior_id = "pizza_van"

/datum/map_template/interior/arc
	name = "ARC"
	interior_id = "arc"

/datum/map_template/interior/blackfoot
	name = "blackfoot base"
	interior_id = "blackfoot"

/datum/map_template/interior/blackfoot_doorgun
	name = "blackfoot doorgun"
	interior_id = "blackfoot_doorgun"

/datum/map_template/interior/blackfoot_transport
	name = "blackfoot transport"
	interior_id = "blackfoot_transport"
