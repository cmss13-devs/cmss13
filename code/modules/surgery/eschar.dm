/datum/surgery/eschar_mend
	name = "Eschar mending Surgery"
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	steps = list(
		/datum/surgery_step/open_eschar,
		/datum/surgery_step/fix_eschar,
	)

/datum/surgery/eschar_mend/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return L.status & LIMB_ESCHAR

/datum/surgery_step/open_eschar
	name = "Open eschar"
	desc = "open the eschar"
	tools = SURGERY_TOOLS_INCISION
	time = 2 SECONDS

/datum/surgery_step/open_eschar/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start to open the eschar on [target] with \the [tool]."),
		SPAN_NOTICE("[user] starts to open the eschar with \the [tool]."),
		SPAN_NOTICE("[user] starts to open the eschar on [target] with \the [tool]."))

	log_interact(user, target, "[key_name(user)] to open the eschar o [key_name(target)] with \the [tool].")

/datum/surgery_step/open_eschar/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You have opened [target] eschar."),
		SPAN_NOTICE("[user] has opened your eschar."),
		SPAN_NOTICE("[user] has opened [target]'s eschar."))

	log_interact(user, target, "[key_name(user)] opened eschar on [key_name(target)] with \the [tool], starting [surgery].")

/datum/surgery_step/open_eschar/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, slicing [target] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, slicing you with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, slicing [target] with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to open eschar on [key_name(target)] with \the [tool], aborting [surgery].")

	target.apply_damage(10, BRUTE, target_zone)
	return FALSE

/datum/surgery_step/fix_eschar
	name = "Repair Eschar On Limb"
	desc = "repair the eschar on limb"
	tools = list(
		/obj/item/stack/medical/advanced/ointment = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/stack/medical/advanced/ointment/predator = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/stack/medical/ointment = SURGERY_TOOL_MULT_AWFUL,
		/obj/item/tool/surgery/synthgraft = SURGERY_TOOL_MULT_IDEAL,
	)
	time = 3 SECONDS

/datum/surgery_step/fix_eschar/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start to mend the eschar on [target] with \the [tool]."),
		SPAN_NOTICE("[user] starts to mend the eschar with \the [tool]."),
		SPAN_NOTICE("[user] starts to mend the eschar on [target] with \the [tool]."))

	log_interact(user, target, "[key_name(user)] to mend the eschar o [key_name(target)] with \the [tool].")

/datum/surgery_step/fix_eschar/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You have mended [target] eschar."),
		SPAN_NOTICE("[user] has mended your eschar."),
		SPAN_NOTICE("[user] has mended [target]'s eschar."))

	log_interact(user, target, "[key_name(user)] mended eschar on [key_name(target)] with \the [tool], starting [surgery].")

	surgery.affected_limb.status &= ~(LIMB_ESCHAR)
	return



/datum/surgery_step/fix_eschar/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	if(tool_type == /obj/item/stack/medical/ointment)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, smearing [tool] in [target]'s [surgery.affected_limb.display_name]!"),
			SPAN_WARNING("[user]'s hand slips, smearing [tool] in your [surgery.affected_limb.display_name]!"),
			SPAN_WARNING("[user]'s hand slips, smearing [tool] in [target]'s [surgery.affected_limb.display_name]!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging the incision in [target]'s [surgery.affected_limb.display_name] with \the [tool]!"),
			SPAN_WARNING("[user]'s hand slips, damaging the incision in your [surgery.affected_limb.display_name] with \the [tool]!"),
			SPAN_WARNING("[user]'s hand slips, damaging the incision in [target]'s [surgery.affected_limb.display_name] with \the [tool]!"))

	user.add_blood(target.get_blood_color(), BLOOD_HANDS)
	target.apply_damage(10, BRUTE, target_zone)
	return FALSE


