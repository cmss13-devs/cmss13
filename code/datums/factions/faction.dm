/datum/faction
	var/name = "Neutral Faction"
	var/faction_tag = FACTION_NEUTRAL
	var/hud_type = FACTION_HUD
	var/hud_icon_prefix
	var/hud_icon_file = 'icons/mob/hud/marine_hud.dmi'

/datum/faction/proc/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	return

/datum/faction/proc/get_antag_guns_snowflake_equipment()
	return list()

/datum/faction/proc/get_antag_guns_sorted_equipment()
	return list()
