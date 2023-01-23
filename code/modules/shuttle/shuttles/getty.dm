#define SHUTTLE_GETTY "gettysburg"
#define SHUTTLE_GETTY_CUSTOM "gettysburg_custom"

/obj/docking_port/stationary/getty
	name = "Gettysburg Hangar Pad"
	id = SHUTTLE_GETTY
	roundstart_template = /datum/map_template/shuttle/getty
	width = 8
	height = 10

/datum/map_template/shuttle/getty
	name = "Gettysburg"
	shuttle_id = "getty"

/obj/docking_port/mobile/getty
	name = "Gettysburg"
	id = "dropship_getty"
	ignitionTime = DROPSHIP_WARMUP_TIME
	area_type = /area/shuttle/getty
	width = 10
	height = 11
	callTime = 30 SECONDS
	rechargeTime = 30 SECONDS
	dwidth = 0
	dheight = 0
	port_direction = SOUTH

/obj/structure/machinery/computer/shuttle/getty
	name = "\"Gettysburg\" transit computer"
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "consoleright"
	unacidable = TRUE
	indestructible = TRUE
	req_one_access = list(ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LEADER)
	shuttleId = SHUTTLE_GETTY
	possible_destinations = list(SHUTTLE_GETTY, SHUTTLE_GETTY_CUSTOM)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty
	name = "\"Gettysburg\" navigation computer"
	desc = "Used to designate a precise transit location for the Gettysburg."
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "consoleleft"
	req_one_access = list(ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LEADER)
	shuttleId = SHUTTLE_GETTY
	lock_override = CAMERA_LOCK_GROUND
	shuttlePortId = list(SHUTTLE_GETTY_CUSTOM)
	view_range = "26x26"
	x_offset = 4
	y_offset = 5
	designate_time = 10 SECONDS
	indestructible = TRUE
	unacidable = TRUE
	open_prompt = FALSE

	var/current_state = STATE_ON_SHIP
	var/damaged = FALSE




