/datum/squad_type
	var/name_ru

/datum/squad_type/proc/get_name_ru()
	return name_ru ? name_ru : name

/datum/squad_type/marine_squad
	name_ru = "Отряда"
	lead_name = "Командир Отряда"
	sub_squad = "Боевой Группы"
	sub_leader = "Лидер Боевой Группы"

/datum/squad_type/marsoc_team
	name_ru = "Команды"
	lead_name = "Лидер Команды"
	sub_squad = "Ударной Группы"
	sub_leader = "Ударный Лидер"

// ======================
// 			SQUADS
// ======================
/datum/squad
	var/squad_type_ru = "Отряда"
	var/name_ru

/datum/squad/proc/get_name_ru()
	return name_ru ? name_ru : name

// Marines

/datum/squad/marine/alpha
	name_ru = SQUAD_MARINE_1_RU

/datum/squad/marine/bravo
	name_ru = SQUAD_MARINE_2_RU

/datum/squad/marine/charlie
	name_ru = SQUAD_MARINE_3_RU

/datum/squad/marine/delta
	name_ru = SQUAD_MARINE_4_RU

/datum/squad/marine/echo
	name_ru = SQUAD_MARINE_5_RU

/datum/squad/marine/cryo
	name_ru = SQUAD_MARINE_CRYO_RU

/datum/squad/marine/intel
	name_ru = SQUAD_MARINE_INTEL_RU

/datum/squad/marine/sof
	name_ru = SQUAD_SOF_RU

/datum/squad/marine/cbrn
	name_ru = SQUAD_CBRN_RU

/datum/squad/marine/forecon
	name_ru = SQUAD_FORECON_RU

/datum/squad/marine/solardevils
	name_ru = SQUAD_SOLAR_RU


// UPP

/datum/squad/upp/one
	name_ru = SQUAD_UPP_1_RU

/datum/squad/upp/two
	name_ru = SQUAD_UPP_2_RU

/datum/squad/upp/three
	name_ru = SQUAD_UPP_3_RU

/datum/squad/upp/four
	name_ru = SQUAD_UPP_4_RU

/datum/squad/upp/kdo
	squad_type_ru = "Команды"
	name_ru = SQUAD_UPP_5_RU


// PMC

/datum/squad/pmc
	squad_type_ru = "Команды"

/datum/squad/pmc/one
	name_ru = "Команда Эпсилон"

/datum/squad/pmc/two
	name_ru = "Команда Гамма"

/datum/squad/pmc/wo
	name_ru = "Целевая Группа Войт"


// CLF

/datum/squad/clf
	squad_type_ru = "Ячейки"

/datum/squad/clf/one
	name_ru = "Питон"

/datum/squad/clf/two
	name_ru = "Гадюка"

/datum/squad/clf/three
	name_ru = "Кобра"

/datum/squad/clf/four
	name_ru = "Удав"
