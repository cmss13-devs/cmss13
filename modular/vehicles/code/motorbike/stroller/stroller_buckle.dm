// ==========================================
// =============== Усаживание ===============

/obj/structure/bed/chair/stroller/buckle_mob(mob/living/carbon/human/mob, mob/user)
	if(!try_buckle_mob(mob, user))
		return TRUE
	. = ..()

/obj/structure/bed/chair/stroller/proc/can_xeno_buckle(mob/M)
	// Мы можем посадить небольшого ксеноса, если он будет помогать лапками в граб интенте. Как на кровати.
	// мы сможем украсть руню или ящерку, если они не особо сопротивляться будут
	// Мы можем посадить: Lesser Drones, Люди
	return (
		(M.mob_size == MOB_SIZE_XENO && \
			(M.a_intent == INTENT_GRAB || M.stat == DEAD)) \
		|| \
		(M.mob_size == MOB_SIZE_XENO_SMALL && \
			(M.a_intent == INTENT_HELP || M.a_intent == INTENT_GRAB || M.stat == DEAD)) \
		|| \
		(M.mob_size <= MOB_SIZE_XENO_VERY_SMALL)
		)

/obj/structure/bed/chair/stroller/proc/try_buckle_mob(mob/M, mob/user)
	if(!ismob(M) || (get_dist(src, user) > 1) || user.stat || buckled_mob || M.buckled)
		return FALSE
	if(!ishumansynth_strict(user))
		return FALSE	// Садить могут только хуманы и синты
	if(!can_xeno_buckle(M))
		return FALSE
	if(!do_after(user, buckle_time * user.get_skill_duration_multiplier(SKILL_VEHICLE), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return FALSE
	if(!ismob(M) || (get_dist(src, user) > 1) || user.stat || buckled_mob || M.buckled)
		to_chat(user, SPAN_WARNING("Кто-то был быстрее!"))
		return FALSE
	do_buckle(M, user)
	if(buckling_sound)
		playsound(src, buckling_sound, 20)
	return TRUE

/obj/structure/bed/chair/stroller/afterbuckle(mob/M)
	. = ..()
	if(buckled_mob)
		update_buckle_mob()
		update_drag_delay()
		update_mob_gun_signal()
		update_bike_permutated(TRUE)
		RegisterSignal(buckled_mob, list(COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOB_TACKLED_DOWN), PROC_REF(unbuckle))
	else
		if(connected)
			push_to_left_side(buckled_mob)
		update_drag_delay()
		reset_bike_permutated(TRUE)

/obj/structure/bed/chair/stroller/unbuckle()
	// Отдельно, иначе возникнет ситуация где сигнал не успевает убраться,
	// т.к. нам ВСЕГДА нужен моб чтобы убрать у него сигнал
	update_mob_gun_signal(TRUE)
	reload_buckle_mob()
	UnregisterSignal(buckled_mob, list(COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOB_TACKLED_DOWN))
	. = ..()


// ==========================================
// =============== Обновление ===============

/obj/structure/bed/chair/stroller/proc/update_buckle_mob()
	if(!buckled_mob)
		return
	buckled_mob.pixel_x = get_buckled_mob_pixel_x()
	buckled_mob.pixel_y = get_buckled_mob_pixel_y()
	buckled_mob.setDir(dir)
	buckled_mob.density = FALSE
	if(dir == WEST)
		buckled_mob.layer = layer_west
	else
		buckled_mob.layer = initial(buckled_mob.layer)
	if(mounted)
		update_gun_dir()
