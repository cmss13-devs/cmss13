/datum/faction
	var/name = "Neutral Faction"
	var/faction_tag = FACTION_NEUTRAL
	var/hud_type = FACTION_HUD
	var/icon/base_icon_file

// Modify the HUD holder image for the given mob to add role overlays
/datum/faction/proc/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	return

// Construct a role HUD icon without basing it on dynamic state
/datum/faction/proc/get_role_icon(role)
	RETURN_TYPE(/icon)
	return

/datum/faction/proc/get_antag_guns_snowflake_equipment()
	return list()

/datum/faction/proc/get_antag_guns_sorted_equipment()
	return list()

