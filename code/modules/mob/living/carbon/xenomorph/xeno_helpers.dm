/mob/living/carbon/xenomorph/can_ventcrawl()
	return (mob_size < MOB_SIZE_BIG && caste.can_vent_crawl)

/mob/living/carbon/xenomorph/ventcrawl_carry()
	if(stomach_contents.len)
		for(var/mob/living/carbon/human/H in stomach_contents)
			if(!isspeciesmonkey(H))
				to_chat(src, SPAN_XENOWARNING("You cannot ventcrawl with [H] inside you!"))
				return FALSE
	return TRUE

/mob/living/carbon/xenomorph/can_inject()
	return FALSE

/mob/living/carbon/xenomorph/proc/can_destroy_special()
	if(hive)
		if(IS_XENO_LEADER(src))
			if(hive.destruction_allowed == NORMAL_XENO || hive.destruction_allowed == XENO_LEADER)
				return TRUE
		if(hive.destruction_allowed == NORMAL_XENO && isxeno_builder(src))
			return TRUE
		if(isqueen(src))
			return TRUE

	return FALSE

/mob/living/carbon/xenomorph/proc/get_plasma_percentage()
	if(plasma_max<=0)
		return 100
	return floor(plasma_stored * 100 / plasma_max)

/mob/living/carbon/xenomorph/proc/get_armor_integrity_percentage()
	if(armor_deflection<=0)
		return 100
	return floor(armor_integrity * 100 / armor_integrity_max)

/**
 * Returns the name of the xeno's strain, if it has one.
 *
 * If that can't be found, returns "Normal".
 */
/mob/living/carbon/xenomorph/proc/get_strain_name()
	return strain?.name || "Normal"

/**
 * Returns the custom icon state from the xeno's strain, if it has one.
 *
 * If that can't be found, returns "Normal"
 */
/mob/living/carbon/xenomorph/proc/get_strain_icon()
	return strain?.icon_state_prefix || "Normal"
	// TODO: Go through xeno/xenoid sprites and remove "Normal", so that this isn't needed.

//These don't do much currently. Or anything? Only around for legacy code.
/mob/living/carbon/xenomorph/is_mob_restrained()
	return 0

// Count how many xenos are in the same area as you. Used in hijacking.
/mob/living/carbon/xenomorph/proc/count_hivemember_same_area()
	var/area/MA = get_area(src)
	var/count = 0

	// Compare the areas.
	for(var/mob/living/carbon/xenomorph/X in hive.totalXenos)
		if(!(X in GLOB.living_xeno_list))
			continue

		var/area/XA = get_area(X)
		if(XA == MA)
			count++

	return count

/mob/living/carbon/xenomorph/check_fire_intensity_resistance()
	return caste.fire_intensity_resistance

/mob/living/carbon/xenomorph/alter_ghost(mob/dead/observer/ghost)
	ghost.icon_state = "[get_strain_icon()] [caste.caste_type] Running"
