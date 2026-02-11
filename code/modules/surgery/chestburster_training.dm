
//////////////////////////////////////////////////////////////////
// LARVA SURGERY (practice) //
//////////////////////////////////////////////////////////////////

/// Similar procedure to chestburster removal surgery, on an adorable plushy animal. To be used for training
/datum/surgery/chestburster_training
	name = "Practice Plushy Removal"
	priority = SURGERY_PRIORITY_MAXIMUM
	possible_locs = list("chest")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	pain_reduction_required = PAIN_REDUCTION_FULL
	required_surgery_skill = SKILL_SURGERY_NOVICE
	target_mobtypes = list(/mob/living/carbon/human/professor_dummy)
	steps = list(
		/datum/surgery_step/cut_larval_pseudoroots/training,
		/datum/surgery_step/remove_larva/training,
	)

/datum/surgery/chestburster_training/can_start(mob/user, mob/living/carbon/patient)
	if(!locate(/obj/structure/machinery/optable) in get_turf(patient))
		return FALSE

	if(patient.mob_flags & EASY_SURGERY && locate(/obj/item/toy/plush) in patient)
		return TRUE

//------------------------------------

/datum/surgery_step/cut_larval_pseudoroots/training
	name = "Loosen fluffy talons"
	desc = "gently loosen the plush's grip on vital organs"

/datum/surgery_step/cut_larval_pseudoroots/training/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool)
	user.affected_message(target,
		SPAN_NOTICE("You start gently pulling the plush's fluffy talons away from [target]'s vital organs with \the [tool]."),
		SPAN_NOTICE("[user] starts to gently loosen the plush's grip on your vital organs with \the [tool]."),
		SPAN_NOTICE("[user] starts to gently loosen the plush's grip on the [target]'s vital organs with \the [tool]."))

/datum/surgery_step/cut_larval_pseudoroots/training/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] carefully unwinds the last of the plush's fluffy appendages with \the [tool], without awakening it."),
		SPAN_NOTICE("You carefully unwind the last of the plush's fluffy appendages with \the [tool], without awakening it."))

	if(target.stat == CONSCIOUS)
		target.emote("scream")

/datum/surgery_step/cut_larval_pseudoroots/training/failure(mob/user, mob/living/carbon/target)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips and the plush stirs in its slumber!"),
		SPAN_WARNING("Your hand slips and the plush stirs in its slumber!"))

	if(target.stat == CONSCIOUS)
		target.emote("scream")

	return FALSE

//------------------------------------

/datum/surgery_step/remove_larva/training
	name = "Remove Plush"
	desc = "extract the plush from the ribcage"

/datum/surgery_step/remove_larva/training/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("You try to extract the plush from [target]'s chest with \the [tool]."),
			SPAN_NOTICE("[user] tries to extract the plush from your chest with \the [tool]."),
			SPAN_NOTICE("[user] tries to extract the plush from [target]'s chest with \the [tool]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You try to forcefully rip the plush from [target]'s chest with your bare hand."),
			SPAN_NOTICE("[user] tries to forcefully rip the plush from your chest."),
			SPAN_NOTICE("[user] tries to forcefully rip the plush from [target]'s chest."))

/datum/surgery_step/remove_larva/training/success(mob/living/carbon/user, mob/living/carbon/target)
	var/obj/item/toy/plush/plush = locate() in target
	if(!plush)
		return

	user.affected_message(target,
		SPAN_WARNING("You pull [plush] out of [target]'s ribcage! I wonder how that got there..."),
		SPAN_WARNING("[user] pulls an adorable [plush] out of [target]'s ribcage! I wonder how that got there..."),
		SPAN_WARNING("[user] pulls an adorable [plush] out of [target]'s ribcage! I wonder how that got there..."))

	playsound(plush, 'sound/items/plush3.ogg', 20)
	plush.forceMove(target.loc)

/datum/surgery_step/remove_larva/training/failure(mob/user, mob/living/carbon/human/target)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, bruising [target]'s organs!"),
		SPAN_WARNING("[user]'s hand slips, bruising your organs!"),
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s organs!"))

	if(target.stat == CONSCIOUS)
		target.emote("scream")

	return FALSE
