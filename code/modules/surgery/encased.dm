//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/open_encased
	priority = 1
	can_infect = 1
	blood_level = 1
	var/open_case_step

/datum/surgery_step/open_encased/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(affected.status & LIMB_DESTROYED) return 0
	return affected.encased && affected.surgery_open_stage == open_case_step


/datum/surgery_step/open_encased/saw
	allowed_tools = list(
	/obj/item/tool/surgery/circular_saw = 100, \
	/obj/item/tool/hatchet = 75
	)

	min_duration = CIRCULAR_SAW_MIN_DURATION
	max_duration = CIRCULAR_SAW_MAX_DURATION
	open_case_step = 2

/datum/surgery_step/open_encased/saw/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] begins to cut through [target]'s [affected.encased] with \the [tool]."), \
	SPAN_NOTICE("You begin to cut through [target]'s [affected.encased] with \the [tool]."))
	target.custom_pain("Something hurts horribly in your [affected.display_name]!", 1)
	..()

/datum/surgery_step/open_encased/saw/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has cut [target]'s [affected.encased] open with \the [tool]."),		\
	SPAN_NOTICE("You have cut [target]'s [affected.encased] open with \the [tool]."))
	affected.surgery_open_stage = 2.5

/datum/surgery_step/open_encased/saw/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, cracking [target]'s [affected.encased] with \the [tool]!") , \
	SPAN_WARNING("Your hand slips, cracking [target]'s [affected.encased] with \the [tool]!") )

	affected.createwound(CUT, 20)
	affected.fracture()
	affected.update_wounds()


/datum/surgery_step/open_encased/retract
	allowed_tools = list(
	/obj/item/tool/surgery/retractor = 100, \
	/obj/item/tool/crowbar = 75
	)

	min_duration = RETRACTOR_MIN_DURATION
	max_duration = RETRACTOR_MAX_DURATION
	open_case_step = 2.5

/datum/surgery_step/open_encased/retract/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts to force open the [affected.encased] in [target]'s [affected.display_name] with \the [tool]."), \
	SPAN_NOTICE("You start to force open the [affected.encased] in [target]'s [affected.display_name] with \the [tool]."))
	target.custom_pain("Something hurts horribly in your [affected.display_name]!", 1)
	..()

/datum/surgery_step/open_encased/retract/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] forces open [target]'s [affected.encased] with \the [tool]."), \
	SPAN_NOTICE("You force open [target]'s [affected.encased] with \the [tool]."))
	affected.surgery_open_stage = 3

	//Whoops!
	if(prob(10))
		affected.fracture()

/datum/surgery_step/open_encased/retract/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, cracking [target]'s [affected.encased]!"), \
	SPAN_WARNING("Your hand slips, cracking [target]'s  [affected.encased]!"))

	affected.createwound(BRUISE, 20)
	affected.fracture()
	affected.update_wounds()


/datum/surgery_step/open_encased/close
	allowed_tools = list(
	/obj/item/tool/surgery/retractor = 100, \
	/obj/item/tool/crowbar = 75
	)

	min_duration = RETRACTOR_MIN_DURATION
	max_duration = RETRACTOR_MAX_DURATION
	open_case_step = 3

/datum/surgery_step/open_encased/close/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts bending [target]'s [affected.encased] back into place with \the [tool]."), \
	SPAN_NOTICE("You start bending [target]'s [affected.encased] back into place with \the [tool]."))
	target.custom_pain("Something hurts horribly in your [affected.display_name]!", 1)
	..()

/datum/surgery_step/open_encased/close/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] bends [target]'s [affected.encased] back into place with \the [tool]."), \
	SPAN_NOTICE("You bend [target]'s [affected.encased] back into place with \the [tool]."))
	affected.surgery_open_stage = 2.5

/datum/surgery_step/open_encased/close/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, bending [target]'s [affected.encased] the wrong way!"), \
	SPAN_WARNING("Your hand slips, bending [target]'s [affected.encased] the wrong way!"))

	affected.createwound(BRUISE, 20)
	affected.fracture()
	affected.update_wounds()


/datum/surgery_step/open_encased/mend
	allowed_tools = list(
	/obj/item/tool/surgery/bonegel = 100,	\
	/obj/item/tool/screwdriver = 75
	)

	min_duration = BONEGEL_REPAIR_MIN_DURATION
	max_duration = BONEGEL_REPAIR_MAX_DURATION
	open_case_step = 2.5

/datum/surgery_step/open_encased/mend/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts applying \the [tool] to [target]'s [affected.encased]."), \
	SPAN_NOTICE("You start applying \the [tool] to [target]'s [affected.encased]."))
	target.custom_pain("Something hurts horribly in your [affected.display_name]!",1)
	..()

/datum/surgery_step/open_encased/mend/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] applied \the [tool] to [target]'s [affected.encased]."), \
	SPAN_NOTICE("You applied \the [tool] to [target]'s [affected.encased]."))
	affected.surgery_open_stage = 2
