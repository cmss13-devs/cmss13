/datum/action/xeno_action/activable/xeno_spit/spitter
	desc = "Дальнобойный кислотный плевок."

// Handled by basic version
/datum/action/xeno_action/activable/xeno_spit/spitter/apply_replaces_in_desc()
	return ..()

/datum/action/xeno_action/onclick/charge_spit
	desc = "Собирает кислоту в гландах, повышая скорость передвижения и броню (%ARMOR%).\
		<br>Следующий плевок будет усилен до %DAMAGE% урона, дальность уменьшена до %RANGE%\
		<br>На цели будет создана кислота, наносящая %ACID_HUMAN% урона носителям и %ACID_STR% объектам в течении времени (%TIME%).\
		<br>Кислота может быть усилена с помощью Spray Acid, увеличивая эффективность кислоты в два раза и обновляя таймер кислоты."

/datum/action/xeno_action/onclick/charge_spit/apply_replaces_in_desc()
	replace_in_desc("%ARMOR%", armor_buff_amount)
	replace_in_desc("%DAMAGE%", /datum/ammo/xeno/acid/spatter::damage)
	replace_in_desc("%RANGE%", /datum/ammo/xeno/acid/spatter::max_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%TIME%", /datum/effects/acid::duration, DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%ACID_HUMAN%", /datum/effects/acid::damage_in_total_human)
	replace_in_desc("%ACID_STR%", /datum/effects/acid::damage_in_total_obj)

/datum/action/xeno_action/activable/spray_acid/spitter
	desc = "Спрей из линии кислоты, наносящий %DAMAGE% урона на расстоянии %RANGE%\
		<br>Если на цели имеется кислота, она получает дополнительно %DAMAGE_BONUS% урона, а также усиливает кислоту на цели.\
		<br>Если кислота была усилена, цель будет оглушена (%KNOCKDOWN_BONUS%)."

/datum/action/xeno_action/activable/spray_acid/spitter/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", spray_distance, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%DAMAGE%", /obj/effect/xenomorph/spray/weak::damage_amount)
	replace_in_desc("%KNOCKDOWN_BONUS%", convert_effect_time(/obj/effect/xenomorph/spray/weak::stun_duration, STUN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DAMAGE_BONUS%", /obj/effect/xenomorph/spray/weak::bonus_damage)

// Need to update tail first
/datum/action/xeno_action/activable/tail_stab/spitter
