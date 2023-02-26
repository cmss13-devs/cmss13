/datum/character_trait_group/biology
	trait_group_name = "Biology"

/datum/character_trait/biology
	applyable = FALSE
	trait_group = /datum/character_trait_group/biology

/datum/character_trait/biology/bad_eyesight
	trait_name = "Bad Eyesight"
	trait_desc = "A condition in which close objects appear clearly, but far ones don't."
	applyable = TRUE
	cost = 1

/datum/character_trait/biology/bad_eyesight/apply_trait(mob/living/carbon/human/target)
	..()
	ENABLE_BITFIELD(target.disabilities, NEARSIGHTED)

/datum/character_trait/biology/bad_eyesight/unapply_trait(mob/living/carbon/human/target)
	..()
	DISABLE_BITFIELD(target.disabilities, NEARSIGHTED)

/datum/character_trait/biology/opiate_receptor_deficiency
	trait_name = "Opiate Receptor Deficiency"
	trait_desc = "Due to overuse of opiates or a genetic fluke, this condition reduces the potency of all basic painkilling drugs."
	applyable = TRUE
	cost = 1

/datum/character_trait/biology/opiate_receptor_deficiency/apply_trait(mob/living/carbon/human/target)
	..()
	ENABLE_BITFIELD(target.disabilities, OPIATE_RECEPTOR_DEFICIENCY)

/datum/character_trait/biology/opiate_receptor_deficiency/unapply_trait(mob/living/carbon/human/target)
	..()
	DISABLE_BITFIELD(target.disabilities, OPIATE_RECEPTOR_DEFICIENCY)

/datum/character_trait/biology/lisp
	trait_name = "Lisping"
	trait_desc = "You have difficulty with pronouncing 'S' sounds (and similar). Expect to be mocked mercilessly."
	applyable = TRUE
	cost = 1
	/// Roles that will not allow the trait to be added
	var/list/inapplicable_roles = list(JOB_COMMAND_ROLES_LIST)
	/// Species that will not allow the trait to be added.
	var/list/inapplicable_species = list(SPECIES_SYNTHETIC) // Let's let predators lisp if they reaaaally want to.
	/// Maximum rank at which you can have this trait.
	var/maximum_ranking = 4 // Nothing above this. Lisping makes you hard to understand - bad for pretty much any role that requires you to communicate. Marines get away with it though.

/datum/character_trait/biology/lisp/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	var/string_paygrade = preset.load_rank(target)
	var/datum/paygrade/paygrade_datum = GLOB.paygrades[string_paygrade]
	if(paygrade_datum?.ranking > maximum_ranking)
		to_chat(target, SPAN_WARNING("Your paygrade is too high for you to be able to recieve the lisping trait."))
		return
	if(target.job in inapplicable_roles)
		to_chat(target, SPAN_WARNING("Your office is too high for you to be able to recieve the lisping trait."))
		return
	if(target.species.group in inapplicable_species)
		to_chat(target, SPAN_WARNING("Your species is too sophisticated for you be able to recieve the lisping trait."))
		return

	ADD_TRAIT(target, TRAIT_LISPING, TRAIT_SOURCE_QUIRK)

	..()

/datum/character_trait/biology/lisp/unapply_trait(mob/living/carbon/human/target)
	REMOVE_TRAIT(target, TRAIT_LISPING, TRAIT_SOURCE_QUIRK)
	..()
