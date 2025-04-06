// Returns all hardpoints that are attached to the vehicle, including ones held by holder hardpoints (e.g. turrets)
/obj/vehicle/multitile/proc/get_hardpoints_copy()
	var/list/all_hardpoints = hardpoints.Copy()
	for(var/obj/item/hardpoint/holder/H in all_hardpoints)
		if(!H.hardpoints)
			continue
		all_hardpoints += H.hardpoints.Copy()

	return all_hardpoints

//Returns all activatable hardpoints
/obj/vehicle/multitile/proc/get_activatable_hardpoints(seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H
			if(HP.hardpoints)
				hps += HP.get_activatable_hardpoints(seat)
		if(!H.is_activatable() || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

//Returns hardpoints that use ammunition
/obj/vehicle/multitile/proc/get_hardpoints_with_ammo(seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H
			if(HP.hardpoints)
				hps += HP.get_hardpoints_with_ammo(seat)
		if(!H.ammo || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

// Returns a hardpoint by its name
/obj/vehicle/multitile/proc/find_hardpoint(name)
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H

			var/obj/item/hardpoint/nested_hp = HP.find_hardpoint(name)
			if(nested_hp)
				return nested_hp

		if(H.name == name)
			return H
	return null

//What to do if all ofthe installed modules have been broken
/obj/vehicle/multitile/proc/handle_all_modules_broken()
	return

/obj/vehicle/multitile/proc/deactivate_all_hardpoints()
	var/list/hps = get_activatable_hardpoints()
	for(var/obj/item/hardpoint/H in hps)
		H.deactivate()

/obj/vehicle/multitile/proc/remove_all_players()
	return

/obj/vehicle/multitile/proc/can_install_hardpoint(obj/item/hardpoint/hardpoint, mob/user)
	return TRUE

//Putting on hardpoints
//Similar to repairing stuff, down to the time delay
/obj/vehicle/multitile/proc/install_hardpoint(obj/item/O, mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You don't know what to do with [O] on \the [src]."))
		return

	var/obj/item/hardpoint/HP = O
	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		HP = PC.loaded

	for(var/obj/item/hardpoint/holder/H in hardpoints)
		// Attempt to install on holder hardpoints first
		if(H.can_install(HP))
			H.install(HP, user)
			update_icon()
			return

	if(health < initial(health) * 0.75)
		to_chat(user, SPAN_WARNING("All the mounting points on \the [src] are broken!"))
		return

	if(LAZYLEN(hardpoints))
		for(var/obj/item/hardpoint/H in hardpoints)
			if(HP.slot == H.slot)
				to_chat(user, SPAN_WARNING("There is already something installed there!"))
				return

	if(!(HP.type in hardpoints_allowed))
		to_chat(user, SPAN_WARNING("You don't know what to do with [HP] on \the [src]."))
		return

	if(!can_install_hardpoint(O, user))
		return

	user.visible_message(SPAN_NOTICE("[user] begins installing \the [HP] on the [HP.slot] hardpoint slot of \the [src]."),
		SPAN_NOTICE("You begin installing \the [HP] on the [HP.slot] hardpoint slot of \the [src]."))

	var/num_delays = 1

	switch(HP.slot)
		if(HDPT_PRIMARY)
			num_delays = 5
		if(HDPT_SECONDARY)
			num_delays = 3
		if(HDPT_SUPPORT)
			num_delays = 2
		if(HDPT_ARMOR)
			num_delays = 10
		if(HDPT_TREADS, HDPT_WHEELS)
			num_delays = 7

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays))
		user.visible_message(SPAN_WARNING("[user] stops installing \the [HP] on \the [src]."), SPAN_WARNING("You stop installing \the [HP] on \the [src]."))
		return

	if(!can_install_hardpoint(O, user))
		return

	//check to prevent putting two modules on same slot
	for(var/obj/item/hardpoint/H in hardpoints)
		if(HP.slot == H.slot)
			to_chat(user, SPAN_WARNING("There is already something installed there!"))
			return

	user.visible_message(SPAN_NOTICE("[user] installs \the [HP] on \the [src]."), SPAN_NOTICE("You install \the [HP] on \the [src]."))

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		PC.loaded.forceMove(src)
		to_chat(user, SPAN_NOTICE("You install \the [PC.loaded] on \the [src] with \the [PC]."))
		PC.loaded = null
		playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
		PC.update_icon()
	else
		user.temp_drop_inv_item(HP, 0)

	add_hardpoint(HP, user)

//User-orientated proc for taking of hardpoints
//Again, similar to the above ones
/obj/vehicle/multitile/proc/uninstall_hardpoint(obj/item/O, mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		if(!PC.linked_powerloader || PC.loaded)
			return

	var/list/hps = list()
	for(var/obj/item/hardpoint/H in get_hardpoints_copy())
		// Only allow uninstalls of massive hardpoints when using powerloaders
		if(H.w_class == SIZE_MASSIVE && !ispowerclamp(O) || H.w_class <= SIZE_HUGE && ispowerclamp(O) || istype(H, /obj/item/hardpoint/special))
			continue
		hps += H

	var/chosen_hp = tgui_input_list(usr, "Select a hardpoint to remove", "Hardpoint Removal", (hps + "Cancel"))
	if(chosen_hp == "Cancel" || !chosen_hp || (get_dist(src, user) > 2)) //get_dist uses 2 because the vehicle is 3x3
		return

	var/obj/item/hardpoint/old = chosen_hp

	if(!old)
		to_chat(user, SPAN_WARNING("There is nothing installed there."))
		return

	if(!old.can_be_removed(user))
		return
	// It's in a holder
	if(!(old in hardpoints))
		for(var/obj/item/hardpoint/holder/H in hardpoints)
			if(old in H.hardpoints)
				H.uninstall(old, user)
				update_icon()
				return

	user.visible_message(SPAN_NOTICE("[user] begins removing [old] on the [old.slot] hardpoint slot on \the [src]."),
		SPAN_NOTICE("You begin removing [old] on the [old.slot] hardpoint slot on \the [src]."))

	var/num_delays = 1

	switch(old.slot)
		if(HDPT_PRIMARY)
			num_delays = 5
		if(HDPT_SECONDARY)
			num_delays = 3
		if(HDPT_SUPPORT)
			num_delays = 2
		if(HDPT_ARMOR)
			num_delays = 10
		if(HDPT_TREADS)
			num_delays = 7

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays, target_flags = INTERRUPT_DIFF_LOC, target = old))
		user.visible_message(SPAN_WARNING("[user] stops removing \the [old] on \the [src]."), SPAN_WARNING("You stop removing \the [old] on \the [src]."))
		return

	user.visible_message(SPAN_NOTICE("[user] removes \the [old] on \the [src]."), SPAN_NOTICE("You remove \the [old] on \the [src]."))

	remove_hardpoint(old, user)

	if(QDELETED(old))
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		PC.grab_object(user, old, "vehicle_module")
		PC.loaded.update_icon()

	if(old.slot == HDPT_TREADS && clamped)
		detach_clamp(user)

//General proc for putting on hardpoints
//ALWAYS CALL THIS WHEN ATTACHING HARDPOINTS
/obj/vehicle/multitile/proc/add_hardpoint(obj/item/hardpoint/HP, mob/user)
	HP.owner = src
	HP.forceMove(src)
	hardpoints += HP

	HP.on_install(src)
	HP.rotate(turning_angle(HP.dir, dir))

	update_icon()

//General proc for taking off hardpoints
//ALWAYS CALL THIS WHEN REMOVING HARDPOINTS
/obj/vehicle/multitile/proc/remove_hardpoint(obj/item/hardpoint/old, mob/user)
	if(!(old in hardpoints))
		return

	if(user)
		old.forceMove(get_turf(user))
	else
		old.forceMove(get_turf(src))

	old.on_uninstall(src)
	old.reset_rotation()
	hardpoints -= old
	old.owner = null

	if(old.health <= 0 && !old.gc_destroyed) // Make sure it's not already being deleted.
		visible_message(SPAN_WARNING("\The [src] disintegrates into useless pile of scrap under the damage it suffered."))
		qdel(old)

	update_icon()
