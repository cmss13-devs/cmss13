// APC cannons
/obj/item/hardpoint/primary/dualcannon
	name = "PARS-159 Boyars Dualcannon"
	desc = "A primary two-barrel cannon for the APC that shoots 20mm IFF-compatible rounds."
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "dual_cannon"
	disp_icon = "apc"
	disp_icon_state = "dualcannon"
	activation_sounds = list('sound/weapons/vehicles/dual_autocannon_fire.ogg')

	damage_multiplier = 0.2

	health = 500
	cooldown = 7
	accuracy = 0.98
	firing_arc = 60
	var/burst_amount = 2

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/boyars_dualcannon
	max_clips = 2

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_double"

	muzzle_flash_pos = list(
		"1" = list(11, -29),
		"2" = list(-11, 10),
		"4" = list(-14, 9),
		"8" = list(14, 9)
	)

/obj/item/hardpoint/primary/dualcannon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/primary/dualcannon/fire(var/mob/user, var/atom/A)
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

	for(var/bullets_fired = 1, bullets_fired <= burst_amount, bullets_fired++)
		var/atom/T = A
		if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
			T = get_step(get_turf(A), pick(cardinal))
		if(LAZYLEN(activation_sounds))
			playsound(get_turf(src), pick(activation_sounds), 60, 1)
		fire_projectile(user, T)
		if(ammo.current_rounds <= 0)
			break
		if(bullets_fired < burst_amount)	//we need to sleep only if there are more bullets to shoot in the burst
			sleep(3)
	to_chat(user, SPAN_WARNING("[src] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))
