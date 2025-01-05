//Procedures in this file: Fracture repair surgery
//Steps will only work in a surgery of /datum/surgery/bone_repair or a child of that due to affected_bone var.
//////////////////////////////////////////////////////////////////
// BONE SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/bone_repair
	name = "Bone Repair Surgery"
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	steps = list(
		/datum/surgery_step/mend_bones,
		/datum/surgery_step/set_bones,
	)
	var/affected_bone //Used for messaging.

/datum/surgery/bone_repair/New(surgery_target, surgery_location, surgery_limb)
	..()
	if(affected_limb)
		switch(affected_limb.name)
			if("chest")
				affected_bone = "ribs"
			if("head")
				affected_bone = "skull"
			if("groin")
				affected_bone = "pelvis"

/datum/surgery/bone_repair/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return L.status & LIMB_BROKEN

//------------------------------------

/datum/surgery_step/mend_bones
	name = "Mend Broken Bones"
	desc = "repair the fractured bones"
	tools = SURGERY_TOOLS_BONE_MEND
	time = 3 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/bandage.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

//Use materials to repair bones, same as /datum/surgery_step/mend_encased
/datum/surgery_step/mend_bones/extra_checks(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, repeating, skipped)
	. = ..()
	if(istype(tool, /obj/item/tool/surgery/bonegel)) //If bone gel, use some of the gel
		var/obj/item/tool/surgery/bonegel/gel = tool
		if(!gel.use_gel(gel.fracture_fix_cost))
			to_chat(user, SPAN_BOLDWARNING("[gel] is empty!"))
			return FALSE

	else //Otherwise, use metal rods
		var/obj/item/stack/rods/rods = user.get_inactive_hand()
		if(!istype(rods))
			to_chat(user, SPAN_BOLDWARNING("You need metal rods in your offhand to repair [target]'s [surgery.affected_limb.display_name] with [tool]."))
			return FALSE
		if(!rods.use(2)) //Refunded on failure
			to_chat(user, SPAN_BOLDWARNING("You need more metal rods to mend [target]'s [surgery.affected_limb.display_name] with [tool]."))
			return FALSE

/datum/surgery_step/mend_bones/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	if(surgery.affected_bone)
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("You start applying \the [tool] to [target]'s broken [surgery.affected_bone]."),
				SPAN_NOTICE("[user] starts to apply \the [tool] to your broken [surgery.affected_bone]."),
				SPAN_NOTICE("[user] starts to apply \the [tool] to [target]'s broken [surgery.affected_bone]."))

			target.custom_pain("Something stings inside your [surgery.affected_limb.display_name]!", 1)
		else
			user.affected_message(target,
				SPAN_NOTICE("You begin driving reinforcing pins into [target]'s [surgery.affected_bone] with \the [tool]."),
				SPAN_NOTICE("[user] begins to drive reinforcing pins into your [surgery.affected_bone] with \the [tool]."),
				SPAN_NOTICE("[user] begins to drive reinforcing pins into [target]'s [surgery.affected_bone] with \the [tool]."))

			target.custom_pain("You can feel something grinding in your [surgery.affected_bone]!", 1)
			playsound(target.loc, 'sound/items/Screwdriver.ogg', 25, TRUE)
	else
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("You start applying \the [tool] to the broken bones in [target]'s [surgery.affected_limb.display_name]."),
				SPAN_NOTICE("[user] starts to apply \the [tool] to the broken bones in your [surgery.affected_limb.display_name]."),
				SPAN_NOTICE("[user] starts to apply \the [tool] to the broken bones in [target]'s [surgery.affected_limb.display_name]."))

			target.custom_pain("Something stings inside your [surgery.affected_limb.display_name]!", 1)
		else
			user.affected_message(target,
				SPAN_NOTICE("You begin driving reinforcing pins into the broken bones in [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
				SPAN_NOTICE("[user] begins to drive reinforcing pins into the broken bones in your [surgery.affected_limb.display_name] with \the [tool]."),
				SPAN_NOTICE("[user] begins to drive reinforcing pins into the broken bones in [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

			target.custom_pain("You can feel something grinding in your [surgery.affected_limb.display_name]'s bones!", 1)

	log_interact(user, target, "[key_name(user)] attempted to begin repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/mend_bones/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	var/improvised_desc = pick("an organlegger", "a DIY enthusiast", "a cryo-preserved 20th Century witch-doctor", "an escaped chimpanzee")

	if(surgery.affected_bone)
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("You slather \the [tool] on [target]'s broken [surgery.affected_bone]."),
				SPAN_NOTICE("[user] slathers \the [tool] on your broken [surgery.affected_bone]."),
				SPAN_NOTICE("[user] slathers \the [tool] on [target]'s broken [surgery.affected_bone]."))
		else
			user.affected_message(target,
				SPAN_NOTICE("You crudely reinforce [target]'s [surgery.affected_bone] like [improvised_desc]."),
				SPAN_NOTICE("[user] crudely reinforces your [surgery.affected_bone] like [improvised_desc]."),
				SPAN_NOTICE("[user] crudely reinforces [target]'s [surgery.affected_bone] like [improvised_desc]."))
	else
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("You slather \the [tool] on the broken bones in [target]'s [surgery.affected_limb.display_name]."),
				SPAN_NOTICE("[user] slathers \the [tool] on the broken bones in your [surgery.affected_limb.display_name]."),
				SPAN_NOTICE("[user] slathers \the [tool] on the broken bones in [target]'s [surgery.affected_limb.display_name]."))
			user.update_inv_l_hand()
			user.update_inv_r_hand()
		else
			user.affected_message(target,
				SPAN_NOTICE("You crudely reinforce the bones in [target]'s [surgery.affected_limb.display_name] like [improvised_desc]."),
				SPAN_NOTICE("[user] crudely reinforces the bones in your [surgery.affected_limb.display_name] like [improvised_desc]."),
				SPAN_NOTICE("[user] crudely reinforces the bones in [target]'s [surgery.affected_limb.display_name] like [improvised_desc]."))

	log_interact(user, target, "[key_name(user)] successfully began repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], starting [surgery].")

/datum/surgery_step/mend_bones/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging [target]'s [surgery.affected_bone] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging your [surgery.affected_bone] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging [target]'s [surgery.affected_bone] even more!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging the bones in [target]'s [surgery.affected_limb.display_name] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging the bones in your [surgery.affected_limb.display_name] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging the bones in [target]'s [surgery.affected_limb.display_name] even more!"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to begin repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], aborting [surgery].")

	if(tool_type != /obj/item/tool/surgery/bonegel)
		to_chat(user, SPAN_NOTICE("The metal rods used on [target]'s [surgery.affected_limb.display_name] fall loose from their [surgery.affected_limb]."))
		var/obj/item/stack/rods/rods = new /obj/item/stack/rods(get_turf(target))
		rods.amount = 2 //Refund 2 rods on failure
		rods.update_icon()

	return FALSE

//------------------------------------

/datum/surgery_step/set_bones
	name = "Set Bones"
	desc = "set the bones"
	tools = list(
		/obj/item/tool/surgery/bonesetter = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/wrench = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/maintenance_jack = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
	)
	time = 4 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/effects/bone_break6.ogg'
	failure_sound = 'sound/effects/bone_break1.ogg'

/datum/surgery_step/set_bones/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	switch(surgery.affected_limb.name) //Yet another set of different messages because I just have to be Like This.
		if("head")
			user.affected_message(target,
				SPAN_NOTICE("You begin to piece [target]'s skull together with \the [tool]."),
				SPAN_NOTICE("[user] begins to piece your skull together with \the [tool]."),
				SPAN_NOTICE("[user] begins to piece [target]'s skull together with \the [tool]."))
		if("chest")
			user.affected_message(target,
				SPAN_NOTICE("You begin to set [target]'s broken ribs with \the [tool]."),
				SPAN_NOTICE("[user] begins to set your broken ribs with \the [tool]."),
				SPAN_NOTICE("[user] begins to set [target]'s broken ribs with \the [tool]."))
		if("groin")
			user.affected_message(target,
				SPAN_NOTICE("You begin to set [target]'s fractured pelvis with \the [tool]."),
				SPAN_NOTICE("[user] begins to set your fractured pelvis with \the [tool]."),
				SPAN_NOTICE("[user] begins to set [target]'s fractured pelvis with \the [tool]."))
		else
			user.affected_message(target,
				SPAN_NOTICE("You begin to set the broken bones in [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
				SPAN_NOTICE("[user] begins to set the broken bones in your [surgery.affected_limb.display_name] with \the [tool]."),
				SPAN_NOTICE("[user] begins to set the broken bones in [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

	target.custom_pain("The pain in your [surgery.affected_limb.display_name] is going to make you pass out!", 1)
	log_interact(user, target, "[key_name(user)] attempted to begin setting bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/set_bones/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_NOTICE("You set [target]'s [surgery.affected_bone]."),
			SPAN_NOTICE("[user] sets your [surgery.affected_bone]."),
			SPAN_NOTICE("[user] sets [target]'s [surgery.affected_bone]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You set the bones in [target]'s [surgery.affected_limb.display_name]."),
			SPAN_NOTICE("[user] sets the bones in your [surgery.affected_limb.display_name]."),
			SPAN_NOTICE("[user] sets the bones in [target]'s [surgery.affected_limb.display_name]."))

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_BONES)
	if(surgery.affected_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)
		new /obj/item/stack/medical/splint/nano(get_turf(target), 1)
	surgery.affected_limb.status &= ~(LIMB_SPLINTED|LIMB_SPLINTED_INDESTRUCTIBLE|LIMB_BROKEN)
	surgery.affected_limb.perma_injury = 0
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] successfully set bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/set_bones/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging [target]'s [surgery.affected_bone] with \the [tool]!"),
			SPAN_WARNING("[user]'s hand slips, damaging your [surgery.affected_bone] with \the [tool]!"),
			SPAN_WARNING("[user]'s hand slips, damaging [target]'s [surgery.affected_bone] with \the [tool]!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging the bones in [target]'s [surgery.affected_limb.display_name] with \the [tool]!"),
			SPAN_WARNING("[user]'s hand slips, damaging the bones in your [surgery.affected_limb.display_name] with \the [tool]!"),
			SPAN_WARNING("[user]'s hand slips, damaging the bones in [target]'s [surgery.affected_limb.display_name] with \the [tool]!"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to set bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE
