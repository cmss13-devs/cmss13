/* WELCOME TO TEND WOUNDS GENTLEMEN, UNFORTUNATELY YOUR CHANCES OF REVIVAL ARE LOW,
PFCS MAY EVEN TANTRUM AGAINST YOUR MEDICS AS 400 BRUTE CORPSES, BUT YOU HAVE MY WORD THAT I
WILL USE MY SURGERY 1 SKILLS TO ENSURE YOUR BODIES ARE SUB-200 DAMAGE. THIS IS THE GREATEST
SURGERY, EVEN MORE THAN LARVA REMOVAL, FOR THE FATE OF YOUR DEFIB IS A 5 MINUTE CONCERN.
NOW COME, RETURN TO CORPSE, STRIKE DOWN THE OB DAMAGE THAT BEAT AGAINST YOU, ALLOW US TO TREAT
YOU TO 200 DAMAGE. I ASK NOT FOR MY OWN MEDIC EGOSTROKING, BUT FOR THE GOOD OF THE ROUND. */

/datum/surgery/tend_wounds
	name = "Tend Limb Damage (Brute/Burn)"
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = PAIN_REDUCTION_MEDIUM
	steps = list(/datum/surgery_step/tend_wounds)
	lying_required = FALSE
	self_operable = TRUE

/datum/surgery/tend_wounds/can_start(mob/user, mob/living/carbon/patient, var/obj/limb/L, obj/item/tool)
	return L.brute_dam > 0 || L.burn_dam > 0

//For closing an open incision first.
/datum/surgery/tend_wounds/open
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	steps = list(
		/datum/surgery_step/tend_wounds/suture_incision,
		/datum/surgery_step/tend_wounds
		)

//------------------------------------

/datum/surgery_step/tend_wounds
	name = "Tend Wounds"
	desc = "tend the wounds"
	tools = SURGERY_TOOLS_SUTURE
	time = 2 SECONDS //Heals 5 brute & 5 burn per second.
	repeat_step = TRUE

/datum/surgery_step/tend_wounds/repeat_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.brute_dam > 0 || surgery.affected_limb.burn_dam > 0)
		return TRUE
	return FALSE

/datum/surgery_step/tend_wounds/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to suture and tend the wounds on [target]'s [parse_zone(target_zone)] with \the [tool]."),
		SPAN_NOTICE("[user] begins to suture and tend the wounds on your [parse_zone(target_zone)] with \the [tool]."),
		SPAN_NOTICE("[user] begins to suture and tend the wounds on [target]'s [parse_zone(target_zone)] with \the [tool]."))

	target.custom_pain("It feels like your [surgery.affected_limb.display_name] is being stabbed with needles - because it is!")
	log_interact(user, target, "[key_name(user)] began tending wounds in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], starting [surgery].")

/datum/surgery_step/tend_wounds/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	surgery.affected_limb.heal_damage(10, 10)

	if(surgery.affected_limb.brute_dam <= 0 && surgery.affected_limb.burn_dam <= 0)
		user.affected_message(target,
			SPAN_NOTICE("You finish treating the wounds on [target]'s [parse_zone(target_zone)]."),
			SPAN_NOTICE("[user] finishes treating the wounds on your [parse_zone(target_zone)]."),
			SPAN_NOTICE("[user] finishes treating the wounds on [target]'s [parse_zone(target_zone)]."))

		surgery.affected_limb.remove_all_bleeding(TRUE, FALSE)
		log_interact(user, target, "[key_name(user)] finished tending wounds in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")
	else
		user.affected_message(target,
			SPAN_NOTICE("You treat some of the injuries on [target]'s [parse_zone(target_zone)]."),
			SPAN_NOTICE("[user] treats some of the injuries on your [parse_zone(target_zone)]."),
			SPAN_NOTICE("[user] treats some of the injuries on [target]'s [parse_zone(target_zone)]."))

		log_interact(user, target, "[key_name(user)] tended some wounds in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/tend_wounds/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to tend wounds in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], possibly ending [surgery].")
	return TRUE	 //As a one-step surgery failing would end it anyway, but this is necessary if using this step in a longer surgery.

//------------------------------------

/datum/surgery_step/tend_wounds/suture_incision
	name = "Suture Incision"
	desc = "suture the incision"
	//Suturing incisions closed is distinctly faster than cauterise-swaphand-suture, but slower than cautery alone, meaning it's only better if wanting to both close and suture the incision.
	time = 3.5 SECONDS

/datum/surgery_step/tend_wounds/suture_incision/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to suture the incision on [target]'s [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] begins to suture the incision on your [surgery.affected_limb.display_name] with \the [tool]."),
		SPAN_NOTICE("[user] begins to suture the incision on [target]'s [surgery.affected_limb.display_name] with \the [tool]."))

	target.custom_pain("It feels like your [surgery.affected_limb.display_name] is being stabbed with needles - because it is!")
	log_interact(user, target, "[key_name(user)] began suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/tend_wounds/suture_incision/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	surgery.affected_limb.heal_damage(10, 10)

	if(surgery.affected_limb.brute_dam <= 0 && surgery.affected_limb.burn_dam <= 0)
		user.affected_message(target,
			SPAN_NOTICE("You close the incision on [target]'s [surgery.affected_limb.display_name] with a line of neat sutures."),
			SPAN_NOTICE("[user] closes the incision on your [surgery.affected_limb.display_name] with a line of neat sutures."),
			SPAN_NOTICE("[user] closes the incision on [target]'s [surgery.affected_limb.display_name] with a line of neat sutures."))

		surgery.affected_limb.remove_all_bleeding(TRUE, FALSE)
		log_interact(user, target, "[key_name(user)] finished suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")
	else
		user.affected_message(target,
			SPAN_NOTICE("You close the incision on [target]'s [surgery.affected_limb.display_name] with a line of neat sutures, but some injuries remain."),
			SPAN_NOTICE("[user] closes the incision on your [surgery.affected_limb.display_name] with a line of neat sutures, but some injuries remain."),
			SPAN_NOTICE("[user] closes the incision on [target]'s [surgery.affected_limb.display_name] with a line of neat sutures, but some injuries remain."))

		log_interact(user, target, "[key_name(user)] finished suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], beginning [surgery].")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	target.pain.recalculate_pain()
	surgery.status++ //It will then either try to loop, using the next (normal suturing) step, or fail to loop because there's no damage, increment status again, and end the surgery.

/datum/surgery_step/tend_wounds/suture_incision/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to tend wounds in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], possibly ending [surgery].")
	return FALSE //Normal suturing is done on incision-less limbs; don't want people failing to close an incision but being able to suture anyway.
