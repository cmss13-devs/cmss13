/datum/tutorial/ss13/intents
	name = "Space Station 13 - Intents"
	desc = "Learn how the intent interaction system works."
	icon_state = "intents"
	tutorial_id = "ss13_intents_1"
	tutorial_template = /datum/map_template/tutorial/s11x7
	template_safety_override = TRUE
	required_tutorial = "ss13_basic_1"

// START OF SCRIPTING

/datum/tutorial/ss13/intents/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	var/list/script = list(
		"This is the tutorial for the <b>intents</b> system of Space Station 13.",
		"The highlighted UI element in the bottom-right corner is your current intent."
	)
	var/datum/hud/human/human_hud = tutorial_mob.hud_used
	add_highlight(human_hud.action_intent)

	addtimer(CALLBACK(src, PROC_REF(require_help)), dynamic_message_to_player(script))

/datum/tutorial/ss13/intents/proc/require_help()
	tutorial_mob.a_intent_change(INTENT_DISARM)

	dynamic_message_to_player(list(
		"Your intent has been changed off of <b>help</b>.",
		"Change back to it by pressing <b>[retrieve_bind("select_help_intent")]</b>."
	))

	update_objective("Change to help intent by pressing [retrieve_bind("select_help_intent")].")
	RegisterSignal(tutorial_mob, COMSIG_MOB_INTENT_CHANGE, PROC_REF(on_help_intent))

/datum/tutorial/ss13/intents/proc/on_help_intent(datum/source, new_intent)
	SIGNAL_HANDLER

	if(new_intent != INTENT_HELP)
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_INTENT_CHANGE)

	var/mob/living/carbon/human/dummy/tutorial/tutorial_dummy = new(loc_from_corner(2, 3))
	tutorial_dummy.alpha = 0
	animate(tutorial_dummy, 1 SECONDS, alpha=255)
	addtimer(CALLBACK(src, PROC_REF(add_highlight), tutorial_dummy, COLOR_GREEN), 1 SECONDS)
	add_to_tracking_atoms(tutorial_dummy)

	dynamic_message_to_player(list(
		"To help us learn the basics of intents on Space Station 13, Mr Test Dummy is here to lend a hand!",
		"The first of the intents is <b>help</b> intent. It is used to harmlessly touch others, put out fire, give CPR, and similar.",
		"Click on the <b>Test Dummy</b> to give them a pat on the back."
	))

	update_objective("Click on the <font color='[COLOR_GREEN]'><b>Test Dummy</b></font> on help intent.")
	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_help_attack))

/datum/tutorial/ss13/intents/proc/on_help_attack(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if((attacked_mob == src) || (tutorial_mob.a_intent != INTENT_HELP))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	remove_highlight(tutorial_dummy)
	tutorial_dummy.status_flags = DEFAULT_MOB_STATUS_FLAGS
	REMOVE_TRAIT(tutorial_dummy, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
	tutorial_dummy.anchored = FALSE

	tutorial_mob.skills = new /datum/skills/pfc
	tutorial_mob.skills.set_skill(SKILL_CQC, SKILL_CQC_MAX)

	var/list/script = list(
		"The second intent is <b>disarm</b>, selectable with <b>[retrieve_bind("select_disarm_intent")]</b>.",
		"Disarm is used to shove people, which can make them drop items or fall to the ground.",
		"Shove the <b>Test Dummy</b> repeatedly until it falls over."
	)

	addtimer(CALLBACK(src, PROC_REF(add_highlight), tutorial_dummy, COLOR_BLUE), dynamic_message_to_player(script))

	update_objective("Switch to <font color='[COLOR_BLUE]'>disarm intent</font> by pressing [retrieve_bind("select_disarm_intent")] and shove the <font color='[COLOR_BLUE]'><b>Test Dummy</b></font> to the ground.")

	RegisterSignal(tutorial_dummy, COMSIG_LIVING_APPLY_EFFECT, PROC_REF(on_shove_down))

/datum/tutorial/ss13/intents/proc/on_shove_down(datum/source, datum/status_effect/new_effect)
	SIGNAL_HANDLER

	if(!istype(new_effect, /datum/status_effect/incapacitating/knockdown))
		return

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	remove_highlight(tutorial_dummy)
	UnregisterSignal(tutorial_dummy, COMSIG_LIVING_APPLY_EFFECT)
	tutorial_dummy.rejuvenate()

	var/list/script = list(
		"The third intent is <b>grab</b>.<br>Grab is used to grab people in either a passive, aggressive, or chokehold grab.",
		"Grabbing someone multiples times <b>upgrades</b> your grab.",
		"Switch to <b>grab intent</b> by pressing the <b>[retrieve_bind("select_disarm_intent")]</b> key.<br>Then click the <b>Test Dummy</b> twice to grab them <b>aggressively</b>."
	)

	addtimer(CALLBACK(src, PROC_REF(add_highlight), tutorial_dummy, COLOR_ORANGE), dynamic_message_to_player(script))
	update_objective("Aggressively grab the <font color='[COLOR_ORANGE]'><b>Test Dummy</b></font> by grabbing them twice.")

	RegisterSignal(tutorial_dummy, COMSIG_MOB_AGGRESSIVELY_GRABBED, PROC_REF(on_aggrograb))

/datum/tutorial/ss13/intents/proc/on_aggrograb(datum/source, mob/living/carbon/human/choker)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	UnregisterSignal(tutorial_dummy, COMSIG_MOB_AGGRESSIVELY_GRABBED)
	remove_highlight(tutorial_dummy)
	tutorial_mob.stop_pulling()
	var/list/script = list(
		"The final intent is <b>harm</b>, selected by pressing the <b>[retrieve_bind("select_harm_intent")]</b> key.<br>Harm is used to injure people with your fists or a melee weapon.",
		"<br>Punch the <b>Test Dummy</b> with an empty hand."
	)
	addtimer(CALLBACK(src, PROC_REF(add_highlight), tutorial_dummy, COLOR_RED), dynamic_message_to_player(script))
	update_objective("<font color='[COLOR_RED]'>Attack</font> the <font color='[COLOR_RED]'><b>Test Dummy</b></font> with an empty hand.")
	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_harm_attack))

/datum/tutorial/ss13/intents/proc/on_harm_attack(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if((attacked_mob == src) || (tutorial_mob.a_intent != INTENT_HARM))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	remove_highlight(tutorial_dummy)
	animate(tutorial_dummy, 2 SECONDS, alpha=0)
	QDEL_IN(tutorial_dummy, 2.5 SECONDS)

	var/list/script = list(
		"Excellent. Those are the basics of the intent system.",
		"Further tutorials are available to cover gameplay elements from both <b>Marine</b> or <b>Xenomorph</b> roles.",
		"This tutorial will end shortly. Best of luck out there!"
	)

	update_objective("")

	tutorial_end_in(dynamic_message_to_player(script) + 2 SECONDS, TRUE)

// END OF SCRIPTING
// START OF SCRIPT HELPERS



// END OF SCRIPT HELPERS

/datum/tutorial/ss13/intents/init_mob()
	. = ..()
	tutorial_mob.forceMove(loc_from_corner(2, 0))
