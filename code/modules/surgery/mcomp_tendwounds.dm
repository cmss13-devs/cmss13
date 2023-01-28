/datum/surgery/mcomp_wounds
	name = "Tend Damage (Brute/Burn)"
	possible_locs = list("chest")
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	var/required_trait = TRAIT_YAUTJA_TECH// Only predators can do this

	pain_reduction_required = 0
	steps = list(
		/datum/surgery_step/mstabilize_wounds,
		/datum/surgery_step/mtend_wounds,
		/datum/surgery_step/cauterize/mclamp_wound,
				)
	lying_required = FALSE
	self_operable = TRUE

/datum/surgery/mcomp_wounds/can_start(mob/living/carbon/human/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	if((istype(user) && HAS_TRAIT(user, TRAIT_YAUTJA_TECH)) && (patient.getBruteLoss() || patient.getFireLoss()))
		return TRUE
	return FALSE

//For closing an open incision first.
/datum/surgery/mcomp_wounds/open
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	steps = list(
		/datum/surgery_step/mtend_wounds,
		/datum/surgery_step/cauterize/mclamp_wound,
	)
//------------------------------------

/datum/surgery_step/mstabilize_wounds
	name = "stabilize wounds"
	desc = "stabilize the wounds"
	tools = SURGERY_TOOLS_MEDICOMP_STABILIZE_WOUND
	time = 5 SECONDS

/datum/surgery_step/mstabilize_wounds/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(user == target)
		user.visible_message(SPAN_NOTICE("[user] begins to stabilize wounds on their body with \the [tool]."),
		SPAN_HELPFUL("You begin to stabilize your wounds with \the [tool]."))
	else
		user.affected_message(target,
		SPAN_HELPFUL("You begin to stabilize the wounds on [target]'s body with \the [tool]."),
		SPAN_HELPFUL("[user] begins to stabilize the wounds on your body with \the [tool]."),
		SPAN_NOTICE("[user] begins to stabilize the wounds on [target]'s body with \the [tool]."))

/datum/surgery_step/mstabilize_wounds/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(40,40)

	if(isspeciesyautja(target))
		target.emote("click2")
	else
		target.emote("pain")

	if(user == target)
		user.visible_message(SPAN_NOTICE("[user] finishes stabilizing the wounds on their body with \the [tool]."),
			SPAN_HELPFUL("You finish stabilizing your wounds with \the [tool]."))
	else
		user.affected_message(target,
			SPAN_HELPFUL("You finish stabilizing [target]'s wounds with \the [tool]."),
			SPAN_HELPFUL("[user] finished stabilizing your wounds with \the [tool]."),
			SPAN_NOTICE("[user] finished treating [target]'s wounds with \the [tool]."))

	log_interact(user, target, "[key_name(user)] stabilized some of [key_name(target)]'s wounds with \the [tool].")

/datum/surgery_step/mstabilize_wounds/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to stabilize [key_name(target)]'s wounds with \the [tool], possibly ending [surgery].")
	return FALSE

/datum/surgery_step/mtend_wounds
	name = "Tend Wounds"
	desc = "tend the wounds"
	tools = SURGERY_TOOLS_MEDICOMP_MEND_WOUND
	time = 15 SECONDS

/datum/surgery_step/mtend_wounds/extra_checks(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, repeating, skipped)
	var/obj/item/tool/surgery/healing_gun/gun = tool
	if(!gun.loaded)
		to_chat(user, SPAN_WARNING("You can't heal yourself without a capsule in the gun!"))
		return FALSE
	return TRUE

/datum/surgery_step/mtend_wounds/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	playsound(target,'sound/misc/heal_gun.ogg',25)

	if(user == target)
		user.visible_message(SPAN_NOTICE("[user] begins to treat the stabilized wounds on their body with \the [tool]."),
		SPAN_HELPFUL("You begin to treat your stabilized wounds with \the [tool]."))
	else
		user.affected_message(target,
			SPAN_HELPFUL("You begin to treat the stabilized wounds on [target]'s body with \the [tool]."),
			SPAN_HELPFUL("[user] begins to treat the stabilized wounds on your body with \the [tool]."),
			SPAN_NOTICE("[user] begins to treat the stabilized wounds on [target]'s body with \the [tool]."))

	target.custom_pain("It feels like your body is being stabbed with needles - because it is!")
	log_interact(user, target, "[key_name(user)] began tending wounds on [key_name(target)] with \the [tool], starting [surgery].")

/datum/surgery_step/mtend_wounds/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(65,65)

	if(isspeciesyautja(target))
		target.emote("click")
	else
		target.emote("pain")

	if(user == target)
		user.visible_message(SPAN_NOTICE("[user] finishes treating the stabilized wounds on their body with \the [tool]."),
			SPAN_HELPFUL("You finish treating the stabilized wounds on your body with \the [tool]."))
	else
		user.affected_message(target,
			SPAN_HELPFUL("You finish treating [target]'s stabilized wounds with \the [tool]."),
			SPAN_HELPFUL("[user] finished treating your stabilized wounds with \the [tool]."),
			SPAN_NOTICE("[user] finished treating [target]'s stabilized wounds with \the [tool]."))

	if(!istype(tool, /obj/item/tool/surgery/healing_gun))
		return
	var/obj/item/tool/surgery/healing_gun/gun = tool
	gun.loaded = FALSE

	log_interact(user, target, "[key_name(user)] Treated some of [key_name(target)]'s wounds with \the [tool].")

/datum/surgery_step/mtend_wounds/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to tend [key_name(target)]'s wounds with \the [tool], possibly ending [surgery].")
	return FALSE

/datum/surgery_step/cauterize/mclamp_wound
	name = "Clamp Wounds"
	desc = "clamp the wounds"
	tools = SURGERY_TOOLS_MEDICOMP_CLAMP_WOUND
	time = 10 SECONDS

/datum/surgery_step/cauterize/mclamp_wound/tool_check(mob/user, obj/item/tool, datum/surgery/surgery)
	. = ..()
	if((. in tools_lit) && !tool.heat_source)
		return FALSE

/datum/surgery_step/cauterize/mclamp_wound/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(user == target)
		user.visible_message(SPAN_NOTICE("[user] begins to close the treated wounds on their body with \the [tool]."),
			SPAN_HELPFUL("You begin to close your treated wounds with \the [tool]."))
	else
		user.affected_message(target,
			SPAN_HELPFUL("You begin to close the treated wounds on [target]'s body with \the [tool]."),
			SPAN_HELPFUL("[user] begins to clamp the treated wounds on your body with \the [tool]."),
			SPAN_NOTICE("[user] begns to clamp the treated wounds on [target]'s body with \the [tool]."))

/datum/surgery_step/cauterize/mclamp_wound/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(65,65) //makes sure that all damage is healed

	if(user == target)
		user.visible_message(SPAN_NOTICE("[user] finshes closing the treated wounds on their  body with \the [tool]."),
			SPAN_HELPFUL("You finish closing the treated wounds on your body with \the [tool]"))
	else
		user.affected_message(target,
			SPAN_HELPFUL("You finish closing [target]'s treated wounds with \the [tool]."),
			SPAN_HELPFUL("[user] finished closing your treated wounds with \the [tool]."),
			SPAN_NOTICE("[user] finished closing [target]'s treated wounds with \the [tool]."))

	if(isyautja(target))
		target.emote("loudroar")
	else
		target.emote("pain")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] clamped a wound in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/cauterize/mclamp_wound/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to tend [key_name(target)]'s wounds with \the [tool], possibly ending [surgery].")
	return FALSE
