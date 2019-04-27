/datum/caste_datum/defender
	caste_name = "Defender"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	max_health = XENO_UNIVERSAL_HPMULT * 220
	plasma_gain = 0.08
	plasma_max = 100
	caste_desc = "A sturdy front line combatant."
	speed = -0.2
	charge_type = 2 //Pounce - Hunter
	evolves_to = list("Warrior")
	can_vent_crawl = 0

/datum/caste_datum/defender/mature
	upgrade_name = "Mature"
	caste_desc = "An alien with an armored head crest. It looks a little more dangerous."
	upgrade = 1
	max_health = XENO_UNIVERSAL_HPMULT * 230
	melee_damage_lower = 25
	melee_damage_upper = 35
	speed = -0.3
	armor_deflection = 25

/datum/caste_datum/defender/elder
	upgrade_name = "Elder"
	caste_desc = "An alien with an armored head crest. It looks pretty strong."
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 35
	max_health = XENO_UNIVERSAL_HPMULT * 245
	speed = -0.4
	armor_deflection = 30

/datum/caste_datum/defender/ancient
	upgrade_name = "Ancient"
	caste_desc = "An unstoppable force that remains when others would fall."
	upgrade = 3
	melee_damage_lower = 30
	melee_damage_upper = 40
	max_health = XENO_UNIVERSAL_HPMULT * 250
	speed = -0.5
	armor_deflection = 35

/mob/living/carbon/Xenomorph/Defender
	caste_name = "Defender"
	name = "Defender"
	desc = "A alien with an armored head crest."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Defender Walking"
	pixel_x = -16
	old_x = -16
	tier = 1
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/toggle_crest_defense,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/activable/tail_sweep
	)


/mob/living/carbon/Xenomorph/Defender/update_icons()
	if (stat == DEAD)
		icon_state = "Defender Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Defender Sleeping"
		else
			icon_state = "Defender Knocked Down"
	else if (fortify)
		icon_state = "Defender Fortify"
	else if (crest_defense)
		icon_state = "Defender Crest"
	else
		if (m_intent == MOVE_INTENT_RUN)
			icon_state = "Defender Running"
		else
			icon_state = "Defender Walking"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
