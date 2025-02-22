/area/navalis
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

//Parent Types

/area/navalis/oob
	name = "Navalis - Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE|AREA_NO_PARA

/area/navalis/indoors
	name = "Navalis - Indoors"
	icon_state = "cliff_blocked"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/area/navalis/outdoors
	name = "Navalis - Outdoors"
	icon_state = "cliff_blocked"
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV759_OUTDOORS
	ambience_exterior = AMBIENCE_CITY
	soundscape_interval = 25

//Water Types

/area/navalis/oob/water
	name = "Water - Near"
	icon_state = "blue2"
	ceiling = CEILING_NONE
	requires_power = FALSE
	base_lighting_alpha = 20
	minimap_color = MINIMAP_WATER

/area/navalis/oob/water/mid
	name = "Water - Middle"
	base_lighting_alpha = 30

/area/navalis/oob/water/far
	name = "Water - Far"
	base_lighting_alpha = 35

//Additional Out Of Bounds

/area/navalis/oob/powered
	requires_power = FALSE

// PSV Charon

/area/navalis/outdoors/charon
	name = "PSV Charon"
	icon_state = "unknown"
	ceiling = CEILING_NONE
	unoviable_timer = FALSE
	minimap_color = MINIMAP_AREA_JUNGLE

/area/navalis/outdoors/charon/surface_deck
	name = "PSV Charon - Forecastle Deck"
	icon_state = "syndie-ship"

/area/navalis/outdoors/charon/surface_deck/forecastle_deck
	name = "PSV Charon - Forecastle Deck"

/area/navalis/outdoors/charon/surface_deck/main_deck
	name = "PSV Charon - Main Deck"

/area/navalis/outdoors/charon/surface_deck/rear_deck
	name = "PSV Charon - Poop Deck"

// Medical-Science Rig

/area/navalis/indoors/med_sci
	name = "Medi-Sci Rig - Indoors"
	icon_state = "medbay"
	ceiling = CEILING_METAL
	minimap_color = MINIMAP_AREA_MEDBAY

/area/navalis/indoors/med_sci/foyer
	name = "Medi-Sci Rig - Foyer"

/area/navalis/indoors/med_sci/main_floor
	name = "Medi-Sci Rig - Treatment Floor"

/area/navalis/indoors/med_sci/surg_one
	name = "Medi-Sci Rig - Surgery One"

/area/navalis/indoors/med_sci/surg_two
	name = "Medi-Sci Rig - Surgery Two"

/area/navalis/indoors/med_sci/elevator
	name = "Medi-Sci Rig - Elevator"

/area/navalis/indoors/med_sci/break_room
	name = "Medi-Sci Rig - Employee Break Room"

/area/navalis/indoors/med_sci/pharmacy
	name = "Medi-Sci Rig - Pharmacy"

/area/navalis/indoors/med_sci/storage
	name = "Medi-Sci Rig - Medical Storage"

/area/navalis/indoors/med_sci/records_room
	name = "Medi-Sci Rig - Records Room"

/area/navalis/indoors/med_sci/science_lower_entrance
	name = "Medi-Sci Rig - Science Wing Lower-Entrance"

/area/navalis/indoors/med_sci/corridor
	name = "Medi-Sci Rig - Lower Corridor"

/area/navalis/indoors/med_sci/chemical_store
	name = "Medi-Sci Rig - Chemical Storage"

/area/navalis/indoors/med_sci/maintenance_port
	name = "Medi-Sci Rig - Port Maintenance"

/area/navalis/indoors/med_sci/maintenance_starboard
	name = "Medi-Sci Rig - Starboard Maintenance"

// Command Rig

/area/navalis/indoors/command
	name = "Command Rig - Indoors"
	icon_state = "bridge"
	minimap_color = MINIMAP_AREA_COMMAND

/area/navalis/indoors/command/aft_hallway
	name = "Command Rig - Aft-Hallway"

/area/navalis/indoors/command/port_hallway
	name = "Command Rig - Port-Hallway"

/area/navalis/indoors/command/starboard_hallway
	name = "Command Rig - Starboard-Hallway"

/area/navalis/indoors/command/office
	name = "Command Rig - Main Office"

/area/navalis/indoors/command/conferance
	name = "Command Rig - Conferance Room"

/area/navalis/indoors/command/director_office
	name = "Command Rig - Site Director's Office"

/area/navalis/indoors/command/cent_com
	name = "Command Rig - Central Command Room"

/area/navalis/indoors/command/oft_duty_room
	name = "Command Rig - Off-Duty Break Room"

/area/navalis/indoors/command/command_kitchen
	name = "Command Rig - Command Kitchen"

/area/navalis/indoors/command/server_room
	name = "Command Rig - Ancillery Backup Server Room"

/area/navalis/indoors/command/security
	name = "Command Rig - Level 1: Security Office"

/area/navalis/indoors/command/meeting_hall
	name = "Command Rig - Meeting Hall"

/area/navalis/indoors/command/bathroom
	name = "Command Rig - Level 1: Bathroom"

/area/navalis/indoors/command/tertiary_comms
	name = "Command Rig - Tertiary Communications"

/area/navalis/indoors/command/maintenance_port
	name = "Command Rig - Port Maintenance"

/area/navalis/indoors/command/maintenance_starboard
	name = "Command Rig - Starboard Maintenance"

// Logistical Rig

/area/navalis/indoors/logistic
	name = "Logistic Rig - Indoors"
	icon_state = "quartstorage"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING

/area/navalis/indoors/logistic/Port_hallway
	name = "Logistic Rig - Port-Hallway"

/area/navalis/indoors/logistic/workshop
	name = "Logistic Rig - Workshop"

/area/navalis/indoors/logistic/mech_bay
	name = "Logistic Rig - Mech-Bay"

/area/navalis/indoors/logistic/primary_storage
	name = "Logistic Rig - Primary Storage"

/area/navalis/indoors/logistic/elevator
	name = "Logistic Rig - Elevator"

/area/navalis/indoors/logistic/maintenance_port
	name = "Logistic Rig - Port Maintenance"

/area/navalis/indoors/logistic/maintenance_starboard
	name = "Logistic Rig - Starboard Maintenance"


// Industrial Rig

/area/navalis/indoors/industrial
	name = "Industrial Rig - Indoors"
	icon_state = "mining_production"
	unoviable_timer = FALSE
	minimap_color = MINIMAP_AREA_ENGI

/area/navalis/indoors/industrial/accessway
	name = "Industrial Rig - Sector-A: Accessway"

/area/navalis/indoors/industrial/power
	name = "Industrial Rig - Sector-B: Geothermal Reactor"

/area/navalis/indoors/industrial/refinery
	name = "Industrial Rig - Sector-C: Refinery"

/area/navalis/indoors/industrial/mining
	name = "Industrial Rig - Sector-D: Primary-Mining Rig"

// Residential Rig

/area/navalis/indoors/residential
	name = "Residential Rig - Indoors"
	icon_state = "fitness"
	ceiling = CEILING_REINFORCED_METAL
	unoviable_timer = FALSE
	minimap_color = MINIMAP_AREA_RESEARCH

/area/navalis/indoors/residential/accessway
	name = "Residential Rig - Aft-Accessway"

/area/navalis/indoors/residential/port
	name = "Residential Rig - Port-Section"

/area/navalis/indoors/residential/starboard
	name = "Residential Rig - Starboard-Section"

/area/navalis/indoors/residential/kitchen
	name = "Residential Rig - Kitchen"

/area/navalis/indoors/residential/landing_pad
	name = "Residential Rig - Landing-Pad"

// Landing Zones
/area/navalis/outdoors/landing_zone_1
	name = "Navalis Platform 13 - Medical Emergency Response - Landing Zone One"
	icon_state = "medbay3"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

/area/navalis/outdoors/landing_zone_2
	name = "Navalis Platform 13 - Logistics Delivery Area - Landing Zone Two"
	icon_state = "bunker01_engineering"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2


// Other

/area/navalis/outdoors/exterior
	name = "Exterior Walkway"
	icon_state = "eva"
	minimap_color = MINIMAP_AREA_MINING
	requires_power = FALSE

/area/navalis/outdoors/exterior/med_ext
	name = "Med-Sci Rig - Exterior Walkway"
	icon_state = "eva"

/area/navalis/outdoors/exterior/com_ext
	name = "Command Rig - Exterior Walkway"

/area/navalis/outdoors/exterior/log_ext
	name = "Logistical Rig - Exterior Walkway"

/area/navalis/outdoors/exterior/ind_ext
	name = "Industrial Rig - Exterior Walkway"

/area/navalis/outdoors/comm_one
	name = "Navalis Platform 13 - Exterior Communications Relay"

/area/navalis/outdoors/exterior_xeno_only
	name = "Industrial Rig - Exterior Lattice Walkway"
	icon_state = "red2"
	flags_area = AREA_NOTUNNEL|AREA_CONTAINMENT|NOT_WEEDABLE|AREA_NO_PARA
	base_lighting_alpha = 35
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE
	requires_power = FALSE

/area/navalis/outdoors/exterior_xeno_only/lz1
	name = "Medical / LZ1 - Exterior Lattice Walkway"

/area/navalis/outdoors/exterior_xeno_only/lz2
	name = "Medical / LZ2 - Exterior Lattice Walkway"

/area/navalis/outdoors/exterior_xeno_only/mining
	name = "Mining Rig - Exterior Lattice Walkway"

/area/navalis/indoors/xeno_growth
	name = "Unidentified Xeno-biological Growth: Industrial Area"
	icon_state = "eta_xeno"
	unoviable_timer = FALSE
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	requires_power = FALSE

/area/navalis/indoors/xeno_growth/residential
	name = "Unidentified Xeno-biological Growth: Residential Entrance Area"
