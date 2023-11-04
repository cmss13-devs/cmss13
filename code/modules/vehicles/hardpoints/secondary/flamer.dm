/obj/item/hardpoint/secondary/small_flamer
	name = "LZR-N Flamer Unit"
	desc = "A secondary weapon for tanks that spews hot fire."

	icon_state = "flamer"
	disp_icon = "tank"
	disp_icon_state = "flamer"
	activation_sounds = list('sound/weapons/vehicles/flamethrower.ogg')

	health = 300
	cooldown = 30
	accuracy = 0.68
	firing_arc = 120

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/secondary_flamer
	max_clips = 1

	use_muzzle_flash = FALSE

	var/max_range = 7

	px_offsets = list(
		"1" = list(2, 14),
		"2" = list(-2, 3),
		"4" = list(3, 0),
		"8" = list(-3, 18)
	)

	fire_delay = 3.0 SECONDS

/obj/item/hardpoint/secondary/small_flamer/fire_shot(atom/target, mob/living/user, params)
	//offset fire origin from lower-left corner
	var/turf/origin_turf = get_turf(src)
	origin_turf = get_offset_target_turf(origin_turf, origins[1], origins[2])

	var/distance = get_dist(origin_turf, get_turf(target))
	var/fire_amount = min(ammo.current_rounds, distance+1, max_range)

	new /obj/flamer_fire(origin_turf, create_cause_data(initial(name), user), null, fire_amount, null, FLAMESHAPE_LINE, target, CALLBACK(src, PROC_REF(display_ammo), user))

	ammo.current_rounds -= fire_amount
	play_firing_sounds()

	COOLDOWN_START(src, fire_cooldown, fire_delay)
	return AUTOFIRE_CONTINUE
