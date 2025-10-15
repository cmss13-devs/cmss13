/obj/vehicle/motorbike/buckle_mob(mob/M, mob/user)
	if(!try_buckle_mob(M, user))
		return FALSE
	. = ..()
	if(M.loc == src.loc && M.buckled)
		update_stroller(TRUE)
		play_start_sound()

/obj/vehicle/motorbike/proc/try_buckle_mob(mob/M, mob/user)
	if(!ismob(M) || (get_dist(src, user) > 1) || user.stat || buckled_mob || M.buckled)
		return FALSE
	if(!ishumansynth_strict(user))
		return FALSE	// Садиться могут только хуманы и синты
	if(user != M)
		to_chat(user, SPAN_WARNING("Вы можете только сами сесть на байк!"))
		return FALSE
	if(!skillcheck(M, SKILL_VEHICLE, required_skill))
		if(M == user)
			to_chat(user, SPAN_WARNING("Вы без понятия как им управлять!"))
		return FALSE
	if(!do_after(user, buckle_time * user.get_skill_duration_multiplier(SKILL_VEHICLE), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return FALSE
	if(!ismob(M) || (get_dist(src, user) > 1) || user.stat || buckled_mob || M.buckled)
		to_chat(user, SPAN_WARNING("Кто-то был быстрее!"))
		return FALSE
	do_buckle(M, user)
	update_stroller(TRUE)
	play_start_sound()
	return TRUE

/obj/vehicle/motorbike/afterbuckle(mob/M)
	. = ..()
	if(buckled_mob)
		density = TRUE
		add_vehicle_verbs(M)
		if(stroller)
			stroller.update_bike_permutated(TRUE)
		RegisterSignal(buckled_mob, list(COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOB_TACKLED_DOWN), PROC_REF(unbuckle))
	else
		density = initial(density)
		remove_vehicle_verbs(M)
	update_drive_skill_parameters()

/obj/vehicle/motorbike/unbuckle()
	if(stroller)	// Выносим сюда, а то неправильно уберет, т.к. моб уже отвязан
		stroller.reset_bike_permutated(TRUE)
	buckled_mob.set_glide_size(initial(buckled_mob.glide_size))
	UnregisterSignal(buckled_mob, list(COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOB_TACKLED_DOWN))
	. = ..()
