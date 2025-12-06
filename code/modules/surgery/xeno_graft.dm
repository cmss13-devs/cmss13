// Surgery to graft a control headset onto a xenomorph

/datum/surgery/xenomorph_graft
	name = "Experimental Headset Graft Surgery"
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	possible_locs = list("head")
	target_mobtypes = list(/mob/living/carbon/xenomorph)
	steps = list(
		/datum/surgery_step/xenomorph/cut_exoskeleton,
		/datum/surgery_step/xenomorph/open_exoskeleton,
		/datum/surgery_step/xenomorph/install_connections,
		/datum/surgery_step/xenomorph/install_headset,
	)
	lying_required = FALSE
	requires_bodypart_type = NONE
	requires_bodypart = FALSE

/datum/surgery/xenomorph_graft/can_start(mob/user, mob/living/carbon/xenomorph/patient, obj/limb/L, obj/item/tool)
	if(islarva(patient) || isfacehugger(patient))
		to_chat(user, SPAN_DANGER("This organism is far too small for the headset to fit."))
		return FALSE
	if((patient.tier > 2 || isqueen(patient)) && !istype(tool, /obj/item/tool/surgery/scalpel/laser/advanced))
		to_chat(user, SPAN_DANGER("Chitin of this kind is too thick for an ordinary tool, you would need something special."))
		return FALSE
	if(patient.stat != DEAD && !patient.organ_removed)
		return TRUE
	return FALSE

/datum/surgery_step/xenomorph/install_connections
	name = "Install Connections"
	desc = "install the necessary neural connections for the headset"
	tools = list(
		/obj/item/stack/nanopaste = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/stack/cable_coil = SURGERY_TOOL_MULT_SUBSTITUTE,
	)
	time = 10 SECONDS
	preop_sound = 'sound/surgery/organ1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/xenomorph/install_connections/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/stack/nanopaste)
		user.visible_message(
			SPAN_NOTICE("[user] begins to prepare the ends of the [target.caste_type]'s nerves for headset grafting using [tool]."),
			SPAN_NOTICE("You slowly and carefully prepare the ends of the [target.caste_type]'s nerves for headset grafting using [tool]."))
	else
		user.visible_message(
			SPAN_NOTICE("[user] confidently starts to connect cable to the [target.caste_type]'s connective tissue apart like a mad scientist."),
			SPAN_NOTICE("You confidently start to connect cable to the [target.caste_type]'s connective tissue apart like a mad scientist."))

/datum/surgery_step/xenomorph/install_connections/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/stack/nanopaste)
		user.visible_message(
			SPAN_NOTICE("[user] prepares the ends of the [target.caste_type]'s nerves for grafting using [tool]."),
			SPAN_NOTICE("You prepare the ends of the [target.caste_type]'s nerves for grafting using [tool]."))
	else
		user.visible_message(
			SPAN_NOTICE("[user] madly connects cable to the [target.caste_type]'s nerves."),
			SPAN_NOTICE("You connect cable to the [target.caste_type]'s nerves. This is very normal."))

	var/obj/item/stack/stack_tool = tool
	stack_tool.use(rand(1,3))

/datum/surgery_step/xenomorph/install_connections/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
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

/datum/surgery_step/xenomorph/install_headset
	name = "Graft Control Headset"
	desc = "graft the control headset onto the xenomorph"
	tools = list(
		/obj/item/device/control_headset_xeno = SURGERY_TOOL_MULT_IDEAL,
	)
	time = 15 SECONDS
	preop_sound = 'sound/surgery/organ1.ogg'
	success_sound = 'sound/machines/pda_button1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/install_headset/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(
		SPAN_NOTICE("[user] starts to connect the [tool] to the [target.caste_type]'s prepared nerve endings."),
		SPAN_NOTICE("You start to connect the [tool] to the [target.caste_type]'s prepared nerve endings."))

/datum/surgery_step/xenomorph/install_headset/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(
		SPAN_NOTICE("[user] connects the [tool] to the [target.caste_type]!"),
		SPAN_NOTICE("You connect the [tool] to the [target.caste_type]!"))
	if(!HAS_TRAIT(target, TRAIT_XENO_BRAINDEAD))
		to_chat(user, SPAN_NOTICE("Nothing seems to happen."))
		return

	playsound(target, 'sound/machines/screen_output1.ogg', 50)
	target.visible_message(SPAN_NOTICE("Sensors start to beep and mechanisms whirr as the control headset is grafted onto [target]'s head."))
	target.AddComponent(/datum/component/xeno_control_headset)
	target.set_hive_and_update(XENO_HIVE_CONTROLLED)
	qdel(tool)

/datum/surgery_step/xenomorph/install_headset/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(
		SPAN_NOTICE("[user] fails to connect the [tool] to the [target.caste_type]!"),
		SPAN_NOTICE("You fail to connect the [tool] to the [target.caste_type]!"))
	return FALSE

