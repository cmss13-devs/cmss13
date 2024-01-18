
//Research stuff to extract stuff from xenomorphs for goodies. In other words, to extract usefull material that could be used to upgrade marines and etc. doesnt add anything of kind

/datum/surgery/xenomorph
	name = "Experimental Harvesting Surgery"
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	possible_locs = list("head")
	target_mobtypes = list(/mob/living/carbon/xenomorph)
	steps = list(
		/datum/surgery_step/xenomorph/cut_exoskeleton,
		/datum/surgery_step/xenomorph/open_exoskeleton,
		///datum/surgery_step/xenomorph/severe_connections
	)
	lying_required = FALSE
	requires_bodypart_type = NONE
	requires_bodypart = FALSE

/datum/surgery/xenomorph/can_start(mob/user, mob/living/carbon/xenomorph/patient, obj/limb/L, obj/item/tool)
	if(patient.stat == DEAD && !patient.organ_removed)
		return TRUE
	return FALSE

/datum/surgery_step/xenomorph/cut_exoskeleton
	name = "Cut Exoskeleton Carapace"
	desc = "Cut the carapace open."
	tools = SURGERY_TOOLS_SEVER_BONE
	time = 4 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/bandage.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/cut_exoskeleton/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw)
		user.affected_message(target,
			SPAN_NOTICE("You start to cut [target.caste_type] carapace apart using \the [tool], carefully, with barely any acid."),
			SPAN_NOTICE("[user] starts to cut Your carapace apart using \the [tool], carefully, with barely any acid."),
			SPAN_NOTICE("[user] starts to cut [target.caste_type] carapace. \the [tool], carefully, with barely any acid."))
		if(user.head && !(user.head.flags_inventory & COVEREYES))
			var/datum/internal_organ/eyes/user_eye = user.internal_organs_by_name["eyes"]
			user_eye.take_damage(rand(1,2), FALSE)
			to_chat(user, SPAN_DANGER("Some acid gets into your eyes!"))
	else
		user.affected_message(target,
			SPAN_NOTICE("You start to [pick("smash", "crack", "break")] [target.caste_type] carapace apart using \the [tool], Recklessly, with acid splashing on you!"),
			SPAN_NOTICE("[user] starts to [pick("smash", "crack", "break")] Your carapace apart using \the [tool], Recklessly, with acid splashing on you!"),
			SPAN_NOTICE("[user] starts to [pick("smash", "crack", "break")] [target.caste_type] carapace with \the [tool], Recklessly, with acid splashing him!"))
		if(user.head && !(user.head.flags_inventory & COVEREYES))
			var/datum/internal_organ/eyes/user_eye = user.internal_organs_by_name["eyes"]
			user_eye.take_damage(rand(3,5), FALSE)
			to_chat(user, SPAN_DANGER("Lots of acid gets into your eyes!"))
			user.emote("pain")
		user.apply_damage(rand(10,25),BURN)

/datum/surgery_step/xenomorph/cut_exoskeleton/success(mob/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw)
		user.affected_message(target,
			SPAN_NOTICE("You succesfully cut through [target.caste_type] carapace apart using \the [tool]."),
			SPAN_NOTICE("[user] Succesfully cuts through Your carapace. \the [tool]."),
			SPAN_NOTICE("[user] Succesfully cuts [target.caste_type] carapace. \the [tool]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You succesfully destroy [target.caste_type] carapace into bits and pieces apart using \the [tool]."),
			SPAN_NOTICE("[user] succesfully destroys Your carapace into bits and pieces apart using \the [tool]."),,
			SPAN_NOTICE("[user] Succesfully destroys [target.caste_type] carapace into bits and pieces apart using \the [tool]."))

/datum/surgery_step/xenomorph/cut_exoskeleton/failure(mob/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, failing to cut [target.caste_type] carapace apart using \the [tool]!"),
			SPAN_WARNING("[user] hand slips, failing to cut Your carapace apart using \the [tool]!"),
			SPAN_WARNING("[user] hand slips, failing to cut [target.caste_type] carapace using \the [tool]!"))
	else
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, failing to destroy [target.caste_type] carapace into bits and pieces apart using \the [tool]."),
			SPAN_WARNING("[user] hand slips, failing to destroy Your carapace into bits and pieces using \the [tool]."),
			SPAN_WARNING("[user] hand slips, failing to destroy [target.caste_type] carapace into bits and pieces using \the [tool]."))

/datum/surgery_step/xenomorph/open_exoskeleton
	name = "Pry exoskeleton open"
	desc = "Open the exoskeleton in the opening."
	tools = SURGERY_TOOLS_PRY_ENCASED
	time = 3 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/xenomorph/open_exoskeleton/preop(mob/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
			user.affected_message(target,
				SPAN_NOTICE("You start to pry [target.caste_type] carapace open using \the [tool], slowly"),
				SPAN_NOTICE("[user] starts to pry Your carapace open with \the [tool] very carefully"),
				SPAN_NOTICE("[user] starts to pry [target.caste_type] carapace open with \the [tool] very carefully"))

/datum/surgery_step/xenomorph/open_exoskeleton/success(mob/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/retractor)
		user.affected_message(target,
			SPAN_NOTICE("You hold [target.caste_type] carapace and exoskeleton open using \the [tool], exposing [target.caste_type] vital organs"),
			SPAN_NOTICE("[user] Holds Your carapace and exoskeleton open with \the [tool], exposing [target.caste_type] vital organs "),
			SPAN_NOTICE("[user] Holds [target.caste_type] carapace and exoskeleton open with \the [tool], exposing [target.caste_type] vital organs "))
	else
		user.affected_message(target,
			SPAN_NOTICE("You Hold [target.caste_type] carapace open using \the [tool] like a medieval doctor, exposing [target.caste_type] vital organs"),
			SPAN_NOTICE("[user] starts to open Your carapace with \the [tool] very carefully"),
			SPAN_NOTICE("[user] starts to open [target.caste_type] carapace with \the [tool] very carefully"))

/datum/surgery_step/xenomorph/open_exoskeleton/failure(mob/living/carbon/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"),
			SPAN_WARNING("[user] hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"),
			SPAN_WARNING("[user] hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"))
		user.apply_damage(rand(5, 15), BURN)
/*
/datum/surgery_step/xenomorph/severe_connections
	name = "Severe organ connections"
	desc = "Detach tubes and connections from organ."
	tools = list(
		/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/scalpel/pict_system = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/shard = SURGERY_TOOL_MULT_AWFUL,
	) //shamelessly taken from embryo code
	time = 5 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/remove_organ
*/
