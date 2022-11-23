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
