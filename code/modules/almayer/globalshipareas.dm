GLOBAL_LIST_EMPTY(global_ship_areas)

/area/Initialize()

	if(is_mainship_level(z))
    	GLOB.global_ship_areas += src
