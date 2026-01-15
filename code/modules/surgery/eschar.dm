/datum/surgery/eschar_mend
	name = "Eschar Removal Surgery"
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	steps = list(
		/datum/surgery_step/separate_eschar,
		/datum/surgery_step/graft_exposed_flesh,
	)

/datum/surgery/eschar_mend/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return L.status & LIMB_ESCHAR

/datum/surgery_step/separate_eschar
	name = "Remove the Eschar"
	desc = "remove the eschar"
	tools = SURGERY_TOOLS_INCISION
	time = 2 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/separate_eschar/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to separate the hardened, crusted flesh from [target]'s [surgery.affected_limb.display_name] with [tool]."),
		SPAN_NOTICE("[user] begins to separate the hardened, crusted flesh from your [surgery.affected_limb.display_name] with [tool]."),
		SPAN_NOTICE("[user] begins to separate the hardened, crusted flesh from [target]'s [surgery.affected_limb.display_name] with [tool]."))

	target.custom_pain("[user] is carving your skin up like you're a crispy roast turkey! It hurts!", 1)
	log_interact(user, target, "[key_name(user)] begins to separate the hardened, crusted flesh from [key_name(target)]'s [surgery.affected_limb.display_name] with [tool].")

/datum/surgery_step/separate_eschar/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You have removed the eschar from [target]'s [surgery.affected_limb.display_name] and exposed the pink and healthy tissue beneath it."),
		SPAN_NOTICE("[user] has removed the eschar from your [surgery.affected_limb.display_name] and exposed the pink and healthy tissue beneath it."),
		SPAN_NOTICE("[user] has removed the eschar from [target]'s [surgery.affected_limb.display_name] and exposed the pink and healthy tissue beneath it."))

	to_chat(target, SPAN_NOTICE("The air feels cold around the exposed skin on your [surgery.affected_limb.display_name]."))
	log_interact(user, target, "[key_name(user)] has removed the eschar from [key_name(target)]'s [surgery.affected_limb.display_name] with [tool], starting [surgery].")

/datum/surgery_step/separate_eschar/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, slicing [target]'s [surgery.affected_limb.display_name] with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, slicing your [surgery.affected_limb.display_name] with [tool]!"),
		SPAN_WARNING("[user]'s hand slips, slicing [target]'s [surgery.affected_limb.display_name] with [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to remove the eschar from [key_name(target)]'s [surgery.affected_limb.display_name] with [tool], aborting [surgery].")
	target.apply_damage(10, BRUTE, target_zone)
	return FALSE

/datum/surgery_step/graft_exposed_flesh
	name = "Apply a Graft"
	desc = "graft and seal the exposed flesh"
	tools = list(
		/obj/item/stack/medical/advanced/ointment = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/synthgraft = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/stack/medical/advanced/ointment/predator = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/stack/medical/ointment = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 3 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/bandage.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	var/use_stack = 1 //uses one stack of burn heal stuff.

/datum/surgery_step/graft_exposed_flesh/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	var/toolname

	switch(tool_type)
		if(/obj/item/stack/medical/ointment)
			toolname = "some ointment"
		if(/obj/item/stack/medical/advanced/ointment)
			toolname = "a regenerative membrane"
		if(/obj/item/tool/surgery/synthgraft)
			toolname = "the synthgraft"
		else
			toolname = "the poultice"

	user.affected_message(target,
		SPAN_NOTICE("You begin to apply and seal a graft over the exposed skin on [target]'s [surgery.affected_limb.display_name] with [toolname]."),
		SPAN_NOTICE("[user] begins to apply and seal a graft over the exposed skin on your [surgery.affected_limb.display_name] with [toolname]."),
		SPAN_NOTICE("[user] begins to apply and seal a graft over the exposed skin on [target]'s [surgery.affected_limb.display_name] with [toolname]."))

	target.custom_pain("Your exposed skin feels tender as [user] presses on it! Ouch!", 1)
	log_interact(user, target, "[key_name(user)] begins to apply and seal a graft over the exposed skin on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool].")

/datum/surgery_step/graft_exposed_flesh/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	if(istype(tool, /obj/item/stack/medical)) //uses 1 stack of ointment/burnpack but not synthgraft, very important.
		var/obj/item/stack/medical/packs = tool
		packs.use(use_stack) //use 1 stack, please.

	user.affected_message(target,
		SPAN_NOTICE("You sealed a skin graft over the exposed skin on [target]'s [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] sealed a skin graft over the exposed skin on your [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] sealed a skin graft over the exposed skin on [target]'s [surgery.affected_limb.display_name]."))

	to_chat(target, SPAN_NOTICE("Your skin is covered and safe. You feel better."))
	log_interact(user, target, "[key_name(user)] sealed a skin graft over the exposed skin on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool], ending [surgery].")
	surgery.affected_limb.status &= ~LIMB_ESCHAR
	surgery.affected_limb.heal_damage(0, surgery.affected_limb.burn_healing_threshold)
	target.pain.recalculate_pain()
	return

/datum/surgery_step/graft_exposed_flesh/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eschar_mend/surgery)
	if(tool_type == /obj/item/stack/medical/ointment)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, smearing [tool] over the exposed flesh on [target]'s [surgery.affected_limb.display_name]!"),
			SPAN_WARNING("[user]'s hand slips, smearing [tool] over the exposed flesh on your [surgery.affected_limb.display_name]!"),
			SPAN_WARNING("[user]'s hand slips, smearing [tool] over the exposed flesh on [target]'s [surgery.affected_limb.display_name]!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, bruising the exposed flesh on [target]'s [surgery.affected_limb.display_name] with [tool]!"),
			SPAN_WARNING("[user]'s hand slips, bruising the exposed flesh on your [surgery.affected_limb.display_name] with [tool]!"),
			SPAN_WARNING("[user]'s hand slips, bruising the exposed flesh on [target]'s [surgery.affected_limb.display_name] with [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to seal a graph over the exposed flesh on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool].")
	target.apply_damage(10, BRUTE, target_zone)
	return FALSE


