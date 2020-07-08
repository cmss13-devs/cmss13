/datum/caste_datum/defender
	caste_name = "Defender"
	caste_desc = "A sturdy front line combatant."
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_3
	plasma_gain = XENO_PLASMA_GAIN_ULTRAHIGH
	plasma_max = XENO_PLASMA_TIER_1
	xeno_explosion_resistance = XENO_LOWULTRA_EXPLOSIVE_ARMOR
	armor_deflection = XENO_ARMOR_TIER_4
	armor_hardiness_mult = XENO_ARMOR_FACTOR_CRUSHER
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_6
	
	evolves_to = list("Warrior")
	deevolves_to = "Larva"
	can_vent_crawl = 0

/mob/living/carbon/Xenomorph/Defender
	caste_name = "Defender"
	name = "Defender"
	desc = "A alien with an armored head crest."
	icon = 'icons/mob/xenos/defender.dmi'
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
		icon_state = "[mutation_type] Defender Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[mutation_type] Defender Sleeping"
		else
			icon_state = "[mutation_type] Defender Knocked Down"
	else if (fortify)
		icon_state = "[mutation_type] Defender Fortify"
	else if (crest_defense)
		icon_state = "[mutation_type] Defender Crest"
	else
		icon_state = "[mutation_type] Defender Running"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
