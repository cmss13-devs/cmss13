// APC cannons
/obj/item/hardpoint/primary/arc_sentry
	name = "\improper RE700 Rotary Cannon"
	desc = "A primary two-barrel cannon for the APC that shoots 20mm IFF-compatible rounds."
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "dual_cannon"
	disp_icon = "apc"
	disp_icon_state = "dualcannon"
	activation_sounds = list('sound/weapons/gun_m60.ogg')

	damage_multiplier = 0.1
	health = 125

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/arc_sentry
	max_clips = 2

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_double"

	muzzle_flash_pos = list(
		"1" = list(11, -29),
		"2" = list(-11, 10),
		"4" = list(-14, 9),
		"8" = list(14, 9)
	)
	/// Potential targets the turret can shoot at
	var/list/targets = list()
	/// The currently focused target
	var/atom/movable/target = null
	/// The range that this turret can shoot at the furthest
	var/turret_range = 4
	/// What factions this sentry is aligned with
	var/faction_group = FACTION_LIST_MARINE
	/// How many rounds will fire in a burst
	var/burst_amount = 3

/obj/item/hardpoint/primary/arc_sentry/on_install(obj/vehicle/multitile/V)
	. = ..()
	RegisterSignal(owner, COMSIG_ARC_ANTENNA_TOGGLED, PROC_REF(toggle_processing))

/obj/item/hardpoint/primary/arc_sentry/on_uninstall(obj/vehicle/multitile/V)
	. = ..()
	UnregisterSignal(owner, COMSIG_ARC_ANTENNA_TOGGLED)
	fast_machines -= src

/obj/item/hardpoint/primary/arc_sentry/Destroy()
	fast_machines -= src
	target = null
	return ..()

/obj/item/hardpoint/primary/arc_sentry/proc/toggle_processing()
	SIGNAL_HANDLER
	if(!owner)
		return

	var/obj/vehicle/multitile/arc/vehicle = owner
	if(vehicle.antenna_deployed)
		fast_machines |= src

	else
		fast_machines -= src

/obj/item/hardpoint/primary/arc_sentry/process()
	for(var/mob/living/in_range_mob in range(turret_range, owner))
		targets |= in_range_mob

	if(!length(targets))
		return FALSE

	if(!target && length(targets))
		target = pick(targets)

	get_target(target)
	return TRUE

/obj/item/hardpoint/primary/arc_sentry/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/primary/arc_sentry/fire(atom/movable/target)
	set waitfor = FALSE
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

	for(var/bullets_fired in 1 to burst_amount)
		var/atom/tile = target
		if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
			tile = get_step(get_turf(target), pick(cardinal))
		if(LAZYLEN(activation_sounds))
			playsound(src, pick(activation_sounds), 60, 1)
		fire_projectile(tile)
		if(ammo.current_rounds <= 0)
			break
		if(bullets_fired < burst_amount)
			sleep(1)

/obj/item/hardpoint/primary/arc_sentry/fire_projectile(atom/movable/target)
	set waitfor = FALSE

	var/turf/origin_turf = get_turf(src)
	//origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z) //zonenote

	var/obj/item/projectile/arc_sentry/new_bullet = generate_bullet(origin_turf)
	new_bullet.runtime_iff_group = faction_group // Technically shouldn't be directly modifying this, but sue me
	new_bullet.fire_at(target, owner, origin_turf, new_bullet.ammo.max_range, new_bullet.ammo.shell_speed) //zonenote origin

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(origin_turf, target))

	ammo.current_rounds--

/obj/item/hardpoint/primary/arc_sentry/generate_bullet(turf/origin_turf)
	var/obj/item/projectile/arc_sentry/new_proj = new(origin_turf, create_cause_data(initial(name), owner))
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
				if(movable == target)
					target = null
				targets.Remove(movable)
				continue

			if(living_mob.get_target_lock(faction_group) || living_mob.invisibility || HAS_TRAIT(living_mob, TRAIT_ABILITY_BURROWED))
				if(living_mob == target)
					target = null
				targets.Remove(living_mob)
				continue

		var/list/turf/path = getline2(get_turf(src), movable, include_from_atom = FALSE)
		if(!length(path)|| get_dist(get_turf(src), movable) > turret_range)
			if(movable == target)
				target = null
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

			for(var/obj/vehicle/multitile/vehicle in tile) //zonenote
				if(vehicle == owner) // Some of the tiles will inevitably be the ARC itself
					continue
				blocked = TRUE
				break

			if(locate(/obj/effect/particle_effect/smoke) in tile)
				blocked = TRUE
				break

		if(blocked)
			if(movable == target)
				target = null
			targets.Remove(movable)
			continue

		if(isliving(movable))
			var/mob/living/living_mob = movable
			if(living_mob.stat & UNCONSCIOUS)
				unconscious_targets += living_mob
			else
				conscious_targets += living_mob

	if(length(conscious_targets))
		target = pick(conscious_targets)

	else if(length(unconscious_targets))
		target = pick(unconscious_targets)

	if(!target) //No targets, don't bother firing
		return

	fire(target)


/obj/item/projectile/arc_sentry/check_canhit(turf/current_turf, turf/next_turf)
	var/proj_dir = get_dir(current_turf, next_turf)
	if(!(firer in current_turf) && !(firer in next_turf) && (proj_dir & (proj_dir - 1)) && !current_turf.Adjacent(next_turf))
		ammo.on_hit_turf(current_turf, src)
		current_turf.bullet_act(src)
		return TRUE

	// Check for hits that would occur when moving to turf, such as a blocking cade
	if(scan_a_turf(next_turf, proj_dir))
		return TRUE

	return FALSE

