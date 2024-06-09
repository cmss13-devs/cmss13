//Research stuff to extract stuff from xenomorphs for goodies. In other words, to extract useful material that could be used to upgrade marines etc.

/datum/surgery/xenomorph
	name = "Experimental Harvesting Surgery"
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	possible_locs = list("head")
	target_mobtypes = list(/mob/living/carbon/xenomorph)
	steps = list(
		/datum/surgery_step/xenomorph/cut_exoskeleton,
		/datum/surgery_step/xenomorph/open_exoskeleton,
		/datum/surgery_step/xenomorph/severe_connections,
		/datum/surgery_step/xenomorph/remove_organ,
	)
	lying_required = FALSE
	requires_bodypart_type = NONE
	requires_bodypart = FALSE

/datum/surgery/xenomorph/can_start(mob/user, mob/living/carbon/xenomorph/patient, obj/limb/L, obj/item/tool)
	if(islarva(patient) || isfacehugger(patient))
		to_chat(user, SPAN_DANGER("This race is probably too small to have a mature organ worthy to extract..."))
		return FALSE
	if((patient.tier > 2 || isqueen(patient)) && !istype(tool, /obj/item/tool/surgery/scalpel/laser/advanced))
		to_chat(user, SPAN_DANGER("Chitin of this kind is too thick for an ordinary tool, you would need something special."))
		return FALSE
	if(patient.stat == DEAD && !patient.organ_removed)
		return TRUE
	return FALSE

/datum/surgery_step/xenomorph/cut_exoskeleton
	name = "Cut Exoskeleton Carapace"
	desc = "cut the carapace open"
	tools = list(
		/obj/item/tool/surgery/scalpel/laser/advanced = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/circular_saw = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/weapon/twohanded/fireaxe = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/weapon/sword/machete = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/hatchet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife/butcher = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
	)

	time = 4 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/bandage.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/cut_exoskeleton/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw || tool_type == /obj/item/tool/surgery/scalpel/laser/advanced)
		user.affected_message(target,
			SPAN_NOTICE("You start to cut [target.caste_type] carapace apart using [tool], carefully, trying to prevent acid leaks."),
			SPAN_NOTICE("[user] starts to cut your carapace apart using [tool], carefully, trying to prevent acid leaks."),
			SPAN_NOTICE("[user] starts to cut [target.caste_type] carapace. [tool], carefully, trying to prevent acid leaks."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You start to [pick("smash", "crack", "break")] [target.caste_type] carapace apart using [tool], Recklessly, with acid splashing on you!"),
			SPAN_NOTICE("[user] starts to [pick("smash", "crack", "break")] your carapace apart using [tool], recklessly splashing acid everywhere!"),
			SPAN_NOTICE("[user] starts to [pick("smash", "crack", "break")] [target.caste_type] carapace with [tool], recklessly splashing acid everywhere!"))
		//we dont really need log interact since we're working with dead body... I hope

/datum/surgery_step/xenomorph/cut_exoskeleton/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw)
		user.affected_message(target,
			SPAN_NOTICE("You succesfully cut through [target.caste_type] carapace apart using [tool]."),
			SPAN_NOTICE("[user] successfully cuts through your carapace using [tool]."),
			SPAN_NOTICE("[user] successfully cuts [target.caste_type] carapace using [tool]."))
	else
		user.affected_message(target,
			SPAN_NOTICE("You successfully destroy [target.caste_type] carapace into bits and pieces using [tool]."),
			SPAN_NOTICE("[user] successfully destroys your carapace into bits and pieces using [tool]."),,
			SPAN_NOTICE("[user] successfully destroys [target.caste_type] carapace into bits and pieces using [tool]."))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		to_chat(victim, SPAN_HIGHDANGER("You are covered in acid as you feel agonizing pain!"))
		victim.apply_damage(rand(75, 125), BURN) // you WILL wear biosuit.
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")

/datum/surgery_step/xenomorph/cut_exoskeleton/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, failing to cut [target.caste_type] carapace apart using [tool]!"),
		SPAN_WARNING("[user]'s hand slips, failing to cut your carapace apart using [tool]!"),
		SPAN_WARNING("[user] hand slips, failing to cut [target.caste_type] carapace using [tool]!"))
	return FALSE

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
				SPAN_NOTICE("You start to pry [target.caste_type] carapace open using [tool]"),
				SPAN_NOTICE("[user] starts to pry your carapace open with [tool] very carefully"),
				SPAN_NOTICE("[user] starts to pry [target.caste_type] carapace open with [tool] very carefully"))

/datum/surgery_step/xenomorph/open_exoskeleton/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/retractor)
		user.affected_message(target,
			SPAN_NOTICE("You hold [target.caste_type] carapace and exoskeleton open using [tool], exposing [target.caste_type] vital organs"),
			SPAN_NOTICE("[user] holds your carapace and exoskeleton open with [tool], exposing [target.caste_type] vital organs "),
			SPAN_NOTICE("[user] holds [target.caste_type] carapace and exoskeleton open with [tool], exposing [target.caste_type] vital organs "))
	else
		user.affected_message(target,
			SPAN_NOTICE("You hold [target.caste_type] carapace open using [tool] like a medieval doctor, exposing [target.caste_type] vital organs"),
			SPAN_NOTICE("[user] starts to open your carapace with [tool] very carefully"),
			SPAN_NOTICE("[user] starts to open [target.caste_type] carapace with [tool] very carefully"))

/datum/surgery_step/xenomorph/open_exoskeleton/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"),
		SPAN_WARNING("[user] hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"),
		SPAN_WARNING("[user] hand slips, letting go of [target.caste_type] carapace and exoskeleton, slaming it back into place and splashing acid everywhere!"))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		to_chat(victim, SPAN_DANGER("You are covered in blood gushing out from [target.caste_type]"))
		victim.apply_damage(rand(50, 75), BURN) // still dangerous
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")
	return FALSE

/datum/surgery_step/xenomorph/severe_connections
	name = "Sever Organ Connections"
	desc = "detach tubes and connections from organ"
	tools = list(
		/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/scalpel/pict_system = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/shard = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 4 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/severe_connections/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You start to sever [target.caste_type] organ links using [tool], with confidence"),
		SPAN_NOTICE("[user] start to sever your organ links using [tool], with confidence"),
		SPAN_NOTICE("[user] starts to sever [target.caste_type] organ links using [tool], with confidence"))

/datum/surgery_step/xenomorph/severe_connections/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/scalpel || tool_type == /obj/item/tool/surgery/scalpel/pict_system)
		user.affected_message(target,
			SPAN_NOTICE("You severed [target.caste_type] connections and links to vital organs using [tool]"),
			SPAN_NOTICE("[user] severed your connections and links to vital organs using [tool]"),
			SPAN_NOTICE("[user] severed [target.caste_type] connections and links to vital organs using [tool]"))
	else
		user.affected_message(target,
			SPAN_NOTICE("You rip [target.caste_type] connections and links to vital organs apart using [tool]"),
			SPAN_NOTICE("[user] rips your connections and links to vital organs apart using [tool]"),
			SPAN_NOTICE("[user] rips [target.caste_type] connections and links to vital organs apart using [tool]"))

/datum/surgery_step/xenomorph/severe_connections/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("Your hand slips, damaging one of [target.caste_type] [pick("arteries", "viens")], gushing acid blood everywhere!"),
		SPAN_WARNING("[user] hand slips, damaging one of your [pick("arteries", "viens")], gushing acid blood everywhere!"),
		SPAN_WARNING("[user] hand slips, damaging one of [target.caste_type] [pick("arteries", "viens")], gushing acid blood everywhere!"))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		to_chat(victim, SPAN_DANGER("You are covered in blood gushing out from [target.caste_type]"))
		victim.apply_damage(rand(50, 75), BURN) // not SO dangerous but still is
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")

/datum/surgery_step/xenomorph/remove_organ
	name = "Remove Xenomorph Organ"
	desc = "grab a hold of it and pull the organ out"
	accept_hand = TRUE
	tools = list(
		/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_SUBSTITUTE,
	)//shamelessly taken from embryo code
	time = 3 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/remove_organ/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
		SPAN_NOTICE("You start to get a firm grip on the [target.caste_type] organ using [tool] "),
		SPAN_NOTICE("[user] start to get a firm grip on your insides using [tool]"),
		SPAN_NOTICE("[user] starts to get a firm grip on the [target.caste_type] organ using [tool] "))
	else
		user.affected_message(target,
			SPAN_NOTICE("You start to get a firm grip on the [target.caste_type] organ"),
			SPAN_NOTICE("[user] starts to get a firm grip on your insides"),
			SPAN_NOTICE("[user] starts to get a firm grip on the [target.caste_type] organ"))

/datum/surgery_step/xenomorph/remove_organ/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("You pulled the [target.caste_type] organ out using [tool]"),
			SPAN_NOTICE("[user] pulled your organ out using [tool]"),
			SPAN_NOTICE("[user] pulled the [target.caste_type] organ out using [tool]"))
	else
		if(istype(user.wear_suit, /obj/item/clothing/suit/bio_suit))
			user.affected_message(target,
				SPAN_NOTICE("You pulled the [target.caste_type] organ out!"),
				SPAN_NOTICE("[user] pulles your insides out!"),
				SPAN_NOTICE("[user] pulled the [target.caste_type] organ out."))
		else
			user.affected_message(target,
				SPAN_NOTICE("You burn your hands as you pulled the [target.caste_type] organ out!"),
				SPAN_NOTICE("[user] burns their hands as they pulled your insides out!"),
				SPAN_NOTICE("[user] burns [user.p_their()] hands as [user.p_they()] pulled the [target.caste_type] organ out."))
			user.emote("pain")
			if(user.hand)
				user.apply_damage(rand(30,50), BURN, "l_hand")
			else
				user.apply_damage(rand(30,50), BURN, "r_hand")
			playsound(user, "acid_sizzle", 25, TRUE)
			animation_flash_color(user, "#FF0000")
	var/obj/item/organ/xeno/organ = locate() in target
	if(!isnull(organ))
		organ.forceMove(target.loc)
		target.organ_removed = TRUE
		target.update_wounds()

/datum/surgery_step/xenomorph/remove_organ/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("You fail to pull the [target.caste_type] organ out using [tool]"),
			SPAN_NOTICE("[user] fails to pull your organ out using [tool]"),
			SPAN_NOTICE("[user] fails to pull the [target.caste_type] organ out using [tool]"))
	return FALSE

