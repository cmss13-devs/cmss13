/obj/item/hardpoint/holder
	name = "holder hardpoint"
	desc = "i hold other hardpoints :)"

	// List of types of hardpoints that this hardpoint can hold
	var/list/accepted_hardpoints

	// List of held hardpoints
	var/list/hardpoints

/obj/item/hardpoint/holder/Destroy()
	if(LAZYLEN(hardpoints))
		for(var/obj/item/hardpoint/H in hardpoints)
			qdel(H)
			hardpoints -= H
		hardpoints = null

	. = ..()

/obj/item/hardpoint/holder/update_icon()
	overlays.Cut()
	for(var/obj/item/hardpoint/H in hardpoints)
		var/image/I = H.get_hardpoint_image()
		overlays += I

/obj/item/hardpoint/holder/examine(var/mob/user)
	for(var/obj/item/hardpoint/H in hardpoints)
		to_chat(user, "There is a [H] module installed on \the [src].")
		H.examine(user, TRUE)

/obj/item/hardpoint/holder/get_hardpoint_info()
	..()
	var/dat = ""
	for(var/obj/item/hardpoint/H in hardpoints)
		dat += H.get_hardpoint_info()
	return dat

/obj/item/hardpoint/holder/take_damage(var/damage)
	..()

	for(var/obj/item/hardpoint/H in hardpoints)
		H.take_damage(damage)

/obj/item/hardpoint/holder/on_install(var/obj/vehicle/multitile/V)
	for(var/obj/item/hardpoint/HP in hardpoints)
		HP.owner = V
	return

/obj/item/hardpoint/holder/proc/can_install(var/obj/item/hardpoint/H)
	// Can only have 1 hardpoint of each slot type
	if(LAZYLEN(hardpoints))
		for(var/obj/item/hardpoint/HP in hardpoints)
			if(HP.slot == H.slot)
				return FALSE
	// Must be accepted by the holder
	return LAZYISIN(accepted_hardpoints, H.type)

/obj/item/hardpoint/holder/proc/install(var/obj/item/hardpoint/H, var/mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("All the mounting points on \the [src] are broken!"))
		return

	user.visible_message(SPAN_NOTICE("[user] begins installing \the [H] on the [H.slot] hardpoint slot of \the [src]."),
		SPAN_NOTICE("You begin installing \the [H] on the [H.slot] hardpoint slot of \the [src]."))
	if(!do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		user.visible_message(SPAN_WARNING("[user] stops installing \the [H] on \the [src]."), SPAN_WARNING("You stop installing \the [H] on \the [src]."))
		return

	user.temp_drop_inv_item(H, 0)
	add_hardpoint(H)

	update_icon()

/obj/item/hardpoint/holder/proc/uninstall(var/obj/item/hardpoint/H, var/mob/user)
	if(!LAZYISIN(hardpoints, H))
		return

	user.visible_message(SPAN_NOTICE("[user] begins removing \the [H] from the [H.slot] hardpoint slot of \the [src]."),
		SPAN_NOTICE("You begin removing \the [H] from the [H.slot] hardpoint slot of \the [src]."))
	if(!do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		user.visible_message(SPAN_WARNING("[user] stops removing \the [H] from \the [src]."), SPAN_WARNING("You stop removing \the [H] from \the [src]."))
		return

	remove_hardpoint(H, get_turf(user))

	update_icon()

/obj/item/hardpoint/holder/attackby(var/obj/item/O, var/mob/user)
	if(iscrowbar(O))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
			return

		var/chosen_hp = input("Select a hardpoint to remove") in (hardpoints + "Cancel")
		if(chosen_hp == "Cancel")
			return
		var/obj/item/hardpoint/old = chosen_hp

		uninstall(old, user)
		return

	if(istype(O, /obj/item/hardpoint))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
			return

		var/obj/item/hardpoint/H = O
		if(!(H.type in accepted_hardpoints))
			to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
			return

		install(H, user)
		return

	..()

/obj/item/hardpoint/holder/proc/add_hardpoint(var/obj/item/hardpoint/H)
	H.owner = owner
	H.loc = src
	LAZYADD(hardpoints, H)

	H.rotate(turning_angle(H.dir, dir))

/obj/item/hardpoint/holder/proc/remove_hardpoint(var/obj/item/hardpoint/H, var/turf/uninstall_to)
	if(!hardpoints)
		return
	hardpoints -= H
	H.loc = uninstall_to ? uninstall_to : get_turf(src)

	H.reset_rotation()

	H.owner = null

	if(H.health <= 0)
		qdel(H)

/obj/item/hardpoint/holder/proc/get_activatable_hardpoints()
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(!H.is_activatable())
			continue
		hps += H
	return hps

/obj/item/hardpoint/holder/proc/find_hardpoint(var/name)
	for(var/obj/item/hardpoint/H in hardpoints)
		if(H.name == name)
			return H
	return null

// Modified to return a list of all images tied to the holder
/obj/item/hardpoint/holder/get_hardpoint_image()
	var/image/I = ..()
	var/list/images = list(I)
	for(var/obj/item/hardpoint/H in hardpoints)
		var/image/HI = H.get_hardpoint_image()
		if(LAZYLEN(px_offsets))
			HI.pixel_x += px_offsets["[loc.dir]"][1]
			HI.pixel_y += px_offsets["[loc.dir]"][2]
		images += HI
	return images

/obj/item/hardpoint/holder/rotate(var/deg)
	for(var/obj/item/hardpoint/H in hardpoints)
		H.rotate(deg)

	..()
