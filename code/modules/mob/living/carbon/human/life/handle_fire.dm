//Refer to life.dm for caller

/mob/living/carbon/human/handle_fire()
	if(..())
		return
	if(isyautja(src))
		adjust_fire_stacks(-2, min_stacks = 0) // add some more fire reduction for predators
		if (fire_stacks == 0)
			ExtinguishMob()
			return
	var/thermal_protection = get_flags_heat_protection(30000) //If you don't have fire suit level protection, you get a temperature increase and burns
	if((1 - thermal_protection) > 0.0001)
		bodytemperature += BODYTEMP_HEATING_MAX
		recalculate_move_delay = TRUE
//RUCM START
		if(fire_reagent.friendlydetection && getFireLoss() > 400)
			return
//RUCM END
		var/dmg = armor_damage_reduction(GLOB.marine_fire, fire_reagent.intensityfire / HUMAN_BURN_DIVIDER)
		apply_damage(dmg, BURN)
