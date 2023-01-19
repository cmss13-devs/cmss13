/datum/caste_datum/custom
	caste_type = XENO_CASTE_CUSTOM

/mob/living/carbon/Xenomorph/Custom
	caste_type = XENO_CASTE_CUSTOM
	///Custom xenos can have multiple delegates at once
	var/list/behavior_delegates = list()
	///Visual info to be restored after initials()
	var/list/stored_visuals = list()

/mob/living/carbon/Xenomorph/Custom/Initialize(mapload, datum/caste_datum/pre_made_caste, mob/living/carbon/Xenomorph/oldXeno, h_number)
	caste = pre_made_caste
	. = ..(mapload, oldXeno, h_number)

/mob/living/carbon/Xenomorph/Custom/Destroy()
	. = ..()
	//If our caste is not in the global, it means it isn't the singleton and should therefor be deleted with us
	if(!(caste in xeno_custom_datums))
		QDEL_NULL(caste)

///////////////////////////////////////
//		VISUAL UPDATE OVERRIDES		//
/////////////////////////////////////
/**
 * A little bit of trickery, we pretend to be something else for the purpose of updates
 * Saves a whole bunch of duplicate code
 */
/mob/living/carbon/Xenomorph/Custom/update_icons()
	//A bit of trickery, we pretend to be something else for the purposes of icons, saves a bunch of duplicate code
	caste.caste_type = stored_visuals["icon_source_caste"]
	pixel_x = stored_visuals["pixel_x"]
	pixel_y = stored_visuals["pixel_y"]
	old_x = stored_visuals["old_x"]
	old_y = stored_visuals["old_y"]
	base_pixel_x = stored_visuals["base_pixel_x"]
	base_pixel_y = stored_visuals["base_pixel_y"]
	. = ..()
	caste.caste_type = initial(caste.caste_type)
