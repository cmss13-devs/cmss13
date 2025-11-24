//Procedures in this file: Robotic limbs attachment
//////////////////////////////////////////////////////////////////
// ROBOLIMB SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/prosthetical_replacement
	name = "Attach Prosthetic Limb"
	steps = list(
		/datum/surgery_step/connect_prosthesis,
		/datum/surgery_step/strenghten_prosthesis_connection,
		/datum/surgery_step/calibrate_prosthesis,
	)
	possible_locs = EXTREMITY_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = NONE
	requires_bodypart = FALSE
	requires_bodypart_type = LIMB_AMPUTATED

//------------------------------------

/datum/surgery_step/connect_prosthesis
	name = "Connect Prosthesis"
	desc = "attach a prosthesis"
	tools = list(/obj/item/robot_parts = SURGERY_TOOL_MULT_IDEAL)
	time = 2 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/clothingrustle5.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
/datum/surgery_step/connect_prosthesis/tool_check(mob/user, obj/item/robot_parts/tool, datum/surgery/surgery)
	. = ..()
	if(. && (!tool.part || !(user.zone_selected in tool.part)))
		to_chat(user, SPAN_WARNING("\The [tool] cannot be used to replaced a missing [parse_zone(user.zone_selected)]"))
		return FALSE

/datum/surgery_step/connect_prosthesis/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/robot_parts/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin connecting \the [tool] to the prepared stump of [target]'s [parse_zone(target_zone)]."),
		SPAN_NOTICE("[user] begins connect \the [tool] to the prepared stump of your [parse_zone(target_zone)]."),
		SPAN_NOTICE("[user] begins to connect \the [tool] to the prepared stump of [target]'s [parse_zone(target_zone)]."))

	log_interact(user, target, "[key_name(user)] attempted to begin attaching a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/connect_prosthesis/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You replace [target]'s severed [parse_zone(target_zone)] with \the [tool]."),
		SPAN_NOTICE("[user] replaces your severed [parse_zone(target_zone)] with \the [tool]."),
		SPAN_NOTICE("[user] replaces [target]'s severed [parse_zone(target_zone)] with \the [tool]."))

	surgery.affected_limb.robotize(surgery_in_progress = TRUE, uncalibrated = TRUE, synth_skin = issynth(target))
	target.update_body()
	target.pain.recalculate_pain()

	user.temp_drop_inv_item(tool)
	qdel(tool)
	log_interact(user, target, "[key_name(user)] successfully began attaching a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name], starting [surgery].")

/datum/surgery_step/connect_prosthesis/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging [target]'s stump!"),
		SPAN_WARNING("[user] slips, damaging your stump!"),
		SPAN_WARNING("[user] slips, damaging [target]'s stump!"))

	target.apply_damage(10, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to begin attaching a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/strenghten_prosthesis_connection
	name = "Tighten Prosthesis Connections"
	desc = "tighten the prosthesis"
	accept_hand = TRUE
	time = 3 SECONDS
	tools = SURGERY_TOOLS_PINCH
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/retractor1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/strenghten_prosthesis_connection/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start tightening [target]'s new prosthetic [parse_zone(target_zone)]'s connection to \his body."),
		SPAN_NOTICE("[user] starts to tighten your new prosthetic [parse_zone(target_zone)]'s connection to your body."),
		SPAN_NOTICE("[user] starts to tighten [target]'s new prosthetic [parse_zone(target_zone)]'s connection to \his body."))

	log_interact(user, target, "[key_name(user)] began tightening a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/strenghten_prosthesis_connection/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You firmly attach the prosthesis to [target]'s body."),
		SPAN_NOTICE("[user] firmly attaches the prosthesis to your body."),
		SPAN_NOTICE("[user] firmly attaches the prosthesis to [target]'s body."))

	log_interact(user, target, "[key_name(user)] finished tightening a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/strenghten_prosthesis_connection/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/nerves_type = target.get_nerves_type()
	if(nerves_type == "nervous system") //pinching someone's entire nervous system wouldn't make sense
		nerves_type = "stump"
	var/pain = (target.species && (target.species.flags & IS_SYNTHETIC)) ? "" : " painfully"
	user.affected_message(target,
		SPAN_WARNING("You slip while trying to tighten [target]'s prosthesis, pinching \his [nerves_type][pain]!"),
		SPAN_WARNING("[user] slips while trying to tighten the prosthesis, pinching your [nerves_type][pain]!"),
		SPAN_WARNING("[user] slips while trying to tighten [target]'s prosthesis, pinching \his [nerves_type][pain]!"))

	log_interact(user, target, "[key_name(user)] failed to tighten a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name].")
	return FALSE

//------------------------------------

/datum/surgery_step/calibrate_prosthesis
	name = "Calibrate Prosthesis"
	desc = "calibrate the prosthesis"
	accept_hand = TRUE
	time = 2.5 SECONDS
	tools = SURGERY_TOOLS_PINCH
	preop_sound = 'sound/items/Screwdriver.ogg'
	success_sound = 'sound/handling/click_2.ogg'
	failure_sound = 'sound/items/Screwdriver2.ogg'

/datum/surgery_step/calibrate_prosthesis/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/nerves_type = target.get_nerves_type()
	user.affected_message(target,
		SPAN_NOTICE("You start calibrating [target]'s prosthesis to \his [nerves_type]."),
		SPAN_NOTICE("[user] starts calibrating your prosthesis to your [nerves_type]."),
		SPAN_NOTICE("[user] starts calibrating [target]'s prosthesis to \his [nerves_type]."))

	log_interact(user, target, "[key_name(user)] began calibrating a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/calibrate_prosthesis/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish calibrating [target]'s prosthesis, and it now moves as \he commands."),
		SPAN_NOTICE("[user] finishes calibrating your prosthesis, and it now moves as you command."),
		SPAN_NOTICE("[user] finishes calibrating [target]'s prosthesis, and it now moves as \he commands."))

	log_interact(user, target, "[key_name(user)] calibrated a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	surgery.affected_limb.calibrate_prosthesis()

/datum/surgery_step/calibrate_prosthesis/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/failure_mode
	if(target_zone in HANDLING_LIMBS) //Arm/hand
		failure_mode = pick("flails wildly", "gestures rudely", "attempts to throttle its owner")
	else //Leg/foot
		failure_mode = pick("kicks wildly", "contorts inhumanly", "almost crushes something with its toes")

	user.affected_message(target,
		SPAN_WARNING("You make a mistake calibrating the prosthetic [parse_zone(target_zone)], and it [failure_mode]!"),
		SPAN_WARNING("[user] makes a mistake calibrating the prosthetic [parse_zone(target_zone)], and it [failure_mode]!"),
		SPAN_WARNING("[user] makes a mistake calibrating the prosthetic [parse_zone(target_zone)], and it [failure_mode]!"))

	log_interact(user, target, "[key_name(user)] failed to calibrate a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name].")
	return FALSE
