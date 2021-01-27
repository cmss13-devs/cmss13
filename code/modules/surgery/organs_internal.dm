// Internal surgeries.
/datum/surgery_step/internal
	priority = 3
	can_infect = 1
	blood_level = 1

/datum/surgery_step/internal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	return affected.surgery_open_stage == (affected.encased ? 3 : 2)

//////////////////////////////////////////////////////////////////
//					ALIEN EMBRYO SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/internal/remove_embryo
	allowed_tools = list(
	/obj/item/tool/surgery/hemostat = 100,           \
	/obj/item/tool/wirecutters = 75,         \
	/obj/item/tool/kitchen/utensil/fork = 20
	)
	blood_level = 2

	min_duration = REMOVE_OBJECT_MIN_DURATION
	max_duration = REMOVE_OBJECT_MAX_DURATION

/datum/surgery_step/internal/remove_embryo/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(target_zone != "chest")
		return 0
	if(..())
		var/obj/item/alien_embryo/A = locate() in target
		if(A)
			return 1

/datum/surgery_step/internal/remove_embryo/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts to pull something out from [target]'s ribcage with \the [tool]."), \
					SPAN_NOTICE("You start to pull something out from [target]'s ribcage with \the [tool]."))
	log_interact(user, target, "[key_name(user)] started to remove an embryo from [key_name(target)]'s ribcage with \the [tool].")

	target.custom_pain("Something hurts horribly in your chest!",1)
	..()

/datum/surgery_step/internal/remove_embryo/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	var/obj/item/alien_embryo/A = locate() in target
	if(A)
		user.visible_message(SPAN_WARNING("[user] rips a wriggling parasite out of [target]'s ribcage!"),
							 SPAN_WARNING("You rip a wriggling parasite out of [target]'s ribcage!"))
		log_interact(user, target, "[key_name(user)] removed an embryo from [key_name(target)]'s ribcage with \the [tool].")

		user.count_niche_stat(STATISTICS_NICHE_SURGERY_LARVA)
		var/mob/living/carbon/Xenomorph/Larva/L = locate() in target //the larva was fully grown, ready to burst.
		if(L)
			L.forceMove(target.loc)
			qdel(A)
		else
			A.forceMove(target.loc)
			target.status_flags &= ~XENO_HOST

	affected.createwound(CUT, rand(0,20), 1)
	target.updatehealth()
	affected.update_wounds()


//////////////////////////////////////////////////////////////////
//				CHEST INTERNAL ORGAN SURGERY					//
//////////////////////////////////////////////////////////////////


/datum/surgery_step/internal/fix_organ
	allowed_tools = list(
	/obj/item/stack/medical/advanced/bruise_pack= 100, \
	/obj/item/stack/medical/bruise_pack = 20,          \
	/obj/item/stack/medical/advanced/bruise_pack/tajaran = 70,  \
	)

	min_duration = FIX_ORGAN_MIN_DURATION
	max_duration = FIX_ORGAN_MAX_DURATION

/datum/surgery_step/internal/fix_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(..())
		if(affected.body_part == BODY_FLAG_HEAD)//brain and eye damage is fixed by a separate surgery
			return 0
		for(var/datum/internal_organ/I in affected.internal_organs)
			if(I.damage > 0 && I.robotic != ORGAN_ROBOT)
				return 1


/datum/surgery_step/internal/fix_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	var/tool_name = "\the [tool]"
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	else if(istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"

	for(var/datum/internal_organ/I in affected.internal_organs)
		if(I && I.damage > 0 && I.robotic != ORGAN_ROBOT)
			user.visible_message(SPAN_NOTICE("[user] starts treating damage to [target]'s [I.name] with [tool_name]."), \
			SPAN_NOTICE("You start treating damage to [target]'s [I.name] with [tool_name].") )
			log_interact(user, target, "[key_name(user)] started to treat damage to [key_name(target)]'s [I.name] with [tool_name].")


	target.custom_pain("The pain in your [affected.display_name] is living hell!", 1)
	..()

/datum/surgery_step/internal/fix_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	var/tool_name = "\the [tool]"
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	else if(istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"

	for(var/datum/internal_organ/I in affected.internal_organs)
		if(I && I.damage > 0 && I.robotic != ORGAN_ROBOT)
			user.visible_message(SPAN_NOTICE("[user] treats damage to [target]'s [I.name] with [tool_name]."), \
			SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name].") )
			log_interact(user, target, "[key_name(user)] treated damage to [key_name(target)]'s [I.name] with [tool_name].")

			user.count_niche_stat(STATISTICS_NICHE_SURGERY_ORGAN_REPAIR)
			I.rejuvenate()

	target.pain.recalculate_pain()

/datum/surgery_step/internal/fix_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.display_name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, getting mess and tearing the inside of [target]'s [affected.display_name] with \the [tool]!"))
	log_interact(user, target, "[key_name(user)] failed to treat damage to the inside of [key_name(target)]'s [affected.display_name] with \the [tool].")

	var/dam_amt = 2

	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		target.apply_damage(5, TOX)

	else if(istype(tool, /obj/item/stack/medical/bruise_pack))
		dam_amt = 5
		target.apply_damage(10, TOX)
		affected.createwound(CUT, 5)

	for(var/datum/internal_organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			I.take_damage(dam_amt,0)
	target.updatehealth()
	affected.update_wounds()



/datum/surgery_step/internal/fix_organ_robotic //For artificial organs
	allowed_tools = list(
	/obj/item/stack/nanopaste = 100,   \
	/obj/item/tool/surgery/bonegel = 30,     \
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



/datum/surgery_step/internal/detach_organ
	allowed_tools = list()/*
	/obj/item/tool/surgery/scalpel = 100,		\
	/obj/item/tool/kitchen/knife = 75,	\
	/obj/item/shard = 50, 		\
	)*/

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




/datum/surgery_step/internal/remove_organ
	allowed_tools = list()
	/*/obj/item/tool/surgery/hemostat = 100,           \
	/obj/item/tool/wirecutters = 75,         \
	/obj/item/tool/kitchen/utensil/fork = 20
	)*/

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
	var/o_a =  (O.gender == PLURAL) ? ""      : "a "
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
			O.organ_data.transplant_data["species"]    = target.species.name
			O.organ_data.transplant_data["blood_type"] = target.blood_type
		else
			O.organ_data.transplant_data = list()
			O.organ_data.transplant_data["species"]    = transplant_blood.data_properties["species"]
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
