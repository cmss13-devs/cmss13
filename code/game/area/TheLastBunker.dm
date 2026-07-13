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
	temperature = ICE_COLONY_TEMPERATURE

/area/last_bunker/oob
	name = "Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	ceiling_muffle = FALSE
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_NOBURROW
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
	unlimited_power = TRUE

/area/last_bunker/oob/surface_light
	base_lighting_alpha = 35
	soundscape_playlist = AMBIENCE_LASTBUNKER

//Landing Zones

/area/last_bunker/landing_zone_1
	name = "Surface Exterior - East - Landing Zone One"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_ICE
	linked_lz = DROPSHIP_LZ1
	base_lighting_alpha = 35

/area/last_bunker/landing_zone_2
	name = "Surface Exterior - South - Landing Zone Two"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_ICE
	linked_lz = DROPSHIP_LZ2
	base_lighting_alpha = 35

//Exterior Areas

// --

/area/last_bunker/outdoors/surface_exterior
	name = "Surface Exterior"
	icon_state = "green"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 35

/area/last_bunker/outdoors/surface_exterior/center
	icon_state = "central"
	name = "Surface Exterior - South Bunker Exterior"

/area/last_bunker/outdoors/surface_exterior/south
	icon_state = "central"
	name = "Surface Exterior - South"
	linked_lz = DROPSHIP_LZ1

/area/last_bunker/outdoors/surface_exterior/south_west
	icon_state = "southwest"
	name = "Surface Exterior - Southwest"
	linked_lz = DROPSHIP_LZ1

/area/last_bunker/outdoors/surface_exterior/south_east
	icon_state = "southeast"
	name = "Surface Exterior - Southeast"
	linked_lz = DROPSHIP_LZ2

/area/last_bunker/outdoors/surface_exterior/east
	icon_state = "east"
	name = "Surface Exterior - East"
	linked_lz = DROPSHIP_LZ1

/area/last_bunker/outdoors/surface_exterior/north_east
	icon_state = "northeast"
	name = "Surface Exterior - Northeast"
	linked_lz = DROPSHIP_LZ1

// --

/area/last_bunker/outdoors/eastern_cavern
	name = "Eastern Cavern - Bunker Eastern Exterior"
	icon_state = "central"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 30

/area/last_bunker/outdoors/eastern_cavern/mid_light
	name = "Eastern Cavern - Bunker Eastern Exterior"
	icon_state = "central"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 25

/area/last_bunker/outdoors/eastern_cavern/low_light
	name = "Eastern Cavern - Bunker Eastern Exterior"
	icon_state = "central"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 20

/area/last_bunker/outdoors/eastern_cavern/no_light
	name = "Eastern Cavern - Bunker Eastern Exterior"
	icon_state = "central"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 0

// --

/area/last_bunker/outdoors/cavern_external_access
	name = "Bunker Cavern - Roof"
	icon_state = "central"
	minimap_color = MINIMAP_SNOW
	base_lighting_alpha = 35

/area/last_bunker/outdoors/cavern_external_access/central
	name = "Bunker Cavern - Exposed Roof - Central"

/area/last_bunker/outdoors/cavern_external_access/central/adj
	base_lighting_alpha = 20

/area/last_bunker/outdoors/cavern_external_access/north
	name = "Bunker Cavern - Exposed Roof - North"

/area/last_bunker/outdoors/cavern_external_access/north/adj
	base_lighting_alpha = 20

/area/last_bunker/outdoors/cavern_external_access/west
	name = "Bunker Cavern - Exposed Roof - West"

/area/last_bunker/outdoors/cavern_external_access/west/adj
	base_lighting_alpha = 20

/area/last_bunker/outdoors/cavern_external_access/south_west
	name = "Bunker Cavern - Exposed Roof - South-West"

/area/last_bunker/outdoors/cavern_external_access/south_west/adj
	base_lighting_alpha = 20

//Interior Areas

// --

/area/last_bunker/indoors/comms
	name = "Communications Areas"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	icon_state = "engine"

/area/last_bunker/indoors/comms/tcomms_1
	name = "Bunker K31 - Primary Communications"

/area/last_bunker/indoors/comms/tcomms_2_a
	name = "Bunker K31 - Secondary Communications"

/area/last_bunker/indoors/comms/tcomms_2_b
	name = "Bunker K31 - Tertiary Communications"

// --

/area/last_bunker/indoors/entry_zone
	name = "Bunker K31 - Entrance/Logistics Zone"
	minimap_color = MINIMAP_AREA_MINING
	icon_state = "maint_cargo"

/area/last_bunker/indoors/entry_zone/train
	name = "Bunker K31 - Rail System"
	minimap_color = MINIMAP_AREA_COLONY_SPACE_PORT
	icon_state = "HH_Basement"

/area/last_bunker/indoors/entry_zone/power
	name = "Bunker K31 - Emergency Bunker Generator"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	icon_state = "HH_Basement"

// --

/area/last_bunker/indoors/sustainment_zone
	name = "Bunker K31 - Admin/Medical Zone"
	minimap_color = MINIMAP_AREA_MEDBAY
	icon_state = "medbay"

// --

/area/last_bunker/indoors/residential_zone
	name = "Bunker K31 - Residential Zone"
	minimap_color = MINIMAP_AREA_RESEARCH
	icon_state = "purple"

// --

/area/last_bunker/indoors/hanger_zone
	name = "Bunker K31 - Hanger Zone"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	icon_state = "dk_yellow"

// --

/area/last_bunker/indoors/synthetic_zone
	name = "Bunker K31 - Synthetic Operations Zone"
	minimap_color = MINIMAP_AREA_SEC
	icon_state = "ai_cyborg"

// --

/area/last_bunker/indoors/command_zone
	name = "Bunker K31 - Bunker Command Ops Zone"
	minimap_color = MINIMAP_AREA_COMMAND
	icon_state = "bridge"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

// --

/area/last_bunker/indoors/cavern
	name = "Bunker Cavern"
	minimap_color = MINIMAP_AREA_CAVES
	icon_state = "cave"
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
	temperature = ICE_COLONY_TEMPERATURE

/area/last_bunker/indoors/cavern/south_entrance
	name = "Bunker Cavern - Tram/Bunker Cavern - South"
	base_lighting_alpha = 35

/area/last_bunker/indoors/cavern/south_entrance/low_light
	base_lighting_alpha = 20

/area/last_bunker/indoors/cavern/north_entrance/zero_light
	base_lighting_alpha = 0

/area/last_bunker/indoors/cavern/north_entrance
	name = "Bunker Cavern - Tram/Bunker Cavern - North"
	base_lighting_alpha = 35

/area/last_bunker/indoors/cavern/north_entrance/low_light
	base_lighting_alpha = 20

/area/last_bunker/indoors/cavern/north_entrance/zero_light
	base_lighting_alpha = 0

/area/last_bunker/indoors/cavern/central
	name = "Bunker Cavern - Interior Area - Central"

/area/last_bunker/indoors/cavern/west
	name = "Bunker Cavern - Interior Area - West"

/area/last_bunker/indoors/cavern/north
	name = "Bunker Cavern - Interior Area - North"

//Special Out Of Bound Areas

// --

/area/last_bunker/oob/electrical_tunnel
	name = "Bunker K31 - Electrical Sub-Network"
	icon_state = "engine"

// --

/area/last_bunker/oob/hydro
	name = "Bunker K31 - Primary Hydroponics"
	icon_state = "bunker01_hydroponics"

// --

/area/last_bunker/oob/train
	name = "Bunker Extended Network - External Rail System"
	icon_state = "engine_monitoring"
