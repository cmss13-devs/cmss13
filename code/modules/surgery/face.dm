//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
// FACE SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/face_fix
	name = "Facial Reconstruction"
	possible_locs = list("mouth")
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/facial_incision,
		/datum/surgery_step/mend_vocals,
		/datum/surgery_step/pull_skin,
		/datum/surgery_step/cauterize/close_facial_incision,
	)

/datum/surgery/face_fix/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	var/obj/limb/head/H = L
	return H && H.disfigured

//------------------------------------

/datum/surgery_step/facial_incision
	name = "Make Facial Incision"
	desc = "make facial incisions"
	tools = SURGERY_TOOLS_INCISION
	time = 4 SECONDS

/datum/surgery_step/facial_incision/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start to cut open [target]'s face and neck with \the [tool]."),
		SPAN_NOTICE("[user] starts to cut open your face and neck with \the [tool]."),
		SPAN_NOTICE("[user] starts to cut open [target]'s face and neck with \the [tool]."))

	log_interact(user, target, "[key_name(user)] began to cut open [key_name(target)]'s face and neck with \the [tool].")
	target.custom_pain("Your face is being cut apart!", 1)

/datum/surgery_step/facial_incision/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You finish opening incisions on [target]'s face and neck."),
		SPAN_NOTICE("[user] finishes opening incisions on your face and neck."),
		SPAN_NOTICE("[user] finishes opening incisions on [target]'s face and neck."))

	target.incision_depths[target_zone] = SURGERY_DEPTH_SHALLOW
	log_interact(user, target, "[key_name(user)] cut open [key_name(target)]'s face and neck with \the [tool].")

/datum/surgery_step/facial_incision/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_DANGER("Your hand slips, slicing [target]'s throat wth \the [tool]!"),
		SPAN_DANGER("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!"),
		SPAN_DANGER("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to cut open [key_name(target)]'s face and neck with \the [tool].")

	target.apply_damage(40, BRUTE, target_zone)
	target.losebreath += 20
	user.add_blood(target.get_blood_color(), BLOOD_BODY|BLOOD_HANDS)
	return FALSE

//------------------------------------

/datum/surgery_step/mend_vocals
	name = "Mend Vocal Cords"
	desc = "mend the vocal cords"
	tools = SURGERY_TOOLS_PINCH
	time = 3 SECONDS

/datum/surgery_step/mend_vocals/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start mending [target]'s vocal cords with \the [tool]."),
		SPAN_NOTICE("[user] starts to mend your vocal cords with \the [tool]."),
		SPAN_NOTICE("[user] starts to mend [target]'s vocal cords with \the [tool]."))

	log_interact(user, target, "[key_name(user)] began to mend [key_name(target)]'s vocal cords with \the [tool].")
	target.custom_pain("The insides of your throat are being pinched and pulled at!", 1)

/datum/surgery_step/mend_vocals/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You mend [target]'s vocal cords."),
		SPAN_NOTICE("[user] mends your vocal cords."),
		SPAN_NOTICE("[user] mends [target]'s vocal cords."))

	log_interact(user, target, "[key_name(user)] mended [key_name(target)]'s vocal cords with \the [tool].")

/datum/surgery_step/mend_vocals/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, clamping [user]'s trachea shut for a moment with \the [tool]!"),
		SPAN_DANGER("[user]'s hand slips, clamping your trachea shut for a moment with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, clamping [target]'s trachea shut for a moment with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to mend [key_name(target)]'s vocal cords with \the [tool].")

	target.losebreath += 10
	return FALSE

//------------------------------------

/datum/surgery_step/pull_skin
	name = "Reconstruct Facial Features"
	desc = "reconstruct the face"
	tools = SURGERY_TOOLS_PRY_DELICATE
	time = 3 SECONDS

/datum/surgery_step/pull_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start pulling the skin on [target]'s face back into shape with \the [tool]."),
		SPAN_NOTICE("[user] starts to pull the skin on your face back into shape with \the [tool]."),
		SPAN_NOTICE("[user] starts to pull the skin on [target]'s face back into shape with \the [tool]."))

	log_interact(user, target, "[key_name(user)] began to pull the skin on [key_name(target)]'s face back in place with \the [tool].")
	target.custom_pain("Your face hurts!", 1)

/datum/surgery_step/pull_skin/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You reconstruct [target]'s facial features."),
		SPAN_NOTICE("[user] reconstructs your facial features."),
		SPAN_NOTICE("[user] reconstructs [target]'s facial features."))

	log_interact(user, target, "[key_name(user)] pulled the skin on [key_name(target)]'s face back in place with \the [tool].")

/datum/surgery_step/pull_skin/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, tearing skin on [target]'s face with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, tearing skin on your face with \the [tool]!"),
		SPAN_WARNING("[user]'s hand slips, tearing skin on [target]'s face with \the [tool]!"))

	log_interact(user, target, "[key_name(user)] failed to pull the skin on [key_name(target)]'s face back in place with \the [tool].")

	target.apply_damage(10, BRUTE, target_zone)
	return FALSE

//------------------------------------

/datum/surgery_step/cauterize/close_facial_incision
	name = "Close Facial Incisions"
	desc = "close the facial incisions"
	time = 5 SECONDS

/datum/surgery_step/cauterize/close_facial_incision/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to cauterize the incisions on [target]'s face and neck with \the [tool]."),
		SPAN_NOTICE("[user] begins to cauterize the incisions on your face and neck with \the [tool]."),
		SPAN_NOTICE("[user] begins to cauterize the incisions on [target]'s face and neck with \the [tool]."))

	target.custom_pain("Your face is being burned!", 1)

	log_interact(user, target, "[key_name(user)] began to cauterize [key_name(target)]'s face and neck with \the [tool].")

/datum/surgery_step/cauterize/close_facial_incision/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You cauterize the incisions on [target]'s face and neck."),
		SPAN_NOTICE("[user] cauterizes the incisions on your face and neck."),
		SPAN_NOTICE("[user] cauterizes the incision on [target]'s face and neck."))

	log_interact(user, target, "[key_name(user)] cauterized [key_name(target)]'s face and neck with \the [tool], ending [surgery].")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	surgery.affected_limb.remove_all_bleeding(TRUE)
	var/obj/limb/head/H = surgery.affected_limb
	H.disfigured = FALSE
	H.owner.name = H.owner.get_visible_name()

/datum/surgery_step/cauterize/close_facial_incision/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, leaving a small burn on [target]'s face!"),
		SPAN_WARNING("[user]'s hand slips, leaving a small burn on your face!"),
		SPAN_WARNING("[user]'s hand slips, leaving a small burn on [target]'s face!"))

	log_interact(user, target, "[key_name(user)] failed to cauterize [key_name(target)]'s face and neck with \the [tool].")

	target.apply_damage(5, BURN, target_zone)
	return FALSE
