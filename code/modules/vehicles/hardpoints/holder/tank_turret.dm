/obj/item/hardpoint/holder/tank_turret
	name = "\improper M34A2-A Multipurpose Turret"
	desc = "The centerpiece of the tank. Designed to support quick installation and deinstallation of various tank weapon modules. Has inbuilt flare launcher."

	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_turret_0"
	disp_icon = "tank"
	disp_icon_state = "tank_turret"
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')
	pixel_x = -48
	pixel_y = -48

	density = TRUE //come on, it's huge

	activatable = TRUE

	ammo = new /obj/item/ammo_magazine/hardpoint/turret_flare
	max_clips = 0
	use_muzzle_flash = FALSE

	w_class = SIZE_MASSIVE
	density = TRUE
	anchored = TRUE

	allowed_seat = VEHICLE_DRIVER

	slot = HDPT_TURRET

	// big beefy chonk of metal
	health = 450
	damage_multiplier = 0.1

	accepted_hardpoints = list(
		// primaries
		/obj/item/hardpoint/primary/flamer,
		/obj/item/hardpoint/primary/cannon,
		/obj/item/hardpoint/primary/minigun,
		/obj/item/hardpoint/primary/autocannon,
		// secondaries
		/obj/item/hardpoint/secondary/small_flamer,
		/obj/item/hardpoint/secondary/towlauncher,
		/obj/item/hardpoint/secondary/m56cupola,
		/obj/item/hardpoint/secondary/grenade_launcher,
		/obj/item/hardpoint/secondary/brute_launcher,
		/obj/item/hardpoint/secondary/united_americas_flag,
		/obj/item/hardpoint/iff_module/uscm,
		/obj/item/hardpoint/visual_sensors/uscm,
		/obj/item/hardpoint/turret_ring/uscm,
		/obj/item/hardpoint/air_filter/uscm,
	)

	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, -10),
		"2" = list(0, 10),
		"4" = list(-10, 0),
		"8" = list(10, 0)
	)

	/// Index into accepted_hardpoints, used by /mob/living/carbon/verb/cycle_tank_weapon_hardpoint() to track cycling progress.
	var/debug_cycle_index = 0

	var/datum/looping_sound/tank_turret/turret_soundloop

	/// TRUE while a forced turn (Warrior Punch/Oppressor Dislocate) hasn't been released yet.
	var/forced_wrench_active = FALSE
	/// Turret's real max_angular_velocity/angular_accel, snapshotted once before the first forced wrench.
	var/forced_wrench_original_velocity
	var/forced_wrench_original_accel

	/// External turn-rate buff/malus multiplier, applied on top of everything else in recalculate_turn_rate().
	var/turret_turn_rate_mult = 1

	scatter = 4
	fire_delay = 7.0 SECONDS

	uses_starshell_ammo = TRUE

/obj/item/hardpoint/holder/tank_turret/Initialize()
	. = ..()
	current_angle = dir2angle(dir)
	desired_angle = current_angle
	// Loaded shell-by-shell rather than swapped as a whole magazine.
	ammo_type = null
	turret_soundloop = new(src)

/obj/item/hardpoint/holder/tank_turret/Destroy()
	QDEL_NULL(turret_soundloop)
	return ..()

/obj/item/hardpoint/holder/tank_turret/on_rotation_started()
	// A hand-cranked turret has no motor running, so no traverse noise.
	if(owner?.has_vehicle_power() && turret_soundloop)
		turret_soundloop.mid_sounds = is_damaged() ? 'sound/vehicles/turretdamaged.ogg' : 'sound/vehicles/tankturret.ogg'
		turret_soundloop.start()
	set_turret_ring_power_draw(TURRET_RING_ROTATING_POWER_DRAW)

/obj/item/hardpoint/holder/tank_turret/on_rotation_stopped()
	turret_soundloop?.stop()
	set_turret_ring_power_draw(TURRET_RING_IDLE_POWER_DRAW)

/**
 * Whether the turret is damaged enough to grind (turretdamaged.ogg).
 */
/obj/item/hardpoint/holder/tank_turret/is_damaged()
	var/obj/item/hardpoint/turret_ring/ring = locate() in hardpoints
	return ring && (ring.get_integrity_percent() <= 50 || LAZYLEN(ring.wound_tiers))

/**
 * Updates the turret ring's power_draw. Rotating pulls more power than idling.
 * No-ops if there's no ring installed.
 *
 * Arguments:
 * * new_draw = Power draw (units/sec) to set the ring to.
 */
/obj/item/hardpoint/holder/tank_turret/set_turret_ring_power_draw(new_draw)
	if(!owner)
		return
	var/obj/item/hardpoint/turret_ring/ring = locate() in hardpoints
	if(ring)
		ring.power_draw = new_draw

/obj/item/hardpoint/holder/tank_turret/update_icon()
	var/broken = (health <= 0)
	icon_state = "tank_turret_[broken]"

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		overlays += damage_overlay

	..()

/obj/item/hardpoint/holder/tank_turret/get_icon_image(x_offset, y_offset, new_dir)
	var/icon_state_suffix = "0"
	if(health <= 0)
		icon_state_suffix = "1"

	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[icon_state_suffix]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		I.overlays += damage_overlay

	return I

/**
 * Layers a continuous visual tilt on top of the turret's (and every mounted weapon's) cardinal
 * sprite. The base dir still snaps every 90 degrees for sprite selection.
 */
/obj/item/hardpoint/holder/tank_turret/get_hardpoint_image()
	var/list/images = ..()

	var/tilt = angle_delta(current_angle, dir2angle(dir))

	var/image/turret_image = images[1]
	if(turret_image && tilt)
		turret_image.transform = build_tilt_matrix(tilt, interpolate_pivot(rotation_pivot, current_angle))

	var/image_index = 2
	for(var/obj/item/hardpoint/weapon in hardpoints)
		var/image/weapon_image = images[image_index]
		image_index++
		if(!weapon_image)
			continue

		// A self_gimballed weapon needs TWO nested rotations around TWO genuinely different pivots.
		// Collapsing these into one combined rotation only works if both
		// pivots happen to coincide, which isn't the case.
		if(weapon.self_gimballed)
			var/own_tilt = angle_delta(weapon.current_angle, current_angle)
			if(own_tilt || tilt)
				var/list/inner_pivot = weapon.interpolate_pivot(weapon.gimbal_pivot, current_angle) || weapon.interpolate_pivot(weapon.rotation_pivot, current_angle)
				var/list/outer_pivot = weapon.interpolate_pivot(weapon.rotation_pivot, current_angle)
				weapon_image.transform = weapon.build_nested_tilt_matrix(own_tilt, inner_pivot, tilt, outer_pivot)
		else if(tilt)
			weapon_image.transform = build_tilt_matrix(tilt, weapon.interpolate_pivot(weapon.rotation_pivot, current_angle))

	return images

// no picking this big beast up
/obj/item/hardpoint/holder/tank_turret/attack_hand(mob/user)
	return

/obj/item/hardpoint/holder/tank_turret/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(!PC.linked_powerloader)
			qdel(PC)
			return TRUE

		if(health < 1)
			visible_message(SPAN_WARNING("\The [src] disintegrates into useless pile of scrap under the damage it suffered!"))
			qdel(src)
			return TRUE

		PC.grab_object(user, src, "vehicle_module", 'sound/machines/hydraulics_2.ogg')
		update_icon()
		return TRUE
	..()

/obj/item/hardpoint/holder/tank_turret/get_tgui_info()
	var/list/data = list()

	data += list(list( // turret flare launcher data
		"name" = "M34A2-A Turret Flare Launcher",
		"health" = health <= 0 ? null : floor(get_integrity_percent()),
		"uses_ammo" = TRUE,
		"current_rounds" = ammo.current_rounds,
		"max_rounds"= ammo.max_rounds,
		"mags" = LAZYLEN(backup_clips),
		"max_mags" = max_clips,
		"wounds" = get_wound_tgui_data(),
	))

	for(var/obj/item/hardpoint/H in hardpoints)
		data += list(H.get_tgui_info())

	return data

/// Keeps dir/origins in sync with current_angle's quadrant, then refreshes the vehicle's sprite.
/obj/item/hardpoint/holder/tank_turret/apply_current_angle()
	var/target_cardinal = angle_to_cardinal(current_angle)
	if(target_cardinal != dir)
		rotate(turning_angle(dir, target_cardinal), override_gyro = TRUE, sync_angle = FALSE)
	owner.update_icon()

// See base proc's doc comment (hardpoint.dm) - drags any self_gimballed mounted weapon's angle along with this turret's own, so it keeps riding the turret's motion instead of holding a fixed absolute world angle.
/obj/item/hardpoint/holder/tank_turret/drag_self_gimballed_weapons(delta)
	if(!delta)
		return
	for(var/obj/item/hardpoint/mounted_weapon in hardpoints)
		if(!mounted_weapon.self_gimballed)
			continue
		// %% (not %) since angles are often fractional.
		mounted_weapon.current_angle = ((mounted_weapon.current_angle + delta) %% 360 + 360) %% 360
		mounted_weapon.desired_angle = ((mounted_weapon.desired_angle + delta) %% 360 + 360) %% 360

/**
 * Gates firing for a weapon mounted on this turret. current_angle must have caught up to within
 * FIRING_GATE_TOLERANCE of the angle from tthe weapon's own muzzle to target.
 */
/obj/item/hardpoint/holder/tank_turret/proc/in_turret_firing_arc(obj/item/hardpoint/weapon, atom/target)
	var/turf/muzzle_turf = weapon.get_origin_turf()
	var/turf/target_turf = get_turf(target)

	//same tile angle is undefined for Get_Angle, returning FALSE to match the legacy static-arc check
	if(muzzle_turf == target_turf)
		return FALSE

	var/target_angle = Get_Angle(muzzle_turf, target_turf)
	. = abs(angle_delta(target_angle, current_angle)) <= FIRING_GATE_TOLERANCE

/**
 * Recomputes max_angular_velocity from the mounted primary weapon's traverse_arc, or
 * TURRET_EMPTY_TRAVERSE_ARC if no primary is mounted.
 *
 * Scaled by the turret ring's condition, floored at TURRET_ABSOLUTE_MIN_ANGULAR_VELOCITY unless
 * the ring is destroyed or missing.
 *
 * Skipped while forced_wrench_active, so a forced turn's speed boost doesn't get overwritten mid-wrench.
 *
 * Finally scaled by turret_turn_rate_mult.
 */
/obj/item/hardpoint/holder/tank_turret/proc/recalculate_turn_rate(ignore_battery = FALSE)
	if(forced_wrench_active)
		return
	var/obj/item/hardpoint/primary/mounted_primary = locate(/obj/item/hardpoint/primary) in hardpoints
	var/arc = (mounted_primary && mounted_primary.traverse_arc) ? mounted_primary.traverse_arc : TURRET_EMPTY_TRAVERSE_ARC

	max_angular_velocity = max(TURRET_BASE_ANGULAR_VELOCITY * (arc / TURRET_ARC_NORMALIZATION), TURRET_MIN_ANGULAR_VELOCITY)

	var/ring_scale = get_turret_ring_scale(ignore_battery)
	max_angular_velocity *= ring_scale
	if(ring_scale > 0)
		max_angular_velocity = max(max_angular_velocity, TURRET_ABSOLUTE_MIN_ANGULAR_VELOCITY)
	max_angular_velocity *= turret_turn_rate_mult

/**
 * Turret ring integrity as a 0-1 scale, ramping down below WEAPON_DEGRADE_GRACE_THRESHOLD_PCT.
 * Further scaled by active turn_rate_mult wounds, or 0 if no ring is installed.
 *
 * Additionally scaled by TURRET_NO_POWER_TURN_RATE_FRACTION when the vehicle has no power.
 */
/obj/item/hardpoint/holder/tank_turret/proc/get_turret_ring_scale(ignore_battery = FALSE)
	if(!owner)
		return 0
	var/obj/item/hardpoint/turret_ring/ring = locate() in hardpoints
	if(!ring)
		return 0
	. = ring.get_own_health_scale() * ring.get_wound_effect_multiplier("turn_rate_mult")
	if(!owner.has_vehicle_power(ignore_battery))
		. *= TURRET_NO_POWER_TURN_RATE_FRACTION

/obj/item/hardpoint/holder/tank_turret/add_hardpoint(obj/item/hardpoint/new_hardpoint)
	. = ..()
	recalculate_turn_rate()

/obj/item/hardpoint/holder/tank_turret/remove_hardpoint(obj/item/hardpoint/removed_hardpoint, turf/uninstall_to)
	. = ..()
	recalculate_turn_rate()

/// Only the turret-specific extras live here now. Gyro-check and current_angle sync live in the base proc.
/obj/item/hardpoint/holder/tank_turret/rotate(deg, override_gyro = FALSE, sync_angle = TRUE)
	. = ..(deg, override_gyro, sync_angle)
	if(!.)
		return

	if(sync_angle)
		drag_self_gimballed_weapons(-deg)

	var/obj/vehicle/multitile/tank/C = owner
	var/obj/item/hardpoint/support/artillery_module/AM
	for(var/obj/item/hardpoint/support/artillery_module/A in C.hardpoints)
		AM = A
	if(AM)
		var/mob/living/user = C.seats[VEHICLE_GUNNER]
		if(user && (user in AM.optics_users))
			AM.apply_gunner_view(user)
