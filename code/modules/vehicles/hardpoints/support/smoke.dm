// Technically a support weapon but it functions like a gun
// Sue me
/obj/item/hardpoint/gun/smoke_launcher
	name = "Smoke Launcher"
	desc = "Launches smoke forward to obscure vision"

	icon_state = "slauncher_0"
	disp_icon = "tank"
	disp_icon_state = "slauncher"
	firing_sounds = list('sound/weapons/tank_smokelauncher_fire.ogg')

	slot = HDPT_SUPPORT
	hdpt_layer = HDPT_LAYER_SUPPORT

	point_cost = 250
	health = 300
	damage_multiplier = 0.075
	cooldown = 70
	accuracy = 0.8

	ammo = new /obj/item/ammo_magazine/hardpoint/tank_slauncher
	max_clips = 3

	use_muzzle_flash = FALSE

/obj/item/hardpoint/gun/smoke_launcher/get_icon_image(var/x_offset, var/y_offset, var/new_dir)

	var/icon_suffix = "NS"
	var/icon_state_suffix = "0"

	if(new_dir in list(NORTH, SOUTH))
		icon_suffix = "NS"
	else if(new_dir in list(EAST, WEST))
		icon_suffix = "EW"

	if(health <= 0) icon_state_suffix = "1"
	else if(ammo.current_rounds <= 0) icon_state_suffix = "2"

	return image(icon = "[disp_icon]_[icon_suffix]", icon_state = "[disp_icon_state]_[icon_state_suffix]", pixel_x = x_offset, pixel_y = y_offset)


/obj/item/hardpoint/gun/smoke_launcher/fire(var/mob/user, var/atom/A)
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]

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

	if(LAZYLEN(firing_sounds))
		playsound(get_turf(src), pick(firing_sounds), 60, 1)
	fire_projectile(user, L)

	sleep(10)

	if(LAZYLEN(firing_sounds))
		playsound(get_turf(src), pick(firing_sounds), 60, 1)
	fire_projectile(user, R)

	to_chat(user, SPAN_WARNING("[src] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))

/obj/item/hardpoint/gun/smoke_launcher/fire_projectile(var/mob/user, var/atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)
	origin_turf = get_step(get_step(origin_turf, owner.dir), owner.dir)	//this should get us tile in front of tank to prevent grenade being stuck under us.

	var/obj/item/projectile/P = new(initial(name), user)
	P.loc = origin_turf
	P.generate_bullet(new ammo.default_ammo)
	P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, get_dist(origin_turf, A) + 1, P.ammo.shell_speed, iff_group = owner.seats[VEHICLE_GUNNER].faction_group)
	ammo.current_rounds--