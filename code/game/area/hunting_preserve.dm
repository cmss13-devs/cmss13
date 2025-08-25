
///Predator Hunting Grounds stuff
/area/yautja_grounds
	name = "\improper Yautja Hunting Grounds"
	icon_state = "green"
	weather_enabled = FALSE
	flags_area = AREA_YAUTJA_HANGABLE|AREA_NOTUNNEL|AREA_AVOID_BIOSCAN|AREA_YAUTJA_GROUNDS|AREA_YAUTJA_HUNTING_GROUNDS
	resin_construction_allowed = FALSE
	can_build_special = FALSE
	is_resin_allowed = TRUE

/area/yautja_grounds/jungle
	name = "\improper Yautja Hunting Grounds Jungle Central"
	icon_state = "central"
	ambience_exterior = AMBIENCE_JUNGLEMOON
	soundscape_playlist = SCAPE_PL_JUNGLE_MOON
	soundscape_interval = 60

/area/yautja_grounds/jungle/north
	name = "\improper Yautja Hunting Grounds Jungle north"
	icon_state = "north"

/area/yautja_grounds/jungle/north_east
	name = "\improper Yautja Hunting Grounds Jungle north east"
	icon_state = "northeast"

/area/yautja_grounds/jungle/north_west
	name = "\improper Yautja Hunting Grounds Jungle north west"
	icon_state = "northwest"

/area/yautja_grounds/jungle/east
	name = "\improper Yautja Hunting Grounds Jungle east"
	icon_state = "east"

/area/yautja_grounds/jungle/south
	name = "\improper Yautja Hunting Grounds Jungle south"
	icon_state = "south"

/area/yautja_grounds/jungle/south_east
	name = "\improper Yautja Hunting Grounds Jungle south east"
	icon_state = "southeast"

/area/yautja_grounds/jungle/south_west
	name = "\improper Yautja Hunting Grounds Jungle south west "
	icon_state = "southwest"

/area/yautja_grounds/jungle/west
	name = "\improper Yautja Hunting Grounds Jungle west"
	icon_state = "west"

/area/yautja_grounds/caves
	name = "\improper Yautja Hunting Grounds Caves"
	icon_state = "cave"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30

///TP Areas/Prep areas
/area/yautja_grounds/prep_room
	name = "\improper Jungle Moon Campsite"
	icon_state = "red"
	ambience_exterior = AMBIENCE_JUNGLEMOON
	sound_environment = SOUND_ENVIRONMENT_ROOM
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_MEDIUM
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
