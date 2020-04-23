/datum/caste_datum/defender
	caste_name = "Defender"
	upgrade_name = "Young"
	caste_desc = "A sturdy front line combatant."
	tier = 1
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOWPLUS
	melee_damage_upper = XENO_DAMAGE_MEDIUMLOW
	max_health = XENO_HEALTH_MEDIUM
	plasma_gain = XENO_PLASMA_GAIN_VERYHIGH
	plasma_max = XENO_PLASMA_LOW
	xeno_explosion_resistance = XENO_LOWULTRA_EXPLOSIVE_ARMOR
	armor_deflection = XENO_HEAVY_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_CRUSHER
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_HIGH
	speed_mod = XENO_SPEED_MOD_LARGE
	
	evolves_to = list("Warrior")
	deevolves_to = "Larva"
	can_vent_crawl = 0

/datum/caste_datum/defender/mature
	upgrade_name = "Mature"
	caste_desc = "An alien with an armored head crest. It looks a little more dangerous."
	upgrade = 1

/datum/caste_datum/defender/elder
	upgrade_name = "Elder"
	caste_desc = "An alien with an armored head crest. It looks pretty strong."
	upgrade = 2

/datum/caste_datum/defender/ancient
	upgrade_name = "Ancient"
	caste_desc = "An unstoppable force that remains when others would fall."
	upgrade = 3

/mob/living/carbon/Xenomorph/Defender
	caste_name = "Defender"
	name = "Defender"
	desc = "A alien with an armored head crest."
	icon = 'icons/mob/xenos/xenomorph_64x64.dmi'
	icon_size = 64
	icon_state = "Defender Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	tier = 1
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/toggle_crest_defense,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/onclick/tail_sweep
	)
	mutation_type = DEFENDER_NORMAL

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
