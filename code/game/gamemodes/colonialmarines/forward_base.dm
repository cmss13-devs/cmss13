/datum/game_mode/colonialmarines/forward_base
	name = GAMEMODE_FORWARD_BASE
	config_tag = GAMEMODE_FORWARD_BASE

/datum/game_mode/colonialmarines/forward_base/pre_setup()
	..()
	var/obj/docking_port/stationary/marine_dropship/lz1/landing_zone = locate() in SSshuttle.stationary
	if(!landing_zone)
		return FALSE

	var/datum/map_template/bunker = new("maps/templates/forward_base/big_red_lz1.dmm")
	// Do not change any of these values unless you know what you're doing. This is the exact tile the bunker has to be placed on
	var/turf/bunker_origin = locate(landing_zone.x - 26, min(landing_zone.y - 33, world.maxy - bunker.height + 1), landing_zone.z)

	for(var/obj/docking_port/port as anything in (SSshuttle.mobile + SSshuttle.stationary))
		if(is_mainship_level(port.z) || port == landing_zone)
			qdel(port, TRUE)
	SSitem_cleanup.delete_almayer()

	bunker.load(bunker_origin, delete = TRUE)
	qdel(bunker)
	makepowernets()

	// Snowflake to get the req elevator to work
	var/datum/controller/shuttle_controller/controller = SSoldshuttle.shuttle_controller
	var/datum/shuttle/ferry/supply/old_shuttle = GLOB.supply_controller.shuttle
	var/area/supply_depot = old_shuttle.area_offsite
	controller.process_shuttles -= old_shuttle
	qdel(old_shuttle.elevator_animation)
	qdel(old_shuttle)

	var/datum/shuttle/ferry/supply/bunker_shuttle = new()
	bunker_shuttle.area_station = get_area(GLOB.supply_controller.supply_elevator)
	bunker_shuttle.area_offsite = supply_depot
	controller.shuttles["Supply"] = bunker_shuttle
	controller.process_shuttles += bunker_shuttle

	active_lz = locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1)
	for(var/obj/structure/machinery/computer/shuttle/dropship/flight/console in GLOB.machines)
		console.disable()
	return TRUE

/datum/game_mode/colonialmarines/forward_base/post_setup()
	. = ..()
	flags_round_type |= MODE_DS_LANDED
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_DS_FIRST_LANDED)

/datum/game_mode/colonialmarines/forward_base/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING || round_started > 0 || round_finished)
		return
	if(!count_marines(SSmapping.levels_by_trait(ZTRAIT_GROUND)))
		round_finished = MODE_INFESTATION_X_MAJOR
		return
	return ..()
