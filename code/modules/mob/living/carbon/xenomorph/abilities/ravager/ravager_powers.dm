
////////// BASE RAV POWERS

/datum/action/xeno_action/activable/empower/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(X.mutation_type != RAVAGER_NORMAL)
		return

	if(!action_cooldown_check())
		return

	if(!activated_once)
		if (!check_and_use_plasma_owner())
			return

		X.visible_message(SPAN_XENODANGER("[X] starts empowering!"), SPAN_XENODANGER("You start empowering yourself!"))
		activated_once = TRUE
		get_inital_shield()
		addtimer(CALLBACK(src, .proc/timeout), time_until_timeout)
		apply_cooldown()
		return ..()
	else
		actual_empower(X)

/datum/action/xeno_action/activable/empower/proc/actual_empower(var/mob/living/carbon/Xenomorph/X)
	var/datum/behavior_delegate/ravager_base/BD = X.behavior_delegate

	activated_once = FALSE
	X.visible_message(SPAN_XENOWARNING("[X] gets empowered by the surrounding enemies!"), SPAN_XENOWARNING("You feel a rush of power from the surrounding enemies!"))
	X.create_empower()

	var/list/mobs_in_range = oviewers(empower_range, X)
	// Spook patrol
	X.emote("tail")

	var/accumulative_health = 0
	var/list/telegraph_atom_list = list()

	var/empower_targets
	for(var/mob/M as anything in mobs_in_range)
		if(empower_targets >= max_targets)
			break
		if(M.stat == DEAD || HAS_TRAIT(M, TRAIT_NESTED))
			continue
		if(X.can_not_harm(M))
			continue

		empower_targets++
		accumulative_health += shield_per_human
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(M.loc, 1 SECONDS)
		shake_camera(M, 2, 1)

	accumulative_health += main_empower_base_shield

	X.add_xeno_shield(accumulative_health, XENO_SHIELD_SOURCE_RAVAGER)
	X.overlay_shields()
	if(empower_targets >= BD.super_empower_threshold) //you go in deep you reap the rewards
		super_empower(X, empower_targets, BD)

/datum/action/xeno_action/activable/empower/proc/super_empower(var/mob/living/carbon/Xenomorph/X, var/empower_targets, var/datum/behavior_delegate/ravager_base/BD)
	X.visible_message(SPAN_DANGER("[X] glows an eerie red as it empowers further with the strength of [empower_targets] hostiles!"), SPAN_XENOHIGHDANGER("You begin to glow an eerie red, empowered by the [empower_targets] enemies!"))
	X.emote("roar")


	BD.empower_targets = empower_targets

	var/color = "#FF0000"
	var/alpha = 70
	color += num2text(alpha, 2, 16)
	X.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))

	addtimer(CALLBACK(src, .proc/weaken_superbuff, X, BD), 3.5 SECONDS)

/datum/action/xeno_action/activable/empower/proc/weaken_superbuff(var/mob/living/carbon/Xenomorph/X, var/datum/behavior_delegate/ravager_base/BD)

	X.remove_filter("empower_rage")
	var/color = "#FF0000"
	var/alpha = 35
	color += num2text(alpha, 2, 16)
	X.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))

	addtimer(CALLBACK(src, .proc/remove_superbuff, X, BD), 1.5 SECONDS)

/datum/action/xeno_action/activable/empower/proc/remove_superbuff(var/mob/living/carbon/Xenomorph/X, var/datum/behavior_delegate/ravager_base/BD)
	BD.empower_targets = 0

	X.visible_message(SPAN_DANGER("[X]'s glow slowly dims."), SPAN_XENOHIGHDANGER("Your glow fades away, the power leaving your body!"))
	X.remove_filter("empower_rage")

/datum/action/xeno_action/activable/empower/proc/get_inital_shield()
	var/mob/living/carbon/Xenomorph/X = owner

	if(!activated_once)
		return

	X.add_xeno_shield(initial_activation_shield, XENO_SHIELD_SOURCE_RAVAGER)
	X.overlay_shields()

/datum/action/xeno_action/activable/empower/proc/timeout()
	if(!activated_once)
		return

	var/mob/living/carbon/Xenomorph/X = owner
	actual_empower(X)

/datum/action/xeno_action/activable/empower/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		return TRUE
	else if (activated_once)
		return TRUE
	else
		return FALSE

// Supplemental behavior for our charge
/datum/action/xeno_action/activable/pounce/charge/additional_effects(mob/living/L)

	var/mob/living/carbon/human/H = L
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.mutation_type != RAVAGER_NORMAL)
		return
	var/datum/behavior_delegate/ravager_base/BD = X.behavior_delegate
	if(BD.empower_targets < BD.super_empower_threshold)
		return
	X.visible_message(SPAN_XENODANGER("The [X] uses its shield to bash [H] as it charges at them!"), SPAN_XENODANGER("You use your shield to bash [H] as you charge at them!"))
	H.KnockDown(BD.knockdown_amount)
	H.attack_alien(X, rand(X.melee_damage_lower, X.melee_damage_upper))

	var/facing = get_dir(X, H)
	var/turf/T = X.loc
	var/turf/temp = X.loc

	for(var/x in 0 to BD.fling_distance-1)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	H.throw_atom(T, BD.fling_distance, SPEED_VERY_FAST, X, TRUE)

/datum/action/xeno_action/activable/scissor_cut/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	// Determine whether or not we should daze here
	var/should_sslow = FALSE
	if(X.mutation_type != RAVAGER_NORMAL)
		return
	var/datum/behavior_delegate/ravager_base/BD = X.behavior_delegate
	if(BD.empower_targets >= BD.super_empower_threshold)
		should_sslow = TRUE

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(X, A)
	var/turf/T = X.loc
	var/turf/temp = X.loc
	var/list/telegraph_atom_list = list()

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
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(T, 0.25 SECONDS)

	// Extract our 'optimal' turf, if it exists
	if (target_turfs.len >= 2)
		X.animation_attack_on(target_turfs[target_turfs.len], 15)

	X.emote("roar")
	X.visible_message(SPAN_XENODANGER("[X] sweeps its claws through the area in front of it!"), SPAN_XENODANGER("You sweep your claws through the area in front of you!"))

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/turf/target_turf in target_turfs)
		for (var/mob/living/carbon/C in target_turf)
			if (C.stat == DEAD)
				continue

			if(X.can_not_harm(C))
				continue
			X.flick_attack_overlay(C, "slash")
			C.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			playsound(get_turf(C), "alien_claw_flesh", 30, TRUE)

			if(should_sslow)
				new /datum/effects/xeno_slow/superslow/(C, X, ttl = superslow_duration)

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

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		to_chat(X, SPAN_XENOWARNING("You must target a hostile!"))
		return

	if (get_dist(A, X) > max_distance)
		to_chat(X, SPAN_XENOWARNING("[A] is too far away!"))
		return

	var/mob/living/carbon/H = A

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
	new /datum/effects/xeno_slow(H, X, null, null, get_xeno_stun_duration(H, 20))
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
	X.throw_atom(get_step_towards(A, X), max_distance, SPEED_FAST, X)

	..()
	return


/datum/action/xeno_action/activable/clothesline/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		to_chat(X, SPAN_XENOWARNING("You must target a hostile!"))
		return

	if (!X.Adjacent(A))
		to_chat(X, SPAN_XENOWARNING("You must be adjacent to your target!"))
		return

	var/mob/living/carbon/H = A
	var/heal_amount = heal_per_rage
	var/fling_distance = fling_dist_base
	var/debilitate = TRUE // Do we apply neg. status effects to the target?

	if (H.mob_size >= MOB_SIZE_BIG)
		to_chat(X, SPAN_XENOWARNING("This creature is too massive to target"))
		return

	if (H.stat == DEAD)
		return

	// All strain-specific behavior
	if (X.mutation_type == RAVAGER_BERSERKER)
		var/datum/behavior_delegate/ravager_berserker/BD = X.behavior_delegate

		if (BD.rage >= 1)
			BD.decrement_rage()
		else
			to_chat(X, SPAN_XENOWARNING("You don't have enough rage to heal!"))
			heal_amount -= heal_per_rage
			debilitate = FALSE
			fling_distance--

	// Damage
	var/obj/limb/head/head = H.get_limb("head")
	if(ishuman(H) && head)
		H.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "head")
	else
		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE) // just for consistency

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

	H.throw_atom(T, fling_distance, SPEED_VERY_FAST, X, TRUE)

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
		if (BD.rage == 0)
			to_chat(X, SPAN_XENODANGER("You cannot eviscerate when you have 0 rage!"))
			return
		damage = damage_at_rage_levels[Clamp(BD.rage, 1, BD.max_rage)]
		range = range_at_rage_levels[Clamp(BD.rage, 1, BD.max_rage)]
		windup_reduction = windup_reduction_at_rage_levels[Clamp(BD.rage, 1, BD.max_rage)]
		BD.decrement_rage(BD.rage)

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

		for (var/mob/living/carbon/H in orange(X, range))
			if(!isXenoOrHuman(H) || X.can_not_harm(H))
				continue

			if (H.stat == DEAD)
				continue

			if(!check_clear_path_to_target(X, H))
				continue

			if (range > 1)
				X.visible_message(SPAN_XENOHIGHDANGER("[X] rips open the guts of [H]!"), SPAN_XENOHIGHDANGER("You rip open the guts of [H]!"))
				H.spawn_gibs()
				playsound(get_turf(H), 'sound/effects/gibbed.ogg', 30, 1)
				H.KnockDown(get_xeno_stun_duration(H, 1))
			else
				X.visible_message(SPAN_XENODANGER("[X] claws [H]!"), SPAN_XENODANGER("You claw [H]!"))
				playsound(get_turf(H), "alien_claw_flesh", 30, 1)

			H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, "chest", 20)

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
	addtimer(CALLBACK(src, .proc/remove_shield), shield_duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/spike_shield/action_cooldown_check()
	if (shield_active) // If active shield, return FALSE so that this action does not get carried out
		return FALSE
	else if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/Xenomorph/X = owner
		if (X.mutation_type == RAVAGER_HEDGEHOG)
			var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
			return BD.check_shards(shard_cost)
		return TRUE
	return FALSE

/datum/action/xeno_action/activable/spike_shield/proc/remove_shield()
	var/mob/living/carbon/Xenomorph/X = owner

	if (!shield_active)
		return

	shield_active = FALSE

	for (var/datum/xeno_shield/XS in X.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_HEDGE_RAV)
			XS.on_removal()
			qdel(XS)
			break

	to_chat(X, SPAN_XENODANGER("You feel your shard shield dissipate!"))
	X.overlay_shields()
	return

/datum/action/xeno_action/activable/rav_spikes/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc) || !X.check_state())
		return

	if (X.mutation_type == RAVAGER_HEDGEHOG)
		var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
		if (!BD.check_shards(shard_cost))
			to_chat(X, SPAN_DANGER("Not enough shards! You need [shard_cost - BD.shards] more!"))
			return
		BD.use_shards(shard_cost)

	X.visible_message(SPAN_XENOWARNING("The [X] fires their spikes at [A]!"), SPAN_XENOWARNING("You fire your spikes at [A]!"))

	var/turf/target = locate(A.x, A.y, A.z)
	var/obj/item/projectile/P = new /obj/item/projectile(X.loc, create_cause_data(initial(X.caste_type), X))

	var/datum/ammo/ammoDatum = GLOB.ammo_list[ammo_type]

	P.generate_bullet(ammoDatum)

	P.fire_at(target, X, X, ammoDatum.max_range, ammoDatum.shell_speed)
	playsound(X, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/rav_spikes/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/Xenomorph/X = owner
		if (X.mutation_type == RAVAGER_HEDGEHOG)
			var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
			return BD.check_shards(shard_cost)

		return TRUE
	else
		return FALSE

/datum/action/xeno_action/activable/spike_shed/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return
		
	if (!X.check_state())
		return

	if (X.mutation_type == RAVAGER_HEDGEHOG)
		var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
		if (!BD.check_shards(shard_cost))
			to_chat(X, SPAN_DANGER("Not enough shards! You need [shard_cost - BD.shards] more!"))
			return
		BD.use_shards(shard_cost)
		BD.lock_shards()

	X.visible_message(SPAN_XENOWARNING("The [X] sheds their spikes, firing them in all directions!"), SPAN_XENOWARNING("You shed your spikes, firing them in all directions!!"))
	X.spin_circle()
	create_shrapnel(get_turf(X), shrapnel_amount, null, null, ammo_type, create_cause_data(initial(X.caste_type), owner), TRUE)
	playsound(X, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/spike_shed/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/Xenomorph/X = owner
		if (X.mutation_type == RAVAGER_HEDGEHOG)
			var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
			return BD.check_shards(shard_cost)

		return TRUE
	else
		return FALSE
