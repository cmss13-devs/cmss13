// Главный чекер урона у vehicle, повторяем здесь же
/obj/structure/bed/chair/stroller/proc/healthcheck(damage = 0)
	if(health - damage <= 0)
		disconnect()
		update_mob_gun_signal(TRUE)
		// После уничтожения - создается разрушенный каркас
		new /obj/motorbike_destroyed/stroller(src.loc, icon_skin)
		if(mounted)
			mounted.forceMove(src.loc)
			mounted.update_health(mounted.health) // Разрушенный каркас, патроны и тому подобное
		unbuckle()
		deconstruct(FALSE)
		QDEL_NULL(src)

/obj/structure/bed/chair/stroller/update_health(damage = 0)
	healthcheck(damage)
	. = ..()

/obj/structure/bed/chair/stroller/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		return
	if(buckled_mob && prob(hit_chance_buckled))	// Шанс попасть по сидящему
		return buckled_mob.attack_animal(M)
	health -= M.melee_damage_upper
	src.visible_message(SPAN_DANGER("<B>[capitalize(M.declent_ru(NOMINATIVE))] [ru_attack_verb(M.attacktext)] [declent_ru(ACCUSATIVE)]!</B>"))
	M.attack_log += text("\[[time_stamp()]\] <font color='red'>рвет [src.name]</font>")
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	healthcheck()

/obj/structure/bed/chair/stroller/attack_alien(mob/living/carbon/xenomorph/M)
	if(unslashable)
		return
	if(M.melee_damage_upper == 0)
		return
	if(buckled_mob && prob(hit_chance_buckled))
		var/mob/affected_mob = buckled_mob
		if(prob(hit_chance_to_unbuckle))
			unbuckle()
			affected_mob.apply_effect(1, WEAKEN)
			affected_mob.throw_atom(src, 1, VEHICLE_SPEED_FASTER, M, TRUE)
			M.visible_message(SPAN_DANGER("[capitalize(M.declent_ru(NOMINATIVE))] сшибает [declent_ru(ACCUSATIVE)]!"), SPAN_DANGER("Мы сшибаем [declent_ru(ACCUSATIVE)]!"))
		affected_mob.attack_alien(M)	// Шанс попасть по сидящему
	M.animation_attack_on(src)
	playsound(src, hit_bed_sound, 25, 1)
	M.visible_message(SPAN_DANGER("[capitalize(M.declent_ru(NOMINATIVE))] кромсает [declent_ru(ACCUSATIVE)]!"),
	SPAN_DANGER("Мы кромсаем [declent_ru(ACCUSATIVE)]."))
	health -= M.melee_damage_upper
	healthcheck()
	return XENO_ATTACK_ACTION

/obj/structure/bed/chair/stroller/bullet_act(obj/projectile/P)
	if(buckled_mob && prob(hit_chance_buckled) && buckled_mob.get_projectile_hit_chance(P))
		return buckled_mob.bullet_act(P)	// Сидящие тоже могут получить пулю в задницу
	var/damage = P.damage
	health -= damage
	..()
	healthcheck()
	return TRUE

/obj/structure/bed/chair/stroller/ex_act(severity)
	health -= severity*0.05
	health -= severity*0.1
	healthcheck()
	return


