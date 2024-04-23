/area/dockred
	can_build_special = TRUE
	ambience_exterior = AMBIENCE_BIGRED
	soundscape_playlist = SCAPE_PL_THUNDER
	soundscape_interval = 50

/area/dockred/oob
	name = "Dock Red Out of Bounds"
	ceiling = CEILING_MAX
	icon = 'icons/turf/area_kutjevo.dmi'
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	can_build_special = FALSE
	soundscape_interval = 0

/area/dockred/outside
	name = "\improper Dock Red"
	icon_state = "red"
	ceiling = CEILING_NONE
	soundscape_interval = 30
	soundscape_playlist = SCAPE_PL_THUNDER

/area/dockred/outside/telecomm
	name = "\improper Port Communications Relay"
	icon_state = "ass_line"
	ceiling = CEILING_METAL

/area/dockred/outside/telecomm/depot
	name = "\improper Depot Communications Relay"
	ceiling = CEILING_NONE

/area/dockred/outside/telecomm/junkyard
	name = "\improper Junkyard Communications Relay"
	ceiling = CEILING_NONE

/area/dockred/outside/port_outside
	name = "\improper Dock Red - Space Port(Open)"
	soundscape_playlist = SCAPE_PL_DESERT_STORM

/area/dockred/outside/port_outside/landing_zone
	is_landing_zone = TRUE
	is_resin_allowed = FALSE

/area/dockred/outside/bar
	name = "\improper Dock Red - Bar"
	icon_state = "bar"
	ceiling = CEILING_METAL

/area/dockred/outside/dorms
	name = "\improper Dock Red - Dorms"
	icon_state = "bar"
	ceiling = CEILING_METAL

/area/dockred/outside/port_inside
	name = "\improper Dock Red - Space Port(Ceiling)"
	icon_state = "storage"
	ceiling = CEILING_METAL
	minimap_color = MINIMAP_AREA_COMMAND
	is_landing_zone = TRUE
	is_resin_allowed = FALSE

/area/dockred/outside/port_inside/console
	requires_power = FALSE

/area/dockred/outside/cargo
	name = "\improper Dock Red - Cargo Depot"
	icon_state = "storage"
	ceiling = CEILING_METAL
	minimap_color = MINIMAP_AREA_COMMAND

/area/dockred/outside/checkpoint_west
	name = "\improper Dock Red - West Checkpoint"
	icon_state = "bridge"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_ALMAYER
	sound_environment = SOUND_ENVIRONMENT_ROOM
	minimap_color = MINIMAP_AREA_SEC

/area/dockred/outside/checkpoint_south
	name = "\improper Dock Red - South Checkpoint"
	icon_state = "bridge"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_ALMAYER
	sound_environment = SOUND_ENVIRONMENT_ROOM
	minimap_color = MINIMAP_AREA_SEC

/area/dockred/caves/north
	name = "\improper Dock Red - Caves(North)"
	icon_state = "caves_lambda"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	base_muffle = MUFFLE_HIGH
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE

/area/dockred/caves/south
	name = "\improper Dock Red - Caves(South)"
	icon_state = "caves_research"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	base_muffle = MUFFLE_HIGH
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE

/area/dockred/caves
	name = "\improper Dock Red - Caves"
	icon_state = "bluenew"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	base_muffle = MUFFLE_HIGH
	minimap_color = MINIMAP_AREA_CAVES

/area/dockred/caves/eta
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_ALMAYER
	sound_environment = SOUND_ENVIRONMENT_ROOM
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE
	soundscape_playlist = list()

/area/dockred/caves/eta/living
	name = "\improper Dock Red - ETA(Living Quarters)"
	icon_state = "eta_living"

/area/dockred/caves/eta/xenobiology
	name = "\improper Dock Red - ETA(Xenobiology)"
	icon_state = "eta_xeno"

/area/dockred/caves/eta/storage
	name = "\improper Dock Red - ETA(Storage)"
	icon_state = "eta_storage"

/area/dockred/caves/eta/research
	name = "\improper Dock Red - ETA(Research)"
	icon_state = "eta_research"

/area/dockred/caves/lambda
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	ceiling_muffle = FALSE
	ambience_exterior = AMBIENCE_ALMAYER
	sound_environment = SOUND_ENVIRONMENT_ROOM
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE
	soundscape_playlist = list()

/area/dockred/caves/lambda/virology
	name = "\improper Dock Red - LAMBDA(Virology)"
	icon_state = "lam_virology"

/area/dockred/caves/lambda/research
	name = "\improper Dock Red - LAMBDA(Research)"
	icon_state = "lam_research"

/area/dockred/caves/lambda/breakroom
	name = "\improper Dock Red - LAMBDA(Breakroom)"
	icon_state = "lam_break"

/area/dockred/caves/lambda/xenobiology
	name = "\improper Dock Red - LAMBDA(Xenobiology)"
	icon_state = "lam_xeno"

