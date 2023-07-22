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

/*
//----------------------------------//
// UNUPDATED LEGACY CODE //
//----------------------------------//

/datum/surgery_step/internal/fix_organ_robotic //For artificial organs
	allowed_tools = list(
		/obj/item/stack/nanopaste = 100,   \
		/obj/item/tool/surgery/bonegel = 30,  \
		/obj/item/tool/screwdriver = 70, \
	)

	min_duration = FIX_ORGAN_MIN_DURATION
	max_duration = FIX_ORGAN_MAX_DURATION

/datum/surgery_step/internal/fix_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(..())
		if(affected.body_part == BODY_FLAG_HEAD)//brain and eye damage is fixed by a separate surgery
			return 0
		for(var/datum/internal_organ/I in affected.internal_organs)
			if(I.damage > 0 && I.robotic == ORGAN_ROBOT)
				return 1

/datum/surgery_step/internal/fix_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	for(var/datum/internal_organ/I in affected.internal_organs)
		if(I && I.damage > 0 && I.robotic == ORGAN_ROBOT)
			user.visible_message(SPAN_NOTICE("[user] starts mending the damage to [target]'s [I.name]'s mechanisms."), \
			SPAN_NOTICE("You start mending the damage to [target]'s [I.name]'s mechanisms.") )
			log_interact(user, target, "[key_name(user)] started to repair damage to [key_name(target)]'s [I.name]'s mechanisms.")


	target.custom_pain("The pain in your [affected.display_name] is living hell!", 1)
	..()

/datum/surgery_step/internal/fix_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	for(var/datum/internal_organ/I in affected.internal_organs)
		if(I && I.damage > 0 && I.robotic == ORGAN_ROBOT)
			user.visible_message(SPAN_NOTICE("[user] repairs [target]'s [I.name] with [tool]."), \
			SPAN_NOTICE("You repair [target]'s [I.name] with [tool].") )
			log_interact(user, target, "[key_name(user)] repaired damage to [key_name(target)]'s [I.name]'s mechanisms.")
			I.damage = 0

/datum/surgery_step/internal/fix_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, gumming up the mechanisms inside of [target]'s [affected.display_name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, gumming up the mechanisms inside of [target]'s [affected.display_name] with \the [tool]!"))
	log_interact(user, target, "[key_name(user)] failed to repair damage inside of [key_name(target)]'s [affected.display_name] with \the [tool].")

	target.apply_damage(5, TOX)
	affected.createwound(CUT, 5)

	for(var/datum/internal_organ/I in affected.internal_organs)
		if(I)
			I.take_damage(rand(3, 5), 0)
	target.updatehealth()
	affected.update_wounds()


//------------------------------------

/datum/surgery_step/internal/detach_organ
	allowed_tools = list()
	/obj/item/tool/surgery/scalpel = 100, \
	/obj/item/tool/kitchen/knife = 75, \
	/obj/item/shard = 50, \
	)

	min_duration = SCALPEL_MIN_DURATION
	max_duration = SCALPEL_MAX_DURATION

/datum/surgery_step/internal/detach_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(!..())
		return 0

	if(checks_only) //Second call of can_use(), just before calling end_step().
		if(affected.surgery_organ)
			var/datum/internal_organ/I = target.internal_organs_by_name[affected.surgery_organ]
			if(I && !I.cut_away)
				return 1
	else
		var/list/attached_organs = list()
		for(var/organ in target.internal_organs_by_name)
			var/datum/internal_organ/I = target.internal_organs_by_name[organ]
			if(!I.cut_away && I.parent_limb == target_zone)
				attached_organs |= organ

		var/organ_to_detach = tgui_input_list(user, "Which organ do you want to prepare for removal?", "Remove organ", attached_organs)
		if(!organ_to_detach)
			return 0
		if(affected.surgery_organ)
			return 0

		var/datum/internal_organ/I = target.internal_organs_by_name[organ_to_detach]
		if(!I || I.cut_away)
			return 0

		if(..())
			affected.surgery_organ = organ_to_detach
			return 1

/datum/surgery_step/internal/detach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts to separate [target]'s [affected.surgery_organ] with \the [tool]."), \
	SPAN_NOTICE("You start to separate [target]'s [affected.surgery_organ] with \the [tool].") )
	log_interact(user, target, "[key_name(user)] started to detatch [key_name(target)]'s [affected.surgery_organ] with \the [tool].")
	target.custom_pain("The pain in your [affected.display_name] is living hell!", 1)
	..()

/datum/surgery_step/internal/detach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has separated [target]'s [affected.surgery_organ] with \the [tool].") , \
	SPAN_NOTICE("You have separated [target]'s [affected.surgery_organ] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] detatched [key_name(target)]'s [affected.surgery_organ] with \the [tool].")

	var/datum/internal_organ/I = target.internal_organs_by_name[affected.surgery_organ]
	I.cut_away = TRUE
	affected.surgery_organ = null

/datum/surgery_step/internal/detach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing an artery inside [target]'s [affected.display_name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, slicing an artery inside [target]'s [affected.display_name] with \the [tool]!"))
	log_interact(user, target, "[key_name(user)] failed to detatch [key_name(target)]'s [affected.surgery_organ] with \the [tool].")

	affected.createwound(CUT, rand(30, 50), 1)
	affected.update_wounds()
	affected.surgery_organ = null


//------------------------------------

/datum/surgery_step/internal/remove_organ
	allowed_tools = list()
	/obj/item/tool/surgery/hemostat = 100,    \
	/obj/item/tool/wirecutters = 75,  \
	/obj/item/tool/kitchen/utensil/fork = 20
	)

	min_duration = SCALPEL_MIN_DURATION
	max_duration = SCALPEL_MAX_DURATION

/datum/surgery_step/internal/remove_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(!..())
		return 0

	if(checks_only) //Second call of can_use(), just before calling end_step().
		if(affected.surgery_organ)
			var/datum/internal_organ/I = target.internal_organs_by_name[affected.surgery_organ]
			if(I && I.cut_away)
				return 1
	else
		var/list/removable_organs = list()
		for(var/organ in target.internal_organs_by_name)
			var/datum/internal_organ/I = target.internal_organs_by_name[organ]
			if(I.cut_away && I.parent_limb == target_zone)
				removable_organs |= organ

		var/organ_to_remove = tgui_input_list(user, "Which organ do you want to remove?", "Remove organ", removable_organs)
		if(!organ_to_remove)
			return 0
		if(affected.surgery_organ) //already working on an organ
			return 0

		var/datum/internal_organ/I = target.internal_organs_by_name[organ_to_remove]
		if(!I || !I.cut_away)
			return 0

		if(..())
			affected.surgery_organ = organ_to_remove
			return 1

/datum/surgery_step/internal/remove_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts removing [target]'s [affected.surgery_organ] with \the [tool]."), \
	SPAN_NOTICE("You start removing [target]'s [affected.surgery_organ] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] started to remove [key_name(target)]'s [affected.surgery_organ] with \the [tool].")

	target.custom_pain("Someone's ripping out your [affected.surgery_organ]!", 1)
	..()

/datum/surgery_step/internal/remove_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has removed [target]'s [affected.surgery_organ] with \the [tool]."), \
	SPAN_NOTICE("You have removed [target]'s [affected.surgery_organ] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] removed [key_name(target)]'s [affected.surgery_organ] with \the [tool].")

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_ORGAN_REMOVE)

	//Extract the organ!
	if(affected.surgery_organ)

		var/datum/internal_organ/I = target.internal_organs_by_name[affected.surgery_organ]

		var/obj/item/organ/O
		if(I && istype(I))
			O = I.remove(user)
			if(O && istype(O))

				//Stop the organ from continuing to reject.
				O.organ_data.rejecting = null

				//Transfer over some blood
				var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in O.reagents.reagent_list
				if(!organ_blood)
					target.take_blood(O, 5)

				//Kinda redundant, but I'm getting some buggy behavior.
				target.internal_organs_by_name[affected.surgery_organ] = null
				target.internal_organs_by_name -= affected.surgery_organ
				target.internal_organs -= O.organ_data
				affected.internal_organs -= O.organ_data
				O.removed(target,user)

		affected.surgery_organ = null

/datum/surgery_step/internal/remove_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the flesh in [target]'s [affected.display_name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging the flesh in [target]'s [affected.display_name] with \the [tool]!"))
	log_interact(user, target, "[key_name(user)] failed to remove [key_name(target)]'s [affected.surgery_organ] with \the [tool].")

	affected.createwound(BRUISE, 20)
	affected.update_wounds()
	affected.surgery_organ = null

//------------------------------------

/datum/surgery_step/internal/replace_organ
	allowed_tools = list(/obj/item/organ = 100)

	min_duration = IMPLANT_MIN_DURATION
	max_duration = IMPLANT_MAX_DURATION

/datum/surgery_step/internal/replace_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)

	var/obj/item/organ/O = tool

	var/organ_compatible
	var/organ_missing

	if(!istype(O))
		return 0

	if(!target.species)
		to_chat(user, SPAN_WARNING("You have no idea what species this person is. Report this on the bug tracker."))
		return SPECIAL_SURGERY_INVALID

	var/o_is = (O.gender == PLURAL) ? "are"   : "is"
	var/o_a =  (O.gender == PLURAL) ? ""   : "a "
	var/o_do = (O.gender == PLURAL) ? "don't" : "doesn't"

	if(target.species.has_organ[O.organ_tag])

		if(!O.health)
			to_chat(user, SPAN_WARNING("\The [O.organ_tag] [o_is] in no state to be anted."))
			return SPECIAL_SURGERY_INVALID

		if(!target.internal_organs_by_name[O.organ_tag])
			organ_missing = 1
		else
			to_chat(user, SPAN_WARNING("\The [target] already has [o_a][O.organ_tag]."))
			return SPECIAL_SURGERY_INVALID

		if(O.organ_data && affected.name == O.organ_data.parent_limb)
			organ_compatible = 1
		else
			to_chat(user, SPAN_WARNING("\The [O.organ_tag] [o_do] normally go in \the [affected.display_name]."))
			return SPECIAL_SURGERY_INVALID
	else
		to_chat(user, SPAN_WARNING("You're pretty sure [target.species.name_plural] don't normally have [o_a][O.organ_tag]."))
		return SPECIAL_SURGERY_INVALID

	return ..() && organ_missing && organ_compatible

/datum/surgery_step/internal/replace_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts transplanting \the [tool] into [target]'s [affected.display_name]."), \
	SPAN_NOTICE("You start transplanting \the [tool] into [target]'s [affected.display_name]."))
	log_interact(user, target, "[key_name(user)] started to transplant \the [tool] into [key_name(target)]'s [affected.display_name].")

	target.custom_pain("Someone's rooting around in your [affected.display_name]!", 1)
	..()

/datum/surgery_step/internal/replace_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has transplanted \the [tool] into [target]'s [affected.display_name]."), \
	SPAN_NOTICE("You have transplanted \the [tool] into [target]'s [affected.display_name]."))
	log_interact(user, target, "[key_name(user)] transplanted \the [tool] into [key_name(target)]'s [affected.display_name].")

	user.temp_drop_inv_item(tool)
	var/obj/item/organ/O = tool

	if(istype(O))

		var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in O.reagents.reagent_list
		if(!transplant_blood)
			O.organ_data.transplant_data = list()
			O.organ_data.transplant_data["species"] = target.species.name
			O.organ_data.transplant_data["blood_type"] = target.blood_type
		else
			O.organ_data.transplant_data = list()
			O.organ_data.transplant_data["species"] = transplant_blood.data_properties["species"]
			O.organ_data.transplant_data["blood_type"] = transplant_blood.data_properties["blood_type"]

		O.organ_data.organ_holder = null
		O.organ_data.owner = target
		target.internal_organs |= O.organ_data
		affected.internal_organs |= O.organ_data
		target.internal_organs_by_name[O.organ_tag] = O.organ_data
		O.organ_data.cut_away = TRUE
		O.replaced(target)

	qdel(O)

/datum/surgery_step/internal/replace_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging \the [tool]!"))
	log_interact(user, target, "[key_name(user)] failed to transplant \the [tool] into [key_name(target)]'s [affected.display_name].")

	var/obj/item/organ/I = tool
	if(istype(I))
		I.organ_data.take_damage(rand(3, 5), 0)
	target.updatehealth()

//------------------------------------

/datum/surgery_step/internal/attach_organ
	allowed_tools = list(
		/obj/item/tool/surgery/FixOVein = 100, \
		/obj/item/stack/cable_coil = 75
	)

	min_duration = FIXVEIN_MIN_DURATION
	max_duration = FIXVEIN_MAX_DURATION

/datum/surgery_step/internal/attach_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(!..())
		return 0

	if(checks_only) //Second call of can_use(), just before calling end_step().
		if(affected.surgery_organ)
			var/datum/internal_organ/I = target.internal_organs_by_name[affected.surgery_organ]
			if(I && I.cut_away)
				return 1
	else
		var/list/removable_organs = list()
		for(var/organ in target.internal_organs_by_name)
			var/datum/internal_organ/I = target.internal_organs_by_name[organ]
			if(I.cut_away && I.parent_limb == target_zone)
				removable_organs |= organ

		var/organ_to_replace = tgui_input_list(user, "Which organ do you want to reattach?", "Attach organ", removable_organs)
		if(!organ_to_replace)
			return 0

		if(affected.surgery_organ)
			return 0

		var/datum/internal_organ/I = target.internal_organs_by_name[organ_to_replace]
		if(!I || !I.cut_away)
			return 0

		if(..())
			affected.surgery_organ = organ_to_replace
			return 1

/datum/surgery_step/internal/attach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] begins reattaching [target]'s [affected.surgery_organ] with \the [tool]."), \
	SPAN_NOTICE("You start reattaching [target]'s [affected.surgery_organ] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] started to reattach [key_name(target)]'s [affected.surgery_organ] with \the [tool].")

	target.custom_pain("Someone's digging needles into your [affected.surgery_organ]!", 1)
	..()

/datum/surgery_step/internal/attach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has reattached [target]'s [affected.surgery_organ] with \the [tool].") , \
	SPAN_NOTICE("You have reattached [target]'s [affected.surgery_organ] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] reattached [key_name(target)]'s [affected.surgery_organ] with \the [tool].")

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_ORGAN_ATTACH)

	var/datum/internal_organ/I = target.internal_organs_by_name[affected.surgery_organ]
	I.cut_away = FALSE
	affected.surgery_organ = null

/datum/surgery_step/internal/attach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the flesh in [target]'s [affected.display_name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging the flesh in [target]'s [affected.display_name] with \the [tool]!"))
	log_interact(user, target, "[key_name(user)] failed to reattach [key_name(target)]'s [affected.surgery_organ] with \the [tool].")

	affected.createwound(BRUISE, 20)
	affected.update_wounds()
	affected.surgery_organ = null
*/
