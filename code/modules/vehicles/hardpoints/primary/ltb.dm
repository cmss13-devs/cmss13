/// Low end of the LTB's aiming laser opacity ramp
#define LTB_LASER_MIN_ALPHA 50

/// Multiply-tint applied to the "dark" phase of the flicker
#define LTB_LASER_DARK_TINT "#787878"

/obj/item/hardpoint/primary/cannon
	name = "\improper LTB Cannon"
	desc = "A primary cannon for tanks that shoots explosive rounds."

	icon_state = "ltb_cannon"
	disp_icon = "tank"
	disp_icon_state = "ltb_cannon"
	activation_sounds = list('sound/weapons/vehicles/cannon_fire1.ogg', 'sound/weapons/vehicles/cannon_fire2.ogg')

	health = 500
	traverse_arc = 60

	ammo = new /obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell
	max_clips = 1

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 0),
		"8" = list(-32, 0)
	)
	rotation_pivot = list(
		"1" = list(0, -21),
		"2" = list(0, 32),
		"4" = list(-32, 0),
		"8" = list(32, 0)
	)

	muzzle_flash_pos = list(
		"1" = list(0, 59),
		"2" = list(0, -74),
		"4" = list(89, -4),
		"8" = list(-89, -4)
	)

	scatter = 2
	fire_delay = 20.0 SECONDS
	/// How long the lock-on charge takes before firing is allowed.
	var/f_aiming_time = 4 SECONDS
	/// Stashed for generate_bullet() below, which doesn't receive target directly.
	var/atom/homing_target

	var/image/lockon_icon
	var/image/lockon_direction_icon
	var/datum/beam/laser_beam
	var/obj/effect/beam_anchor/anchor
	/// Incrementted every start_aim_visuals(), lets a stale cycle_laser_color() invocation from a
	/// previous charge recognize it's outdated and stop, even if a new charge starts before it wakes
	/// up from its own sleep() and notices laser beam has already been replaced. fixes a very annoying bug where more than one reticle can appear.
	var/aim_generation = 0
	/// world.time the current charge started - used to ramp the beam's opacity up gradually across the whole charge
	var/charge_start_time = 0

/**
 * Same lock-on/tracking charge as the secondary BRUTE launcher. Targets any living mob, blocked by the same things Aimed Shot is
 * (dense+opaque turfs, opaque objects, obscuring smoke...
 * The fired round homes in on the target same as Aimed Shot's own /datum/component/homing_projectile.
 */
/obj/item/hardpoint/primary/cannon/handle_fire(atom/target, mob/living/user, params)
	if(charging)
		return NONE

	if(!isliving(target))
		to_chat(user, SPAN_WARNING("Invalid target!"))
		return NONE

	var/mob/living/living_target = target
	if(living_target.is_dead())
		to_chat(user, SPAN_WARNING("Invalid target!"))
		return NONE

	if(check_shot_is_blocked(target))
		to_chat(user, SPAN_WARNING("Target obscured!"))
		return NONE

	if(!track_and_charge(target, user, f_aiming_time))
		return NONE

	// Re-validate once more after the charge
	if(QDELETED(target) || living_target.is_dead() || check_shot_is_blocked(target))
		to_chat(user, SPAN_WARNING("You lose the shot!"))
		return NONE

	homing_target = target
	. = ..()
	homing_target = null
	return .

/obj/item/hardpoint/primary/cannon/generate_bullet(mob/user, turf/origin_turf)
	var/obj/projectile/fired_projectile = ..()
	if(homing_target)
		fired_projectile.AddComponent(/datum/component/homing_projectile, homing_target, user)
	return fired_projectile

/obj/item/hardpoint/primary/cannon/proc/check_shot_is_blocked(atom/target)
	var/turf/origin_turf = get_origin_turf()
	var/turf/target_turf = get_turf(target)
	var/list/turf/path = get_line(origin_turf, target_turf, include_start_atom = FALSE)
	if(!length(path))
		return TRUE

	for(var/turf/path_turf in path)
		if(path_turf.density && path_turf.opacity)
			return TRUE

		for(var/obj/path_obj in path_turf)
			if(path_obj.get_projectile_hit_boolean(null) && path_obj.opacity)
				return TRUE

		for(var/obj/effect/particle_effect/smoke/smoke in path_turf)
			if(smoke.obscuring)
				return TRUE

	return FALSE

/obj/item/hardpoint/primary/cannon/start_aim_visuals(atom/target, mob/living/user)
	anchor = new(get_origin_turf())
	charge_start_time = world.time
	build_lockon_icons(target)
	apply_beam_visuals(target, FALSE)
	aim_generation++
	INVOKE_ASYNC(src, PROC_REF(cycle_laser_color), target, aim_generation)

//Builds the two reticle overlay images once for the whole charge
/obj/item/hardpoint/primary/cannon/proc/build_lockon_icons(atom/target)
	var/turf/origin_turf = get_origin_turf()

	var/mob/living_target = target
	var/x_offset = -living_target.pixel_x + living_target.base_pixel_x
	var/y_offset = (living_target.icon_size - world.icon_size) * 0.5 - living_target.pixel_y + living_target.base_pixel_y

	lockon_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "sniper_lockon_intense")
	lockon_icon.pixel_x = x_offset
	lockon_icon.pixel_y = y_offset
	target.overlays += lockon_icon

	lockon_direction_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "sniper_lockon_intense_direction", dir = get_cardinal_dir(target, origin_turf))
	lockon_direction_icon.pixel_x = x_offset
	lockon_direction_icon.pixel_y = y_offset
	target.overlays += lockon_direction_icon

/**
 * Recolors the (already-built) reticle icons and rebuilds the beam using the AMR's focused-fire beam,
 * the flicker alternates between this sprite's native blue and a darker shade of the same blue.
 *
 * Also refreshes the direction arrow's facing (the target/tank can have moved since the last cycle)
 * and ramps the beam's opacity based on total elapsed charge time (charge_start_time).
 *
 * The intent, with the flickering, and the blue color of the AMR focused shot, is to make it clear for xenos that
 * they are being targeted by something dangerous.
 */
/obj/item/hardpoint/primary/cannon/proc/apply_beam_visuals(atom/target, use_dark_look)
	var/turf/origin_turf = get_origin_turf()

	lockon_icon.color = use_dark_look ? LTB_LASER_DARK_TINT : null
	lockon_direction_icon.color = use_dark_look ? LTB_LASER_DARK_TINT : null
	lockon_direction_icon.dir = get_cardinal_dir(target, origin_turf)

	QDEL_NULL(laser_beam)
	laser_beam = anchor.beam(target, "laser_beam_intense", 'icons/effects/beam.dmi', (f_aiming_time + 1 SECONDS), beam_type = /obj/effect/ebeam/laser/intense/tank_mounted)
	if(use_dark_look)
		laser_beam.visuals.color = LTB_LASER_DARK_TINT

	var/elapsed = world.time - charge_start_time
	var/current_progress = clamp(elapsed / f_aiming_time, 0, 1)
	var/next_progress = clamp((elapsed + 5) / f_aiming_time, 0, 1)
	laser_beam.visuals.alpha = LTB_LASER_MIN_ALPHA + (255 - LTB_LASER_MIN_ALPHA) * current_progress
	animate(laser_beam.visuals, alpha = LTB_LASER_MIN_ALPHA + (255 - LTB_LASER_MIN_ALPHA) * next_progress, 0.5 SECONDS, easing = SINE_EASING|EASE_OUT)

/// Flickers the reticle/beam between the AMR-intense blue's native brightness and a darker shade of
/// the same blue about twice a second while charging
/obj/item/hardpoint/primary/cannon/proc/cycle_laser_color(atom/locked_target, my_generation)
	var/use_dark_look = FALSE
	while(laser_beam && !QDELETED(laser_beam) && !QDELETED(locked_target) && aim_generation == my_generation)
		sleep(5)
		if(!laser_beam || QDELETED(laser_beam) || QDELETED(locked_target) || aim_generation != my_generation)
			break
		use_dark_look = !use_dark_look
		apply_beam_visuals(locked_target, use_dark_look)

/obj/item/hardpoint/primary/cannon/on_track_tick(atom/target)
	if(!anchor)
		return
	var/turf/origin_turf = get_origin_turf()
	if(anchor.loc != origin_turf)
		anchor.forceMove(origin_turf)

/obj/item/hardpoint/primary/cannon/end_aim_visuals(atom/target, mob/living/user, success)
	if(lockon_icon)
		target.overlays -= lockon_icon
		lockon_icon = null
	if(lockon_direction_icon)
		target.overlays -= lockon_direction_icon
		lockon_direction_icon = null
	QDEL_NULL(laser_beam)
	QDEL_NULL(anchor)
