var/datum/subsystem/pipenet/SSpipenet

var/list/obj/structure/machinery/atmospherics/atmos_machines = list()
var/list/datum/pipe_network/pipe_networks = list()


/datum/subsystem/pipenet
	name          = "Pipenet"
	wait          = 2 SECONDS
	display_order = SS_DISPLAY_PIPENET
	priority      = SS_PRIORITY_PIPENET
	init_order    = SS_INIT_PIPENET
	flags         = SS_DISABLE_FOR_TESTING

	var/list/currentrun_atmos_machines
	var/list/currentrun_pipenets


/datum/subsystem/pipenet/New()
	NEW_SS_GLOBAL(SSpipenet)


/datum/subsystem/pipenet/stat_entry()
	..("PN:[pipe_networks.len]|AM:[atmos_machines.len]")


/datum/subsystem/pipenet/Initialize()
	for (var/obj/structure/machinery/atmospherics/machine in atmos_machines)
		machine.build_network()
	..()

/datum/subsystem/pipenet/fire(resumed = FALSE)
	if (!resumed)
		currentrun_pipenets       = global.pipe_networks.Copy()
		currentrun_atmos_machines = global.atmos_machines.Copy()

	while (currentrun_atmos_machines.len)
		var/obj/structure/machinery/atmospherics/atmosmachinery = currentrun_atmos_machines[currentrun_atmos_machines.len]
		currentrun_atmos_machines.len--

		if (!atmosmachinery || atmosmachinery.disposed)
			continue

		if (atmosmachinery.process() && MC_TICK_CHECK)
			return

