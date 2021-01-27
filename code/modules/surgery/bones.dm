//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/bone
	var/bone_step

/datum/surgery_step/bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	return affected.surgery_open_stage >= 2 && !(affected.status & LIMB_DESTROYED) && affected.bone_repair_stage == bone_step && !(affected.status & LIMB_REPAIRED)


/datum/surgery_step/bone/glue_bone
	allowed_tools = list(
	/obj/item/tool/surgery/bonegel = 100,	  \
	/obj/item/tool/screwdriver = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = BONEGEL_REPAIR_MIN_DURATION
	max_duration = BONEGEL_REPAIR_MAX_DURATION
	bone_step = 0

/datum/surgery_step/bone/glue_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts applying medication to the damaged bones in [target]'s [affected.display_name] with \the [tool].") , \
		SPAN_NOTICE("You start applying medication to the damaged bones in [target]'s [affected.display_name] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] began to apply medication to the damaged bones in [key_name(target)]'s [affected.display_name] with \the [tool].")

	target.custom_pain("Something in your [affected.display_name] is causing you a lot of pain!", 1)
	..()

/datum/surgery_step/bone/glue_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] applies some [tool] to [target]'s bone in [affected.display_name]."), \
	SPAN_NOTICE("You apply some [tool] to [target]'s bone in [affected.display_name] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] applied medication to the damaged bones in [key_name(target)]'s [affected.display_name] with \the [tool].")

	affected.bone_repair_stage = 1

/datum/surgery_step/bone/glue_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!") , \
	SPAN_WARNING("Your hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!"))
	log_interact(user, target, "[key_name(user)] failed to apply medication to the damaged bones in [key_name(target)]'s [affected.display_name] with \the [tool].")


/datum/surgery_step/bone/set_bone
	allowed_tools = list(
	/obj/item/tool/surgery/bonesetter = 100, \
	/obj/item/tool/wrench = 75	   \
	)

	min_duration = BONESETTER_MIN_DURATION
	max_duration = BONESETTER_MAX_DURATION
	bone_step = 1


/datum/surgery_step/bone/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	if(affected.body_part == BODY_FLAG_HEAD)
		user.visible_message(SPAN_NOTICE("[user] is beginning to piece together [target]'s skull with \the [tool].")  , \
		SPAN_NOTICE("You are beginning to piece together [target]'s skull with \the [tool]."))
		log_interact(user, target, "[key_name(user)] began to piece together [key_name(target)]'s skull with \the [tool].")

	else
		user.visible_message(SPAN_NOTICE("[user] is beginning to set the bone in [target]'s [affected.display_name] in place with \the [tool].") , \
		SPAN_NOTICE("You are beginning to set the bone in [target]'s [affected.display_name] in place with \the [tool]."))
		target.custom_pain("The pain in your [affected.display_name] is going to make you pass out!", 1)
		log_interact(user, target, "[key_name(user)] began to set the bone in [key_name(target)]'s [affected.display_name] in place with \the [tool].")
	..()

/datum/surgery_step/bone/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	if(affected.body_part == BODY_FLAG_HEAD)
		user.visible_message(SPAN_NOTICE("[user] sets [target]'s skull with \the [tool].") , \
		SPAN_NOTICE("You set [target]'s skull with \the [tool]."))
		log_interact(user, target, "[key_name(user)] set [key_name(target)]'s skull with \the [tool].")

	else
		user.visible_message(SPAN_NOTICE("[user] sets the bone in [target]'s [affected.display_name] in place with \the [tool]."), \
		SPAN_NOTICE("You set the bone in [target]'s [affected.display_name] in place with \the [tool]."))
		log_interact(user, target, "[key_name(user)] set the damaged bone in [key_name(target)]'s [affected.display_name] in place with \the [tool].")

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_BONES)
	affected.status &= ~LIMB_BROKEN
	affected.status &= ~LIMB_SPLINTED
	affected.status |= LIMB_REPAIRED
	affected.bone_repair_stage = 0
	affected.perma_injury = 0
	target.pain.recalculate_pain()

/datum/surgery_step/bone/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	if(affected.body_part == BODY_FLAG_HEAD)
		user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s face with \the [tool]!")  , \
		SPAN_WARNING("Your hand slips, damaging [target]'s face with \the [tool]!"))
		log_interact(user, target, "[key_name(user)] failed to set [key_name(target)]'s skull with \the [tool].")

		var/obj/limb/head/h = affected
		h.createwound(BRUISE, 10)
		h.disfigured = 1
		h.owner.name = h.owner.get_visible_name()
		h.update_wounds()
	else
		user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the bone in [target]'s [affected.display_name] with \the [tool]!") , \
		SPAN_WARNING("Your hand slips, damaging the bone in [target]'s [affected.display_name] with \the [tool]!"))
		log_interact(user, target, "[key_name(user)] failed to set the damaged bone in [key_name(target)]'s [affected.display_name] in place with \the [tool].")

		affected.createwound(BRUISE, 5)
		affected.update_wounds()
