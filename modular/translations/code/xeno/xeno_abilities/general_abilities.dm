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
	desc = "%POWER%, способная уничтожать источники света и окружение."

/datum/action/xeno_action/activable/corrosive_acid/apply_replaces_in_desc()
	switch(level)
		if(1)
			replace_in_desc("%POWER%", "Слабая кислота")
		if(2)
			replace_in_desc("%POWER%", "Обычная кислота")
		if(3)
			replace_in_desc("%POWER%", "Сильная кислота")
		else
			replace_in_desc("%POWER%", "Необычная кислота")

/datum/action/xeno_action/onclick/emit_pheromones
	desc = "Выбрать излучаемые феромоны. Если имеется несколько доступных феромонов одного типа, выбирается сильнейший.\
		<br><br>Сила ваших феромонов: %STRENGTH%"

/datum/action/xeno_action/onclick/emit_pheromones/apply_replaces_in_desc()
	var/mob/living/carbon/xenomorph/xeno = owner
	replace_in_desc("%STRENGTH%", get_pheromone_aura_strength(xeno.caste.aura_strength + xeno.phero_modifier))

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

/datum/action/xeno_action/onclick/toggle_long_range/apply_replaces_in_desc()
	if(should_delay)
		desc += "<br>Имеется задержка активации в %DELAY%"
		replace_in_desc("%DELAY%", delay / 10, DESCRIPTION_REPLACEMENT_TIME)
	if(!handles_movement)
		desc += "<br>Вы не можете двигаться в этом режиме."

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
	desc = "Передаёт плазму (%PLASMA%) сестре с задержкой в %DELAY% на расстоянии %RANGE%"

/datum/action/xeno_action/activable/transfer_plasma/apply_replaces_in_desc()
	replace_in_desc("%PLASMA%", plasma_transfer_amount)
	replace_in_desc("%DELAY%", transfer_delay / 10, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%RANGE%", max_range, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/onclick/xenohide
	desc = "Прятаться под объектами окружения."

/datum/action/xeno_action/onclick/place_trap
	desc = "Поставить ловушку на траве. Её можно заполнить кислотой, газом или лицехватом. Активируется при приближении."

/datum/action/xeno_action/activable/place_construction
	desc = "Построить продвинутые структуры. Требуется усиленная трава с Hive Core/Hive Cluster, а также свободное пространство вокруг точки установки."

/datum/action/xeno_action/activable/xeno_spit
	desc = "Дальнобойный плевок."

/datum/action/xeno_action/activable/xeno_spit/apply_replaces_in_desc()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/ammo/xeno/spit = xeno.ammo || GLOB.ammo_list[xeno.caste.spit_types[1]]
	desc += "[spit.get_description()]"

/datum/action/xeno_action/activable/tail_stab
	desc = "Удар хвостом на расстоянии %TAIL_DISTANCE%, наносящий %TAIL_DAMAGE% урона, а также дезориентирирует цель (%TAIL_DAZE%)."

/datum/action/xeno_action/activable/tail_stab/apply_replaces_in_desc()
	var/mob/living/carbon/xenomorph/xeno = owner
	replace_in_desc("%TAIL_DAMAGE%", xeno.melee_damage_upper * TAILSTAB_MOB_DAMAGE_MULTIPLIER)
	replace_in_desc("%TAIL_DISTANCE%", stab_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%TAIL_DAZE%", xeno.mob_size >= MOB_SIZE_BIG ? convert_effect_time(3, DAZE) : convert_effect_time(1, DAZE), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/evolve
	desc = "Эволюционировать в следующий уровень. Количество доступных слотов можно посмотреть в Hive Status."

/datum/action/xeno_action/onclick/tacmap
	desc = "Тактическая карта с двумя режимами - режимом прямого эфира с текущим положением сестёр, а также режим планирования, где Королева может рисовать план."

/datum/action/xeno_action/active_toggle/toggle_meson_vision
	desc = "Переключение видимости пола за стенами."
