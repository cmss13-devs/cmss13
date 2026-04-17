/area/horde_mode
	name = "Lost Colony"
	icon = 'icons/turf/area_whiskey.dmi'
	soundscape_playlist = list('sound/ambience/rainforest.ogg', 'sound/ambience/ambienceLV624.ogg','sound/ambience/ambienceNV.ogg', 'sound/ambience/ambimo2.ogg')
	icon_state = "bunker"
	area_has_base_lighting = TRUE
	base_lighting_alpha = 45
	requires_power = FALSE
	ceiling = CEILING_METAL
	var/unlocked = FALSE
	var/list/vents_in_area = list()

/area/horde_mode/outside
	name = "Lost Colony - Outside"
	icon_state = "outside"

/area/horde_mode/lobby
	name = "Lost Colony - Lobby"
	icon_state = "p4"
	unlocked = TRUE

/area/horde_mode/engineering
	name = "Lost Colony - Engineering"
	icon_state = "p2"

/area/horde_mode/medical
	name = "Lost Colony - Medical"
	icon_state = "p1"

/area/horde_mode/science
	name = "Lost Colony - Science"
	icon_state = "p3"

/area/horde_mode/center
	name = "Lost Colony - Center"
	icon_state = "p5"
