//////////////////////////////////////////////////////////////////
// INTERNAL WOUND PATCHING //
//////////////////////////////////////////////////////////////////

/datum/surgery/internal_bleeding
	name = "Internal Bleeding Repair"
	priority = SURGERY_PRIORITY_HIGH
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW, SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	steps = list(/datum/surgery_step/fix_vein)

/datum/surgery/internal_bleeding/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	for(var/datum/wound/W as anything in L.wounds)
		if(W.internal)
			return TRUE
	return FALSE

//------------------------------------

/datum/surgery_step/fix_vein
	name = "Fix Vein"
	desc = "mend the damaged blood vessel"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 5 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/fix_vein/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start patching the damaged vein in [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] starts to patch the damaged vein in your [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] starts to patch the damaged vein in [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

	target.custom_pain("The pain in your [surgery.affected_limb.display_name] is unbearable!", 1)
	log_interact(user, target, "[key_name(user)] began repairing internal bleeding in [key_name(target)]'s [surgery.affected_limb.display_name], beginning [surgery].")

/datum/surgery_step/fix_vein/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.count_niche_stat(STATISTICS_NICHE_SURGERY_IB)
	if(!user.statistic_exempt && ishuman(target))
		user.life_ib_total++

	user.affected_message(target,
		SPAN_NOTICE("You finish repairing [target]'s damaged vein."),
		SPAN_NOTICE("[user] finishes repairing your damaged vein."),
		SPAN_NOTICE("[user] finishes repairing [target]'s damaged vein."))

	for(var/datum/wound/W as anything in surgery.affected_limb.wounds)
		if(W.internal)
			surgery.affected_limb.wounds -= W
			surgery.affected_limb.remove_all_bleeding(FALSE, TRUE)
			surgery.affected_limb.update_damages()

	if(prob(40))
		user.add_blood(target.get_blood_color(), BLOOD_HANDS)
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] successfully repaired internal bleeding in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/fix_vein/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/FixOVein)
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
	log_interact(user, target, "[key_name(user)] failed to repair internal bleeding in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	return FALSE
