/datum/roundstart_spawn
	var/list/object_to_spawn = list() // Объекты, которые спавним
	var/obj/attached_to_type          // Объект, к которому привязываем спавн
	var/range = 1                     // Радиус спавна вокруг attached_obj
	var/ignore_walls = FALSE          // Игнорировать стены при выборе места
	var/ignore_objects = FALSE        // Игнорировать объекты при выборе места

	// Настройки количества спавнов
	var/min_spawns = 0                // Минимальное число спавнов
	var/max_spawns = 3                // Максимальное число спавнов
	var/current_spawns = 0            // Уже заспавнено

	// Зависимость от числа игроков
	var/required_players = 40         // Игроков на +1 спавн

	// Хранилище данных для цикличного спавна
	var/list/used_turfs = list()      // Использованные тюрфы для каждого attached_obj
	var/list/available_attached = list()  // Доступные attached_obj (обновляется динамически)

/datum/roundstart_spawn/proc/process_spawns()
	if(!length(object_to_spawn) || !attached_to_type)
		return FALSE

	// Рассчитываем, сколько нужно заспавнить
	var/num_players = LAZYLEN(GLOB.new_player_list)
	var/num_to_spawn = clamp(round(num_players / required_players), min_spawns, max_spawns)
	if(num_to_spawn <= current_spawns)
		return FALSE

	// Если список available_attached пуст, заполняем его заново
	if(!length(available_attached))
		available_attached = list()
		for(var/obj/A in world)
			if(istype(A, attached_to_type))
				available_attached += A

		if(!length(available_attached))
			return FALSE  // Вообще нет объектов для привязки

	var/list/available_attached_temp = available_attached.Copy()

	for(var/i in 1 to num_to_spawn)
		if(!length(available_attached_temp))
			available_attached_temp = available_attached.Copy()

		// Выбираем случайный attached_obj и удаляем его из доступных
		var/obj/attached_obj = pick_n_take(available_attached_temp)
		var/turf/spawn_turf = find_valid_spawn_turf(attached_obj)

		// Если не нашли тюрф — спавним прямо на attached_obj (допустимо по условию)
		if(!spawn_turf)
			spawn_turf = get_turf(attached_obj)  // Если не нашли подходящий — спавним прямо на attached_obj

		if(spawn_turf)
			for(var/O in object_to_spawn)
				new O(spawn_turf)
			current_spawns++

	return TRUE

/datum/roundstart_spawn/proc/find_valid_spawn_turf(obj/attached_obj)
	var/turf/center = get_turf(attached_obj)
	if(!center)
		return null

	// Получаем или создаем список использованных тюрфов для этого attached_obj
	var/list/obj_used_turfs = used_turfs[attached_obj]
	if(isnull(obj_used_turfs))
		obj_used_turfs = list()
		used_turfs[attached_obj] = obj_used_turfs

	var/list/valid_turfs = list()

	// Собираем все подходящие тайлы вокруг центра
	for(var/turf/T in orange(range, center))
		if(T in obj_used_turfs)
			continue  // Пропускаем использованные
		if(!ignore_walls && isclosedturf(T))
			continue
		if(!ignore_objects && (locate(/obj) in T) || (locate(/mob) in T))
			continue
		valid_turfs += T

	// Если есть неиспользованные тюрфы — берем случайный
	if(length(valid_turfs))
		var/turf/chosen_turf = pick(valid_turfs)
		obj_used_turfs += chosen_turf
		return chosen_turf

	// Если все тюрфы использованы — очищаем список и пробуем снова
	if(length(obj_used_turfs))
		obj_used_turfs.Cut()
		return find_valid_spawn_turf(attached_obj)

	// Если вообще нет валидных тюрфов — возвращаем центр
	return center
