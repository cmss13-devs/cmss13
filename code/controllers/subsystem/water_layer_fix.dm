SUBSYSTEM_DEF(water_layer_fix)
	name = "Water Layer Fix"
	init_order = 3.6          // lower than DECORATOR (3.7) → runs after it ---> Necessary to run this AFTER anything that changes turf layers
	flags = SS_NO_FIRE

/datum/controller/subsystem/water_layer_fix/Initialize()
	for(var/turf/T as anything in GLOB.turfs)
		T.fix_water_clipping_layers()
		CHECK_TICK
	for(var/turf/T as anything in GLOB.turfs)
		T.fix_water_clipping_layers_final()
		CHECK_TICK
	return SS_INIT_SUCCESS
