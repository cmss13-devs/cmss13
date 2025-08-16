/obj/vehicle/motorbike
	var/crash_damage_multiplier = 1.0 // Множитель урона при столкновении
	var/last_crash_time = 0 // Время последнего столкновения
	var/crash_cooldown = 2 SECONDS // Задержка между столкновениями

// ==========================================
// =============== Коллизия =================

/obj/vehicle/motorbike/Collide(atom/A)
	if(world.time < last_crash_time + crash_cooldown)
		return ..()

	if(!buckled_mob)
		return ..()

	if(current_speed_level <= 1)
		return ..()

	last_crash_time = world.time

	// Обработка столкновений в зависимости от типа объекта
	if(ismob(A))
		handle_mob_collision(A)
	else if(isclosedturf(A))
		handle_wall_collision(A)
	else if(isobj(A) && A.density)
		handle_object_collision(A)
	else
		return ..()

	// Сброс скорости после любого столкновения
	reset_speed()
	return TRUE


// ==========================================
// ========= Коллизия с объектами ===========

/obj/vehicle/motorbike/proc/handle_wall_collision(turf/wall)
	if(current_speed_level <= 1)
		return

	var/damage = 10 * current_speed_level * 0.5 * crash_damage_multiplier

	// Урон мотоциклу
	take_damage(damage)

	// Эффекты для водителя
	if(buckled_mob)
		var/mob/living/L = buckled_mob
		L.apply_damage(damage * 0.7, BRUTE)
		L.apply_effect(current_speed_level, WEAKEN)
		L.apply_effect(current_speed_level, STUN)
		to_chat(L, SPAN_HIGHDANGER("Вы врезались в [wall]на полной скорости!"))
		unbuckle()

	// Эффекты для пассажира
	if(stroller?.buckled_mob)
		var/mob/living/L = stroller.buckled_mob
		L.apply_damage(damage * 0.5, BRUTE)
		L.apply_effect(current_speed_level, STUN)

	playsound(src, 'sound/effects/metal_crash.ogg', 75, 1)
	visible_message(SPAN_DANGER("[src] врезается в [wall] на полной скорости!"))

/obj/vehicle/motorbike/proc/handle_object_collision(obj/O)
	if(current_speed_level <= 1)
		return

	var/damage = 5 * current_speed_level * 0.3 * crash_damage_multiplier

	// Урон мотоциклу
	take_damage(damage)

	// Урон объекту
	if(O.health)
		throwforce = damage
		O.hitby(src)
		throwforce = initial(throwforce)

	// Эффекты для водителя
	if(buckled_mob)
		var/mob/living/L = buckled_mob
		L.apply_damage(damage * 0.5, BRUTE)
		L.apply_effect(current_speed_level * 0.5, STUN)
		to_chat(L, SPAN_WARNING("Вы врезались в [O]!"))

	playsound(src, 'sound/effects/grillehit.ogg', 50, 1)
	visible_message(SPAN_WARNING("[src] врезается в [O]!"))


// ==========================================
// ========== Коллизия с мобами =============

/obj/vehicle/motorbike/proc/handle_mob_collision(mob/M)
	var/mod = 0
	var/bike_collide = TRUE

	switch(M.mob_size)
		if(MOB_SIZE_SMALL)
			bike_collide = FALSE
			mod = 2
		if(MOB_SIZE_HUMAN)
			mod = 1
		if(MOB_SIZE_XENO_VERY_SMALL)
			bike_collide = FALSE
			mod = 1.2
		if(MOB_SIZE_XENO_SMALL)
			mod = 0.9
		if(MOB_SIZE_XENO)
			mod = 0.7
		if(MOB_SIZE_BIG)
			mod = 0.3
		if(MOB_SIZE_IMMOBILE)
			mod = 0

	// Учитываем скорость при столкновении
	mod *= current_speed_level * 0.5

	// Обработка для разных типов мобов
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/try_broke_bones = TRUE
		if(isyautja(C))
			mod *= 0.5
			try_broke_bones = FALSE
		if(mod)
			apply_collision_effects(C, mod, try_broke_bones)
		if(isxeno(M))
			attack_alien(M)
	else if(isliving(M))
		var/mob/living/L = M
		L.adjustBruteLoss(20 * current_speed_level)

	// Звуки и визуальные эффекты
	if(!bike_collide)
		playsound(src.loc, 'sound/effects/bone_break7.ogg', 25, 1)
		buckled_mob.visible_message(SPAN_DANGER("[buckled_mob] на [name] переехал [M]!"))
	else
		playsound(src.loc, 'sound/effects/bang.ogg', 50, 1)
		if(ishuman_strict(M) && !blooded)
			blooded = TRUE
			update_overlay()
		handle_driver_effects(M, mod)

/obj/vehicle/motorbike/proc/handle_driver_effects(mob/M, mod)
	var/mob/living/carbon/occupant = buckled_mob
	unbuckle()

	if(mod)
		apply_collision_effects(occupant, 1/mod)
		if(stroller?.buckled_mob)
			var/mob/living/carbon/second_occupant = stroller.buckled_mob
			apply_collision_effects(second_occupant, 1.5/mod)

	occupant.visible_message(SPAN_DANGER("[occupant] на [name] врезался в [M]!"))


// ==========================================
// =========== Эффекты на мобов =============

/obj/vehicle/motorbike/proc/apply_collision_effects(mob/living/carbon/C, mod, try_broke_bones = FALSE)
	var/throw_range = 1 * mod
	var/damage = 17 * mod
	var/weaken = 2 * mod
	var/stutter = 10 * mod

	C.throw_atom(get_step(src, dir), throw_range, SPEED_FAST, src, TRUE)
	C.apply_damage(damage, BRUTE)
	C.apply_effect(weaken, WEAKEN)
	C.apply_effect(stutter, STUTTER)

	if(try_broke_bones && ishuman(C))
		var/obj/limb/L = C.get_limb(rand_zone())
		if(L && prob(15 * current_speed_level * 0.5))
			L.fracture(100)
