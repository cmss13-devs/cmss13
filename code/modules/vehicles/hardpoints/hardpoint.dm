/*
	Hardpoints are any items that attach to a base vehicle, such as wheels/treads, support systems and guns
*/

/obj/item/hardpoint
	// Which slot is this hardpoint in
	// Purely to check for conflicting hardpoints
	var/slot
	// The vehicle this hardpoint is installed on
	var/obj/vehicle/multitile/owner

	icon = 'icons/obj/vehicles/hardpoints/tank.dmi'
	icon_state = "tires" //Placeholder

	health = 100
	w_class = SIZE_LARGE

	// Determines how much of any incoming damage is actually taken
	var/damage_multiplier = 1

	//Strings, used to get the overlay for the armored vic
	var/disp_icon //This also differentiates tank vs apc vs other
	var/disp_icon_state

	var/activatable = 0

	// Cooldown on use of the hardpoint
	var/cooldown = 100
	var/next_use = 0

	var/point_cost

	var/being_repaired = FALSE // to prevent welder click spam
	var/user

	// Origin coords of the hardpoint relative to the vehicle
	var/list/origins = list(0, 0)
	// List of pixel offsets for each direction
	var/list/px_offsets

	var/hdpt_layer = HDPT_LAYER_WHEELS

/obj/item/hardpoint/Destroy()
	if(owner)
		owner.remove_hardpoint(src)
		owner.update_icon()
		owner = null
	. = ..()

/obj/item/hardpoint/proc/take_damage(var/damage)
	health = max(0, health - damage * damage_multiplier)

//If the hardpoint can be activated
/obj/item/hardpoint/proc/can_activate(var/mob/user, var/atom/A)
	if(!owner)
		return

	if(world.time < next_use)
		to_chat(usr, SPAN_WARNING("\The [src] is not ready to be used yet. It indicates that it is ready to use in [(next_use - world.time) / 10] seconds."))
		return FALSE
	if(health <= 0)
		to_chat(usr, SPAN_WARNING("\The [src] is broken!"))
		return FALSE
	// commented because debug. un-comment before merge
	//if(owner.z == 2 || owner.z == 3)
	//	to_chat(usr, SPAN_WARNING("\The [src] refuses to fire as it's locked by an IFF restrictor!"))
	//	return FALSE
	return TRUE

//Called when you want to activate the hardpoint, such as a gun
//This can also be used for some type of temporary buff, up to you
/obj/item/hardpoint/proc/activate(var/mob/user, var/atom/A)
	next_use = world.time + cooldown

/obj/item/hardpoint/proc/deactivate()
	return

/obj/item/hardpoint/proc/livingmob_interact(var/mob/living/M)
	return

/obj/item/hardpoint/proc/on_install(var/obj/vehicle/multitile/V)
	return

/obj/item/hardpoint/proc/on_uninstall(var/obj/vehicle/multitile/V)
	return

/obj/item/hardpoint/proc/on_move(var/turf/old, var/turf/new_turf, var/move_dir)
	return

//The integrity of the hardpoint module
/obj/item/hardpoint/proc/get_integrity_percent()		// return % charge of cell
	return 100.0*health/initial(health)

/obj/item/hardpoint/proc/is_activatable()
	if(health <= 0)
		return FALSE
	return activatable

/obj/item/hardpoint/examine(mob/user, var/integrity_only = null)
	if(!integrity_only)
		..()
	if(health <= 0)
		to_chat(user, "It's busted!")
	else if(isobserver(user) || (ishuman(user) && skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI)))
		to_chat(user, "It's at [round(get_integrity_percent(), 1)]% integrity!")

//for status window
/obj/item/hardpoint/proc/get_hardpoint_info()
	var/dat = "<hr>"
	dat += "[name]<br>"
	dat += "Integrity: [health <= 0 ? "<font color=\"red\">\[DESTROYED\]</font>" : "[round(get_integrity_percent())]%"]"
	return dat

// Returns an image for the hardpoint
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
			to_chat(user, SPAN_WARNING("You repair [src]. Integrity now at [round(get_integrity_percent())]%."))
		being_repaired = FALSE
		return
	..()

/obj/item/hardpoint/proc/repair(var/obj/item/O, var/mob/user)
	if(health > 0)
		to_chat(user, SPAN_NOTICE("\The [src] doesn't require any critical repairs."))
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

	user.visible_message(SPAN_NOTICE("[user] starts repairing \the [src]."),
		SPAN_NOTICE("You start repairing \the [src]."))

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays))
		user.visible_message(SPAN_NOTICE("[user] stops repairing \the [src]."),
			SPAN_NOTICE("You stop repairing \the [src]."))
		return

	if(!Adjacent(user))
		user.visible_message(SPAN_NOTICE("[user] stops repairing \the [src]."),
			SPAN_NOTICE("You stop repairing \the [src]."))
		return

	user.visible_message(SPAN_NOTICE("[user] repairs \the [src]."),
		SPAN_NOTICE("You repair \the [src]."))

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
