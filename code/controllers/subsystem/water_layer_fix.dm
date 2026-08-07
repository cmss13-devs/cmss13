SUBSYSTEM_DEF(water_layer_fix)
	name = "Water Overlays"
	init_order = 3.6				// lower than DECORATOR (3.7) → runs after it ---> Necessary to run this AFTER anything that changes turf layers..
	flags = SS_NO_FIRE				// since this subsystem also changes some turf layers near water (to prevent mobs in water clipping below them)
									// alternatively we could detect and change those turf's layer upon a mob in water approaching nearby on the fly..
									// but this is the less costly approach imho

/datum/controller/subsystem/water_layer_fix/Initialize()
	for(var/turf/T as anything in GLOB.turfs)
		T.fix_water_clipping_layers()
		CHECK_TICK
	for(var/turf/T as anything in GLOB.turfs)
		T.fix_water_clipping_layers_final()
		CHECK_TICK
	generate_water_display_icons()
	return SS_INIT_SUCCESS
