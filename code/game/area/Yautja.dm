/area/yautja_ship
	name = "\improper Yautja Ship"
	icon = 'icons/turf/area_yautja.dmi'
	icon_state = "darkred"
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

/area/yautja_ship/lower_deck/corridors
	name = "\improper Yautja Ship - Lower Deck - Corridors"
	icon_state = "magenta"

/area/yautja_ship/lower_deck/training_center
	name = "\improper Yautja Ship - Lower Deck - Training Center"
	icon_state = "cyan"

/area/yautja_ship/lower_deck/houndchamber
	name = "\improper Yautja Ship - Lower Deck - Hound Chamber"
	icon_state = "red"

/area/yautja_ship/lower_deck/temple
	name = "\improper Yautja Ship - Lower Deck - Temple"
	icon_state = "blue"
	base_lighting_alpha = 0
	base_lighting_color = "#ffffff"

/area/yautja_ship/lower_deck/scribe
	name = "\improper Yautja Ship - Lower Deck - Scribe Chamber"
	icon_state = "green"

/area/yautja_ship/lower_deck/elites
	name = "\improper Yautja Ship - Lower Deck - Elite Quarters"
	icon_state = "yellow"

/area/yautja_ship/lower_deck/cargo
	name = "\improper Yautja Ship - Lower Deck - Cargo Bay"
	icon_state = "darkred"

/area/yautja_ship/lower_deck/engine
	name = "\improper Yautja Ship - Lower Deck - Engine Bay"
	icon_state = "orange"

/area/yautja_ship/lower_deck/forge
	name = "\improper Yautja Ship - Lower Deck - Forge"
	icon_state = "purple"

/area/yautja_ship/lower_deck/firerange
	name = "\improper Yautja Ship - Lower Deck - Firing Range"


/// Mid Deck
/area/yautja_ship/middle_deck
	name = "\improper Yautja Ship - Middle Deck"

/area/yautja_ship/middle_deck/corridors
	name = "\improper Yautja Ship - Middle Deck - Corridors"
	icon_state = "magenta"

/area/yautja_ship/middle_deck/mainhall
	name = "\improper Yautja Ship - Middle Deck - Main Hall"
	icon_state = "cyan"

/area/yautja_ship/middle_deck/bridge
	name = "\improper Yautja Ship - Middle Deck - Bridge"
	icon_state = "blue"

/area/yautja_ship/middle_deck/trophy_hall
	name = "\improper Yautja Ship - Middle Deck - Trophy Hall"

/area/yautja_ship/middle_deck/armory
	name = "\improper Yautja Ship - Middle Deck - Armory"

/area/yautja_ship/middle_deck/research
	name = "\improper Yautja Ship - Middle Deck - Research Chamber"
	icon_state = "purple"

/area/yautja_ship/middle_deck/medical
	name = "\improper Yautja Ship - Middle Deck - Healing Chamber"
	icon_state = "green"

/area/yautja_ship/middle_deck/morgue
	name = "\improper Yautja Ship - Middle Deck - Hall of the Fallen"
	icon_state = "green"

/area/yautja_ship/middle_deck/mortuary
	name = "\improper Yautja Ship - Middle Deck - Mortuary"
	icon_state = "green"

/area/yautja_ship/middle_deck/food
	name = "\improper Yautja Ship - Middle Deck - Feed Hall"

/area/yautja_ship/middle_deck/elder
	name = "\improper Yautja Ship - Middle Deck - Elder Quarters"
	icon_state = "cyan"

/area/yautja_ship/middle_deck/prep
	name = "\improper Yautja Ship - Middle Deck - Sleeping Chamber"
	icon_state = "blue"

/area/yautja_ship/middle_deck/reactor
	name = "\improper Yautja Ship - Middle Deck - Generator Room"
	icon_state = "orange"

/area/yautja_ship/middle_deck/workshop
	name = "\improper Yautja Ship - Middle Deck - Workshop"
	icon_state = "orange"

/// Top Deck
/area/yautja_ship/upper_deck
	name = "\improper Yautja Ship - Upper Deck"
	base_lighting_alpha = 180

/area/yautja_ship/upper_deck/corridors
	name = "\improper Yautja Ship - Upper Deck - Corridors"
	icon_state = "magenta"

/area/yautja_ship/upper_deck/hangar_a
	name = "\improper Yautja Ship - Upper Deck - Hangar A"
	icon_state = "orange"

/area/yautja_ship/upper_deck/hangar_b
	name = "\improper Yautja Ship - Upper Deck - Hangar B"
	icon_state = "orange"

/area/yautja_ship/upper_deck/prison
	name = "\improper Yautja Ship - Upper Deck - Prison Wing"
	icon_state = "red"

/area/yautja_ship/upper_deck/elder
	name = "\improper Yautja Ship - Upper Deck - Elder Quarters"
	icon_state = "cyan"

/area/yautja_ship/upper_deck/meeting
	name = "\improper Yautja Ship - Upper Deck - Meeting Chamber"
	icon_state = "yellow"

/area/yautja_ship/upper_deck/throne
	name = "\improper Yautja Ship - Upper Deck - Throne Room"
	icon_state = "blue"
	base_lighting_alpha = 0
	base_lighting_color = "#ffffff"

/area/yautja_ship/upper_deck/ancient
	name = "\improper Yautja Ship - Upper Deck - Ancient Quarters"
	icon_state = "blue"

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

///TP Areas/Prep areas
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




/area/yautja_ancient_temple
	name = "\improper Ancient Temple"
	icon_state = "green"
	weather_enabled = FALSE
	flags_area = AREA_YAUTJA_HANGABLE|AREA_NOTUNNEL|AREA_AVOID_BIOSCAN|AREA_YAUTJA_GROUNDS|AREA_YAUTJA_HUNTING_GROUNDS
	resin_construction_allowed = FALSE
	can_build_special = FALSE
	is_resin_allowed = TRUE
	ceiling = CEILING_SANDSTONE_TEMPLE
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ceiling_muffle = FALSE

/area/yautja_ancient_temple/sanctum
	name = "\improper Ancient Temple - Sanctum Chamber"
	icon_state = "purple"

/area/yautja_ancient_temple/sanctum/crypt
	name = "\improper Ancient Temple - Sanctum Crypt"

/area/yautja_ancient_temple/sanctum/stairs
	name = "\improper Ancient Temple - Sanctum Stairway"

/area/yautja_ancient_temple/sanctum/acid_pit
	name = "\improper Ancient Temple - Sanctum Acid Pit"



/area/yautja_ancient_temple/gate
	icon_state = "shuttlered"
/area/yautja_ancient_temple/gate/north
	name = "\improper Ancient Temple - North Gate"

/area/yautja_ancient_temple/gate/north_west
	name = "\improper Ancient Temple - North-West Gate"

/area/yautja_ancient_temple/gate/west
	name = "\improper Ancient Temple - West Gate"

/area/yautja_ancient_temple/gate/west/second
	name = "\improper Ancient Temple - Minor West Gate"

/area/yautja_ancient_temple/gate/west/blocked
	name = "\improper Ancient Temple - Old Gate"





/area/yautja_ancient_temple/lower
	name = "\improper Ancient Temple (Lower)"

/area/yautja_ancient_temple/lower/armory
	name = "\improper Ancient Temple (L) - Armory"
	icon_state = "storage"

/area/yautja_ancient_temple/lower/crypt
	name = "\improper Ancient Temple (L) - Crypt"

/area/yautja_ancient_temple/lower/crypt/hall
	name = "\improper Ancient Temple (L) - Hall of Fallen"

/area/yautja_ancient_temple/lower/lab
	name = "\improper Ancient Temple (L) - Laboratory"
	icon_state = "xeno_lab"

/area/yautja_ancient_temple/lower/medical
	name = "\improper Ancient Temple (L) - Medical Bay"
	icon_state = "medbay3"

/area/yautja_ancient_temple/lower/arena_grounds
	name = "\improper Ancient Temple (L) - Arena Grounds"
	ceiling = CEILING_NONE
	icon_state = "start"

/area/yautja_ancient_temple/lower/quarters
	name = "\improper Ancient Temple (L) - Elite Quarters"
	icon_state = "bunker01_bedroom"

/area/yautja_ancient_temple/lower/offering
	name = "\improper Ancient Temple (L) - Offering Chamber"

/area/yautja_ancient_temple/lower/central_chamber
	name = "\improper Ancient Temple (L) - Central Chamber"

/area/yautja_ancient_temple/lower/meeting_hall
	name = "\improper Ancient Temple (L) - Meeting Chamber"

/area/yautja_ancient_temple/lower/feed_hall
	name = "\improper Ancient Temple (L) - Feed Hall"

/area/yautja_ancient_temple/lower/north_hall
	name = "\improper Ancient Temple (L) - North Hall"

/area/yautja_ancient_temple/lower/west_hall
	name = "\improper Ancient Temple (L) - West Hall"



/area/yautja_ancient_temple/stairs
	icon_state = "yellow"

/area/yautja_ancient_temple/stairs/central
	name = "\improper Ancient Temple (L) - Central Stairs"

/area/yautja_ancient_temple/stairs/central/mid
	name = "\improper Ancient Temple (M) - Central Stairs"

/area/yautja_ancient_temple/stairs/south
	name = "\improper Ancient Temple (L) - Southern Stairs"

/area/yautja_ancient_temple/stairs/south/mid
	name = "\improper Ancient Temple (M) - Southern Stairs"



/area/yautja_ancient_temple/mid
	name = "\improper Ancient Temple (Mid)"
	icon_state = "blue"

/area/yautja_ancient_temple/mid/quarters_elder
	name = "\improper Ancient Temple (M) - Elder Quarters"
	icon_state = "bunker01_bedroom"

/area/yautja_ancient_temple/mid/quarters_ancient
	name = "\improper Ancient Temple (M) - Ancient Quarters"
	icon_state = "bunker01_bedroom"

/area/yautja_ancient_temple/mid/arena_grounds
	name = "\improper Ancient Temple (M) - Arena Grounds"
	ceiling = CEILING_NONE
	icon_state = "start"

/area/yautja_ancient_temple/mid/temple_altar
	name = "\improper Ancient Temple (M) - Altar"


/area/yautja_ancient_temple/upper
	name = "\improper Ancient Temple (Upper)"

/area/yautja_ancient_temple/upper/arena_grounds
	name = "\improper Ancient Temple (U) - Arena Grounds"
	ceiling = CEILING_NONE
	icon_state = "start"

/area/yautja_ancient_temple/upper/hangar
	name = "\improper Ancient Temple (U) - Hangar"
