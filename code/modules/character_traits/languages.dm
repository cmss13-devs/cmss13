/datum/character_trait/language
	var/language_name
	applyable = FALSE
	trait_group = /datum/character_trait_group/language

/datum/character_trait/language/New()
	..()
	trait_name = "Speaks [language_name]"
	trait_desc = "Can speak the language [language_name]."

/datum/character_trait/language/apply_trait(mob/living/carbon/human/target)
	..()
	target.add_language(language_name)

/datum/character_trait/language/unapply_trait(mob/living/carbon/human/target)
	..()
	target.remove_language(language_name)

/datum/character_trait/language/russian
	language_name = LANGUAGE_RUSSIAN
	applyable = TRUE

/datum/character_trait/language/japanese
	language_name = LANGUAGE_JAPANESE
	applyable = TRUE

/datum/character_trait/language/german
	language_name = LANGUAGE_SPACENDEUTCHEN
	applyable = TRUE

/datum/character_trait/language/spanish
	language_name = LANGUAGE_SPANISH
	applyable = TRUE

/datum/character_trait_group/language
	trait_group_name = "Languages"
