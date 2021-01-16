/obj/item/hardpoint/primary/minigun
	name = "LTAA-AP Minigun"
	desc = "A primary weapon for tanks that spews bullets"

	icon_state = "ltaaap_minigun"
	disp_icon = "tank"
	disp_icon_state = "ltaaap_minigun"

	health = 350
	cooldown = 8
	accuracy = 0.6
	firing_arc = 90

	origins = list(0, -3)

	ammo = new /obj/item/ammo_magazine/hardpoint/ltaaap_minigun
	max_clips = 1

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 0),
		"8" = list(-32, 0)
	)

	muzzle_flash_pos = list(
		"1" = list(0, 57),
		"2" = list(0, -67),
		"4" = list(77, 0),
		"8" = list(-77, 0)
	)

	//changed minigun mechanic so instead of having lowered cooldown with each shot it now has increased burst size.
	//While it's still spammy, user doesn't have to click as fast as possible anymore and has margin of 2 seconds before minigun will start slowing down

	var/chained_shots = 1		//how many quick succession shots we've fired, 1 by default
	var/last_shot_time = 0		//when was last shot fired, after 3 seconds we stop barrel
	var/list/chain_bursts = list(1, 1, 2, 2, 3, 3, 3, 4, 4, 4)	//how many shots per click we do


/obj/item/hardpoint/primary/minigun/fire(var/mob/user, var/atom/A)

	var/S = 'sound/weapons/vehicles/minigun_stop.ogg'
	//check how much time since last shot. 2 seconds are grace period before minigun starts to lose rotation momentum
	var/t = world.time - last_shot_time - 2 SECONDS
	t = round(t / 10)
	if(t > 0)
		chained_shots = max(chained_shots - t * 3, 1)	//we lose 3 chained_shots per second
	else
		if(chained_shots < 11)
			chained_shots++
		S = 'sound/weapons/vehicles/minigun_loop.ogg'

	if(chained_shots == 1)
		playsound(get_turf(src), 'sound/weapons/vehicles/minigun_start.ogg', 40, 1)

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

	//how many rounds we will shoot in this burst
	if(chained_shots > LAZYLEN(chain_bursts))	//5 shots at maximum rotation
		t = 5
	else
		t = LAZYACCESS(chain_bursts, chained_shots)
	for(var/i = 1; i <= t; i++)
		var/atom/T = A
		if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
			T = get_step(get_turf(T), pick(cardinal))
		fire_projectile(user, T)
		if(ammo.current_rounds <= 0)
			break
		sleep(2)
	to_chat(user, SPAN_WARNING("[src] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))

	playsound(get_turf(src), S, 40, 1)
	last_shot_time = world.time
