/obj/vehicle/motorbike
	var/nickname //used for single-use verb to name the vehicle. Put anything here to prevent naming

/obj/vehicle/motorbike/proc/add_vehicle_verbs(mob/living/M)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/motorbike/proc/activate_horn,
		/obj/vehicle/motorbike/proc/activate_show
	))
	if(!nickname)
		add_verb(M.client, /obj/vehicle/motorbike/proc/name_vehicle)

/obj/vehicle/motorbike/proc/remove_vehicle_verbs(mob/living/M)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/motorbike/proc/activate_horn,
		/obj/vehicle/motorbike/proc/activate_show
	))
	if(!nickname)
		remove_verb(M.client, /obj/vehicle/motorbike/proc/name_vehicle)
	SStgui.close_user_uis(M, src)

// ==========================================
// ================== ВЕРБЫ =================

// Гудок
/obj/vehicle/motorbike/proc/activate_horn()
	set name = "Активировать Гудок"
	set desc = "Активировать гудок. Биииип!"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/motorbike/M = user.buckled
	if(!M)
		return

	M.play_honk_sound()
	to_chat(user, SPAN_NOTICE("Вы активировали гудок"))

// Врум-врум!
/obj/vehicle/motorbike/proc/activate_show()
	set name = "Дать газу"
	set desc = "Покажи себя! Круто!"
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/motorbike/M = user.buckled
	if(!M)
		return

	M.play_show_sound()

// Переименование ТС
/obj/vehicle/motorbike/proc/name_vehicle()
	set name = "Переименовать"
	set desc = "Один раз позволяет переименовать транспорт. Максимум 26 символов."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/motorbike/M = user.buckled
	if(!M)
		return

	if(M.nickname)
		to_chat(user, SPAN_WARNING("У вашего транспорта уже есть название - \"[M.nickname]\"."))
		return

	var/new_nickname = stripped_input(user,
		"Введите уникальное наименование, которое будет добавлено к названию вашего транспортного средства. \
		Максимум [MAX_NAME_LEN] символов длиной. \
		\n\nВАЖНО! \
		Не используйте ООС/MEM/Брейнерот-наименование, иначе вы будете за это наказаны. \
		\nЕДИНИЧНОЕ ИСПОЛЬЗОВАНИЕ.",
		"Наименование", null, MAX_NAME_LEN)
	if(!new_nickname)
		return
	if(length(new_nickname) > MAX_NAME_LEN)
		alert(user, "Наименование [new_nickname] больше чем [MAX_NAME_LEN] символов. Попробуйте еще раз.", "Ошибка наименования", "Ну ладно...")
		return
	if(alert(user, "Наименование транспорта будет [M.name + " \"[new_nickname]\""]. Оставляем?", "Подтверждаем?", "Да", "Нет") != "Да")
		return

	//post-checks
	if(!M.buckled_mob) //check that we are still in seat
		to_chat(user, SPAN_WARNING("Вам необходимо сесть на ваш транспорт!"))
		return

	if(M.nickname) //check again if second VC was faster.
		to_chat(user, SPAN_WARNING("Ваш транспорт уже был переименован!"))
		return

	M.nickname = new_nickname
	M.name = initial(M.name) + " \"[M.nickname]\""
	to_chat(user, SPAN_NOTICE("Вы назвали \"[M.nickname]\" ваш транспорт."))
	remove_verb(user.client, /obj/vehicle/motorbike/proc/name_vehicle)

	message_admins(WRAP_STAFF_LOG(user, "дал наименование \"[M.nickname]\" его [initial(M.name)]. ([M.x],[M.y],[M.z])"), M.x, M.y, M.z)
