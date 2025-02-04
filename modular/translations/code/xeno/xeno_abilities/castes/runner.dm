/datum/action/xeno_action/activable/pounce/runner
	desc = "Наброситься на клетку, опрокидывая первую цель (%KNOCKDOWN%)."

/datum/action/xeno_action/activable/pounce/runner/apply_replaces_in_desc()
	replace_in_desc("%KNOCKDOWN%", convert_effect_time(knockdown_duration, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/runner_skillshot
	desc = "Выстрелить шипом, который наносит %DAMAGE% урона на дистанции %RANGE% Замедляет цель (%SLOWDOWN%)."

/datum/action/xeno_action/activable/runner_skillshot/apply_replaces_in_desc()
	replace_in_desc("%DAMAGE%", /datum/ammo/xeno/bone_chips/spread/runner_skillshot::damage)
	replace_in_desc("%RANGE%", /datum/ammo/xeno/bone_chips/spread/runner_skillshot::max_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%SLOWDOWN%", convert_effect_time(3, SLOW), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/acider_acid
	desc = "Сильная кислота, способная очень бюстро расплавлять объекты. Вы пополняете %ACID_LYING% кислоты, когда наносите удар по лежачим носителям; вы восстанавливаете %ACID_SLASH% кислоты, когда наносите удар по носителю с кислотой. \
		Также, пассивно пополняете %ACID_PASSIVE% раз в 2 секунды."

/datum/action/xeno_action/activable/acider_acid/apply_replaces_in_desc()
	replace_in_desc("%ACID_LYING%", /datum/behavior_delegate/runner_acider::acid_slash_regen_lying)
	replace_in_desc("%ACID_SLASH%", /datum/behavior_delegate/runner_acider::acid_slash_regen_standing)
	replace_in_desc("%ACID_PASSIVE%", /datum/behavior_delegate/runner_acider::acid_passive_regen)

/datum/action/xeno_action/activable/acider_for_the_hive
	desc = "Начинает таймер в %TIMER%, после которого вы взорветесь и обольете всё кислотой вокруг себя. Урон и расстояние зависит от накопленной плазмы (макс. %MAX_ACID%). \
		Максимальная дальность кислоты равна %MAX_RANGE%; максимальный ожоговый урон носителям равен %MAX_BURN_DAMAGE%, а дальность урона носителям %MAX_BURN_RANGE%. Урон падает с расстоянием. \
		Вы можете отменить таймер в любой момент ценой %CANCEL_COST% кислоты. Вы будете издавать звук во время таймера. Также, при взрыве вы будете воскрешены в виде нового грудолома."

/datum/action/xeno_action/activable/acider_for_the_hive/apply_replaces_in_desc()
	replace_in_desc("%TIMER%", /datum/behavior_delegate/runner_acider::caboom_timer, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%MAX_ACID%", /datum/behavior_delegate/runner_acider::max_acid)
	replace_in_desc("%CANCEL_COST%", /datum/behavior_delegate/runner_acider::max_acid / 4)
	replace_in_desc("%MAX_RANGE%", /datum/behavior_delegate/runner_acider::max_acid / /datum/behavior_delegate/runner_acider::caboom_acid_ratio, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%MAX_BURN_DAMAGE%", /datum/behavior_delegate/runner_acider::max_acid / /datum/behavior_delegate/runner_acider::caboom_burn_damage_ratio)
	replace_in_desc("%MAX_BURN_RANGE%", /datum/behavior_delegate/runner_acider::max_acid / /datum/behavior_delegate/runner_acider::caboom_burn_range_ratio, DESCRIPTION_REPLACEMENT_DISTANCE)

