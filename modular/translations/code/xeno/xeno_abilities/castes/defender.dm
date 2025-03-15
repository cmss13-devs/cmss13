/datum/action/xeno_action/onclick/toggle_crest
	desc = "Опускает гребень. Если гребень опущен, скорость передвижения уменьшается, а броня увеличивается (%ARMOR%). Не позволяет откинуть вас."

/datum/action/xeno_action/onclick/toggle_crest/apply_replaces_in_desc()
	replace_in_desc("%ARMOR%", armor_buff)

/datum/action/xeno_action/activable/headbutt
	desc = "Ударить гребнем. Дистанция равна %RANGE% (%RANGE_CREST%, если гребень опущен). \
		При попадании наносит %DAMAGE% урона (%DAMAGE_CREST% урона, если гребень опущен), и толкает цель на %THROW% (%THROW_CREST%, если гребень опущен, или мы укреплены). \
		Нельзя использовать при укреплении"

/datum/action/xeno_action/activable/headbutt/apply_replaces_in_desc()
	replace_in_desc("%RANGE%", 3, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%RANGE_CREST%", 1, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%DAMAGE%", base_damage)
	replace_in_desc("%DAMAGE_CREST%", base_damage - 10)
	replace_in_desc("%THROW%", 1, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%THROW_CREST%", 1 + 2, DESCRIPTION_REPLACEMENT_DISTANCE)

/datum/action/xeno_action/activable/headbutt/steel_crest
	desc = "Ударить гребнем. Дистанция равна %RANGE% (%RANGE_CREST%, если гребень опущен). \
		При попадании наносит %DAMAGE% урона (%DAMAGE_CREST% урона, если гребень опущен), и толкает цель на %THROW% (%THROW_CREST%, если гребень опущен, или мы укреплены). \
		Можно использовать при укреплении."

/datum/action/xeno_action/onclick/tail_sweep
	desc = "Ударить хвостом вокруг себя, толкая и опрокидывая (%KNOCKDOWN%) носителей вокруг себя. Наносит %DAMAGE% урона. \
		Нельзя использовать с опущенным гребнем или при укреплении."

/datum/action/xeno_action/onclick/tail_sweep/apply_replaces_in_desc()
	replace_in_desc("%KNOCKDOWN%", convert_effect_time(1, WEAKEN), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%DAMAGE%", 15)

/datum/action/xeno_action/activable/fortify
	desc = "Занять позицию укрепления, увеличивая защиту на %ARMOR% (вдвое больше от взрывов). Не даёт вас опрокинуть. \
		Также даёт %EXTRA_FRONT_ARMOR% спереди. Нельзя использовать способности и двигаться в укреплении, но удар хвостом всё ещё доступен."

/datum/action/xeno_action/activable/fortify/apply_replaces_in_desc()
	replace_in_desc("%EXTRA_FRONT_ARMOR%", frontal_armor)
	replace_in_desc("%ARMOR%", 30)

/datum/action/xeno_action/activable/fortify/steel_crest
	desc = "Занять мобильную позицию укрепления, увеличивая защиту на %ARMOR% (в шесть раз больше от взрывов). Не даёт вас опрокинуть. \
		Также даёт %EXTRA_FRONT_ARMOR% спереди. Вы можете ударять гребнем и двигаться в укреплении."

/datum/action/xeno_action/activable/fortify/steel_crest/apply_replaces_in_desc()
	replace_in_desc("%EXTRA_FRONT_ARMOR%", frontal_armor)
	replace_in_desc("%ARMOR%", 10)

// Update tails first
/datum/action/xeno_action/activable/tail_stab/slam

/datum/action/xeno_action/onclick/soak
	desc = "Начинает поглощать урон. Если в этом состоянии вы получите %THRESHOLD% урона, вы восстановите 75 здоровья, а также закончите перезарядку удара хвостом."

/datum/action/xeno_action/onclick/soak/apply_replaces_in_desc()
	replace_in_desc("%THRESHOLD%", 140)
