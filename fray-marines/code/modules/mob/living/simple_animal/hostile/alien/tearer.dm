/mob/living/simple_animal/hostile/alien/spawnable/tearer
	icon_name = "Ravager"
	caste_name = "tearer"
	name = "tearer"
	icon = 'fray-marines/icons/mob/xenos/lesser_xeno_big.dmi'
	desc = "Weakened version of a Ravager."
	health = XENO_HEALTH_RUNNER
	melee_damage_lower = XENO_AI_DAMAGE_TIER_2
	melee_damage_upper = XENO_AI_DAMAGE_TIER_3
	move_to_delay = XENO_AI_SPEED_TIER_1
	pixel_x = -12
	old_x = -12

/mob/living/simple_animal/hostile/alien/spawnable/tearer/evaluate_special_attack(mob/living/L)
	var/probability = prob(special_attack_probability)

	if(probability)
		visible_message(SPAN_DANGER("[src] goes savage!"))
		for(var/mob/living/ajacent in range(1, L))
			if(ajacent == src)
				continue
			ajacent.attack_animal(src)

	return probability
