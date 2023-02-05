/datum/action/xeno_action/activable/acid_lance/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if (!istype(X) || !X.check_state())
		return

	if (!activated_once && !action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if (!activated_once)
		// Start our 'charging'

		if (!check_and_use_plasma_owner())
			return

		X.create_empower()
		X.visible_message(SPAN_XENODANGER("[X] starts to gather its acid for a massive blast!"), SPAN_XENODANGER("You start to gather your acid for a massive blast!"))
		activated_once = TRUE
		stack()
		addtimer(CALLBACK(src, PROC_REF(timeout)), max_stacks*stack_time + time_after_max_before_end)
		apply_cooldown()
		return ..()

	else
		activated_once = FALSE
		var/range = base_range + stacks*range_per_stack
		var/damage = base_damage + stacks*damage_per_stack
		var/turfs_visited = 0
		for (var/turf/T in getline2(get_turf(X), A))
			if(T.density || T.opacity)
				break

			var/should_stop = FALSE
			for(var/obj/structure/S in T)
				if(istype(S, /obj/structure/window/framed))
					var/obj/structure/window/framed/W = S
					if(!W.unslashable)
						W.deconstruct(disassembled = FALSE)

				if(S.opacity)
					should_stop = TRUE
					break

			if (should_stop)
				break

			if (turfs_visited >= range)
				break

			turfs_visited++

			new /obj/effect/xenomorph/acid_damage_delay(T, damage, 7, FALSE, "You are blasted with a stream of high-velocity acid!", X)

		X.visible_message(SPAN_XENODANGER("[X] fires a massive blast of acid at [A]!"), SPAN_XENODANGER("You fire a massive blast of acid at [A]!"))
		remove_stack_effects("You feel your speed return to normal!")

/datum/action/xeno_action/activable/acid_lance/proc/stack()
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	if (!activated_once)
		return

	stacks = min(max_stacks, stacks + 1)
	if (stacks != max_stacks)
		X.speed_modifier += movespeed_per_stack
		movespeed_nerf_applied += movespeed_per_stack
		X.recalculate_speed()
		addtimer(CALLBACK(src, PROC_REF(stack)), stack_time)
		return
	else
		to_chat(X, SPAN_XENOHIGHDANGER("You have charged your acid lance to maximum!"))
		return

/datum/action/xeno_action/activable/acid_lance/proc/remove_stack_effects(message = null)
	var/mob/living/carbon/xenomorph/X = owner

	if (!istype(X))
		return

	if (stacks <= 0)
		return

	if (message)
		to_chat(X, SPAN_XENODANGER(message))

	stacks = 0
	X.speed_modifier -= movespeed_nerf_applied
	movespeed_nerf_applied = 0
	X.recalculate_speed()

/datum/action/xeno_action/activable/acid_lance/proc/timeout()
	if (activated_once)
		activated_once = FALSE
		remove_stack_effects("You have waited too long and can no longer use your acid lance!")


/datum/action/xeno_action/activable/acid_lance/action_cooldown_check()
	return (activated_once || ..())

/datum/action/xeno_action/onclick/dump_acid/use_ability(atom/A)
	if (!isxeno(owner))
		return

	if (!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/X = owner

	if (!X.check_state())
		return

	RegisterSignal(X, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(handle_mob_move_or_look))
	addtimer(CALLBACK(src, PROC_REF(remove_speed_buff)), buffs_duration)
	X.speed_modifier -= speed_buff_amount
	movespeed_buff_applied = TRUE
	X.recalculate_speed()

	to_chat(X, SPAN_XENOHIGHDANGER("You dump your acid, disabling your offensive abilities to escape!"))

	for (var/action_type in action_types_to_cd)
		var/datum/action/xeno_action/XA = get_xeno_action_by_type(X, action_type)
		if (!istype(XA))
			continue

		XA.apply_cooldown_override(cooldown_duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/dump_acid/proc/remove_speed_buff()
	if (movespeed_buff_applied && isxeno(owner))
		var/mob/living/carbon/xenomorph/xeno = owner
		xeno.speed_modifier += speed_buff_amount
		xeno.recalculate_speed()
		movespeed_buff_applied = FALSE
		UnregisterSignal(owner, COMSIG_MOB_MOVE_OR_LOOK)

/datum/action/xeno_action/onclick/dump_acid/proc/handle_mob_move_or_look(mob/living/carbon/xenomorph/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(!actually_moving)
		return

	var/obj/effect/particle_effect/smoke/S = new /obj/effect/particle_effect/smoke/xeno_burn(get_turf(mover), 1, create_cause_data(initial(mover.caste_type), mover))
	S.time_to_live = 3
	S.spread_speed = 1000000

/datum/action/xeno_action/onclick/dump_acid/remove_from()
	remove_speed_buff()
	..()

/////////////////////////////// Trapper boiler powers

/datum/action/xeno_action/activable/boiler_trap/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!can_see(X, A, TRAPPER_VIEWRANGE))
		to_chat(X, SPAN_XENODANGER("You cannot see that location!"))
		return

	if (!check_and_use_plasma_owner())
		return

	// 5-long line of turfs orthogonal to the line between us and our target as precisely as we can figure it
	var/dir_between = Get_Compass_Dir(X, A)
	var/list/target_turfs = list()
	var/target_turf = get_turf(A)
	var/left_turf = get_step(target_turf, turn(dir_between, -90))
	var/right_turf = get_step(target_turf, turn(dir_between, 90))
	target_turfs += target_turf
	target_turfs += left_turf
	target_turfs += right_turf
	target_turfs += get_step(left_turf, turn(dir_between, -90))
	target_turfs += get_step(right_turf, turn(dir_between, 90))


	for (var/turf/T in target_turfs)
		if (!istype(T) || T.density)
			continue

		var/trap_found = FALSE
		for (var/obj/effect/alien/resin/boilertrap/BT in T)
			trap_found = TRUE
			break

		if (trap_found)
			continue

		var/obj/effect/alien/resin/boilertrap/BT
		if(empowered)
			BT = new /obj/effect/alien/resin/boilertrap/empowered(T, X)
		else
			BT = new /obj/effect/alien/resin/boilertrap/(T, X)
		QDEL_IN(BT, trap_ttl)

	if(empowered)
		empowered = FALSE
		empowering_charge_counter = 0
		button.overlays -= "+empowered"
		var/datum/action/xeno_action/activable/acid_mine/mine = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/acid_mine)
		if(!mine.empowered)
			mine.empowered = TRUE
			mine.button.overlays += "+empowered"
			to_chat(X, SPAN_XENODANGER("You tap in your reserves to prepare a stronger [mine.name]!"))

	apply_cooldown()
	..()
	return


/datum/action/xeno_action/activable/acid_mine/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if (!istype(X))
		return

	if (!X.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if(!check_clear_path_to_target(X, A, TRUE, TRAPPER_VIEWRANGE))
		to_chat(X, SPAN_XENOWARNING("Something is in the way!"))
		return

	if (!check_and_use_plasma_owner())
		return

	var/turf/T = get_turf(A)
	var/acid_bolt_message = "a bolt of acid"
	if(empowered)
		acid_bolt_message = "a powerful bolt of acid"

	X.visible_message(SPAN_XENODANGER("[X] fires " + acid_bolt_message + " at [A]!"), SPAN_XENODANGER("You fire " + acid_bolt_message + " at [A]!"))
	new /obj/effect/xenomorph/acid_damage_delay/boiler_landmine(T, damage, delay, empowered, "You are blasted with " + acid_bolt_message + "!", X, )

	for (var/turf/targetTurf in orange(1, T))
		new /obj/effect/xenomorph/acid_damage_delay/boiler_landmine(targetTurf, damage, delay, empowered, "You are blasted with a " + acid_bolt_message + "!", X)

	if(empowered)
		empowered = FALSE
		button.overlays -= "+empowered"

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/acid_shotgun/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc) || !X.check_state())
		return

	X.visible_message(SPAN_XENOWARNING("The [X] fires a blast of acid at [A]!"), SPAN_XENOWARNING("You fire a blast of acid at [A]!"))

	var/turf/target = locate(A.x, A.y, A.z)
	var/obj/item/projectile/P = new /obj/item/projectile(X.loc, create_cause_data(initial(X.caste_type), X))

	var/datum/ammo/ammoDatum = new ammo_type()

	P.generate_bullet(ammoDatum)

	P.fire_at(target, X, X, ammoDatum.max_range, ammoDatum.shell_speed)

	apply_cooldown()
	..()
	return


/datum/ammo/xeno/acid_shotgun
	name = "acid ball"
	ping = null
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_STOPPED_BY_COVER|AMMO_IGNORE_ARMOR|AMMO_ACIDIC
	bonus_projectiles_type = /datum/ammo/xeno/acid_shotgun/spread
	hit_effect_color = "#FF0000"

/datum/ammo/xeno/acid_shotgun/New()
	..()
	damage = 10
	max_range = 5
	damage_type = BURN
	accuracy = HIT_ACCURACY_TIER_8
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_9
	shrapnel_type = /datum/ammo/xeno/acid_shotgun/spread
	shrapnel_chance = 100

/datum/ammo/xeno/acid_shotgun/spread
	name = "acid ball"

/datum/ammo/xeno/acid_shotgun/spread/New()
	..()
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0
	max_range = 4

/datum/action/xeno_action/activable/tail_stab/boiler/use_ability(atom/A)
	var/target = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.reagents.add_reagent("molecularacid", 6)
