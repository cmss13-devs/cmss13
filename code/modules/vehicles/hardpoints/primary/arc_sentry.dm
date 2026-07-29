// APC cannons
/obj/item/hardpoint/primary/arc_sentry
	name = "\improper RE700 Rotary Cannon"
	desc = "A primary two-barrel cannon for the ARC that shoots 12.7mm IFF-compatible rounds."
	icon = 'icons/obj/vehicles/hardpoints/arc.dmi'

	icon_state = "autocannon"
	disp_icon = "arc"
	disp_icon_state = "autocannon"
	activation_sounds = list('sound/weapons/gun_m60.ogg')

	damage_multiplier = 0.1
	health = 125

	origins = list(0, 0)
	traverse_arc = 360

	px_offsets = list(
		"1" = list(0, -5),
		"2" = list(0, 9),
		"4" = list(-10, 19),
		"8" = list(10, 18)
	)

	ammo = new /obj/item/ammo_magazine/hardpoint/arc_sentry
	max_clips = 2

	use_muzzle_flash = FALSE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_double"

	muzzle_flash_pos = list(
		"1" = list(1, 4),
		"2" = list(1, -29),
		"4" = list(16, 3),
		"8" = list(-16, 3)
	)
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.2 SECONDS

	/// Potential targets the turret can shoot at
	var/list/targets = list()
	/// The currently focused sentry target
	var/atom/movable/sentry_target = null
	/// The range that this turret can shoot at the furthest
	var/turret_range = 5
	/// TRUE while a recenter_turret() callback is pending, so losing targets repeatedly doesn't keep pushing the 5-second wait back out.
	var/recenter_scheduled = FALSE
	/// Width, in degrees, of the arc around the target's true bearing this turret must be facing within before it'll open fire.
	var/firing_arc_width = 45

/// This vehicle's installed IFF module, if any.
/obj/item/hardpoint/primary/arc_sentry/proc/get_iff_module()
	if(!owner)
		return null
	return locate(/obj/item/hardpoint/iff_module) in owner.get_hardpoints_copy()

/// The faction this turret currently protects from friendly fire, read live from the installed IFF module. Null if none is installed and working.
/obj/item/hardpoint/primary/arc_sentry/proc/get_effective_faction_group()
	var/obj/item/hardpoint/iff_module/iff = get_iff_module()
	if(!iff || !iff.is_functional())
		return null
	return iff.set_faction

/obj/item/hardpoint/primary/arc_sentry/recalculate_own_turn_rate()
	. = ..()
	max_angular_velocity *= 2

/obj/item/hardpoint/primary/arc_sentry/on_install(obj/vehicle/multitile/vehicle)
	. = ..()
	RegisterSignal(owner, COMSIG_ARC_ANTENNA_TOGGLED, PROC_REF(toggle_processing))
	toggle_processing() // We can't know that the antenna is in the same position as when the gun was removed

/obj/item/hardpoint/primary/arc_sentry/on_uninstall(obj/vehicle/multitile/vehicle)
	. = ..()
	UnregisterSignal(owner, COMSIG_ARC_ANTENNA_TOGGLED)
	SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
	STOP_PROCESSING(SSfastobj, src)

/obj/item/hardpoint/primary/arc_sentry/Destroy()
	SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
	STOP_PROCESSING(SSfastobj, src)
	sentry_target = null
	return ..()

/obj/item/hardpoint/primary/arc_sentry/proc/toggle_processing()
	SIGNAL_HANDLER
	if(!owner)
		return

	var/obj/vehicle/multitile/arc/vehicle = owner
	if(vehicle.antenna_deployed)
		// Hands aiming back to the auto-targeting loop.
		turret_safety_on = FALSE
		recalculate_gyro()
		aim_locked = FALSE
		START_PROCESSING(SSfastobj, src)

	else
		// Stops firing immediately, since process() won't notice the antenna retracting on its own.
		// Also locks the turret to hull facing
		SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
		turret_safety_on = TRUE
		recalculate_gyro()
		aim_locked = TRUE
		desired_angle = dir2angle(owner.dir)
		start_rotation_if_needed()
		STOP_PROCESSING(SSfastobj, src)

/obj/item/hardpoint/primary/arc_sentry/process()
	// No working IFF module means no faction to protect, so refuse to engage at all.
	if(!get_effective_faction_group())
		handle_no_target()
		return FALSE

	for(var/mob/living/in_range_mob in range(turret_range, owner))
		targets |= in_range_mob

	if(!length(targets))
		handle_no_target()
		return FALSE

	if(!sentry_target)
		sentry_target = pick(targets)

	get_target(sentry_target)
	return TRUE

// Stops the turret from firing once it has no target.
/obj/item/hardpoint/primary/arc_sentry/proc/handle_no_target()
	SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
	if(recenter_scheduled)
		return
	recenter_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(recenter_turret)), 5 SECONDS) // Makes it turn back to face the hull.

/// Turns the turret back to face the hull's own direction, unless a target's been reacquired since this was scheduled.
/obj/item/hardpoint/primary/arc_sentry/proc/recenter_turret()
	recenter_scheduled = FALSE
	if(sentry_target || !owner)
		return
	desired_angle = dir2angle(owner.dir)
	// Already facing the hull, no actual turn (and no rotation sound) needed.
	if(abs(angle_delta(desired_angle, current_angle)) < ROTATION_SETTLE_TOLERANCE)
		return
	start_rotation_if_needed()

/**
 * Tags each fired bullet with the IFF module's current faction, read fresh at the moment of firing.
 */
/obj/item/hardpoint/primary/arc_sentry/generate_bullet(mob/user, turf/origin_turf)
	. = ..()
	var/obj/projectile/fired_bullet = .
	if(!fired_bullet)
		return
	fired_bullet.runtime_iff_group = get_effective_faction_group()

/obj/item/hardpoint/primary/arc_sentry/fire_wrapper(atom/target, mob/living/user, params)
	if(!target)
		target = src.target
	if(!target)
		return NONE

	return try_fire(target, null, params)

/obj/item/hardpoint/primary/arc_sentry/start_fire(datum/source, atom/object, turf/location, control, params)
	if(QDELETED(object))
		return

	// Keeps target synced even mid-cooldown, so full-auto fire doesn't go stale on a dead target.
	set_target(object)

	if(!COOLDOWN_FINISHED(src, fire_cooldown))
		return
	SEND_SIGNAL(src, COMSIG_GUN_FIRE)

/obj/item/hardpoint/primary/arc_sentry/proc/get_target(atom/movable/new_target)
	if(QDELETED(new_target))
		sentry_target = null
		handle_no_target()
		return

	if(!targets.Find(new_target))
		targets.Add(new_target)

	if(!length(targets))
		handle_no_target()
		return

	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()

	for(var/mob/living/living_mob as anything in targets) // orange allows sentry to fire through gas and darkness
		if(living_mob.stat == DEAD)
			purge_target(living_mob)
			continue

		if(living_mob.get_target_lock(get_effective_faction_group()) || living_mob.invisibility || HAS_TRAIT(living_mob, TRAIT_ABILITY_BURROWED))
			purge_target(living_mob)
			continue

		var/list/turf/path = get_line(get_turf(src), living_mob)
		if(!length(path) || get_dist(get_turf(src), living_mob) > turret_range)
			purge_target(living_mob)
			continue

		var/blocked = FALSE
		for(var/turf/tile as anything in path)
			if(tile.density || tile.opacity)
				blocked = TRUE
				break

			for(var/obj/structure/struct in tile)
				if(struct.opacity)
					blocked = TRUE
					break

			for(var/obj/vehicle/multitile/vehicle in tile)
				if(vehicle == owner) // Some of the tiles will inevitably be the ARC itself
					continue
				blocked = TRUE
				break

			for( var/obj/effect/particle_effect/smoke/smoke in tile)
				if(!smoke.obscuring)
					continue
				blocked = TRUE
				break

		if(blocked)
			purge_target(living_mob)
			continue

		if(living_mob.stat & UNCONSCIOUS)
			unconscious_targets += living_mob
		else
			conscious_targets += living_mob

	if((sentry_target in conscious_targets) || (sentry_target in unconscious_targets))
		sentry_target = sentry_target

	else if(length(conscious_targets))
		sentry_target = pick(conscious_targets)

	else if(length(unconscious_targets))
		sentry_target = pick(unconscious_targets)

	if(!sentry_target) //No targets, don't bother firing
		handle_no_target()
		return

	recenter_scheduled = FALSE
	update_desired_angle(sentry_target, null, null)

	if(abs(angle_delta(desired_angle, current_angle)) > firing_arc_width * 0.5)
		SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
		return

	start_fire(object = sentry_target)

/obj/item/hardpoint/primary/arc_sentry/proc/purge_target(mob/target)
	if(target == sentry_target)
		sentry_target = null
	targets.Remove(target)

/obj/item/hardpoint/primary/arc_sentry/can_be_removed(mob/remover)
	var/obj/vehicle/multitile/arc/arc_owner = owner
	if(!istype(arc_owner))
		return TRUE

	if(arc_owner.antenna_deployed)
		to_chat(remover, SPAN_WARNING("[src] cannot be removed from [owner] while its antenna is deployed."))
		return FALSE

	return ..()
