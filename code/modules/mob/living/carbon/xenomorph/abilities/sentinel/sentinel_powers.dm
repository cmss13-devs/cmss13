/datum/action/xeno_action/activable/slowing_spit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("You must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(X)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENOWARNING("[X] spits at [A]!"), \
	SPAN_XENOWARNING("You spit at [A]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(X.loc, sound_to_play, 25, 1)

	X.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin]
	var/obj/item/projectile/P = new /obj/item/projectile(current_turf, create_cause_data(initial(X.caste_type), X))
	P.generate_bullet(X.ammo)
	P.permutated += X
	P.def_zone = X.get_limbzone_target()
	P.fire_at(A, X, X, X.ammo.max_range, X.ammo.shell_speed)

	apply_cooldown()
	..()

/datum/action/xeno_action/activable/scattered_spit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(X.mutation_type != SENTINEL_NORMAL)
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("You must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(X)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENOWARNING("[X] spits at [A]!"), \
	SPAN_XENOWARNING("You spit at [A]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(X.loc, sound_to_play, 25, 1)

	X.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin/shotgun]
	var/obj/item/projectile/P = new /obj/item/projectile(current_turf, create_cause_data(initial(X.caste_type), X))
	P.generate_bullet(X.ammo)
	P.permutated += X
	P.def_zone = X.get_limbzone_target()
	P.fire_at(A, X, X, X.ammo.max_range, X.ammo.shell_speed)

	apply_cooldown()
	..()

/datum/action/xeno_action/onclick/paralyzing_slash/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	if (X.mutation_type != SENTINEL_NORMAL)
		return

	var/datum/behavior_delegate/sentinel_base/BD = X.behavior_delegate
	if (istype(BD))
		BD.next_slash_buffed = TRUE

	to_chat(X, SPAN_XENOHIGHDANGER("Your next slash will apply neurotoxin!"))

	addtimer(CALLBACK(src, .proc/unbuff_slash), buff_duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/paralyzing_slash/proc/unbuff_slash()
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return
	var/datum/behavior_delegate/sentinel_base/BD = X.behavior_delegate
	if (istype(BD))
		// In case slash has already landed
		if (!BD.next_slash_buffed)
			return
		BD.next_slash_buffed = FALSE

	to_chat(X, SPAN_XENODANGER("You have waited too long, your slash will no longer apply neurotoxin!"))
