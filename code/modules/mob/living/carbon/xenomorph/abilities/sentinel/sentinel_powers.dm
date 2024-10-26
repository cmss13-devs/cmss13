/datum/action/xeno_action/activable/slowing_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/slowspit_user = owner
	if(!slowspit_user.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("We must wait for our spit glands to refill."))
		return

	var/turf/current_turf = get_turf(slowspit_user)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	slowspit_user.visible_message(SPAN_XENOWARNING("[slowspit_user] spits at [target]!"), \
	SPAN_XENOWARNING("You spit at [target]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(slowspit_user.loc, sound_to_play, 25, 1)

	slowspit_user.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(slowspit_user.caste_type), slowspit_user))
	projectile.generate_bullet(slowspit_user.ammo)
	projectile.permutated += slowspit_user
	projectile.def_zone = slowspit_user.get_limbzone_target()
	projectile.fire_at(target, slowspit_user, slowspit_user, slowspit_user.ammo.max_range, slowspit_user.ammo.shell_speed)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/scattered_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/scatterspit_user = owner
	if(!scatterspit_user.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("We must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(scatterspit_user)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	scatterspit_user.visible_message(SPAN_XENOWARNING("[scatterspit_user] spits at [target]!"), \
	SPAN_XENOWARNING("You spit at [target]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(scatterspit_user.loc, sound_to_play, 25, 1)

	scatterspit_user.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin/shotgun]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(scatterspit_user.caste_type), scatterspit_user))
	projectile.generate_bullet(scatterspit_user.ammo)
	projectile.permutated += scatterspit_user
	projectile.def_zone = scatterspit_user.get_limbzone_target()
	projectile.fire_at(target, scatterspit_user, scatterspit_user, scatterspit_user.ammo.max_range, scatterspit_user.ammo.shell_speed)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/paralyzing_slash/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/paraslash_user = owner

	if (!istype(paraslash_user))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/sentinel_base/behavior = paraslash_user.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(paraslash_user, SPAN_XENOHIGHDANGER("Our next slash will apply neurotoxin!"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/paralyzing_slash/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/unbuffslash_user = owner
	if (!istype(unbuffslash_user))
		return
	var/datum/behavior_delegate/sentinel_base/behavior = unbuffslash_user.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(unbuffslash_user, SPAN_XENODANGER("We have waited too long, our slash will no longer apply neurotoxin!"))
	button.icon_state = "template"
