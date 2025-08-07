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
		to_chat(user, SPAN_DANGER("This organism is probably too small to have a mature organ worthy of extraction..."))
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

//No need for to-patient messages on this one, they're heckin' dead
/datum/surgery_step/xenomorph/cut_exoskeleton/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw || tool_type == /obj/item/tool/surgery/scalpel/laser/advanced)
		user.visible_message(
			SPAN_NOTICE("[user] carefully starts to cut the [target.caste_type]'s carapace apart with [tool], trying to prevent acidic blood from leaking."),
			SPAN_NOTICE("You carefully start to cut the [target.caste_type]'s carapace apart using [tool], trying to prevent acidic blood from leaking."))
	else
		user.visible_message(
			SPAN_NOTICE("[user] recklessly starts to [pick("smash", "crack", "break")] the [target.caste_type]'s carapace apart with [tool] as acidic blood begins to burst through the corpse's seams!"),
			SPAN_NOTICE("You recklessly start to [pick("smash", "crack", "break")] the [target.caste_type]'s carapace apart using [tool] as acidic blood begins to burst through the corpse's seams!"))
			//we dont really need a log interact since we're working with dead bodies... I hope

/datum/surgery_step/xenomorph/cut_exoskeleton/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw)
		user.visible_message(
			SPAN_NOTICE("[user] successfully cuts through the [target.caste_type]'s carapace using [tool]."),
			SPAN_NOTICE("You successfully cut through the [target.caste_type]'s carapace using [tool]."))
	else
		user.visible_message(
			SPAN_NOTICE("[user] successfully destroys the [target.caste_type]'s carapace into bits and pieces using [tool]."),
			SPAN_NOTICE("You successfully destroy the [target.caste_type]'s carapace into bits and pieces using [tool]."))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		victim.visible_message(
			SPAN_WARNING("[victim] is [pick("covered", "drenched", "soaked")] in the acidic blood that [pick("spurts", "sprays", "bursts")] out from the [target.caste_type]!"),
			SPAN_HIGHDANGER("You feel agonizing pain as you're drenched in acid!"))
		victim.apply_damage(rand(75, 125), BURN) // you WILL wear biosuit.
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")
		//Having acid spray everywhere *but* the floor makes no sense, but this can be removed if research gets too messy.
		target.add_splatter_floor(get_turf(target.loc))

/datum/surgery_step/xenomorph/open_exoskeleton
	name = "Pry exoskeleton open"
	desc = "open the exoskeleton in the incision"
	tools = SURGERY_TOOLS_PRY_ENCASED
	time = 2 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/xenomorph/open_exoskeleton/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/retractor)
		user.visible_message(
			SPAN_NOTICE("[user] carefully starts to pry the [target.caste_type]'s carapace open with [tool]."),
			SPAN_NOTICE("You carefully start to pry the [target.caste_type]'s carapace open using [tool]."))
	else
		user.visible_message(
			SPAN_NOTICE("[user] starts to pry the [target.caste_type]'s carapace open using [tool] like a crazed medieval doctor!"),
			SPAN_NOTICE("You start to pry the [target.caste_type]'s carapace open using [tool] like a crazed medieval doctor!"))

/datum/surgery_step/xenomorph/open_exoskeleton/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/retractor)
		user.visible_message(
			SPAN_NOTICE("[user] holds the [target.caste_type]'s carapace and exoskeleton open with [tool], exposing the [target.caste_type]'s vital organs."),
			SPAN_NOTICE("You hold the [target.caste_type]'s carapace and exoskeleton open using [tool], exposing the [target.caste_type]'s vital organs."))
	else
		user.visible_message(
			SPAN_NOTICE("[user] holds the [target.caste_type]'s carapace open with [tool] like a wacky kid at a science fair."),
			SPAN_NOTICE("You hold the [target.caste_type]'s carapace open using [tool] like a wacky kid at a science fair."))

/datum/surgery_step/xenomorph/open_exoskeleton/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(
		SPAN_WARNING("[user] messes up and [user.p_their()] hand slips, letting go of the [target.caste_type]'s carapace and exoskeleton. It snaps back into place, sending acid flying!"),
		SPAN_WARNING("Your hand slips, letting go of the [target.caste_type]'s carapace and exoskeleton. It snaps back into place, sending acid flying!"))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		victim.visible_message(
			SPAN_WARNING("[victim] is [pick("covered", "drenched", "soaked")] in the acidic blood that [pick("spurts", "sprays", "bursts")] out from the [target.caste_type]!"),
			SPAN_DANGER("You're [pick("covered", "drenched", "soaked")] in the acidic blood that [pick("spurts", "sprays", "bursts")] out from the [target.caste_type]!"))
		victim.apply_damage(rand(50, 75), BURN) // still dangerous
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")
		target.add_splatter_floor(get_turf(target.loc))
	return FALSE

/datum/surgery_step/xenomorph/severe_connections
	name = "Sever Organ Connections"
	desc = "detach tubes and connections from organ"
	tools = list(
		/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/scalpel/pict_system = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/weapon/throwing_knife = SURGERY_TOOL_MULT_AWFUL,
		/obj/item/shard = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 4 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/severe_connections/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/scalpel || tool_type == /obj/item/tool/surgery/scalpel/pict_system)
		user.visible_message(
			SPAN_NOTICE("[user] confidently starts to sever the [target.caste_type]'s alien organ from its surrounding connective tissue using [tool]."),
			SPAN_NOTICE("You confidently start to sever the [target.caste_type]'s alien organ from its surrounding connective tissue using [tool]."))
	else
		user.visible_message(
			SPAN_NOTICE("[user] confidently starts to rip the [target.caste_type]'s connective tissue apart using [tool]"),
			SPAN_NOTICE("You confidently start to rip the [target.caste_type]'s connective tissue apart using [tool]."))

/datum/surgery_step/xenomorph/severe_connections/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/scalpel || tool_type == /obj/item/tool/surgery/scalpel/pict_system)
		user.visible_message(
			SPAN_NOTICE("[user] severs the connective tissue that holds the [target.caste_type]'s alien organ in place using [tool]."),
			SPAN_NOTICE("You sever the connective tissue that holds the [target.caste_type]'s alien organ in place using [tool]."))
	else
		user.visible_message(
			SPAN_NOTICE("[user] gleefully rips the [target.caste_type]'s connective tissue apart using [tool]."),
			SPAN_NOTICE("You gleefully rip the [target.caste_type]'s connective tissue apart using [tool]."))

/datum/surgery_step/xenomorph/severe_connections/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(
		SPAN_WARNING("[user] messes up and [user.p_their()] hand slips, damaging one of the [target.caste_type]'s [pick("arteries", "veins")]. Acidic blood sprays everywhere!"),
		SPAN_WARNING("Your hand slips, damaging one of the [target.caste_type]'s [pick("arteries", "veins")]. Acidic blood sprays everywhere!"))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		victim.visible_message(
			SPAN_WARNING("[victim] is [pick("covered", "drenched", "soaked")] in the acidic blood that [pick("spurts", "sprays", "bursts")] out from the [target.caste_type]!"),
			SPAN_DANGER("You're [pick("covered", "drenched", "soaked")] in the acidic blood that [pick("spurts", "sprays", "bursts")] out from the [target.caste_type]!"))
		victim.apply_damage(rand(50, 75), BURN) // not AS dangerous but still is
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")
		target.add_splatter_floor(get_turf(target.loc))

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
		user.visible_message(
			SPAN_NOTICE("[user] starts to get a firm grip on the [target.caste_type]'s alien organ using [tool]."),
			SPAN_NOTICE("You start to get a firm grip on the [target.caste_type]'s alien organ using [tool]."))
	else
		user.visible_message(
			SPAN_NOTICE("Like a mad scientist, [user] starts to get a firm grip on the [target.caste_type]'s alien organ!"),
			SPAN_NOTICE("Like a mad scientist, you start to get a firm grip on the [target.caste_type]'s alien organ!"))

/datum/surgery_step/xenomorph/remove_organ/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.visible_message(
			SPAN_NOTICE("[user] pulls the [target.caste_type]'s alien organ out using [tool]."),
			SPAN_NOTICE("You pull the [target.caste_type]'s alien organ out using [tool]."))
	else
		if(istype(user.wear_suit, /obj/item/clothing/suit/bio_suit))
			user.visible_message(
				SPAN_NOTICE("[user] pulls the [target.caste_type]'s alien organ out."),
				SPAN_NOTICE("You pull the [target.caste_type]'s alien organ out."))
		else
			user.visible_message(
				SPAN_WARNING("[user] burns [user.p_their()] hands as [user.p_they()] pull the [target.caste_type]'s alien organ out!"),
				SPAN_WARNING("You burn your hands as you pull the [target.caste_type]'s alien organ out!"))
			user.emote("pain")
			if(user.hand)
				user.apply_damage(rand(30,50), BURN, "l_hand")
			else
				user.apply_damage(rand(30,50), BURN, "r_hand")
			playsound(user, "acid_sizzle", 25, TRUE)
			animation_flash_color(user, "#FF0000")
			//no blood splatter here, we're just sticking our hands in, not cutting anything open
	var/obj/item/organ/xeno/organ = locate() in target
	if(!isnull(organ))
		organ.forceMove(target.loc)
		target.organ_removed = TRUE
		target.update_wounds()

/datum/surgery_step/xenomorph/remove_organ/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.visible_message(
			SPAN_NOTICE("[user] fails to pull the [target.caste_type]'s alien organ out using [tool]."),
			SPAN_NOTICE("You fail to pull the [target.caste_type]'s alien organ out using [tool]."))
	return FALSE

