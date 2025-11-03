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
	desc = "восстановить раздробленные кости"
	tools = SURGERY_TOOLS_BONE_MEND
	time = 3 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/bandage.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

//Use materials to repair bones, same as /datum/surgery_step/mend_encased
/datum/surgery_step/mend_bones/extra_checks(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, repeating, skipped)
	. = ..()
	var/ru_name_affected_limb = declent_ru_initial(surgery.affected_limb.display_name, PREPOSITIONAL, surgery.affected_limb.display_name) // SS220 EDIT ADDICTION
	var/ru_name_tool = tool.declent_ru() // SS220 EDIT ADDICTION
	if(istype(tool, /obj/item/tool/surgery/bonegel)) //If bone gel, use some of the gel
		var/obj/item/tool/surgery/bonegel/gel = tool
		if(!gel.use_gel(gel.fracture_fix_cost))
			to_chat(user, SPAN_BOLDWARNING("[gel] is empty!"))
			return FALSE
	else //Otherwise, use metal rods
		var/obj/item/stack/rods/rods = user.get_inactive_hand()
		if(!istype(rods))
			to_chat(user, SPAN_BOLDWARNING("У вас должны быть металлические прутья, чтобы починить [ru_name_affected_limb] [target], используя [ru_name_tool].")) // SS220 EDIT ADDICTION
			return FALSE
		if(!rods.use(2)) //Refunded on failure
			to_chat(user, SPAN_BOLDWARNING("У вас должно быть больше металлических прутьев, чтобы починить [ru_name_affected_limb] [target], используя [ru_name_tool].")) // SS220 EDIT ADDICTION
			return FALSE

/datum/surgery_step/mend_bones/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	var/ru_name_affected_limb = declent_ru_initial(surgery.affected_limb.display_name, PREPOSITIONAL, surgery.affected_limb.display_name) // SS220 EDIT ADDICTION
	var/ru_name_tool = tool.declent_ru() // SS220 EDIT ADDICTION
	if(surgery.affected_bone)
		var/ru_name_affected_bone = declent_ru_initial(surgery.affected_bone, GENITIVE, surgery.affected_bone) // SS220 EDIT ADDICTION
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("Вы начинаете наносить гель на [ru_name_affected_bone] [target], используя [ru_name_tool]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] начинает наносить гель на вашу [ru_name_affected_bone], используя [ru_name_tool]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] начинает наносить гель на [ru_name_affected_bone] [target], используя [ru_name_tool].")) // SS220 EDIT ADDICTION

			target.custom_pain("Вы чувствуете, как что-то жжёт внутри вашей [ru_name_affected_bone]!", 1)
		else
			user.affected_message(target,
				SPAN_NOTICE("Вы начинаете вкручивать металлические штифты в сломанные кости на [ru_name_affected_bone] [target], используя [ru_name_tool]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] начинает вкручивать металлические штифты в сломанные кости на вашей [ru_name_affected_bone], используя [ru_name_tool]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] начинает вкручивать металлические штифты в сломанные кости на [ru_name_affected_bone] [target], используя [ru_name_tool].")) // SS220 EDIT ADDICTION

			target.custom_pain("Вы чувствуете, как что-то закручивается внутрь вашей [ru_name_affected_bone]!", 1)
			playsound(target.loc, 'sound/items/Screwdriver.ogg', 25, TRUE)
	else
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("Вы начинаете наносить гель на [ru_name_affected_limb] [target], используя [ru_name_tool]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] начинает наносить гель на вашу [ru_name_affected_limb], используя [ru_name_tool]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] начинает наносить гель на [ru_name_affected_limb] [target], используя [ru_name_tool].")) // SS220 EDIT ADDICTION

			target.custom_pain("Вы чувствуете, как что-то жжёт внутри вашей [ru_name_affected_limb]!", 1) // SS220 EDIT ADDICTION
		else
			user.affected_message(target,
				SPAN_NOTICE("Вы начинаете вкручивать металлические штифты в сломанные кости на [ru_name_affected_limb] [target], используя [ru_name_tool]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] начинает вкручивать металлические штифты в сломанные кости на вашей [ru_name_affected_limb], используя [ru_name_tool]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] начинает вкручивать металлические штифты в сломанные кости на [ru_name_affected_limb] [target], используя [ru_name_tool].")) // SS220 EDIT ADDICTION

			target.custom_pain("Вы чувствуете, как что-то закручивается внутрь вашей [ru_name_affected_limb]!", 1)

	log_interact(user, target, "[key_name(user)] attempted to begin repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/mend_bones/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	var/ru_name_affected_limb = declent_ru_initial(surgery.affected_limb.display_name, ACCUSATIVE, surgery.affected_limb.display_name) // SS220 EDIT ADDICTION
	var/ru_name_tool = tool.declent_ru() // SS220 EDIT ADDICTION
	var/improvised_desc = pick("костоправ", "медик-самоучка", "доктор-шаман", "сумасшедшая обезьяна")

	if(surgery.affected_bone)
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("Вы наносите гель на [ru_name_affected_limb] [target], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] наносит гель на вашу [ru_name_affected_limb], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] наносит гель на [ru_name_affected_limb] [target], используя [ru_name_tool]."))
		else
			user.affected_message(target,
				SPAN_NOTICE("Вы наспех укрепляете кости [ru_name_affected_limb] [target], словно какой-то [improvised_desc]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] наспех укрепляет кости вашей [ru_name_affected_limb], словно какой-то [improvised_desc]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] наспех укрепляет кости [ru_name_affected_limb] [target], словно какой-то [improvised_desc].")) // SS220 EDIT ADDICTION
	else
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("Вы наносите гель на [ru_name_affected_limb] [target], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] наносит гель на вашу [ru_name_affected_limb], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] наносит гель на [ru_name_affected_limb] [target], используя [ru_name_tool]."))
			user.update_inv_l_hand()
			user.update_inv_r_hand()
		else
			user.affected_message(target,
				SPAN_NOTICE("Вы наспех укрепляете кости [ru_name_affected_limb] [target], словно какой-то [improvised_desc]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] наспех укрепляет кости вашей [ru_name_affected_limb], словно какой-то [improvised_desc]."), // SS220 EDIT ADDICTION
				SPAN_NOTICE("[user] наспех укрепляет кости [ru_name_affected_limb] [target], словно какой-то [improvised_desc].")) // SS220 EDIT ADDICTION

	log_interact(user, target, "[key_name(user)] successfully began repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], starting [surgery].")

/datum/surgery_step/mend_bones/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	var/ru_name_affected_limb = declent_ru_initial(surgery.affected_limb.display_name, PREPOSITIONAL, surgery.affected_limb.display_name) // SS220 EDIT ADDICTION
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_WARNING("Ваша рука дёргается, ещё больше повреждая [ru_name_affected_limb] [target]!"),
			SPAN_WARNING("Рука [user] дёргается, ещё больше повреждая вашу [ru_name_affected_limb]!"),
			SPAN_WARNING("Рука [user] дёргается, ещё больше повреждая [ru_name_affected_limb] [target]!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Ваша рука дёргается, ещё больше повреждая [ru_name_affected_limb] [target]!"),
			SPAN_WARNING("Рука [user] дёргается, ещё больше повреждая вашу [ru_name_affected_limb]!"),
			SPAN_WARNING("Рука [user] дёргается, ещё больше повреждая [ru_name_affected_limb] [target]!"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to begin repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], aborting [surgery].")

	if(tool_type != /obj/item/tool/surgery/bonegel)
		to_chat(user, SPAN_NOTICE("Металлические прутья, использованные на [ru_name_affected_limb] [target], отваливаются."))
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
	var/ru_name_affected_limb = declent_ru_initial(surgery.affected_limb.display_name, PREPOSITIONAL, surgery.affected_limb.display_name) // SS220 EDIT ADDICTION
	var/ru_name_tool = tool.declent_ru() // SS220 EDIT ADDICTION
	switch(surgery.affected_limb.name) //Yet another set of different messages because I just have to be Like This.
		if("head")
			user.affected_message(target,
				SPAN_NOTICE("Вы начинаете собирать кусочки черепа [target], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] начинает собирать кусочки вашего черепа, используя [ru_name_tool]."),
				SPAN_NOTICE("[user] начинает собирать кусочки черепа [target], используя [ru_name_tool]."))
		if("chest")
			user.affected_message(target,
				SPAN_NOTICE("Вы начинаете вправлять сломанные рёбра [target], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] начинает вправлять ваши сломанные рёбра, используя [ru_name_tool]."),
				SPAN_NOTICE("[user] начинает вправлять сломанные рёбра [target], используя [ru_name_tool]."))
		if("groin")
			user.affected_message(target,
				SPAN_NOTICE("Вы начинаете вправлять сломанный таз [target], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] начинает вправлять ваш сломанный таз, используя [ru_name_tool]."),
				SPAN_NOTICE("[user] начинает вправлять сломанный таз [target], используя [ru_name_tool]."))
		else
			user.affected_message(target,
				SPAN_NOTICE("Вы начинаете вправлять сломанные кости [ru_name_affected_limb] [target], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] начинает вправлять сломанные кости в вашей [ru_name_affected_limb], используя [ru_name_tool]."),
				SPAN_NOTICE("[user] начинает вправлять сломанные кости [ru_name_affected_limb] [target], используя [ru_name_tool]."))

	target.custom_pain("Вы вот-вот потеряете сознание от боли в вашей [ru_name_affected_limb]!", 1)
	log_interact(user, target, "[key_name(user)] attempted to begin setting bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/set_bones/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	var/ru_name_affected_limb = declent_ru_initial(surgery.affected_limb.display_name, PREPOSITIONAL, surgery.affected_limb.display_name) // SS220 EDIT ADDICTION
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_NOTICE("Вы вправляете [ru_name_affected_limb] [target]."),
			SPAN_NOTICE("[user] вправляет вашу [ru_name_affected_limb]."),
			SPAN_NOTICE("[user] вправляет [ru_name_affected_limb] [target]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("Вы вправляете [ru_name_affected_limb] [target]."),
			SPAN_NOTICE("[user] вправляет вашу [ru_name_affected_limb]."),
			SPAN_NOTICE("[user] вправляет [ru_name_affected_limb] [target]."))

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_BONES)
	if(surgery.affected_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)
		new /obj/item/stack/medical/splint/nano(get_turf(target), 1)
	surgery.affected_limb.status &= ~(LIMB_SPLINTED|LIMB_SPLINTED_INDESTRUCTIBLE|LIMB_BROKEN)
	surgery.affected_limb.perma_injury = 0
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] successfully set bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/set_bones/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	var/ru_name_affected_limb = declent_ru_initial(surgery.affected_limb.display_name, ACCUSATIVE, surgery.affected_limb.display_name) // SS220 EDIT ADDICTION
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_WARNING("Ваша рука дёргается, ещё больше повреждая [ru_name_affected_limb] [target]!"),
			SPAN_WARNING("Рука [user] дёргается, ещё больше повреждая вашу [ru_name_affected_limb]!"),
			SPAN_WARNING("Рука [user] дёргается, ещё больше повреждая [ru_name_affected_limb] [target]!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Ваша рука дёргается, ещё больше повреждая [ru_name_affected_limb] [target]!"),
			SPAN_WARNING("Рука [user] дёргается, ещё больше повреждая вашу [ru_name_affected_limb]!"),
			SPAN_WARNING("Рука [user] дёргается, ещё больше повреждая [ru_name_affected_limb] [target]!"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to set bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE
