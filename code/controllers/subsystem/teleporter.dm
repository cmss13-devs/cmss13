// Master teleporter controller.
SUBSYSTEM_DEF(teleporter)
	name = "Teleporter"
	wait = 5 SECONDS
	init_order = SS_INIT_TELEPORTER
	priority = SS_PRIORITY_TELEPORTER
	flags = SS_NO_FIRE|SS_NO_INIT

	var/list/teleporters_by_id = list() // Associative list of teleporters by ID, master list of teleporters to process
	var/list/teleporters = list()    // Process list (identical contents to teleporters_by_id)
