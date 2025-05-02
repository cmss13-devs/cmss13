//Areas for Shiva's Snowball, aka Ice LZ1, above ground revamp.

/area/shiva
	name = "Shiva's Snowball"
	icon = 'icons/turf/area_shiva.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "shiva"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	temperature = ICE_COLONY_TEMPERATURE
	minimap_color = MINIMAP_AREA_COLONY

/area/shuttle/drop1/shiva
	name = "Shiva's Snowball - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_shiva.dmi'
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_LZ

/area/shuttle/drop2/shiva
	name = "Shiva's Snowball - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_shiva.dmi'
	linked_lz = DROPSHIP_LZ2
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/lz1_console
	name = "Shiva's Snowball - Dropship Alamo Console"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/lz1_console/two
	name = "Shiva's Snowball - Dropship Normandy Console"
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior
	name = "Shiva's Snowball - Exterior"
	ceiling = CEILING_NONE


/area/shiva/interior
	name = "Shiva's Snowball - Interior"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	requires_power = TRUE

/area/shiva/interior/oob
	name = "Shiva's Snowball - Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE

/area/shiva/interior/oob/dev_room
	name = "Shiva's Snowball - Secret Room"
	icon_state = "shiva"

//telecomms areas - exterior
/area/shiva/exterior/telecomm
	name = "Shiva's Snowball - Communications Relay"
	icon_state = "ass_line"

/area/shiva/exterior/telecomm/lz1_north
	name = "Shiva's Snowball - North LZ1 Communications Relay"
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

/area/shiva/exterior/telecomm/lz2_southeast
	name = "Shiva's Snowball - South-East LZ2 Communications Relay"
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

/area/shiva/exterior/telecomm/lz2_northeast
	name = "Shiva's Snowball - North-East LZ2 Communications Relay"
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

//telecomms areas - interior
/area/shiva/interior/telecomm
	name = "Shiva's Snowball - Communications Relay"
	icon_state = "ass_line"

/area/shiva/interior/telecomm/lz1_biceps
	name = "Shiva's Snowball - Fort Biceps Communications Relay"
	icon_state = "hangars0"
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/interior/telecomm/lz1_flight
	name = "Shiva's Snowball - LZ1 Aerodrome Communications Relay"
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

/area/shiva/interior/telecomm/lz2_research
	name = "Shiva's Snowball - Argentinian Communications Relay"
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

//telecomms areas - caves
/area/shiva/caves/telecomm
	name = "Shiva's Snowball - Communications Relay"
	icon_state = "ass_line"

/area/shiva/caves/telecomm/lz2_south
	name = "Shiva's Snowball - Backup Communications Relay"
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

//exterior areas

/area/shiva/exterior/lz1_valley
	name = "Shiva's Snowball - Landing Valley"
	icon_state = "landing_valley"
	linked_lz = DROPSHIP_LZ1
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/lz2_fortress
	name = "Shiva's Snowball - Landing Bulwark"
	icon_state = "lz2_fortress"
	linked_lz = DROPSHIP_LZ2
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/valley
	name = "Shiva's Snowball - Storage Bunker Valley"
	icon_state = "junkyard1"
	unoviable_timer = FALSE

/area/shiva/exterior/southwest_valley
	name = "Shiva's Snowball - Southwest Valley"
	icon_state = "sw"
	linked_lz = DROPSHIP_LZ1

/area/shiva/exterior/cp_colony_grounds
	name = "Shiva's Snowball - Colony Grounds"
	icon_state = "junkyard2"
	unoviable_timer = FALSE

/area/shiva/exterior/junkyard
	name = "Shiva's Snowball - Junkyard"
	icon_state = "junkyard0"

/area/shiva/exterior/junkyard/fortbiceps
	name = "Shiva's Snowball - Fort Biceps"
	icon_state = "junkyard1"

/area/shiva/exterior/junkyard/cp_bar
	name = "Shiva's Snowball - Bar Grounds"
	icon_state = "bar0"
	unoviable_timer = FALSE

/area/shiva/exterior/cp_s_research
	name = "Shiva's Snowball - Research Hab Exterior"
	icon_state = "junkyard1"
	unoviable_timer = FALSE

/area/shiva/exterior/cp_lz2
	name = "Shiva's Snowball - North Colony Grounds"
	icon_state = "junkyard3"
	linked_lz = DROPSHIP_LZ2

/area/shiva/exterior/research_alley
	name = "Shiva's Snowball - South Research Alley"
	icon_state = "junkyard2"
	minimap_color = MINIMAP_AREA_RESEARCH



//interior areas

/area/shiva/interior/caves
	name = "Shiva's Snowball - Caves"
	icon_state = "caves0"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/shiva/interior/caves/right_spiders
	name = "Shiva's Snowball - Forgotten Passage"
	icon_state = "caves1"
	unoviable_timer = FALSE

/area/shiva/interior/caves/left_spiders
	name = "Shiva's Snowball - Crevice Passage"
	icon_state = "caves2"

/area/shiva/interior/caves/s_lz2
	name = "Shiva's Snowball - South LZ2 Caves"
	icon_state = "caves3"
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

/area/shiva/interior/caves/cp_camp
	name = "Shiva's Snowball - Cave Camp"
	icon_state = "bar3"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/shiva/interior/caves/research_caves
	name = "Shiva's Snowball - South Research Hab Caves"
	icon_state = "caves2"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE
	unoviable_timer = FALSE

/area/shiva/interior/caves/medseceng_caves
	name = "Shiva's Snowball - South Med-Sec-Eng Complex Caves"
	icon_state = "caves3"
	unoviable_timer = FALSE

/area/shiva/interior/colony
	name = "Shiva's Snowball - Colony MegaStruct(TM)"
	icon_state = "res0"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/shiva/interior/colony/botany
	name = "Shiva's Snowball - MegaStruct(TM) Botanical Dorms"
	icon_state = "res1"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/shiva/interior/colony/clf_shuttle
	name = "Shiva's Snowball - Disabled Cargo Shuttle"
	icon_state = "res0"

/area/shiva/interior/colony/s_admin
	name = "Shiva's Snowball - MegaStruct(TM) Crisis Center"
	icon_state = "res2"

/area/shiva/interior/colony/n_admin
	name = "Shiva's Snowball - MegaStruct(TM) Administration"
	icon_state = "res3"
	minimap_color = MINIMAP_AREA_COMMAND

/area/shiva/interior/colony/central
	name = "Shiva's Snowball - MegaStruct(TM) Residential Life"
	icon_state = "res4"

/area/shiva/interior/colony/research_hab
	name = "Shiva's Snowball - Research Hab Interior"
	icon_state = "res2"
	unoviable_timer = FALSE

/area/shiva/interior/colony/medseceng
	name = "Shiva's Snowball - Colony MegaStruct(TM) Med-Sec-Eng Segment"
	icon_state = "res0"
	unoviable_timer = FALSE

/area/shiva/interior/aerodrome
	name = "Shiva's Snowball - Aerodrome"
	icon_state = "hangars0"
	linked_lz = DROPSHIP_LZ1

/area/shiva/interior/bar
	name = "Shiva's Snowball - Anti-Freeze Bar"
	icon_state = "hangars0"

/area/shiva/interior/fort_biceps
	name = "Shiva's Snowball - Fort Biceps Interior"
	icon_state = "hangars0"

/area/shiva/interior/warehouse
	name = "Shiva's Snowball - Blue Warehouse"
	icon_state = "hangars1"
	linked_lz = DROPSHIP_LZ1

/area/shiva/interior/warehouse/caves
	name = "Shiva's Snowball - Blue Warehouse Ice Cave"
	icon_state = "caves1"

/area/shiva/interior/valley_huts
	name = "Shiva's Snowball - Valley Bunker 1"
	icon_state = "hangars1"
	unoviable_timer = FALSE

/area/shiva/interior/valley_huts/no2
	name = "Shiva's Snowball - Valley Bunker 2"
	icon_state = "hangars2"
	unoviable_timer = FALSE

/area/shiva/interior/valley_huts/disposals
	name = "Shiva's Snowball - Valley Disposals"
	icon_state = "hangars3"
	unoviable_timer = FALSE

/area/shiva/interior/garage
	name = "Shiva's Snowball - Cargo Tug Repair Station"
	icon_state = "hangars2"
	unoviable_timer = FALSE

/area/shiva/interior/lz2_habs
	name = "Shiva's Snowball - Argentinian Research Headquarters"
	icon_state = "bar1"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/shiva/interior/aux_power
	name = "Shiva's Snowball - Auxiliary Generator Station"
	icon_state = "hangars0"
