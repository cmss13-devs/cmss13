
////////// BASE RAV POWERS

/datum/action/xeno_action/activable/empower/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!istype(X) || !X.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!activated_once)
		if (!check_and_use_plasma_owner())
			return

		X.visible_message(SPAN_XENODANGER("[X] starts empowering!"), SPAN_XENODANGER("You start empowering yourself!"))
		activated_once = TRUE
		get_inital_shield()
		add_timer(CALLBACK(src, .proc/timeout), time_until_timeout)
		apply_cooldown()
		return ..()
	else
		actual_empower(X)

/datum/action/xeno_action/activable/empower/proc/actual_empower(var/mob/living/carbon/Xenomorph/X)
	if(!istype(X))
		return

	activated_once = FALSE
	X.visible_message(SPAN_XENOWARNING("[X] gets empowered by the surrounding enemies!"), SPAN_XENOWARNING("You feel a rush of power from the surrounding enemies!"))
	X.create_empower()
	
	var/list/mobs_in_range = orange(empower_range, X)
	// Spook patrol
	X.emote("tail")

	var/accumulative_health = 0
	for(var/mob/living/carbon/human/H in mobs_in_range)
		if(H.stat == DEAD || istype(H.buckled, /obj/structure/bed/nest))
			continue
		accumulative_health += shield_per_human
		shake_camera(H, 2, 1)

	accumulative_health = min(max_shield, accumulative_health)
	accumulative_health += baseline_shield
	
	X.add_xeno_shield(accumulative_health, XENO_SHIELD_SOURCE_RAVAGER)
	X.overlay_shields()

/datum/action/xeno_action/activable/empower/proc/get_inital_shield()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!istype(X))
		return

	if(!activated_once)
		return

	X.add_xeno_shield(initial_shield, XENO_SHIELD_SOURCE_RAVAGER)
	X.overlay_shields()

/datum/action/xeno_action/activable/empower/proc/timeout()
	if(!activated_once)
		return
	
	var/mob/living/carbon/Xenomorph/X = owner
	if(!istype(X))
		return
	actual_empower(X)

/datum/action/xeno_action/activable/empower/can_use_action()
	if (activated_once)
		return TRUE
	else
		return ..()

/datum/action/xeno_action/activable/empower/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		return TRUE
	else if (activated_once)
		return TRUE
	else
		return FALSE

// Supplemental behavior for our charge
/datum/action/xeno_action/activable/pounce/charge/additional_effects(mob/living/L)
	if (!istype(L, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = L
	var/mob/living/carbon/Xenomorph/X = owner
	if (istype(X) && X.mutation_type == RAVAGER_NORMAL)
		var/datum/behavior_delegate/ravager_base/BD = X.behavior_delegate
		if (istype(BD))
			var/shield_total = 0
			for (var/datum/xeno_shield/XS in X.xeno_shields)
				if (XS.shield_source == XENO_SHIELD_SOURCE_RAVAGER)
					shield_total += XS.amount
					break 

			if (shield_total > BD.min_shield_buffed_abilities)
				X.visible_message(SPAN_XENODANGER("The [X] uses its shield to bash [H] as it charges at them!"), SPAN_XENODANGER("You use your shield to bash [H] as you charge at them!"))
				H.KnockDown(BD.knockdown_amount)
				
				var/facing = get_dir(X, H)
				var/turf/T = X.loc
				var/turf/temp = X.loc

				for (var/x in 0 to BD.fling_distance-1)
					temp = get_step(T, facing)
					if (!temp)
						break
					T = temp

				H.launch_towards(T, BD.fling_distance, SPEED_VERY_FAST, X, TRUE)

	else
		return

/datum/action/xeno_action/activable/scissor_cut/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	// Determine whether or not we should daze here
	var/should_daze = FALSE
	if (X.mutation_type == RAVAGER_NORMAL)
		var/datum/behavior_delegate/ravager_base/BD = X.behavior_delegate
		if (istype(BD))
			
			var/shield_total = 0
			for (var/datum/xeno_shield/XS in X.xeno_shields)
				if (XS.shield_source == XENO_SHIELD_SOURCE_RAVAGER)
					shield_total += XS.amount
					break 

			if (shield_total >= BD.min_shield_buffed_abilities)
				should_daze = TRUE

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = get_dir(X, A)
	var/turf/T = X.loc
	var/turf/temp = X.loc

	for (var/x in 0 to 3)
		temp = get_step(T, facing)
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(istype(S, /obj/structure/window/framed))
				var/obj/structure/window/framed/W = S
				if(!W.unslashable)
					W.shatter_window(TRUE)

			if(S.opacity)
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp
		target_turfs += T

	// Extract our 'optimal' turf, if it exists
	if (target_turfs.len >= 2)
		X.animation_attack_on(target_turfs[target_turfs.len], 15)

	X.emote("roar")
	X.visible_message(SPAN_XENODANGER("[X] sweeps its claws through the area in front of it!"), SPAN_XENODANGER("You sweep your claws through the area in front of you!"))

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/turf/target_turf in target_turfs)
		for (var/mob/living/carbon/human/H in target_turf)
			if (H.stat)
				continue 

			X.flick_attack_overlay(H, "slash")
			H.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			playsound(get_turf(H), "alien_claw_flesh", 30, 1)

			if (should_daze)
				H.Daze(daze_duration)

	apply_cooldown()
	..()
	return




///////////// BERSERKER POWERS

/datum/action/xeno_action/activable/apprehend/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state() || X.action_busy)
		return
	
	if (!ishuman(A))
		to_chat(X, SPAN_XENOWARNING("You must target a human!"))
		return

	if (get_dist(A, X) > max_distance)
		to_chat(X, SPAN_XENOWARNING("[A] is too far away!"))
		return

	var/mob/living/carbon/human/H = A

	if (H.stat == DEAD)
		to_chat(X, SPAN_XENOWARNING("[H] is dead, you can't pull yourself to it!"))
		return

	if (!check_and_use_plasma_owner())
		return

	
	
	apply_cooldown()

	to_chat(H, SPAN_XENOHIGHDANGER("You feel [X] fire bone spurs that dig into your skin! You have [windup_duration/10] seconds to move away or it will pull itself to you!"))
	to_chat(X, SPAN_XENOHIGHDANGER("Stay close to [H] to be pulled to it!"))

	H.targeted_by = X
	H.target_locked = image("icon" = 'icons/effects/Targeted.dmi', "icon_state" = "locking")
	new /datum/effects/xeno_slow(H, X, null, null, 20)
	H.update_targeted()

	if (!do_after(X, windup_duration, INTERRUPT_ALL & ~INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
		H.targeted_by = null
		H.target_locked = null
		H.update_targeted()
		to_chat(X, SPAN_XENODANGER("The target moved out of range or you were incapacitated!"))
		return

	// Needs to occur AFTER the do_after resolves.
	if (get_dist(A, X) > max_distance)
		H.targeted_by = null
		H.target_locked = null
		H.update_targeted()
		to_chat(X, SPAN_XENODANGER("The target moved out of range or you were incapacitated!"))
		return

	H.targeted_by = null
	H.target_locked = null
	H.update_targeted()

	to_chat(X, SPAN_XENOHIGHDANGER("You attempt to pull yourself to [H]!"))
	to_chat(H, SPAN_XENOHIGHDANGER("[X] pulls itself towards you!"))
	X.launch_towards(get_step_towards(A, X), max_distance, SPEED_FAST, X)

	..()
	return


/datum/action/xeno_action/activable/clothesline/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return
	
	if (!ishuman(A))
		to_chat(X, SPAN_XENOWARNING("You must target a human!"))
		return

	if (!X.Adjacent(A))
		to_chat(X, SPAN_XENOWARNING("You must be adjacent to your target!"))
		return

	var/mob/living/carbon/human/H = A
	var/heal_amount = heal_per_rage
	var/fling_distance = fling_dist_base
	var/debilitate = TRUE // Do we apply neg. status effects to the target?

	if (H.stat == DEAD)
		return

	// All strain-specific behavior
	if (X.mutation_type == RAVAGER_BERSERKER)
		var/datum/behavior_delegate/ravager_berserker/BD = X.behavior_delegate

		if (!istype(BD))
			return

		if (BD.rage >= 1)
			BD.decrement_rage()
		else 
			to_chat(X, SPAN_XENOWARNING("You don't have enough rage to heal!"))
			heal_amount -= heal_per_rage
			debilitate = FALSE
			fling_distance--

	// Damage
	var/obj/limb/head/head = H.get_limb("head")
	if(head)
		H.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "head")

	// Heal
	X.gain_health(heal_amount)
	
	// Fling
	var/facing = get_dir(X, H)
	var/turf/T = X.loc
	var/turf/temp = X.loc

	for (var/x in 0 to fling_distance-1)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	H.launch_towards(T, fling_distance, SPEED_VERY_FAST, X, TRUE)

	// Negative stat effects
	if (debilitate)
		H.dazed += daze_amount

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/eviscerate/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if(!action_cooldown_check() || X.action_busy)
		return

	if(!X.check_state())
		return

	var/damage = base_damage
	var/range = 1
	var/windup_reduction = 0

	if (X.mutation_type == RAVAGER_BERSERKER)
		var/datum/behavior_delegate/ravager_berserker/BD = X.behavior_delegate
		if (istype(BD))
			if (BD.rage == 0)
				to_chat(X, SPAN_XENODANGER("You cannot eviscerate when you have 0 rage!"))
				return
			if (!BD.rage_lock_start_time)
				BD.decrement_rage(BD.rage)
			damage = damage_at_rage_levels[Clamp(BD.rage+1, 1, BD.max_rage)]
			range = range_at_rage_levels[Clamp(BD.rage+1, 1, BD.max_rage)]
			windup_reduction = windup_reduction_at_rage_levels[Clamp(BD.rage+1, 1, BD.max_rage)]

		apply_cooldown()
	
	if (range > 1)
		X.visible_message(SPAN_XENOHIGHDANGER("[X] begins digging in for a massive strike!"), SPAN_XENOHIGHDANGER("You begin digging in for a massive strike!"))
	else
		X.visible_message(SPAN_XENODANGER("[X] begins digging in for a strike!"), SPAN_XENOHIGHDANGER("You begin digging in for a strike!"))
	
	X.frozen = 1
	X.anchored = 1
	X.update_canmove()

	if (do_after(X, (activation_delay - windup_reduction), INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		X.emote("roar")
		X.spin_circle()

		for (var/mob/living/carbon/human/H in orange(X, range))
			if (H.stat == DEAD)
				continue

			if(!check_clear_path_to_target(X, H))
				continue

			if (range > 1)
				X.visible_message(SPAN_XENOHIGHDANGER("[X] rips open the guts of [H]!"), SPAN_XENOHIGHDANGER("You rip open the guts of [H]!"))
				H.spawn_gibs()
				playsound(get_turf(H), 'sound/effects/gibbed.ogg', 30, 1)
				H.KnockDown(1)
			else
				X.visible_message(SPAN_XENODANGER("[X] claws [H]!"), SPAN_XENODANGER("You claw [H]!"))
				playsound(get_turf(H), "alien_claw_flesh", 30, 1)
	
			H.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 20)

	X.frozen = 0
	X.anchored = 0
	X.update_canmove()

	..()
	return
			

////////// HEDGEHOG POWERS

/datum/action/xeno_action/activable/spike_shield/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (X.mutation_type == RAVAGER_HEDGEHOG)
		var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
		if (istype(BD))
			if (!BD.check_shards(shard_cost))
				to_chat(X, SPAN_DANGER("Not enough shards! You need [shard_cost - BD.shards] more!"))
				return 
			BD.use_shards(shard_cost)

	X.visible_message(SPAN_XENODANGER("[X] ruffles its bone-shard quills, forming a defensive shell!"), SPAN_XENODANGER("You ruffle your bone-shard quills, forming a defensive shell!"))
	
	// Add our shield
	var/datum/xeno_shield/hedgehog_shield/XS = X.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_HEDGE_RAV, /datum/xeno_shield/hedgehog_shield)
	if (XS)
		XS.owner = X
		XS.shrapnel_amount = shield_shrapnel_amount
		X.overlay_shields()

	X.create_shield(shield_duration)
	shield_active = TRUE
	add_timer(CALLBACK(src, .proc/remove_shield), shield_duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/spike_shield/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/Xenomorph/X = owner
		if (!istype(X))
			return FALSE
		if (X.mutation_type == RAVAGER_HEDGEHOG)
			var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
			if (istype(BD))
				return BD.check_shards(shard_cost)

		return TRUE
	else
		return shield_active

/datum/action/xeno_action/activable/spike_shield/proc/remove_shield()
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!shield_active)
		return

	shield_active = FALSE

	for (var/datum/xeno_shield/XS in X.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_HEDGE_RAV)
			X.xeno_shields -= XS
			qdel(XS)
			break 

	to_chat(X, SPAN_XENODANGER("You feel your shard shield dissipate!"))
	X.overlay_shields()
	return

/datum/action/xeno_action/activable/rav_spikes/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return
	
	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc) || !X.check_state()) 
		return

	if (X.mutation_type == RAVAGER_HEDGEHOG)
		var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
		if (istype(BD))
			if (!BD.check_shards(shard_cost))
				to_chat(X, SPAN_DANGER("Not enough shards! You need [shard_cost - BD.shards] more!"))
				return 
			BD.use_shards(shard_cost)

	X.visible_message(SPAN_XENOWARNING("The [X] fires their spikes at [A]!"), SPAN_XENOWARNING("You fire your spikes at [A]!"))

	var/turf/target = locate(A.x, A.y, A.z)
	var/obj/item/projectile/P = new /obj/item/projectile(initial(X.caste_name), X, X.loc)
	
	var/datum/ammo/ammoDatum = ammo_list[ammo_type]

	P.generate_bullet(ammoDatum)

	P.fire_at(target, X, X, ammoDatum.max_range, ammoDatum.shell_speed)
	playsound(X, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/rav_spikes/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/Xenomorph/X = owner
		if (!istype(X))
			return FALSE
		if (X.mutation_type == RAVAGER_HEDGEHOG)
			var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
			if (istype(BD))
				return BD.check_shards(shard_cost)

		return TRUE
	else 
		return FALSE

/datum/action/xeno_action/activable/spike_shed/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (X.mutation_type == RAVAGER_HEDGEHOG)
		var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
		if (istype(BD))
			if (!BD.check_shards(shard_cost))
				to_chat(X, SPAN_DANGER("Not enough shards! You need [shard_cost - BD.shards] more!"))
				return 
			BD.use_shards(shard_cost)
			BD.lock_shards()

	X.visible_message(SPAN_XENOWARNING("The [X] sheds their spikes, firing them in all directions!"), SPAN_XENOWARNING("You shed your spikes, firing them in all directions!!"))
	X.spin_circle()
	create_shrapnel(get_turf(X), shrapnel_amount, null, null, ammo_type, null, owner, TRUE)
	playsound(X, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/spike_shed/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/Xenomorph/X = owner
		if (!istype(X))
			return FALSE
		if (X.mutation_type == RAVAGER_HEDGEHOG)
			var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
			if (istype(BD))
				return BD.check_shards(shard_cost)

		return TRUE
	else 
		return FALSE