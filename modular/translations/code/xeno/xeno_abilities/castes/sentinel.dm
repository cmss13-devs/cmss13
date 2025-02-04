/datum/action/xeno_action/activable/slowing_spit
	desc = "Слабый нейротоксин ограниченной дистанции (%DISTANCE%). Значительно замедляет цель (%SLOWDOWN%). Носитель может устоять от нейротоксина."

/datum/action/xeno_action/activable/slowing_spit/apply_replaces_in_desc()
	replace_in_desc("%DISTANCE%", /datum/ammo/xeno/toxin::max_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%SLOWDOWN%", convert_effect_time(4, SUPERSLOW), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/activable/scattered_spit
	desc = "Слабый нейротоксин ограниченной дистанции (%DISTANCE%), стреляющий веером. Кратковременно оглушает цель (%STUN%). Носитель может устоять от нейротоксина."

/datum/action/xeno_action/activable/scattered_spit/apply_replaces_in_desc()
	replace_in_desc("%DISTANCE%", /datum/ammo/xeno/toxin/shotgun::max_range, DESCRIPTION_REPLACEMENT_DISTANCE)
	replace_in_desc("%STUN%", convert_effect_time(0.7, STUN), DESCRIPTION_REPLACEMENT_TIME)

/datum/action/xeno_action/onclick/paralyzing_slash
	desc = "Усиливает следующий удар. При попадании цель будет дезориентирована (%DAZE%), а также через 3 сек. цель будет оглушена (%STUN%) Носитель может устоять от нейротоксина."

/datum/action/xeno_action/onclick/paralyzing_slash/apply_replaces_in_desc()
	replace_in_desc("%DAZE%", convert_effect_time(4, DAZE), DESCRIPTION_REPLACEMENT_TIME)
	replace_in_desc("%STUN%", convert_effect_time(2.5, STUN), DESCRIPTION_REPLACEMENT_TIME)
