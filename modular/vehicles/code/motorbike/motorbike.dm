/obj/vehicle/motorbike
	name = "Мотоцикл"
	desc = "Для крутышей."
	icon = 'modular/vehicles/icons/moto48x48.dmi'
	icon_state = "moto_ural_classic"	// Для отображения на картах
	var/icon_base = "moto_ural"
	var/icon_skin = "classic"
	var/need_camo = FALSE // Камуфлируем под текущую карту?
	var/blooded = FALSE	// Окровавлен при столкновении в motorbike_collide.dm
	var/blooded_skin = "moto_mudak-overlay"
	var/create_stroller = FALSE

	var/required_skill = SKILL_VEHICLE_SMALL

	health = 400
	maxhealth = 400
	projectile_coverage = PROJECTILE_COVERAGE_LOW // Шанс попадания проджектайлов

	anchored = FALSE // Мы можем передвинуть байк, если он нам мешает.
	drag_delay = 3 // Но медленно
	density = FALSE // Проходим сквозь байк если на нем никто не сидит

	var/buckle_time = 0.7 SECONDS

	pixel_x = -8	// спрайт 48х48, центрируем.
	buckling_y = 7
	layer = ABOVE_LYING_MOB_LAYER //Allows it to drive over people, but is below the driver.

	move_delay = 1.5	// Скорость
	var/move_delay_connected = VEHICLE_SPEED_SUPERFAST // == 2 - Скорость когда приконекчена тележка

	// Система света
	light_system = MOVABLE_LIGHT
	light_range = 5
	var/atom/movable/vehicle_light_holder/lighting_holder
	var/vehicle_light_range = 5
	var/vehicle_light_power = 2

	// Ремонт, коннекты, действия
	var/welder_health = 35	// Восстановление прочности за 1 топливо из сварки
	var/welder_time = 1 SECONDS	// Время требуемое для сварки
	var/is_welded = FALSE	// Сейчас происходит процесс варки?
	var/wrench_time = 10 SECONDS // Время коннекта при закручивании

	var/obj/structure/bed/chair/stroller/stroller = null // привязанная тележка
	var/hit_chance_connected = PROJECTILE_COVERAGE_MEDIUM // prob шанс задеть тележку или сидящего при попадании
	var/hit_chance_buckled = 50 // Шанс попасть по сидящему
	var/hit_chance_to_unbuckle = 5 // Каждый удар имеет шанс отсоединить куклу при попадании по ней


/obj/vehicle/motorbike/New(loc, skin)
	if(skin)
		icon_skin = skin
	else if(need_camo)
		select_gamemode_skin()
	. = ..(loc, icon_skin)
	if(create_stroller)
		stroller = new(src, icon_skin)
		update_connect_params()
		update_stroller(TRUE)
	update_overlay()

/obj/vehicle/motorbike/Initialize()
	. = ..()
	update_overlay()
	if(bound_width > world.icon_size || bound_height > world.icon_size)
		lighting_holder = new(src)
		lighting_holder.set_light_range(vehicle_light_range)
		lighting_holder.set_light_power(vehicle_light_power)
		lighting_holder.set_light_on(vehicle_light_range || vehicle_light_power)
	else if(light_range)
		set_light_on(TRUE)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	GLOB.all_spec_vehicles += src // Orbit

/obj/vehicle/motorbike/Destroy(force)
	. = ..()
	GLOB.all_spec_vehicles -= src

/obj/vehicle/motorbike/proc/update_overlay()
	overlays.Cut()
	icon_state = "[icon_base]_[icon_skin]"
	var/image/I = new(icon = 'modular/vehicles/icons/moto48x48.dmi', icon_state = "[icon_state]-overlay", layer = ABOVE_MOB_LAYER) //over mobs
	overlays += I
	if(blooded)
		I = new(icon = 'modular/vehicles/icons/moto48x48.dmi', icon_state = "[blooded_skin]", layer = ABOVE_MOB_LAYER) //over mobs
		overlays += I

/obj/vehicle/motorbike/get_examine_text(mob/user)
	. = ..()
	if(!isxeno(user))
		. += SPAN_NOTICE("Прочность: [health/maxhealth*100]%")

// ==========================================
// ========== Присоединяем коляску ==========

// Пытаемся приконектить объект
/obj/vehicle/motorbike/proc/try_connect()
	stroller = get_before_connect()
	if(!stroller)
		return FALSE
	connect()
	return TRUE

// Ищем и выдаем нужный объект для коннекта
/obj/vehicle/motorbike/proc/get_before_connect(mob/user)
	for(var/obj/structure/bed/chair/stroller/S in range(1, get_turf(user)))
		if(S.connected)
			to_chat(user, SPAN_DANGER("[S] уже закреплена."))
			continue
		if(S.health < S.maxhealth - 100)
			to_chat(user, SPAN_DANGER("[S] повреждена и требует ремонта."))
			continue
		return S
	to_chat(user, SPAN_DANGER("Вы прокрутили крепежи и осознали, что рядом с вами нет коляски..."))
	return FALSE

// Завершаем конект в коляске
/obj/vehicle/motorbike/proc/connect()
	stroller.connect(src)
	update_connect_params()

/obj/vehicle/motorbike/proc/update_connect_params()
	move_delay = move_delay_connected

/obj/vehicle/motorbike/proc/disconnect()
	stroller.disconnect()
	stroller = null
	move_delay = initial(move_delay)

// Глайдинг для плавного перемещения
/obj/vehicle/motorbike/set_glide_size(target)
	. = ..()
	if(stroller)
		stroller.set_glide_size(target)
