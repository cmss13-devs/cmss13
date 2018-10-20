var/datum/supply_controller/supply_controller

var/datum/subsystem/supply/SSsupply

/datum/subsystem/supply
	name          = "Supply"
	init_order    = SS_INIT_SUPPLY_SHUTTLE
	display_order = SS_DISPLAY_SUPPLY
	priority      = SS_PRIORITY_SUPPLY
	wait          = 30 SECONDS
	flags         = SS_NO_TICK_CHECK | SS_KEEP_TIMING


/datum/subsystem/supply/New()
	NEW_SS_GLOBAL(SSsupply)


/datum/subsystem/supply/Initialize(timeofday)
	supply_controller = new
	supply_controller.setup()
	..()


/datum/subsystem/supply/fire(resumed = FALSE)
	supply_controller.process()
