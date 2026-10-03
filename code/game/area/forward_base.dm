/area/forward_base
	name = "\improper Forward Base"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "almayer"
	ceiling = CEILING_METAL
	ceiling_muffle = FALSE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	weather_enabled = FALSE
	requires_power = FALSE //Temporary
	unlimited_power = TRUE //Temporary

/area/forward_base/command
	minimap_color = MINIMAP_AREA_COMMAND

/area/forward_base/command/cic
	name = "\improper Forward Base Combat Information Center"
	icon_state = "cic"
	flags_area = AREA_NOBURROW

/area/forward_base/command/combat_correspondent
	name = "\improper Forward Base Combat Correspondent Office"
	icon_state = "selfdestruct"

/area/forward_base/command/corporateliaison
	name = "\improper Forward Base Corporate Liaison Office"
	icon_state = "corporatespace"

/area/forward_base/command/securestorage
	name = "\improper Forward Base Intelligence Office"
	icon_state = "corporatespace"

/area/forward_base/engineering
	minimap_color = MINIMAP_AREA_ENGI

/area/forward_base/engineering/lower
	name = "\improper Forward Base Engineering"
	icon_state = "lowerengineering"

/area/forward_base/engineering/lower/workshop
	name = "\improper Forward Base Engineering Workshop"
	icon_state = "workshop"

/area/forward_base/hallways/lower/port_midship_hallway
	name = "\improper Forward Base Lower Port Hallway"
	icon_state = "port"

/area/forward_base/hallways/lower/starboard_midship_hallway
	name = "\improper Forward Base Lower Starboard Hallway"
	icon_state = "starboard"

/area/forward_base/hallways/upper/port
	name = "\improper Forward Base Upper Port Hallway"
	icon_state = "port"

/area/forward_base/hallways/upper/starboard
	name = "\improper Forward Base Upper Starboard Hallway"
	icon_state = "starboard"

/area/forward_base/living/briefing
	name = "\improper Forward Base Briefing Area"
	icon_state = "briefing"

/area/forward_base/living/grunt_rnr
	name = "\improper Forward Base Lounge"
	icon_state = "gruntrnr"

/area/forward_base/living/offices/cryo
	name = "\improper Forward Base Cryogenics Bay"
	icon_state = "cryo"

/area/forward_base/medical
	minimap_color = MINIMAP_AREA_MEDBAY

/area/forward_base/medical/chemistry
	name = "\improper Forward Base Chemical Laboratory"
	icon_state = "chemistry"

/area/forward_base/medical/lower_medical_lobby
	name = "\improper Forward Base Lower Medical Lobby"
	icon_state = "medical"

/area/forward_base/medical/medical_science
	name = "\improper Forward Base Research Laboratory"
	icon_state = "science"

/area/forward_base/medical/morgue
	name = "\improper Forward Base Morgue"
	icon_state = "operating"

/area/forward_base/medical/operating_room_one
	name = "\improper Forward Base Operating Room 1"
	icon_state = "operating"

/area/forward_base/medical/upper_medical
	name = "\improper Forward Base Upper Medbay"
	icon_state = "medical"

/area/forward_base/shipboard/brig/processing
	name = "\improper Forward Base Brig"
	icon_state = "brig"
	minimap_color = MINIMAP_AREA_SEC

/area/forward_base/shipboard/weapon_room
	name = "\improper Forward Base Weapon Control"
	icon_state = "weaponroom"
	minimap_color = MINIMAP_AREA_SEC

/area/forward_base/squads/alpha_bravo_shared
	name = "\improper Forward Base Squad Preparation"
	icon_state = "ab_shared"

/area/forward_base/squads/req
	name = "\improper Forward Base Requisitions"
	icon_state = "req"

/area/forward_base/underdeck/hangar
	name = "\improper Forward Base Hangar"
	icon_state = "hangar"
