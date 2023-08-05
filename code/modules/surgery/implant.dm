//Procedures in this file: Putting items in body cavity. Implant removal. Embedded object removal.

//////////////////////////////////////////////////////////////////
// ITEM PLACEMENT SURGERY //
//////////////////////////////////////////////////////////////////

//Implant and removal surgeries allow either removing the implant just inserted or replacing a removed one with a new item.
/datum/surgery/implant
	name = "Implant Surgery"
	priority = SURGERY_PRIORITY_LOW
	possible_locs = list("chest", "head")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/create_cavity,
		/datum/surgery_step/place_item,
		/datum/surgery_step/cauterize/close_cavity,
	)

/datum/surgery/implant/groin
	possible_locs = list("groin")
	invasiveness = list(SURGERY_DEPTH_SHALLOW)

/datum/surgery/implant/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return !L.hidden

//------------------------------------

/datum/surgery/implant/removal
	name = "Implant Removal Surgery"
	steps = list(
		/datum/surgery_step/create_cavity,
		/datum/surgery_step/remove_implant,
		/datum/surgery_step/cauterize/close_cavity,
	)

/datum/surgery/implant/removal/groin
	possible_locs = list("groin")
	invasiveness = list(SURGERY_DEPTH_SHALLOW)

/datum/surgery/implant/removal/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return L.hidden

//------------------------------------

/datum/surgery_step/create_cavity
	name = "Create Implant Cavity"
	desc = "open an implant cavity"
	tools = list(
		/obj/item/tool/surgery/surgicaldrill = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/pen = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/stack/rods = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 6 SECONDS

/datum/surgery_step/create_cavity/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin opening a pocket in [target]'s [surgery.affected_limb.cavity] wall with \the [tool]."),
		SPAN_NOTICE("[user] begins to open a pocket in your [surgery.affected_limb.cavity] wall with \the [tool]."),
		SPAN_NOTICE("[user] begins to open a pocket in [target]'s [surgery.affected_limb.cavity] wall with \the [tool]."))

	target.custom_pain("[user] is literally drilling a hole in your [surgery.affected_limb.display_name]!", 1)
	log_interact(user, target, "[key_name(user)] started to make some space in [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool].")

/datum/surgery_step/create_cavity/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You open an implant cavity inside [target]'s [surgery.affected_limb.cavity]."),
		SPAN_NOTICE("[user] opens an implant cavity inside your [surgery.affected_limb.cavity]."),
		SPAN_NOTICE("[user] opens an implant cavity inside [target]'s [surgery.affected_limb.cavity]."))

	log_interact(user, target, "[key_name(user)] made some space in [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool], beginning [surgery].")

/datum/surgery_step/create_cavity/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [surgery.affected_limb.cavity] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside your [surgery.affected_limb.cavity] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [surgery.affected_limb.cavity] with \the [tool]!"))

	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to make some space in [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/place_item
	name = "Insert Implant"
	desc = "implant an object"
	accept_any_item = TRUE //Any item except a surgery tool or substitute for such.
	time = 5 SECONDS

/datum/surgery_step/place_item/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE

/datum/surgery_step/place_item/proc/get_max_wclass(datum/surgery/surgery)
	switch(surgery.affected_limb.name)
		if("head")
			return SIZE_TINY
		if("chest")
			return SIZE_MEDIUM
		if("groin")
			return SIZE_SMALL

/datum/surgery_step/place_item/tool_check(mob/user, obj/item/tool, datum/surgery/surgery)
	. = ..()
	if(.)
		if(is_surgery_tool(tool)) //Make sure you still have all your tools after a surgery.
			return FALSE
		if(HAS_TRAIT(tool, TRAIT_ITEM_NOT_IMPLANTABLE))
			return FALSE
		if(tool.w_class > get_max_wclass(surgery))
			to_chat(user, SPAN_WARNING("[tool] is too big to implant into [surgery.target]'s [surgery.affected_limb.cavity]!"))
			return FALSE

/datum/surgery_step/place_item/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin implanting \the [tool] into [target]'s [surgery.affected_limb.cavity]."),
		SPAN_NOTICE("[user] begins implanting \the [tool] into your [surgery.affected_limb.cavity]."),
		SPAN_NOTICE("[user] begins implanting \the [tool] into [target]'s [surgery.affected_limb.cavity]."))

	target.custom_pain("The pain in your [surgery.affected_limb.cavity] is living hell!", 1)
	log_interact(user, target, "[key_name(user)] started to put \the [tool] inside [key_name(target)]'s [surgery.affected_limb.cavity].")

/datum/surgery_step/place_item/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You implant \the [tool] into [target]'s [surgery.affected_limb.cavity]."),
		SPAN_NOTICE("[user] implants \the [tool] into your [surgery.affected_limb.cavity]."),
		SPAN_NOTICE("[user] implants \the [tool] into [target]'s [surgery.affected_limb.cavity]."))

	log_interact(user, target, "[key_name(user)] put \the [tool] inside [key_name(target)]'s [surgery.affected_limb.cavity].")

	if(tool.w_class >= SIZE_SMALL)
		to_chat(user, SPAN_WARNING("You tear some blood vessels trying to fit such a bulky object in the cavity."))
		log_interact(user, target, "[key_name(user)] damaged some blood vessels while putting \the [tool] inside [key_name(target)]'s [surgery.affected_limb.cavity].")

		var/datum/wound/internal_bleeding/I = new (0)
		surgery.affected_limb.add_bleeding(I, TRUE)
		surgery.affected_limb.wounds += I
		surgery.affected_limb.owner.custom_pain("You feel something rip in your [surgery.affected_limb.display_name]!", 1)

	user.drop_inv_item_to_loc(tool, target)
	surgery.affected_limb.hidden = tool

/datum/surgery_step/place_item/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [surgery.affected_limb.cavity] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside your [surgery.affected_limb.cavity] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [surgery.affected_limb.cavity] with \the [tool]!"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to implant \the [tool] into [key_name(target)]'s [surgery.affected_limb.cavity].")
	return FALSE

//------------------------------------

/datum/surgery_step/remove_implant
	name = "Remove Embedded Implant"
	desc = "remove an implant"
	tools = SURGERY_TOOLS_PINCH
	time = 5 SECONDS

/datum/surgery_step/remove_implant/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE

/datum/surgery_step/remove_implant/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.hidden) //Perhaps it self-deleted in the meantime.
		user.affected_message(target,
			SPAN_NOTICE("You attempt to get a grip on \the [surgery.affected_limb.hidden] implanted in [target]'s [surgery.affected_limb.cavity] with \the [tool]."),
			SPAN_NOTICE("[user] attempt to get a grip on \the [surgery.affected_limb.hidden] implanted in your [surgery.affected_limb.cavity] with \the [tool]."),
			SPAN_NOTICE("[user] attempt to get a grip on \the [surgery.affected_limb.hidden] implanted in [target]'s [surgery.affected_limb.cavity] with \the [tool]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You start poking around inside [target]'s [surgery.affected_limb.cavity] with \the [tool]."),
			SPAN_NOTICE("[user] starts poking around inside your [surgery.affected_limb.cavity] with \the [tool]."),
			SPAN_NOTICE("[user] starts poking around inside [target]'s [surgery.affected_limb.cavity] with \the [tool]."))

	target.custom_pain("The pinching and tugging in your [surgery.affected_limb.cavity] is agonizing!", 1)
	log_interact(user, target, "[key_name(user)] started poking around inside the incision on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/remove_implant/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.hidden)
		user.affected_message(target,
			SPAN_NOTICE("You extract \the [surgery.affected_limb.hidden] from [target]'s [surgery.affected_limb.cavity]."),
			SPAN_NOTICE("[user] extracts \the [surgery.affected_limb.hidden] from your [surgery.affected_limb.cavity]."),
			SPAN_NOTICE("[user] extracts \the [surgery.affected_limb.hidden] from [target]'s [surgery.affected_limb.cavity]."))

		log_interact(user, target, "[key_name(user)] removed something from [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool].")

		surgery.affected_limb.hidden.forceMove(get_turf(target))
		surgery.affected_limb.hidden.blood_color = target.get_blood_color()
		surgery.affected_limb.hidden.update_icon()
		surgery.affected_limb.hidden = null
	else
		user.affected_message(target,
			SPAN_NOTICE("You could not find anything inside [target]'s [surgery.affected_limb.cavity]."),
			SPAN_NOTICE("[user] could not find anything inside your [surgery.affected_limb.cavity]."),
			SPAN_NOTICE("[user] could not find anything inside [target]'s [surgery.affected_limb.cavity]."))

		log_interact(user, target, "[key_name(user)] found nothing inside [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool].")

/datum/surgery_step/remove_implant/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [surgery.affected_limb.cavity] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside your [surgery.affected_limb.cavity] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [surgery.affected_limb.cavity] with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] damaged the inside of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

	target.apply_damage(10, BRUTE, target_zone)
	return FALSE

//------------------------------------

/datum/surgery_step/cauterize/close_cavity
	name = "Cauterize Implant Cavity"
	desc = "seal the implant cavity"
	time = 5 SECONDS

/datum/surgery_step/cauterize/close_cavity/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin sealing the implant pocket in [target]'s [surgery.affected_limb.cavity] with \the [tool]."),
		SPAN_NOTICE("[user] begins to seal the implant pocket in your [surgery.affected_limb.cavity] with \the [tool]."),
		SPAN_NOTICE("[user] begins to seal the implant pocket in [target]'s [surgery.affected_limb.cavity] with \the [tool]."))

	target.custom_pain("Your [surgery.affected_limb.cavity] is on fire!", 1)
	log_interact(user, target, "[key_name(user)] started to mend [key_name(target)]'s [surgery.affected_limb.cavity] wall with \the [tool].")

/datum/surgery_step/cauterize/close_cavity/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You mend [target]'s [surgery.affected_limb.cavity] wall."),
		SPAN_NOTICE("[user] mends your [surgery.affected_limb.cavity] wall."),
		SPAN_NOTICE("[user] mends [target]'s [surgery.affected_limb.cavity] wall."))

	log_interact(user, target, "[key_name(user)] mended [key_name(target)]'s [surgery.affected_limb.cavity] wall with \the [tool], ending [surgery].")

/datum/surgery_step/cauterize/close_cavity/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, scorching [target]'s [surgery.affected_limb.cavity] wall with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scorching your [surgery.affected_limb.cavity] wall with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scorching [target]'s [surgery.affected_limb.cavity] wall with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to mend [key_name(target)]'s [surgery.affected_limb.cavity] wall with \the [tool].")

	target.apply_damage(10, BURN, target_zone)
	return FALSE


//////////////////////////////////////////////////////////////////
// EMBEDDED ITEM REMOVAL SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/embedded
	name = "Embedded Object Removal Surgery"
	priority = SURGERY_PRIORITY_LOW
	invasiveness = list(SURGERY_DEPTH_SHALLOW, SURGERY_DEPTH_DEEP)
	steps = list(/datum/surgery_step/remove_embedded)
	lying_required = FALSE
	self_operable = TRUE
	pain_reduction_required = PAIN_REDUCTION_LIGHT //This is Yank Object without the damage or IB risk.
	required_surgery_skill = SKILL_SURGERY_NOVICE

/datum/surgery/embedded/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return length(L.implants)

//------------------------------------

/datum/surgery_step/remove_embedded
	name = "Remove Foreign Body"
	desc = "extract a foreign body"
	tools = SURGERY_TOOLS_PINCH
	time = 5 SECONDS

/datum/surgery_step/remove_embedded/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start poking around inside the incision on [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] starts poking around inside the incision on your [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] starts poking around inside the incision on [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

	target.custom_pain("The poking and prying inside your [surgery.affected_limb.display_name] is unpleasant.")
	log_interact(user, target, "[key_name(user)] started poking around inside the incision on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/remove_embedded/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(length(surgery.affected_limb.implants))
		var/list/shrapnel = list()
		for(var/obj/item/shard/shrap in surgery.affected_limb.implants)
			shrapnel += shrap

		if(length(shrapnel))
			user.affected_message(target,
				SPAN_NOTICE("You extract the shrapnel from [target]'s [surgery.affected_limb.display_name]."),
				SPAN_NOTICE("[user] extracts the shrapnel from your [surgery.affected_limb.display_name]."),
				SPAN_NOTICE("[user] extracts the shrapnel from [target]'s [surgery.affected_limb.display_name]."))
			for(var/obj/item/shard/S as anything in shrapnel)
				S.forceMove(target.loc)
				surgery.affected_limb.implants -= S
				target.embedded_items -= S
				for(var/i in 1 to S.count-1)
					user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
					var/shrap = new S.type(S.loc)
					QDEL_IN(shrap, 30 SECONDS)
				user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
				QDEL_IN(S, 30 SECONDS)
		else
			var/obj/item/obj = surgery.affected_limb.implants[1]

			user.affected_message(target,
				SPAN_NOTICE("You extract \the [obj] from [target]'s [surgery.affected_limb.display_name]."),
				SPAN_NOTICE("[user] extracts \the [obj] from your [surgery.affected_limb.display_name]."),
				SPAN_NOTICE("[user] extracts \the [obj] from [target]'s [surgery.affected_limb.display_name]."))

			surgery.affected_limb.implants -= obj
			obj.forceMove(get_turf(target))

			if(istype(obj, /obj/item/implant))
				var/obj/item/implant/imp = obj
				imp.imp_in = null
				imp.implanted = 0

			if(is_sharp(obj))
				target.embedded_items -= obj
				user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)

			log_interact(user, target, "[key_name(user)] removed [obj] from [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")
	else
		user.affected_message(target,
			SPAN_NOTICE("You could not find anything inside [target]'s [surgery.affected_limb.display_name]."),
			SPAN_NOTICE("[user] could not find anything inside your [surgery.affected_limb.display_name]."),
			SPAN_NOTICE("[user] could not find anything inside [target]'s [surgery.affected_limb.display_name]."))

		log_interact(user, target, "[key_name(user)] found nothing inside [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/remove_embedded/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [surgery.affected_limb.display_name] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside your [surgery.affected_limb.display_name] with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [surgery.affected_limb.display_name] with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] damaged the inside of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

	target.apply_damage(10, BRUTE, target_zone)
	if(length(surgery.affected_limb.implants) && prob(10 + 100 * (tools[tool_type] - 1)))
		var/obj/item/implant/imp = surgery.affected_limb.implants[1]
		if(istype(imp))
			target.visible_message(SPAN_WARNING("Something beeps inside [target]'s [surgery.affected_limb.display_name]!"))
			playsound(target, 'sound/items/countdown.ogg', 25, TRUE)
			addtimer(CALLBACK(imp, TYPE_PROC_REF(/obj/item/implant, activate)), 2.5 SECONDS)
	return FALSE
