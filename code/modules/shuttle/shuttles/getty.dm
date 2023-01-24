#define SHUTTLE_GETTY "gettysburg"
#define SHUTTLE_GETTY_CUSTOM "gettysburg_custom"

#define STATE_ON_SHIP "on_ship"
#define STATE_ON_GROUND "on_ground"
#define STATE_IN_ATMOSPHERE "in_atmosphere"

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

	COOLDOWN_DECLARE(launch_cooldown)

	var/current_state = STATE_ON_SHIP
	var/damaged = FALSE

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/to_atmosphere()
	shuttle_port = SSshuttle.getShuttle(shuttleId)
	shuttle_port.shuttle_computer = src

	if(!(shuttle_port.shuttle_flags & GAMEMODE_IMMUNE) && world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(user, SPAN_WARNING("The shuttle is still undergoing pre-flight fueling and cannot depart yet. Please wait another [round((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK-world.time)/600)] minutes before trying again."))
		return

	if(!COOLDOWN_FINISHED)
		to_chat(user, SPAN_WARNING("Engines are cooling down. Wait a moment."))

	current_state = STATE_IN_ATMOSPHERE
	SSshuttle.move_shuttle_to_transit(shuttleId, TRUE)


/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/to_ship()
	SSshuttle.moveShuttle(shuttleId, shuttleId, TRUE)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/ui_state(mob/user)


