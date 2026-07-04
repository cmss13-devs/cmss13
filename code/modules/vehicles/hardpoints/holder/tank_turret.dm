/obj/item/hardpoint/holder/tank_turret
	name = "\improper M34A2-A Multipurpose Turret"
	desc = "The centerpiece of the tank. Designed to support quick installation and deinstallation of various tank weapon modules. Has inbuilt smoke screen deployment system."

	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_turret_0"
	disp_icon = "tank"
	disp_icon_state = "tank_turret"
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')
	pixel_x = -48
	pixel_y = -48

	density = TRUE //come on, it's huge

	activatable = TRUE

	ammo = new /obj/item/ammo_magazine/hardpoint/turret_smoke
	max_clips = 2
	use_muzzle_flash = FALSE

	w_class = SIZE_MASSIVE
	density = TRUE
	anchored = TRUE

	allowed_seat = VEHICLE_DRIVER

	slot = HDPT_TURRET

	// big beefy chonk of metal
	health = 450
	damage_multiplier = 0.05

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
		/obj/item/hardpoint/secondary/grenade_launcher
	)

	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, -10),
		"2" = list(0, 10),
		"4" = list(-10, 0),
		"8" = list(10, 0)
	)

	var/gyro = FALSE

	// How long the windup is before the turret rotates
	var/rotation_windup = 15
	// Used during the windup
	var/rotating = FALSE

	scatter = 4
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	gun_firemode_list = list(
		GUN_FIREMODE_BURSTFIRE,
	)
	burst_amount = 2
	burst_delay = 1.0 SECONDS
	extra_delay = 13.0 SECONDS

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

	data += list(list( // turret smokescreen data
		"name" = "M34A2-A Turret Smoke Screen",
		"health" = health <= 0 ? null : floor(get_integrity_percent()),
		"uses_ammo" = TRUE,
		"current_rounds" = ammo.current_rounds / 2,
		"max_rounds"= ammo.max_rounds / 2,
		"mags" = LAZYLEN(backup_clips),
		"max_mags" = max_clips,
	))

	for(var/obj/item/hardpoint/H in hardpoints)
		data += list(H.get_tgui_info())

	return data

//gyro ON locks the turret in one direction, OFF will make turret turning when tank turns
/obj/item/hardpoint/holder/tank_turret/proc/toggle_gyro(mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src]'s stabilization systems are busted!"))
		return

	gyro = !gyro
	to_chat(user, SPAN_NOTICE("You toggle \the [src]'s gyroscopic stabilizer [gyro ? "ON" :"OFF"]."))

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
		mounted_weapon.current_angle = ((mounted_weapon.current_angle + delta) % 360 + 360) % 360
		mounted_weapon.desired_angle = ((mounted_weapon.desired_angle + delta) % 360 + 360) % 360

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
	return abs(angle_delta(target_angle, current_angle)) <= FIRING_GATE_TOLERANCE

// Recomputes max_angular_velocity from the median traverse_arc of currently-mounted weapons.
/obj/item/hardpoint/holder/tank_turret/proc/recalculate_turn_rate()
	var/list/arcs = list()
	for(var/obj/item/hardpoint/mounted_weapon in hardpoints)
		if(!mounted_weapon.traverse_arc)
			continue
		arcs += mounted_weapon.traverse_arc

	if(!length(arcs))
		max_angular_velocity = TURRET_DEFAULT_ANGULAR_VELOCITY
		return

	sortTim(arcs)
	var/weapon_count = length(arcs)
	var/median_arc = (weapon_count % 2) ? arcs[(weapon_count + 1) / 2] : (arcs[weapon_count / 2] + arcs[weapon_count / 2 + 1]) / 2

	max_angular_velocity = max(TURRET_BASE_ANGULAR_VELOCITY * (median_arc / TURRET_ARC_NORMALIZATION), TURRET_MIN_ANGULAR_VELOCITY)

/obj/item/hardpoint/holder/tank_turret/add_hardpoint(obj/item/hardpoint/new_hardpoint)
	. = ..()
	recalculate_turn_rate()

/obj/item/hardpoint/holder/tank_turret/remove_hardpoint(obj/item/hardpoint/removed_hardpoint, turf/uninstall_to)
	. = ..()
	recalculate_turn_rate()

/**
 * override_gyro - bypasses the gyro lock (used by mouse-driven aiming, which should always work).
 * sync_angle - whether to drag current_angle along by deg. TRUE for hull-turn cascades (rotate_hardpoints),
 * FALSE when apply_current_angle() calls this to snap dir to a quadrant it already accounted for.
 */
/obj/item/hardpoint/holder/tank_turret/rotate(deg, override_gyro = FALSE, sync_angle = TRUE)
	if(gyro && !override_gyro)
		return

	..(deg)

	if(sync_angle)
		// deg is in turn()'s rotational convention, which is the opposite
		// sign of dir2angle()'s north-clockwise convention that current_angle is tracked in
		// subtract, don't add, or current_angle drifts away from the direction dir actually turned.
		current_angle = ((current_angle - deg) % 360 + 360) % 360
		drag_self_gimballed_weapons(-deg)

	var/obj/vehicle/multitile/tank/C = owner
	var/obj/item/hardpoint/support/artillery_module/AM
	for(var/obj/item/hardpoint/support/artillery_module/A in C.hardpoints)
		AM = A
	if(AM && AM.is_active)
		var/mob/user = C.seats[VEHICLE_GUNNER]
		if(user && user.client)
			user = C.seats[VEHICLE_GUNNER]
			user.client.change_view(AM.view_buff, src)

			switch(dir)
				if(NORTH)
					user.client.set_pixel_x(0)
					user.client.set_pixel_y(AM.view_tile_offset * 32)
				if(SOUTH)
					user.client.set_pixel_x(0)
					user.client.set_pixel_y(-1 * AM.view_tile_offset * 32)
				if(EAST)
					user.client.set_pixel_x(AM.view_tile_offset * 32)
					user.client.set_pixel_y(0)
				if(WEST)
					user.client.set_pixel_x(-1 * AM.view_tile_offset * 32)
					user.client.set_pixel_y(0)

/obj/item/hardpoint/holder/tank_turret/try_fire(atom/target, mob/living/user, params)
	var/turf/L
	var/turf/R
	switch(owner.dir)
		if(NORTH)
			L = locate(owner.x - 2, owner.y + 4, owner.z)
			R = locate(owner.x + 2, owner.y + 4, owner.z)
		if(SOUTH)
			L = locate(owner.x + 2, owner.y - 4, owner.z)
			R = locate(owner.x - 2, owner.y - 4, owner.z)
		if(EAST)
			L = locate(owner.x + 4, owner.y + 2, owner.z)
			R = locate(owner.x + 4, owner.y - 2, owner.z)
		else
			L = locate(owner.x - 4, owner.y + 2, owner.z)
			R = locate(owner.x - 4, owner.y - 2, owner.z)

	if(shots_fired)
		target = R
	else
		target = L

	return ..()
