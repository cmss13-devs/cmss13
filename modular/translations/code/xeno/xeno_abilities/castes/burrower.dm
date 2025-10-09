/datum/action/xeno_action/activable/burrow
	desc = "Зарыться под землю. Вы можете находиться под землёй %TIME% Используйте повторно под землей, чтобы выйти в указанной точке. \
		Носители, оказавшиеся над местом выхода, будут опрокинуты (%WEAKEN%)."

/datum/action/xeno_action/activable/burrow/apply_replaces_in_desc()
	replace_in_desc("%TIME%", 9, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%WEAKEN%", convert_effect_time(2, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/tremor
	desc = "Сильный топот, который оглушает носителей (%TIME%) вокруг вас на расстоянии %DISTANCE%"

/datum/action/xeno_action/onclick/tremor/apply_replaces_in_desc()
	replace_in_desc("%TIME%", convert_effect_time(1, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DISTANCE%", 3, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/onclick/build_tunnel
	desc = "Вырыть туннель, который будет соединен с сетью туннелей."
