//Procedures in this file: Opening and closing incisions. Clamping bleeds. Opening and closing ribcage/skull etc., proof of concept do-nothing non-human surgery.

//////////////////////////////////////////////////////////////////
// INCISION SURGERIES //
//////////////////////////////////////////////////////////////////

/datum/surgery/open_incision
	name = "Open Incision"
	priority = SURGERY_PRIORITY_MAXIMUM
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	steps = list(
		/datum/surgery_step/incision,
		/datum/surgery_step/cauterize/abort,
		/datum/surgery_step/suture_incision/abort,
		/datum/surgery_step/clamp_bleeders_step,
		/datum/surgery_step/cauterize/abort,
		/datum/surgery_step/suture_incision/abort,
		/datum/surgery_step/retract_skin,
	)
	lying_required = FALSE
	self_operable = TRUE
	pain_reduction_required = PAIN_REDUCTION_MEDIUM

//------------------------------------

/datum/surgery_step/incision
	name = "Make Incision"
	desc = "make an incision"
	tools = SURGERY_TOOLS_INCISION
	time = 2 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/incision/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/scalpel/manager)
		user.affected_message(target,
			SPAN_NOTICE("You start to construct a prepared incision in [target]'s [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] starts to construct a prepared incision in your [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] starts to construct a prepared incision in [target]'s [surgery.affected_limb.display_name] with [tool]."))

		target.custom_pain("You feel a horrible, searing pain in your [surgery.affected_limb.display_name] as the flesh is pushed apart!", 1)
	else
		user.affected_message(target,
			SPAN_NOTICE("You start to make an incision on [target]'s [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] starts making an incision on your [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] starts making an incision on [target]'s [surgery.affected_limb.display_name] with [tool]."))

		target.custom_pain("You feel a horrible, piercing pain in your [surgery.affected_limb.display_name]!", 1)

	log_interact(user, target, "[key_name(user)] began making an incision in [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/incision/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/obj/item/tool/surgery/scalpel/laser/las_scalpel = tool

	if(tool_type == /obj/item/tool/surgery/scalpel/manager)
		user.affected_message(target,
			SPAN_NOTICE("You have constructed a prepared incision in [target]'s [surgery.affected_limb.display_name] that is now bleeding."),
			SPAN_NOTICE("[user] has constructed a prepared incision in your [surgery.affected_limb.display_name] that is now bleeding."),
			SPAN_NOTICE("[user] has constructed a prepared incision in [target]'s [surgery.affected_limb.display_name] that is now bleeding."))

		surgery.status += 6 //IMS completes all steps.
		surgery.affected_limb.limb_surgery_status |= (INCISION_WIDENED | INCISION_CLAMPED)
		switch(target_zone) //forces application of overlays
			if("chest")
				target.overlays += image('icons/mob/humans/dam_human.dmi', "chest_surgery_closed")
			if("head")
				target.overlays += image('icons/mob/humans/dam_human.dmi', "skull_surgery_closed")

	else if(tool_type == /obj/item/tool/surgery/scalpel/laser && prob(las_scalpel.bloodlessprob))
		user.affected_message(target,
			SPAN_NOTICE("You finish making a bloodless incision on [target]'s [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] finishes making a bloodless incision on your [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] finishes making a bloodless incision on [target]'s [surgery.affected_limb.display_name] with [tool]."))

		surgery.status += 3 //A laser scalpel may cauterise as it cuts.
		surgery.affected_limb.limb_surgery_status |= (INCISION_MADE | INCISION_CLAMPED)
	else
		user.affected_message(target,
			SPAN_NOTICE("You finish the incision on [target]'s [surgery.affected_limb.display_name]."),
			SPAN_NOTICE("[user] finishes the incision on your [surgery.affected_limb.display_name]."),
			SPAN_NOTICE("[user] finishes the incision on [target]'s [surgery.affected_limb.display_name]."))
		surgery.affected_limb.limb_surgery_status |= (INCISION_MADE | INCISION_BLEEDING)

		if(!(surgery.affected_limb.status & LIMB_SYNTHSKIN))
			var/datum/effects/bleeding/external/incision_bleed = new(target, surgery.affected_limb, 10)
			incision_bleed.duration = 10 MINUTES //A weak bleed, but it doesn't stop on its own.
			surgery.affected_limb.bleeding_effects_list += incision_bleed
			surgery.affected_limb.limb_surgery_status |= (INCISION_MADE | INCISION_BLEEDING)
		else
			surgery.status += 3 // synth skin doesn't cause bleeders
		surgery.affected_limb.limb_surgery_status |= (INCISION_MADE | INCISION_CLAMPED)

	var/internal_bleeding_check = FALSE
	for(var/datum/effects/bleeding/internal/ib in surgery.affected_limb.bleeding_effects_list)
		ib = TRUE
		internal_bleeding_check = TRUE
		break

		if(ib == TRUE && internal_bleeding_check == TRUE)
			surgery.affected_limb.limb_surgery_status |= INCISION_INT_BLEEDING

	target.update_surgery_overlays()
	target.incision_depths[target_zone] = SURGERY_DEPTH_SHALLOW //Descriptionwise this is done by the retractor, but putting it here means people can examine to see if an unfinished surgery has been done.
	user.add_blood(target.get_blood_color(), BLOOD_HANDS)
	log_interact(user, target, "[key_name(user)] made an incision in [key_name(target)]'s [surgery.affected_limb.display_name], beginning [surgery].")

/datum/surgery_step/incision/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	switch(tool_type)
		if(/obj/item/tool/surgery/scalpel/manager)
			user.affected_message(target,
				SPAN_WARNING("Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [surgery.affected_limb.display_name] with [tool]!"),
				SPAN_WARNING("[user]'s hand jolts as the system sparks, ripping a gruesome hole in your [surgery.affected_limb.display_name] with [tool]!"),
				SPAN_WARNING("[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [surgery.affected_limb.display_name] with [tool]!"))

			target.apply_damage(15, BRUTE, target_zone)
			target.apply_damage(15, BURN, target_zone)
		if(/obj/item/tool/surgery/scalpel/laser)
			user.affected_message(target,
				SPAN_WARNING("Your hand slips as [tool]'s blade sputters, searing a long gash in [target]'s [surgery.affected_limb.display_name]!"),
				SPAN_WARNING("[user]'s hand slips as [tool]'s blade sputters, searing a long gash in your [surgery.affected_limb.display_name]!"),
				SPAN_WARNING("[user]'s hand slips as [tool]'s blade sputters, searing a long gash in [target]'s [surgery.affected_limb.display_name]!"))

			target.apply_damage(7.5, BRUTE, target_zone)
			target.apply_damage(12.5, BURN, target_zone)
		else
			user.affected_message(target,
				SPAN_WARNING("Your hand slips, slicing [target]'s [surgery.affected_limb.display_name] in the wrong place!"),
				SPAN_WARNING("[user]'s hand slips, slicing your [surgery.affected_limb.display_name] in the wrong place!"),
				SPAN_WARNING("[user]'s hand slips, slicing [target]'s [surgery.affected_limb.display_name] in the wrong place!"))

			target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to make an incision in [key_name(target)]'s [surgery.affected_limb.display_name], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery/clamp_bleeders
	name = "Clamp Bleeders"
	priority = SURGERY_PRIORITY_HIGH
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW, SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	steps = list(/datum/surgery_step/clamp_bleeders_step)
	lying_required = FALSE
	self_operable = TRUE
	pain_reduction_required = PAIN_REDUCTION_MEDIUM

/datum/surgery/clamp_bleeders/can_start(mob/user, mob/living/carbon/patient, obj/limb/patient_limb, obj/item/tool)
	for(var/datum/effects/bleeding/external/bleeding in patient_limb.bleeding_effects_list)
		return TRUE
	return FALSE

//------------------------------------

/datum/surgery_step/clamp_bleeders_step
	name = "Clamp Bleeders"
	desc = "clamp bleeders on the bleeding vessels"
	//Tools used to clamp bleeders by either clamping them shut or tying them shut. Fixovein is a substitute but also a real surgery tool.
	tools = list(
		/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/stack/cable_coil = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
	)
	///Tools used to stem bleeders by specifically tying them up. List used for specific messaging as there's two of these.
	var/ligation_tools = list(/obj/item/stack/cable_coil)
	time = 2 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/clamp_bleeders_step/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE //This step is optional.

/datum/surgery_step/clamp_bleeders_step/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type in ligation_tools)
		user.affected_message(target,
			SPAN_NOTICE("You begin ligating bleeders in [target]'s [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] begins ligating bleeders in your [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] begins ligating bleeders in [target]'s [surgery.affected_limb.display_name] with [tool]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You begin clamping bleeders in [target]'s [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] begins to clamp bleeders in your [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] begins to clamp bleeders in [target]'s [surgery.affected_limb.display_name] with [tool]."))

	target.custom_pain("The pain in your [surgery.affected_limb.display_name] is maddening!", 1)
	log_interact(user, target, "[key_name(user)] began clamping bleeders in [key_name(target)]'s [surgery.affected_limb.display_name], possibly beginning [surgery].")

/datum/surgery_step/clamp_bleeders_step/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type in ligation_tools)
		user.affected_message(target,
			SPAN_NOTICE("You finish ligating bleeders in [target]'s [surgery.affected_limb.display_name], stopping the incision's bleeding."),
			SPAN_NOTICE("[user] finishes ligating bleeders in your [parse_zone(target_zone)], stopping the incision's bleeding."),
			SPAN_NOTICE("[user] finishes ligating bleeders in [target]'s [parse_zone(target_zone)], stopping the incision's bleeding."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You clamp bleeders in [target]'s [surgery.affected_limb.display_name]."),
			SPAN_NOTICE("[user] clamps bleeders in your [parse_zone(target_zone)]."),
			SPAN_NOTICE("[user] clamps bleeders in [target]'s [parse_zone(target_zone)]."))

	surgery.affected_limb.limb_surgery_status |= INCISION_CLAMPED
	surgery.affected_limb.limb_surgery_status &= ~INCISION_BLEEDING
	target.update_surgery_overlays()
	log_interact(user, target, "[key_name(user)] clamped bleeders in [key_name(target)]'s [surgery.affected_limb.display_name], possibly ending [surgery].")

	var/surface_modifier = target.buckled?.surgery_duration_multiplier
	if(!surface_modifier)
		surface_modifier = SURGERY_SURFACE_MULT_AWFUL
		for(var/obj/surface in get_turf(target))
			if(surface_modifier > surface.surgery_duration_multiplier)
				surface_modifier = surface.surgery_duration_multiplier


	if(surface_modifier == SURGERY_SURFACE_MULT_IDEAL)
		surgery.affected_limb.remove_all_bleeding(TRUE, FALSE)
		return

	var/bleeding_multiplier_bad_surface = surface_modifier - 1
	for(var/datum/effects/bleeding/external/external_bleed in surgery.affected_limb.bleeding_effects_list)
		external_bleed.blood_loss *= bleeding_multiplier_bad_surface
		to_chat(user, SPAN_WARNING("Stopping blood loss is less effective in these conditions."))


/datum/surgery_step/clamp_bleeders_step/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips and tears several blood vessels in [target]'s [surgery.affected_limb.display_name], causing internal bleeding! Blood gushes all over and fills the surgical site!"),
		SPAN_WARNING("[user]'s hand slips and tears several blood vessels in your [surgery.affected_limb.display_name], causing internal bleeding! Blood gushes all over and fills the surgical site!"),
		SPAN_WARNING("[user]'s hand slips and tears several blood vessels in [target]'s [surgery.affected_limb.display_name], causing internal bleeding! Blood gushes all over and fills the surgical site!"))

	target.custom_pain("You feel something rip in your [surgery.affected_limb.display_name]!", 1)
	if(target.stat == CONSCIOUS)
		to_chat(user, SPAN_WARNING("Blood is gushing out of your [surgery.affected_limb.display_name]! It looks horrifying!"))
		if(target.pain.reduction_pain < surgery.pain_reduction_required)//if patient is not under the proper anesthesia
			target.emote("pain")

	user.add_blood(target.get_blood_color(), BLOOD_HANDS) //messy
	user.add_blood(target.get_blood_color(), BLOOD_BODY) //splish splosh
	var/datum/wound/internal_bleeding/int_bleeding = new (0)
	surgery.affected_limb.add_bleeding(int_bleeding, TRUE)
	surgery.affected_limb.wounds += int_bleeding
	target.apply_damage(4, BRUTE, target_zone)
	surgery.affected_limb.limb_surgery_status |= INCISION_INT_BLEEDING
	target.update_surgery_overlays()
	log_interact(user, target, "[key_name(user)] failed to clamp bleeders in [key_name(target)]'s [surgery.affected_limb.display_name], possibly ending [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/retract_skin
	name = "Widen Incision"
	desc = "widen the incision"
	time = 2 SECONDS
	//Tools used to pry open specifically incisions. Contains INCISION tools at lengthy delays, mainly so surgeons can dramatically slash open incisions with them.
	tools = list(\
		/obj/item/tool/surgery/retractor = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/crowbar = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
		/obj/item/maintenance_jack = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
		/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_AWFUL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_AWFUL,
		/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_AWFUL,
		/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_AWFUL,
		/obj/item/weapon/throwing_knife = SURGERY_TOOL_MULT_AWFUL,
		/obj/item/shard = SURGERY_TOOL_MULT_AWFUL
		)
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/retract_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(target_zone == "groin")
		user.affected_message(target,
			SPAN_NOTICE("You begin prying open the incision and rearranging the organs in [target]'s lower abdomen with [tool]."),
			SPAN_NOTICE("[user] begins to pry open the incision and rearrange the organs in your lower abdomen with [tool]."),
			SPAN_NOTICE("[user] begins to pry open the incision and rearrange the organs in [target]'s lower abdomen with [tool]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You begin drawing back the skin and tissue around the incision on [target]'s [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] begins drawing back the skin and tissue around the incision on your [surgery.affected_limb.display_name] with [tool]."),
			SPAN_NOTICE("[user] begins drawing back the skin and tissue around the incision on [target]'s [surgery.affected_limb.display_name] with [tool]."))

	target.custom_pain("It feels like the skin on your [surgery.affected_limb.display_name] is on fire as it is being pulled apart!", 1)
	log_interact(user, target, "[key_name(user)] began retracting skin in [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/retract_skin/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/h_his = "their" //[tool] doesn't have a gender.
	switch(target.gender)
		if(MALE)
			h_his = "his"
		if(FEMALE)
			h_his = "her"
		if(PLURAL)
			h_his = "their"

	switch(target_zone)
		if("chest")
			user.affected_message(target,
				SPAN_NOTICE("You hold the incision on [target]'s [surgery.affected_limb.display_name] open with [tool], exposing [h_his] ribs."),
				SPAN_NOTICE("[user] holds the incision on your [surgery.affected_limb.display_name] open with [tool], exposing your ribs."),
				SPAN_NOTICE("[user] holds the incision on [target]'s [surgery.affected_limb.display_name] open with [tool], exposing [h_his] ribs."))
			surgery.affected_limb.limb_surgery_status |= INCISION_BONE_CLOSED
		if("head")
			user.affected_message(target,
				SPAN_NOTICE("You hold the incision on [target]'s head open with [tool], exposing [h_his] skull."),
				SPAN_NOTICE("[user] holds the incision on your head open with [tool], exposing your skull."),
				SPAN_NOTICE("[user] holds the incision on [target]'s head open with [tool], exposing [h_his] skull."))
			surgery.affected_limb.limb_surgery_status |= INCISION_BONE_CLOSED

		if("groin")
			user.affected_message(target,
				SPAN_NOTICE("You hold the incision on [target]'s lower abdomen open with [tool], exposing [h_his] viscera."),
				SPAN_NOTICE("[user] holds the incision on your lower abdomen open with [tool], exposing your viscera."),
				SPAN_NOTICE("[user] holds the incision on [target]'s lower abdomen open with [tool], exposing [h_his] viscera."))
			surgery.affected_limb.limb_surgery_status |= INCISION_BONE_CLOSED
		else
			user.affected_message(target,
				SPAN_NOTICE("You hold the incision on [target]'s [surgery.affected_limb.display_name] open with [tool], exposing [h_his] bones and blood vessels."),
				SPAN_NOTICE("[user] holds the incision on your [surgery.affected_limb.display_name] open with [tool], exposing your bones and blood vessels."),
				SPAN_NOTICE("[user] holds the incision on [target]'s [surgery.affected_limb.display_name] open with [tool], exposing [h_his] bones and blood vessels."))

	surgery.affected_limb.limb_surgery_status |= INCISION_WIDENED
	surgery.affected_limb.limb_surgery_status &= ~INCISION_MADE
	target.update_surgery_overlays()
	log_interact(user, target, "[key_name(user)] retracted skin in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/retract_skin/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/h_his = "their" //[tool] doesn't have a gender.
	switch(target.gender)
		if(MALE)
			h_his = "his"
		if(FEMALE)
			h_his = "her"
		if(PLURAL)
			h_his = "their"

	switch(target_zone)
		if("head")
			user.affected_message(target,
				SPAN_WARNING("You tear open the incision on [target]'s head with [tool], exposing [h_his] skull!"),
				SPAN_WARNING("[user] holds the incision on your head open with [tool], exposing your skull!"),
				SPAN_WARNING("[user] holds the incision on [target]'s head open with [tool], exposing [h_his] skull!"))
			surgery.affected_limb.limb_surgery_status |= INCISION_BONE_CLOSED

		if("groin")
			user.affected_message(target,
				SPAN_WARNING("You tear open the incision on [target]'s lower abdomen with [tool], exposing [h_his] viscera!"),
				SPAN_WARNING("[user] tears the incision on your lower abdomen open with [tool], exposing your viscera!"),
				SPAN_WARNING("[user] tears the incision on [target]'s lower abdomen open with [tool], exposing [h_his] viscera!"))
			surgery.affected_limb.limb_surgery_status |= INCISION_BONE_CLOSED

		if("chest")
			user.affected_message(target,
				SPAN_WARNING("You tear open the incision on [target]'s [surgery.affected_limb.display_name] with [tool], exposing [h_his] ribs!"),
				SPAN_WARNING("[user] tears the incision on your [surgery.affected_limb.display_name] open with [tool], exposing your ribs!"),
				SPAN_WARNING("[user] tears the incision on [target]'s [surgery.affected_limb.display_name] open with [tool], exposing [h_his] ribs!"))
			surgery.affected_limb.limb_surgery_status |= INCISION_BONE_CLOSED
		else
			user.affected_message(target,
				SPAN_WARNING("You tear open the incision on [target]'s [surgery.affected_limb.display_name] with [tool], exposing bones and bleeding blood vessels!"),
				SPAN_WARNING("[user] tears the incision on your [surgery.affected_limb.display_name] open with [tool], exposing bones and bleeding blood vessels!"),
				SPAN_WARNING("[user] tears the incision on [target]'s [surgery.affected_limb.display_name] open with [tool], exposing bones and bleeding blood vessels!"))

	if(target.stat == CONSCIOUS)
		if(target.pain.reduction_pain < surgery.pain_reduction_required) //if patient is not under the proper anesthesia
			target.emote("pain")

	surgery.affected_limb.limb_surgery_status |= INCISION_WIDENED
	target.update_surgery_overlays()
	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] violently retracted skin in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	return TRUE //Failing to finish this step doesn't fail it, it just means you do it a lot more violently.

//------------------------------------

/datum/surgery/close_incision
	name = "Close Incision"
	priority = SURGERY_PRIORITY_MINIMUM
	possible_locs = ALL_LIMBS
	required_surgery_skill = SKILL_SURGERY_NOVICE
	steps = list(/datum/surgery_step/cauterize)
	lying_required = FALSE
	self_operable = TRUE
	pain_reduction_required = PAIN_REDUCTION_MEDIUM

//------------------------------------

/datum/surgery_step/cauterize
	name = "Cauterize Incision"
	desc = "cauterize the incision"
	tools = SURGERY_TOOLS_CAUTERIZE
	time = 2.5 SECONDS
	var/tools_lit = list(
		/obj/item/tool/lighter,
		/obj/item/clothing/mask/cigarette,
		/obj/item/tool/weldingtool,
		)
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'
	failure_sound = 'sound/items/welder.ogg'

/datum/surgery_step/cauterize/tool_check(mob/user, obj/item/tool, datum/surgery/surgery)
	. = ..()
	if((. in tools_lit) && !tool.heat_source) //Light your damned tools.
		return FALSE

/datum/surgery_step/cauterize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start cauterizing the incision on [target]'s [surgery.affected_limb.display_name] with [tool]."),
		SPAN_NOTICE("[user] starts to cauterize the incision on your [surgery.affected_limb.display_name] with [tool]."),
		SPAN_NOTICE("[user] starts to cauterize the incision on [target]'s [surgery.affected_limb.display_name] with [tool]."))

	target.custom_pain("Your [surgery.affected_limb.display_name] burns!", 1)
	log_interact(user, target, "[key_name(user)] began cauterizing an incision in [key_name(target)]'s [surgery.affected_limb.display_name], beginning [surgery].")

/datum/surgery_step/cauterize/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You cauterize the incision on [target]'s [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] cauterizes the incision on your [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] cauterizes the incision on [target]'s [surgery.affected_limb.display_name]."))

	target.remove_surgery_flags()
	target.update_surgery_overlays()
	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	surgery.affected_limb.remove_all_bleeding(TRUE, FALSE)
	target.pain.recalculate_pain()

	log_interact(user, target, "[key_name(user)] cauterized an incision in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/cauterize/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, leaving a small burn on [target]'s [surgery.affected_limb.display_name]!"),
		SPAN_WARNING("[user]'s hand slips, leaving a small burn on your [surgery.affected_limb.display_name]!"),
		SPAN_WARNING("[user]'s hand slips, leaving a small burn on [target]'s [surgery.affected_limb.display_name]!"))

	target.apply_damage(3, BURN, target_zone)
	log_interact(user, target, "[key_name(user)] failed to cauterize an incision in [key_name(target)]'s [surgery.affected_limb.display_name], aborting [surgery].")
	return FALSE

/datum/surgery_step/cauterize/abort
	name = "Abort Surgery"
	desc = "close the incision early"

/datum/surgery_step/cauterize/abort/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE //If you opened the wrong limb or you need to close an autopsy incision; this has you covered. Different from amputation abortion.

/datum/surgery_step/cauterize/abort/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You cauterize the incision on [target]'s [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] cauterizes the incision on your [surgery.affected_limb.display_name]."),
		SPAN_NOTICE("[user] cauterizes the incision on [target]'s [surgery.affected_limb.display_name]."))

	target.remove_surgery_flags()
	target.update_surgery_overlays()
	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	surgery.affected_limb.remove_all_bleeding(TRUE, FALSE)
	target.pain.recalculate_pain()
	complete(target, surgery)
	log_interact(user, target, "[key_name(user)] cauterized an incision in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")

//////////////////////////////////////////////////////////////////
// BONE-OPENING SURGERIES //
//////////////////////////////////////////////////////////////////

/datum/surgery/open_encased
	name = "Open Bone"
	priority = SURGERY_PRIORITY_LOW
	possible_locs = list("chest","head")
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/saw_encased,
		/datum/surgery_step/open_encased_step,
		/datum/surgery_step/clamp_bleeders_step,
		/datum/surgery_step/mend_encased,
	)
	pain_reduction_required = PAIN_REDUCTION_HEAVY

//------------------------------------

/datum/surgery/open_encased/groin
	name = "Move Organs Away"
	priority = SURGERY_PRIORITY_LOW
	possible_locs = list("groin")
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/open_encased_step/groin,
		/datum/surgery_step/clamp_bleeders_step,
		/datum/surgery_step/mend_encased,
	)
	pain_reduction_required = PAIN_REDUCTION_HEAVY

//------------------------------------

/datum/surgery_step/saw_encased
	name = "Saw Bone"
	desc = "saw through the bone"
	/*Tools used to cut ribs/skull. Same tools as SEVER_BONE, but with sawing tools being better than chopping ones.
	You're trying to cut through, but keep it and what's behind it intact.*/
	tools = list(
		/obj/item/tool/surgery/circular_saw = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/weapon/twohanded/fireaxe = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/weapon/sword/machete = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/hatchet = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
		/obj/item/tool/kitchen/knife/butcher = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
	)
	time = 4 SECONDS
	preop_sound = 'sound/surgery/saw.ogg'
	success_sound = 'sound/surgery/hemostat2.ogg'
	failure_sound = 'sound/effects/circsawfail1.ogg'


/datum/surgery_step/saw_encased/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/limb/affecting = target.get_limb(check_zone(user.zone_selected))
	if(affecting.status & LIMB_BROKEN)
		return TRUE //Don't need the saw if it's already fractured.

/datum/surgery_step/saw_encased/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to cut through [target]'s [surgery.affected_limb.encased] with [tool]."),
		SPAN_NOTICE("[user] begins to cut through your [surgery.affected_limb.encased] with [tool]."),
		SPAN_NOTICE("[user] begins to cut through [target]'s [surgery.affected_limb.encased] with [tool]."))

	target.custom_pain("You can feel every vibration and cut in your [surgery.affected_limb.display_name]! It feels terrible!", 1)

	if(surgery.affected_limb.status & LIMB_BROKEN)
		to_chat(user, SPAN_NOTICE("It's already broken, though, so you could just pry it open."))
	log_interact(user, target, "[key_name(user)] began cutting through [key_name(target)]'s [surgery.affected_limb.encased], attempting [surgery].")

/datum/surgery_step/saw_encased/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish cutting through [target]'s [surgery.affected_limb.encased]."),
		SPAN_NOTICE("[user] finishes cutting through your [surgery.affected_limb.encased]."),
		SPAN_NOTICE("[user] finishes cutting through [target]'s [surgery.affected_limb.encased]."))

	log_interact(user, target, "[key_name(user)] cut through [key_name(target)]'s [surgery.affected_limb.encased], beginning [surgery].")

/datum/surgery_step/saw_encased/failure(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.status & LIMB_BROKEN) //Can't shatter what is already broken.
		var/affected_bone = surgery.affected_limb.name == "chest" ? "ribs" : "skull"
		user.affected_message(target,
			SPAN_WARNING("You hack through [target]'s broken [affected_bone]!"),
			SPAN_WARNING("[user] hacks through your broken [affected_bone]!"),
			SPAN_WARNING("[user] hacks through [target]'s broken [affected_bone]!"))
		if(target.stat == CONSCIOUS)
			if (target.pain.reduction_pain >= surgery.pain_reduction_required) //if patient is under the proper anesthesia
				target.emote("pain") //BRO!?
			else
				target.emote("scream") //MY! ARRRRRRMMMM! - Scout from Team Fortress 2

	else
		user.affected_message(target,
			SPAN_WARNING("You shatter [target]'s [surgery.affected_limb.encased]!"),
			SPAN_WARNING("[user] shatters your [surgery.affected_limb.encased]!"),
			SPAN_WARNING("[user] shatters [target]'s [surgery.affected_limb.encased]!"))

		if(target.stat == CONSCIOUS)
			if (target.pain.reduction_pain >= surgery.pain_reduction_required) //if patient is under the proper anesthesia
				target.emote("pain") //HEY!!!
			else
				target.emote("scream") //MY! ARRRRRRMMMM! - Scout from Team Fortress 2
		surgery.affected_limb.fracture(100)

	target.update_surgery_overlays()
	user.animation_attack_on(target)
	if(tool.hitsound)
		playsound(target.loc, tool.hitsound, 25, TRUE)
	target.apply_damage(20, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] violently cut through [key_name(target)]'s [surgery.affected_limb.encased], beginning [surgery].")
	return TRUE

//------------------------------------

//This step can be skipped, and ends the surgery when completed. In rib-opening surgery, it can be skipped to abort the operation.
//In rib-closing surgery, it can be skipped to finish closing the ribcage, or completed to abort the operation.
/datum/surgery_step/open_encased_step
	name = "Pry Bones Open"
	desc = "pry the sawed bones open"
	tools = SURGERY_TOOLS_PRY_ENCASED
	time = 2 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/effects/bone_break4.ogg'

/datum/surgery_step/open_encased_step/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE

/datum/surgery_step/open_encased_step/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start forcing [target]'s [surgery.affected_limb.encased] open with [tool]."),
		SPAN_NOTICE("[user] begins to force your [surgery.affected_limb.encased] open with [tool]."),
		SPAN_NOTICE("[user] begins to force [target]'s [surgery.affected_limb.encased] open with [tool]."))

	target.custom_pain("It feels as if your [surgery.affected_limb.display_name] is being split in two!", 1)
	log_interact(user, target, "[key_name(user)] began opening [key_name(target)]'s [surgery.affected_limb.encased], possibly beginning [surgery].")

/datum/surgery_step/open_encased_step/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/brain = surgery.affected_limb.body_part == BODY_FLAG_HEAD ? TRUE : FALSE
	if(prob(10)) //RNG break chance.
		user.affected_message(target,
			SPAN_NOTICE("[target]'s [surgery.affected_limb.encased] couldn't take the strain and fractured as you exposed \his [brain ? "brain" : "vital organs"] with [tool]!"),
			SPAN_NOTICE("Your [surgery.affected_limb.encased] couldn't take the strain and fractured as [user] exposed your [brain ? "brain" : "vital organs"] with [tool]!"),
			SPAN_NOTICE("[target]'s [surgery.affected_limb.encased] couldn't take the strain and fractured as [user] exposed \his [brain ? "brain" : "vital organs"] with [tool]!"))

		surgery.affected_limb.fracture(100)
		if(target.stat == CONSCIOUS)
			if(target.pain.reduction_pain < surgery.pain_reduction_required) //if patient is not under the proper anesthesia. Patient under anesthesia can't feel shit.
				target.emote("scream") //AWWW FUCK MY RIBS!
	else
		user.affected_message(target,
			SPAN_NOTICE("You use [tool] to hold [target]'s [surgery.affected_limb.encased] open, exposing \his [brain ? "brain" : "vital organs"]."),
			SPAN_NOTICE("[user] uses [tool] to hold your [surgery.affected_limb.encased] open, exposing your [brain ? "brain" : "vital organs"]."),
			SPAN_NOTICE("[user] uses [tool] to hold [target]'s [surgery.affected_limb.encased] open, exposing \his [brain ? "brain" : "vital organs"]."))

	surgery.affected_limb.limb_surgery_status &= ~INCISION_BONE_CLOSED
	surgery.affected_limb.limb_surgery_status |= INCISION_BONE_OPENED
	target.update_surgery_overlays()
	target.incision_depths[target_zone] = SURGERY_DEPTH_DEEP
	complete(target, surgery) //This finishes the surgery.
	log_interact(user, target, "[key_name(user)] opened [key_name(target)]'s [surgery.affected_limb.encased], ending [surgery].")

/datum/surgery_step/open_encased_step/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.status & LIMB_BROKEN)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging [target]'s [surgery.affected_limb.encased] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging your [surgery.affected_limb.encased] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging [target]'s [surgery.affected_limb.encased] even more!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, cracking [target]'s [surgery.affected_limb.encased]!"),
			SPAN_WARNING("[user]'s hand slips, cracking your [surgery.affected_limb.encased]!"),
			SPAN_WARNING("[user]'s hand slips, cracking [target]'s [surgery.affected_limb.encased]!"))

		if(target.stat == CONSCIOUS)
			if (target.pain.reduction_pain >= surgery.pain_reduction_required) //if patient is under the proper anesthesia
				target.emote("pain") //Shit doc, watch it!
			else
				target.emote("scream") //MAN WHAT THE HELL!?
		surgery.affected_limb.fracture(100)

	target.update_surgery_overlays()
	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to open [key_name(target)]'s [surgery.affected_limb.encased].")

//------------------------------------

//Unique to pelvis bone repair surgery. Move organs out of the way to display the pelvis.
/datum/surgery_step/open_encased_step/groin
	name = "Move Organs Away"
	desc = "move organs away from the pelvis"
	tools = SURGERY_TOOLS_PRY_ENCASED
	time = 2 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery/open_encased_step/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/patient_limb, obj/item/tool)
	return (patient_limb.status & LIMB_BROKEN)

/datum/surgery_step/open_encased_step/groin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/internals_type
	if(issynth(target))
		internals_type = "hydraulic systems"
	else
		internals_type = "internal organs"

	user.affected_message(target,
		SPAN_NOTICE("You begin to gently move [target]'s [internals_type] away from \his pelvic bones with [tool]."),
		SPAN_NOTICE("[user] begins to gently move your [internals_type] away from your pelvic bones with [tool]."),
		SPAN_NOTICE("[user] begins to gently move [target]'s [internals_type] away from \his pelvic bones open with [tool]."))

	target.custom_pain("The pressure of your [internals_type] moving around in your lower abdomen is excruciating!", 1)
	log_interact(user, target, "[key_name(user)] began moving organs in [key_name(target)]'s [surgery.affected_limb.cavity], possibly beginning [surgery].")

/datum/surgery_step/open_encased_step/groin/success(mob/user, mob/living/carbon/target, internals_type, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You hold [target]'s [internals_type] away from \his pelvic bones with [tool], exposing them."),
		SPAN_NOTICE("[user] holds your [internals_type] away from pelvic bones with [tool], exposing them."),
		SPAN_NOTICE("[user] holds [target]'s [internals_type] away from \his pelvic bones with [tool], exposing them."))

	surgery.affected_limb.limb_surgery_status &= ~INCISION_BONE_CLOSED
	surgery.affected_limb.limb_surgery_status |= INCISION_BONE_OPENED
	target.incision_depths[target_zone] = SURGERY_DEPTH_DEEP
	complete(target, surgery) //This finishes the surgery.
	log_interact(user, target, "[key_name(user)] moved organs in [key_name(target)]'s lower abdomen, ending [surgery].")

/datum/surgery_step/open_encased_step/groin/failure(mob/user, mob/living/carbon/target, internals_type, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, bruising [target]'s [internals_type] and contaminating \his lower abdomen!"),
		SPAN_WARNING("[user]'s hand slips, bruising your [internals_type] and contaminating your lower abdomen!"),
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s [internals_type] and contaminating \his lower abdomen!"))

	if(target.stat == CONSCIOUS)
		if(target.pain.reduction_pain < surgery.pain_reduction_required)
			target.emote("pain")

	var/dam_amt = 3
	target.apply_damage(10, TOX)
	target.apply_damage(5, BRUTE, target_zone)

	for(var/datum/internal_organ/int_organ as anything in surgery.affected_limb.internal_organs)
		if(int_organ && int_organ.damage > 0)
			int_organ.take_damage(dam_amt,0)

	log_interact(user, target, "[key_name(user)] failed to move [target]'s [internals_type] away from \his [surgery.affected_limb.cavity].")

//------------------------------------

/datum/surgery/close_encased
	name = "Close Bone"
	priority = SURGERY_PRIORITY_MINIMUM
	possible_locs = list("chest","head")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/close_encased_step,
		/datum/surgery_step/open_encased_step,
		/datum/surgery_step/clamp_bleeders_step, //oop i forgor, also cuz you can't clamp bleeders here, normally, for some reason
		/datum/surgery_step/mend_encased,
	)
	pain_reduction_required = PAIN_REDUCTION_HEAVY


/datum/surgery/close_encased/groin
	name = "Move Organs Back"
	priority = SURGERY_PRIORITY_MINIMUM
	possible_locs = list("groin")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/close_encased_step/groin,
		/datum/surgery_step/open_encased_step/groin,
		/datum/surgery_step/clamp_bleeders_step,
		/datum/surgery_step/mend_bones,
	)
	pain_reduction_required = PAIN_REDUCTION_HEAVY

//------------------------------------

/datum/surgery_step/close_encased_step
	name = "Close Bone"
	desc = "bend the bones back into place"
	tools = SURGERY_TOOLS_PRY_ENCASED
	time = 2 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/effects/bone_break7.ogg'

/datum/surgery_step/close_encased_step/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start bending [target]'s [surgery.affected_limb.encased] back into place with [tool]."),
		SPAN_NOTICE("[user] starts bending your [surgery.affected_limb.encased] back into place with [tool]."),
		SPAN_NOTICE("[user] starts bending [target]'s [surgery.affected_limb.encased] back into place with [tool]."))

	target.custom_pain("You feel a crushing pressure in your [surgery.affected_limb.display_name]!", 1)
	log_interact(user, target, "[key_name(user)] began closing [key_name(target)]'s [surgery.affected_limb.encased], attempting to begin [surgery].")

/datum/surgery_step/close_encased_step/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You close [target]'s [surgery.affected_limb.encased]."),
		SPAN_NOTICE("[user] closes your [surgery.affected_limb.encased]."),
		SPAN_NOTICE("[user] closes [target]'s [surgery.affected_limb.encased]."))

	surgery.affected_limb.limb_surgery_status &= ~INCISION_BONE_OPENED
	surgery.affected_limb.limb_surgery_status |= INCISION_BONE_CLOSED
	target.update_surgery_overlays()
	target.incision_depths[target_zone] = SURGERY_DEPTH_SHALLOW
	log_interact(user, target, "[key_name(user)] closed [key_name(target)]'s [surgery.affected_limb.encased], beginning [surgery].")

/datum/surgery_step/close_encased_step/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.status & LIMB_BROKEN)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging [target]'s [surgery.affected_limb.encased] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging your [surgery.affected_limb.encased] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging [target]'s [surgery.affected_limb.encased] even more!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, cracking [target]'s [surgery.affected_limb.encased]!"),
			SPAN_WARNING("[user]'s hand slips, cracking your [surgery.affected_limb.encased]!"),
			SPAN_WARNING("[user]'s hand slips, cracking [target]'s [surgery.affected_limb.encased]!"))

		if(target.stat == CONSCIOUS)
			if (target.pain.reduction_pain >= surgery.pain_reduction_required) //if patient is under the proper anesthesia
				target.emote("pain") //Shit doc, watch it!
			else
				target.emote("scream") //MAN WHAT THE HELL!?
		surgery.affected_limb.fracture(100)

	target.update_surgery_overlays()
	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to close [key_name(target)]'s [surgery.affected_limb.encased], aborting [surgery].")

//------------------------------------

//Gotta move dem organs back in place before closing the patient!
/datum/surgery_step/close_encased_step/groin
	name = "Close Bone"
	desc = "move the abdominopelvic organs back in place"
	tools = SURGERY_TOOLS_PRY_ENCASED
	time = 2 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/close_encased_step/groin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/internals_type
	if(issynth(target))
		internals_type = "hydraulic systems"
	else
		internals_type = "internal organs"

	user.affected_message(target,
		SPAN_NOTICE("You begin to gently move [target]'s [internals_type] in \his [surgery.affected_limb.cavity] back into place with [tool]."),
		SPAN_NOTICE("[user] begins to gently move your [internals_type] in your [surgery.affected_limb.cavity] back into place with [tool]."),
		SPAN_NOTICE("[user] begins to gently move [target]'s [internals_type] in \his [surgery.affected_limb.cavity] back into place with [tool]."))

	target.custom_pain("You feel a crushing pressure in your [surgery.affected_limb.display_name]!", 1)
	log_interact(user, target, "[key_name(user)] began moving [internals_type] back into place in [key_name(target)]'s [surgery.affected_limb.cavity], attempting to begin [surgery].")

/datum/surgery_step/close_encased_step/groin/success(mob/user, mob/living/carbon/human/target, internals_type, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You move [target]'s [internals_type] in \his [surgery.affected_limb.encased] back into place.."),
		SPAN_NOTICE("[user] moves your [internals_type] in your [surgery.affected_limb.cavity] back into place."),
		SPAN_NOTICE("[user] moves [target]'s [internals_type] in \his [surgery.affected_limb.cavity] back into place."))

	surgery.affected_limb.limb_surgery_status &= ~INCISION_BONE_OPENED
	surgery.affected_limb.limb_surgery_status |= INCISION_BONE_CLOSED
	target.update_surgery_overlays()
	target.incision_depths[target_zone] = SURGERY_DEPTH_SHALLOW
	log_interact(user, target, "[key_name(user)] moved [internals_type] back in place into [key_name(target)]'s [surgery.affected_limb.cavity], beginning [surgery].")

/datum/surgery_step/close_encased_step/groin/failure(mob/user, mob/living/carbon/human/target, internals_type, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, bruising [target]'s [internals_type] and contaminating \his [surgery.affected_limb.cavity]!"),
		SPAN_WARNING("[user]'s hand slips, bruising your [internals_type] and contaminating your [surgery.affected_limb.cavity]!"),
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s [internals_type] and contaminating \his [surgery.affected_limb.cavity]!"))

	if(target.stat == CONSCIOUS)
		if(target.pain.reduction_pain < surgery.pain_reduction_required)
			target.emote("pain")

	var/dam_amt = 3
	target.apply_damage(10, TOX)
	target.apply_damage(5, BRUTE, target_zone)

	for(var/datum/internal_organ/int_organ as anything in surgery.affected_limb.internal_organs)
		if(int_organ && int_organ.damage > 0)
			int_organ.take_damage(dam_amt,0)

	target.update_surgery_overlays()
	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to move organs back in place into [key_name(target)]'s [surgery.affected_limb.cavity], aborting [surgery].")

/datum/surgery_step/mend_encased
	name = "Mend Bone"
	desc = "repair the damaged bones"
	tools = SURGERY_TOOLS_BONE_MEND
	time = 3 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/bandage.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

//Use materials to mend bones, same as /datum/surgery_step/mend_bones
/datum/surgery_step/mend_encased/extra_checks(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, repeating, skipped)
	. = ..()
	if(istype(tool, /obj/item/tool/surgery/bonegel)) //If bone gel, use some of the gel
		var/obj/item/tool/surgery/bonegel/gel = tool
		if(!gel.use_gel(gel.mend_bones_fix_cost))
			to_chat(user, SPAN_BOLDWARNING("[gel] is empty!"))
			return FALSE

	else //Otherwise, use metal rods
		var/obj/item/stack/rods/rods = user.get_inactive_hand()
		if(!istype(rods))
			to_chat(user, SPAN_BOLDWARNING("You need metal rods in your offhand to mend [target]'s [surgery.affected_limb.display_name] with [tool]."))
			return FALSE
		if(!rods.use(2)) //Refunded on failure
			to_chat(user, SPAN_BOLDWARNING("You need more metal rods to mend [target]'s [surgery.affected_limb.display_name] with [tool]."))
			return FALSE

/datum/surgery_step/mend_encased/preop(mob/user, mob/living/carbon/target, surgery_step, step, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/bonegel)
		user.affected_message(target,
			SPAN_NOTICE("You start applying [tool] to [target]'s [surgery.affected_limb.encased]."),
			SPAN_NOTICE("[user] starts to apply [tool] to your [surgery.affected_limb.encased]."),
			SPAN_NOTICE("[user] starts to apply [tool] to [target]'s [surgery.affected_limb.encased]."))

		target.custom_pain("Something stings and feels cold and gooey in your [surgery.affected_limb.display_name]!", 1)
	else
		user.affected_message(target,
			SPAN_NOTICE("You begin screwing a reinforcing plate to [target]'s [surgery.affected_limb.encased] with [tool]."),
			SPAN_NOTICE("[user] begins to screw a reinforcing plate to your [surgery.affected_limb.encased] with [tool]."),
			SPAN_NOTICE("[user] begins to screw a reinforcing plate to [target]'s [surgery.affected_limb.encased] with [tool]."))

		target.custom_pain("You can feel something grinding in your [surgery.affected_limb.encased]!", 1)
		playsound(target.loc, 'sound/items/Screwdriver.ogg', 25, TRUE)

	log_interact(user, target, "[key_name(user)] began mending [key_name(target)]'s [surgery.affected_limb.encased].")

/datum/surgery_step/mend_encased/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/bonegel)
		user.affected_message(target,
			SPAN_NOTICE("You mend [target]'s [surgery.affected_limb.encased]."),
			SPAN_NOTICE("[user] mends your [surgery.affected_limb.encased]."),
			SPAN_NOTICE("[user] mends [target]'s [surgery.affected_limb.encased]."))
	else
		var/improvised_desc = pick("paleolithic surgeon", "UPP torturer", "mad carpenter")
		user.affected_message(target,
			SPAN_NOTICE("You haphazardly repair [target]'s [surgery.affected_limb.encased] like some kind of [improvised_desc]."),
			SPAN_NOTICE("[user] haphazardly repairs your [surgery.affected_limb.encased] like some kind of [improvised_desc]."),
			SPAN_NOTICE("[user] haphazardly repairs [target]'s [surgery.affected_limb.encased] like some kind of [improvised_desc]."))

	if(surgery.affected_limb.status & LIMB_BROKEN)
		to_chat(user, SPAN_NOTICE("You've repaired the damage done from prying it open, but it's still fractured."))
	log_interact(user, target, "[key_name(user)] mended [key_name(target)]'s [surgery.affected_limb.encased], ending [surgery].")

/datum/surgery_step/mend_encased/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.status & LIMB_BROKEN)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging [target]'s [surgery.affected_limb.encased] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging your [surgery.affected_limb.encased] even more!"),
			SPAN_WARNING("[user]'s hand slips, damaging [target]'s [surgery.affected_limb.encased] even more!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, cracking [target]'s [surgery.affected_limb.encased]!"),
			SPAN_WARNING("[user]'s hand slips, cracking your [surgery.affected_limb.encased]!"),
			SPAN_WARNING("[user]'s hand slips, cracking [target]'s [surgery.affected_limb.encased]!"))

		if(target.stat == CONSCIOUS)
			if (target.pain.reduction_pain >= surgery.pain_reduction_required) //if patient is under the proper anesthesia
				target.emote("pain") //Shit doc, watch it!
			else
				target.emote("scream") //MAN WHAT THE HELL!?
		surgery.affected_limb.fracture(100)
	target.update_surgery_overlays()
	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to mend [key_name(target)]'s [surgery.affected_limb.encased].")

	if(tool_type != /obj/item/tool/surgery/bonegel)
		to_chat(user, SPAN_NOTICE("The metal rods used on [target]'s [surgery.affected_limb.display_name] fall loose from their [surgery.affected_limb]."))
		var/obj/item/stack/rods/rods = new /obj/item/stack/rods(get_turf(target))
		rods.amount = 2 //Refund 2 rods on failure
		rods.update_icon()
