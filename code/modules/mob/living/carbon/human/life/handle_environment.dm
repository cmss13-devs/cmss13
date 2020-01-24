//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_environment()

	if(!loc)
		return

	var/loc_temp = loc.return_temperature()

	if(!istype(get_turf(src), /turf/open/space)) //Space is not meant to change your body temperature.

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection
		var/temp_adj = 0
		if(loc_temp < bodytemperature) //Place is colder than we are
			var/thermal_protection = get_flags_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1 - thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR) //This will be negative

		else if (loc_temp > bodytemperature) //Place is hotter than we are
			var/thermal_protection = get_flags_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1 - thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		bodytemperature += Clamp(temp_adj, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)

	//+/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature > species.heat_level_1)
		//Body temperature is too hot.
		fire_alert = max(fire_alert, 2)
		if(status_flags & GODMODE)
			return 1 //Godmode

		if(bodytemperature > species.heat_level_3)
			take_overall_damage(burn = HEAT_DAMAGE_LEVEL_3, used_weapon = "High Body Temperature")
		else if(bodytemperature > species.heat_level_2)
			take_overall_damage(burn = HEAT_DAMAGE_LEVEL_2, used_weapon = "High Body Temperature")
		else if(bodytemperature > species.heat_level_1)
			take_overall_damage(burn = HEAT_DAMAGE_LEVEL_1, used_weapon = "High Body Temperature")

	else if(bodytemperature < species.cold_level_1)
		fire_alert = max(fire_alert, 1)

		if(status_flags & GODMODE)
			return 1 //Godmode

		if(!istype(loc, /obj/structure/machinery/cryo_cell))

			if(bodytemperature < species.cold_level_3)
				take_overall_damage(burn = COLD_DAMAGE_LEVEL_3, used_weapon = "Low Body Temperature")
			else if(bodytemperature < species.cold_level_2)
				take_overall_damage(burn = COLD_DAMAGE_LEVEL_2, used_weapon = "Low Body Temperature")
			else if(bodytemperature < species.cold_level_1)
				take_overall_damage(burn = COLD_DAMAGE_LEVEL_1, used_weapon = "Low Body Temperature")

	return 1
