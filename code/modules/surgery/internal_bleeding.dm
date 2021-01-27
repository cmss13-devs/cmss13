//Procedures in this file: Inernal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////


/datum/surgery_step/fix_vein
	allowed_tools = list(
	/obj/item/tool/surgery/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = FIXVEIN_MIN_DURATION
	max_duration = FIXVEIN_MAX_DURATION

/datum/surgery_step/fix_vein/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected, checks_only)
	if(affected.surgery_open_stage >= 2)
		for(var/datum/wound/W in affected.wounds)
			if(W.internal)
				return 1

/datum/surgery_step/fix_vein/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] starts patching the damaged vein in [target]'s [affected.display_name] with \the [tool].") , \
	SPAN_NOTICE("You start patching the damaged vein in [target]'s [affected.display_name] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] started patching the damaged vein in [key_name(target)]'s [affected.display_name] with \the [tool].")

	target.custom_pain("The pain in [affected.display_name] is unbearable!",1)
	..()

/datum/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_NOTICE("[user] has patched the damaged vein in [target]'s [affected.display_name] with \the [tool]."), \
		SPAN_NOTICE("You have patched the damaged vein in [target]'s [affected.display_name] with \the [tool]."))
	log_interact(user, target, "[key_name(user)] patched the damaged vein in [key_name(target)]'s [affected.display_name] with \the [tool].")

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_IB)

	for(var/datum/wound/W in affected.wounds)
		if(W.internal)
			affected.wounds -= W
			affected.remove_all_bleeding(FALSE, TRUE)
			affected.update_damages()
	if(ishuman(user) && prob(40))
		var/mob/living/carbon/human/H = user
		H.add_blood(target.get_blood_color(), BLOOD_HANDS)

	target.pain.recalculate_pain()

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, obj/limb/affected)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!") , \
	SPAN_WARNING("Your hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!"))
	log_interact(user, target, "[key_name(user)] failed to patch the damaged vein in [key_name(target)]'s [affected.display_name] with \the [tool].")

	affected.take_damage(5, 0)
	target.updatehealth()
