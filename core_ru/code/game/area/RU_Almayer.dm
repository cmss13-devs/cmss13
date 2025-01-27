//RUCM ALMAYER ZONES
/area/rumayer
	icon = 'core_ru/icons/turf/area_rumayer.dmi'
	// ambience = list('sound/ambience/shipambience.ogg')
	icon_state = "almayer"
	ceiling = CEILING_METAL
	powernet_name = "almayer"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
	// soundscape_playlist = list('sound/effects/xylophone1.ogg', 'sound/effects/xylophone2.ogg', 'sound/effects/xylophone3.ogg')
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE

	///Whether this area is used for hijack evacuation progress
	var/hijack_evacuation_area = FALSE

	///The weight this area gives towards hijack evacuation progress
	var/hijack_evacuation_weight = 0

	///Whether this area is additive or multiplicative towards evacuation progress
	var/hijack_evacuation_type = EVACUATION_TYPE_NONE

/area/rumayer/squads/alpha_delta_shared
	name = "\improper Alpha Delta Equipment Preparation"
	icon_state = "ad_shared"
	fake_zlevel = 2 // lowerdeck

/area/rumayer/squads/bravo_charlie_shared
	name = "\improper Bravo Charlie Equipment Preparation"
	icon_state = "bc_shared"
	fake_zlevel = 2 // lowerdeck
