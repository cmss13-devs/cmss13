/datum/caste_datum/custom
	caste_type = XENO_CASTE_CUSTOM

/mob/living/carbon/Xenomorph/Custom
	caste_type = XENO_CASTE_CUSTOM

/mob/living/carbon/Xenomorph/Custom/Initialize(mapload, datum/caste_datum/pre_made_caste, mob/living/carbon/Xenomorph/oldXeno, h_number)
	caste = pre_made_caste
	. = ..(mapload, oldXeno, h_number)

/mob/living/carbon/Xenomorph/Custom/Destroy()
	. = ..()
	//If our caste is not in the global, it means it isn't the singleton and should therefor be deleted with us
	if(!(caste in xeno_custom_datums))
		QDEL_NULL(caste)
