/datum/faction
	var/name = "Neutral Faction"
	var/faction_tag = FACTION_NEUTRAL
	var/hud_type = FACTION_HUD
	var/icon/base_icon_file

/// Modifies the passed holder using information about the passed human
/datum/faction/proc/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	SHOULD_NOT_OVERRIDE(TRUE) // You need to implement it the new way; update this logic if you need more data

	var/datum/squad/squad = human.assigned_squad
	var/role = human.job
	var/paygrade = null
	var/assignment = null
	var/rank_fallback = human.rank_fallback
	var/rank_override = human.rank_override
	var/obj/item/card/id/id_card = human.get_idcard()
	if(id_card)
		if(!role)
			role = id_card.rank
		paygrade = id_card.paygrade
		assignment = id_card.assignment

	modify_hud_holder_from_data(holder, human, role, paygrade, assignment, rank_fallback, rank_override, squad)

/// Modifies the passed holder using information about the target as applicable
/datum/faction/proc/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, assignment, rank_fallback, rank_override, datum/squad/squad)
	return // Not implemented

/datum/faction/proc/get_antag_guns_snowflake_equipment()
	return list()

/datum/faction/proc/get_antag_guns_sorted_equipment()
	return list()
