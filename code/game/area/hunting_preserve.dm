
///Predator Hunting Grounds stuff | Jungle Moon
/area/yautja_grounds
	name = "\improper Yautja Hunting Grounds"
	icon_state = "green"
	weather_enabled = FALSE
	flags_area = AREA_YAUTJA_HANGABLE|AREA_NOBURROW|AREA_AVOID_BIOSCAN|AREA_YAUTJA_GROUNDS|AREA_YAUTJA_HUNTING_GROUNDS
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

/area/yautja_grounds/caves/central
	name = "\improper Yautja Hunting Grounds Central Caves"
	icon_state = "cave"

/area/yautja_grounds/caves/north
	name = "\improper Yautja Hunting Grounds North Caves"
	icon_state = "caves_north"

/area/yautja_grounds/caves/north_west
	name = "\improper Yautja Hunting Grounds North West Caves"
	icon_state = "caves_north"

/area/yautja_grounds/caves/north_east
	name = "\improper Yautja Hunting Grounds North East Caves"
	icon_state = "caves_north"

/area/yautja_grounds/caves/west
	name = "\improper Yautja Hunting Grounds West Caves"
	icon_state = "caves_virology"

/area/yautja_grounds/caves/east
	name = "\improper Yautja Hunting Grounds East Caves"
	icon_state = "caves_east"

/area/yautja_grounds/caves/south
	name = "\improper Yautja Hunting Grounds South Caves"
	icon_state = "caves_research"

/area/yautja_grounds/caves/south_west
	name = "\improper Yautja Hunting Grounds South West Caves"
	icon_state = "caves_sw"

/area/yautja_grounds/caves/south_east
	name = "\improper Yautja Hunting Grounds South East Caves"
	icon_state = "caves_se"

/area/yautja_grounds/temple/entrance
	name = "\improper Yautja Hunting Grounds Temple"
	icon_state = "bluenew"
	ambience_exterior = AMBIENCE_JUNGLE

// Hunting Grounds | Desert Moon
/area/yautja_grounds/desert
	name = "\improper Yautja Hunting Grounds Desert central"
	icon_state = "central"
	ambience_exterior = AMBIENCE_BIGRED
	soundscape_playlist = SCAPE_PL_WIND
	soundscape_interval = 30

/area/yautja_grounds/desert/north
	name = "\improper Yautja Hunting Grounds Desert north"
	icon_state = "north"

/area/yautja_grounds/desert/north_east
	name = "\improper Yautja Hunting Grounds Desert north east"
	icon_state = "northeast"

/area/yautja_grounds/desert/north_west
	name = "\improper Yautja Hunting Grounds Desert north west"
	icon_state = "northwest"

/area/yautja_grounds/desert/east
	name = "\improper Yautja Hunting Grounds Desert east"
	icon_state = "east"

/area/yautja_grounds/desert/south
	name = "\improper Yautja Hunting Grounds Desert south"
	icon_state = "south"

/area/yautja_grounds/desert/south_east
	name = "\improper Yautja Hunting Grounds Desert south east"
	icon_state = "southeast"

/area/yautja_grounds/desert/south_west
	name = "\improper Yautja Hunting Grounds Desert south west"
	icon_state = "southwest"

/area/yautja_grounds/desert/west
	name = "\improper Yautja Hunting Grounds Desert west"
	icon_state = "west"

/area/yautja_grounds/temple
	name = "\improper Yautja Hunting Grounds Temple"
	icon_state = "bluenew"
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_CAVE
	ceiling = CEILING_UNDERGROUND_SANDSTONE_BLOCK_CAS

/area/yautja_grounds/temple/entrance/desert
	name = "\improper Yautja Hunting Grounds Temple"
	icon_state = "bluenew"
	ambience_exterior = AMBIENCE_BIGRED
	soundscape_playlist = SCAPE_PL_WIND
	soundscape_interval = 30
	ceiling = CEILING_NONE

///TP Areas/Prep Areas

/area/yautja_grounds/prep_room
	name = "\improper Jungle Moon Campsite"
	icon_state = "red"
	ambience_exterior = AMBIENCE_JUNGLEMOON
	sound_environment = SOUND_ENVIRONMENT_ROOM
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_MEDIUM
	ceiling = CEILING_SANDSTONE_ALLOW_CAS

/area/yautja_grounds/prep_room/desert
	name = "\improper Desert Moon Campsite"
	ambience_exterior = AMBIENCE_BIGRED
	soundscape_playlist = SCAPE_PL_WIND
	soundscape_interval = 30
	sound_environment = SOUND_ENVIRONMENT_GENERIC
	ceiling_muffle = TRUE
	ceiling = CEILING_NONE

/area/yautja_grounds/prep_room/desert/interior
	name ="\improper Desert Moon Campsite Interior"
	ceiling_muffle = FALSE
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
