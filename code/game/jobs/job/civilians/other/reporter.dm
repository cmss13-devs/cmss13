#define MILITARY_VARIANT "Военный Корреспондент"	// SS220 EDIT TRANSLATE
#define CIVILIAN_VARIANT "Гражданский Корреспондент"	// SS220 EDIT TRANSLATE

/datum/job/civilian/reporter
	title = JOB_COMBAT_REPORTER
	total_positions = 1
	spawn_positions = 1
	selection_class = "job_cl"
	supervisors = "the acting commanding officer"
	gear_preset = /datum/equipment_preset/uscm_ship/reporter
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	selection_class = "job_cl"

	job_options = list(CIVILIAN_VARIANT = "Грж", MILITARY_VARIANT = "Арм")	// SS220 EDIT TRANSLATE
	/// If this job is a military variant of the reporter role
	var/military = FALSE

/datum/job/civilian/reporter/handle_job_options(option)
	if(option != CIVILIAN_VARIANT)
		gear_preset = /datum/equipment_preset/uscm_ship/reporter_uscm
		military = TRUE
	else
		gear_preset = initial(gear_preset)
		military = initial(military)

/datum/job/civilian/reporter/generate_entry_message(mob/living/carbon/human/H)
	if(military)	// SS220 EDIT TRANSLATE
		. = {"USCM назначил вас на [MAIN_SHIP_NAME], чтобы лучше справляться с сообщениями о том, как обстоят дела в секторе Нероидов. Отправляйтесь туда и покажите вселенной, что USCM делает великие дела!"}
	else
		. = {"Какая сенсация! Вас назначили на [MAIN_SHIP_NAME], чтобы посмотреть, во что они вляпаются, и, похоже, беда уже здесь!
Это могла бы стать историей сектора! "Храбрые морпехи реагируют на опасный сигнал бедствия!" Мистер Паркерсон наверняка заметил бы вас в офисе, если бы вы принесли ему такую ​​историю!"}

/obj/effect/landmark/start/reporter
	name = JOB_COMBAT_REPORTER
	job = /datum/job/civilian/reporter

AddTimelock(/datum/job/civilian/reporter, list(
	JOB_HUMAN_ROLES = 10 HOURS,
))
