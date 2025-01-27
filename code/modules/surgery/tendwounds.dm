//For closing an open incision first.
/datum/surgery/suture_incision
	name = "Suture Incision"
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = PAIN_REDUCTION_MEDIUM
	steps = list(/datum/surgery_step/suture_incision)
	lying_required = FALSE
	self_operable = TRUE

//------------------------------------

/datum/surgery_step/suture_incision
	name = "Suture Incision"
	desc = "suture the incision"
	tools = SURGERY_TOOLS_SUTURE
	//Suturing incisions closed is distinctly faster than cauterise-swaphand-suture, but slower than cautery alone, meaning it's only better if wanting to both close and suture the incision.
	time = 3.5 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/suture_incision/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to suture the incision on [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] begins to suture the incision on your [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] begins to suture the incision on [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

	target.custom_pain("It feels like your [surgery.affected_limb.display_name] is being stabbed with needles - because it is!")
	log_interact(user, target, "[key_name(user)] began suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/suture_incision/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/added_sutures = SEND_SIGNAL(surgery.affected_limb, COMSIG_LIMB_ADD_SUTURES, TRUE)
	if(!added_sutures) //No suture datum to answer the signal
/*
		new /datum/suture_handler(surgery.affected_limb)
*/
//RUCM START
		new /datum/suture_handler(surgery.affected_limb, tool, user, target)
//RUCM END
		added_sutures = SEND_SIGNAL(surgery.affected_limb, COMSIG_LIMB_ADD_SUTURES, TRUE) //This time, with feeling.

	if(added_sutures & SUTURED_FULLY)
		user.affected_message(target,
			SPAN_NOTICE("You close the incision on [target]'s [surgery.affected_limb.display_name] with a line of neat sutures."),
			SPAN_NOTICE("[user] closes the incision on your [surgery.affected_limb.display_name] with a line of neat sutures."),
			SPAN_NOTICE("[user] closes the incision on [target]'s [surgery.affected_limb.display_name] with a line of neat sutures."))

		log_interact(user, target, "[key_name(user)] finished suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")
	else
		user.affected_message(target,
			SPAN_NOTICE("You close the incision on [target]'s [surgery.affected_limb.display_name] with a line of neat sutures, but some injuries remain."),
			SPAN_NOTICE("[user] closes the incision on your [surgery.affected_limb.display_name] with a line of neat sutures, but some injuries remain."),
			SPAN_NOTICE("[user] closes the incision on [target]'s [surgery.affected_limb.display_name] with a line of neat sutures, but some injuries remain."))

		log_interact(user, target, "[key_name(user)] finished suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE

/datum/surgery_step/suture_incision/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to suture the incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE
