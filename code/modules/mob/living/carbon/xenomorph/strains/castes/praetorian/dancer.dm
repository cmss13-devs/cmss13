/datum/xeno_strain/dancer
	// My name is Cuban Pete, I'm the King of the Rumba Beat
	name = PRAETORIAN_DANCER
	description = "You lose all of your acid-based abilities and a small amount of your armor in exchange for increased movement speed, evasion, and unparalleled agility that gives you an ability to move even more quickly, dodge bullets, and phase through enemies and allies alike. By slashing enemies, you temporarily increase your movement speed and you also you apply a tag that changes how your two new tail abilities function. By tagging enemies, you will make Impale hit twice instead of once and make Tail Trip knock enemies down instead of stunning them."
	flavor_description = "A performance fit for a Queen, this one will become my instrument of death."
	icon_state_prefix = "Dancer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit/praetorian,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/prae_impale,
		/datum/action/xeno_action/onclick/prae_dodge,
		/datum/action/xeno_action/activable/prae_tail_trip,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_dancer

/datum/xeno_strain/dancer/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.armor_modifier -= XENO_ARMOR_MOD_VERY_SMALL
	prae.speed_modifier += XENO_SPEED_FASTMOD_TIER_5
	prae.dodge_chance = 18
	prae.regeneration_multiplier = XENO_REGEN_MULTIPLIER_TIER_7
	prae.plasma_types = list(PLASMA_CATECHOLAMINE)
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_dancer
	name = "Praetorian Dancer Behavior Delegate"

	// State
	var/dodge_activated = FALSE

/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if(!isxeno_human(target_carbon))
		return

	if(target_carbon.stat)
		return

	// Clean up all tags to 'refresh' our TTL
	for(var/datum/effects/dancer_tag/target_tag in target_carbon.effects_list)
		qdel(target_tag)

	new /datum/effects/dancer_tag(target_carbon, bound_xeno, , , 35)

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

/datum/action/xeno_action/activable/prae_impale/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if(!action_cooldown_check())
		return

	if(!dancer_user.check_state())
		return

	if(!ismob(target_atom))
		apply_cooldown_override(impale_click_miss_cooldown)
		update_button_icon()
		return

	if(!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if(target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
		return

	var/dist = get_dist(dancer_user, target_carbon)

	if(dist > range)
		to_chat(dancer_user, SPAN_WARNING("[target_carbon] is too far away!"))
		return

	if(dist > 1)
		var/turf/targetTurf = get_step(dancer_user, get_dir(dancer_user, target_carbon))
		if(targetTurf.density)
			to_chat(dancer_user, SPAN_WARNING("We can't attack through [targetTurf]!"))
			return
		else
			for(var/atom/atom_in_turf in targetTurf)
				if(atom_in_turf.density && !atom_in_turf.throwpass && !istype(atom_in_turf, /obj/structure/barricade) && !istype(atom_in_turf, /mob/living))
					to_chat(dancer_user, SPAN_WARNING("We can't attack through [atom_in_turf]!"))
					return

	if(!check_and_use_plasma_owner())
		return

	apply_cooldown()
	var/buffed = FALSE
	for(var/datum/effects/dancer_tag/dancer_tag_effect in target_carbon.effects_list)
		buffed = TRUE
		qdel(dancer_tag_effect)
		break

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/Hu = target_carbon
		Hu.update_xeno_hostile_hud()

	// Hmm today visible_message(SPAN_DANGER("\The [dancer_user] violently slices [target_atom] with its tail[buffed?" twice":""]!"),
	dancer_user.face_atom(target_atom)

	var/damage = get_xeno_damage_slash(target_carbon, rand(dancer_user.melee_damage_lower, dancer_user.melee_damage_upper))

	dancer_user.visible_message(SPAN_DANGER("\The [dancer_user] violently slices [target_atom] with its tail[buffed?" twice":""]!"),
					SPAN_DANGER("We slice [target_atom] with our tail[buffed?" twice":""]!"))

	if(buffed)
		dancer_user.animation_attack_on(target_atom)
		dancer_user.flick_attack_overlay(target_atom, "tail")
		dancer_user.emote("roar") // Feedback for the player that we got the magic double impale

		target_carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
		playsound(target_carbon, 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)

		damage = get_xeno_damage_slash(target_carbon, rand(dancer_user.melee_damage_lower, dancer_user.melee_damage_upper))
		var/list/attack_data = list(
			"attacker" = dancer_user,
			"target" = target_carbon,
			"damage" = damage
		)
		addtimer(CALLBACK(src, /datum/action/xeno_action/activable/prae_impale/proc/delayed_impale_strike, attack_data), 4)

	return ..()

/datum/action/xeno_action/activable/prae_impale/proc/delayed_impale_strike(list/attack_data)
	var/mob/living/carbon/xenomorph/attacker = attack_data["attacker"]
	var/mob/living/carbon/target = attack_data["target"]
	var/damage = attack_data["damage"]

	if(!attacker || !target || target.stat == DEAD)
		return

	attacker.animation_attack_on(target)
	attacker.flick_attack_overlay(target, "tail")

	target.last_damage_data = create_cause_data(initial(attacker.caste_type), attacker)
	target.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
	playsound(target, 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)

/datum/action/xeno_action/onclick/prae_dodge/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/dodge_user = owner

	if(!action_cooldown_check())
		return

	if(!istype(dodge_user) || !dodge_user.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/praetorian_dancer/behavior = dodge_user.behavior_delegate
	if(!istype(behavior))
		return

	behavior.dodge_activated = TRUE
	button.icon_state = "template_active"
	to_chat(dodge_user, SPAN_XENOHIGHDANGER("We can now dodge through mobs!"))
	dodge_user.speed_modifier -= speed_buff_amount
	dodge_user.dodge_chance += 20
	dodge_user.add_temp_pass_flags(PASS_MOB_THRU)
	dodge_user.recalculate_speed()

	INVOKE_ASYNC(src, PROC_REF(create_afterimage_sequence), dodge_user, duration)

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/prae_dodge/proc/remove_effects()
	var/mob/living/carbon/xenomorph/dodge_remove = owner

	if(!istype(dodge_remove))
		return

	var/datum/behavior_delegate/praetorian_dancer/behavior = dodge_remove.behavior_delegate
	if(!istype(behavior))
		return

	if(behavior.dodge_activated)
		behavior.dodge_activated = FALSE
		button.icon_state = "template_xeno"
		dodge_remove.speed_modifier += speed_buff_amount
		dodge_remove.dodge_chance -= 20
		dodge_remove.remove_temp_pass_flags(PASS_MOB_THRU)
		dodge_remove.recalculate_speed()
		to_chat(dodge_remove, SPAN_XENOHIGHDANGER("We can no longer dodge through mobs!"))

/datum/action/xeno_action/onclick/prae_dodge/proc/create_afterimage_sequence(mob/living/carbon/xenomorph/dodge_user, duration)
	if(!dodge_user || !dodge_user.loc)
		return

	var/afterimage_count = round(duration / afterimage_interval)

	var/datum/afterimage_state/state = new
	state.owner = dodge_user
	state.remaining = afterimage_count
	state.last_turf = get_turf(dodge_user.loc)

	addtimer(CALLBACK(src, PROC_REF(process_afterimage_tick), state), afterimage_interval)

/datum/action/xeno_action/onclick/prae_dodge/proc/process_afterimage_tick(datum/afterimage_state/state)
	if(!state || !state.owner || !state.owner.loc)
		return

	var/mob/living/carbon/xenomorph/dodge_user = state.owner
	var/turf/current_position = get_turf(dodge_user.loc)

	if(current_position && current_position != state.last_turf)
		var/random_offset_x = rand(-4, 4)
		var/random_offset_y = rand(-4, 4)

		dodge_user.reset_position_to_initial()
		dodge_user.apply_offset(random_offset_x, random_offset_y)

		create_afterimage(dodge_user, random_offset_x, random_offset_y)
		state.last_turf = current_position

	state.remaining--

	if(state.remaining > 0)
		addtimer(CALLBACK(src, PROC_REF(process_afterimage_tick), state), afterimage_interval)
	else
		addtimer(CALLBACK(dodge_user, TYPE_PROC_REF(/atom/movable, reset_position_to_initial)), 2 DECISECONDS)

/datum/action/xeno_action/onclick/prae_dodge/proc/create_afterimage(mob/living/carbon/xenomorph/dodge_user, random_offset_x, random_offset_y)
	if(!dodge_user || !dodge_user.loc)
		return

	var/turf/afterimage_location = get_turf(dodge_user.loc)
	if(!afterimage_location)
		return

	var/directional_offset_x = 0
	var/directional_offset_y = 0

	switch(dodge_user.dir)
		if(NORTH)
			directional_offset_y = -16
		if(SOUTH)
			directional_offset_y = 16
		if(EAST)
			directional_offset_x = -16
		if(WEST)
			directional_offset_x = 16

	var/obj/effect/overlay/afterimage = new /obj/effect/overlay/afterimage(afterimage_location)
	afterimage.icon = dodge_user.icon
	afterimage.icon_state = dodge_user.icon_state
	afterimage.color = dodge_user.color
	afterimage.layer = dodge_user.layer
	afterimage.dir = dodge_user.dir
	afterimage.alpha = 200
	afterimage.mouse_opacity = 0
	afterimage.pixel_x = dodge_user.pixel_x + directional_offset_x
	afterimage.pixel_y = dodge_user.pixel_y + directional_offset_y

	addtimer(CALLBACK(afterimage, TYPE_PROC_REF(/obj/effect/overlay/afterimage, fade_out_afterimage)))

/obj/effect/overlay/afterimage/proc/fade_out_afterimage()
	if(!src)
		return

	fade_step = 1
	addtimer(CALLBACK(src, PROC_REF(handle_fade_tick)), fade_delay)

/obj/effect/overlay/afterimage/proc/handle_fade_tick()
	if(!src)
		return

	alpha = round(200 * (1 - (fade_step / fade_max_steps)))

	if(fade_step >= fade_max_steps)
		qdel(src)
	else
		fade_step++
		addtimer(CALLBACK(src, PROC_REF(handle_fade_tick)), fade_delay)

/atom/movable/proc/reset_position_to_initial()
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)

/atom/movable/proc/apply_offset(dx, dy)
	pixel_x += dx
	pixel_y += dy

/datum/afterimage_state
	var/mob/living/carbon/xenomorph/owner
	var/remaining
	var/turf/last_turf

/obj/effect/overlay/afterimage
	name = "Dancer Afterimage"
	icon = 'icons/mob/xenos/castes/tier_3/praetorian.dmi'
	layer = MOB_LAYER
	var/fade_step = 0
	var/fade_max_steps = 4
	var/fade_delay = 1 DECISECONDS

/datum/action/xeno_action/activable/prae_tail_trip/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if(!action_cooldown_check())
		return

	if(!istype(dancer_user) || !dancer_user.check_state())
		return

	if(!ismob(target_atom))
		apply_cooldown_override(tail_click_miss_cooldown)
		update_button_icon()
		return

	if(!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if(target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
		return

	if(!check_and_use_plasma_owner())
		return


	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

	var/dist = get_dist(dancer_user, target_carbon)

	if(dist > range)
		to_chat(dancer_user, SPAN_WARNING("[target_carbon] is too far away!"))
		return

	if(dist > 1)
		var/turf/targetTurf = get_step(dancer_user, get_dir(dancer_user, target_carbon))
		if(targetTurf.density)
			to_chat(dancer_user, SPAN_WARNING("We can't attack through [targetTurf]!"))
			return
		else
			for(var/atom/atom_in_turf in targetTurf)
				if(atom_in_turf.density && !atom_in_turf.throwpass && !istype(atom_in_turf, /obj/structure/barricade) && !istype(atom_in_turf, /mob/living))
					to_chat(dancer_user, SPAN_WARNING("We can't attack through [atom_in_turf]!"))
					return

	// Hmm today I will kill a marine while looking away from them
	dancer_user.face_atom(target_carbon)
	dancer_user.flick_attack_overlay(target_carbon, "disarm")

	var/buffed = FALSE

	var/datum/effects/dancer_tag/dancer_tag_effect = locate() in target_carbon.effects_list

	if(dancer_tag_effect)
		buffed = TRUE
		qdel(dancer_tag_effect)

	if(!buffed)
		new /datum/effects/xeno_slow(target_carbon, dancer_user, null, null, get_xeno_stun_duration(target_carbon, slow_duration))

	var/stun_duration = stun_duration_default
	var/daze_duration = 0

	if(buffed)
		stun_duration = stun_duration_buffed
		daze_duration = daze_duration_buffed

	var/xeno_smashed = FALSE

	if(isxeno(target_carbon))
		var/mob/living/carbon/xenomorph/Xeno = target_carbon
		if(Xeno.mob_size >= MOB_SIZE_BIG)
			xeno_smashed = TRUE
			shake_camera(Xeno, 10, 1)
			dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] smashes [Xeno] with it's tail!"), SPAN_XENODANGER("We smash [Xeno] with your tail!"))
			to_chat(Xeno, SPAN_XENOHIGHDANGER("You feel dizzy as [dancer_user] smashes you with their tail!"))
			dancer_user.animation_attack_on(Xeno)

	if(!xeno_smashed)
		if (stun_duration > 0)
			target_carbon.apply_effect(stun_duration, WEAKEN)
		dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] trips [target_atom] with it's tail!"), SPAN_XENODANGER("We trip [target_atom] with our tail!"))
		dancer_user.spin_circle()
		dancer_user.emote("tail")
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You are swept off your feet by [dancer_user]!"))
	if(daze_duration > 0)
		target_carbon.apply_effect(daze_duration, DAZE)
	playsound(dancer_user, 'sound/effects/hit_kick.ogg', 75, 1)

	apply_cooldown()
	return ..()
