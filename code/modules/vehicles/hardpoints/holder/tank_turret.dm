/obj/item/hardpoint/holder/tank_turret
	name = "M34A2-A Multipurpose Turret"
	desc = "The centerpiece of the tank. Everything else is just there to carry this turret around. It has been carefully designed to allow for easy fitting of various selections of large, powerful weapons."

	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_turret_0"
	disp_icon = "tank"
	disp_icon_state = "tank_turret"
	pixel_x = -48
	pixel_y = -48

	point_cost = 1000

	w_class = SIZE_MASSIVE
	density = TRUE
	anchored = TRUE

	slot = HDPT_TURRET

	// big beefy chonk of metal
	health = 750
	damage_multiplier = 0.05

	accepted_hardpoints = list(
		// primaries
		/obj/item/hardpoint/gun/flamer,
		/obj/item/hardpoint/gun/cannon,
		/obj/item/hardpoint/gun/minigun,
		/obj/item/hardpoint/gun/autocannon,
		// secondaries
		/obj/item/hardpoint/gun/small_flamer,
		/obj/item/hardpoint/gun/towlauncher,
		/obj/item/hardpoint/gun/m56cupola,
		/obj/item/hardpoint/gun/grenade_launcher
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
	var/rotation_windup = 20
	// Used during the windup
	var/rotating = FALSE

/obj/item/hardpoint/holder/tank_turret/update_icon()
	var/broken = (health <= 0)
	icon_state = "tank_turret_[broken]"

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		overlays += damage_overlay

	..()

/obj/item/hardpoint/holder/tank_turret/get_icon_image(var/x_offset, var/y_offset, var/new_dir)
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
/obj/item/hardpoint/holder/tank_turret/attack_hand(var/mob/user)
	return

/obj/item/hardpoint/holder/tank_turret/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(PC.linked_powerloader)
			if(!PC.loaded)
				forceMove(PC.linked_powerloader)
				PC.loaded = src
				playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
				PC.update_icon()
				to_chat(user, SPAN_NOTICE("You grab [PC.loaded] with [PC]."))
				update_icon()

	..()

//gyro ON locks the turret in one direction, OFF will make turret turning when tank turns
/obj/item/hardpoint/holder/tank_turret/proc/toggle_gyro(var/mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src]'s stabilization systems are busted!"))
		return

	gyro = !gyro
	to_chat(user, SPAN_NOTICE("You toggle \the [src]'s gyroscopic stabilizer [gyro ? "ON" :"OFF"]."))

/obj/item/hardpoint/holder/tank_turret/activate()
	gyro = TRUE

/obj/item/hardpoint/holder/tank_turret/deactivate()
	gyro = FALSE

/obj/item/hardpoint/holder/tank_turret/proc/user_rotation(var/mob/user, var/deg)
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

/obj/item/hardpoint/holder/tank_turret/rotate(var/deg, var/override_gyro = FALSE)
	if(gyro && !override_gyro)
		return

	..(deg)

	var/obj/vehicle/multitile/tank/C = owner
	var/obj/item/hardpoint/artillery_module/AM
	for(var/obj/item/hardpoint/artillery_module/A in C.hardpoints)
		AM = A
	if(AM && AM.is_active)
		var/mob/user = C.seats[VEHICLE_GUNNER]
		if(user && user.client)
			user = C.seats[VEHICLE_GUNNER]
			user.client.change_view(AM.view_buff)

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