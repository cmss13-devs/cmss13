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
		"1" = list(1, 4),
		"2" = list(1, -29),
		"4" = list(16, 3),
		"8" = list(-16, 3)
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
	var/turret_range = 5
	/// What factions this sentry is aligned with
	var/faction_group = FACTION_LIST_MARINE

/obj/item/hardpoint/primary/arc_sentry/on_install(obj/vehicle/multitile/vehicle)
	. = ..()
	RegisterSignal(owner, COMSIG_ARC_ANTENNA_TOGGLED, PROC_REF(toggle_processing))
	toggle_processing() // We can't know that the antenna is in the same position as when the gun was removed

/obj/item/hardpoint/primary/arc_sentry/on_uninstall(obj/vehicle/multitile/vehicle)
	. = ..()
	UnregisterSignal(owner, COMSIG_ARC_ANTENNA_TOGGLED)
	STOP_PROCESSING(SSfastobj, src)

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

	if(!sentry_target)
		sentry_target = pick(targets)

	get_target(sentry_target)
	return TRUE

/obj/item/hardpoint/primary/arc_sentry/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff, faction_group)
	))

/obj/item/hardpoint/primary/arc_sentry/fire_wrapper(atom/target, mob/living/user, params)
	if(!target)
		target = src.target
	if(!target)
		return NONE

	return try_fire(target, null, params)

/obj/item/hardpoint/primary/arc_sentry/start_fire(datum/source, atom/object, turf/location, control, params)
	if(QDELETED(object))
		return
	if(!COOLDOWN_FINISHED(src, fire_cooldown))
		return

	set_target(object)
	SEND_SIGNAL(src, COMSIG_GUN_FIRE)

/obj/item/hardpoint/primary/arc_sentry/proc/get_target(atom/movable/new_target)
	if(QDELETED(new_target))
		sentry_target = null
		return

	if(!targets.Find(new_target))
		targets.Add(new_target)

	if(!length(targets))
		return

	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()

	for(var/mob/living/living_mob as anything in targets) // orange allows sentry to fire through gas and darkness
		if(living_mob.stat == DEAD)
			purge_target(living_mob)
			continue

		if(living_mob.get_target_lock(faction_group) || living_mob.invisibility || HAS_TRAIT(living_mob, TRAIT_ABILITY_BURROWED))
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

			if(locate(/obj/effect/particle_effect/smoke) in tile)
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
