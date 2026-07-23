/obj/item/hardpoint/secondary/brute_launcher
	name = "\improper M6H-BRUTE Launcher"
	desc = "A tank-mounted variant of the M6H-BRUTE breaching rocket system. Laser-guides a 90mm shaped-charge rocket onto a fortified position, given a few seconds to lock on."

	icon_state = "brute_launcher"
	disp_icon = "tank"
	disp_icon_state = "brutelauncher"

	health = 500
	traverse_arc = 120
	activation_sounds = list('sound/weapons/gun_rocketlauncher.ogg')

	// reuses the handheld BRUTE launcher's own rocket item directly
	// It's very silly that the M56D also needed its own 'vehicle magazines' instead of just using the default drum. This has properly been changed.
	ammo = new /obj/item/ammo_magazine/rocket/brute
	max_clips = 4

	px_offsets = list(
		"1" = list(1, 10),
		"2" = list(-1, 5),
		"4" = list(0, 0),
		"8" = list(0, 18)
	)
	rotation_pivot = list(
		"1" = list(-1, -10),
		"2" = list(1, -5),
		"4" = list(0, 0),
		"8" = list(0, -18)
	)
	gimbal_pivot = list(
		"1" = list(6, -6),
		"2" = list(-6, 6),
		"4" = list(-6, 6),
		"8" = list(6, 6)
	)
	muzzle_flash_pos = list(
		"1" = list(8, -1),
		"2" = list(-8, -16),
		"4" = list(5, -8),
		"8" = list(-5, 10)
	)

	scatter = 4 // irrelevant - /datum/ammo/rocket/brute sets AMMO_HITS_TARGET_TURF, which skips scatter entirely
	fire_delay = 15.0 SECONDS

	// How long the lock-on charge takes before firing is allowed.
	var/f_aiming_time = 5 SECONDS

	var/image/lockon_icon
	var/image/lockon_direction_icon
	var/datum/beam/laser_beam
	var/obj/effect/beam_anchor/anchor

/obj/item/hardpoint/secondary/brute_launcher/handle_fire(atom/target, mob/living/user, params)
	if(charging)
		SEND_SIGNAL(src, COMSIG_GUN_INTERRUPT_FIRE)
		return NONE

	if(!(istype(target, /obj/structure) || istype(target, /turf/closed/wall)))
		to_chat(user, SPAN_WARNING("Invalid target!"))
		return NONE

	var/turf/origin_turf = get_origin_turf()
	var/list/turf/path = get_line(origin_turf, get_turf(target), include_start_atom = FALSE)
	for(var/turf/turf_path in path)
		if(turf_path.opacity && turf_path != target)
			to_chat(user, SPAN_WARNING("Target obscured!"))
			return NONE

	if(!track_and_charge(target, user, f_aiming_time))
		return NONE

	return ..()

/obj/item/hardpoint/secondary/brute_launcher/start_aim_visuals(atom/target, mob/living/user)
	var/turf/origin_turf = get_origin_turf()

	lockon_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "sniper_lockon_guided")
	target.overlays += lockon_icon

	lockon_direction_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "sniper_lockon_guided_direction", dir = get_cardinal_dir(target, origin_turf))
	target.overlays += lockon_direction_icon

	anchor = new(origin_turf)
	laser_beam = anchor.beam(target, "laser_beam_guided", 'icons/effects/beam.dmi', (f_aiming_time + 1 SECONDS), beam_type = /obj/effect/ebeam/laser/intense/tank_mounted)
	laser_beam.visuals.alpha = 0
	animate(laser_beam.visuals, alpha = initial(laser_beam.visuals.alpha), f_aiming_time, easing = SINE_EASING|EASE_OUT)

/obj/item/hardpoint/secondary/brute_launcher/on_track_tick(atom/target)
	if(!anchor)
		return
	var/turf/origin_turf = get_origin_turf()
	if(anchor.loc != origin_turf)
		anchor.forceMove(origin_turf)

/obj/item/hardpoint/secondary/brute_launcher/end_aim_visuals(atom/target, mob/living/user, success)
	if(lockon_icon)
		target.overlays -= lockon_icon
		lockon_icon = null
	if(lockon_direction_icon)
		target.overlays -= lockon_direction_icon
		lockon_direction_icon = null
	QDEL_NULL(laser_beam)
	QDEL_NULL(anchor)

// Plain /obj/effect/ebeam/laser/intense defaults to the base /obj layer, which renders underneath the
// tank's own ABOVE_MOB_LAYER (4.1) sprite, so, we bump it above it.
/obj/effect/ebeam/laser/intense/tank_mounted
	layer = 4.501

// Small invisible movable used solely as a beam origin that actually moves with the muzzle
/obj/effect/beam_anchor
	name = ""
	icon = null
	anchored = FALSE
	density = FALSE
	invisibility = INVISIBILITY_MAXIMUM
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
