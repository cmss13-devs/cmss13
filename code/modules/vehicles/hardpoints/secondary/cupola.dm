/obj/item/hardpoint/secondary/m56cupola
	name = "M56 Cupola"
	desc = "A secondary weapon for tanks that shoots bullets"

	icon_state = "m56_cupola"
	disp_icon = "tank"
	disp_icon_state = "m56cupola"
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')

	health = 350
	cooldown = 15
	accuracy = 0.9
	firing_arc = 120
	var/burst_amount = 3

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola
	max_clips = 1

	muzzle_flash_pos = list(
		"1" = list(8, -1),
		"2" = list(-7, -15),
		"4" = list(6, -10),
		"8" = list(-5, 7)
	)

/obj/item/hardpoint/secondary/m56cupola/fire(var/mob/user, var/atom/A)
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