/datum/action/xeno_action/activable/throw_hugger
	desc = "Достаёт лицехвата из хранилища или кидает его на расстояние %RANGE%\
		<br>Использование на лицехватах или морферах добавляет их в хранилище."

/datum/action/xeno_action/activable/throw_hugger/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", 4, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/activable/retrieve_egg
	desc = "Достаёт яйцо из хранилища.\
		<br>Использование на морфере перенесёт яйцо в морфер."

/datum/action/xeno_action/onclick/set_hugger_reserve
	desc = "Ограничивает количество доступных лицехватов для наблюдателей."

/datum/action/xeno_action/active_toggle/generate_egg
	desc = "Начинает генерацию яиц, используя %TICK_COST% плазмы в секунду"

/datum/action/xeno_action/active_toggle/generate_egg/apply_replaces_in_desc()
	replace_in_desc("%TICK_COST%", round(plasma_use_per_tick / 2, 0.1))
