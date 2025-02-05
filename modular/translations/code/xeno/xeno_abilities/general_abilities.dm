/datum/action/xeno_action/onclick/plant_weeds
	desc = "Посадить траву, на которой сёстры быстрее передвигаются, регенерируют здоровье и плазму, а носители замедляются."

/datum/action/xeno_action/onclick/xeno_resting
	desc = "Отдых позволяет быстрее регенерировать здоровье."

/datum/action/xeno_action/onclick/shift_spits
	desc = "Переключить вид плевка."

/datum/action/xeno_action/onclick/shift_spits/use_ability(atom/A)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/action/xeno_action/activable/xeno_spit/spit = get_action(xeno, /datum/action/xeno_action/activable/xeno_spit)
	spit.update_desc()

/datum/action/xeno_action/onclick/regurgitate
	desc = "Выпленуть носителя, если он находится в вас."

/datum/action/xeno_action/onclick/choose_resin
	desc = "Выбрать структуру, которая будет поставлена с помощью Secrete Resin."

/datum/action/xeno_action/activable/secrete_resin
	desc = "Поставить структуру, выбранную с помощью Choose Resin Structure."

/datum/action/xeno_action/activable/info_marker

/datum/action/xeno_action/activable/corrosive_acid
	desc = "Уничтожает источники света и окружение. Скорость зависит от силы кислоты (взависимости от касты)."

/datum/action/xeno_action/onclick/emit_pheromones
	desc = "Выбрать излучаемые феромоны. Феромоны одного типа не стакаются; если имеется несколько доступных феромонов одного типа, выбирается сильнейший."

/datum/action/xeno_action/activable/pounce
	desc = "Наброситься на клетку (%DISTANCE%)."

/datum/action/xeno_action/activable/pounce/apply_replaces_in_desc()
	replace_in_desc("%DISTANCE%", distance, DESCRIPTION_REPLACEMENT_DISTANCE)
	if(knockdown)
		desc += " Опрокидывает цель (%KNOCKDOWN_DURATION%)."
	replace_in_desc("%KNOCKDOWN_DURATION%", convert_effect_time(knockdown_duration, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	if(slash)
		desc += " Наносит удар цели при попадании."
		if(slash_bonus_damage)
			desc += " Этот удар наносит на %SLASH_BONUS% урона больше."
	replace_in_desc("%SLASH_BONUS%", slash_bonus_damage)
	if(freeze_self)
		desc += " При попадании по цели, вы не сможете двигаться %FREEZE_TIME%"
	replace_in_desc("%FREEZE_TIME%", freeze_time / 10, DESCRIPTION_REPLACEMENT_TIME)
	if(windup)
		desc += " ВНИМАНИЕ: имеется задержка перед прыжком в %WINDUP_TIME%"
	replace_in_desc("%WINDUP_TIME%", windup_duration / 10, DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/toggle_long_range
	desc = "Позволяет смотреть вдаль."

/datum/action/xeno_action/activable/spray_acid
	desc = "Спрей из линии кислоты, наносящий %DAMAGE% урона на расстоянии %RANGE%"

/datum/action/xeno_action/activable/spray_acid/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", spray_distance, DESCRIPTION_REPLACEMENT_DISTANCE)
	var/obj/effect/xenomorph/spray/spray = spray_effect_type
	replace_in_desc("%DAMAGE%", spray::damage_amount)
	if(activation_delay)
		desc += "<br>Имеется задержка перед активацией в <b>[activation_delay_length / 10] сек.</b>"
	if(spray::stun_duration)
		desc += "<br>Оглушает цель на <b>[convert_effect_time(spray::stun_duration, WEAKEN)] сек.</b>"

/datum/action/xeno_action/activable/transfer_plasma
	desc = "Передать плазму сестре."

/datum/action/xeno_action/onclick/xenohide
	desc = "Прятаться под объектами окружения."

/datum/action/xeno_action/onclick/place_trap
	desc = "Поставить ловушку на траве. Необходимо её заполнить после установки. Активируется при приближении."

/datum/action/xeno_action/activable/place_construction
	desc = "Построить продвинутые структуры. Требуется усиленная трава с Hive Core/Hive Cluster, а также свободное пространство вокруг точки установки."

/datum/action/xeno_action/activable/xeno_spit
	desc = "Дальнобойный плевок."

/datum/action/xeno_action/activable/xeno_spit/apply_replaces_in_desc()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/ammo/xeno/spit = xeno.ammo || GLOB.ammo_list[xeno.caste.spit_types[1]]
	desc += "[spit.get_description()]"

/datum/action/xeno_action/activable/tail_stab
	desc = "Удар хвостом на расстоянии 2-х клеток, который наносит на 20% больше урона, чем удар когтями, а также дезориентирирует цель."

/datum/action/xeno_action/onclick/evolve
	desc = "Эволюционировать в следующий уровень. Количество доступных слотов можно посмотреть в Hive Status."

/datum/action/xeno_action/onclick/tacmap
	desc = "Тактическая карта с двумя режимами - режимом прямого эфира с текущим положением сестёр, а также режим планирования, где Королева может рисовать план."

/datum/action/xeno_action/active_toggle/toggle_meson_vision
	desc = "Переключение видимости пола за стенами."
