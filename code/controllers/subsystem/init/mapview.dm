SUBSYSTEM_DEF(mapview_init)
	name       = "Mapview Init"
	init_order = SS_INIT_MAPVIEW
	flags      = SS_NO_FIRE

/datum/controller/subsystem/mapview_init/Initialize()
	generate_marine_mapview()
	return ..()
