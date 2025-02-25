/datum/emergency_call/goon
	name = "Weyland-Yutani Corporate Security (Squad)"
	mob_max = 6
	probability = 0
	home_base = /datum/lazy_template/ert/weyland_station

/datum/emergency_call/goon/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], это шаттл службы корпоративной безопасности \"Вейланд-Ютани\", мы получили ваш сигнал бедствия. Выдвигаемся на помощь."
	objectives = "Обеспечьте безопасность корпоративного связного и командующего офицера [MAIN_SHIP_NAME]. Устраните любые враждебные угрозы. Не повреждайте имущество Вей-Ю."

/datum/emergency_call/goon/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Lead!"))
		arm_equipment(mob, /datum/equipment_preset/goon/lead, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Officer!"))
		arm_equipment(mob, /datum/equipment_preset/goon/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/goon/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a poor family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani was all you could do to keep yourself and your loved ones fed."))
	to_chat(M, SPAN_BOLD("You have no idea what a xenomorph is."))
	to_chat(M, SPAN_BOLD("You are a simple security officer employed by Weyland-Yutani to guard their outposts and colonies."))
	to_chat(M, SPAN_BOLD("You heard about the original distress signal ages ago, but you have only just gotten permission from corporate to enter the area."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))

/datum/emergency_call/goon/chem_retrieval
	name = "Weyland-Yutani Goon (Chemical Investigation Squad)"
	mob_max = 6
	mob_min = 2
	max_medics = 1
	var/checked_objective = FALSE

/datum/emergency_call/goon/chem_retrieval/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME], это ККС \"Ройс\". Наш отряд направляется к вам, чтобы забрать все образцы химического вещества, недавно отсканированного в вашем исследовательском отделе. Вы уже получили значительную сумму денег за открытие, сделанное вашим отделом. Взамен мы просим вас сотрудничать и предоставить нашей команде всё, что связано с химикатом."
	objectives = "Заберите из исследовательского отдела [MAIN_SHIP_NAME] все документы, образцы и химикаты, содержащие свойство \"DNA_Disintegrating\", и верните их на станцию группы реагирования."

/datum/emergency_call/goon/chem_retrieval/proc/check_objective_info()
	if(objective_info)
		objectives = "Заберите из исследовательского отдела [MAIN_SHIP_NAME] все документы, образцы и химикаты, относящиеся к [objective_info], и верните их на станцию группы реагирования."
	objectives += "Предполагается, что в отделе находится не менее 30 юнитов. Если они не могут сделать больше, то это должно быть всё. Сотрудничайте с бортовым командным связным, чтобы гарантировать, что все, кто знает полный рецепт, хранят молчание, заключив договор о неразглашении. Все люди, употребившие химикат, должны быть доставлены живыми или мертвыми. Вирусное сканирование требуется для всех людей, подозреваемых в употреблении химиката. Вы не можете отправляться в колонию без прямого разрешения супервайзера ЧВК. Профессор может вызвать подмогу из ЧВК, если ситуация выйдет из-под контроля."
	checked_objective = TRUE

/datum/emergency_call/goon/chem_retrieval/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Lead!"))
		arm_equipment(mob, /datum/equipment_preset/goon/lead, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Research Consultant!"))
		arm_equipment(mob, /datum/equipment_preset/goon/researcher, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Officer!"))
		arm_equipment(mob, /datum/equipment_preset/goon/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/goon/chem_retrieval/print_backstory(mob/living/carbon/human/backstory_human)
	if(backstory_human.job == JOB_WY_GOON_RESEARCHER)
		to_chat(backstory_human, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a wealthy family."))
		to_chat(backstory_human, SPAN_BOLD("Joining the ranks of Weyland-Yutani was the perfect way to further your research goals."))
		to_chat(backstory_human, SPAN_BOLD("You have a very in depth understanding of xenomorphs."))
		to_chat(backstory_human, SPAN_BOLD("You are a well educated scientist employed by Weyland-Yutani to study various non-humans."))
		to_chat(backstory_human, SPAN_BOLD("You heard about the original distress signal ages ago, but you have only just gotten permission from corporate to enter the area."))
		to_chat(backstory_human, SPAN_BOLD("Your only goal is to recover the chemical aboard the Almayer. Do whatever you have to do."))
	else
		to_chat(backstory_human, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a poor family."))
		to_chat(backstory_human, SPAN_BOLD("Joining the ranks of Weyland-Yutani was all you could do to keep yourself and your loved ones fed."))
		to_chat(backstory_human, SPAN_BOLD("You have had a basic brief on xenomorphs."))
		to_chat(backstory_human, SPAN_BOLD("You are a simple security officer employed by Weyland-Yutani to guard their outposts and colonies."))
		to_chat(backstory_human, SPAN_BOLD("You heard about the original distress signal ages ago, but you have only just gotten permission from corporate to enter the area."))
		to_chat(backstory_human, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the researcher is kept safe and follow their instructions."))

/datum/emergency_call/goon/bodyguard
	name = "Weyland-Yutani Goon (Executive Bodyguard Detail)"
	mob_max = 1
	mob_min = 1

/datum/emergency_call/goon/bodyguard/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME], это шаттл службы корпоративной безопасности \"Вейланд-Ютани\". Направляемся к маяку связного."
	objectives = "Защищайте корпоративного связного и выполняйте его приказы, если это не противоречит политике компании. Не наносите ущерба имуществу Вей-Ю."

/datum/emergency_call/goon/bodyguard/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Lead!"))
		arm_equipment(mob, /datum/equipment_preset/goon/lead, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Officer!"))
		arm_equipment(mob, /datum/equipment_preset/goon/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/goon/bodyguard/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a poor family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani was all you could do to keep yourself and your loved ones fed."))
	to_chat(M, SPAN_BOLD("You have no idea what a xenomorph is."))
	to_chat(M, SPAN_BOLD("You are a simple security officer employed by Weyland-Yutani to guard their Executives from all Divisions alike."))
	to_chat(M, SPAN_BOLD("You were sent to act as the Executives bodyguard on the [MAIN_SHIP_NAME], you have gotten permission from corporate to enter the area."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))

/datum/emergency_call/goon/platoon
	name = "Weyland-Yutani Corporate Security (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
