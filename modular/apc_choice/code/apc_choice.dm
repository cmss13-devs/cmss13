/obj/effect/vehicle_spawner
	var/category

/obj/effect/vehicle_spawner/tank
	category = "TANK"

/obj/effect/vehicle_spawner/apc
	category = "APC"

/obj/effect/vehicle_spawner/apc_med
	category = "APC"

/obj/effect/vehicle_spawner/apc_cmd
	category = "APC"

/area/interior/vehicle/apc/med/Initialize(mapload, ...)
	. = ..()

	for(var/turf/open/turf in src)
		turf.supports_surgery = TRUE

/datum/vehicle_order/apc/plain
	name = "M577 Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc/plain

/datum/vehicle_order/apc/med/plain
	name = "M577-MED Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc_med/plain

/datum/vehicle_order/apc/cmd/plain
	name = "M577-CMD Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc_cmd/plain

/obj/structure/machinery/computer/supply/asrs/vehicle/Initialize()
	. = ..()

	vehicles |= list(
		new /datum/vehicle_order/apc/plain,
		new /datum/vehicle_order/apc/med/plain,
		new /datum/vehicle_order/apc/cmd/plain,
	)
