/obj/vehicle/multitile/van/flatbed
	name = "flatbed truck"
	desc = "A state-of-the-art military-grade flatbed truck, used by the Colonial Marines to transport materials across vast distances."

	icon = 'icons/obj/vehicles/flatbed.dmi'
	icon_state = "flatbed_truck"

	interior_map = "flatbed"
	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0)
	)

	passengers_slots = 2

	var/list/flatbed_entrances = list(
		"back_left" = list(1, 2),
		"back_right" = list(0, 2)
	)
	var/obj/structure/container/loaded_container
	var/image/container_overlay

/obj/vehicle/multitile/van/flatbed/Initialize()
	. = ..()
	container_overlay = image(icon, null, "container")

/obj/vehicle/multitile/van/flatbed/Destroy()
	if(loaded_container)
		loaded_container.forceMove(loc)
	return ..()

/obj/vehicle/multitile/van/flatbed/update_icon()
	. = ..()
	if(loaded_container)
		overlays += container_overlay

/obj/vehicle/multitile/van/flatbed/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/powerloader_clamp))
		var/mob_x = user.x - src.x
		var/mob_y = user.y - src.y
		var/correctly_positioned = FALSE
		for(var/entrance in flatbed_entrances)
			var/entrance_coord = flatbed_entrances[entrance]
			if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
				correctly_positioned = TRUE
		if(!correctly_positioned)
			to_chat(user, SPAN_WARNING("You can't reach the flatbed from there. Try the back."))
			return
		var/obj/item/powerloader_clamp/clamp = O
		var/obj/item/powerloader_clamp/offhand_clamp = user.get_inactive_hand()
		if(loaded_container)
			if(clamp.loaded)
				to_chat(user, SPAN_WARNING("\The [src] already has a container loaded!"))
				return
			if(offhand_clamp.loaded)
				to_chat(user, SPAN_WARNING("Both clamps need to be empty before you can offload a container!"))
				return
			clamp.grab_object(loaded_container, "container")
			offhand_clamp.loaded = loaded_container
			offhand_clamp.update_icon("container")
			user.visible_message(SPAN_NOTICE("[user] unloads \the [loaded_container] from the back of \the [src]."), SPAN_NOTICE("You unload \the [loaded_container] from the back of \the [src]."))
			loaded_container = null
			update_icon()
		else
			if(!clamp.loaded)
				return
			if(!istype(clamp.loaded, /obj/structure/container))
				to_chat(user, SPAN_WARNING("\The [src] can only haul packaged containers."))
				return
			loaded_container = clamp.loaded
			clamp.loaded.forceMove(src)
			clamp.loaded = null
			clamp.update_icon()
			offhand_clamp.loaded = null
			offhand_clamp.update_icon()
			update_icon()
			user.visible_message(SPAN_NOTICE("[user] loads \the [loaded_container] onto the back of \the [src]."), SPAN_NOTICE("You load \the [loaded_container] onto the back of \the [src]."))
		return TRUE
	return ..()

/obj/vehicle/multitile/van/flatbed/rotate_entrances(var/deg)
	. = ..()
	flatbed_entrances = rotate_origins(deg, flatbed_entrances)
