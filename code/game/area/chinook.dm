//Chinook area

//Sparse but gets the job done.

/area/adminlevel/chinook
	name = "Chinook 91 GSO Station"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "almayer"
	requires_power = TRUE
	statistic_exempt = TRUE
	flags_area = AREA_NOTUNNEL
	lighting_use_dynamic = TRUE
	sound_environment = 2
	unlimited_power = TRUE
	ceiling = CEILING_METAL
	ambience_exterior = AMBIENCE_ALMAYER
	soundscape_interval = 30
	ceiling_muffle = FALSE

/area/adminlevel/chinook/offices
	name = "Chinook 91 GSO Station - Office Sector"
	icon_state = "officerstudy"

/area/adminlevel/chinook/event
	name = "Chinook 91 GSO Station - Convention Sector"
	icon_state = "officerrnr"

/area/adminlevel/chinook/sec
	name = "Chinook 91 GSO Station - Security Sector"
	icon_state = "brig"

/area/adminlevel/chinook/engineering
	name = "Chinook 91 GSO Station - Engineering Sector"
	icon_state = "engineering"

/area/adminlevel/chinook/medical
	name = "Chinook 91 GSO Station - Medical Sector"
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	icon_state = "medical"
	soundscape_interval = 60

/area/adminlevel/chinook/cryo
	name = "Chinook 91 GSO Station - Cryogenics Bay"
	icon_state = "cryo"

/area/adminlevel/chinook/shuttle
	name = "Chinook 91 GSO Station - Shuttle Bay"
	icon_state = "upperhull"

/area/adminlevel/chinook/shuttle/unpowered
	name = "Chinook 91 GSO Station - Shuttle Pad"
	icon_state = "lowerhull"
	requires_power = FALSE

/area/adminlevel/chinook/cargo
	name = "Chinook 91 GSO Station - Cargo Bay"
	icon_state = "req"
