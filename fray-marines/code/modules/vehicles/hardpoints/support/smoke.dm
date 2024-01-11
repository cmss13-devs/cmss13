/obj/item/hardpoint/support/flare_launcher/smoke_launcher
	name = "M-87S Smoke Screen System"
	desc = "A smoke screen deployment system."
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')

	ammo = new /obj/item/ammo_magazine/hardpoint/turret_smoke
	max_clips = 2

	use_muzzle_flash = FALSE



/obj/item/hardpoint/support/flare_launcher/smoke_launcher/try_fire(atom/target, mob/living/user, params)
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

/obj/item/hardpoint/support/flare_launcher/smoke_launcher/get_origin_turf()
	var/origin_turf = ..()
	origin_turf = get_step(get_step(origin_turf, owner.dir), owner.dir) //this should get us tile in front of tank to prevent grenade being stuck under us.
	return origin_turf

/obj/item/ammo_magazine/hardpoint/turret_smoke/apc
	name = "M-87S Smoke Screen Magazine"
	desc = "A grenades magazine used by APC smoke screen system."
	gun_type = /obj/item/hardpoint/support/flare_launcher/smoke_launcher
