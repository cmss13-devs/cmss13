/datum/cooking_surface/grill_surface
	cooker_id = COOKER_SURFACE_GRILL

/datum/cooking_surface/grill_surface/handle_switch(mob/user)
	var/obj/structure/machinery/cooking/grill/grill = parent
	if(!istype(grill))
		return

	if(!on)
		if(grill.stored_wood <= 0)
			to_chat(user, "<span class='notice'>There is no wood in the grill. Insert some planks first.</span>")
			return

	return ..()

/obj/effect/grill_hopper
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	vis_flags = VIS_INHERIT_ID
	mouse_opacity = 0
	invisibility = 0

// TODO: add back special attack for grill for v2
// Yes, that's a v2 thing, I'm not doing it right now
/obj/structure/machinery/cooking/grill
	name = "grill"
	desc = "A deep pit of charcoal for cooking food. A slot on the side of the machine takes wood and converts it into charcoal."
	icon_state = "grill"
	density = FALSE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	active_power_usage = 50 // uses more wood than power
	allowed_containers = list(
		/obj/item/reagent_container/cooking/grill_grate,
	)

	var/stored_wood = 0
	var/wood_maximum = 30
	var/wood_consumption_rate = 0.025
	var/obj/effect/grill_hopper/hopper_overlay

/obj/structure/machinery/cooking/grill/Initialize(mapload)
	. = ..()

	hopper_overlay = new
	vis_contents += hopper_overlay

	for(var/i in 1 to 2)
		surfaces += new /datum/cooking_surface/grill_surface(src)
	update_icon()

/obj/structure/machinery/cooking/grill/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It contains [round(stored_wood, 0.01)]/[wood_maximum] units of charcoal.</span>"
	. += "<span class='notice'><b>Ctrl-Click</b> on a surface to set its timer, temperature, and toggle it on or off.</span>"

/obj/structure/machinery/cooking/grill/process()
	. = ..()

	for(var/datum/cooking_surface/surface in surfaces)
		if(surface.on)
			if(!stored_wood)
				SEND_SIGNAL(surface.container, COMSIG_COOK_GRILL_NO_FUEL)
				surface.turn_off()
			else
				stored_wood = max(0, stored_wood - wood_consumption_rate)

/obj/structure/machinery/cooking/grill/RefreshParts()
	. = ..()

	var/las_rating = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		las_rating += M.rating
	wood_consumption_rate = initial(wood_consumption_rate) / max(1, las_rating / 2)

	var/bin_rating = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		bin_rating += M.rating
	wood_maximum = 15 * bin_rating

#define ICON_SPLIT_X 16

//Retrieve which half of the baking pan is being used.
/obj/structure/machinery/cooking/grill/clickpos_to_surface(modifiers)
	var/icon_x = text2num(modifiers["icon-x"])
	if(icon_x <= ICON_SPLIT_X)
		return 1
	else if(icon_x > ICON_SPLIT_X)
		return 2

#undef ICON_SPLIT_X

/obj/structure/machinery/cooking/grill/attackby(obj/item/used, mob/living/user, list/modifiers)
	if(istype(used, /obj/item/stack/sheet/wood))
		var/obj/item/stack/sheet/wood/stack = used
		var/used_sheets = min(stack.get_amount(), (wood_maximum - stored_wood))
		if(!used_sheets)
			to_chat(user, "<span class='notice'>The grill's hopper is full.</span>")
			return
		to_chat(user, "<span class='notice'>You add [used_sheets] wood plank\s into [src]'s hopper.</span>")
		if(!stack.use(used_sheets))
			qdel(stack)	// Protects against weirdness
		stored_wood += used_sheets

		flick("wood_load", hopper_overlay)
		return

	return ..()

/obj/structure/machinery/cooking/grill/attack_hand(mob/user, params)
	var/input = clickpos_to_surface(params2list(params))
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

				switch(surface.temperature)
					if(J_HI)
						burn_victim.apply_damage(5, BURN, which_hand, enviro = TRUE)
					if(J_MED)
						burn_victim.apply_damage(2, BURN, which_hand, enviro = TRUE)
					if(J_LO)
						burn_victim.apply_damage(1, BURN, which_hand, enviro = TRUE)

				to_chat(burn_victim, "<span class='danger'>You burn your hand a little taking [surface.container] off of [src].</span>")

		user.put_in_hands(surface.container)
		surface.UnregisterSignal(surface.container, COMSIG_PARENT_EXAMINE)
		surface.container = null
		update_icon()

/obj/structure/machinery/cooking/grill/update_surface_icon(surface_idx)
	var/datum/cooking_surface/surface = surfaces[surface_idx]

	if(!surface.container)
		return

	switch(surface_idx)
		if(1)
			surface.container.pixel_x = -7
			surface.container.pixel_y = 3
		if(2)
			surface.container.pixel_x = 7
			surface.container.pixel_y = 3

	add_to_visible(surface.container, surface_idx)

/obj/structure/machinery/cooking/grill/update_icon()
	. = ..()
	for(var/i in 1 to length(surfaces))
		var/datum/cooking_surface/surface = surfaces[i]
		if(surface.on)
			. += image(icon, icon_state = "fire_[i]")

/obj/structure/machinery/cooking/grill/add_to_visible(obj/item/reagent_container/cooking/container, surface_idx)
	container.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	vis_contents += container
	if(surface_idx == 2 || surface_idx == 4)
		var/matrix/M = matrix()
		M.Scale(-1, 1)
		container.transform = M

	container.make_mini()
