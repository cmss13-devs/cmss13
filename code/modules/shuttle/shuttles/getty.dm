#define SHUTTLE_GETTY "gettysburg"
#define SHUTTLE_GETTY_CUSTOM "gettysburg_custom"

#define STATE_ON_SHIP "on ship"
#define STATE_ON_GROUND "on ground"
#define STATE_IN_ATMOSPHERE "in atmosphere"
#define STATE_IN_TRANSIT "in transit"

/obj/structure/dropship_parts/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS
		. &= ~MOVE_TURF

/obj/structure/dropship_parts
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/dropship_parts/ex_act(severity, direction)
	return

/obj/structure/dropship_parts/midway
	name = "\improper Midway"
	icon = 'icons/turf/getty.dmi'
	opacity = FALSE

/obj/structure/dropship_parts/midway/left/cockpit_upper
	icon_state = "cockpit_upperleft"
	opacity = TRUE

/obj/structure/dropship_parts/midway/right/cockpit_upper
	icon_state = "cockpit_upperright"
	opacity = TRUE

/obj/structure/dropship_parts/midway/left/body_upper
	icon_state = "wingwall_lefttop"
	opacity = TRUE

/obj/structure/dropship_parts/midway/right/body_upper
	icon_state = "wingwall_righttop"
	opacity = TRUE

/obj/structure/dropship_parts/midway/left/cap
	icon_state = "cap_left"

/obj/structure/dropship_parts/midway/right/cap
	icon_state = "cap_right"

/obj/structure/dropship_parts/midway/left/upper_wing
	icon_state = "wing_lefttop"

/obj/structure/dropship_parts/midway/right/upper_wing
	icon_state = "wing_righttop"

/obj/structure/dropship_parts/midway/left/lower_wing
	icon_state = "wing_leftbottom"

/obj/structure/dropship_parts/midway/right/lower_wing
	icon_state = "wing_rightbottom"

/obj/structure/dropship_parts/midway/left/engine_upper
	icon_state = "leftupperengine"

/obj/structure/dropship_parts/midway/right/engine_upper
	icon_state = "rightupperengine"

/obj/structure/dropship_parts/midway/left/engine_lower
	icon_state = "leftlowerengine"

/obj/structure/dropship_parts/midway/right/engine_lower
	icon_state = "rightlowerengine"

/obj/structure/dropship_parts/midway/left/body_lower
	icon_state = "leftlowerwalltoengine"
	opacity = TRUE

/obj/structure/dropship_parts/midway/right/body_lower
	icon_state = "rightlowerwalltoengine"
	opacity = TRUE

/obj/structure/dropship_parts/midway/left/wing_outer
	icon_state = "bottomwing_leftouter"

/obj/structure/dropship_parts/midway/left/wing_inner
	icon_state = "bottomwing_leftinner"


/obj/structure/dropship_parts/midway/right/wing_outer
	icon_state = "bottomwing_rightouter"

/obj/structure/dropship_parts/midway/right/wing_inner
	icon_state = "bottomwing_rightinner"

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
	width = 8
	height = 10
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
	var/transit_to = FALSE
	var/damaged = FALSE

	/// used for landing to a defined destination
	var/datum/action/innate/shuttledocker_land/land_action = new

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/give_actions(mob/living/user)
	if(!(current_state == STATE_IN_ATMOSPHERE))
		return

	. = ..()

	if(land_action)
		land_action.target = user
		land_action.give_to(user)
		actions += land_action

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

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/ui_data(mob/user)
	var/list/data = list()

	data["current_state"] = current_state
	data["current_mode"] = shuttle_port ? shuttle_port.mode : SHUTTLE_IDLE

	return data

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/mob/user = usr

	switch(action)
		if("take_off")
			take_off(user)
		if("to_ship")
			to_ship(user)
		if("view_ground")
			view_ground(user)
	. = TRUE

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/shuttle_arrived()
	if(current_state == STATE_IN_TRANSIT)
		if(transit_to == STATE_IN_ATMOSPHERE)
			addtimer(CALLBACK(src, PROC_REF(move_to_atmosphere)), 1 SECONDS)
			return
		if(transit_to == STATE_ON_SHIP)
			move_to_ship()
			return

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/take_off(mob/user)
	shuttle_port = SSshuttle.getShuttle(shuttleId)
	shuttle_port.shuttle_computer = src

	if(shuttle_port.mode != SHUTTLE_IDLE)
		return

	if(current_state == STATE_ON_SHIP && !transit_to)
		from_ship(user)

	if(current_state == STATE_ON_GROUND && !transit_to)
		from_ground(user)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/from_ship(mob/user)
	if(current_state != STATE_ON_SHIP || transit_to)
		return

	if(!(shuttle_port.shuttle_flags & GAMEMODE_IMMUNE) && world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(user, SPAN_WARNING("The shuttle is still undergoing pre-flight fueling and cannot depart yet. Please wait another [round((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK-world.time)/600)] minutes before trying again."))
		return

	if(!COOLDOWN_FINISHED(src, launch_cooldown))
		to_chat(user, SPAN_WARNING("Engines are cooling down. Wait a moment."))

	balloon_alert_to_viewers("take off initiated")
	current_state = STATE_IN_TRANSIT
	transit_to = STATE_IN_ATMOSPHERE
	SSshuttle.move_shuttle_to_transit(shuttleId, TRUE)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/move_to_atmosphere()
	balloon_alert_to_viewers("entering low flight")
	current_state = STATE_IN_ATMOSPHERE
	transit_to = null
	shuttle_port.assigned_transit.reserved_area.set_turf(/turf/open/space/transit/atmosphere)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/move_to_ship()
	shuttle_port.assigned_transit.reserved_area.set_turf(/turf/open/space/transit)
	current_state = STATE_ON_SHIP
	transit_to = null

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/to_ship()
	balloon_alert_to_viewers("moving to ship")
	current_state = STATE_IN_TRANSIT
	transit_to = STATE_ON_SHIP
	SSshuttle.moveShuttle(shuttleId, SHUTTLE_GETTY, TRUE)

/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/from_ground()
	balloon_alert_to_viewers("take off initiated")
	current_state = STATE_IN_TRANSIT
	transit_to = STATE_IN_ATMOSPHERE
	SSshuttle.move_shuttle_to_transit(shuttleId, TRUE)


/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/proc/view_ground(mob/user)
	if(!(current_state == STATE_IN_ATMOSPHERE && transit_to == null && shuttle_port.mode == SHUTTLE_IDLE))
		return

	open_prompt(user)

/datum/action/innate/shuttledocker_land
	name = "Land"
	action_icon_state = "land"

/datum/action/innate/shuttledocker_land/action_activate()
	var/mob/C = target
	var/mob/camera/eye/remote/remote_eye = C.remote_control
	var/obj/structure/machinery/computer/camera_advanced/shuttle_docker/getty/origin = remote_eye.origin
	if(origin.shuttle_port.mode != SHUTTLE_IDLE)
		to_chat(owner, SPAN_WARNING("The shuttle is not ready to land yet!"))
		return
	if(!origin.placeLandingSpot(target))
		to_chat(owner, SPAN_WARNING("You cannot land here."))
		return
	origin.shuttle_port.callTime = 0 SECONDS
	origin.transit_to = STATE_ON_GROUND
	origin.open_prompt = FALSE
	origin.shuttle_port.set_mode(SHUTTLE_CALL)
	origin.last_valid_ground_port = origin.my_port
	SSshuttle.moveShuttleToDock(origin.shuttleId, origin.my_port, TRUE)
