/datum/cooking_surface/grill_surface
	cooker_id = COOKER_SURFACE_GRILL

/datum/cooking_surface/grill_surface/handle_switch(mob/user)
	var/obj/structure/machinery/cooking/grill/grill = parent
	if(!istype(grill))
		return

	if(!on)
		if(grill.stored_wood <= 0)
			to_chat(user, SPAN_NOTICE("There is no wood in the grill. Insert some planks first."))
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

	for(var/index in 1 to 2)
		surfaces += new /datum/cooking_surface/grill_surface(src)
	update_icon()

/obj/structure/machinery/cooking/grill/Destroy()
	. = ..()
	QDEL_NULL(hopper_overlay)

/obj/structure/machinery/cooking/grill/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It contains [round(stored_wood, 0.01)]/[wood_maximum] units of charcoal.")
	. += SPAN_NOTICE("<b>Ctrl-Click</b> on a surface to set its timer, temperature, and toggle it on or off.")

/obj/structure/machinery/cooking/grill/process()
	. = ..()

	for(var/datum/cooking_surface/surface in surfaces)
		if(surface.on)
			if(!stored_wood)
				SEND_SIGNAL(surface.container, COMSIG_COOK_GRILL_NO_FUEL)
				surface.turn_off()
			else
				stored_wood = max(0, stored_wood - wood_consumption_rate)

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
			to_chat(user, SPAN_NOTICE("The grill's hopper is full."))
			return
		to_chat(user, SPAN_NOTICE("You add [used_sheets] wood plank\s into [src]'s hopper."))
		if(!stack.use(used_sheets))
			qdel(stack)	// Protects against weirdness
		stored_wood += used_sheets

		flick("wood_load", hopper_overlay)
		return

	return ..()

/obj/structure/machinery/cooking/grill/attack_hand(mob/user, params)
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

				switch(surface.temperature)
					if(J_HI)
						burn_victim.apply_damage(5, BURN, which_hand, enviro = TRUE)
					if(J_MED)
						burn_victim.apply_damage(2, BURN, which_hand, enviro = TRUE)
					if(J_LO)
						burn_victim.apply_damage(1, BURN, which_hand, enviro = TRUE)

				to_chat(burn_victim, SPAN_DANGER("You burn your hand a little taking [surface.container] off of [src]."))

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
	overlays.Cut()
	for(var/index in 1 to length(surfaces))
		var/datum/cooking_surface/surface = surfaces[index]
		if(surface.on)
			overlays += image(icon, icon_state = "fire_[index]")


/obj/structure/machinery/cooking/grill/add_to_visible(obj/item/reagent_container/cooking/container, surface_idx)
	container.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	vis_contents += container
	if(surface_idx == 2 || surface_idx == 4)
		var/matrix/transform_matrix = matrix()
		transform_matrix.Scale(-1, 1)
		container.apply_transform(transform_matrix)

	container.make_mini()
