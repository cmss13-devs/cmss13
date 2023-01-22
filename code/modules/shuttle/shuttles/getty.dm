#define SHUTTLE_GETTY "gettysburg"

/obj/docking_port/stationary/getty
	name = "Gettysburg Hangar Pad"
	id = SHUTTLE_GETTY
	roundstart_template = /datum/map_template/shuttle/getty
	width = 10
	height = 11

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
