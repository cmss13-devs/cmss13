//Procedures in this file: Robotic limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/limb
	can_infect = 0
	var/limb_step

/datum/surgery_step/limb/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(!affected)
		return 0
	if(!(affected.status & LIMB_DESTROYED))
		return 0
	if(affected.parent && (affected.parent.status & LIMB_DESTROYED))//parent limb is destroyed
		return 0
	if(affected.limb_replacement_stage != limb_step)
		return 0
	if(affected.body_part == BODY_FLAG_HEAD) //head has its own steps
		return 0
	return 1

/datum/surgery_step/limb/cut
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,		\
	/obj/item/tool/kitchen/knife = 75,	\
	/obj/item/shard = 50, 		\
	)

	min_duration = SCALPEL_MIN_DURATION
	max_duration = SCALPEL_MAX_DURATION
	limb_step = 0

/datum/surgery_step/limb/cut/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts cutting away flesh where [target]'s [affected.display_name] used to be with \the [tool]."), \
	SPAN_NOTICE("You start cutting away flesh where [target]'s [affected.display_name] used to be with \the [tool]."))
	..()

/datum/surgery_step/limb/cut/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] cuts away flesh where [target]'s [affected.display_name] used to be with \the [tool]."),	\
	SPAN_NOTICE("You cut away flesh where [target]'s [affected.display_name] used to be with \the [tool]."))
	affected.limb_replacement_stage = 1

/datum/surgery_step/limb/cut/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(SPAN_WARNING("[user]'s hand slips, cutting [target]'s [affected.display_name] open!"), \
		SPAN_WARNING("Your hand slips, cutting [target]'s [affected.display_name] open!"))
		affected.createwound(CUT, 10)
		affected.update_wounds()



/datum/surgery_step/limb/mend
	allowed_tools = list(
	/obj/item/tool/surgery/retractor = 100,          \
	/obj/item/tool/crowbar = 75,             \
	/obj/item/tool/kitchen/utensil/fork = 50
	)

	min_duration = RETRACTOR_MIN_DURATION
	max_duration = RETRACTOR_MAX_DURATION
	limb_step = 1

/datum/surgery_step/limb/mend/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] is beginning to reposition flesh and nerve endings where where [target]'s [affected.display_name] used to be with [tool]."), \
	SPAN_NOTICE("You start repositioning flesh and nerve endings where [target]'s [affected.display_name] used to be with [tool]."))
	..()

/datum/surgery_step/limb/mend/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has finished repositioning flesh and nerve endings where [target]'s [affected.display_name] used to be with [tool]."),	\
	SPAN_NOTICE("You have finished repositioning flesh and nerve endings where [target]'s [affected.display_name] used to be with [tool]."))
	affected.limb_replacement_stage = 2

/datum/surgery_step/limb/mend/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing flesh on [target]'s [affected.display_name]!"), \
		SPAN_WARNING("Your hand slips, tearing flesh on [target]'s [affected.display_name]!"))
		target.apply_damage(10, BRUTE, affected, sharp = 1)
		target.updatehealth()



/datum/surgery_step/limb/prepare
	allowed_tools = list(
    /obj/item/tool/surgery/cautery = 100,         \
    /obj/item/clothing/mask/cigarette = 75,    \
    /obj/item/tool/lighter = 50,    \
    /obj/item/tool/weldingtool = 50
    )

	min_duration = CAUTERY_MIN_DURATION
	max_duration = CAUTERY_MAX_DURATION
	limb_step = 2

/datum/surgery_step/limb/prepare/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts adjusting the area around [target]'s [affected.display_name] with \the [tool]."), \
	SPAN_NOTICE("You start adjusting the area around [target]'s [affected.display_name] with \the [tool]."))
	..()

/datum/surgery_step/limb/prepare/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has finished adjusting the area around [target]'s [affected.display_name] with \the [tool]."),	\
	SPAN_NOTICE("You have finished adjusting the area around [target]'s [affected.display_name] with \the [tool]."))
	affected.status |= LIMB_AMPUTATED
	affected.setAmputatedTree()
	affected.limb_replacement_stage = 0

/datum/surgery_step/limb/prepare/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(SPAN_WARNING("[user]'s hand slips, searing [target]'s [affected.display_name]!"), \
		SPAN_WARNING("Your hand slips, searing [target]'s [affected.display_name]!"))
		target.apply_damage(10, BURN, affected)
		target.updatehealth()



/datum/surgery_step/limb/attach
	allowed_tools = list(/obj/item/robot_parts = 100)

	min_duration = IMPLANT_MIN_DURATION
	max_duration = IMPLANT_MAX_DURATION
	limb_step = 0

/datum/surgery_step/limb/attach/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	if(..())
		var/obj/item/robot_parts/p = tool
		if(p.part)
			if(!(target_zone in p.part))
				return 0
		return affected.status & LIMB_AMPUTATED

/datum/surgery_step/limb/attach/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts attaching \the [tool] where [target]'s [affected.display_name] used to be."), \
	SPAN_NOTICE("You start attaching \the [tool] where [target]'s [affected.display_name] used to be."))

/datum/surgery_step/limb/attach/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has attached \the [tool] where [target]'s [affected.display_name] used to be."),	\
	SPAN_NOTICE("You have attached \the [tool] where [target]'s [affected.display_name] used to be."))

	//Update our dear victim to have a limb again
	affected.robotize()

	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

	//Deal with the limb item properly
	user.temp_drop_inv_item(tool)
	qdel(tool)

/datum/surgery_step/limb/attach/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging connectors on [target]'s [affected.display_name]!"), \
	SPAN_WARNING("Your hand slips, damaging connectors on [target]'s [affected.display_name]!"))
	target.apply_damage(10, BRUTE, affected, sharp = 1)
	target.updatehealth()
