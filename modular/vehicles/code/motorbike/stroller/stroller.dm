// стул на колесиках, по другому "сайдкар"
/obj/structure/bed/chair/stroller
	name = "Мотоциклетная коляска"
	icon = 'modular/vehicles/icons/moto48x48.dmi'
	icon_state = "moto_ural_stroller_classic"	// Для отображения на картах
	var/icon_base = "moto_ural_stroller"
	var/icon_skin = "classic"
	var/icon_destroyed = "destroyed"
	var/need_camo = FALSE // Камуфлируем под текущую карту?
	desc = "Для детишек."
	density = FALSE	// При коннекте - У нас уже есть колизия с мотоциклом
	anchored = TRUE	// При коннекте - Нехай трогать и перемещать
	stacked_size = FALSE // Иначе он будет его в нулину ломать
	picked_up_item = null // Нам не нужно превращение в стул...

	projectile_coverage = PROJECTILE_COVERAGE_MEDIUM
	health = 600 // Тележка прочнее мотоцикла. Увы, но это просто кусок металла.
	var/maxhealth = 600
	var/welder_health = 35	// Восстановление прочности за 1 топливо из сварки
	var/welder_time = 1 SECONDS	// Время требуемое для сварки
	var/is_welded = FALSE	// Сейчас происходит процесс варки?

	can_buckle = TRUE
	var/buckle_time = 3 SECONDS	// Не сразу можно сесть.
	var/obj/connected
	var/hit_chance_buckled = PROJECTILE_COVERAGE_LOW // Шанс попасть по сидящему
	var/hit_chance_to_unbuckle = 10 // Каждый удар имеет шанс отсоединить куклу при попадании по ней

/obj/structure/bed/chair/stroller/Initialize()
	. = ..()
	update_overlay()
	if(buckled_mob)
		buckled_mob.setDir(dir)

/obj/structure/bed/chair/stroller/New(loc, skin)
	if(skin)
		icon_skin = skin
	else if(need_camo)
		select_gamemode_skin()
	. = ..(loc, icon_skin)
	if(istype(loc, /obj/vehicle))
		connected = loc
	if(connected)
		connect(connected)
	else
		disconnect()

/obj/structure/bed/chair/stroller/proc/update_overlay()
	overlays.Cut()
	icon_state = "[icon_base]_[icon_skin]"
	var/image/I = new(icon = 'modular/vehicles/icons/moto48x48.dmi', icon_state = "[icon_state]-overlay", layer = layer_above) //over mobs
	overlays += I
	if(mounted)
		var/gun_overlay = "m56d"
		if(istype(mounted, /obj/item/device/m2c_gun))
			gun_overlay = "m2c"
		if(mounted.rounds <= 0)
			gun_overlay += "_e"
		var/image/I_gun = new(icon = 'modular/vehicles/icons/moto48x48.dmi', icon_state = "moto_ural_[gun_overlay]", layer = layer_above) //over mobs
		overlays += I_gun

/obj/structure/bed/chair/stroller/get_examine_text(mob/user)
	. = ..()
	if(!isxeno(user))
		. += SPAN_NOTICE("Прочность: [health/maxhealth*100]%")

// ==========================================
// ============ Коннект с байком ============

/obj/structure/bed/chair/stroller/proc/connect(atom/connection)
	connected = connection
	forceMove(connected.loc) // Обновляем местоположение, мы ж не хотим видеть коляску в чмстилище
	RegisterSignal(connected, COMSIG_MOVABLE_MOVED, PROC_REF(handle_parent_move))
	// Доп параметры для корректной обработки состояния "ОНО КАК ОБЪЕКТ НО СУКА НЕ ОБЪЕКТ"
	density = initial(density)
	anchored = initial(anchored)
	update_position(connected, TRUE)
	drag_delay = FALSE
	update_bike_permutated()

/obj/structure/bed/chair/stroller/proc/disconnect()
	if(connected)
		UnregisterSignal(connected, COMSIG_MOVABLE_MOVED)
	update_bike_permutated()
	reload_connected()
	connected = null
	density = !density
	anchored = !anchored
	update_drag_delay()
	update_position(src, TRUE)
	push_to_left_side(src)

/obj/structure/bed/chair/stroller/proc/handle_parent_move(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	forceMove(get_turf(mover))

// ==========================================
