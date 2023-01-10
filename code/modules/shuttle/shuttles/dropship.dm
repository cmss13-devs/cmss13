#define ALMAYER_DROPSHIP_LZ1 "almayer-hangar-lz1"
#define ALMAYER_DROPSHIP_LZ2 "almayer-hangar-lz2"

#define LV_624_LZ1 "lv624-lz1"
#define LV_624_LZ2 "lv624-lz2"

#define DROPSHIP_ALAMO "dropship_alamo"
#define DROPSHIP_NORMANDY "dropship_normandy"

/obj/docking_port/mobile/marine_dropship
	width = 11
	height = 21
	preferred_direction = SOUTH
	var/list/hatches = list()
	var/datum/door_controller/aggregate/door_control
	var/door_override = FALSE
	var/in_flyby = FALSE
	callTime = DROPSHIP_TRANSIT_DURATION
	rechargeTime = SHUTTLE_RECHARGE

/obj/docking_port/mobile/marine_dropship/Initialize(mapload)
	. = ..()
	door_control = new()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			switch(air.id)
				if("starboard_door")
					door_control.add_door(air, "starboard")
				if("port_door")
					door_control.add_door(air, "port")
				if("aft_door")
					door_control.add_door(air, "aft")

/obj/docking_port/mobile/marine_dropship/Destroy(force)
	. = ..()
	qdel(door_control)

/obj/docking_port/mobile/marine_dropship/proc/send_for_flyby()
	in_flyby = TRUE
	var/obj/docking_port/stationary/dockedAt = get_docked()
	SSshuttle.moveShuttle(src.id, dockedAt.id, callTime)

/obj/docking_port/mobile/marine_dropship/proc/get_door_data()
	return door_control.get_data()

/obj/docking_port/mobile/marine_dropship/Initialize(mapload)
	. = ..()
	door_control = new()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			switch(air.id)
				if("starboard_door")
					door_control.add_door(air, "starboard")
				if("port_door")
					door_control.add_door(air, "port")
				if("aft_door")
					door_control.add_door(air, "aft")

/obj/docking_port/mobile/marine_dropship/Destroy(force)
	. = ..()
	qdel(door_control)

/obj/docking_port/mobile/marine_dropship/proc/control_doors(var/action, var/direction, var/force)
	// its been locked down by the queen
	if(door_override)
		return
	door_control.control_doors(action, direction, force)

/obj/docking_port/mobile/marine_dropship/proc/is_door_locked(var/direction)
	return door_control.is_door_locked(direction)

/obj/docking_port/mobile/marine_dropship/alamo
	name = "Alamo"
	id = DROPSHIP_ALAMO

/obj/docking_port/mobile/marine_dropship/normandy
	name = "Normandy"
	id = DROPSHIP_NORMANDY

/obj/docking_port/stationary/marine_dropship
	dir = NORTH
	width = 11
	height = 21
	var/list/landing_lights = list()
	var/auto_open = FALSE

/obj/docking_port/stationary/marine_dropship/Initialize(mapload)
	. = ..()
	link_landing_lights()

/obj/docking_port/stationary/marine_dropship/proc/link_landing_lights()
	var/area/landing_area = get_area(src)
	for(var/obj/structure/machinery/landinglight/light in landing_area)
		landing_lights += list(light)

/obj/docking_port/stationary/marine_dropship/proc/turn_on_landing_lights()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.turn_on()

/obj/docking_port/stationary/marine_dropship/proc/turn_off_landing_lights()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.turn_off()

/obj/docking_port/stationary/marine_dropship/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	turn_off_landing_lights()
	if(auto_open && istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		var/obj/docking_port/mobile/marine_dropship/dropship = arriving_shuttle
		dropship.in_flyby = FALSE
		dropship.control_doors("unlock", "all", force=TRUE)

/obj/docking_port/stationary/marine_dropship/on_dock_ignition(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_off_landing_lights()
	if(istype(departing_shuttle, /obj/docking_port/mobile/marine_dropship))
		var/obj/docking_port/mobile/marine_dropship/dropship = departing_shuttle
		dropship.control_doors("force-lock-launch", "all", force=TRUE)

/obj/docking_port/stationary/marine_dropship/lv642_lz1
	name = "Nexus Landing Zone"
	id = LV_624_LZ1

/obj/docking_port/stationary/marine_dropship/lv642_lz2
	name = "Robotics Landing Zone"
	id = LV_624_LZ2

/obj/docking_port/stationary/marine_dropship/almayer_hangar_1
	name = "Almayer Hangar bay 1"
	id = ALMAYER_DROPSHIP_LZ1
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/alamo

/obj/docking_port/stationary/marine_dropship/almayer_hangar_2
	name = "Almayer Hangar bay 2"
	id = ALMAYER_DROPSHIP_LZ2
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/normandy

/datum/map_template/shuttle/alamo
	name = "Alamo"
	shuttle_id = DROPSHIP_ALAMO

/datum/map_template/shuttle/normandy
	name = "Normandy"
	shuttle_id = DROPSHIP_NORMANDY
