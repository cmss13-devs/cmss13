/**
* Surgery to change the voice of TTS.
* Below are the operations for organics and IPC.
*/

// Surgery for organics
/datum/surgery/vocal_cords_surgery
	name = "Vocal Cords Tuning Surgery"
	invasiveness = list(SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_MEDIUM
	steps = list(
		/datum/surgery_step/incision,
		/datum/surgery_step/clamp_bleeders_step,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/tune_vocal_cords,
		/datum/surgery_step/cauterize,
	)
	possible_locs = list("mouth")


/datum/surgery/vocal_cords_surgery/can_start(mob/user, mob/living/carbon/target)
	return TRUE
	// if(ishuman(target))
	// 	return TRUE
	// return FALSE

/datum/surgery_step/tune_vocal_cords
	name = "tune vocal cords"
	time = 6 SECONDS
	var/target_vocal = "vocal cords"

/datum/surgery_step/tune_vocal_cords/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message("[user] begins to tune [target]'s vocals.", span_notice("You begin to tune [target]'s vocals..."))
	..()

/datum/surgery_step/tune_vocal_cords/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.change_tts_seed(user, FALSE, TRUE)
	user.visible_message("[user] tunes [target]'s vocals completely!", span_notice("You tune [target]'s vocals completely."))
	return TRUE

/datum/surgery_step/tune_vocal_cords/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(span_warning("[user]'s hand slips, tearing [target_vocal] in [target]'s throat with [tool]!"), \
						span_warning("Your hand slips, tearing [target_vocal] in [target]'s throat with [tool]!"))
	target.AddComponent(/datum/component/tts_component, SStts220.get_random_seed(target))
	target.apply_damage(15, BRUTE, target_zone)
	return FALSE
