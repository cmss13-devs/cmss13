#define STANDARD_VARIANT "Рабочий Джо" // SS220 EDIT TRANSLATE
#define HAZMAT_VARIANT "Хазмат Джо" // SS220 EDIT TRANSLATE

/datum/job/civilian/working_joe
	title = JOB_WORKING_JOE
	total_positions = 6
	spawn_positions = 6
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "ARES and APOLLO"
	selection_class = "job_working_joe"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_JOE
	gear_preset = /datum/equipment_preset/synth/working_joe
	gets_emergency_kit = FALSE

	job_options = list(STANDARD_VARIANT = "ДЖО", HAZMAT_VARIANT = "ХАЗ") 	// SS220 EDIT TRANSLATE
	var/standard = TRUE

/datum/job/civilian/working_joe/check_whitelist_status(mob/user)
	if(user.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		return TRUE

	return ..()

/datum/job/civilian/working_joe/handle_job_options(option)
	if(option != HAZMAT_VARIANT)
		standard = TRUE
		gear_preset = /datum/equipment_preset/synth/working_joe
	else
		standard = FALSE
		gear_preset = /datum/equipment_preset/synth/working_joe/engi

/datum/job/civilian/working_joe/set_spawn_positions(count)
	spawn_positions = working_joe_slot_formula(count)

/datum/job/civilian/working_joe/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = working_joe_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/civilian/working_joe/generate_entry_message(mob/living/carbon/human/H)
	if(standard)
		. = {"Вы - <a href='[generate_wiki_link()]'>Рабочий Джо.</a> Вы придерживаетесь более высоких стандартов и обязаны соблюдать не только Правила сервера, но и Законы Морпехов, Ожидания от ролевой игры и Синтетические правила. Ваша главная задача — поддерживать чистоту на корабле, расставляя вещи по местам. В качестве альтернативы вашей главной задачей может быть помощь с ручным трудом в ограниченных возможностях или канцелярские обязанности. Ваши возможности ограничены, но у вас есть все необходимое оборудование, а у центрального ИИ есть план! Оставайтесь в образе до конца. Используйте аплинк для связи с APOLLO!"} // SS220 EDIT TRANSLATE
	else
		. = {"Вы - <a href='[generate_wiki_link()]'>Рабочий Джо</a> для опасной среды! Вы придерживаетесь более высоких стандартов и обязаны соблюдать не только Правила сервера, но и Законы Морпехов, Ожидания от ролевой игры и Синтетические правила. Вы являетесь вариантом Рабочего Джо, созданным для более жестких условий и выполняете особые обязанности по опасному ремонту или обслуживанию. Ваша основная задача — поддерживать реактор, заряд корабля и Ядро ИИ. Ваша второстепенная задача — реагировать на опасные условия, такие как атмосферное нарушение или разлив биологически опасной среды, и помогать с ремонтом по приказу либо Главного ЭВМ ИИ, либо Офицера. Вас не следует видеть за пределами чрезвычайных ситуаций, за исключением инженерного отдела и Ядра ИИ! Всегда оставайтесь в образе. Используйте аплинк для связи с APOLLO!"}  // SS220 EDIT TRANSLATE

/datum/job/civilian/working_joe/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ares_apollo_talk), "[H.real_name] has been activated."), 1.5 SECONDS)
	return ..()

/obj/effect/landmark/start/working_joe
	name = JOB_WORKING_JOE
	icon_state = "wj_spawn"
	job = /datum/job/civilian/working_joe

/datum/job/civilian/working_joe/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()

	if(SSticker.mode)
		SSticker.mode.initialize_joe(M)

/datum/job/antag/upp/dzho_automaton
	title = JOB_UPP_JOE
	total_positions = 3 //Number is actually based on information from Colonial Marines_Operations Manual, 1IVAN/3 starts to lag if it is connected to more than 3.
	spawn_positions = 3
	allow_additional = TRUE
	scaled = FALSE
	supervisors = "1VAN/3 and UPP command staff"
	gear_preset = /datum/equipment_preset/synth/working_joe/upp
	flags_startup_parameters = ROLE_WHITELISTED

	flags_whitelist =  WHITELIST_JOE

/datum/job/antag/upp/dzho_automaton/check_whitelist_status(mob/user)
	if(user.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		return TRUE

	return ..()

/datum/job/antag/upp/dzho_automaton/generate_entry_message(mob/living/carbon/human/H)
	. = {"Вы <a>Автоматон Сергей</a>. Вы придерживаетесь более высоких стандартов и обязаны соблюдать не только Правила сервера, но и Законы UPP, Ожидания от ролевой игры и Синтетические правила. Ваша основная задача — поддерживать корабль, патрулировать и выполнять другие задачи, порученные вам офицерским составом СПН. В качестве альтернативы вашей основной задачей может быть помощь с ручным трудом в ограниченных возможностях или канцелярские обязанности. При необходимости вы можете выполнять обязанности брига и службы безопасности. У вас есть разрешение на огнестрельное оружие, и вы можете применять смертоносную силу, где это применимо. Ваши возможности ограничены, но у вас есть все необходимое оборудование, а у центрального ИИ есть план! Оставайтесь в образе до конца!"}	// SS220 EDIT TRANSLATE


