//Procedures in this file: brain damage surgery.
//////////////////////////////////////////////////////////////////
// BRAIN DAMAGE FIXING //
//////////////////////////////////////////////////////////////////

/datum/surgery/brain_repair
	name = "Brain Repair Surgery"
	possible_locs = list("head")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_MEDIUM //Brain doesn't actually have much in the way of nerve endings.
	steps = list(/datum/surgery_step/remove_bone_chips)
	var/dmg_min = 0
	var/dmg_max = BONECHIPS_MAX_DAMAGE

/datum/surgery/brain_repair/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	var/datum/internal_organ/brain/B = patient.internal_organs_by_name["brain"]
	if(!B || B.damage <= dmg_min || B.robotic == ORGAN_ROBOT)
		return FALSE
	if(dmg_max && B.damage > dmg_max)
		return FALSE
	return TRUE

/datum/surgery/brain_repair/heavy //Serious brain damage requires a serious surgery.
	dmg_min = BONECHIPS_MAX_DAMAGE
	dmg_max = FALSE
	steps = list(
		/datum/surgery_step/treat_hematoma,
		/datum/surgery_step/remove_bone_chips,
	)

//------------------------------------

/datum/surgery_step/remove_bone_chips
	name = "Remove Embedded Bone Chips"
	desc = "remove the shards of bone"
	tools = SURGERY_TOOLS_PINCH
	time = 5 SECONDS

/datum/surgery_step/remove_bone_chips/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin picking chips of bone out of [target]'s brain with \the [tool]."),
		SPAN_NOTICE("[user] begins picking chips of bone out of your brain with \the [tool]."),
		SPAN_NOTICE("[user] begins picking chips of bone out of [target]'s brain with \the [tool]."))

	log_interact(user, target, "[key_name(user)] started taking bone chips out of [key_name(target)]'s brain with \the [tool], possibly beginning [surgery]")

/datum/surgery_step/remove_bone_chips/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish extracting fragments of bone from [target]'s brain."),
		SPAN_NOTICE("[user] finishes extracting fragments of bone from your brain."),
		SPAN_NOTICE("[user] finishes extracting fragments of bone from [target]'s brain."))

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_BRAIN)

	var/datum/internal_organ/brain/B = target.internal_organs_by_name["brain"]
	if(B)
		B.heal_damage(B.damage)
	target.disabilities &= ~NERVOUS
	target.sdisabilities &= ~DISABILITY_DEAF
	target.sdisabilities &= ~DISABILITY_MUTE
	target.jitteriness = 0
	target.pain.recalculate_pain()

	log_interact(user, target, "[key_name(user)] finished taking bone chips out of [key_name(target)]'s brain with \the [tool], finishing [surgery].")

/datum/surgery_step/remove_bone_chips/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, tearing a blood vessel in [target]'s [surgery.affected_limb.display_name] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, tearing a blood vessel in your [surgery.affected_limb.display_name] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, tearing a blood vessel in [target]'s [surgery.affected_limb.display_name] with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to take the bone chips out of [key_name(target)]'s brain with \the [tool], possibly aborting [surgery].")

	var/datum/wound/internal_bleeding/I = new (0)
	surgery.affected_limb.add_bleeding(I, TRUE)
	surgery.affected_limb.wounds += I
	target.custom_pain("You feel something rip in your [surgery.affected_limb.display_name]!", 1)
	return FALSE

//------------------------------------

/datum/surgery_step/treat_hematoma
	name = "Treat Hematoma"
	desc = "repair the hematoma"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 5 SECONDS

/datum/surgery_step/treat_hematoma/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin mending the hematoma in [target]'s brain with \the [tool]."),
		SPAN_NOTICE("[user] begins to mend the hematoma in your brain with \the [tool]."),
		SPAN_NOTICE("[user] begins to mend the hematoma in [target]'s brain with \the [tool]."))

	log_interact(user, target, "[key_name(user)] started mending a hematoma in [key_name(target)]'s brain with \the [tool].")

/datum/surgery_step/treat_hematoma/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish mending the hematoma in [target]'s brain."),
		SPAN_NOTICE("[user] finishes mending the hematoma in your brain."),
		SPAN_NOTICE("[user] finishes mending the hematoma in [target]'s brain."))

	log_interact(user, target, "[key_name(user)] finished mending a hematoma in [key_name(target)]'s brain with \the [tool], beginning [surgery].")

	var/datum/internal_organ/brain/B = target.internal_organs_by_name["brain"]
	if(B)
		B.damage = BONECHIPS_MAX_DAMAGE
	target.disabilities &= ~NERVOUS
	target.sdisabilities &= ~DISABILITY_DEAF
	target.sdisabilities &= ~DISABILITY_MUTE

/datum/surgery_step/treat_hematoma/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, bruising [target]'s brain with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, bruising your brain with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s brain with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to mend the hematoma in [key_name(target)]'s brain with \the [tool], aborting [surgery].")

	target.apply_damage(15, BRUTE, target_zone)
	return FALSE
