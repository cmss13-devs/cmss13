/area/mainship_crashsite
	ceiling = CEILING_REINFORCED_METAL
	icon_state = "shuttle"
	always_unpowered = TRUE
	powernet_name = "ground"

/area/mainship_crashsite/outside
	ceiling = CEILING_NONE

/area/mainship_crashsite/Initialize(mapload, ...)
	. = ..()
	name = "\improper [MAIN_SHIP_NAME] crash site"

/area/template_noop/conditional/mainship_crashsite_outside
	resulting_area_type = /area/mainship_crashsite/outside
