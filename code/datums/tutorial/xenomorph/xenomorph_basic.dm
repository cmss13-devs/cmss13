#define WAITING_HEALTH_THRESHOLD 300

/datum/tutorial/xenomorph/basic
	name = "Ксеноморф - Базовое"
	desc = "Это обучение покажет тебе как играть за ксеноморфа, хотя бы базовое."
	icon_state = "xeno"
	tutorial_id = "xeno_basic_1"
	tutorial_template = /datum/map_template/tutorial/s12x12
	starting_xenomorph_type = /mob/living/carbon/xenomorph/drone

// START OF SCRITPING

/datum/tutorial/xenomorph/basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()

	xeno.plasma_stored = 0
	xeno.plasma_max = 0
	xeno.melee_damage_lower = 40
	xeno.melee_damage_upper = 40
	xeno.lock_evolve = TRUE

	message_to_player("Приветствую тебя, дитя. Ты [xeno.name], дрон, рабочая лошадка всего улья.")

	addtimer(CALLBACK(src, PROC_REF(on_stretch_legs)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_stretch_legs()
	message_to_player("Как дрон, ты будешь выполнять базовые действия в улье. Такие как распространение, строительство, сажание яиц и крепление захваченых хостов (людей).")
	addtimer(CALLBACK(src, PROC_REF(on_inform_health)), 5 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_inform_health()
	message_to_player("Зелёная иконка <b>справа</b>, твоего экрана, зелёный овал показывает твоё здоровье.")
	addtimer(CALLBACK(src, PROC_REF(on_give_plasma)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_give_plasma()
	message_to_player("Тебе была дана <b>плазма</b>, это ресурс для использования твоих способностей. она отображена <b>справа</b> твоего экрана, синий овал.")
	xeno.plasma_max = 200
	xeno.plasma_stored = 200
	addtimer(CALLBACK(src, PROC_REF(on_damage_xenomorph)), 15 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_damage_xenomorph()
	xeno.apply_damage(350)
	xeno.emote("hiss")
	message_to_player("О нет! Ты получил повреждения. Посмотри, количество твоего здоровья снизилось. Ксеноморфы восстанавливают его только если отдыхают на траве улья.")
	addtimer(CALLBACK(src, PROC_REF(request_player_plant_weed)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/request_player_plant_weed()
	update_objective("Установи кластер травы с помощью способности сверху слева, она называется <b>Plant Weeds</b>.")
	give_action(xeno, /datum/action/xeno_action/onclick/plant_weeds)
	message_to_player("Установи кластер травы с помощью своей новой способности. Трава лечит всех ксеноморфов и восстанавливает плазму. Она так же замедляет хостов для более лёгкого боя.")
	RegisterSignal(xeno, COMSIG_XENO_PLANT_RESIN_NODE, PROC_REF(on_plant_resinode))

/datum/tutorial/xenomorph/basic/proc/on_plant_resinode()
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_PLANT_RESIN_NODE)
	message_to_player("Отлично. Теперь ты можешь <b>отдохнуть</b> с помощью нажатия на [retrieve_bind("rest")] или нажав на иконку сверху слева.")
	message_to_player("Мы увеличили твой резерв плазмы. Помни что плазму ты регенерируешь только на траве.")
	give_action(xeno, /datum/action/xeno_action/onclick/xeno_resting)
	update_objective("Отдохни пока не восполнится твоё [WAITING_HEALTH_THRESHOLD] здоровье.")
	xeno.plasma_max = 500
	RegisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS, PROC_REF(on_xeno_gain_health))

/datum/tutorial/xenomorph/basic/proc/on_xeno_gain_health()
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS)
	message_to_player("Пока ты отдыхаешь, лечение очень медленное. Оно может быть ускорено с помощью феромонов. раздай феромоны \"Лечения (Recovery)\" они позволят тебе быстро встать в строй.")
	give_action(xeno, /datum/action/xeno_action/onclick/emit_pheromones)
	update_objective("Раздай феромоны.")
	RegisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES, PROC_REF(on_xeno_emit_pheromone))

/datum/tutorial/xenomorph/basic/proc/on_xeno_emit_pheromone(emitter, pheromone)
	SIGNAL_HANDLER
	if(!(pheromone == "recovery"))
		message_to_player("Это не феромоны лечения. Нажми на способность что бы прекратить раздавать феромоны и попробуй ещё раз.")
	else if(xeno.health > WAITING_HEALTH_THRESHOLD)
		reach_health_threshold()
		UnregisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES)
	else
		UnregisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES)
		message_to_player("Отлично. Лечащие феромоны очень сильно ускоряют твоё лечение. Отдохни пока твоё здоровье не восполнится [WAITING_HEALTH_THRESHOLD].")
		message_to_player("Феромоны так же раздаются всем сёстрам (ксеноморфам) поблизости!")
		RegisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS, PROC_REF(reach_health_threshold))

/datum/tutorial/xenomorph/basic/proc/reach_health_threshold()
	SIGNAL_HANDLER
	if(xeno.health < WAITING_HEALTH_THRESHOLD)
		return

	UnregisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS)

	message_to_player("Хорошо. Отлично!")
	message_to_player("Враждебный человек или \"длинный хост\" появился перед тобой. Используй <b>вред</b> и убей его!")
	update_objective("Убей человека!!!")

	var/mob/living/carbon/human/human_dummy = new(loc_from_corner(7,7))
	add_to_tracking_atoms(human_dummy)
	add_highlight(human_dummy, COLOR_RED)
	RegisterSignal(human_dummy, COMSIG_MOB_DEATH, PROC_REF(on_human_death_phase_one))

/datum/tutorial/xenomorph/basic/proc/on_human_death_phase_one()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)

	UnregisterSignal(human_dummy, COMSIG_MOB_DEATH)
	message_to_player("Отлично. Убийство людей это одно из множества занятий ксеноморфа.")
	message_to_player("Однако! Ты можешь <b>захватить</b> хоста. И вырастить из него ещё ксеноморфов, так что лучше попытайся захватить его!")
	addtimer(CALLBACK(human_dummy, TYPE_PROC_REF(/mob/living, rejuvenate)), 8 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(proceed_to_tackle_phase)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/proceed_to_tackle_phase()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	remove_highlight(human_dummy)
	RegisterSignal(human_dummy, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(on_tackle_phase_human_damage))
	RegisterSignal(human_dummy, COMSIG_MOB_TACKLED_DOWN, PROC_REF(proceed_to_cap_phase))
	message_to_player("Толкни хоста с помощью <b>толкания</b>. Это может потребовать нескольких попыток для дрона.")
	update_objective("Толкни хоста на землю!")

/datum/tutorial/xenomorph/basic/proc/on_tackle_phase_human_damage(source, damagedata)
	SIGNAL_HANDLER
	if(damagedata["damage"] <= 0)
		return
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	// Rejuvenate the dummy if it's less than half health so our player can't kill it and softlock themselves.
	if(human_dummy.health < (human_dummy.maxHealth / 2))
		message_to_player("Не надо убивать если можешь захватить!")
		human_dummy.rejuvenate()

/datum/tutorial/xenomorph/basic/proc/proceed_to_cap_phase()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)

	UnregisterSignal(human_dummy, COMSIG_MOB_TACKLED_DOWN)

	ADD_TRAIT(human_dummy, TRAIT_KNOCKEDOUT, TRAIT_SOURCE_TUTORIAL)
	ADD_TRAIT(human_dummy, TRAIT_FLOORED, TRAIT_SOURCE_TUTORIAL)
	xeno.melee_damage_lower = 0
	xeno.melee_damage_upper = 0
	message_to_player("Отлично. В основном, если ты продолжаешь толкать хоста, он останется лежать, а может и встать, но тут он будет лежать вечно.")
	addtimer(CALLBACK(src, PROC_REF(cap_phase)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/cap_phase()
	var/obj/effect/alien/resin/special/eggmorph/morpher = new(loc_from_corner(2,2), GLOB.hive_datum[XENO_HIVE_TUTORIAL])
	morpher.stored_huggers = 1
	add_to_tracking_atoms(morpher)
	add_highlight(morpher, COLOR_YELLOW)
	message_to_player("На юго-западе появился формовщик яиц. Нажми на него что бы получить <b>лицехвата</b>.")
	RegisterSignal(xeno, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER, PROC_REF(take_facehugger_phase))

/datum/tutorial/xenomorph/basic/proc/take_facehugger_phase(source, hugger)
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/effect/alien/resin/special/eggmorph, morpher)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	add_to_tracking_atoms(hugger)
	remove_highlight(morpher)

	add_highlight(hugger, COLOR_YELLOW)
	message_to_player("Это лицехват, он подсвечен. Возьми его нажатием на него.")
	message_to_player("Подойди к человеку на земле и кликни на него. или урони лицехвата рядом что бы посмотреть как он автоматически прыгнет на него после подготовки.")
	RegisterSignal(human_dummy, COMSIG_HUMAN_IMPREGNATE, PROC_REF(nest_cap_phase))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/mask/facehugger, hugger)
	UnregisterSignal(human_dummy, COMSIG_MOB_TAKE_DAMAGE)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_IMPREGNATE)
	remove_highlight(hugger)

	message_to_player("Нам нужно сделать так, что бы хост не убежал из улья, для этого нужно их прикрепить к стене.")
	message_to_player("Хосты не могут сбежать из резины без чьей то помощи, так же резина будет поддерживать его жизнь пока новые сёстры не прорвут его торс.")
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_two)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_two()

	loc_from_corner(8,0).ChangeTurf(/turf/closed/wall/resin/tutorial)
	loc_from_corner(8,1).ChangeTurf(/turf/closed/wall/resin/tutorial)
	loc_from_corner(9,1).ChangeTurf(/turf/closed/wall/resin/tutorial)

	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_three)), 5 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_three()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	message_to_player("Схвати хоста с помощью захвата. Или используй <b>Ctrl + Click</b>.")
	RegisterSignal(human_dummy, COMSIG_MOVABLE_XENO_START_PULLING, PROC_REF(nest_cap_phase_four))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_four()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOVABLE_XENO_START_PULLING)
	message_to_player("Отлично. Теперь поглоти его с помощью нажатия на себя. Тебе нельзя двигаться во время этого.")
	RegisterSignal(human_dummy, COMSIG_MOB_DEVOURED, PROC_REF(nest_cap_phase_five))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_five()
	SIGNAL_HANDLER
	message_to_player("Отлично теперь ты можешь его срыгнуть с помощью новой способности.")
	message_to_player("Будь осторожен! Хосты часто сопротивляются и пробуют разрезать тебя изнутри! Так же они через некоторое время выберутся сами.")
	give_action(xeno, /datum/action/xeno_action/onclick/regurgitate)
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_six)), 15 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_six()
	message_to_player("Хосты могут быть прикреплены к стенам которые обвиты <b>травой улья</b>. Это специальная трава которая образуется в улье и с помощью кластеров.")
	message_to_player("Мы поместили тебе траву улья на востоке.")
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_seven)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_seven()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOB_DEVOURED)
	RegisterSignal(human_dummy, COMSIG_MOB_NESTED, PROC_REF(on_mob_nested))
	message_to_player("Прирезинь этого пленного хоста!")
	update_objective("Прирезинь этого пленного хоста!")
	message_to_player("Поднеси хоста к стене рядом с которой появилась трава.")
	message_to_player("Теперь захвати хоста и нажми по стене, или зажми мышку на хосте и перетащи на стену. Ты не должен двигаться.")
	new /obj/effect/alien/resin/special/cluster(loc_from_corner(9,0), GLOB.hive_datum[XENO_HIVE_TUTORIAL])

/datum/tutorial/xenomorph/basic/proc/on_mob_nested()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOB_NESTED)

	message_to_player("Отлично! Теперь ты знаешь как играть за ксеноморфа!.")
	message_to_player("Скоро тебя вернёт в лобби.")
	tutorial_end_in(10 SECONDS)

// END OF SCRIPTING

/datum/tutorial/xenomorph/basic/init_map()
	loc_from_corner(9,0).ChangeTurf(/turf/closed/wall/resin/tutorial)

#undef WAITING_HEALTH_THRESHOLD
