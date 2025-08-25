//LV624 AREAS--------------------------------------//
/area/lv624
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	ambience_exterior = AMBIENCE_JUNGLE
	minimap_color = MINIMAP_AREA_COLONY

/area/lv624/ground
	name = "Ground"
	icon_state = "green"
	always_unpowered = 1 //Will this mess things up? God only knows

//Jungle
/area/lv624/ground/jungle
	minimap_color = MINIMAP_AREA_JUNGLE
	flags_area = AREA_YAUTJA_HANGABLE

/area/lv624/ground/jungle/south_east_jungle
	name ="\improper Southeast Jungle"
	icon_state = "southeast"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/south_central_jungle
	name ="\improper Southern Central Jungle"
	icon_state = "south"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/south_west_jungle
	name ="\improper Southwest Jungle"
	icon_state = "southwest"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/south_west_jungle/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/jungle/west_jungle
	name ="\improper Western Jungle"
	icon_state = "west"
	//ambience = list('sound/ambience/jungle_amb1.ogg')
	linked_lz = DROPSHIP_LZ2

/area/lv624/ground/jungle/west_jungle/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/jungle/east_jungle
	name ="\improper Eastern Jungle"
	icon_state = "east"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/north_west_jungle
	name ="\improper Northwest Jungle"
	icon_state = "northwest"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/north_jungle
	name ="\improper Northern Jungle"
	icon_state = "north"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/north_east_jungle
	name ="\improper Northeast Jungle"
	icon_state = "northeast"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/central_jungle
	name ="\improper Central Jungle"
	icon_state = "central"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/west_central_jungle
	name ="\improper West Central Jungle"
	icon_state = "west"
	//ambience = list('sound/ambience/jungle_amb1.ogg')
	linked_lz = DROPSHIP_LZ2

/area/lv624/ground/jungle/east_central_jungle
	name ="\improper East Central Jungle"
	icon_state = "east"
	//ambience = list('sound/ambience/jungle_amb1.ogg')


//The Barrens
/area/lv624/ground/barrens
	name = "\improper Barrens"
	icon_state = "yellow"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/west_barrens
	name = "\improper Western Barrens"
	icon_state = "west"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/west_barrens/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/barrens/east_barrens
	name = "\improper Eastern Barrens"
	icon_state = "east"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/east_barrens/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/barrens/containers
	name = "\improper Containers"
	icon_state = "blue-red"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/north_east_barrens
	name = "\improper North Eastern Barrens"
	icon_state = "northeast"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/north_east_barrens/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/barrens/south_west_barrens
	name = "\improper South Western Barrens"
	icon_state = "southwest"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/central_barrens
	name = "\improper Central Barrens"
	icon_state = "away1"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/south_eastern_barrens
	name = "\improper South Eastern Barrens"
	icon_state = "southeast"
// ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/south_eastern_jungle_barrens
	name = "\improper South East Jungle Barrens"
	icon_state = "southeast"
// ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/river
	name = "\improper River"
	icon_state = "blueold"
// ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/river/west_river
	name = "\improper Western River"
	icon_state = "blueold"
// ambience = list('sound/ambience/jungle_amb1.ogg')
/area/lv624/ground/river/central_river
	name = "\improper Central River"
	icon_state = "purple"
// ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/river/east_river
	name = "\improper Eastern River"
	icon_state = "bluenew"
// ambience = list('sound/ambience/jungle_amb1.ogg')


//Colony Areas
/area/lv624/ground/colony
	name = "\improper Weyland-Yutani Compound"
	icon_state = "green"

/area/lv624/ground/colony/north_nexus_road
	name = "\improper North Nexus Road"
	icon_state = "north"

/area/lv624/ground/colony/south_medbay_road
	name = "\improper South Medbay Road"
	icon_state = "south"

/area/lv624/ground/colony/south_nexus_road
	name = "\improper South Nexus Road"
	icon_state = "south"

/area/lv624/ground/colony/west_nexus_road
	name = "\improper West Nexus Road"
	icon_state = "west"

/area/lv624/ground/colony/north_tcomms_road
	name = "\improper North T-Comms Road"
	icon_state = "north"
	linked_lz = DROPSHIP_LZ2

/area/lv624/ground/colony/west_tcomms_road
	name = "\improper West T-Comms Road"
	icon_state = "west"
	linked_lz = DROPSHIP_LZ2

/area/lv624/ground/colony/telecomm
	name = "\improper LZ1 Communications Relay"
	icon_state = "ass_line"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	linked_lz = DROPSHIP_LZ1
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_LOW
	always_unpowered = FALSE

/area/lv624/ground/colony/telecomm/cargo
	name = "\improper Far North Storage Dome Communications Relay"
	linked_lz = DROPSHIP_LZ1


/area/lv624/ground/colony/telecomm/sw_lz1
	name = "\improper South-West LZ1 Communications Relay"
	ceiling = CEILING_NONE
	linked_lz = DROPSHIP_LZ1

/area/lv624/ground/colony/telecomm/tcommdome
	name = "\improper Telecomms Dome Communications Relay"

/area/lv624/ground/colony/telecomm/tcommdome/south
	name = "\improper South Telecomms Dome Communications Relay"
	ceiling = CEILING_NONE

/area/lv624/ground/colony/telecomm/sw_lz2
	name = "\improper South-West LZ2 Communications Relay"
	ceiling = CEILING_NONE
	linked_lz = DROPSHIP_LZ2

// ambience = list('sound/ambience/jungle_amb1.ogg')


//The Caves
/area/lv624/ground/caves //Does not actually exist
	name ="\improper Caves"
	icon_state = "cave"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambisin4.ogg')
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	minimap_color = MINIMAP_AREA_CAVES
	unoviable_timer = FALSE

/area/lv624/ground/caves/west_caves
	name ="\improper Western Caves"
	icon_state = "away1"

/area/lv624/ground/caves/south_west_caves
	name ="\improper South Western Caves"
	icon_state = "red"

/area/lv624/ground/caves/east_caves
	name ="\improper Eastern Caves"
	icon_state = "away"

/area/lv624/ground/caves/central_caves
	name ="\improper Central Caves"
	icon_state = "away4" //meh

/area/lv624/ground/caves/north_west_caves
	name ="\improper North Western Caves"
	icon_state = "cave"

/area/lv624/ground/caves/north_east_caves
	name ="\improper North Eastern Caves"
	icon_state = "cave"

/area/lv624/ground/caves/north_central_caves
	name ="\improper North Central Caves"
	icon_state = "away3" //meh

/area/lv624/ground/caves/north_central_caves/lake_house_tower
	name = "\improper Lake House Communications Relay"
	ceiling = CEILING_NONE
	icon_state = "yellow"

/area/lv624/ground/caves/south_central_caves
	name ="\improper South Central Caves"
	icon_state = "away2" //meh

/area/lv624/ground/caves/south_east_caves
	name ="\improper South East Caves"
	icon_state = "away2" //meh

/area/lv624/ground/caves/sand_temple
	name = "\improper Sand Temple"
	icon_state = "bluenew"

/area/lv624/ground/caves/sand_temple/powered
	name = "\improper Sand Temple - Powered"
	icon_state = "green"
	requires_power = FALSE

//Lazarus landing
/area/lv624/lazarus
	name = "\improper Lazarus"
	icon_state = "green"
	ceiling = CEILING_METAL

/area/lv624/lazarus/landing_zones
	ceiling = CEILING_NONE
	is_landing_zone = TRUE

/area/lv624/lazarus/landing_zones/lz1
	name = "\improper Alamo Landing Zone"
	linked_lz = DROPSHIP_LZ1

/area/lv624/lazarus/landing_zones/lz2
	name = "\improper Normandy Landing Zone"
	linked_lz = DROPSHIP_LZ2

/area/lv624/lazarus
	name = "\improper Lazarus"
	icon_state = "green"
	ceiling = CEILING_METAL

/area/lv624/lazarus/corporate_dome
	name = "\improper Corporate Dome"
	icon_state = "green"
	linked_lz = DROPSHIP_LZ2

/area/lv624/lazarus/yggdrasil
	name = "\improper Yggdrasil Tree"
	icon_state = "atmos"
	ceiling = CEILING_GLASS

/area/lv624/lazarus/medbay
	name = "\improper Medbay"
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/lv624/lazarus/armory
	name = "\improper Armory"
	icon_state = "armory"
	minimap_color = MINIMAP_AREA_SEC

/area/lv624/lazarus/security
	name = "\improper Security"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC

/area/lv624/lazarus/captain
	name = "\improper Commandant's Quarters"
	icon_state = "captain"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv624/lazarus/hop
	name = "\improper Head of Personnel's Office"
	icon_state = "head_quarters"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv624/lazarus/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"
	linked_lz = DROPSHIP_LZ1

/area/lv624/lazarus/canteen
	name = "\improper Canteen"
	icon_state = "cafeteria"
	linked_lz = DROPSHIP_LZ1

/area/lv624/lazarus/main_hall
	name = "\improper Main Hallway"
	icon_state = "hallC1"
	linked_lz = DROPSHIP_LZ1

/area/lv624/lazarus/toilet
	name = "\improper Dormitory Toilet"
	icon_state = "toilet"

/area/lv624/lazarus/chapel
	name = "\improper Chapel"
	icon_state = "chapel"
	//ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg')

/area/lv624/lazarus/toilet
	name = "\improper Dormitory Toilet"
	icon_state = "toilet"

/area/lv624/lazarus/sleep_male
	name = "\improper Male Dorm"
	icon_state = "Sleep"

/area/lv624/lazarus/sleep_female
	name = "\improper Female Dorm"
	icon_state = "Sleep"
	linked_lz = DROPSHIP_LZ1

/area/lv624/lazarus/quart
	name = "\improper Quartermasters"
	icon_state = "quart"
	linked_lz = DROPSHIP_LZ1

/area/lv624/lazarus/quartstorage
	name = "\improper Cargo Bay"
	icon_state = "quartstorage"
	linked_lz = DROPSHIP_LZ1

/area/lv624/lazarus/quartstorage/outdoors
	name = "\improper Cargo Bay Area"
	icon_state = "purple"
	ceiling = CEILING_NONE
	linked_lz = DROPSHIP_LZ1
	always_unpowered = TRUE

/area/lv624/lazarus/engineering
	name = "\improper Engineering"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv624/lazarus/comms
	name = "\improper Communications Relay"
	icon_state = "tcomsatcham"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv624/lazarus/secure_storage
	name = "\improper Secure Storage"
	icon_state = "storage"
	flags_area = AREA_NOTUNNEL
	linked_lz = DROPSHIP_LZ2

/area/lv624/lazarus/robotics
	name = "\improper Robotics"
	icon_state = "ass_line"
	linked_lz = DROPSHIP_LZ2

/area/lv624/lazarus/research
	name = "\improper Research Lab"
	icon_state = "toxlab"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/lv624/lazarus/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

/area/lv624/lazarus/hydroponics
	name = "\improper Hydroponics"
	icon_state = "hydro"
	ceiling = CEILING_GLASS

/area/lv624/landing/console
	name = "\improper LZ1 'Nexus'"
	icon_state = "tcomsatcham"
	requires_power = FALSE

/area/lv624/landing/console2
	name = "\improper LZ2 'Robotics'"
	icon_state = "tcomsatcham"
	requires_power = FALSE

/area/lv624/lazarus/crashed_ship
	name = "\improper Crashed Ship"
	icon_state = "syndie-ship"

/area/lv624/lazarus/crashed_ship_containers
	name = "\improper Crashed Ship Containers"
	icon_state = "syndie-ship"
