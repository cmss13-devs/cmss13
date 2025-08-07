//these are the companion turfs to the auto-turf used on chances claim, since I (triiodine) fucked up the layer system
/turf/open/shale
	icon = 'icons/turf/floors/auto_shale.dmi'
	icon_state = "shale_0"
	is_weedable = SEMI_WEEDABLE

/turf/open/shale/get_dirt_type()
	return DIRT_TYPE_SHALE

/turf/open/shale/can_dig_xeno_tunnel()
	return TRUE

/turf/open/shale/update_icon()
	. = ..()
	setDir(pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST))

/turf/open/shale/Initialize(mapload, ...)
	. = ..()
	update_icon()

/turf/open/shale/underlayer
	icon_state = "shale_1_alt"

/turf/open/shale/underlayer/puddle
	icon_state = "shale_0_puddle"
