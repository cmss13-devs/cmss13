#define SHUTTLE_GETTY "gettysburg"
#define SHUTTLE_GETTY_CUSTOM "gettysburg_custom"

#define STATE_ON_SHIP "on_ship"
#define STATE_ON_GROUND "on_ground"
#define STATE_IN_ATMOSPHERE "in_atmosphere"
#define STATE_IN_TRANSIT "in_transit"

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
	callTime = 15 SECONDS
	rechargeTime = 30 SECONDS
	dwidth = 0
	dheight = 0
	port_direction = SOUTH
	shuttle_flags = GAMEMODE_IMMUNE

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
	var/transit_to
	var/damaged = FALSE

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	tgui_interact(user)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "MidwayConsole", name)
		ui.open()

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/mob/user = usr

	switch(action)
		if("from_ship")
			takeoff(user)
		if("to_ship")
			to_ship(user)
		if("view_ground")
			view_ground(user)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/shuttle_arrived()
	if(current_state == STATE_IN_TRANSIT)
		if(transit_to == STATE_IN_ATMOSPHERE)
			addtimer(CALLBACK(src, PROC_REF(move_to_atmosphere)), 1 SECONDS)
			return
		if(transit_to == STATE_ON_SHIP)
			addtimer(CALLBACK(src, PROC_REF(move_to_ship)), 1 SECONDS)
			return

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/take_off(mob/user)
	if(current_state == SHUTTLE_ON_SHIP && !transit_to)
		from_ship(user)

	if(current_state == SHUTTLE_ON_GROUND && !transit_to)
		from_ground(user)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/from_ship(mob/user)
	if(current_state != SHUTTLE_ON_SHIP || transit_to)
		return

	shuttle_port = SSshuttle.getShuttle(shuttleId)
	shuttle_port.shuttle_computer = src

	if(!(shuttle_port.shuttle_flags & GAMEMODE_IMMUNE) && world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(user, SPAN_WARNING("The shuttle is still undergoing pre-flight fueling and cannot depart yet. Please wait another [round((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK-world.time)/600)] minutes before trying again."))
		return

	if(!COOLDOWN_FINISHED(src, launch_cooldown))
		to_chat(user, SPAN_WARNING("Engines are cooling down. Wait a moment."))

	current_state = STATE_IN_TRANSIT
	transit_to = STATE_IN_ATMOSPHERE
	SSshuttle.move_shuttle_to_transit(shuttleId, TRUE)
	shuttle_port.assigned_transit.reserved_area.set_turf(/turf/open/space/transit)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/move_to_atmosphere()
	current_state = STATE_IN_ATMOSPHERE
	transit_to = null
	SSshuttle.move_shuttle_to_transit(shuttleId, TRUE, /turf/open/space/transit/atmosphere)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/move_to_ship()
	current_state = STATE_ON_SHIP
	transit_to = null
	SSshuttle.moveShuttle(shuttleId, SHUTTLE_GETTY, TRUE)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/to_ship()
	current_state = STATE_IN_TRANSIT
	transit_to = STATE_ON_SHIP
	SSshuttle.move_shuttle_to_transit(shuttleId, TRUE)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/from_ground()
	transit_to = STATE_IN_ATMOSPHERE
	SSshuttle.move_shuttle_to_transit(shuttleId, TRUE, /turf/open/space/transit/atmosphere)


/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/view_ground(mob/user)
	if(!(current_state == STATE_IN_ATMOSPHERE && transit_to == null))
		return

	open_prompt(user)
