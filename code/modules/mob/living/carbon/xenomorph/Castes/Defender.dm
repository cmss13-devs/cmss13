/datum/caste_datum/defender
	caste_name = "Defender"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = 15
	melee_damage_upper = 25
	max_health = 250
	plasma_gain = 8
	plasma_max = 100
	evolution_threshold = 200
	upgrade_threshold = 200
	caste_desc = "A sturdy front line combatant."
	speed = -0.2
	charge_type = 2 //Pounce - Hunter
	armor_deflection = 40
	evolves_to = list("Warrior")

/datum/caste_datum/defender/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 20
	melee_damage_upper = 30
	max_health = 275
	upgrade_threshold = 400
	caste_desc = "An alien with an armored head crest. It looks a little more dangerous."
	speed = -0.3
	armor_deflection = 45

/datum/caste_datum/defender/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 35
	max_health = 300
	upgrade_threshold = 800
	caste_desc = "An alien with an armored head crest. It looks pretty strong."
	speed = -0.4
	armor_deflection = 50

/datum/caste_datum/defender/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	max_health = 325
	caste_desc = "An unstoppable force that remains when others would fall."
	speed = -0.4
	armor_deflection = 55

/mob/living/carbon/Xenomorph/Defender
	caste_name = "Defender"
	name = "Defender"
	desc = "A alien with an armored head crest."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Defender Walking"
	health = 250
	maxHealth = 250
	plasma_stored = 50
	pixel_x = -16
	old_x = -16
	tier = 1
	upgrade = 0
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/toggle_crest_defense,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/activable/tail_sweep
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
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
