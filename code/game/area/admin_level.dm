// Bunker01
// Areas

/area/adminlevel
	ceiling = CEILING_METAL
	base_lighting_alpha = 255

/area/adminlevel/bunker01
	icon_state = "thunder"
	requires_power = FALSE
	statistic_exempt = TRUE
	flags_area = AREA_NOTUNNEL

/area/adminlevel/bunker01/mainroom
	name = "\improper Bunker Main Room"
	icon_state = "bunker01_main"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/medbay
	name = "\improper Bunker Medbay"
	icon_state = "bunker01_medbay"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/security
	name = "\improper Bunker Security"
	icon_state = "bunker01_security"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/engineering
	name = "\improper Bunker Engineering"
	icon_state = "bunker01_engineering"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/storage
	name = "\improper Bunker Storage"
	icon_state = "bunker01_storage"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/bedroom
	name = "\improper Bunker Bedroom"
	icon_state = "bunker01_bedroom"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/command
	name = "\improper Bunker Command Room"
	icon_state = "bunker01_command"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/bathroom
	name = "\improper Bunker Bathroom"
	icon_state = "bunker01_bathroom"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/kitchen
	name = "\improper Bunker Kitchen"
	icon_state = "bunker01_kitchen"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/hydroponics
	name = "\improper Bunker Hydroponics"
	icon_state = "bunker01_hydroponics"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/breakroom
	name = "\improper Bunker Breakroom"
	icon_state = "bunker01_break"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/gear
	name = "\improper Bunker Gear"
	icon_state = "bunker01_gear"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/caves
	name = "\improper Bunker Caves"
	icon_state = "bunker01_caves"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	always_unpowered = TRUE
	requires_power = TRUE
	base_lighting_alpha = 0

/area/adminlevel/bunker01/caves/outpost
	name = "\improper Bunker Outpost"
	icon_state = "bunker01_caves_outpost"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	requires_power = TRUE
	always_unpowered = FALSE

/area/adminlevel/bunker01/caves/xeno
	name = "\improper Bunker Xeno Hive"
	icon_state = "bunker01_caves_outpost"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	flags_area = AREA_NOTUNNEL|AREA_ALLOW_XENO_JOIN

	var/hivenumber = XENO_HIVE_ALPHA

/area/adminlevel/bunker01/caves/xeno/Entered(A, atom/OldLoc)
	. = ..()
	if(isxeno(A))
		var/mob/living/carbon/xenomorph/X = A

		X.away_timer = XENO_LEAVE_TIMER
		X.set_hive_and_update(hivenumber)

// ERT Station
/area/adminlevel/ert_station
	name = "ERT Station"
	icon_state = "green"
	requires_power = FALSE
	flags_area = AREA_NOTUNNEL

/area/adminlevel/ert_station/upp_station
	name = "UPP Station"
	icon_state = "green"

/area/adminlevel/ert_station/pizza_station
	name = "Pizza Galaxy"
	icon_state = "red"

/area/adminlevel/ert_station/clf_station
	name = "CLF Station"
	icon_state = "white"

/area/adminlevel/ert_station/weyland_station
	name = "Weyland-Yutani Station"
	icon_state = "red"

/area/adminlevel/ert_station/uscm_station
	name = "USCM Station"
	icon_state = "green"

/area/adminlevel/ert_station/freelancer_station
	name = "Freelancer Station"
	icon_state = "yellow"

/area/adminlevel/ert_station/royal_marines_station
	name = "HMS Patna Hangerbay"
	icon_state = "yellow"

/area/adminlevel/ert_station/shuttle_dispatch
	name = "Shuttle Dispatch Station"
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	icon_state = "yellow"

//Fax Responder areas
/area/adminlevel/ert_station/fax_response_station
	name = "Sector Comms Relay"
	icon_state = "green"
	unlimited_power = TRUE
	flags_area = AREA_AVOID_BIOSCAN

/area/adminlevel/ert_station/fax_response_station/exterior
	name = "Sector Comms Relay"
	icon_state = "red"
	ambience_exterior = AMBIENCE_JUNGLE
	//ambience = list('sound/ambience/jungle_amb1.ogg')
	base_lighting_alpha = 185

//Simulation area
/area/adminlevel/simulation
	name = "Simulated Reality"
	icon_state = "green"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

/area/misc
	weather_enabled = FALSE

/area/misc/testroom
	requires_power = FALSE
	name = "Test Room"

/area/misc/tutorial
	name = "Tutorial Zone"
	icon_state = "tutorial"
	requires_power = FALSE
	flags_area = AREA_NOTUNNEL|AREA_AVOID_BIOSCAN
	statistic_exempt = TRUE
	ceiling = CEILING_METAL
	block_game_interaction = TRUE
	unique = TRUE

	base_lighting_alpha = 255

/area/misc/tutorial/Initialize(mapload, ...)
	. = ..()
	update_base_lighting()

/area/misc/tutorial/no_baselight
	base_lighting_alpha = 0
