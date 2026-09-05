/datum/cooking_surface/deepfryer_basin
	cooker_id = COOKER_SURFACE_DEEPFRYER
	allow_temp_change = FALSE

// TODO: add back special attack for deep fryer for v2
// Yes, that's a v2 thing, I'm not doing it right now
/obj/structure/machinery/cooking/deepfryer
	name = "deep fryer"
	desc = "A deep fryer that can hold two baskets."
	icon_state = "deep_fryer"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	cooking = FALSE
	allowed_containers = list(
		/obj/item/reagent_container/cooking/deep_basket,
	)

/obj/structure/machinery/cooking/deepfryer/Initialize(mapload)
	. = ..()

	for(var/index in 1 to 2)
		surfaces += new/datum/cooking_surface/deepfryer_basin(src)

/obj/structure/machinery/cooking/deepfryer/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("<b>Ctrl-Click</b> on a basin to set its timer and toggle it on or off.")

#define ICON_SPLIT_X 16
#define ICON_SPLIT_Y 16

/obj/structure/machinery/cooking/deepfryer/clickpos_to_surface(modifiers)
	var/icon_x = text2num(modifiers["icon-x"])
	var/icon_y = text2num(modifiers["icon-y"])
	if(icon_y <= ICON_SPLIT_Y)
		return

	if(icon_x <= ICON_SPLIT_X)
		return 1
	else if(icon_x > ICON_SPLIT_X)
		return 2

#undef ICON_SPLIT_X
#undef ICON_SPLIT_Y

/obj/structure/machinery/cooking/deepfryer/attack_hand(mob/user, params)
	var/input = clickpos_to_surface(params)
	if(!input)
		return

	var/datum/cooking_surface/surface = surfaces[input]
	if(surface && surface.container)
		if(surface.on)
			surface.handle_cooking(user)
			var/mob/living/carbon/human/burn_victim = user
			if(istype(burn_victim) && !burn_victim.gloves)
				var/which_hand = "l_hand"
				if(!burn_victim.hand)
					which_hand = "r_hand"

				burn_victim.apply_damage(20, BURN, which_hand, enviro = TRUE)
				to_chat(burn_victim, SPAN_DANGER("You burn your hand a little taking [surface.container] off of [src]."))

		user.put_in_hands(surface.container)
		surface.UnregisterSignal(surface.container, COMSIG_PARENT_EXAMINE)
		surface.container = null
		update_icon()

/obj/structure/machinery/cooking/deepfryer/update_icon()
	. = ..()

	for(var/index in 1 to length(surfaces))
		var/datum/cooking_surface/surface = surfaces[index]
		if(!surface.container)
			continue

/obj/structure/machinery/cooking/deepfryer/update_surface_icon(surface_idx)
	var/datum/cooking_surface/surface = surfaces[surface_idx]

	if(!surface.container)
		return
	var/obj/item/reagent_container/cooking/deep_basket/basket = surface.container
	if(surface.on)
		basket.frying = TRUE
		basket.update_icon()
	else
		basket.frying = FALSE
		basket.update_icon()
	switch(surface_idx)
		if(1)
			basket.pixel_x = -6
			basket.pixel_y = 4
		if(2)
			basket.pixel_x = 7
			basket.pixel_y = 4

	add_to_visible(basket, surface_idx)

/obj/structure/machinery/cooking/deepfryer/add_to_visible(obj/item/reagent_container/cooking/container, surface_idx)
	container.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	container.make_mini()
	vis_contents += container
