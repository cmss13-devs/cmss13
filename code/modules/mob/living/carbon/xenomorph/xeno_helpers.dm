


/mob/living/carbon/Xenomorph/can_ventcrawl()
	if(stomach_contents.len)
		for(var/atom/movable/AM in stomach_contents)
			if(ishuman(AM))
				return 0
	return (mob_size != MOB_SIZE_BIG && caste.can_vent_crawl)

/mob/living/carbon/Xenomorph/ventcrawl_carry()
	return 1


/mob/living/carbon/Xenomorph/can_inject()
	return FALSE

/mob/living/carbon/Xenomorph/proc/get_plasma_percentage()
	if(caste && caste.plasma_max) 
		return plasma_stored * 100 / caste.plasma_max
	return 0


//These don't do much currently. Or anything? Only around for legacy code.
/mob/living/carbon/Xenomorph/is_mob_restrained()
	return 0
