/datum/hive_status/var/reserved_larva = 0

/datum/action/xeno_action/onclick/set_larva_reserve
	name = "Set Larva Reserve"
	action_icon_state = "project_xeno"

/datum/action/xeno_action/onclick/set_larva_reserve/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/queen = owner
	queen.hive.reserved_larva = tgui_input_number(usr, "Как много грудоломов вы хотите сохранить от желающих зайти наблюдателей?", "Сколько зарезервировать?", queen.hive.reserved_larva, 228, 0)
	to_chat(queen, SPAN_XENONOTICE("Вы зарезервировали [queen.hive.reserved_larva] закопанных грудоломов."))
	return ..()

/datum/action/xeno_action/onclick/give_tech_points
	name = "Trade Larva for Tech Points (100)"
	action_icon_state = "queen_give_evo_points"
	plasma_cost = 100
	xeno_cooldown = 60 SECONDS
	var/required_larva = 1
	var/duration = 10 MINUTES
	var/to_give = 12
	var/active = FALSE

/datum/action/xeno_action/onclick/charger_charge/queen
	ability_primacy = XENO_SCREECH

/datum/action/xeno_action/activable/fling/charger/queen
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	fling_distance = 4
	stun_power = 2
	weaken_power = 0
	slowdown = 8

/datum/action/xeno_action/activable/secrete_resin/hivelord/queen_macro
	ability_primacy = XENO_PRIMARY_ACTION_5
