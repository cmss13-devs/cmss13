//The Last Bunker Areas//

/area/last_bunker
//	name = "Fort McNeil"
	icon_state = "tutorial"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

//parent types

/area/last_bunker/indoors
	name = "Bunker K31 - Indoors"
	icon_state = "unknown"
	ceiling = CEILING_METAL
	ceiling_muffle = FALSE
	soundscape_playlist = SCAPE_PL_LV522_INDOORS

/area/last_bunker/outdoors
	name = "Bunker K31 - Outdoors"
	icon_state = "unknown"
	ceiling = CEILING_NONE
	soundscape_playlist = AMBIENCE_LASTBUNKER

/area/last_bunker/oob
	name = "Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	ceiling_muffle = FALSE
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_NOBURROW
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
	soundscape_playlist = AMBIENCE_LASTBUNKER

//Landing Zones

/area/last_bunker/landing_zone_1
	name = "Surface Exterior - East - Landing Zone One"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

/area/last_bunker/landing_zone_2
	name = "Surface Exterior - South - Landing Zone Two"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

//Exterior Areas

// --

/area/last_bunker/outdoors/surface_exterior
	name = "Surface Exterior"
	icon_state = "green"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 100

/area/last_bunker/outdoors/surface_exterior/south
	icon_state = "central"
	name = "Surface Exterior - South"

/area/last_bunker/outdoors/surface_exterior/south_west
	icon_state = "southwest"
	name = "Surface Exterior - Southwest"

/area/last_bunker/outdoors/surface_exterior/south_east
	icon_state = "southeast"
	name = "Surface Exterior - Southeast"

/area/last_bunker/outdoors/surface_exterior/east
	icon_state = "east"
	name = "Surface Exterior - East"

/area/last_bunker/outdoors/surface_exterior/north_east
	icon_state = "northeast"
	name = "Surface Exterior - Northeast"

// --

/area/last_bunker/outdoors/eastern_cavern
	name = "Eastern Cavern - Bunker Eastern Exterior"
	icon_state = "central"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 100

/area/last_bunker/outdoors/eastern_cavern/mid_light
	name = "Eastern Cavern - Bunker Eastern Exterior"
	icon_state = "central"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 75

/area/last_bunker/outdoors/eastern_cavern/low_light
	name = "Eastern Cavern - Bunker Eastern Exterior"
	icon_state = "central"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 40

//Interior Areas

// --


