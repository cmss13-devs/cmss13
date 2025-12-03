//Procedures in this file: brain damage surgery.
//////////////////////////////////////////////////////////////////
// BRAIN DAMAGE FIXING //
//////////////////////////////////////////////////////////////////

/datum/surgery/brain_repair
	name = "Brain Repair Surgery"
	possible_locs = list("head")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_MEDIUM //Brain doesn't actually have much in the way of nerve endings.
	steps = list(/datum/surgery_step/remove_bone_chips)
	var/dmg_min = 0
	var/dmg_max = BONECHIPS_MAX_DAMAGE

/datum/surgery/brain_repair/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	var/datum/internal_organ/brain/B = patient.internal_organs_by_name["brain"]
	if(!B || B.damage <= dmg_min || B.robotic == ORGAN_ROBOT)
		return FALSE
	if(dmg_max && B.damage > dmg_max)
		return FALSE
	return TRUE

/datum/surgery/brain_repair/heavy //Serious brain damage requires a serious surgery.
	dmg_min = BONECHIPS_MAX_DAMAGE
	dmg_max = FALSE
	steps = list(
		/datum/surgery_step/treat_hematoma,
		/datum/surgery_step/remove_bone_chips,
	)

//------------------------------------

/datum/surgery_step/remove_bone_chips
	name = "Remove Embedded Bone Chips"
	desc = "remove broken bone fragments from the skull"
	tools = SURGERY_TOOLS_PINCH
	time = 5 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/remove_bone_chips/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin picking chips of bone out of [target]'s skull with [tool]."),
		SPAN_NOTICE("[user] begins picking chips of bone out of your skull with [tool]."),
		SPAN_NOTICE("[user] begins picking chips of bone out of [target]'s skull with [tool]."))

	target.custom_pain("You feel [user] picking around your brain! Ow, ouch, owie!", 1)
	log_interact(user, target, "[key_name(user)] started taking bone chips out of [key_name(target)]'s skull with [tool], possibly beginning [surgery].")

/datum/surgery_step/remove_bone_chips/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)

	new /obj/item/shard/shrapnel/bone_chips/human(target) //adds bone chips
	user.affected_message(target, //fixes brain damage
		SPAN_NOTICE("You finish extracting sharp pieces of bone that were piercing [target]'s brain."),
		SPAN_NOTICE("[user] finishes extracting sharp pieces of bone that were piercing your brain."),
		SPAN_NOTICE("[user] finishes extracting sharp pieces of bone that were piercing [target]'s brain."))

	if(target.disabilities &= NERVOUS) //rattlerattlerattlerattlerattle AAAAA MAKE IT STOP!
		user.affected_message(target,
			SPAN_NOTICE("After [target] insisted something was still there, you pull out some extra, tiny, loose pieces of bone that were rattling around in \his skull."),
			SPAN_NOTICE("After you insisted something was still there, [user] pulls out some extra, tiny, loose pieces of bone that were rattling around in your skull."),
			SPAN_NOTICE("[user] pulls out some extra, tiny, loose pieces of bone that were rattling around in [target]'s skull."))
	if(target.sdisabilities &= DISABILITY_DEAF) //o shid, I can hear now?
		user.affected_message(target,
			SPAN_NOTICE("You finish extracting fragments of bone that were piercing [target]'s auditory cortex and causing severe tinnitus."),
			SPAN_NOTICE("[user] finishes extracting fragments of bone that were piercing your auditory cortex and causing severe tinnitus."),
			SPAN_NOTICE("[user] finishes extracting fragments of that were piercing [target]'s auditory cortex and causing severe tinnitus."))

	if(target.sdisabilities &= DISABILITY_MUTE) ////My self esteem emphatically dramatically improved since I was dumb!
		user.affected_message(target,
			SPAN_NOTICE("You finish extracting fragments of bone that were piercing [target]'s Broca's and Wernicke's area and prevented speech."),
			SPAN_NOTICE("[user] finishes extracting fragments of bone that were piercing your Broca's and Wernicke's area and prevented speech."),
			SPAN_NOTICE("[user] finishes extracting fragments of bone that were piercing [target]'s Broca's and Wernicke's area and prevented speech."))
	user.count_niche_stat(STATISTICS_NICHE_SURGERY_BRAIN)

	var/datum/internal_organ/brain/B = target.internal_organs_by_name["brain"]
	if(B)
		B.heal_damage(B.damage)

	to_chat(target, SPAN_NOTICE("The rattling and piercing feelings in your brain cease. Your mind and ears feel more clear."))

	var/obj/item/shard/shrapnel/bone_chips/human/C = locate() in target
	if(C)
		C.forceMove(user.loc)
	target.disabilities &= ~NERVOUS
	target.sdisabilities &= ~DISABILITY_DEAF
	target.sdisabilities &= ~DISABILITY_MUTE
	target.jitteriness = 0
	target.pain.recalculate_pain()

	log_interact(user, target, "[key_name(user)] finished taking bone chips out of [key_name(target)]'s brain with [tool], finishing [surgery].")

/datum/surgery_step/remove_bone_chips/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, tearing a blood vessel in [target]'s [surgery.affected_limb.display_name] with [tool], causing internal bleeding!"),
		SPAN_WARNING("[user]'s hand slips, tearing a blood vessel in your [surgery.affected_limb.display_name] with [tool], causing internal bleeding!"),
		SPAN_WARNING("[user]'s hand slips, tearing a blood vessel in [target]'s [surgery.affected_limb.display_name] with [tool], causing internal bleeding!"))

	log_interact(user, target, "[key_name(user)] failed to take the bone chips out of [key_name(target)]'s brain with [tool], possibly aborting [surgery].")

	var/datum/wound/internal_bleeding/I = new (0)
	surgery.affected_limb.add_bleeding(I, TRUE)
	surgery.affected_limb.wounds += I
	target.apply_damage(5, BRUTE, target_zone)
	surgery.affected_limb.add_bleeding(null, FALSE, 15)
	target.custom_pain("You feel something rip in your [surgery.affected_limb.display_name]!", 1)
	return FALSE

//------------------------------------

/datum/surgery_step/treat_hematoma
	name = "Treat Hematoma"
	desc = "mend the hematoma"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 5 SECONDS

	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/surgery/hemostat2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/treat_hematoma/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin mending the hematoma in [target]'s brain with [tool]."),
		SPAN_NOTICE("[user] begins to mend the hematoma in your brain with [tool]."),
		SPAN_NOTICE("[user] begins to mend the hematoma in [target]'s brain with [tool]."))

	target.custom_pain("You can feel [user] messing around with the swelling in your brain, making it pulse painfully!", 1)
	log_interact(user, target, "[key_name(user)] started mending a hematoma in [key_name(target)]'s brain with [tool].")

/datum/surgery_step/treat_hematoma/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish mending the hematoma in [target]'s brain."),
		SPAN_NOTICE("[user] finishes mending the hematoma in your brain."),
		SPAN_NOTICE("[user] finishes mending the hematoma in [target]'s brain."))

	log_interact(user, target, "[key_name(user)] finished mending a hematoma in [key_name(target)]'s brain with [tool], beginning [surgery].")

	var/datum/internal_organ/brain/B = target.internal_organs_by_name["brain"]
	if(B)
		B.damage = BONECHIPS_MAX_DAMAGE

	to_chat(target, SPAN_NOTICE("The agonizing pressure in your skull ceases. Your mind and ears feel more clear, but something's rattling and poking around in your skull still!"))
	target.sdisabilities &= ~DISABILITY_DEAF
	target.sdisabilities &= ~DISABILITY_MUTE
	target.pain.recalculate_pain()

/datum/surgery_step/treat_hematoma/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, bruising [target]'s brain with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, bruising your brain with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s brain with [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to mend the hematoma in [key_name(target)]'s brain with [tool], aborting [surgery].")

	target.apply_damage(15, BRUTE, target_zone)
	return FALSE
