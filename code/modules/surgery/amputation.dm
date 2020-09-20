


/datum/surgery_step/cut_limb
	can_infect = 1
	allowed_tools = list(
    /obj/item/tool/surgery/circular_saw = 100, \
    /obj/item/tool/hatchet = 75, \
    /obj/item/weapon/melee/claymore/mercsword/machete = 75, \
    /obj/item/weapon/melee/twohanded/fireaxe = 60  
    )

	min_duration = AMPUTATION_MIN_DURATION
	max_duration = AMPUTATION_MAX_DURATION

/datum/surgery_step/cut_limb/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(!affected)
		return 0
	if(affected.status & LIMB_DESTROYED) //already missing
		return 0
	if(affected.surgery_open_stage) //avoids conflict with sawing skull open
		return 0
	if(target_zone == "chest" || target_zone == "groin" || target_zone == "head" || target_zone == "eyes" || target_zone == "mouth") //can't amputate the chest
		return 0
	return 1

/datum/surgery_step/cut_limb/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] is beginning to cut off [target]'s [affected.display_name] with \the [tool].") , \
	SPAN_NOTICE("You are beginning to cut off [target]'s [affected.display_name] with \the [tool]."))
	target.custom_pain("Your [affected.display_name] is being ripped apart!", 1)
	..()

/datum/surgery_step/cut_limb/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] cuts off [target]'s [affected.display_name] with \the [tool]."), \
	SPAN_NOTICE("You cut off [target]'s [affected.display_name] with \the [tool]."))
	user.count_niche_stat(STATISTICS_NICHE_SURGERY_AMPUTATE)
	affected.droplimb(1, 0, "amputation")
	target.updatehealth()

/datum/surgery_step/generic/cut_limb/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, sawing through the bone in [target]'s [affected.display_name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, sawing through the bone in [target]'s [affected.display_name] with \the [tool]!"))
	affected.createwound(CUT, 30)
	affected.fracture()
	affected.update_wounds()