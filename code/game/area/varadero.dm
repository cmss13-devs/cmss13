
//areas for New  Varadero (waterworld), aka Ice Underground revamped.

/area/varadero
	name = "New Varadero"
	icon = 'icons/turf/area_varadero.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "varadero"
	can_build_special = TRUE //T-Comms structure
	temperature = TROPICAL_TEMP
	lighting_use_dynamic = TRUE

/area/shiva/Initialize()
	. = ..()
	if(SSticker.current_state > GAME_STATE_SETTING_UP)
		add_thunder()
	else
		LAZYADD(GLOB.thunder_setup_areas, src)

//shuttle stuff

/area/shuttle/drop1/varadero
	name = "New Varadero - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	lighting_use_dynamic = TRUE
	is_resin_allowed = FALSE

/area/shuttle/drop2/varadero
	name = "New Varadero - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	lighting_use_dynamic = TRUE
	is_resin_allowed = FALSE

//Parent areas

/area/varadero/exterior
	name = "New Varadero - Exterior"
	ceiling = CEILING_NONE

/area/varadero/interior
	name = "New Varadero - Interior"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/varadero/interior_protected
	name = "New Varadero - Interior"
	ceiling = CEILING_DEEP_UNDERGROUND

/area/varadero/interior/oob
	name = "New Varadero - Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

//landing zone computers

/area/varadero/exterior/lz1_console
	name = "New Varadero - Pontoon Dock"
	requires_power = FALSE

/area/varadero/exterior/lz1_console/two
	name = "Varadero - Palm Airfield"

//exterior areas

/area/varadero/exterior/lz1_near
	name = "New Varadero - Pontoon Dock"
	icon_state = "lz1"
	is_resin_allowed = FALSE

/area/varadero/exterior/lz2_near
	name = "New Varadero - Palm Airfield"
	icon_state = "lz2"
	is_resin_allowed = FALSE

/area/varadero/exterior/pontoon_beach
	name = "New Varadero - Rockabilly Beach"
	icon_state = "varadero0"

//interior areas

/area/varadero/interior/cargo
	name = "New Varadero - Cargo"
	icon_state = "req0"

/area/varadero/interior/hall_NW
	name = "New Varadero - Hallway NW"
	icon_state = "hall0"

/area/varadero/interior/hall_SE
	name = "New Varadero - Hallway SE"
	icon_state = "hall1"

/area/varadero/interior/chapel
	name = "New Vardero - Chapel"
	icon_state = "offices1"

/area/varadero/interior/morgue
	name = "New Varadero - Morgue"
	icon_state = "offices0"

/area/varadero/interior/medical
	name = "New Varadero - Medical"
	icon_state = "offices2"

/area/varadero/interior/maintenance
	name = "New Varadero - Central Maintenance"
	icon_state = "tunnels0"

/area/varadero/interior/maintenance/north
	name = "New Varadero - Northern Maintenance"
	icon_state = "tunnels1"

/area/varadero/interior/maintenance/research
	name = "New Varadero - Research Maintenance"
	icon_state = "tunnels1"

/area/varadero/interior/maintenance/security
	name = "New Varadero - Security Maintenance"
	icon_state = "tunnels2"

/area/varadero/interior/maintenance/south
	name = "New Varadero - Southern Maintenance"
	icon_state = "tunnels3"

/area/varadero/interior/research
	name = "New Varadero - Research Offices"
	icon_state = "offices4"

/area/varadero/interior/electrical
	name = "New Varadero - Electrical Annex"
	icon_state = "req4"
