
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
		/datum/surgery_step/xenomorph/severe_connections,
		/datum/surgery_step/xenomorph/remove_organ
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
	desc = "cut the carapace open"
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
	else
		user.affected_message(target,
			SPAN_NOTICE("You start to [pick("smash", "crack", "break")] [target.caste_type] carapace apart using \the [tool], Recklessly, with acid splashing on you!"),
			SPAN_NOTICE("[user] starts to [pick("smash", "crack", "break")] Your carapace apart using \the [tool], Recklessly, with acid splashing all of the place!"),
			SPAN_NOTICE("[user] starts to [pick("smash", "crack", "break")] [target.caste_type] carapace with \the [tool], Recklessly, with acid splashing them!"))
		if(user.head && !(user.head.flags_inventory & COVEREYES))
			var/datum/internal_organ/eyes/user_eye = user.internal_organs_by_name["eyes"]
			user_eye.take_damage(rand(3,5), FALSE)
			to_chat(user, SPAN_DANGER("Lots of acid gets into your eyes and on your skin!"))
			user.emote("pain")
		user.apply_damage(rand(10,25),BURN)

/datum/surgery_step/xenomorph/cut_exoskeleton/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
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

/datum/surgery_step/xenomorph/cut_exoskeleton/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
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
	desc = "open the exoskeleton in the incision"
	tools = SURGERY_TOOLS_PRY_ENCASED
	time = 2 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/xenomorph/open_exoskeleton/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
			user.affected_message(target,
				SPAN_NOTICE("You start to pry [target.caste_type] carapace open using \the [tool], slowly"),
				SPAN_NOTICE("[user] starts to pry Your carapace open with \the [tool] very carefully"),
				SPAN_NOTICE("[user] starts to pry [target.caste_type] carapace open with \the [tool] very carefully"))

/datum/surgery_step/xenomorph/open_exoskeleton/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
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

/datum/surgery_step/xenomorph/open_exoskeleton/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"),
			SPAN_WARNING("[user] hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"),
			SPAN_WARNING("[user] hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"))
		user.apply_damage(rand(5, 15), BURN)

/datum/surgery_step/xenomorph/severe_connections
	name = "Severe organ connections"
	desc = "detach tubes and connections from organ"
	tools = list(
		/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/scalpel/pict_system = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/shard = SURGERY_TOOL_MULT_AWFUL,
	) //shamelessly taken from embryo code
	time = 4 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/severe_connections/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start to severe [target.caste_type] organ links using \the [tool], with confidence"),
		SPAN_NOTICE("[user] start to severe Your organ links using \the [tool], with confidence"),
		SPAN_NOTICE("[user] starts to severe [target.caste_type] organ links using \the [tool], with confidence"))

/datum/surgery_step/xenomorph/severe_connections/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/retractor)
		user.affected_message(target,
			SPAN_NOTICE("You severed [target.caste_type] connections and links to vital organs using \the [tool]"),
			SPAN_NOTICE("[user] severed Your connections and links to vital organs using \the [tool]"),
			SPAN_NOTICE("[user] severed [target.caste_type] connections and links to vital organs using \the [tool]"))
	else
		user.affected_message(target,
			SPAN_NOTICE("You rip [target.caste_type] connections and links to vital organs apart using \the [tool]"),
			SPAN_NOTICE("[user] rips Your connections and links to vital organs apart using \the [tool]"),
			SPAN_NOTICE("[user] rips [target.caste_type] connections and links to vital organs apart using \the [tool]"))

/datum/surgery_step/xenomorph/severe_connections/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
		user.affected_message(target,
			SPAN_WARNING("Your hand slips, damaging one of [target.caste_type] [pick("arteries", "viens")], gushing acid blood everywhere!"),
			SPAN_WARNING("[user] hand slips, damaging one of Your [pick("arteries", "viens")], gushing acid blood everywhere!"),
			SPAN_WARNING("[user] hand slips, damaging one of [target.caste_type] [pick("arteries", "viens")], gushing acid blood everywhere!"))
		user.apply_damage(rand(5, 15), BURN)

/datum/surgery_step/xenomorph/remove_organ
	name = "Take out the organ"
	desc = "grab a hold of it and pull the organ out"
	accept_hand = TRUE
	tools = list(
		/obj/item/tool/surgery/hemostat = 1.5,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_SUBSTITUTE
		)//shamelessly taken from embryo code
	time = 6 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/remove_organ/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
		SPAN_NOTICE("You start to get a firm grip on the [target.caste_type] organ using \the [tool] "),
		SPAN_NOTICE("[user] start to get a firm grip on your insides using \the [tool]"),
		SPAN_NOTICE("[user] starts to get a firm grip on the [target.caste_type] organ using \the [tool] "))
	else
		user.affected_message(target,
			SPAN_NOTICE("You start to get a firm grip on the [target.caste_type] organ"),
			SPAN_NOTICE("[user] start to get a firm grip on your insides"),
			SPAN_NOTICE("[user] starts to get a firm grip on the [target.caste_type] organ"))

/datum/surgery_step/xenomorph/remove_organ/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("You pulled the [target.caste_type] organ out using \the [tool]"),
			SPAN_NOTICE("[user] pulled Your organ out using \the [tool]"),
			SPAN_NOTICE("[user] pulled the [target.caste_type] organ out using \the [tool]"))
	else
		user.affected_message(target,
			SPAN_NOTICE("You burn your hands as you pulled the [target.caste_type] organ out!"),
			SPAN_NOTICE("[user] burns their hands as they pulled Your insides out!"),
			SPAN_NOTICE("[user] burns their hands as they pulled the [target.caste_type] organ out"))
		user.emote("pain")
		if(user.hand)
			user.apply_damage(15, BURN, "l_hand")
		else
			user.apply_damage(15, BURN, "r_hand")
	target.organ_removed = TRUE
	var/obj/item/organ/heart/xeno/organ = locate() in target
	organ.forceMove(target.loc)

/datum/surgery_step/xenomorph/remove_organ/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("You fail to pull the [target.caste_type] organ out using \the [tool]"),
			SPAN_NOTICE("[user] fails to pull Your organ out using \the [tool]"),
			SPAN_NOTICE("[user] fails to pull the [target.caste_type] organ out using \the [tool]"))

