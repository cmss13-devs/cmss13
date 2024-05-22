/datum/tutorial/ss13/intents
	name = "Space Station 13 - Интенты"
	desc = "Что такое интенты, и почему 'настрой' так важен."
	icon_state = "intents"
	tutorial_id = "ss13_intents_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

// START OF SCRIPTING

/datum/tutorial/ss13/intents/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("Это обучение покажет вам <b>интенты</b> стандартная механика Space Station 13. Снизу справа у тебя есть подсвеченный интерфейс, он показывает твой настрой.")
	var/datum/hud/human/human_hud = tutorial_mob.hud_used
	add_highlight(human_hud.action_intent)

	addtimer(CALLBACK(src, PROC_REF(require_help)), 6 SECONDS)

/datum/tutorial/ss13/intents/proc/require_help()
	tutorial_mob.a_intent_change(INTENT_DISARM)
	message_to_player("Сейчас твой настрой изменён с <b>помощи</b> на <b>толкать</b> поменяй его обратно используя <b>[retrieve_bind("select_help_intent")]</b>.")
	update_objective("Смени свой настрой обратно на помощь исопльзуя [retrieve_bind("select_help_intent")].")

	RegisterSignal(tutorial_mob, COMSIG_MOB_INTENT_CHANGE, PROC_REF(on_help_intent))

/datum/tutorial/ss13/intents/proc/on_help_intent(datum/source, new_intent)
	SIGNAL_HANDLER

	if(new_intent != INTENT_HELP)
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_INTENT_CHANGE)

	var/mob/living/carbon/human/dummy/tutorial/tutorial_dummy = new(loc_from_corner(2, 3))
	add_to_tracking_atoms(tutorial_dummy)

	message_to_player("Первый настрой это <b>Помощь</b>. Он используется что бы делать безвредные действия, например: потушить морпеха в огне, сделать искуственной дыхание, и т.д. Нажми на <b>куклу</b> и ты её шлёпнешь по спине.")
	update_objective("Нажми на куклу с настроем помощи.")

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

	message_to_player("Второй настрой это <b>толкать</b>, выбирается с помощью <b>[retrieve_bind("select_disarm_intent")]</b>. Он позволяет тебе толкать людей, из за чего они могут уронить предмет в руках или упасть. толкни <b>куклу</b> что бы она упала на землю.")
	update_objective("Смени настрой используя [retrieve_bind("select_disarm_intent")] и толкни куклу на землю.")

	RegisterSignal(tutorial_dummy, COMSIG_LIVING_APPLY_EFFECT, PROC_REF(on_shove_down))

/datum/tutorial/ss13/intents/proc/on_shove_down(datum/source, datum/status_effect/new_effect)
	SIGNAL_HANDLER

	if(!istype(new_effect, /datum/status_effect/incapacitating/knockdown))
		return

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	UnregisterSignal(tutorial_dummy, COMSIG_LIVING_APPLY_EFFECT)
	tutorial_dummy.rejuvenate()

	message_to_player("Третий настрой это <b>хватать</b>. Хватать используется для того что бы захватывать людей в пассивный, агрессивный, и удушающий захват. Нажми ещё раз что бы \"усилить\" свой захват. Захвати в агрессивный захват <b>куклу</b>.")
	update_objective("Возьми куклу в агрессивный захват.")


	RegisterSignal(tutorial_dummy, COMSIG_MOB_AGGRESSIVELY_GRABBED, PROC_REF(on_aggrograb))

/datum/tutorial/ss13/intents/proc/on_aggrograb(datum/source, mob/living/carbon/human/choker)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	UnregisterSignal(tutorial_dummy, COMSIG_MOB_AGGRESSIVELY_GRABBED)

	message_to_player("И мы близимся к финалу <b>вред</b>. Вред используется что бы навредить кому то с помощью кулаков или ближнего оружия. Ударь <b>куклу</b> с помощью пустой руки.")
	update_objective("Ударь куклу с помощью пустой руки.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_harm_attack))

/datum/tutorial/ss13/intents/proc/on_harm_attack(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if((attacked_mob == src) || (tutorial_mob.a_intent != INTENT_HARM))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	tutorial_dummy.status_flags = GODMODE

	message_to_player("Отлично, теперь ты знаешь о системе настроя, одной из самых важных систем! Это обучение вскоре завершится.")
	update_objective("")

	tutorial_end_in(5 SECONDS, TRUE)

// END OF SCRIPTING
// START OF SCRIPT HELPERS



// END OF SCRIPT HELPERS

/datum/tutorial/ss13/intents/init_mob()
	. = ..()
	tutorial_mob.forceMove(loc_from_corner(2, 0))
