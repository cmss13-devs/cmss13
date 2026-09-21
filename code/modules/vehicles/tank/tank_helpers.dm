// --- Tail Stab hook

/**
 * Tank's version of handle_tail_stab(). Deals the same damage as a mob target would take.
 */
/obj/vehicle/multitile/tank/handle_tail_stab(mob/living/carbon/xenomorph/xeno, blunt_stab)
	var/damage = (xeno.melee_damage_upper + xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER) * TAILSTAB_MOB_DAMAGE_MULTIPLIER

	// Play our own attack flavor since we skip ability_act() entirely.
	xeno.animation_attack_on(src)
	xeno.flick_attack_overlay(src, blunt_stab ? "slam" : "tail")
	if(blunt_stab)
		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] swipes its tail into \the [src], bashing it!"), SPAN_XENOWARNING("We swipe our tail into [get_attack_desc(xeno)], bashing it!"))
		playsound(src, "punch", 50, TRUE)
	else
		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] skewers \the [src] with its razor sharp tail!"), SPAN_XENOWARNING("We skewer [get_attack_desc(xeno)] with our razor sharp tail!"))
		playsound(src, "alien_bite", 50, TRUE)

	// Mitigated like a normal claw slash, not a bypass hit.
	take_damage_type(damage, blunt_stab ? "blunt" : "slash", xeno)
	// Fire resource-gain hooks manually since we skip ability_act().
	if(xeno.behavior_delegate)
		xeno.behavior_delegate.melee_attack_modify_burn_damage(0, src)
		xeno.behavior_delegate.melee_attack_additional_effects_target(src)
		xeno.behavior_delegate.melee_attack_additional_effects_self()
	return TAILSTAB_COOLDOWN_NORMAL

// --- Weighted random-module acid exposure (Spray Acid, Despoiler's lingering acid puddles)

/**
 * Tank version of handle_acid_damage(). Hits a weighted random part instead of always Treads.
 */
/obj/vehicle/multitile/tank/proc/expose_to_weighted_acid(atom/A)
	var/damage = 0
	var/mob/attacker = null

	if(istype(A, /obj/effect/xenomorph/spray))
		var/obj/effect/xenomorph/spray/acid = A
		damage = acid.damage_amount
		if(acid.cause_data?.cause_name == "resin acid trap")
			damage = floor(damage / 3)
		attacker = acid.cause_data?.resolve_mob()

	else if(istype(A, /obj/effect/lingering_acid))
		var/obj/effect/lingering_acid/puddle = A
		damage = puddle.damage
		// No cause_data here, falls back to an unweighted pick.

	if(damage <= 0)
		return
	// ignore_aim = TRUE, a spray/puddle isn't a directed attack.
	apply_weighted_module_hit(damage, "acid", attacker, ignore_aim = TRUE)

// --- Boiler glob AOE exposure (acid/neurotoxin gas over the tank's footprint)

/**
 * Boiler acid gas sitting over the tank's footprint. Hits every part at once as a percent of its
 * own remaining health, unmitigated.
 *
 * Arguments:
 * * covered_fraction = Fraction of the tank's 9 tiles currently gassed, 0 to 1.
 * * attacker = Whoever's glob this is, if known.
 */
/obj/vehicle/multitile/tank/proc/apply_glob_acid_tick(covered_fraction, atom/attacker)
	if(covered_fraction <= 0)
		return

	apply_hull_damage(max(TANK_GLOB_ACID_FLOOR, health * TANK_GLOB_ACID_HEALTH_PCT / 100) * covered_fraction, "acid", attacker, unmitigated = TRUE)
	// get_hardpoints_copy() already flattens nested hardpoints into this list.
	for(var/obj/item/hardpoint/H in get_hardpoints_copy())
		if(H.health <= 0)
			continue
		H.take_damage(max(TANK_GLOB_ACID_FLOOR, H.health * TANK_GLOB_ACID_HEALTH_PCT / 100) * covered_fraction, "acid", attacker, unmitigated = TRUE)

/**
 * Neuro-glob counterpart to apply_glob_acid_tick(). Rolls a boosted chance at a gunked wound for
 * each neuro-foulable slot.
 *
 * Arguments:
 * * covered_fraction = Fraction of the tank's 9 tiles currently gassed with neurotoxin, 0 to 1.
 */
/obj/vehicle/multitile/tank/proc/apply_glob_neuro_tick(covered_fraction)
	if(covered_fraction <= 0)
		return
	var/chance_scale = covered_fraction * TANK_GLOB_NEURO_CHANCE_MULT * get_neuro_wound_chance_scale()
	for(var/slot in GLOB.neuro_foulable_slots)
		roll_neuro_wound_at_slot(slot, chance_scale)

/**
 * Reads the installed Armor hardpoint's neuro_wound_chance_mult.
 */
/obj/vehicle/multitile/tank/get_neuro_wound_chance_scale()
	var/obj/item/hardpoint/armor/installed_armor = get_hardpoint_by_slot(HDPT_ARMOR)
	return installed_armor ? installed_armor.neuro_wound_chance_mult : 1

/**
 * Shockwave damage to every hardpoint mounted on the turret. Unmitigated, ignores turret armor.
 *
 * Arguments:
 * * xeno = The mob to check for atop-a-tank status.
 * * damage = Damage to deal to every hardpoint mounted on the turret, if any.
 */
/proc/apply_atop_tank_turret_damage(mob/living/carbon/xenomorph/xeno, damage)
	var/turf/xeno_turf = get_turf(xeno)
	if(!xeno_turf)
		return
	var/obj/vehicle/multitile/vehicle = get_multitile_vehicle_at(xeno_turf)
	if(!vehicle)
		return
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
	if(!turret)
		return
	for(var/obj/item/hardpoint/mounted_weapon in turret.hardpoints)
		mounted_weapon.take_damage(damage, "blunt", xeno, unmitigated = TRUE)

// --- Forced turret wrench (shared by Warrior Punch and Praetorian Oppressor's Dislocate)

/**
 * Snap-turns a tank's turret away from the attacker's side. Guards against overlapping wrenches
 * corrupting the turret's real turn rate baseline.
 *
 * Arguments:
 * * attacker = Whoever is doing the wrenching.
 * * tank = The tank being wrenched.
 * * degrees = How far to turn the turret, away from `attacker`'s own side.
 *
 * Returns:
 * * TRUE if a turret was found and wrenched, FALSE otherwise.
 */
/proc/force_turret_wrench(mob/living/carbon/xenomorph/attacker, obj/vehicle/multitile/vehicle, degrees)
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
	if(!turret)
		return FALSE

	var/attacker_bearing = Get_Angle_Grounded(turret, attacker)
	var/angle_diff = angle_delta(attacker_bearing, turret.current_angle)
	var/turn_amount = (angle_diff >= 0) ? -degrees : degrees
	// %% not %, current_angle is often fractional.
	var/new_desired = ((turret.current_angle + turn_amount) %% 360 + 360) %% 360

	playsound(turret, "punch", 25, TRUE)
	playsound(turret, 'sound/vehicles/turretdamaged.ogg', 50, TRUE)
	play_wound_gain_effects(turret, WOUND_DAMTYPE_BRUTE, attacker)
	var/mob/living/gunner = vehicle.get_seat_mob(VEHICLE_GUNNER)
	if(gunner?.client)
		shake_camera(gunner, 2, 1)

	// Boosted turn rate, restored once the forced turn settles. Only the first of any overlapping
	// wrenches snapshots the real baseline.
	if(!turret.forced_wrench_active)
		turret.forced_wrench_original_velocity = turret.max_angular_velocity
		turret.forced_wrench_original_accel = turret.angular_accel
		turret.forced_wrench_active = TRUE
	turret.max_angular_velocity = WARRIOR_PUNCH_TURRET_ANGULAR_VELOCITY
	turret.angular_accel = WARRIOR_PUNCH_TURRET_ANGULAR_ACCEL

	turret.lock_rotation(TRUE)
	turret.desired_angle = new_desired
	turret.start_rotation_if_needed()
	INVOKE_ASYNC(turret, TYPE_PROC_REF(/obj/item/hardpoint/holder/tank_turret, release_forced_wrench_lock))
	return TRUE

/**
 * Shared aim-dependent damage resolution for Warrior Punch and Oppressor Dislocate.
 *
 * * Primary: forces the turn, unmitigated hit to Primary with a small bleed to Turret Ring.
 * * Turret: forces the turn, unmitigated hit to Turret Ring with a small bleed to mounted modules.
 * * Hull: no turn, guaranteed unmitigated hit to a random hull module.
 * * Anything else: no turn, bigger unmitigated hit to that module.
 *
 * Arguments:
 * * tank = The tank being hit.
 * * attacker = Whoever's aim to read.
 * * damage = Base damage.
 * * type = Damage type.
 * * ring_damage_mult = Extra multiplier for the Turret Ring case, defaults to 1.
 *
 * Returns:
 * * TRUE if the turret was forcibly turned, FALSE otherwise.
 */
/proc/resolve_turret_wrench_damage(obj/vehicle/multitile/vehicle, mob/living/carbon/xenomorph/attacker, damage, type, ring_damage_mult = 1)
	var/target_slot = vehicle.get_attack_target_slot(attacker)

	if(target_slot == HDPT_PRIMARY)
		// No turret holder to physically wrench (e.g. APC/ARC/van), so this just lands as plain damage.
		var/wrenched = force_turret_wrench(attacker, vehicle, WARRIOR_PUNCH_TURRET_TURN_DEGREES)
		var/obj/item/hardpoint/primary = vehicle.resolve_targeted_hardpoint(HDPT_PRIMARY)
		var/hit_damage = damage * GUARANTEED_EXTERNAL_HIT_DAMAGE_MULT
		primary?.take_damage(hit_damage, type, attacker, unmitigated = TRUE)
		if(wrenched)
			var/obj/item/hardpoint/ring = vehicle.get_hardpoint_by_slot(HDPT_TURRET_RING)
			ring?.deal_raw_damage(hit_damage * HARDPOINT_BLEED_THROUGH_FRACTION)
		return wrenched

	if(target_slot == HDPT_TURRET)
		var/wrenched = force_turret_wrench(attacker, vehicle, WARRIOR_PUNCH_TURRET_TURN_DEGREES)
		var/obj/item/hardpoint/ring = vehicle.get_hardpoint_by_slot(HDPT_TURRET_RING)
		var/hit_damage = damage * ring_damage_mult
		ring?.take_damage(hit_damage, type, attacker, unmitigated = TRUE)
		vehicle.bleed_external_modules(HDPT_TURRET, hit_damage)
		return wrenched

	if(target_slot == WOUND_SLOT_HULL)
		vehicle.force_internal_module_damage(WOUND_SLOT_HULL, damage, type, attacker)
	else
		var/obj/item/hardpoint/target_hardpoint = vehicle.resolve_targeted_hardpoint(target_slot)
		target_hardpoint?.take_damage(damage * GUARANTEED_EXTERNAL_HIT_DAMAGE_MULT, type, attacker, unmitigated = TRUE)
	return FALSE

/**
 * Restores the turret's turn rate once a forced turn settles. Safe to call more than once.
 */
/obj/item/hardpoint/holder/tank_turret/proc/release_forced_wrench_lock()
	var/safety = 0
	while(!QDELETED(src) && rotation_active && safety < 100)
		sleep(1)
		safety++
	if(QDELETED(src))
		return
	if(!forced_wrench_active)
		return
	max_angular_velocity = forced_wrench_original_velocity
	angular_accel = forced_wrench_original_accel
	forced_wrench_active = FALSE
	lock_rotation(FALSE)

/**
 * Elevates any barricade the tank just drove onto above its sprite and riders. Drops any barricade
 * the tank just left back to its normal layer.
 *
 * Only applies to a South facing barricade south of the tank's anchor tile.
 *
 * Arguments:
 * * old_locs = The list of turfs the tank occupied immediately before this move.
 */
/obj/vehicle/multitile/tank/update_covered_barricades(list/old_locs)
	for(var/turf/T as anything in old_locs)
		if(T in locs)
			continue
		for(var/obj/structure/barricade/B in T)
			B.covered_by_vehicle = FALSE
			B.update_icon()

	for(var/turf/T as anything in locs)
		if(T in old_locs)
			continue
		for(var/obj/structure/barricade/B in T)
			B.covered_by_vehicle = (B.dir == SOUTH) && (B.y < y)
			B.update_icon()
