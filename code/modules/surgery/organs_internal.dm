/*Procedures in this file: chest + groin organ repair surgery, legacy prosthetic organ repair
and organ transplant code which may come in handy in future but haven't been edited at all.*/
//////////////////////////////////////////////////////////////////
// ORGAN SURGERIES //
//////////////////////////////////////////////////////////////////

/datum/surgery/organ_repair
	name = "Organ Rejuvenation Surgery"
	priority = SURGERY_PRIORITY_HIGH
	possible_locs = list("chest")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	steps = list(/datum/surgery_step/repair_organs)

/datum/surgery/organ_repair/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	for(var/datum/internal_organ/IO as anything in L.internal_organs)
		if(IO.damage > 0 && IO.robotic != ORGAN_ROBOT)
			return TRUE
	return FALSE

/datum/surgery/organ_repair/groin
	possible_locs = list("groin")
	invasiveness = list(SURGERY_DEPTH_SHALLOW)

//------------------------------------

/datum/surgery_step/repair_organs
	name = "Repair Damaged Organs"
	desc = "repair the organ damage"
	//Tools used to fix damaged organs. Predator herbs may be herbal and organic, but are not as good for surgery.
	tools = list(
		/obj/item/stack/medical/advanced/bruise_pack = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/stack/medical/advanced/bruise_pack/predator = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/stack/medical/bruise_pack = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 3 SECONDS
	repeat_step = TRUE

/datum/surgery_step/repair_organs/repeat_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	for(var/datum/internal_organ/IO as anything in surgery.affected_limb.internal_organs)
		if(IO.damage > 0 && IO.robotic != ORGAN_ROBOT)
			return TRUE
	return FALSE

/datum/surgery_step/repair_organs/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/list/damaged_organs = list()
	var/toolname
	for(var/datum/internal_organ/IO as anything in surgery.affected_limb.internal_organs)
		if(IO.damage > 0 && IO.robotic != ORGAN_ROBOT)
			damaged_organs += IO

	switch(tool_type)
		if(/obj/item/stack/medical/bruise_pack)
			toolname = "the gauze"
		if(/obj/item/stack/medical/advanced/bruise_pack)
			toolname = "regenerative membrane"
		else
			toolname = "the poultice"

	if(length(damaged_organs) > 1)
		user.affected_message(target,
			SPAN_NOTICE("You begin treating the damaged organs in [target]'s [surgery.affected_limb.display_name] with [toolname]."),
			SPAN_NOTICE("[user] begins to treat the damaged organs in your [surgery.affected_limb.display_name] with [toolname]."),
			SPAN_NOTICE("[user] begins to treat the damaged organs in [target]'s [surgery.affected_limb.display_name] with [toolname]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You begin treating [target]'s damaged [damaged_organs[1]] with [toolname]."),
			SPAN_NOTICE("[user] begins to treat your damaged [damaged_organs[1]] with [toolname]."),
			SPAN_NOTICE("[user] begins to treat [target]'s damaged [damaged_organs[1]] with [toolname]."))

	target.custom_pain("The pain in your [surgery.affected_limb.display_name] is living hell!", 1)
	playsound(target.loc, 'sound/handling/bandage.ogg', 25, TRUE)
	log_interact(user, target, "[key_name(user)] began mending organs in [key_name(target)]'s [surgery.affected_limb.display_name], beginning [surgery].")

/datum/surgery_step/repair_organs/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] mended an organ in [key_name(target)]'s [surgery.affected_limb.display_name], possibly ending [surgery].")
	for(var/datum/internal_organ/I as anything in surgery.affected_limb.internal_organs)
		if(I && I.damage > 0 && I.robotic != ORGAN_ROBOT)
			user.affected_message(target,
				SPAN_NOTICE("You finish treating [target]'s damaged [I.name]."),
				SPAN_NOTICE("[user] finishes treating your damaged [I.name]."),
				SPAN_NOTICE("[user] finishes treating [target]'s damaged [I.name]."))

			user.count_niche_stat(STATISTICS_NICHE_SURGERY_ORGAN_REPAIR)
			I.rejuvenate()
			target.pain.recalculate_pain()
			break

/datum/surgery_step/repair_organs/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, bruising [target]'s organs and contaminating \his [surgery.affected_limb.cavity]!"),
		SPAN_WARNING("[user]'s hand slips, bruising your organs and contaminating your [surgery.affected_limb.cavity]!"),
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s organs and contaminating \his [surgery.affected_limb.cavity]!"))

	var/dam_amt = 2
	switch(tool_type)
		if(/obj/item/stack/medical/bruise_pack)
			dam_amt = 5
			target.apply_damage(10, TOX)
			target.apply_damage(5, BRUTE, target_zone)
		else
			target.apply_damage(5, TOX)

	for(var/datum/internal_organ/I as anything in surgery.affected_limb.internal_organs)
		if(I && I.damage > 0)
			I.take_damage(dam_amt,0)

	log_interact(user, target, "[key_name(user)] failed to mend organs in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	return FALSE
