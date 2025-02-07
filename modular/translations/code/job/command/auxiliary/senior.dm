/datum/job/command/senior
	disp_title = JOB_SEA_RU
	job_options = list(
		"Старший Инструктор" = "СтИ",
		"Инструктор по Строевой Подготовке" = "ИСП",
		"Инструктор Рядового Состава" = "ИРС",
		"Сержант-Инструктор" = "С-И")

	total_positions = 2	// сейчас нам нужно таких побольше, много людей требуют обучения.
	spawn_positions = 2	// Если щас уже апрель 2025 и больше, то можно убирать эти 2 строки.

/datum/job/command/senior/filter_job_option(mob/job_applicant)
	return job_options	// Там всеравно опшинс по всратому сделали. Передавали звания как должность...

// Доп перевод: /datum/job/command/senior/on_config_load()
// Доп перевод: /datum/job/command/senior/announce_entry_message(mob/living/carbon/human/H)

/datum/equipment_preset/uscm_ship/sea
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0,
					PAY_SHORT_ME8 = JOB_PLAYTIME_TIER_1,
					PAY_SHORT_ME8E = JOB_PLAYTIME_TIER_2,
					PAY_SHORT_ME9 = JOB_PLAYTIME_TIER_3,
					PAY_SHORT_ME9E = JOB_PLAYTIME_TIER_4
					)
