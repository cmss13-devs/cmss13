/datum/behavior_delegate/pathogen_base
	name = "Base Pathogen Behavior Delegate"

/datum/caste_datum/pathogen/get_minimap_icon()
	var/image/background = mutable_appearance('icons/mob/neo/neo_blips.dmi', minimap_background)

	var/iconstate = minimap_icon ? minimap_icon : "unknown"
	var/mutable_appearance/icon = image('icons/mob/neo/neo_blips.dmi', icon_state = iconstate)
	icon.appearance_flags = RESET_COLOR
	background.overlays += icon

	return background
