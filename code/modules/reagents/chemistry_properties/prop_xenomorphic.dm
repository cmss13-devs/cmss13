/datum/chem_property/xenomorphic
	rarity = PROPERTY_XENOMORPHIC
	category = PROPERTY_TYPE_ANOMALOUS
	value = 8

/datum/chem_property/xenomorphic/weed_resistant
	name = PROPERTY_WEED_RESISTANT
	code = "WRS"
	description = "Reduces the effect of weeds on movement, allowing for faster traversing through resin."
	category = PROPERTY_TYPE_STIMULANT|PROPERTY_TYPE_UNADJUSTABLE
	value = 5
	max_level = 1

/datum/chem_property/xenomorphic/weed_resistant/on_start(mob/living/target)
	. = ..()
	ADD_TRAIT(target, TRAIT_WEED_RESISTANT, REAGENT_TRAIT)

/datum/chem_property/xenomorphic/weed_resistant/on_delete(mob/living/target)
	REMOVE_TRAIT(target, TRAIT_WEED_RESISTANT, REAGENT_TRAIT)
	return ..()

/datum/chem_property/xenomorphic/screech_resistant
	name = PROPERTY_SCREECH_RESISTANT
	code = "VRS"
	description = "Absorbs high intensity vibrations. Completely metabolizes the reagent when this occurs."
	category = PROPERTY_TYPE_STIMULANT|PROPERTY_TYPE_UNADJUSTABLE
	value = 5
	max_level = 1

/datum/chem_property/xenomorphic/screech_resistant/on_start(mob/living/target)
	. = ..()
	ADD_TRAIT(target, TRAIT_SCREECH_RESISTANT, REAGENT_TRAIT)

/datum/chem_property/xenomorphic/screech_resistant/on_delete(mob/living/target)
	REMOVE_TRAIT(target, TRAIT_SCREECH_RESISTANT, REAGENT_TRAIT)
	return ..()

// Corrupted xenos probably won't like this one
/datum/chem_property/xenomorphic/taming
	name = PROPERTY_TAMING
	code = "TMG"
	description = "Chemically combines with the cells in the target, attuning to a desired frequency and stabilizing the DNA."
	category = PROPERTY_TYPE_MEDICINE|PROPERTY_TYPE_UNADJUSTABLE
	value = 5
	max_level = 1

/datum/chem_property/xenomorphic/taming/reagent_added(atom/checking, datum/reagent/reagent, amount)
	. = ..()
	if(!isxeno(checking))
		return
	var/mob/living/carbon/xenomorph/target = checking
	if(reagent.volume < 100 || target.hivenumber != XENO_HIVE_CORRUPTED || isqueen(target))
		return
	target.set_hive_and_update(XENO_HIVE_TAMED)


