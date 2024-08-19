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
		to_chat(target, SPAN_WARNING("Your paygrade is too high for you to be able to receive the lisping trait."))
		return
	if(target.job in inapplicable_roles)
		to_chat(target, SPAN_WARNING("Your office is too high for you to be able to receive the lisping trait."))
		return
	if(target.species.group in inapplicable_species)
		to_chat(target, SPAN_WARNING("Your species is too sophisticated for you be able to receive the lisping trait."))
		return

	ADD_TRAIT(target, TRAIT_LISPING, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/lisp/unapply_trait(mob/living/carbon/human/target)
	REMOVE_TRAIT(target, TRAIT_LISPING, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/bad_leg
	trait_name = "Bad Leg"
	trait_desc = "Your left (or right, if the left's robotic) leg suffered an undetermined wound a long time ago that never fully healed. Walking around without a cane will eventually cause you to freeze in pain, but you start with one."
	applyable = TRUE
	cost = 1
	/// Roles that will not allow the trait to be added. (Due to being designed for combat, heavy physical duty, or just being too junior to be worth keeping around as a cripple.)
	var/list/inapplicable_roles
	/// Roles that get the shitty wooden pole.
	var/list/bad_cane_roles
	/// Roles that get the fancy cane.
	var/list/fancy_cane_roles
	/// Species that will not allow the trait to be added.
	var/list/inapplicable_species

/datum/character_trait/biology/bad_leg/New()
	. = ..()
	// Not on definition as several lists are added
	inapplicable_roles = list(JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_TANK_CREW, JOB_INTEL, JOB_ORDNANCE_TECH, JOB_MARINE) + JOB_SQUAD_ROLES_LIST + JOB_MARINE_RAIDER_ROLES_LIST + JOB_ERT_GRUNT_LIST
	bad_cane_roles = list(JOB_SURVIVOR, JOB_STOWAWAY)
	fancy_cane_roles = list(JOB_CO_SURVIVOR, CORPORATE_SURVIVOR, JOB_CMO, JOB_CORPORATE_LIAISON, JOB_SEA, JOB_CHIEF_ENGINEER) + JOB_COMMAND_ROLES_LIST
	inapplicable_species = list(SPECIES_SYNTHETIC, SPECIES_YAUTJA)

/datum/character_trait/biology/bad_leg/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	if(target.job in inapplicable_roles)
		to_chat(target, SPAN_WARNING("Your office is too combat-geared for you to be able to receive the bad leg trait."))
		return
	if(target.species.group in inapplicable_species)
		to_chat(target, SPAN_WARNING("Your species is too sophisticated for you be able to receive the bad leg trait."))
		return

	target.AddComponent(/datum/component/bad_leg)

	var/cane_type = /obj/item/weapon/pole/wooden_cane
	if(target.job in bad_cane_roles)
		cane_type = /obj/item/weapon/pole // todo - add some sort of override for corporate liaison/director/etc survivors
	if(target.job in fancy_cane_roles)
		cane_type = /obj/item/weapon/pole/fancy_cane

	var/obj/item/weapon/pole/cane = new cane_type(target.loc)

	var/success = target.equip_to_slot_if_possible(cane, WEAR_L_HAND)
	if(!success)
		success = target.equip_to_slot_if_possible(cane, WEAR_R_HAND)

	..()

//datum/character_trait/biology/bad_leg/unapply_trait(mob/living/carbon/human/target) // IMPOSSIBLE

/datum/character_trait/biology/hardcore
	trait_name = "Hardcore"
	trait_desc = "One life. One chance. (Rifleman Only)"
	applyable = TRUE
	cost = 1

/datum/character_trait/biology/hardcore/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	if(target.job != JOB_SQUAD_MARINE)
		to_chat(target, SPAN_WARNING("Only riflemen can have the Hardcore trait."))
		return

	ADD_TRAIT(target, TRAIT_HARDCORE, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/hardcore/unapply_trait(mob/living/carbon/human/target)
	REMOVE_TRAIT(target, TRAIT_HARDCORE, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/iron_teeth
	trait_name = "Iron Teeth"
	trait_desc = "You've got iron teeth or really good dental insurance. Items in your face slot won't fall out when you go down."
	applyable = TRUE
	cost = 1

/datum/character_trait/biology/iron_teeth/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	ADD_TRAIT(target, TRAIT_IRON_TEETH, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/iron_teeth/unapply_trait(mob/living/carbon/human/target)
	REMOVE_TRAIT(target, TRAIT_IRON_TEETH, ROUNDSTART_TRAIT)
	..()
