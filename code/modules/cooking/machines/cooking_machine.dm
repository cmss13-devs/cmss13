/obj/structure/machinery/cooking
	name = "Default Cooking Appliance"
	desc = "You shouldn't be seeing this. Please report this as an issue on GitHub."
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	idle_power_usage = 5
	active_power_usage = 100

	var/cooking = FALSE
	var/quality_mod = 1
	var/list/allowed_containers
	var/list/surfaces = list()

/obj/structure/machinery/cooking/Destroy()
	surfaces = list()

	return ..()

/obj/structure/machinery/cooking/process()
	for(var/datum/cooking_surface/surface in surfaces)
		if(surface.on)
			surface.handle_cooking(null)

	use_power(active_power_usage)

/obj/structure/machinery/cooking/proc/any_surface_active()
	for(var/datum/cooking_surface/surface in surfaces)
		if(surface.on)
			return TRUE

/obj/structure/machinery/cooking/clicked(mob/user, list/modifiers)
	if(modifiers[SHIFT_CLICK])
		var/surface_idx = clickpos_to_surface(modifiers)
		if(!surface_idx)
			return ..()

		var/datum/cooking_surface/surface = surfaces[surface_idx]
		if(surface.container)
			return surface.container.clicked(user, modifiers)

		return ..()

	if(modifiers[CTRL_CLICK])
		if(user.stat || user.is_mob_restrained() || (!in_range(src, user)) || HAS_TRAIT(user, TRAIT_INCAPACITATED)) //TRAIT_HANDS_BLOCKED got nuked at some point apparently?
			return

		if(!anchored)
			return ..()

		var/surface_idx = clickpos_to_surface(modifiers)
		if(!surface_idx)
			return
		var/datum/cooking_surface/surface = surfaces[surface_idx]

		var/list/surface_options = list(
			RADIAL_ACTION_SET_ALARM = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_setalarm"),
			RADIAL_ACTION_ON_OFF = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_onoff"),
		)
		if(surface.allow_temp_change)
			surface_options[RADIAL_ACTION_SET_TEMPERATURE] = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_settemp")
		var/option_choice = show_radial_menu(user, src, surface_options, require_near = TRUE)

		switch(option_choice)
			if(RADIAL_ACTION_SET_ALARM)
				surface.handle_timer(user)
			if(RADIAL_ACTION_SET_TEMPERATURE)
				surface.handle_temperature(user)
			if(RADIAL_ACTION_ON_OFF)
				update_icon()

	if(modifiers[ALT_CLICK])
		if(user.stat || user.is_mob_restrained() || (!in_range(src, user)) || HAS_TRAIT(user, TRAIT_INCAPACITATED))
			return

		var/input = clickpos_to_surface(modifiers)
		var/datum/cooking_surface/burner = surfaces[input]
		if(!burner)
			return

		var/obj/item/reagent_container/cooking/container = burner.container
		if(!(istype(container)))
			return

		container.do_empty(user)
		burner.unset_callbacks()

/// Retrieve which burning surface on the machine is being accessed.
/obj/structure/machinery/cooking/proc/clickpos_to_surface(modifiers)
	return

/obj/structure/machinery/cooking/attackby(obj/item/used, mob/living/user, list/modifiers)
	var/input = clickpos_to_surface(modifiers)
	if(input)
		var/datum/cooking_surface/surface = surfaces[input]
		return surface_item_interaction(user, used, surface)

	return ..()

/obj/structure/machinery/cooking/proc/surface_item_interaction(mob/living/user, obj/item/used, datum/cooking_surface/surface)
	if(surface.container)
		surface.container.attackby(user, used)
		return

	for(var/allowed_container_type in allowed_containers)
		if(istype(used, allowed_container_type))
			if(ismob(user))
				to_chat(user, "<span class='notice'>You put [used] on [src].</span>")
				if(user.drop_held_item(used))
					used.forceMove(src)
			else
				used.forceMove(src)

			surface.container = used
			surface.prob_quality_decrease = 0
			surface.RegisterSignal(used, COMSIG_PARENT_EXAMINE, TYPE_PROC_REF(/datum/cooking_surface, container_examine), override = TRUE)
			if(surface.on)
				surface.reset_cooktime()

	update_icon()
	return

/obj/structure/machinery/cooking/proc/add_to_visible(obj/item/reagent_container/cooking/container, surface_idx)
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/structure/machinery/cooking/proc/remove_from_visible(obj/item/reagent_container/cooking/container, input)
	container.vis_flags = 0
	container.blend_mode = 0
	container.transform =  null
	container.appearance_flags &= PIXEL_SCALE
	container.unmake_mini()
	vis_contents.Remove(container)

/obj/structure/machinery/cooking/update_icon(updates)
	cooking = FALSE
	for(var/datum/cooking_surface/surface in surfaces)
		if(surface.on)
			cooking = TRUE

	. = ..()
	for(var/obj/item/our_item in vis_contents)
		remove_from_visible(our_item)

	for(var/i in 1 to length(surfaces))
		update_surface_icon(i)

/obj/structure/machinery/cooking/proc/update_surface_icon(surface_idx)
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/structure/machinery/cooking/power_change()
	. = ..()
	if(stat & NOPOWER)
		machine_state_change()

/obj/structure/machinery/cooking/proc/machine_state_change()
	for(var/datum/cooking_surface/surface in surfaces)
		if(surface.on)
			surface.turn_off()
			var/obj/item/reagent_container/cooking/container = surface.container
			if(istype(container) && container.tracker)
				SEND_SIGNAL(container, COMSIG_COOK_MACHINE_STEP_INTERRUPTED, surface)
