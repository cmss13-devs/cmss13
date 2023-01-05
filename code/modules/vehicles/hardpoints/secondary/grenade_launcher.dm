/obj/item/hardpoint/secondary/grenade_launcher
	name = "M92T Grenade Launcher"
	desc = "A secondary weapon for tanks that shoots grenades."

	icon_state = "glauncher"
	disp_icon = "tank"
	disp_icon_state = "glauncher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	health = 500
	cooldown = 30
	accuracy = 0.4
	firing_arc = 90
	var/max_range = 7

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/tank_glauncher
	max_clips = 3

	use_muzzle_flash = FALSE

	px_offsets = list(
		"1" = list(0, 17),
		"2" = list(0, 0),
		"4" = list(6, 0),
		"8" = list(-6, 17)
	)

/obj/item/hardpoint/secondary/grenade_launcher/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/secondary/grenade_launcher/can_activate(var/mob/user, var/atom/A)
	if(!..())
		return FALSE

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	if(get_dist(origin_turf, A) < 1)
		to_chat(usr, SPAN_WARNING("The target is too close."))
		return FALSE

	return TRUE

/obj/item/hardpoint/secondary/grenade_launcher/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	//getting distance between supposed target and tank center.
	var/range = get_dist(origin_turf, A) + 1	//otherwise nade falls one tile shorter
	if(range > max_range)
		range = max_range

	var/obj/item/projectile/P = generate_bullet(user, origin_turf)
	SEND_SIGNAL(P, COMSIG_BULLET_USER_EFFECTS, owner.seats[VEHICLE_GUNNER])
	P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, P.ammo.max_range, P.ammo.shell_speed)

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(owner, A))

	ammo.current_rounds--
