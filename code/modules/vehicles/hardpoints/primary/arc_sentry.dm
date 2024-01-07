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

	ammo = new /obj/item/ammo_magazine/hardpoint/arc_sentry
	max_clips = 2

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_double"

	muzzle_flash_pos = list(
		"1" = list(1, 0),
		"2" = list(1, -25),
		"4" = list(16, -4),
		"8" = list(-16, -4)
	)
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	gun_firemode_list = list(
		GUN_FIREMODE_BURSTFIRE,
	)
	burst_delay = 2
	burst_amount = 3

	/// Potential targets the turret can shoot at
	var/list/targets = list()
	/// The currently focused sentry target
	var/atom/movable/sentry_target = null
	/// The range that this turret can shoot at the furthest
	var/turret_range = 4
	/// What factions this sentry is aligned with
	var/faction_group = FACTION_LIST_MARINE

/obj/item/hardpoint/primary/arc_sentry/on_install(obj/vehicle/multitile/V)
	. = ..()
	RegisterSignal(owner, COMSIG_ARC_ANTENNA_TOGGLED, PROC_REF(toggle_processing))

/obj/item/hardpoint/primary/arc_sentry/on_uninstall(obj/vehicle/multitile/V)
	. = ..()
	UnregisterSignal(owner, COMSIG_ARC_ANTENNA_TOGGLED)
	START_PROCESSING(SSfastobj, src)

/obj/item/hardpoint/primary/arc_sentry/Destroy()
	STOP_PROCESSING(SSfastobj, src)
	sentry_target = null
	return ..()

/obj/item/hardpoint/primary/arc_sentry/proc/toggle_processing()
	SIGNAL_HANDLER
	if(!owner)
		return

	var/obj/vehicle/multitile/arc/vehicle = owner
	if(vehicle.antenna_deployed)
		START_PROCESSING(SSfastobj, src)

	else
		STOP_PROCESSING(SSfastobj, src)

/obj/item/hardpoint/primary/arc_sentry/process()
	for(var/mob/living/in_range_mob in range(turret_range, owner))
		targets |= in_range_mob

	if(!length(targets))
		return FALSE

	if(!sentry_target && length(targets))
		sentry_target = pick(targets)

	get_target(sentry_target)
	return TRUE

/obj/item/hardpoint/primary/arc_sentry/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/primary/arc_sentry/fire_wrapper(atom/target, mob/living/user, params)
	if(!target)
		target = src.target
	if(!target)
		return NONE

	return try_fire(target, null, params)

/obj/item/hardpoint/primary/arc_sentry/clear_los()
	var/turf/muzzle_turf = get_origin_turf()

	var/turf/checking_turf = muzzle_turf
	while(!(owner in checking_turf))
		// Dense turfs block LoS
		if(checking_turf.density)
			return FALSE

		// Ensure that we can pass over all objects in the turf
		for(var/obj/object in checking_turf)
			// Since vehicles are multitile the
			if(object == owner)
				continue

			// Non-dense objects are irrelevant
			if(!object.density)
				continue

			// Make sure we can pass object from all directions
			if(!HAS_FLAG(object.pass_flags.flags_can_pass_all, PASS_OVER_THROW_ITEM))
				if(!HAS_FLAG(object.flags_atom, ON_BORDER))
					return FALSE
				//If we're behind the object, check the behind pass flags
				else if(dir == object.dir && !HAS_FLAG(object.pass_flags.flags_can_pass_behind, PASS_OVER_THROW_ITEM))
					return FALSE
				//If we're in front, check front pass flags
				else if(dir == turn(object.dir, 180) && !HAS_FLAG(object.pass_flags.flags_can_pass_front, PASS_OVER_THROW_ITEM))
					return FALSE

		// Trace back towards the vehicle
		checking_turf = get_step(checking_turf, turn(dir,180))

	return TRUE

/obj/item/hardpoint/primary/arc_sentry/handle_fire(atom/target, mob/living/user, params)
	var/turf/origin_turf = get_origin_turf()

	var/obj/projectile/arc_sentry/new_bullet = generate_bullet(origin_turf)
	ammo.current_rounds--
	SEND_SIGNAL(new_bullet, COMSIG_BULLET_USER_EFFECTS, user)
	new_bullet.runtime_iff_group = faction_group // Technically shouldn't be directly modifying this, but sue me

	// turf-targeted projectiles are fired without scatter, because proc would raytrace them further away
	var/ammo_flags = new_bullet.ammo.flags_ammo_behavior | new_bullet.projectile_override_flags
	if(!HAS_FLAG(ammo_flags, AMMO_HITS_TARGET_TURF) && !HAS_FLAG(ammo_flags, AMMO_EXPLOSIVE)) //AMMO_EXPLOSIVE is also a turf-targeted projectile
		new_bullet.scatter = scatter
		target = simulate_scatter(new_bullet, target, origin_turf, get_turf(target), user)

	INVOKE_ASYNC(new_bullet, TYPE_PROC_REF(/obj/projectile, fire_at), target, user, src, new_bullet.ammo.max_range, new_bullet.ammo.shell_speed)
	new_bullet = null

	shots_fired++
	play_firing_sounds()
	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(origin_turf, target))

	set_fire_cooldown(gun_firemode)
	return AUTOFIRE_CONTINUE


/obj/item/hardpoint/primary/arc_sentry/generate_bullet(turf/origin_turf)
	var/obj/projectile/arc_sentry/new_proj = new(origin_turf, create_cause_data(initial(name), owner))
	new_proj.generate_bullet(new ammo.default_ammo)
	new_proj.permutated += owner
	// Apply bullet traits from gun
	for(var/entry in traits_to_give)
		var/list/trait_list
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			trait_list = traits_to_give[entry].Copy()
		else
			// Prepend the bullet trait to the list
			trait_list = list(entry) + traits_to_give[entry]
		new_proj.apply_bullet_trait(trait_list)
	return new_proj

/obj/item/hardpoint/primary/arc_sentry/start_fire(datum/source, atom/object, turf/location, control, params)
	if(istype(object, /atom/movable/screen))
		return

	if(QDELETED(object))
		return

	if(!auto_firing && !burst_firing && !COOLDOWN_FINISHED(src, fire_cooldown))
		if(max(fire_delay, burst_delay + extra_delay) >= 2.0 SECONDS) //filter out guns with high firerate to prevent message spam.
			to_chat(source, SPAN_WARNING("You need to wait [SPAN_HELPFUL(COOLDOWN_SECONDSLEFT(src, fire_cooldown))] seconds before [name] can be used again."))
		return

	set_target(object)

	if(gun_firemode == GUN_FIREMODE_SEMIAUTO)
		var/fire_return = try_fire(object, source, params)
		//end-of-fire, show ammo (if changed)
		if(fire_return == AUTOFIRE_CONTINUE)
			reset_fire()
			display_ammo(source)
	else
		SEND_SIGNAL(src, COMSIG_GUN_FIRE)

/obj/item/hardpoint/primary/arc_sentry/proc/get_target(atom/movable/new_target)
	if(!islist(targets))
		return
	if(!targets.Find(new_target))
		targets.Add(new_target)

	if(!length(targets))
		return

	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()

	for(var/atom/movable/movable as anything in targets) // orange allows sentry to fire through gas and darkness
		if(isliving(movable))
			var/mob/living/living_mob = movable
			if(living_mob.stat & DEAD)
				if(movable == sentry_target)
					sentry_target = null
				targets.Remove(movable)
				continue

			if(living_mob.get_target_lock(faction_group) || living_mob.invisibility || HAS_TRAIT(living_mob, TRAIT_ABILITY_BURROWED))
				if(living_mob == sentry_target)
					sentry_target = null
				targets.Remove(living_mob)
				continue

		var/list/turf/path = getline2(get_turf(src), movable, include_from_atom = FALSE)
		if(!length(path)|| get_dist(get_turf(src), movable) > turret_range)
			if(movable == sentry_target)
				sentry_target = null
			targets.Remove(movable)
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

			if(locate(/obj/effect/particle_effect/smoke) in tile)
				blocked = TRUE
				break

		if(blocked)
			if(movable == sentry_target)
				sentry_target = null
			targets.Remove(movable)
			continue

		if(isliving(movable))
			var/mob/living/living_mob = movable
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
		return

	start_fire(object = sentry_target)


/obj/projectile/arc_sentry/check_canhit(turf/current_turf, turf/next_turf)
	var/proj_dir = get_dir(current_turf, next_turf)
	if(!(firer in current_turf) && !(firer in next_turf) && (proj_dir & (proj_dir - 1)) && !current_turf.Adjacent(next_turf))
		ammo.on_hit_turf(current_turf, src)
		current_turf.bullet_act(src)
		return TRUE

	// Check for hits that would occur when moving to turf, such as a blocking cade
	if(scan_a_turf(next_turf, proj_dir))
		return TRUE

	return FALSE

