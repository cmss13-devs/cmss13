//White Antre Areas--------------------------------------//

/area/white_antre
	name = "White Antre Research Facility"
	icon = 'icons/turf/hybrisareas.dmi'
	icon_state = "wydropship"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

//parent types

/area/white_antre/indoors
	name = "White Antre Research Facility - Indoors"
	icon_state = "cliff_blocked"//because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	ambience_exterior = AMBIENCE_ANTRE
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/white_antre/outdoors
	name = "White Antre Research Facility - Outdoors"
	icon_state = "cliff_blocked"//because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV759_OUTDOORS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_interval = 25
	unoviable_timer = 20 MINUTES
	always_unpowered = TRUE

/area/white_antre/oob
	name = "Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE

// Landing Zone

/area/white_antre/landing_zone
	name = "White Antre Research Facility - Supply Pad - Landing Zone"
	icon_state = "lz"
	soundscape_playlist = SCAPE_PL_LV759_OUTDOORS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	ceiling = CEILING_NONE
	linked_lz = DROPSHIP_LZ1
	requires_power = FALSE

/area/white_antre/landing_zone/roof
	name = "White Antre Research Facility - Supply Pad - Landing Zone"
	icon_state = "lz"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

// PMC Ship

/area/white_antre/interior/pmc_dropship
	name = "PMC-DS-1 'Cash Flow'"
	icon_state = "WYSpaceport"
	ambience_exterior = AMBIENCE_SHIP_ALT

//Exterior Area

/area/white_antre/outdoors/north_field
	name = "Snow Fields - North"
	icon_state = "caves_north"

/area/white_antre/outdoors/south_field
	name = "Snow Fields - South"
	icon_state = "caves_south"

/area/white_antre/outdoors/road_west
	name = "Snow Fields - Road West"
	icon_state = "meridian_factory"

/area/white_antre/outdoors/road_east
	name = "Snow Fields - Road East"
	icon_state = "meridian"

/area/white_antre/outdoors/path_north
	name = "Snow Fields - Offroad North"
	icon_state = "mining"

/area/white_antre/outdoors/facility_exterior
	name = "White Antre - Western Facility Exterior"
	icon_state = "police_line"

/area/white_antre/indoors/exterior
	name = "White Antre Research Facility - Exterior"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/area/white_antre/indoors/exterior/checkpoint
	name = "White Antre Research Facility - Exterior Checkpoint"
	icon_state = "security_checkpoint_west"

/area/white_antre/indoors/exterior/ext_relay_north
	name = "White Antre Research Facility - Exterior Relay North"
	icon_state = "power0"

/area/white_antre/indoors/exterior/ext_relay_south
	name = "White Antre Research Facility - Exterior Relay South"
	icon_state = "power0"

//White Antre Facility - Ground

/area/white_antre/indoors/main_level
	name = "White Antre Research Facility - Ground Level"

/area/white_antre/indoors/main_level/west_corridor
	name = "White Antre Research Facility - West Corridor - Ground"
	icon_state = "colonystreets_west"

/area/white_antre/indoors/main_level/east_corridor
	name = "White Antre Research Facility - East Corridor - Ground"
	icon_state = "colonystreets_east"

/area/white_antre/indoors/main_level/engineering
	name = "White Antre Research Facility - Engineering - Ground"
	icon_state = "power0"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/main_level/security
	name = "White Antre Research Facility - Security - Ground"
	icon_state = "security_checkpoint"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/main_level/dorms
	name = "White Antre Research Facility - Dormitory - Ground"
	icon_state = "apartments"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/main_level/research
	name = "White Antre - Xenobiological Research - Ground"
	icon_state = "apartments"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/main_level/weapons
	name = "White Antre - Weapons Research - Ground"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/main_level/north_containment
	name = "White Antre - K-Series Containment Holding Bay - Ground"
	icon_state = "tumor1"

/area/white_antre/indoors/main_level/north_containment_hive
	name = "White Antre - K-Series Containment Zone - Ground"
	icon_state = "tumor2"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/white_antre/indoors/main_level/south_containment
	name = "White Antre - Unused Containment Holding Bay - Ground"
	icon_state = "tumor1"

/area/white_antre/indoors/main_level/south_containment_hive
	name = "White Antre - Unused Containment Zone - Ground"
	icon_state = "tumor2"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/white_antre/indoors/main_level/east_containment
	name = "White Antre - Prime Hive Containment Holding Bay - Ground"
	icon_state = "tumor1"

/area/white_antre/indoors/main_level/east_containment_hive
	name = "White Antre - Prime Hive Containment Zone - Ground"
	icon_state = "tumor2"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

//White Antre Facility - Underground

/area/white_antre/indoors/underground_level
	name = "White Antre Research Facility - Underground"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/underground_level/west_maint
	name = "White Antre Research Facility - West Maintenance - Underground"
	icon_state = "maints"

/area/white_antre/indoors/underground_level/east_maint
	name = "White Antre Research Facility - East Maintenance - Underground"
	icon_state = "maints"

//White Antre Facility - Above Ground

/area/white_antre/indoors/upper_level
	name = "White Antre - Upper Level"

/area/white_antre/indoors/upper_level/west_corridor
	name = "White Antre - West Corridor - Upper"
	icon_state = "colonystreets_west"

/area/white_antre/indoors/upper_level/east_corridor
	name = "White Antre - East Corridor - Upper"
	icon_state = "colonystreets_east"

/area/white_antre/indoors/upper_level/central_corridor
	name = "White Antre - Central Corridor - Upper"
	icon_state = "colonystreets_north"

/area/white_antre/indoors/upper_level/medical
	name = "White Antre - Medbay - Upper"
	icon_state = "medical_lz1"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/canteen
	name = "White Antre - Canteen - Upper"
	icon_state = "pizza"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/records
	name = "White Antre - Records - Upper"
	icon_state = "wyoffice"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/simian_storage
	name = "White Antre - Simian Storage - Upper"
	icon_state = "WYSpaceportcargo"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/central_command
	name = "White Antre - Central Command - Upper"
	icon_state = "wardens"

/area/white_antre/indoors/upper_level/director_office
	name = "White Antre - Director Kandinsky's Quarters - Upper"
	icon_state = "tumor0-deep"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/ancillery_storage
	name = "White Antre - Ancillery Storage - Upper"
	icon_state = "WYSpaceportcargo"

/area/white_antre/indoors/upper_level/payroll
	name = "White Antre - Payroll - Upper"
	icon_state = "disco"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/xenobio
	name = "White Antre - Xenobiological Research - Upper"
	icon_state = "medical"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/east_overwatch
	name = "White Antre - East Containment Overwatch - Upper"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/north_overwatch
	name = "White Antre - North Containment Overwatch - Upper"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

/area/white_antre/indoors/upper_level/south_overwatch
	name = "White Antre - South Containment Overwatch - Upper"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_ANTRE_ADJACENT

