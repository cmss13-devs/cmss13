/datum/ammo/xeno/proc/get_description()
	var/desc = "<br><br>Характеристики [name]."
	desc += "<br>Дальность: <b>[max_range] кл.</b>"
	desc += "<br>Урон: <b>[damage ? "[damage] [damage_type]" : "отсутствует"]</b>."
	if(bonus_projectiles_amount)
		desc += "<br>Создаёт <b>[bonus_projectiles_amount + 1]</b> снарядов."
	if(damage && damage_falloff)
		desc += " Уменьшается на [damage_falloff] за каждую пройденную клетку."

	if(flags_ammo_behavior & AMMO_SKIPS_ALIENS)
		desc += "<br>Проходит сквозь сестёр."
	if(length(debilitate))
		desc += "<br>Накладывает статус-эффекты:"
		// Stun
		if(debilitate[1])
			desc += "<br>- Оглушение: <b>[convert_effect_time(debilitate[1], STUN)] сек.</b>"
		// Weaken
		if(debilitate[2])
			desc += "<br>- Опрокидывание: <b>[convert_effect_time(debilitate[2], WEAKEN)] сек.</b>"
		// Sleep
		if(debilitate[3])
			desc += "<br>- Нокаут: <b>[convert_effect_time(debilitate[3], WEAKEN)] сек.</b>"
		// Irradiate
		/* Not used
		if(debilitate[4])
			desc += "<br>- Оглушает на <b>[convert_effect_time(debilitate[4], STUN)] <b>сек.</b>"
		*/
		// Stutter
		if(debilitate[5])
			desc += "<br>- Заикание: <b>[convert_effect_time(debilitate[5], STUN)] сек.</b>"
		// Eyeblur
		if(debilitate[6])
			desc += "<br>- Затуманивает зрения: <b>[convert_effect_time(debilitate[6], STUN)] сек.</b>"
		// Drowsy
		if(debilitate[7])
			desc += "<br>- Сонность: <b>[convert_effect_time(debilitate[7], STUN)] сек.</b>"
		// Agony
		if(debilitate[8])
			desc += "<br>- Боль: <b>[debilitate[8]]</b>."
	desc += "<br>"
	return desc

/datum/ammo/xeno/boiler_gas/get_description()
	var/desc = ""
	var/neurodose = /obj/effect/particle_effect/smoke/xeno_weak::neuro_dose
	desc += "<br>Радиус взрыва: <b>[smokerange] кл.</b>\
		<br>Замедляет носителей в области, медленно ослабляет и душит их. Затуманивает зрение. Накладывает <b>[neurodose]</b> стаков нейротоксина каждую секунду.\
		<br>Нейротоксин постепенно ослабевает цель, наносит урон токсинами, вызывает галлюцинации, а при <b>19</b> стаках ослепляет, и при <b>50</b> стаках убивает."
	desc += ..()
	return desc

/datum/ammo/xeno/boiler_gas/acid/get_description()
	var/desc = ""
	var/damage = /obj/effect/particle_effect/smoke/xeno_burn::gas_damage
	desc += "<br>Радиус взрыва: <b>[smokerange] кл.</b>\
		<br>Накладывает кислоту на барикады в области.\
		<br>Наносит [damage] урона в секунду при вдыхании носителями, а также дополнительно <b>15-20</b> урона в секунду по телу."
	desc += call(src, /datum/ammo/xeno::get_description())()
	return desc
