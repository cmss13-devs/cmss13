/datum/job/civilian/nurse
	disp_title = JOB_NURSE_RU
	supervisors = "главным врачом"
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Ваша задача — поддерживать здоровье и силу морпехов.</a> Вы также являетесь экспертом в вопросах лекарств и лечения и можете проводить небольшие хирургические операции. Сосредоточьтесь на оказании помощи врачам и сортировке раненых морпехов."

// Разделение на Гендеры Медсестра/Медбрат
/datum/equipment_preset/uscm_ship/uscm_medical/nurse/male
	assignment = JOB_NURSE_RU_MALE

/datum/equipment_preset/uscm_ship/uscm_medical/nurse/female
	assignment = JOB_NURSE_RU_FEMALE

// Здесь нету pre_equip
/datum/job/civilian/doctor/spawn_and_equip(mob/new_player/player)
	if (player.gender == MALE)
		gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/nurse/male
	else if(player.gender == FEMALE)
		gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/nurse/female
	. = ..()

