/*
	Hardpoints are any items that attach to a base vehicle, such as wheels/treads, support systems and guns
*/

/obj/item/hardpoint
	//------MAIN VARS----------
	// Which slot is this hardpoint in
	// Purely to check for conflicting hardpoints
	var/slot
	// The vehicle this hardpoint is installed on
	var/obj/vehicle/multitile/owner

	health = 100
	w_class = SIZE_LARGE

	// Determines how much of any incoming damage is actually taken
	var/damage_multiplier = 1

	// Origin coords of the hardpoint relative to the vehicle
	var/list/origins = list(0, 0)

	var/list/buff_multipliers
	var/list/type_multipliers

	var/buff_applied = FALSE

	//------ICON VARS----------
	icon = 'icons/obj/vehicles/hardpoints/tank.dmi'
	icon_state = "tires" //Placeholder

	//Strings, used to get the overlay for the armored vic
	var/disp_icon //This also differentiates tank vs apc vs other
	var/disp_icon_state

	// List of pixel offsets for each direction
	var/list/px_offsets

	//visual layer of hardpoint when on vehicle
	var/hdpt_layer = HDPT_LAYER_WHEELS

	// Whether or not to make a muzzle flash when the gun is fired
	var/use_muzzle_flash = FALSE
	// List of offsets for where to place the muzzle flash for each direction
	var/list/muzzle_flash_pos = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 0),
		"8" = list(0, 0)
	)

	// debug vars
	var/use_mz_px_offsets = FALSE
	var/use_mz_trt_offsets = FALSE

	var/const_mz_offset_x = 0
	var/const_mz_offset_y = 0

	//------SOUNDS VARS----------
	// Sounds to play when the module activated/fired
	var/list/activation_sounds



	//------INTERACTION VARS----------

	//which seat can use this module
	var/allowed_seat = VEHICLE_GUNNER

	//Cooldown on use of the hardpoint
	var/cooldown = 100
	var/next_use = 0

	//whether hardpoint has activatable ability like shooting or zooming
	var/activatable = 0

	//used to prevent welder click spam
	var/being_repaired = FALSE

	//current user. We can have only one user at a time. Better never change that
	var/user

	//Accuracy of the hardpoint. (which is, in fact, a scatter. Need to change this system)
	var/accuracy = 1

	// The firing arc of this hardpoint
	var/firing_arc = 0	//in degrees. 0 skips whole arc of fire check


	//------AMMUNITION VARS----------

	//Currently loaded ammo that we shoot from
	var/obj/item/ammo_magazine/ammo
	//spare magazines that we can reload from
	var/list/backup_clips
	//maximum amount of spare mags
	var/max_clips = 0

//-----------------------------
//------GENERAL PROCS----------
//-----------------------------

/obj/item/hardpoint/Destroy()
	if(owner)
		owner.remove_hardpoint(src)
		owner.update_icon()
		owner = null
	if(LAZYLEN(backup_clips))
		for(var/obj/O in backup_clips)
			qdel(O)
	backup_clips = null

	if(ammo)
		qdel(ammo)
	ammo = null

	return ..()

/obj/item/hardpoint/proc/take_damage(var/damage)
	health = max(0, health - damage * damage_multiplier)

/obj/item/hardpoint/proc/is_activatable()
	if(health <= 0)
		return FALSE
	return activatable

//returns the integrity of the hardpoint module
/obj/item/hardpoint/proc/get_integrity_percent()
	return 100.0*health/initial(health)

/obj/item/hardpoint/proc/on_install(var/obj/vehicle/multitile/V)
	apply_buff(V)
	return

/obj/item/hardpoint/proc/on_uninstall(var/obj/vehicle/multitile/V)
	remove_buff(V)
	return

//applying passive buffs like damage type resistance, speed, accuracy, cooldowns
/obj/item/hardpoint/proc/apply_buff(var/obj/vehicle/multitile/V)
	if(buff_applied)
		return
	if(LAZYLEN(type_multipliers))
		for(var/type in type_multipliers)
			V.dmg_multipliers[type] *= LAZYACCESS(type_multipliers, type)
	if(LAZYLEN(buff_multipliers))
		for(var/type in buff_multipliers)
			V.misc_multipliers[type] *= LAZYACCESS(buff_multipliers, type)
	buff_applied = TRUE

//removing buffs
obj/item/hardpoint/proc/remove_buff(var/obj/vehicle/multitile/V)
	if(!buff_applied)
		return
	if(LAZYLEN(type_multipliers))
		for(var/type in type_multipliers)
			V.dmg_multipliers[type] *= 1 / LAZYACCESS(type_multipliers, type)
	if(LAZYLEN(buff_multipliers))
		for(var/type in buff_multipliers)
			V.misc_multipliers[type] *= 1 / LAZYACCESS(buff_multipliers, type)
	buff_applied = FALSE

//this proc called on each move of vehicle
/obj/item/hardpoint/proc/on_move(var/turf/old, var/turf/new_turf, var/move_dir)
	return

/obj/item/hardpoint/proc/get_root_origins()
	return list(-owner.bound_x / world.icon_size, -owner.bound_y / world.icon_size)

// Resets the hardpoint rotation to south
/obj/item/hardpoint/proc/reset_rotation()
	rotate(turning_angle(dir, SOUTH))

/obj/item/hardpoint/proc/rotate(var/deg)
	if(!deg)
		return

	// Update origins
	var/list/root_coords = get_root_origins()
	var/list/center_coords = list(owner.bound_width / (2*world.icon_size), owner.bound_height / (2*world.icon_size))
	var/list/origin_coords_abs = list(origins[1] + root_coords[1], origins[2] + root_coords[2])

	origin_coords_abs[1] = origin_coords_abs[1] + 0.5
	origin_coords_abs[2] = origin_coords_abs[2] + 0.5

	var/list/new_origin = RotateAroundAxis(origin_coords_abs, center_coords, deg)

	new_origin[1] = round(new_origin[1] - root_coords[1] - 0.5, 1)
	new_origin[2] = round(new_origin[2] - root_coords[2] - 0.5, 1)

	origins = new_origin

	// Update dir
	dir = turn(dir, deg)

//for status window
/obj/item/hardpoint/proc/get_hardpoint_info()
	var/dat = "<hr>"
	dat += "[name]<br>"
	if(health <= 0)
		dat += "Integrity: <font color=\"red\">\[DESTROYED\]</font>"
	else
		dat += "Integrity: [round(get_integrity_percent())]%"
		if(ammo)
			dat += " | Ammo: [ammo ? (ammo.current_rounds ? ammo.current_rounds : "<font color=\"red\">0</font>") : "<font color=\"red\">0</font>"]/[ammo ? ammo.max_rounds : "<font color=\"red\">0</font>"] | Mags: [LAZYLEN(backup_clips) ? LAZYLEN(backup_clips) : "<font color=\"red\">0</font>"]/[max_clips]"
	return dat

// Traces backwards from the gun origin to the vehicle to check for obstacles between the vehicle and the muzzle
/obj/item/hardpoint/proc/clear_los(var/atom/A)

	if(origins[1] == 0 && origins[2] == 0)	//skipping check for modules we don't need this
		return TRUE

	var/turf/muzzle_turf = locate(owner.x + origins[1], owner.y + origins[2], owner.z)

	var/turf/checking_turf = muzzle_turf
	while(!(owner in checking_turf))
		// Dense turfs block LoS
		if(checking_turf.density)
			return FALSE

		// Ensure that we can pass over all objects in the turf
		for(var/obj/O in checking_turf)
			// Since vehicles are multitile the
			if(O == owner)
				continue

			// Non-dense objects are irrelevant
			if(!O.density)
				continue

			// Make sure we can pass object from all directions
			if(!(LIST_FLAGS_COMPARE(O.pass_flags.flags_can_pass_all, PASS_OVER_THROW_ITEM)))
				if(!(O.flags_atom & ON_BORDER))
					return FALSE
				//If we're behind the object, check the behind pass flags
				else if(dir == O.dir && !(LIST_FLAGS_COMPARE(O.pass_flags.flags_can_pass_behind, PASS_OVER_THROW_ITEM)))
					return FALSE
				//If we're in front, check front pass flags
				else if(dir == turn(O.dir, 180) && !(LIST_FLAGS_COMPARE(O.pass_flags.flags_can_pass_front, PASS_OVER_THROW_ITEM)))
					return FALSE

		// Trace back towards the vehicle
		checking_turf = get_step(checking_turf, turn(dir,180))

	return TRUE

//-----------------------------
//------INTERACTION PROCS----------
//-----------------------------

//If the hardpoint can be activated by current user
/obj/item/hardpoint/proc/can_activate(var/mob/user, var/atom/A)
	if(!owner)
		return

	var/seat = owner.get_mob_seat(user)
	if(!seat)
		return

	if(seat != allowed_seat)
		to_chat(user, SPAN_WARNING("<b>Only [allowed_seat] can use [name].</b>"))
		return

	if(health <= 0)
		to_chat(user, SPAN_WARNING("<b>\The [name] is broken!</b>"))
		return FALSE

	if(world.time < next_use)
		if(cooldown >= 20)	//filter out guns with high firerate to prevent message spam.
			to_chat(user, SPAN_WARNING("You need to wait [SPAN_HELPFUL((next_use - world.time) / 10)] seconds before [name] can be used again."))
		return FALSE

	if(ammo && ammo.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("<b>\The [name] is out of ammo!</b> Magazines: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))
		return FALSE

	if(!in_firing_arc(A))
		to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
		return FALSE

	if(!clear_los(A))
		to_chat(user, SPAN_WARNING("<b>You don't have a clear line of sight to the target!</b>"))
		return FALSE

	return TRUE

//Called when you want to activate the hardpoint, by default firing a gun
//This can also be used for some type of temporary buff or toggling mode, up to you
/obj/item/hardpoint/proc/activate(var/mob/user, var/atom/A)
	fire(user, A)

/obj/item/hardpoint/proc/deactivate()
	return

//used during bumping. Every mob we bump is getting affected by this proc from every module.
/obj/item/hardpoint/proc/livingmob_interact(var/mob/living/M)
	return

//examining a hardpoint
/obj/item/hardpoint/examine(mob/user, var/integrity_only = null)
	if(!integrity_only)
		..()
	if(health <= 0)
		to_chat(user, "It's busted!")
	else if(isobserver(user) || (ishuman(user) && skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI)))
		to_chat(user, "It's at [round(get_integrity_percent(), 1)]% integrity!")

//reloading hardpoint - take mag from backup clips and replace current ammo with it. Will change in future. Called via weapons loader
/obj/item/hardpoint/proc/reload(var/mob/user)
	if(!LAZYLEN(backup_clips))
		to_chat(usr, SPAN_WARNING("\The [name] has no remaining backup clips."))
		return

	var/obj/item/ammo_magazine/A = LAZYACCESS(backup_clips, 1)
	if(!A)
		to_chat(user, SPAN_DANGER("Something went wrong! Ahelp and ask for a developer! Code: HP_RLDHP"))
		return

	to_chat(user, SPAN_NOTICE("You begin reloading \the [name]."))

	sleep(20)

	forceMove(ammo, get_turf(src))
	ammo.update_icon()
	ammo = A
	LAZYREMOVE(backup_clips, A)

	to_chat(user, SPAN_NOTICE("You reload \the [name]."))

//try adding magazine to hardpoint's backup clips. Called via weapons loader
/obj/item/hardpoint/proc/try_add_clip(var/obj/item/ammo_magazine/A, var/mob/user)
	if(!ammo)
		to_chat(user, SPAN_WARNING("\The [name] doesn't use ammunition."))
		return FALSE
	if(max_clips == 0)
		to_chat(user, SPAN_WARNING("\The [name] does not have room for additional ammo."))
		return FALSE
	else if(LAZYLEN(backup_clips) >= max_clips)
		to_chat(user, SPAN_WARNING("\The [name]'s reloader is full."))
		return FALSE

	to_chat(user, SPAN_NOTICE("You begin loading \the [A] into \the [name]."))

	if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_WARNING("Something interrupted you while reloading \the [name]."))
		return FALSE

	if(LAZYLEN(backup_clips) >= max_clips)
		to_chat(user, SPAN_WARNING("\The [name]'s reloader is full."))
		return FALSE

	user.drop_inv_item_to_loc(A, src)
	to_chat(user, SPAN_NOTICE("You load \the [A] into \the [name]."))
	playsound(loc, 'sound/machines/hydraulics_2.ogg', 50)
	LAZYADD(backup_clips, A)
	return TRUE

//repair procs
/obj/item/hardpoint/proc/repair(var/obj/item/O, var/mob/user)
	if(health > 0)
		to_chat(user, SPAN_NOTICE("\The [name] doesn't require any critical repairs."))
		return

	//Determine how many 3 second intervals to wait and if you have the right tool
	var/num_delays = 1
	switch(slot)
		if(HDPT_PRIMARY)
			num_delays = 5
			if(!iswelder(O))
				to_chat(user, SPAN_WARNING("That's the wrong tool. Use a welder."))
				return
			var/obj/item/tool/weldingtool/WT = O
			if(!WT.isOn())
				to_chat(user, SPAN_WARNING("You need to light your [WT] first."))
				return
			WT.remove_fuel(num_delays, user)

		if(HDPT_SECONDARY)
			num_delays = 3
			if(!iswrench(O))
				to_chat(user, SPAN_WARNING("That's the wrong tool. Use a wrench."))
				return

		if(HDPT_SUPPORT)
			num_delays = 2
			if(!iswrench(O))
				to_chat(user, SPAN_WARNING("That's the wrong tool. Use a wrench."))
				return

		if(HDPT_ARMOR)
			num_delays = 10
			if(!iswelder(O))
				to_chat(user, SPAN_WARNING("That's the wrong tool. Use a welder."))
				return
			var/obj/item/tool/weldingtool/WT = O
			if(!WT.isOn())
				to_chat(user, SPAN_WARNING("You need to light your [WT] first."))
				return
			WT.remove_fuel(num_delays, user)

	user.visible_message(SPAN_NOTICE("[user] starts repairing \the [name]."),
		SPAN_NOTICE("You start repairing \the [name]."))

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays))
		user.visible_message(SPAN_NOTICE("[user] stops repairing \the [name]."),
			SPAN_NOTICE("You stop repairing \the [name]."))
		return

	if(!Adjacent(user))
		user.visible_message(SPAN_NOTICE("[user] stops repairing \the [name]."),
			SPAN_NOTICE("You stop repairing \the [name]."))
		return

	user.visible_message(SPAN_NOTICE("[user] repairs \the [name]."),
		SPAN_NOTICE("You repair \the [name]."))

//determines whether something is in firing arc of a hardpoint
/obj/item/hardpoint/proc/in_firing_arc(var/atom/A)
	if(!owner)
		return FALSE

	if(!firing_arc)
		return TRUE

	var/turf/T = get_turf(A)
	if(!T)
		return FALSE

	var/dx = T.x - (owner.x + origins[1]/2)
	var/dy = T.y - (owner.y + origins[2]/2)

	var/deg = 0
	switch(dir)
		if(EAST)
			deg = 0
		if(NORTH)
			deg = -90
		if(WEST)
			deg = 180
		if(SOUTH)
			deg = 90

	var/nx = dx * cos(deg) - dy * sin(deg)
	var/ny = dx * sin(deg) + dy * cos(deg)
	if(nx == 0)
		return firing_arc >= 90

	var/angle = arctan(ny/nx)
	if(nx < 0)
		angle += 180

	return abs(angle) <= (firing_arc/2)

//doing last preparation before actually firing gun
/obj/item/hardpoint/proc/fire(var/mob/user, var/atom/A)
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]
	if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
		A = get_step(get_turf(A), pick(cardinal))

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)

	fire_projectile(user, A)

	to_chat(user, SPAN_WARNING("[name] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))

//finally firing the gun
/obj/item/hardpoint/proc/fire_projectile(var/mob/user, var/atom/A, var/iff_on = FALSE)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/obj/item/projectile/P = new(initial(name), user)
	P.loc = origin_turf
	P.generate_bullet(new ammo.default_ammo)
	if(iff_on && owner.seats[VEHICLE_GUNNER])
		P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, P.ammo.max_range, P.ammo.shell_speed, iff_group = owner.seats[VEHICLE_GUNNER].faction_group)
	else
		P.fire_at(A, owner.seats[VEHICLE_GUNNER], src, P.ammo.max_range, P.ammo.shell_speed)

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(owner, A))

	ammo.current_rounds--

//-----------------------------
//------ICON PROCS----------
//-----------------------------

//Returns an image for the hardpoint
/obj/item/hardpoint/proc/get_hardpoint_image()
	var/offset_x = 0
	var/offset_y = 0

	if(LAZYLEN(px_offsets))
		offset_x = px_offsets["[loc.dir]"][1]
		offset_y = px_offsets["[loc.dir]"][2]

	var/image/I = get_icon_image(offset_x, offset_y, dir)
	return I

//Returns the image object to overlay onto the root object
/obj/item/hardpoint/proc/get_icon_image(var/x_offset, var/y_offset, var/new_dir)
	var/icon_state_suffix = "0"
	if(health <= 0)
		icon_state_suffix = "1"
	return image(icon = disp_icon, icon_state = "[disp_icon_state]_[icon_state_suffix]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

/obj/item/hardpoint/attackby(var/obj/item/O, var/mob/user)
	if(iswelder(O) && health < initial(health))
		if(being_repaired)
			to_chat(user, SPAN_WARNING("You are already repairing the tank!"))
			return
		var/obj/item/tool/weldingtool/WT = O
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("You need to light \the [WT] first."))
			return
		if(WT.get_fuel() < 10)
			to_chat(user, SPAN_WARNING("You need to refill \the [WT] first."))
			return
		being_repaired = TRUE
		if(do_after(user, 8 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			WT.remove_fuel(10, user)
			health += round(0.10 * initial(health))
			health = Clamp(health, 0, initial(health))
			to_chat(user, SPAN_WARNING("You repair [name]. Integrity now at [round(get_integrity_percent())]%."))
		being_repaired = FALSE
		return
	..()

// debug proc
/obj/item/hardpoint/proc/set_offsets(var/dir, var/x, var/y)
	if(isnull(px_offsets))
		px_offsets = list(
			"1" = list(0, 0),
			"2" = list(0, 0),
			"4" = list(0, 0),
			"8" = list(0, 0)
		)
	px_offsets[dir] = list(x,y)

	owner.update_icon()

/obj/item/hardpoint/proc/muzzle_flash(var/angle)
	if(isnull(angle)) return

	// The +48 and +64 centers the muzzle flash
	var/muzzle_flash_x = muzzle_flash_pos["[dir]"][1] + 48
	var/muzzle_flash_y = muzzle_flash_pos["[dir]"][2] + 64

	// Account for turret rotation
	if(istype(loc, /obj/item/hardpoint/holder))
		var/obj/item/hardpoint/holder/H = loc
		if(LAZYLEN(H.px_offsets))
			muzzle_flash_x += H.px_offsets["[H.loc.dir]"][1]
			muzzle_flash_y += H.px_offsets["[H.loc.dir]"][2]

	var/image_layer = owner.layer + 0.1

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi',src,"muzzle_flash",image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Turn(angle)
	rotate.Translate(muzzle_flash_x, muzzle_flash_y)
	I.transform = rotate
	I.flick_overlay(owner, 3)

// debug proc
/obj/item/hardpoint/proc/set_mf_offset(var/dir, var/x, var/y)
	if(!muzzle_flash_pos)
		muzzle_flash_pos = list(
			"1" = list(0,0),
			"2" = list(0,0),
			"4" = list(0,0),
			"8" = list(0,0)
		)

	muzzle_flash_pos[dir] = list(x,y)

// debug proc
/obj/item/hardpoint/proc/set_mf_use_px(var/use)
	use_mz_px_offsets = use

// debug proc
/obj/item/hardpoint/proc/set_mf_use_trt(var/use)
	use_mz_trt_offsets = use