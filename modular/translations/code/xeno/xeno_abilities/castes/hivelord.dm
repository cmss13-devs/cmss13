/datum/action/xeno_action/active_toggle/toggle_speed
	desc = "При активации значительно увеличивает скорость передвижения по траве. Тратит %TICK% плазмы раз в 2 секунды."

/datum/action/xeno_action/active_toggle/toggle_speed/apply_replaces_in_desc()
	replace_in_desc("%TICK%", plasma_use_per_tick)
