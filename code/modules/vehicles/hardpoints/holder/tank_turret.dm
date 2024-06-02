/obj/item/hardpoint/holder/tank_turret
	name = "M34A2-A Multipurpose Turret"
	desc = "The centerpiece of the tank. Designed to support quick installation and deinstallation of various tank weapon modules. Has inbuilt smoke screen deployment system."

	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_turret_0"
	disp_icon = "tank"
	disp_icon_state = "tank_turret"
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')
	pixel_x = -48
	pixel_y = -48

	density = TRUE //come on, it's huge

	activatable = TRUE

	ammo = new /obj/item/ammo_magazine/hardpoint/turret_smoke
	max_clips = 2
	use_muzzle_flash = FALSE

	w_class = SIZE_MASSIVE
	density = TRUE
	anchored = TRUE

	allowed_seat = VEHICLE_DRIVER

	slot = HDPT_TURRET

	// big beefy chonk of metal
	health = 750
	damage_multiplier = 0.05

	accepted_hardpoints = list(
		// primaries
		/obj/item/hardpoint/primary/flamer,
		/obj/item/hardpoint/primary/cannon,
		/obj/item/hardpoint/primary/minigun,
		/obj/item/hardpoint/primary/autocannon,
		// secondaries
		/obj/item/hardpoint/secondary/small_flamer,
		/obj/item/hardpoint/secondary/towlauncher,
		/obj/item/hardpoint/secondary/m56cupola,
		/obj/item/hardpoint/secondary/grenade_launcher
	)

	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, -10),
		"2" = list(0, 10),
		"4" = list(-10, 0),
		"8" = list(10, 0)
	)

	var/gyro = FALSE

	// How long the windup is before the turret rotates
	var/rotation_windup = 15
	// Used during the windup
	var/rotating = FALSE

	scatter = 4
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	gun_firemode_list = list(
		GUN_FIREMODE_BURSTFIRE,
	)
	burst_amount = 2
	burst_delay = 1.0 SECONDS
	extra_delay = 13.0 SECONDS

/obj/item/hardpoint/holder/tank_turret/update_icon()
	var/broken = (health <= 0)
	icon_state = "tank_turret_[broken]"

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		overlays += damage_overlay

	..()

/obj/item/hardpoint/holder/tank_turret/get_icon_image(x_offset, y_offset, new_dir)
	var/icon_state_suffix = "0"
	if(health <= 0)
		icon_state_suffix = "1"

	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[icon_state_suffix]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		I.overlays += damage_overlay

	return I

// no picking this big beast up
/obj/item/hardpoint/holder/tank_turret/attack_hand(mob/user)
	return

/obj/item/hardpoint/holder/tank_turret/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(!PC.linked_powerloader)
			qdel(PC)
			return TRUE

		if(health < 1)
			visible_message(SPAN_WARNING("\The [src] disintegrates into useless pile of scrap under the damage it suffered!"))
			qdel(src)
			return TRUE

		PC.grab_object(user, src, "vehicle_module", 'sound/machines/hydraulics_2.ogg')
		update_icon()
		return TRUE
	..()


/obj/item/hardpoint/holder/tank_turret/get_tgui_info()
	var/list/data = list()

	data += list(list( // turret smokescreen data
		"name" = "M34A2-A Turret Smoke Screen",
		"health" = health <= 0 ? null : floor(get_integrity_percent()),
		"uses_ammo" = TRUE,
		"current_rounds" = ammo.current_rounds / 2,
		"max_rounds"= ammo.max_rounds / 2,
		"mags" = LAZYLEN(backup_clips),
		"max_mags" = max_clips,
	))

	for(var/obj/item/hardpoint/H in hardpoints)
		data += list(H.get_tgui_info())

	return data

//gyro ON locks the turret in one direction, OFF will make turret turning when tank turns
/obj/item/hardpoint/holder/tank_turret/proc/toggle_gyro(mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src]'s stabilization systems are busted!"))
		return

	gyro = !gyro
	to_chat(user, SPAN_NOTICE("You toggle \the [src]'s gyroscopic stabilizer [gyro ? "ON" :"OFF"]."))

/obj/item/hardpoint/holder/tank_turret/proc/user_rotation(mob/user, deg)
	// no rotating a broken turret
	if(health <= 0)
		return

	if(rotating)
		return

	rotating = TRUE
	to_chat(user, SPAN_NOTICE("You begin rotating the turret towards the [dir2text(turn(dir,deg))]."))

	if(!do_after(user, rotation_windup, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		rotating = FALSE
		return
	rotating = FALSE

	rotate(deg, TRUE)

/obj/item/hardpoint/holder/tank_turret/rotate(deg, override_gyro = FALSE)
	if(gyro && !override_gyro)
		return

	..(deg)

	var/obj/vehicle/multitile/tank/C = owner
	var/obj/item/hardpoint/support/artillery_module/AM
	for(var/obj/item/hardpoint/support/artillery_module/A in C.hardpoints)
		AM = A
	if(AM && AM.is_active)
		var/mob/user = C.seats[VEHICLE_GUNNER]
		if(user && user.client)
			user = C.seats[VEHICLE_GUNNER]
			user.client.change_view(AM.view_buff, src)

			switch(dir)
				if(NORTH)
					user.client.pixel_x = 0
					user.client.pixel_y = AM.view_tile_offset * 32
				if(SOUTH)
					user.client.pixel_x = 0
					user.client.pixel_y = -1 * AM.view_tile_offset * 32
				if(EAST)
					user.client.pixel_x = AM.view_tile_offset * 32
					user.client.pixel_y = 0
				if(WEST)
					user.client.pixel_x = -1 * AM.view_tile_offset * 32
					user.client.pixel_y = 0

/obj/item/hardpoint/holder/tank_turret/try_fire(atom/target, mob/living/user, params)
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
