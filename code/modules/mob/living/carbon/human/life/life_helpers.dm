//Refer to life.dm for caller

/*
 * This is the Life() proc junkyard
 * If you can't find a proc, it's probably here
 * Mostly for procs that are not called in the direct Life() loop, except for exact functionality matches (handle_breath, breathe, get_breath_from_internal for example)
 */

/mob/living/carbon/human/proc/stabilize_body_temperature()


	var/body_temperature_difference = species.body_temperature - bodytemperature

	if(abs(body_temperature_difference) < 0.5)
		return //Fuck this precision

	if(bodytemperature < species.cold_level_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
			nutrition -= 2
		var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		bodytemperature += recovery_amt
		recalculate_move_delay = TRUE

	else if(species.cold_level_1 <= bodytemperature && bodytemperature <= species.heat_level_1)
		var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
		bodytemperature += recovery_amt
		recalculate_move_delay = TRUE

	else if(bodytemperature > species.heat_level_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		//We totally need a sweat system cause it totally makes sense...~
		var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM) //We're dealing with negative numbers
		bodytemperature += recovery_amt
		recalculate_move_delay = TRUE


//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_flags_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.

	var/thermal_protection_flags = 0

	//Handle normal clothing
	if(head)
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.flags_heat_protection
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_suit.flags_heat_protection
	if(w_uniform)
		if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= w_uniform.flags_heat_protection
	if(shoes)
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.flags_heat_protection
	if(gloves)
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.flags_heat_protection
	if(wear_mask)
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.flags_heat_protection

	return thermal_protection_flags


/mob/living/carbon/human/proc/get_flags_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_flags_heat_protection_flags(temperature)
	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & BODY_FLAG_HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & BODY_FLAG_CHEST)
			thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
		if(thermal_protection_flags & BODY_FLAG_GROIN)
			thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
		if(thermal_protection_flags & BODY_FLAG_LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & BODY_FLAG_LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & BODY_FLAG_FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & BODY_FLAG_FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & BODY_FLAG_ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & BODY_FLAG_ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & BODY_FLAG_HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & BODY_FLAG_HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1, thermal_protection)



//See proc/get_flags_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_flags_cold_protection_flags(temperature, deficit = 0)

	var/thermal_protection_flags = 0

	//Handle normal clothing
	if(head)
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.flags_cold_protection

	if(wear_suit)
		if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_suit.flags_cold_protection

	if(w_uniform)
		if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= w_uniform.flags_cold_protection

	if(shoes)
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.flags_cold_protection

	if(gloves)
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.flags_cold_protection

	if(wear_mask)
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.flags_cold_protection

	return thermal_protection_flags


/mob/living/carbon/human/proc/get_flags_cold_protection(temperature)
	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_flags_cold_protection_flags(temperature)
	var/thermal_protection = 0

	if(thermal_protection_flags)
		if(thermal_protection_flags & BODY_FLAG_HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & BODY_FLAG_CHEST)
			thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
		if(thermal_protection_flags & BODY_FLAG_GROIN)
			thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
		if(thermal_protection_flags & BODY_FLAG_LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & BODY_FLAG_LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & BODY_FLAG_FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & BODY_FLAG_FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & BODY_FLAG_ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & BODY_FLAG_ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & BODY_FLAG_HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & BODY_FLAG_HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	var/list/protection_data = list("protection" = thermal_protection)
	SEND_SIGNAL(src, COMSIG_HUMAN_COLD_PROTECTION_APPLY_MODIFIERS, protection_data)
	return min(1, protection_data["protection"])


/mob/living/carbon/human/proc/process_glasses(obj/item/clothing/glasses/G)
	if(!G || !G.active)
		return
	see_in_dark += G.darkness_view
	if(G.vision_flags)
		sight |= G.vision_flags
	if(G.lighting_alpha < lighting_alpha)
		lighting_alpha = G.lighting_alpha

#define HUMAN_TIMER_TO_EFFECT_CONVERSION (0.05) //(1/20) //once per 2 seconds, with effect equal to endurance, which is used later

/mob/living/carbon/human/GetStunDuration(amount)
	. = ..()
	var/skill_resistance = skills ? (skills.get_skill_level(SKILL_ENDURANCE)-1)*0.08 : 0
	var/final_reduction = (1 - skill_resistance) / species.stun_reduction
	return . * final_reduction

/mob/living/carbon/human/GetKnockDownDuration(amount)
	. = ..()
	var/skill_resistance = skills ? (skills.get_skill_level(SKILL_ENDURANCE)-1)*0.08 : 0
	var/final_reduction = (1 - skill_resistance) / species.knock_down_reduction
	return . * final_reduction

/mob/living/carbon/human/GetKnockOutDuration(amount)
	. = ..()
	var/skill_resistance = skills ? (skills.get_skill_level(SKILL_ENDURANCE)-1)*0.08 : 0
	var/final_reduction = (1 - skill_resistance) / species.knock_out_reduction
	return . * final_reduction

/mob/living/carbon/human/GetDazeDuration(amount)
	. = ..()
	var/skill_resistance = skills ? (skills.get_skill_level(SKILL_ENDURANCE)-1)*0.08 : 0
	var/final_reduction = (1 - skill_resistance)
	return . * final_reduction


/mob/living/carbon/human/proc/handle_revive()
	SEND_SIGNAL(src, COMSIG_HUMAN_REVIVED)
	track_revive(job)
	GLOB.alive_mob_list += src
	if(!issynth(src) && !isyautja(src))
		GLOB.alive_human_list += src
	GLOB.dead_mob_list -= src
	timeofdeath = 0
	life_time_start = world.time
	life_time_total = 0
	life_steps_total = 0
	last_damage_data = null
	statistic_tracked = FALSE
	tod = null
	set_stat(UNCONSCIOUS)
	emote("gasp")
	regenerate_icons()
	reload_fullscreens()
	flash_eyes()
	apply_effect(10, EYE_BLUR)
	apply_effect(10, PARALYZE)
	updatehealth() //One more time, so it doesn't show the target as dead on HUDs
