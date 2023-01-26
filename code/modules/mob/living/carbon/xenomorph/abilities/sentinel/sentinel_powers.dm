/datum/action/xeno_action/activable/slowing_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("You must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] spits at [target]!"), \
	SPAN_XENOWARNING("You spit at [target]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(xeno.loc, sound_to_play, 25, 1)

	xeno.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin]
	var/obj/item/projectile/projectile = new /obj/item/projectile(current_turf, create_cause_data(initial(xeno.caste_type), xeno))
	projectile.generate_bullet(xeno.ammo)
	projectile.permutated += xeno
	projectile.def_zone = xeno.get_limbzone_target()
	projectile.fire_at(target, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	apply_cooldown()
	..()

/datum/action/xeno_action/activable/scattered_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(xeno.mutation_type != SENTINEL_NORMAL)
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("You must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] spits at [target]!"), \
	SPAN_XENOWARNING("You spit at [target]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(xeno.loc, sound_to_play, 25, 1)

	xeno.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin/shotgun]
	var/obj/item/projectile/projectile = new /obj/item/projectile(current_turf, create_cause_data(initial(xeno.caste_type), xeno))
	projectile.generate_bullet(xeno.ammo)
	projectile.permutated += xeno
	projectile.def_zone = xeno.get_limbzone_target()
	projectile.fire_at(target, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	apply_cooldown()
	..()

/datum/action/xeno_action/onclick/paralyzing_slash/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	if (xeno.mutation_type != SENTINEL_NORMAL)
		return
	button.icon_state = "template_active"

	apply_cooldown()
	..()
	return TRUE
