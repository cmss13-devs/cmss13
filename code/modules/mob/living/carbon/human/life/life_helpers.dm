//Refer to life.dm for caller

/*
 * This is the Life() proc junkyard
 * If you can't find a proc, it's probably here
 * Mostly for procs that are not called in the direct Life() loop, except for exact functionality matches (handle_breath, breathe, get_breath_from_internal for example)
 */

//Calculate how vulnerable the human is to under- and overpressure.
//Returns 0 (equals 0 %) if sealed in an undamaged suit, 1 if unprotected (equals 100%).
//Suitdamage can modifiy this in 10% steps.
/mob/living/carbon/human/proc/get_pressure_weakness()

	var/pressure_adjustment_coefficient = 1 // Assume no protection at first.

	if(wear_suit && (wear_suit.flags_inventory & NOPRESSUREDMAGE) && head && (head.flags_inventory & NOPRESSUREDMAGE)) //Complete set of pressure-proof suit worn, assume fully sealed.
		pressure_adjustment_coefficient = 0

		//Handles breaches in your space suit. 10 suit damage equals a 100% loss of pressure protection.
		if(istype(wear_suit, /obj/item/clothing/suit/space))
			var/obj/item/clothing/suit/space/S = wear_suit
			if(S.can_breach && S.damage)
				pressure_adjustment_coefficient += S.damage * 0.1

	pressure_adjustment_coefficient = min(1, max(pressure_adjustment_coefficient, 0)) //So it isn't less than 0 or larger than 1.
	return pressure_adjustment_coefficient

//Calculate how much of the enviroment pressure-difference affects the human.
/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	var/pressure_difference

	//First get the absolute pressure difference.
	if(pressure < ONE_ATMOSPHERE) //We are in an underpressure.
		pressure_difference = ONE_ATMOSPHERE - pressure

	else //We are in an overpressure or standard atmosphere.
		pressure_difference = pressure - ONE_ATMOSPHERE

	if(pressure_difference < 5) //If the difference is small, don't bother calculating the fraction.
		pressure_difference = 0

	else
		//Otherwise calculate how much of that absolute pressure difference affects us, can be 0 to 1 (equals 0% to 100%).
		//This is our relative difference.
		pressure_difference *= get_pressure_weakness()

	//The difference is always positive to avoid extra calculations.
	//Apply the relative difference on a standard atmosphere to get the final result.
	//The return value will be the adjusted_pressure of the human that is the basis of pressure warnings and damage.
	if(pressure < ONE_ATMOSPHERE)
		return ONE_ATMOSPHERE - pressure_difference
	else
		return ONE_ATMOSPHERE + pressure_difference

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
	var/thermal_protection = 0.0
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
/mob/living/carbon/human/proc/get_flags_cold_protection_flags(temperature, var/deficit = 0)

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
	var/thermal_protection = 0.0

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


/mob/living/carbon/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	if(G && G.active)
		see_in_dark += G.darkness_view
		if(G.vision_flags)
			sight |= G.vision_flags
			if(!druggy)
				see_invisible = SEE_INVISIBLE_MINIMUM
		if(istype(G,/obj/item/clothing/glasses/night))
			see_invisible = SEE_INVISIBLE_MINIMUM



/mob/living/carbon/human/handle_silent()
	if(..())
		speech_problem_flag = 1
	return silent

/mob/living/carbon/human/handle_slurring()
	if(..())
		speech_problem_flag = 1
	return slurring

/mob/living/carbon/human/handle_stunned()
	if(stunned)
		AdjustStunned(-species.stun_reduction)
		speech_problem_flag = 1
	return stunned

/mob/living/carbon/human/handle_dazed()
	if(dazed)
		var/skill = 1
		if(skills)
			skill += (skills.get_skill_level(SKILL_ENDURANCE)-1)*0.2
		AdjustDazed(-skill)
	if(dazed)
		speech_problem_flag = 1
	return dazed

/mob/living/carbon/human/handle_knocked_down()
	if(knocked_down && client)
		var/skill = species.knock_down_reduction
		if(skills)
			skill += (skills.get_skill_level(SKILL_ENDURANCE)-1)*0.1
		knocked_down = max(knocked_down - skill, 0)
		knocked_down_callback_check()
	return knocked_down

/mob/living/carbon/human/handle_knocked_out()
	if(knocked_out && client)
		var/skill = species.knock_out_reduction
		if(skills)
			skill += (skills.get_skill_level(SKILL_ENDURANCE)-1)*0.1
		knocked_out = max(knocked_out - skill, 0)
		knocked_out_callback_check()
	return knocked_out

/mob/living/carbon/human/handle_stuttering()
	if(..())
		speech_problem_flag = 1
	return stuttering

#define HUMAN_TIMER_TO_EFFECT_CONVERSION (1/20) //once per 2 seconds, with effect equal to endurance, which is used later

// This is here because sometimes our stun comes too early and tick is about to start, so we need to compensate
// this is the best place to do it, tho name might be a bit misleading I guess
/mob/living/carbon/human/stun_clock_adjustment()
	var/skill = species.knock_down_reduction
	if(skills)
		skill += (skills.get_skill_level(SKILL_ENDURANCE)-1) * 0.1

	var/shift_left = (SShuman.next_fire - world.time) * HUMAN_TIMER_TO_EFFECT_CONVERSION * skill
	if(stunned > shift_left)
		stunned += SShuman.wait * HUMAN_TIMER_TO_EFFECT_CONVERSION * skill - shift_left

/mob/living/carbon/human/knockdown_clock_adjustment()
	if(!species)
		return FALSE

	var/skill = species.knock_down_reduction
	if(skills)
		skill += (skills.get_skill_level(SKILL_ENDURANCE)-1) * 0.1

	var/shift_left = (SShuman.next_fire - world.time) * HUMAN_TIMER_TO_EFFECT_CONVERSION * skill
	if(knocked_down > shift_left)
		knocked_down += SShuman.wait * HUMAN_TIMER_TO_EFFECT_CONVERSION * skill - shift_left

/mob/living/carbon/human/knockout_clock_adjustment()
	if(!species)
		return FALSE

	var/skill = species.knock_out_reduction
	if(skills)
		skill += (skills.get_skill_level(SKILL_ENDURANCE)-1) * 0.1

	var/shift_left = (SShuman.next_fire - world.time) * HUMAN_TIMER_TO_EFFECT_CONVERSION * skill
	if(knocked_out > shift_left)
		knocked_out += SShuman.wait * HUMAN_TIMER_TO_EFFECT_CONVERSION * skill - shift_left

/mob/living/carbon/human/proc/handle_revive()
	SEND_SIGNAL(src, COMSIG_HUMAN_REVIVED)
	track_revive(job)
	GLOB.alive_mob_list += src
	if(!isSynth(src) && !isYautja(src))
		GLOB.alive_human_list += src
	GLOB.dead_mob_list -= src
	timeofdeath = 0
	life_time_start = world.time
	life_time_total = 0
	life_steps_total = 0
	last_damage_mob = null
	last_damage_source = null
	statistic_tracked = FALSE
	tod = null
	stat = UNCONSCIOUS
	emote("gasp")
	regenerate_icons()
	reload_fullscreens()
	update_canmove()
	flash_eyes()
	apply_effect(10, EYE_BLUR)
	apply_effect(10, PARALYZE)
	update_canmove()
	updatehealth() //One more time, so it doesn't show the target as dead on HUDs
