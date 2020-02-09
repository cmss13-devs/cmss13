/obj/item/hardpoint/gun/minigun
	name = "LTAA-AP Minigun"
	desc = "A primary weapon for tanks that spews bullets"

	icon_state = "ltaaap_minigun"
	disp_icon = "tank"
	disp_icon_state = "ltaaap_minigun"

	slot = HDPT_PRIMARY

	point_cost = 600
	health = 350
	damage_multiplier = 0.15
	// Doesn't really matter, the minigun has fully custom firing (and therefore cooldown) logic
	cooldown = 2
	accuracy = 0.33
	firing_arc = 60

	origins = list(0, -3)

	ammo = new /obj/item/ammo_magazine/hardpoint/ltaaap_minigun
	max_clips = 2

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

	//Miniguns don't use a conventional cooldown
	//If you fire quickly enough, the cooldown decreases according to chain_delays
	//If you fire too slowly, you slowly slow back down
	//Also, different sounds play and it sounds sick, thanks Rahlzel
	var/chained = 0 //how many quick succession shots we've fired
	var/list/chain_delays = list(4, 4, 3, 3, 2, 2, 2, 1, 1) //the different cooldowns in deciseconds, sequentially

	//MAIN PROBLEM WITH THIS IMPLEMENTATION OF DELAYS:
	//If you spin all the way up and then stop firing, your chained shots will only decrease by 1
	//TODO: Implement a rolling average for seconds per shot that determines chain length without being slow or buggy
	//You'd probably have to normalize it between the length of the list and the actual ROF
	//But you don't want to map it below a certain point probably since seconds per shot would go to infinity

	//So, I came back to this and changed it by adding a fixed reset at 1.5 seconds or later, which seems reasonable
	//Now the cutoff is a little abrupt, but at least it exists. --MadSnailDisease

/obj/item/hardpoint/gun/minigun/fire(var/mob/user, var/atom/A)
	if(ammo.current_rounds <= 0)
		to_chat(usr, SPAN_WARNING("[name] does not have any ammo."))
		return

	var/S = 'sound/weapons/tank_minigun_start.ogg'
	if(world.time - next_use <= 5)
		chained++ //minigun spins up, minigun spins down
		S = 'sound/weapons/tank_minigun_loop.ogg'
	else if(world.time - next_use >= 15) //Too long of a delay, they restart the chain
		chained = 1
	else //In between 5 and 15 it slows down but doesn't stop
		chained--
		S = 'sound/weapons/tank_minigun_stop.ogg'
	if(chained <= 0) chained = 1

	next_use = world.time + (chained > chain_delays.len ? 0.5 : chain_delays[chained])
	if(!prob(accuracy * 100))
		A = get_step(get_turf(A), pick(cardinal))

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/obj/item/projectile/P = new(initial(name), user)
	P.loc = origin_turf

	P.generate_bullet(new ammo.default_ammo)
	P.fire_at(A, owner, src, P.ammo.max_range, P.ammo.shell_speed)
	muzzle_flash(Get_Angle(owner, A))

	playsound(get_turf(src), S, 60)
	ammo.current_rounds--
