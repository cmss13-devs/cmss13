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

/area/forward_base/command/corporateliaison
	name = "\improper Forward Base Corporate Liaison Office"
	icon_state = "corporatespace"

/area/forward_base/command/securestorage
	name = "\improper Forward Base Intelligence Office"
	icon_state = "corporatespace"

/area/forward_base/repair_bay
	name = "\improper Forward Base Deployment Workshop"
	icon_state = "dropshiprepair"

/area/forward_base/cryo
	name = "\improper Forward Base Cryogenics Bay"
	icon_state = "cryo"

/area/forward_base/medical
	minimap_color = MINIMAP_AREA_MEDBAY

/area/forward_base/medical/chemistry
	name = "\improper Forward Base Chemical Laboratory"
	icon_state = "chemistry"

/area/forward_base/medical/medbay
	name = "\improper Forward Base Medbay"
	icon_state = "medical"

/area/forward_base/medical/operating_room_one
	name = "\improper Forward Base Operating Room 1"
	icon_state = "operating"

/area/forward_base/medical/operating_room_two
	name = "\improper Forward Base Operating Room 2"
	icon_state = "operating"

/area/forward_base/brig
	name = "\improper Forward Base Brig"
	icon_state = "brig"
	minimap_color = MINIMAP_AREA_SEC

/area/forward_base/weapon_room
	name = "\improper Forward Base Weapon Control"
	icon_state = "weaponroom"
	minimap_color = MINIMAP_AREA_SEC

/area/forward_base/preparation
	name = "\improper Forward Base Squad Preparation"
	icon_state = "ab_shared"

/area/forward_base/requisitions
	name = "\improper Forward Base Requisitions"
	icon_state = "req"

/area/forward_base/supply
	parent_type = /area/supply/station/uscm
	name = "\improper Forward Base Supply Elevator"
