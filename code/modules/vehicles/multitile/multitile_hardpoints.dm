
//What to do if all ofthe installed modules have been broken
/obj/vehicle/multitile/proc/handle_all_modules_broken()
	return

/obj/vehicle/multitile/proc/deactivate_all_hardpoints()
	var/list/hps = get_activatable_hardpoints()
	for(var/obj/item/hardpoint/H in hps)
		H.deactivate()

/obj/vehicle/multitile/proc/remove_all_players()
	return

//Putting on hardpoints
//Similar to repairing stuff, down to the time delay
/obj/vehicle/multitile/proc/install_hardpoint(var/obj/item/O, var/mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
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

	user.visible_message(SPAN_NOTICE("[user] begins installing \the [HP] on the [HP.slot] hardpoint slot of \the [src]."),
		SPAN_NOTICE("You begin installing \the [HP] on the [HP.slot] hardpoint slot of \the [src]."))

	var/num_delays = 1

	switch(HP.slot)
		if(HDPT_PRIMARY) num_delays = 5
		if(HDPT_SECONDARY) num_delays = 3
		if(HDPT_SUPPORT) num_delays = 2
		if(HDPT_ARMOR) num_delays = 10
		if(HDPT_TREADS || HDPT_WHEELS) num_delays = 7

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays))
		user.visible_message(SPAN_WARNING("[user] stops installing \the [HP] on \the [src]."), SPAN_WARNING("You stop installing \the [HP] on \the [src]."))
		return

	user.visible_message(SPAN_NOTICE("[user] installs \the [HP] on \the [src]."), SPAN_NOTICE("You install \the [HP] on \the [src]."))

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		PC.loaded.forceMove(src)
		PC.loaded = null
		playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
		PC.update_icon()
	else
		user.temp_drop_inv_item(HP, 0)

	add_hardpoint(HP, user)

//User-orientated proc for taking of hardpoints
//Again, similar to the above ones
/obj/vehicle/multitile/proc/uninstall_hardpoint(var/obj/item/O, var/mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		if(!PC.linked_powerloader || PC.loaded)
			return

	var/list/hps = list()
	for(var/obj/item/hardpoint/H in get_hardpoints())
		// Only allow uninstalls of massive hardpoints when using powerloaders
		if(H.w_class == SIZE_MASSIVE && !ispowerclamp(O) || H.w_class <= SIZE_HUGE && ispowerclamp(O))
			continue
		hps += H

	var/chosen_hp = input("Select a hardpoint to remove") in (hps + "Cancel")
	if(chosen_hp == "Cancel")
		return
	var/obj/item/hardpoint/old = chosen_hp

	if(!old)
		to_chat(user, SPAN_WARNING("There is nothing installed there."))
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
		if(HDPT_PRIMARY) num_delays = 5
		if(HDPT_SECONDARY) num_delays = 3
		if(HDPT_SUPPORT) num_delays = 2
		if(HDPT_ARMOR) num_delays = 10
		if(HDPT_TREADS) num_delays = 7

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays))
		user.visible_message(SPAN_WARNING("[user] stops removing \the [old] on \the [src]."), SPAN_WARNING("You stop removing \the [old] on \the [src]."))
		return

	user.visible_message(SPAN_NOTICE("[user] removes \the [old] on \the [src]."), SPAN_NOTICE("You remove \the [old] on \the [src]."))

	remove_hardpoint(old, user)

	if(old.disposed)
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		old.forceMove(PC.linked_powerloader)
		PC.loaded = old
		playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
		PC.update_icon()
		to_chat(user, SPAN_NOTICE("You grab [PC.loaded] with [PC]."))
		old.update_icon()

	if(old.slot == HDPT_TREADS && clamped)
		detach_clamp(user)

//General proc for putting on hardpoints
//ALWAYS CALL THIS WHEN ATTACHING HARDPOINTS
/obj/vehicle/multitile/proc/add_hardpoint(var/obj/item/hardpoint/HP, var/mob/user)
	HP.owner = src
	HP.loc = src
	hardpoints += HP

	HP.on_install(src)
	HP.rotate(turning_angle(HP.dir, dir))

	update_icon()

//General proc for taking off hardpoints
//ALWAYS CALL THIS WHEN REMOVING HARDPOINTS
/obj/vehicle/multitile/proc/remove_hardpoint(var/obj/item/hardpoint/old, var/mob/user)
	if(!(old in hardpoints))
		return

	if(user)
		old.loc = get_turf(user)
	else
		old.loc = get_turf(src)

	old.on_uninstall(src)
	old.reset_rotation()
	hardpoints -= old
	old.owner = null

	if(old.health <= 0)
		qdel(old)

	update_icon()

//proc that fires non selected weaponry
/obj/vehicle/multitile/proc/shoot_other_weapon(var/mob/living/carbon/human/M, var/seat, var/atom/A)

	if(!istype(M))
		return

	var/list/usable_hps = get_activatable_hardpoints()
	for(var/obj/item/hardpoint/HP in usable_hps)
		if(HP == active_hp[seat] || HP.slot != HDPT_PRIMARY && HP.slot != HDPT_SECONDARY)
			usable_hps.Remove(HP)

	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("No other working weapons detected."))
		return

	for(var/obj/item/hardpoint/HP in usable_hps)
		if(!HP.can_activate(M, A))
			return
		HP.activate(M, A)
		break
	return

//proc that activates support module if it can be activated and you meet requirements
/obj/vehicle/multitile/proc/activate_support_module(var/mob/living/carbon/human/M, var/seat, var/atom/A)

	if(!istype(M))
		return

	var/list/usable_hps = get_activatable_hardpoints()
	for(var/obj/item/hardpoint/HP in usable_hps)
		if(HP.slot != HDPT_SUPPORT)
			usable_hps.Remove(HP)

	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("No activatable support modules detected."))
		return

	for(var/obj/item/hardpoint/HP in usable_hps)
		if(!HP.can_activate(M, A))
			return
		HP.activate(M, A)
		break
	return