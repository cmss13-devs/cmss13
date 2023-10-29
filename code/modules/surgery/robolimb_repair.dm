//Procedures in this file: Robotic limbs recalibration
//////////////////////////////////////////////////////////////////
// ROBOLIMB REPAIR //
//////////////////////////////////////////////////////////////////

/datum/surgery/prosthetic_recalibration
	name = "Recalibrate Prosthetic Limb"
	steps = list(/datum/surgery_step/recalibrate_prosthesis)
	possible_locs = EXTREMITY_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = NONE
	requires_bodypart = TRUE
	requires_bodypart_type = LIMB_ROBOT
	lying_required = FALSE

/datum/surgery/prosthetic_recalibration/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	if(L.status & LIMB_UNCALIBRATED_PROSTHETIC)
		return TRUE
	return FALSE

//------------------------------------

/datum/surgery_step/recalibrate_prosthesis
	name = "Recalibrate Prosthesis"
	desc = "recalibrate the prosthesis"
	accept_hand = TRUE
	time = 2.5 SECONDS
	tools = SURGERY_TOOLS_PINCH
	preop_sound = 'sound/items/Screwdriver.ogg'
	success_sound = 'sound/handling/click_2.ogg'
	failure_sound = 'sound/items/Screwdriver2.ogg'

/datum/surgery_step/recalibrate_prosthesis/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/nerves = (target.species && (target.species.flags & IS_SYNTHETIC)) ? "control wiring" : "nervous system"
	user.affected_message(target,
		SPAN_NOTICE("You start recalibrating [target]'s prosthesis to \his [nerves]."),
		SPAN_NOTICE("[user] starts recalibrating your prosthesis to your [nerves]."),
		SPAN_NOTICE("[user] starts recalibrating [target]'s prosthesis to \his [nerves]."))

	log_interact(user, target, "[key_name(user)] began recalibrating a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/recalibrate_prosthesis/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish recalibrating [target]'s prosthesis, and it now moves as \he commands once again."),
		SPAN_NOTICE("[user] finishes recalibrating your prosthesis, and it now moves as you command once again."),
		SPAN_NOTICE("[user] finishes recalibrating [target]'s prosthesis, and it now moves as \he commands once again."))

	log_interact(user, target, "[key_name(user)] recalibrated a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	if(surgery.affected_limb.parent.status & LIMB_UNCALIBRATED_PROSTHETIC)
		surgery.affected_limb.parent.calibrate_prosthesis()
	else
		surgery.affected_limb.calibrate_prosthesis()

/datum/surgery_step/recalibrate_prosthesis/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/failure_mode
	if(target_zone in HANDLING_LIMBS) //Arm/hand
		failure_mode = pick("flails wildly", "gestures rudely", "attempts to throttle its owner")
	else //Leg/foot
		failure_mode = pick("kicks wildly", "contorts inhumanly", "almost crushes something with its toes")

	user.affected_message(target,
		SPAN_WARNING("You make a mistake recalibrating the prosthetic [parse_zone(target_zone)], and it [failure_mode]!"),
		SPAN_WARNING("[user] makes a mistake recalibrating the prosthetic [parse_zone(target_zone)], and it [failure_mode]!"),
		SPAN_WARNING("[user] makes a mistake recalibrating the prosthetic [parse_zone(target_zone)], and it [failure_mode]!"))

	log_interact(user, target, "[key_name(user)] failed to recalibrate a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name].")
	return FALSE

//------------------------------------
