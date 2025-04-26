/datum/action/xeno_action/activable/fling
	desc = "Кинуть цель вперёд от вас (%FLING_DISTANCE%). Оглушает цель (%FLING_STUN%). Замедляет цель (%FLING_SLOWDOWN%)."

/datum/action/xeno_action/activable/fling/apply_replaces_in_desc()
	replace_in_desc("%FLING_STUN%", convert_effect_time(stun_power, STUN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%FLING_SLOWDOWN%", convert_effect_time(slowdown, SLOW), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%FLING_DISTANCE%", fling_distance, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/activable/lunge
	desc = "Сделать рывок к цели (%LUNGE_DISTANCE%). Оглушает цель (%LUNGE_STUN%). Вы автоматически возьмёте эту цель в захват."

/datum/action/xeno_action/activable/lunge/apply_replaces_in_desc()
	replace_in_desc("%LUNGE_DISTANCE%", grab_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%LUNGE_STUN%", convert_effect_time(2, STUN), DESCRIPTION_REPLACEMENT_TIME) // Hardcoded in warrior's grab code

/datum/action/xeno_action/activable/warrior_punch
	desc = "Отталкивающий удар, наносящий %PUNCH_DAMAGE_MIN%-%PUNCH_DAMAGE_MAX% урона. Разрушает шины на конечности. Замедляет цель (%PUNCH_SLOWDOWN%). На мгновение дезориентирует цель."

/datum/action/xeno_action/activable/warrior_punch/apply_replaces_in_desc()
	replace_in_desc("%PUNCH_DAMAGE_MIN%", base_damage)
	replace_in_desc("%PUNCH_DAMAGE_MAX%", base_damage + damage_variance)
	replace_in_desc("%PUNCH_SLOWDOWN%", convert_effect_time(3, SLOW), DESCRIPTION_REPLACEMENT_TIME) // Hardcoded
