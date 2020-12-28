/obj/item/hardpoint/primary/flamer
	name = "DRG-N Offensive Flamer Unit"
	desc = "A primary weapon for the tank that spews fire everywhere."

	icon_state = "drgn_flamer"
	disp_icon = "tank"
	disp_icon_state = "drgn_flamer"
	activation_sounds = list('sound/weapons/vehicles/flamethrower.ogg')

	health = 400
	cooldown = 20
	accuracy = 0.75
	firing_arc = 90

	origins = list(0, -3)

	ammo = new /obj/item/ammo_magazine/hardpoint/primary_flamer
	max_clips = 1

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 1),
		"8" = list(-32, 1)
	)

	use_muzzle_flash = FALSE

/obj/item/hardpoint/primary/flamer/can_activate(var/mob/user, var/atom/A)
	if(!..())
		return FALSE

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	if(origin_turf == get_turf(A))
		return FALSE

	return TRUE

/obj/item/hardpoint/primary/flamer/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/range = get_dist(origin_turf, A) + 1

	var/obj/item/projectile/P = new(initial(name), user)
	P.forceMove(origin_turf)
	P.generate_bullet(new ammo.default_ammo)
	if(ammo.has_iff && owner.seats[VEHICLE_GUNNER])
		P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, range < P.ammo.max_range ? range : P.ammo.max_range, P.ammo.shell_speed, iff_group = owner.seats[VEHICLE_GUNNER].faction_group)
	else
		P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, range < P.ammo.max_range ? range : P.ammo.max_range, P.ammo.shell_speed)

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(owner, A))

	ammo.current_rounds--
