/datum/action/xeno_action/activable/slowing_spit
	desc = "Слабый нейротоксин.\
		<br>Значительно замедляет цель (%SLOWDOWN%).\
		<br>Носитель может устоять от нейротоксина."

/datum/action/xeno_action/activable/slowing_spit/apply_replaces_in_desc()
	replace_in_desc("%SLOWDOWN%", convert_effect_time(4, SUPERSLOW), DESCRIPTION_REPLACEMENT_TIME)
	var/datum/ammo/xeno/spit = GLOB.ammo_list[/datum/ammo/xeno/toxin] // hardcoded
	desc += "[spit.get_description()]"

/datum/action/xeno_action/activable/scattered_spit
	desc = "Слабый нейротоксин ограниченной дистанции (%DISTANCE%), стреляющий веером.\
		<br>Кратковременно оглушает цель (%STUN%).\
		<br>Носитель может устоять от нейротоксина."

/datum/action/xeno_action/activable/scattered_spit/apply_replaces_in_desc()
	replace_in_desc("%DISTANCE%", /datum/ammo/xeno/toxin/shotgun::max_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%STUN%", convert_effect_time(0.7, STUN), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/paralyzing_slash
	desc = "Усиливает следующий удар.\
		<br>При попадании цель будет дезориентирована (%DAZE%), и через <b>3 сек.</b> цель будет оглушена (%STUN%)\
		<br>Носитель может устоять от нейротоксина."

/datum/action/xeno_action/onclick/paralyzing_slash/apply_replaces_in_desc()
	replace_in_desc("%DAZE%", convert_effect_time(4, DAZE), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%STUN%", convert_effect_time(2.5, STUN), DESCRIPTION_REPLACEMENT_TIME)
