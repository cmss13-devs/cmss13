var/datum/subsystem/mapview_init/SSmapview_init

/datum/subsystem/mapview_init
	name       = "Mapview Init"
	init_order = SS_INIT_MAPVIEW
	flags      = SS_NO_FIRE

/datum/subsystem/mapview_init/New()
	NEW_SS_GLOBAL(SSmapview_init)

/datum/subsystem/mapview_init/Initialize()
	generate_marine_mapview()
	..()
