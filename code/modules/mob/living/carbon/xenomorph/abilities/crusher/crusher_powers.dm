
/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects_always()
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	for (var/mob/living/carbon/H in orange(1, get_turf(X)))
		if(X.can_not_harm(H))
			continue

		new /datum/effects/xeno_slow(H, X, null, null, 3.5 SECONDS)
		to_chat(H, SPAN_XENODANGER("You are slowed as the impact of [X] shakes the ground!"))

/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects(mob/living/L)
	if (!isxeno_human(L))
		return

	var/mob/living/carbon/H = L
	if (H.stat == DEAD)
		return

	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	X.emote("roar")
	L.apply_effect(2, WEAKEN)
	X.visible_message(SPAN_XENODANGER("[X] overruns [H], brutally trampling them underfoot!"), SPAN_XENODANGER("You brutalize [H] as you crush them underfoot!"))

	H.apply_armoured_damage(get_xeno_damage_slash(H, direct_hit_damage), ARMOR_MELEE, BRUTE)
	xeno_throw_human(H, X, X.dir, 3)

	H.last_damage_data = create_cause_data(X.caste_type, X)
	return

/datum/action/xeno_action/activable/pounce/crusher_charge/pre_windup_effects()
	RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))

	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner) || xeno_owner.mutation_type != CRUSHER_NORMAL)
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	crusher_delegate.is_charging = TRUE
	xeno_owner.update_icons()

/datum/action/xeno_action/activable/pounce/crusher_charge/post_windup_effects(interrupted)
	..()
	UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE)
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner) || xeno_owner.mutation_type != CRUSHER_NORMAL)
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	addtimer(CALLBACK(src, PROC_REF(undo_charging_icon)), 0.5 SECONDS) // let the icon be here for a bit, it looks cool

/datum/action/xeno_action/activable/pounce/crusher_charge/proc/undo_charging_icon()
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner) || xeno_owner.mutation_type != CRUSHER_NORMAL)
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	crusher_delegate.is_charging = FALSE
	xeno_owner.update_icons()

/datum/action/xeno_action/activable/pounce/crusher_charge/proc/check_directional_armor(mob/living/carbon/xenomorph/X, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(X.dir & REVERSE_DIR(projectile_direction))
		// During the charge windup, crusher gets an extra 15 directional armor in the direction its charging
		damagedata["armor"] += frontal_armor


// This ties the pounce/throwing backend into the old collision backend
/mob/living/carbon/xenomorph/crusher/pounced_obj(obj/O)
	var/datum/action/xeno_action/activable/pounce/crusher_charge/CCA = get_xeno_action_by_type(src, /datum/action/xeno_action/activable/pounce/crusher_charge)
	if (istype(CCA) && !CCA.action_cooldown_check() && !(O.type in CCA.not_reducing_objects))
		CCA.reduce_cooldown(50)

	gain_plasma(10)

	if (!handle_collision(O)) // Check old backend
		obj_launch_collision(O)

/mob/living/carbon/xenomorph/crusher/pounced_turf(turf/T)
	T.ex_act(EXPLOSION_THRESHOLD_VLOW, , create_cause_data(caste_type, src))
	..(T)

/datum/action/xeno_action/onclick/crusher_stomp/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	playsound(get_turf(X), 'sound/effects/bang.ogg', 25, 0)
	X.visible_message(SPAN_XENODANGER("[X] smashes into the ground!"), SPAN_XENODANGER("You smash into the ground!"))
	X.create_stomp()

	for (var/mob/living/carbon/H in get_turf(X))
		if (H.stat == DEAD || X.can_not_harm(H))
			continue

		new effect_type_base(H, X, , , get_xeno_stun_duration(H, effect_duration))
		to_chat(H, SPAN_XENOHIGHDANGER("You are slowed as [X] knocks you off balance!"))

		if(H.mob_size < MOB_SIZE_BIG)
			H.apply_effect(get_xeno_stun_duration(H, 0.2), WEAKEN)

		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE)
		H.last_damage_data = create_cause_data(X.caste_type, X)

	for (var/mob/living/carbon/H in orange(distance, get_turf(X)))
		if (H.stat == DEAD || X.can_not_harm(H))
			continue

		new effect_type_base(H, X, , , get_xeno_stun_duration(H, effect_duration))
		if(H.mob_size < MOB_SIZE_BIG)
			H.apply_effect(get_xeno_stun_duration(H, 0.2), WEAKEN)
		to_chat(H, SPAN_XENOHIGHDANGER("You are slowed as [X] knocks you off balance!"))

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/crusher_stomp/charger/use_ability()
	var/mob/living/carbon/xenomorph/Xeno = owner
	var/mob/living/carbon/Targeted
	if (!istype(Xeno))
		return

	if (!action_cooldown_check())
		return

	if (!Xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	playsound(get_turf(Xeno), 'sound/effects/bang.ogg', 25, 0)
	Xeno.visible_message(SPAN_XENODANGER("[Xeno] smashes into the ground!"), SPAN_XENODANGER("You smash into the ground!"))
	Xeno.create_stomp()

	for (var/mob/living/carbon/Human in get_turf(Xeno)) // MOBS ONTOP
		if (Human.stat == DEAD || Xeno.can_not_harm(Human))
			continue

		new effect_type_base(Human, Xeno, , , get_xeno_stun_duration(Human, effect_duration))
		to_chat(Human, SPAN_XENOHIGHDANGER("You are BRUTALLY crushed and stomped on by [Xeno]!!!"))
		shake_camera(Human, 10, 2)
		if(Human.mob_size < MOB_SIZE_BIG)
			Human.apply_effect(get_xeno_stun_duration(Human, 0.2), WEAKEN)

		Human.apply_armoured_damage(get_xeno_damage_slash(Human, damage), ARMOR_MELEE, BRUTE,"chest", 3)
		Human.apply_armoured_damage(15, BRUTE) // random
		Human.last_damage_data = create_cause_data(Xeno.caste_type, Xeno)
		Human.emote("pain")
		Targeted = Human
	for (var/mob/living/carbon/Human in orange(distance, get_turf(Xeno))) // MOBS AROUND
		if (Human.stat == DEAD || Xeno.can_not_harm(Human))
			continue
		if(Human.client)
			shake_camera(Human, 10, 2)
		if(Targeted)
			to_chat(Human, SPAN_XENOHIGHDANGER("You watch as [Targeted] gets crushed by [Xeno]!"))
		to_chat(Human, SPAN_XENOHIGHDANGER("You are shaken as [Xeno] quakes the earth!"))

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/crusher_shield/use_ability(atom/Target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] hunkers down and bolsters its defenses!"), SPAN_XENOHIGHDANGER("You hunker down and bolster your defenses!"))
	button.icon_state = "template_active"

	xeno.create_crusher_shield()

	xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_CRUSHER, /datum/xeno_shield/crusher)
	xeno.overlay_shields()

	xeno.explosivearmor_modifier += 1000
	xeno.recalculate_armor()

	addtimer(CALLBACK(src, PROC_REF(remove_explosion_immunity)), 25, TIMER_UNIQUE|TIMER_OVERRIDE)
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), 70, TIMER_UNIQUE|TIMER_OVERRIDE)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/crusher_shield/proc/remove_explosion_immunity()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	xeno.explosivearmor_modifier -= 1000
	xeno.recalculate_armor()
	to_chat(xeno, SPAN_XENODANGER("Your immunity to explosion damage ends!"))

/datum/action/xeno_action/onclick/crusher_shield/proc/remove_shield()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	var/datum/xeno_shield/found
	for (var/datum/xeno_shield/shield in xeno.xeno_shields)
		if (shield.shield_source == XENO_SHIELD_SOURCE_CRUSHER)
			found = shield
			break

	if (istype(found))
		found.on_removal()
		qdel(found)
		to_chat(xeno, SPAN_XENOHIGHDANGER("You feel your enhanced shield end!"))
		button.icon_state = "template"

	xeno.overlay_shields()

/datum/action/xeno_action/onclick/charger_charge/use_ability(atom/Target)
	var/mob/living/carbon/xenomorph/Xeno = owner

	activated = !activated
	var/will_charge = "[activated ? "now" : "no longer"]"
	to_chat(Xeno, SPAN_XENONOTICE("You will [will_charge] charge when moving."))
	if(activated)
		RegisterSignal(Xeno, COMSIG_MOVABLE_MOVED, PROC_REF(handle_movement))
		RegisterSignal(Xeno, COMSIG_MOB_KNOCKED_DOWN, PROC_REF(handle_movement))
		RegisterSignal(Xeno, COMSIG_ATOM_DIR_CHANGE, PROC_REF(handle_dir_change))
		RegisterSignal(Xeno, COMSIG_XENO_RECALCULATE_SPEED, PROC_REF(update_speed))
		RegisterSignal(Xeno, COMSIG_XENO_STOP_MOMENTUM, PROC_REF(stop_momentum))
		RegisterSignal(Xeno, COMSIG_MOVABLE_ENTERED_RIVER, PROC_REF(handle_river))
		RegisterSignal(Xeno, COMSIG_LIVING_PRE_COLLIDE, PROC_REF(handle_collision))
		RegisterSignal(Xeno, COMSIG_XENO_START_CHARGING, PROC_REF(start_charging))
		button.icon_state = "template_active"
	else
		stop_momentum()
		UnregisterSignal(Xeno, list(
			COMSIG_MOVABLE_MOVED,
			COMSIG_MOB_KNOCKED_DOWN,
			COMSIG_ATOM_DIR_CHANGE,
			COMSIG_XENO_RECALCULATE_SPEED,
			COMSIG_MOVABLE_ENTERED_RIVER,
			COMSIG_LIVING_PRE_COLLIDE,
			COMSIG_XENO_STOP_MOMENTUM,
			COMSIG_XENO_START_CHARGING,
			button.icon_state = "template"
		))
	if(!activated)
		button.icon_state = "template"


/datum/action/xeno_action/activable/tumble/use_ability(atom/Target)
	if(!action_cooldown_check())
		return
	var/mob/living/carbon/xenomorph/Xeno = owner
	if (!Xeno.check_state())
		return
	if(Xeno.plasma_stored <= plasma_cost)
		return
	var/target_dist = get_dist(Xeno, Target)
	var/dir_between = get_dir(Xeno, Target)
	var/target_dir
	for(var/perpen_dir in get_perpen_dir(Xeno.dir))
		if(dir_between & perpen_dir)
			target_dir = perpen_dir
			break

	if(!target_dir)
		return

	Xeno.visible_message(SPAN_XENOWARNING("[Xeno] tumbles over to the side!"), SPAN_XENOHIGHDANGER("You tumble over to the side!"))
	Xeno.spin(5,1) // note: This spins the sprite and DOES NOT affect directional armor
	var/start_charging = HAS_TRAIT(Xeno, TRAIT_CHARGING)
	SEND_SIGNAL(Xeno, COMSIG_XENO_STOP_MOMENTUM)
	Xeno.flags_atom |= DIRLOCK
	playsound(Xeno,"alien_tail_swipe", 50, 1)

	Xeno.use_plasma(plasma_cost)
	var/datum/launch_metadata/LM = new()
	LM.target = get_step(get_step(Xeno, target_dir), target_dir)
	LM.range = target_dist
	LM.speed = SPEED_FAST
	LM.thrower = Xeno
	LM.spin = FALSE
	LM.pass_flags = PASS_CRUSHER_CHARGE
	LM.collision_callbacks = list(/mob/living/carbon/human = CALLBACK(src, PROC_REF(handle_mob_collision)))
	LM.end_throw_callbacks = list(CALLBACK(src, PROC_REF(on_end_throw), start_charging))

	Xeno.launch_towards(LM)

	apply_cooldown()
	..()
