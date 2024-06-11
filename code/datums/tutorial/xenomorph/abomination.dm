/datum/tutorial/xenomorph/abomination
	name = "Xenomorph - Abomination"
	desc = "A tutorial to teach you how to play the Abomination xenomorph caste. Completing this is required to be able to play an Abomination."
	icon_state = "predalien"
	tutorial_id = "xeno_abom_1"
	tutorial_template = /datum/map_template/tutorial/s7x7
	starting_xenomorph_type = /mob/living/carbon/xenomorph/predalien/tutorial

// START OF SCRITPING

/datum/tutorial/xenomorph/abomination/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	xeno.melee_damage_lower = 40
	xeno.melee_damage_upper = 40
	xeno.lock_evolve = TRUE

	message_to_player("Welcome to the tutorial for the Abomination xenomorph. As an Abomination, you are a frontline powerhouse whose damage scales with your kill count.")

	addtimer(CALLBACK(src, PROC_REF(how_to_be_abom)), 6 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/how_to_be_abom()
	message_to_player("You can become an Abomination in-game by chestbursting from a Predator. Be aware that you are kill-on-sight to all Predators forever, and will very likely need to defend yourself against multiple.")
	addtimer(CALLBACK(src, PROC_REF(feral_rush_tutorial)), 6 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/feral_rush_tutorial()
	var/datum/action/rush = give_action(xeno, /datum/action/xeno_action/onclick/feralrush)
	message_to_player("Your first unique ability is <b>Feral Rush</b>, an ability that temporarily increases your speed and your armor. Use <B>Feral Rush</b> to continue.")
	update_objective("Use your Feral Rush ability.")
	add_highlight(rush.button)
	RegisterSignal(rush, COMSIG_XENO_ACTION_USED, PROC_REF(on_rush_used))

/datum/tutorial/xenomorph/abomination/proc/on_rush_used(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
	remove_highlight(source.button)
	addtimer(CALLBACK(src, PROC_REF(predalien_roar_tutorial_1)), 6 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/predalien_roar_tutorial_1()
	hide_action(xeno, /datum/action/xeno_action/onclick/feralrush)
	xeno.cannot_slash = TRUE
	message_to_player("Your next ability is <b>Roar</b>, a versatile ability that disables any motion detectors or cloaks in a medium radius around you. Additionally, it gives a (kill-scaling) slash and speed bonus to any friendly xenomorphs in range.")
	addtimer(CALLBACK(src, PROC_REF(predalien_roar_tutorial_2)), 8 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/predalien_roar_tutorial_2()
	var/datum/action/roar = give_action(xeno, /datum/action/xeno_action/onclick/predalien_roar)
	message_to_player("One of <b>Roar</b>'s most useful abilities is uncloaking nearby Predators. Use <b>Roar</b> to uncloak the newly spawned Predator.")
	update_objective("Use your Roar ability to uncloak the nearby predator.")
	add_highlight(roar.button)
	var/mob/living/carbon/human/pred = new(loc_from_corner(3, 3))
	add_to_tracking_atoms(pred)
	pred.create_hud()
	arm_equipment(pred, /datum/equipment_preset/yautja/blooded)
	var/obj/item/clothing/gloves/yautja/hunter/bracers = locate() in pred
	if(!bracers)
		message_to_player("Something has gone wrong. Please make a bug report.")
		CRASH("predator spawned without bracers in tutorial")

	bracers.cloaker_internal(pred, TRUE, TRUE, TRUE)
	RegisterSignal(bracers, COMSIG_PRED_BRACER_DECLOAKED, PROC_REF(smash_tutorial_1))

/datum/tutorial/xenomorph/abomination/proc/smash_tutorial_1(datum/source)
	SIGNAL_HANDLER

	var/datum/action/roar = get_action(xeno, /datum/action/xeno_action/onclick/predalien_roar)
	remove_highlight(roar.button)
	update_objective("")

	UnregisterSignal(source, COMSIG_PRED_BRACER_DECLOAKED)
	addtimer(CALLBACK(src, PROC_REF(smash_tutorial_2)), 2.5 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/smash_tutorial_2()
	hide_action(xeno, /datum/action/xeno_action/onclick/predalien_roar)
	message_to_player("Good. <b>Roar</b> will be one of your primary tools for defending against Predators. Your next ability is <b>Feral Smash</b>.")
	xeno.cannot_slash = FALSE

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, pred)
	remove_from_tracking_atoms(pred)
	qdel(pred)

	addtimer(CALLBACK(src, PROC_REF(smash_tutorial_3)), 5 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/smash_tutorial_3()
	var/datum/action/smash = give_action(xeno, /datum/action/xeno_action/activable/feral_smash)
	RegisterSignal(smash, COMSIG_XENO_PRE_ACTION_USED, PROC_REF(frenzy_tutorial_1))
	add_highlight(smash.button)

	message_to_player("<b>Feral Smash</b> is a strong lunge with a range of five tiles. It deals decent damage that scales with your kill count. Use <b>Feral Smash</b> on the marine to continue.")
	update_objective("Use your Feral Smash ability on the marine.")

	xeno.forceMove(loc_from_corner(0, 2))
	xeno.anchored = TRUE
	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)

	var/mob/living/carbon/human/marine = new(loc_from_corner(4, 2))
	add_to_tracking_atoms(marine)
	marine.create_hud()
	arm_equipment(marine, /datum/equipment_preset/uscm/private_equipped)

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_1(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	xeno.anchored = FALSE
	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
	RegisterSignal(source, COMSIG_XENO_ACTION_USED, PROC_REF(frenzy_tutorial_2))
	RegisterSignal(source, COMSIG_XENO_FAILED_ACTION_USED, PROC_REF(frenzy_tutorial_1_fail))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_1_fail(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	xeno.anchored = TRUE
	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
	UnregisterSignal(source, list(COMSIG_XENO_FAILED_ACTION_USED, COMSIG_XENO_ACTION_USED))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_2(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	if(get_turf(xeno) == loc_from_corner(0, 2)) // xeno didn't lunge at the mob
		xeno.anchored = TRUE
		UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
		ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
		return

	update_objective("")
	var/datum/action/smash = get_action(xeno, /datum/action/xeno_action/activable/feral_smash)
	remove_highlight(smash.button)
	UnregisterSignal(source, list(COMSIG_XENO_ACTION_USED, COMSIG_XENO_PRE_ACTION_USED))
	addtimer(CALLBACK(src, PROC_REF(frenzy_tutorial_3)), 2 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_3()
	hide_action(xeno, /datum/action/xeno_action/activable/feral_smash)
	message_to_player("Good. Your final ability is <b>Feral Frenzy</b>, a strong ability that can alternate between hitting a single target or all within a large radius. However, it locks you in place while it winds up.")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine)
	remove_from_tracking_atoms(marine)
	qdel(marine)

	addtimer(CALLBACK(src, PROC_REF(frenzy_tutorial_4)), 6 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_4()
	var/mob/living/carbon/human/marine = new(loc_from_corner(4, 2))
	marine.create_hud()
	add_to_tracking_atoms(marine)
	arm_equipment(marine, /datum/equipment_preset/uscm/private_equipped)

	var/datum/action/frenzy = give_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	add_highlight(frenzy.button)
	message_to_player("By default, <b>Feral Frenzy</b> is on single-target mode. Use <b>Feral Frenzy</b> on the newly spawned marine.")
	update_objective("Use Feral Frenzy on the marine.")

	RegisterSignal(frenzy, COMSIG_XENO_ACTION_USED, PROC_REF(frenzy_tutorial_5))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_5(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine)
	if(get_dist(marine, xeno) > 1)
		return

	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
	message_to_player("<b>Feral Frenzy</b> has now been changed into AOE mode. Use <b>Feral Frenzy</b> again anywhere within 2 tiles of the marine.")
	update_objective("Use Feral Frenzy within 2 tiles of the marine.")
	marine.rejuvenate()
	var/datum/action/xeno_action/activable/feralfrenzy/frenzy = get_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	frenzy.targeting = AOETARGETGUT
	frenzy.reduce_cooldown(frenzy.xeno_cooldown)
	add_highlight(frenzy.button)
	RegisterSignal(frenzy, COMSIG_XENO_ACTION_USED, PROC_REF(frenzy_tutorial_6))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_6(datum/action/source)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine)
	var/datum/action/xeno_action/activable/feralfrenzy/frenzy = get_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	if(get_dist(xeno, marine) > frenzy.range)
		// Not close enough to actually hit the marine
		return

	UnregisterSignal(frenzy, COMSIG_XENO_ACTION_USED)
	remove_highlight(frenzy.button)
	message_to_player("Good. As you may have noticed, the AOE version of <b>Feral Frenzy</b> takes longer to wind up, in addition to doing less overall damage.")
	addtimer(CALLBACK(src, PROC_REF(frenzy_tutorial_7)), 5 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_7()
	message_to_player("This is the end of the Abomination tutorial. One last thing to note is that you are able to put yourself out when on fire far faster than other xenomorphs. The tutorial will end itself shortly.")
	mark_completed() // just in case people exit early
	tutorial_end_in(8 SECONDS, TRUE)

// END OF SCRIPTING
