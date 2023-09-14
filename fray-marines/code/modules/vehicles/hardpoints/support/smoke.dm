/obj/item/hardpoint/support/flare_launcher/smoke_launcher
	name = "M-87S Smoke Screen System"
	desc = "A smoke screen deployment system."
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')

	ammo = new /obj/item/ammo_magazine/hardpoint/turret_smoke
	max_clips = 2

	use_muzzle_flash = FALSE

/obj/item/hardpoint/support/flare_launcher/smoke_launcher/fire(mob/user, atom/A)
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown

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

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)
	fire_projectile(user, L)

	sleep(10)

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)
	fire_projectile(user, R)

	to_chat(user, SPAN_WARNING("Smoke Screen uses left: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds / 2 : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds / 2 : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))

/obj/item/hardpoint/support/flare_launcher/smoke_launcher/fire_projectile(mob/user, atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/obj/projectile/P = generate_bullet(user, origin_turf)
	SEND_SIGNAL(P, COMSIG_BULLET_USER_EFFECTS, owner.seats[VEHICLE_GUNNER])
	P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, get_dist(origin_turf, A) + 1, P.ammo.shell_speed)
	ammo.current_rounds--

/obj/item/ammo_magazine/hardpoint/turret_smoke/apc
	name = "M-87S Smoke Screen Magazine"
	desc = "A grenades magazine used by APC smoke screen system."
	gun_type = /obj/item/hardpoint/support/flare_launcher/smoke_launcher
