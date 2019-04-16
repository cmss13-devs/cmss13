var/datum/subsystem/lighting/SSlighting


/datum/subsystem/lighting
	name          = "Lighting"
	init_order    = SS_INIT_LIGHTING
	display_order = SS_DISPLAY_LIGHTING
	priority      = SS_PRIORITY_LIGHTING
	wait          = 3
	flags         = SS_NO_TICK_CHECK


/datum/subsystem/lighting/New()
	NEW_SS_GLOBAL(SSlighting)


/datum/subsystem/lighting/Initialize(timeofday)
	if(!lighting_controller)
		lighting_controller = new /datum/controller/lighting()

	..()


/datum/subsystem/lighting/fire(resumed = FALSE)
	lighting_controller.process()