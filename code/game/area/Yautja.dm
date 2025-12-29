/area/yautja_ship
	name = "\improper Yautja Ship"
	icon = 'icons/turf/area_yautja.dmi'
	icon_state = "middeck"
	//music = "signal"
	ambience_exterior = AMBIENCE_YAUTJA
	ceiling = CEILING_METAL
	powernet_name = "yautja_ship"
	requires_power = FALSE
	base_lighting_alpha = 155
	base_lighting_color = "#ffc49c"
	flags_area = AREA_YAUTJA_GROUNDS

/// Bottom Deck
/area/yautja_ship/lower_deck
	name = "\improper Yautja Ship - Lower Deck"
	base_lighting_alpha = 105
	icon_state = "lowerdeck"

/area/yautja_ship/lower_deck/training_center
	name = "\improper Yautja Ship - Lower Deck - Training Center"

/area/yautja_ship/lower_deck/houndchamber
	name = "\improper Yautja Ship - Lower Deck - Hound Chamber"

/// Mid Deck
/area/yautja_ship/middle_deck
	name = "\improper Yautja Ship - Middle Deck"

/area/yautja_ship/middle_deck/bridge
	name = "\improper Yautja Ship - Middle Deck - Bridge"
	icon_state = "bridge"

/area/yautja_ship/middle_deck/trophy_hall
	name = "\improper Yautja Ship - Middle Deck - Trophy Hall"

/area/yautja_ship/middle_deck/armory
	name = "\improper Yautja Ship - Middle Deck - Armory"

/area/yautja_ship/middle_deck/research
	name = "\improper Yautja Ship - Middle Deck - Research Chamber"

/area/yautja_ship/middle_deck/medical
	name = "\improper Yautja Ship - Middle Deck - Healing Chamber"
	icon_state = "medical"

/area/yautja_ship/middle_deck/morgue
	name = "\improper Yautja Ship - Middle Deck - Hall of the Fallen"
	icon_state = "medical"


/// Top Deck
/area/yautja_ship/upper_deck
	name = "\improper Yautja Ship - Upper Deck"
	base_lighting_alpha = 180
	icon_state = "topdeck"

/area/yautja_ship/upper_deck/hangar_a
	name = "\improper Yautja Ship - Upper Deck - Hangar A"

/area/yautja_ship/upper_deck/hangar_b
	name = "\improper Yautja Ship - Upper Deck - Hangar B"

/area/yautja_ship/upper_deck/prison
	name = "\improper Yautja Ship - Upper Deck - Prison Wing"

/area/yautja_ship/upper_deck/throne
	name = "\improper Yautja Ship - Upper Deck - Throne Room"
	icon_state = "bridge"

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
