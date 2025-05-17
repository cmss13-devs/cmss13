SUBSYSTEM_DEF(sensors)
	name = "Sensors"
	wait = 0.5 SECONDS
	init_order = SS_INIT_SENSORS

	var/list/obj/structure/machinery/sensor/sensors
	var/list/targets

/datum/controller/subsystem/sensors/Initialize()
	sensors = list()
	targets = list()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/sensors/fire()
	targets.Cut()

	for(var/obj/structure/machinery/sensor/sensor in sensors)
		targets |= SSquadtree.players_in_range(sensor.range_bounds, sensor.z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)

