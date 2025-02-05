/datum/action/xeno_action/activable/pounce/lurker

/datum/action/xeno_action/activable/pounce/lurker/apply_replaces_in_desc()
	. = ..()
	desc += "<br><br>Вы сможете двигаться раньше, когда нанесёте удар когтями. При прыжке с невидимости, вы оглушаете цель (%KNOCKDOWN_DURATION%)."
	replace_in_desc("%KNOCKDOWN_DURATION%", convert_effect_time(knockdown_duration, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/lurker_invisibility
	desc = "Войти в невидимость на %INV_DURATION% Будучи в невидимости, вас будет крайне сложно заметить, и вы будете передвигаться быстрее."

/datum/action/xeno_action/onclick/lurker_invisibility/apply_replaces_in_desc()
	replace_in_desc("%INV_DURATION%", duration / 10, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/lurker_assassinate
	desc = "Увеличивает урон от вашего следующего удара на %BUFF_DAMAGE%%. Этот удар также значительно замедлит цель (%SLOW_DURATION%). Активация сбрасывает перезарядку между ударами."

/datum/action/xeno_action/onclick/lurker_assassinate/apply_replaces_in_desc()
	replace_in_desc("%BUFF_DURATION%", buff_duration / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%BUFF_DAMAGE%", /datum/behavior_delegate/lurker_base::buffed_slash_damage_ratio * 100 - 100)
	replace_in_desc("%SLOW_DURATION%", convert_effect_time(3, SUPERSLOW), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/pounce/rush

/datum/action/xeno_action/activable/pounce/rush/apply_replaces_in_desc()
	. = ..()
	desc += "<br><br>Наносит %DAMAGE_RUSH% урона цели."
	replace_in_desc("%DAMAGE_RUSH%", /datum/caste_datum/lurker::melee_damage_upper)

/datum/action/xeno_action/activable/flurry
	desc = "Провести шквал ударов когтями перед вами размером 1x3, наносит %DAMAGE_FLURRY% урона каждой цели. Также лечит %HEAL_FLURRY% здоровья за каждую цель."

/datum/action/xeno_action/activable/flurry/apply_replaces_in_desc()
	replace_in_desc("%DAMAGE_FLURRY%", /datum/caste_datum/lurker::melee_damage_upper)
	replace_in_desc("%HEAL_FLURRY%", 30)

/datum/action/xeno_action/activable/tail_jab
	desc = "Наносит удар хвостом на расстоянии %TAIL_DISTANCE% Наносит %TAIL_DAMAGE% урона цели, и ещё %TAIL_DAMAGE_DIRECT% сверху, если вы кликнули ровно по цели. \
		Замедляет цель (%SLOWDOWN_DURATION%) и отталкивает её. Если цель ударится об препятствие, цель получит ещё %THROW_DAMAGE% урона, дополнительное замедление и будет опрокинута (%SLOWDOWN_DURATION%)"

/datum/action/xeno_action/activable/tail_jab/apply_replaces_in_desc()
	replace_in_desc("%TAIL_DISTANCE%", 2, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%TAIL_DAMAGE%", /datum/caste_datum/lurker::melee_damage_upper)
	replace_in_desc("%TAIL_DAMAGE_DIRECT%", 15)
	replace_in_desc("%SLOWDOWN_DURATION%", convert_effect_time(0.5, SLOW), DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%THROW_DAMAGE%", MELEE_FORCE_TIER_2)

/datum/action/xeno_action/activable/headbite
	desc = "Позволяет прокусить голову живому носителю, если он лежит без сознания. Задержка перед укусом составляет %DELAY% Успешный укус убивает цель и лечит вас на %HEAL% здоровья."

/datum/action/xeno_action/activable/headbite/apply_replaces_in_desc()
	replace_in_desc("%DELAY%", 0.8, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%HEAL%", 150)
