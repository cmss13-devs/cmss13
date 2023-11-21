//Procedures in this file: Eye mending surgery
//Steps will only work in a surgery of /datum/surgery/eye_repair or a child of that due to target_eyes var.
//////////////////////////////////////////////////////////////////
// EYE SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/eye_repair
	name = "Eye Repair Surgery"
	possible_locs = list("eyes")
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_LIGHT //Eye doesn't have pain receptors.
	steps = list(
		/datum/surgery_step/separate_cornea,
		/datum/surgery_step/lift_eyes,
		/datum/surgery_step/mend_eyes,
		/datum/surgery_step/cauterize/eyes,
	)
	var/datum/internal_organ/eyes/target_eyes

/datum/surgery/eye_repair/New(surgery_target, surgery_location, surgery_limb)
	..()
	if(target)
		var/mob/living/carbon/human/targethuman = target
		target_eyes = targethuman.internal_organs_by_name["eyes"]

/datum/surgery/eye_repair/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	var/datum/internal_organ/eyes/E = patient.internal_organs_by_name["eyes"]
	return E && E.damage > 0 && E.robotic != ORGAN_ROBOT

//------------------------------------

/datum/surgery_step/separate_cornea
	name = "Separate Corneas"
	desc = "separate the corneas"
	tools = SURGERY_TOOLS_INCISION
	time = 2 SECONDS

/datum/surgery_step/separate_cornea/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start to separate the corneas of [target]'s eyes with \the [tool]."),
		SPAN_NOTICE("[user] starts to separate the corneas of your eyes with \the [tool]."),
		SPAN_NOTICE("[user] starts to separate the corneas of [target]'s eyes with \the [tool]."))

	log_interact(user, target, "[key_name(user)] started to separate the cornea on [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/separate_cornea/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You have separated [target]'s corneas."),
		SPAN_NOTICE("[user] has separated your corneas."),
		SPAN_NOTICE("[user] has separated [target]'s corneas."))

	log_interact(user, target, "[key_name(user)] separated the cornea on [key_name(target)]'s eyes with \the [tool], starting [surgery].")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SHALLOW
	target.disabilities |= NEARSIGHTED // code\#define\mobs.dm

/datum/surgery_step/separate_cornea/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, slicing [target]'s eyes with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, slicing your eyes with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, slicing [target]'s eyes with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to separate the cornea on [key_name(target)]'s eyes with \the [tool], aborting [surgery].")

	target.apply_damage(10, BRUTE, target_zone)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/lift_eyes
	name = "Lift Corneas"
	desc = "lift the corneas"
	tools = SURGERY_TOOLS_PRY_DELICATE
	time = 2 SECONDS

/datum/surgery_step/lift_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin lifting the corneas from [target]'s eyes with \the [tool]."),
		SPAN_NOTICE("[user] begins to lift the corneas from your eyes with \the [tool]."),
		SPAN_NOTICE("[user] begins to lift the corneas from [target]'s eyes with \the [tool]."))

	log_interact(user, target, "[key_name(user)] started to lift the cornea from [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/lift_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish lifting [target]'s corneas."),
		SPAN_NOTICE("[user] has lifted your corneas."),
		SPAN_NOTICE("[user] has lifted [target]'s corneas."))

	log_interact(user, target, "[key_name(user)] lifted the cornea from [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/lift_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging [target]'s eyes with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging your eyes with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s eyes with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to lift the cornea from [key_name(target)]'s eyes with \the [tool].")

	target.apply_damage(10, BRUTE, target_zone)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/mend_eyes
	name = "Mend Ocular Nerves"
	desc = "mend the eyes"
	tools = SURGERY_TOOLS_PINCH
	time = 4 SECONDS

/datum/surgery_step/mend_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin mending the nerves and lenses in [target]'s eyes with \the [tool]."),
		SPAN_NOTICE("[user] begins to mend the nerves and lenses in your eyes with \the [tool]."),
		SPAN_NOTICE("[user] begins to mend the nerves and lenses in [target]'s eyes with \the [tool]."))

	log_interact(user, target, "[key_name(user)] started to mend the nerves and lenses in [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/mend_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You mend the nerves and lenses in [target]'s eyes."),
		SPAN_NOTICE("[user] mends the nerves and lenses in your eyes."),
		SPAN_NOTICE("[user] mends the nerves and lenses in [target]'s eyes."))

	log_interact(user, target, "[key_name(user)] mended the nerves and lenses in [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/mend_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging [target]'s eyes with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging your eyes with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s eyes with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to mend the nerves and lenses in [key_name(target)]'s eyes with \the [tool].")

	target.apply_damage(10, BRUTE, target_zone, sharp = 1)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/cauterize/eyes
	name = "Cauterize Eye Incisions"
	desc = "cauterize the incisions"
	time = 3 SECONDS

/datum/surgery_step/cauterize/eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to reattach [target]'s corneas with \the [tool]."),
		SPAN_NOTICE("[user] begins to reattach your corneas with \the [tool]."),
		SPAN_NOTICE("[user] begins to reattach [target]'s corneas with \the [tool]."))

	log_interact(user, target, "[key_name(user)] began to cauterize the incision around [key_name(target)]'s eyes with \the [tool].")


/datum/surgery_step/cauterize/eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You reattach [target]'s corneas."),
		SPAN_NOTICE("[user] reattaches your corneas."),
		SPAN_NOTICE("[user] reattaches [target]'s corneas."))

	log_interact(user, target, "[key_name(user)] cauterized the incision around [key_name(target)]'s eyes with \the [tool], ending [surgery].")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	target.disabilities &= ~NEARSIGHTED
	target.sdisabilities &= ~DISABILITY_BLIND
	surgery.target_eyes.heal_damage(surgery.target_eyes.damage)
	user.count_niche_stat(STATISTICS_NICHE_SURGERY_EYE)
	target.pain.recalculate_pain()

/datum/surgery_step/cauterize/eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, searing [target]'s eyes with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, searing your eyes with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, searing [target]'s eyes with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to cauterize the incision around [key_name(target)]'s eyes with \the [tool].")

	target.apply_damage(15, BURN, target_zone)
	surgery.target_eyes.take_damage(10, FALSE)
	return FALSE
