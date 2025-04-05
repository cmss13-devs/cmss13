// ==========================================
// ================== Урон ==================
// После уничтожения - создается разрушенный каркас

// Главный чекер урона у vehicle
/obj/vehicle/motorbike/healthcheck()
	check_and_try_disasemble()
	. = ..()

/obj/vehicle/motorbike/proc/take_damage(damage)
	health -= damage
	healthcheck()

/obj/vehicle/motorbike/proc/check_and_try_disasemble(damage = 0)
	if(health - damage <= 0)
		disconnect()
		QDEL_NULL(lighting_holder)
		new /obj/motorbike_destroyed(src.loc, icon_skin)

/obj/vehicle/motorbike/bullet_act(obj/projectile/P)
	if(stroller && prob(hit_chance_connected) && stroller.get_projectile_hit_boolean(P))
		return stroller.bullet_act(P)	// Приконекченная тележка задевается если задевать и мотоцикл
	if(buckled_mob && prob(hit_chance_buckled) && buckled_mob.get_projectile_hit_chance(P))
		return buckled_mob.bullet_act(P)	// Сидящие тоже могут получить пулю в задницу
	. = ..()

/obj/vehicle/motorbike/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		return
	if(buckled_mob && prob(hit_chance_buckled))	// Шанс попасть по сидящему
		return buckled_mob.attack_animal(M)
	. = ..()

/obj/vehicle/motorbike/attack_alien(mob/living/carbon/xenomorph/M)
	if(stroller && prob(hit_chance_connected))
		return stroller.attack_alien(M)
	if(buckled_mob && prob(hit_chance_buckled))
		var/mob/affected_mob = buckled_mob
		if(prob(hit_chance_to_unbuckle))
			unbuckle()
			affected_mob.apply_effect(1, WEAKEN)
			affected_mob.throw_atom(src, 1, VEHICLE_SPEED_FASTER, M, TRUE)
			M.visible_message(SPAN_DANGER("[M] сшибает [src]!"), SPAN_DANGER("Мы сшибаем [src]!"))
		affected_mob.attack_alien(M)	// Шанс попасть и по сидящему
	. = ..()
