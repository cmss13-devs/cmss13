/datum/hive_status/var/reserved_larva = 0

/datum/action/xeno_action/onclick/set_larva_reserve
	name = "Set Larva Reserve"
	action_icon_state = "project_xeno"

/datum/action/xeno_action/onclick/set_larva_reserve/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/queen = owner
	queen.hive.reserved_larva = tgui_input_number(usr, "Как много грудоломов вы хотите сохранить от желающих зайти наблюдателей?", "Сколько зарезервировать?", queen.hive.reserved_larva, 228, 0)
	to_chat(queen, SPAN_XENONOTICE("Вы зарезервировали [queen.hive.reserved_larva] закопанных грудоломов."))
	return ..()
