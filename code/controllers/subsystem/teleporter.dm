// Master teleporter controller.
SUBSYSTEM_DEF(teleporter)
    name = "Teleporter"
    wait = 5 SECONDS
    init_order =     SS_INIT_TELEPORTER
    priority =       SS_PRIORITY_TELEPORTER
    flags =          SS_NO_FIRE

    var/teleporters_by_id // Associative list of teleporters by ID, master list of teleporters to process
    var/teleporters       // Process list (identical contents to teleporters_by_id)

// teleporter ID:
//Corsat_Teleporter

/datum/controller/subsystem/teleporter/Initialize()
    if (SSmapping.configs[GROUND_MAP].map_name != MAP_CORSAT) // Bad style, but I'm leaving it here for now until someone wants to add a teleporter to another map
        return SS_INIT_NO_NEED

    teleporters_by_id = list()
    teleporters = list()

    var/datum/teleporter/teleporter = new
    var/teleporter_id = "Corsat_Teleporter"
    teleporter.id = teleporter_id
    teleporter.cooldown = 3000 // Five minutes
    teleporter.name = "CORSAT Experimental Teleporter"

    teleporters_by_id[teleporter_id] = teleporter
    teleporters += teleporter
    return SS_INIT_SUCCESS
