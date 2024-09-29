/datum/tutorial/ss13/intents
	name = "Space Station 13 - Intents"
	desc = "Learn how the intent interaction system works."
	icon_state = "intents"
	tutorial_id = "ss13_intents_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

// START OF SCRIPTING

/datum/tutorial/ss13/intents/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This is the tutorial for the <b>intents</b> system of Space Station 13. The highlighted UI element in the bottom-right corner is your current intent.")
	var/datum/hud/human/human_hud = tutorial_mob.hud_used
	add_highlight(human_hud.action_intent)

	addtimer(CALLBACK(src, PROC_REF(require_help)), 4.5 SECONDS)

/datum/tutorial/ss13/intents/proc/require_help()
	tutorial_mob.a_intent_change(INTENT_DISARM)
	message_to_player("Your intent has been changed off of <b>help</b>. Change back to it by pressing <b>[retrieve_bind("select_help_intent")]</b>.")
	update_objective("Change to help intent by pressing [retrieve_bind("select_help_intent")].")

	RegisterSignal(tutorial_mob, COMSIG_MOB_INTENT_CHANGE, PROC_REF(on_help_intent))

/datum/tutorial/ss13/intents/proc/on_help_intent(datum/source, new_intent)
	SIGNAL_HANDLER

	if(new_intent != INTENT_HELP)
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_INTENT_CHANGE)

	var/mob/living/carbon/human/dummy/tutorial/tutorial_dummy = new(loc_from_corner(2, 3))
	add_to_tracking_atoms(tutorial_dummy)

	message_to_player("The first of the intents is <b>help</b> intent. It is used to harmlessly touch others, put out fire, give CPR, and similar. Click on the <b>Test Dummy</b> to give them a pat on the back.")
	update_objective("Click on the dummy on help intent.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_help_attack))

/datum/tutorial/ss13/intents/proc/on_help_attack(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if((attacked_mob == src) || (tutorial_mob.a_intent != INTENT_HELP))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	tutorial_dummy.status_flags = DEFAULT_MOB_STATUS_FLAGS
	REMOVE_TRAIT(tutorial_dummy, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
	tutorial_dummy.anchored = FALSE

	message_to_player("The second intent is <b>disarm</b>, selectable with <b>[retrieve_bind("select_disarm_intent")]</b>. Disarm is used to shove people, which can make them drop items or fall to the ground. Shove the <b>Test Dummy</b> until it falls over.")
	update_objective("Switch to disarm intent by pressing [retrieve_bind("select_disarm_intent")] and shove the dummy to the ground.")

	RegisterSignal(tutorial_dummy, COMSIG_LIVING_APPLY_EFFECT, PROC_REF(on_shove_down))

/datum/tutorial/ss13/intents/proc/on_shove_down(datum/source, datum/status_effect/new_effect)
	SIGNAL_HANDLER

	if(!istype(new_effect, /datum/status_effect/incapacitating/knockdown))
		return

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	UnregisterSignal(tutorial_dummy, COMSIG_LIVING_APPLY_EFFECT)
	tutorial_dummy.rejuvenate()

	message_to_player("The third intent is <b>grab</b>. Grab is used to grab people in either a passive, aggressive, or chokehold grab. Grab successively to \"upgrade\" your grab. Aggressively grab the <b>Test Dummy</b>.")
	update_objective("Aggressively grab the dummy by grabbing them twice.")


	RegisterSignal(tutorial_dummy, COMSIG_MOB_AGGRESSIVELY_GRABBED, PROC_REF(on_aggrograb))

/datum/tutorial/ss13/intents/proc/on_aggrograb(datum/source, mob/living/carbon/human/choker)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	UnregisterSignal(tutorial_dummy, COMSIG_MOB_AGGRESSIVELY_GRABBED)

	message_to_player("The final intent is <b>harm</b>. Harm is used to injure people with your fists or a melee weapon. Punch the <b>Test Dummy</b> with an empty hand.")
	update_objective("Attack the dummy with an empty hand.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_harm_attack))

/datum/tutorial/ss13/intents/proc/on_harm_attack(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if((attacked_mob == src) || (tutorial_mob.a_intent != INTENT_HARM))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	tutorial_dummy.status_flags = GODMODE

	message_to_player("Excellent. Those are the basics of the intent system. The tutorial will end shortly.")
	update_objective("")

	tutorial_end_in(5 SECONDS, TRUE)

// END OF SCRIPTING
// START OF SCRIPT HELPERS



// END OF SCRIPT HELPERS

/datum/tutorial/ss13/intents/init_mob()
	. = ..()
	tutorial_mob.forceMove(loc_from_corner(2, 0))
