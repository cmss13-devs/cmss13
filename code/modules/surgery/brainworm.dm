/datum/surgery/borer_removal
	name = "Experimental Cranial Parasite Removal"
	priority = SURGERY_PRIORITY_MAXIMUM
	possible_locs = list("head")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	pain_reduction_required = PAIN_REDUCTION_MEDIUM
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/remove_borer,
	)

/datum/surgery/borer_removal/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	if(!locate(/obj/structure/machinery/optable) in get_turf(patient))
		return FALSE

	return patient.has_brain_worms()

//------------------------------------

/datum/surgery_step/remove_borer
	name = "Remove Cranial Parasite"
	desc = "extract the cranial parasite"
	accept_hand = TRUE
	/*Similar to PINCH, but balanced around 100 = using bare hands. Haemostat is faster and better,
	other tools are slower but don't burn the surgeon.*/
	tools = list(
		/obj/item/tool/surgery/hemostat = 1.5,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_SUBSTITUTE
		)
	time = 6 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	failure_sound = 'sound/effects/acid_sizzle2.ogg'

/datum/surgery_step/remove_borer/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/mob/living/carbon/cortical_borer/parasite = target.borer
	if(parasite)
		to_chat(parasite, SPAN_HIGHDANGER("[user] is attempting to extract you from your host's head!"))
	else return FALSE
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("You try to extract the parasite from [target]'s head with \the [tool]."),
			SPAN_NOTICE("[user] tries to extract the parasite from your head with \the [tool]."),
			SPAN_NOTICE("[user] tries to extract the parasite from [target]'s head with \the [tool]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You try to extract the parasite from [target]'s head."),
			SPAN_NOTICE("[user] tries to extract the parasite from your head."),
			SPAN_NOTICE("[user] tries to extract the parasite from [target]'s head."))

	target.custom_pain("Something hurts horribly in your head!",1)
	log_interact(user, target, "[key_name(user)] started to remove a borer from [key_name(target)]'s skull.")

/datum/surgery_step/remove_borer/success(mob/living/carbon/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/mob/living/carbon/cortical_borer/parasite = target.borer
	if(parasite)
		user.affected_message(target,
			SPAN_WARNING("You pull a wriggling parasite out of [target]'s head!"),
			SPAN_WARNING("[user] pulls a wriggling parasite out of [target]'s head!"),
			SPAN_WARNING("[user] pulls a wriggling parasite out of [target]'s head!"))

		user.count_niche_stat(STATISTICS_NICHE_SURGERY_LARVA)
		to_chat(parasite, SPAN_HIGHDANGER("You are ripped forcibly from your host's head!"))
		parasite.leave_host()

		log_interact(user, target, "[key_name(user)] removed a parasite from [key_name(target)]'s head with [tool ? "\the [tool]" : "their hands"], ending [surgery].")

/datum/surgery_step/remove_borer/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, bruising [target]'s brain!"),
		SPAN_WARNING("[user]'s hand slips, bruising your brain!"),
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s brain!"))

	target.apply_damage(10, BRAIN)
	if(target.stat == CONSCIOUS)
		target.emote("scream")
	target.apply_damage(15, BURN, target_zone)
	log_interact(user, target, "[key_name(user)] failed to remove a parasite from [key_name(target)]'s head with [tool ? "\the [tool]" : "their hands"].")
	return FALSE
