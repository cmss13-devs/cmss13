


/mob/living/carbon/Xenomorph/can_ventcrawl()
	if(stomach_contents.len)
		for(var/atom/movable/AM in stomach_contents)
			if(isHumanStrict(AM))
				return 0
	return (mob_size != MOB_SIZE_BIG && caste.can_vent_crawl)

/mob/living/carbon/Xenomorph/ventcrawl_carry()
	return 1


/mob/living/carbon/Xenomorph/can_inject()
	return FALSE

/mob/living/carbon/Xenomorph/proc/can_destroy_special()
	if(hive)
		if(IS_XENO_LEADER(src))
			if(hive.destruction_allowed == NORMAL_XENO || hive.destruction_allowed == XENO_LEADER)
				return TRUE
		if(hive.destruction_allowed == NORMAL_XENO && isXenoBuilder(src))
			return TRUE
		if(isXenoQueen(src))
			return TRUE
		
	return FALSE

/mob/living/carbon/Xenomorph/proc/get_plasma_percentage()
	if(plasma_max<=0)
		return 100
	return round(plasma_stored * 100 / plasma_max)

/mob/living/carbon/Xenomorph/proc/get_armor_integrity_percentage()
	if(armor_deflection<=0)
		return 100
	return round(armor_integrity * 100 / armor_integrity_max)

//These don't do much currently. Or anything? Only around for legacy code.
/mob/living/carbon/Xenomorph/is_mob_restrained()
	return 0

// Count how many xenos are in the same area as you. Used in hijacking.
/mob/living/carbon/Xenomorph/proc/count_hivemember_same_area()
	var/area/MA = get_area(src)
	var/count = 0

	// Compare the areas.
	for(var/mob/living/carbon/Xenomorph/X in hive.totalXenos)
		if(!(X in living_xeno_list))
			continue

		var/area/XA = get_area(X)
		if(XA == MA)
			count++

	return count