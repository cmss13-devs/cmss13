/datum/cooking_surface/ice_cream_mixer
	cooker_id = COOKER_SURFACE_ICE_CREAM_MIXER
	allow_temp_change = FALSE

/obj/structure/machinery/cooking/ice_cream_mixer
	name = "ice cream mixer"
	desc = "An industrial mixing device for desserts of all kinds."
	icon_state = "ice_cream_mixer"
	active_power_usage = 200
	allowed_containers = list(
		/obj/item/reagent_container/cooking/icecream_bowl
	)

/obj/structure/machinery/cooking/ice_cream_mixer/Initialize(mapload)
	. = ..()
	surfaces += new /datum/cooking_surface/ice_cream_mixer(src)
	update_icon()

/obj/structure/machinery/cooking/ice_cream_mixer/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("<b>Ctrl-Click</b> to set its timer and toggle it on or off.")

/obj/structure/machinery/cooking/ice_cream_mixer/clickpos_to_surface(modifiers)
	return 1

/obj/structure/machinery/cooking/ice_cream_mixer/attack_hand(mob/user)
	var/datum/cooking_surface/surface = surfaces[1]
	if(!surface.container)
		return

	if(surface.on)
		to_chat(user, SPAN_NOTICE("\The [src] must be off to retrieve its contents."))
		return

	user.put_in_hands(surface.container)
	surface.UnregisterSignal(surface.container, COMSIG_PARENT_EXAMINE)
	surface.container = null
	update_icon()

/obj/structure/machinery/cooking/ice_cream_mixer/add_to_visible(obj/item/reagent_container/cooking/container, surface_idx)
	container.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	container.make_mini()
	vis_contents += container

/obj/structure/machinery/cooking/ice_cream_mixer/update_surface_icon(surface_idx)
	var/datum/cooking_surface/surface = surfaces[1]
	if(surface.container)
		surface.container.pixel_x = 0
		surface.container.pixel_y = 2
		add_to_visible(surface.container, surface_idx)

/obj/structure/machinery/cooking/ice_cream_mixer/update_icon()
	. = ..()
	var/datum/cooking_surface/surface = surfaces[1]
	if(surface.on)
		. += image(icon = icon, icon_state = "ice_cream_mixer_door", layer = ABOVE_OBJ_LAYER)
		. += image(icon = icon, icon_state = "ice_cream_mixer_on")
	else
		. += image(icon = icon, icon_state = "ice_cream_mixer_door_open", layer = ABOVE_OBJ_LAYER)
