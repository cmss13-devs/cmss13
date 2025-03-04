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
	minimap_color = MINIMAP_AREA_OOB
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
	base_lighting_alpha = 25
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

/area/navalis/oob/empty_space
	requires_power = FALSE
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_WATER
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE|AREA_NO_PARA

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

/area/navalis/indoors/charon
	name = "PSV Charon - Below Deck"
	icon_state = "unknown"
	ceiling = CEILING_METAL
	unoviable_timer = FALSE
	minimap_color = MINIMAP_AREA_JUNGLE

// Middle Deck Indoor

/area/navalis/indoors/charon/surface_deck
	icon_state = "syndie-ship"

/area/navalis/indoors/charon/surface_deck/main_deck
	name = "PSV Charon - Main Deck"

/area/navalis/indoors/charon/surface_deck/rear_deck
	name = "PSV Charon - Poop Deck"

// Lower Deck

/area/navalis/indoors/charon/below_deck
	icon_state = "syndie-ship"

/area/navalis/indoors/charon/below_deck/front
	name = "PSV Charon - Below-Deck Fore"

/area/navalis/indoors/charon/below_deck/middle
	name = "PSV Charon - Below-Deck: Cargo Hold"

/area/navalis/indoors/charon/below_deck/rear
	name = "PSV Charon - Below-Deck Aft"

// Upper Deck

/area/navalis/indoors/charon/upper_deck
	icon_state = "syndie-ship"

/area/navalis/indoors/charon/upper_deck/front
	name = "PSV Charon - Upper-Deck: Bridge"

/area/navalis/indoors/charon/upper_deck/rear
	name = "PSV Charon - Upper-Deck: Engineering"


// Medical-Science Rig

/area/navalis/indoors/med_sci
	name = "Medi-Sci Rig - Indoors"
	icon_state = "medbay"
	ceiling = CEILING_METAL
	minimap_color = MINIMAP_AREA_MEDBAY

/area/navalis/indoors/med_sci/foyer
	name = "Medi-Sci Rig - Level-1: Foyer"

/area/navalis/indoors/med_sci/main_floor
	name = "Medi-Sci Rig - Level-1: Treatment Floor"

/area/navalis/indoors/med_sci/surg_one
	name = "Medi-Sci Rig - Level-1: Surgery One"

/area/navalis/indoors/med_sci/surg_two
	name = "Medi-Sci Rig - Level-1: Surgery Two"

/area/navalis/indoors/med_sci/elevator
	name = "Medi-Sci Rig - Level-1: Elevator"

/area/navalis/indoors/med_sci/break_room
	name = "Medi-Sci Rig - Level-1: Employee Break Room"

/area/navalis/indoors/med_sci/pharmacy
	name = "Medi-Sci Rig - Level-1: Pharmacy"

/area/navalis/indoors/med_sci/storage
	name = "Medi-Sci Rig - Level-1: Medical Storage"

/area/navalis/indoors/med_sci/records_room
	name = "Medi-Sci Rig - Level-1: Records Room"

/area/navalis/indoors/med_sci/science_lower_entrance
	name = "Medi-Sci Rig - Level-1: Sci-Wing Lower-Entrance"

/area/navalis/indoors/med_sci/corridor
	name = "Medi-Sci Rig - Level-1: Lower Corridor"

/area/navalis/indoors/med_sci/chemical_store
	name = "Medi-Sci Rig - Level-1: Chemical Storage"

/area/navalis/indoors/med_sci/maintenance_port
	name = "Medi-Sci Rig - Level-1: Port Maintenance"

/area/navalis/indoors/med_sci/maintenance_starboard
	name = "Medi-Sci Rig - Level-1: Starboard Maintenance"

// Lower-Deck

/area/navalis/indoors/med_sci/lower_level
	name = "Medi-Sci Rig - Level-0"

/area/navalis/indoors/med_sci/lower_level/port
	name = "Medi-Sci Rig - Level-0: Port-Corridor"

/area/navalis/indoors/med_sci/lower_level/starboard
	name = "Medi-Sci Rig - Level-0: Starboard-Corridor"

/area/navalis/indoors/med_sci/lower_level/records
	name = "Medi-Sci Rig - Level-0: Storage Records"

/area/navalis/indoors/med_sci/lower_level/delivery
	name = "Medi-Sci Rig - Level-0: Delivery Bay"

// Upper-Deck

/area/navalis/indoors/med_sci/upper_level
	name = "Medi-Sci Rig - Level-2"

/area/navalis/indoors/med_sci/upper_level/entrance
	name = "Medi-Sci Rig - Level-2: Entrance"

/area/navalis/indoors/med_sci/upper_level/morgue
	name = "Medi-Sci Rig - Level-2: Morgue"

/area/navalis/indoors/med_sci/upper_level/sec
	name = "Medi-Sci Rig - Level-2: Security Office"

/area/navalis/indoors/med_sci/upper_level/corridor
	name = "Medi-Sci Rig - Level-2: Corridor"

/area/navalis/indoors/med_sci/upper_level/flight
	name = "Medi-Sci Rig - Level-2: Medical Flight Control"

/area/navalis/indoors/med_sci/upper_level/store
	name = "Medi-Sci Rig - Level-2: Storage"

/area/navalis/indoors/med_sci/upper_level/on_duty
	name = "Medi-Sci Rig - Level-2: On-Call Standby Quarters"

/area/navalis/indoors/med_sci/upper_level/sci_ent
	name = "Medi-Sci Rig - Level-2: Sci-Wing Entrance"

/area/navalis/indoors/med_sci/upper_level/sci_lab
	name = "Medi-Sci Rig - Level-2: Sci-Wing Lab"

/area/navalis/indoors/med_sci/upper_level/sci_scan
	name = "Medi-Sci Rig - Level-2: Sci-Wing Scanning Room"

// Command Rig

/area/navalis/indoors/command
	name = "Command Rig - Indoors"
	icon_state = "bridge"
	minimap_color = MINIMAP_AREA_COMMAND

/area/navalis/indoors/command/aft_hallway
	name = "Command Rig - Level-1: Aft-Hallway"

/area/navalis/indoors/command/port_hallway
	name = "Command Rig - Level-1: Port-Hallway"

/area/navalis/indoors/command/starboard_hallway
	name = "Command Rig - Level-1: Starboard-Hallway"

/area/navalis/indoors/command/office
	name = "Command Rig - Level-1: Main Office"

/area/navalis/indoors/command/conferance
	name = "Command Rig - Level-1: Conferance Room"

/area/navalis/indoors/command/director_office
	name = "Command Rig - Level-1: Site Director's Office"

/area/navalis/indoors/command/cent_com
	name = "Command Rig - Level-1: Central Command Room"

/area/navalis/indoors/command/oft_duty_room
	name = "Command Rig - Level-1: Off-Duty Break Room"

/area/navalis/indoors/command/command_kitchen
	name = "Command Rig - Level-1: Command Kitchen"

/area/navalis/indoors/command/server_room
	name = "Command Rig - Level-1: Ancillery Backup Server Room"

/area/navalis/indoors/command/security
	name = "Command Rig - Level-1: Security Office"

/area/navalis/indoors/command/meeting_hall
	name = "Command Rig - Level-1: Meeting Hall"

/area/navalis/indoors/command/bathroom
	name = "Command Rig - Level-1: Bathroom"

/area/navalis/indoors/command/tertiary_comms
	name = "Command Rig - Level-1: Tertiary Communications"

/area/navalis/indoors/command/maintenance_port
	name = "Command Rig - Level-1: Port Maintenance"

/area/navalis/indoors/command/maintenance_starboard
	name = "Command Rig - Level-1: Starboard Maintenance"

// Lower-Deck

/area/navalis/indoors/command/lower_deck
	name = "Command Rig - Level-0"

/area/navalis/indoors/command/lower_deck/starboard
	name = "Command Rig - Level-0: Starboard Access"

/area/navalis/indoors/command/lower_deck/port
	name = "Command Rig - Level-0: Port Access"

/area/navalis/indoors/command/lower_deck/sub_pen
	name = "Command Rig - Level-0: Sub-Pen"

// Upper-Deck

/area/navalis/indoors/command/upper_deck
	name = "Command Rig - Level-2"

/area/navalis/indoors/command/upper_deck/server
	name = "Command Rig - Level-2: Primary Server Room"

/area/navalis/indoors/command/upper_deck/starboard
	name = "Command Rig - Level-2: Starboard Corridor"

/area/navalis/indoors/command/upper_deck/port
	name = "Command Rig - Level-2: Port Corridor"

/area/navalis/indoors/command/upper_deck/air_traffic_control
	name = "Command Rig - Level-2: Air Traffic Control"

/area/navalis/indoors/command/upper_deck/naval_traffic_control
	name = "Command Rig - Level-2: Naval Traffic Control"

/area/navalis/indoors/command/upper_deck/jani
	name = "Command Rig - Level-2: Janitorial Closet"


// Logistical Rig

/area/navalis/indoors/logistic
	name = "Logistic Rig - Level-1:Indoors"
	icon_state = "quartstorage"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING

/area/navalis/indoors/logistic/Port_hallway
	name = "Logistic Rig - Level-1:Port-Hallway"

/area/navalis/indoors/logistic/workshop
	name = "Logistic Rig - Level-1:Workshop"

/area/navalis/indoors/logistic/mech_bay
	name = "Logistic Rig - Level-1:Mech-Bay"

/area/navalis/indoors/logistic/primary_storage
	name = "Logistic Rig - Level-1:Primary Storage"

/area/navalis/indoors/logistic/elevator
	name = "Logistic Rig - Level-1:Elevator"

/area/navalis/indoors/logistic/maintenance_port
	name = "Logistic Rig - Level-1:Port Maintenance"

/area/navalis/indoors/logistic/maintenance_starboard
	name = "Logistic Rig - Level-1:Starboard Maintenance"

// Lower-Deck

/area/navalis/indoors/logistic/lower_deck
	name = "Logistic Rig - Level-0"

/area/navalis/indoors/logistic/lower_deck/fore
	name = "Logistic Rig - Level-0: Fore Section"

/area/navalis/indoors/logistic/lower_deck/port
	name = "Logistic Rig - Level-0: Port Corridor"

/area/navalis/indoors/logistic/lower_deck/maint
	name = "Logistic Rig - Level-0: Maintenance Control"

/area/navalis/indoors/logistic/lower_deck/fuel
	name = "Logistic Rig - Level-0: Fuel Pump Control"

/area/navalis/indoors/logistic/lower_deck/maint_store
	name = "Logistic Rig - Level-0: Maintenance Storage"

// Upper-Deck

/area/navalis/indoors/logistic/upper_deck
	name = "Logistic Rig - Level-2"

/area/navalis/indoors/logistic/upper_deck/entrance
	name = "Logistic Rig - Level-2: Entrance"

/area/navalis/indoors/logistic/upper_deck/walkway
	name = "Logistic Rig - Level-2: Walkway"

/area/navalis/indoors/logistic/upper_deck/maint
	name = "Logistic Rig - Level-2: Maintenance"

/area/navalis/indoors/logistic/upper_deck/office
	name = "Logistic Rig - Level-2: Office"

/area/navalis/indoors/logistic/upper_deck/workshop
	name = "Logistic Rig - Level-2: Workshop"

/area/navalis/indoors/logistic/upper_deck/conduit
	name = "Logistic Rig - Level-2: Electrical Conduit"


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

/area/navalis/indoors/residential/cafeteria
	name = "Residential Rig - Level 2: Cafeteria"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/navalis/indoors/residential/access
	name = "Residential Rig - Level 2: Starboard Access"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/navalis/indoors/residential/maint_stern
	name = "Residential Rig - Level 2: Stern Maintenance"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/navalis/indoors/residential/maint_starboard
	name = "Residential Rig - Level 2: Starboard Maintenance"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS


// Landing Zones
/area/navalis/outdoors/landing_zone_1
	name = "Navalis Platform 13 - Medical Emergency Response - Landing Zone One"
	icon_state = "medbay3"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_CELL_VIP
	linked_lz = DROPSHIP_LZ1

/area/navalis/outdoors/landing_zone_1/under
	name = "LZ1 - Lower-Level Walkway"

/area/navalis/outdoors/landing_zone_2
	name = "Navalis Platform 13 - Logistics Delivery Area - Landing Zone Two"
	icon_state = "bunker01_engineering"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_CELL_MED
	linked_lz = DROPSHIP_LZ2

/area/navalis/outdoors/landing_zone_2/under
	name = "LZ2 - Lower-Level Walkway"

/area/navalis/indoors/landing_zone_2
	name = "LZ2 - Lower-Level Access"
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

// Medical

/area/navalis/outdoors/exterior/med_ext
	name = "Med-Sci Rig - Level-1: Exterior Walkway"

/area/navalis/outdoors/exterior/med_ext/lower
	name = "Med-Sci Rig - Level-0: Exterior Walkway"

/area/navalis/outdoors/exterior/med_ext/upper
	name = "Med-Sci Rig - Level-2: Exterior Walkway"

/area/navalis/outdoors/exterior/med_ext/roof
	name = "Medi-Sci Rig - Roof"
	minimap_color = MINIMAP_AREA_MEDBAY

// Command

/area/navalis/outdoors/exterior/com_ext
	name = "Command Rig - Level-1: Exterior Walkway"

/area/navalis/outdoors/exterior/com_ext/lower
	name = "Command Rig - Level-0: Exterior Walkway"

/area/navalis/outdoors/exterior/com_ext/upper
	name = "Command Rig - Level-2: Exterior Walkway"

/area/navalis/outdoors/exterior/com_ext/roof
	name = "Command Rig - Roof"
	minimap_color = MINIMAP_AREA_COMMAND

// Logistics

/area/navalis/outdoors/exterior/log_ext
	name = "Logistical Rig - Level-1: Exterior Walkway"

/area/navalis/outdoors/exterior/log_ext/lower
	name = "Logistical Rig - Level-0: Exterior Walkway"

/area/navalis/outdoors/exterior/log_ext/upper
	name = "Logistical Rig - Level-2: Exterior Walkway"

/area/navalis/outdoors/exterior/log_ext/roof
	name = "Logistical Rig - Roof"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING


// Industrial

/area/navalis/outdoors/exterior/ind_ext
	name = "Industrial Rig - Level-1: Exterior Walkway"

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

/area/navalis/indoors/ice_cavern
	name = "Iceberg Interior"
	icon_state = "medbay3"
	unoviable_timer = FALSE
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	requires_power = FALSE
