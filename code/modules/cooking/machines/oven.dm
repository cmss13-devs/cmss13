/datum/cooking_surface/oven
	cooker_id = COOKER_SURFACE_OVEN

/datum/cooking_surface/oven/handle_switch(mob/user)
	var/obj/structure/machinery/cooking/oven/oven = parent
	if(istype(oven))
		if(!on && oven.opened)
			to_chat(user, SPAN_NOTICE("The oven must be closed in order to turn it on."))
			return

	return ..()

// TODO: add back special attack for oven for v2
// Yes, that's a v2 thing, I'm not doing it right now
/obj/structure/machinery/cooking/oven
	name = "oven"
	desc = "A cozy oven for baking food."
	icon_state = "oven"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	cooking = FALSE
	var/opened = FALSE

	var/on_fire = FALSE //if the oven has caught fire or not.
	allowed_containers = list(
		/obj/item/reagent_container/cooking/oven
	)

/obj/structure/machinery/cooking/oven/Initialize(mapload)
	. = ..()

	surfaces += new /datum/cooking_surface/oven(src)
	update_icon()

/obj/structure/machinery/cooking/oven/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("<b>Ctrl-Click</b> to set its timer, temperature, and toggle it on or off.")

/obj/structure/machinery/cooking/oven/attackby(obj/item/used, mob/living/user, list/modifiers)
	if(!opened)
		handle_open(user)
		update_icon()
		return

	return ..()

/obj/structure/machinery/cooking/oven/attack_hand(mob/user as mob, params)
	var/input = clickpos_to_surface(params2list(params))

	// If we didn't click on the door, toggle it.
	if(!input)
		handle_open(user)
		return

	var/datum/cooking_surface/surface = surfaces[input]
	if(surface && surface.container && opened)
		user.put_in_hands(surface.container)
		surface.UnregisterSignal(surface.container, COMSIG_PARENT_EXAMINE)
		surface.container = null
		update_icon()
	else
		handle_open(user)

/obj/structure/machinery/cooking/oven/clicked(mob/user, list/modifiers)
	if(modifiers[ALT_CLICK])
		if(user.stat || user.is_mob_restrained() || (!in_range(src, user)))
			return

		if(!opened)
			to_chat(user, SPAN_NOTICE("The oven must be open to retrieve the food."))
			return

		return ..()

/obj/structure/machinery/cooking/oven/proc/handle_open(mob/user)
	if(opened)
		opened = FALSE
	else
		opened = TRUE
		var/datum/cooking_surface/surface = surfaces[1]
		if(surface.on)
			surface.handle_switch(user)

	update_icon()

#define ICON_SPLIT_X_1 5
#define ICON_SPLIT_X_2 28
#define ICON_SPLIT_Y_1 5
#define ICON_SPLIT_Y_2 20

/obj/structure/machinery/cooking/oven/clickpos_to_surface(modifiers)
	var/icon_x = text2num(modifiers["icon-x"])
	var/icon_y = text2num(modifiers["icon-y"])
	if(icon_x >= ICON_SPLIT_X_1 && icon_x <= ICON_SPLIT_X_2 && icon_y >= ICON_SPLIT_Y_1 && icon_y <= ICON_SPLIT_Y_2)
		return 1

#undef ICON_SPLIT_X_1
#undef ICON_SPLIT_X_2
#undef ICON_SPLIT_Y_1
#undef ICON_SPLIT_Y_2

/obj/structure/machinery/cooking/oven/update_surface_icon(surface_idx)
	var/datum/cooking_surface/surface = surfaces[1]
	if(surface.container)
		surface.container.pixel_x = 0
		surface.container.pixel_y = -2
		add_to_visible(surface.container)

/obj/structure/machinery/cooking/oven/update_icon()
	. = ..()
	if(opened)
		. += image(icon, icon_state = "oven_hatch_open", layer = ABOVE_OBJ_LAYER)
	else
		var/datum/cooking_surface/surface = surfaces[1]
		. += image(icon, icon_state = "oven_hatch[surface.on ? "_on" : ""]", layer = ABOVE_OBJ_LAYER)

/obj/structure/machinery/cooking/oven/add_to_visible(obj/item/reagent_container/cooking/container, surface_idx)
	container.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	container.make_mini()
	vis_contents += container
