#define ALMAYER_DROPSHIP_LZ1 "almayer-hangar-lz1"

#define LV_624_LZ1 "lv624-lz1"
#define LV_624_LZ2 "lv624-lz2"

/obj/docking_port/mobile/marine_dropship
	width = 11
	height = 21

/obj/docking_port/mobile/marine_dropship/alamo
	name = "Alamo"

/obj/docking_port/stationary/marine_dropship
	dir = NORTH
	width = 11
	height = 21
	var/list/landing_lights = list()

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

/obj/docking_port/stationary/marine_dropship/on_dock_ignition(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_off_landing_lights()

/obj/docking_port/stationary/marine_dropship/lv642_lz1
	name = "Nexus Landing Zone"
	id = LV_624_LZ1

/obj/docking_port/stationary/marine_dropship/lv642_lz2
	name = "Robotics Landing Zone"
	id = LV_624_LZ2

/obj/docking_port/stationary/marine_dropship/almayer_hangar_1
	name = "Almayer Hangar bay 1"
	id = ALMAYER_DROPSHIP_LZ1
	roundstart_template = /datum/map_template/shuttle/alamo

/obj/docking_port/stationary/marine_dropship/almayer_hangar_2
	name = "Almayer Hangar bay 2"
	id = ALMAYER_DROPSHIP_LZ2

/datum/map_template/shuttle/alamo
	name = "Alamo"
	shuttle_id = "dropship_alamo"
