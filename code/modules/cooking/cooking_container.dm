/obj/effect/cooking_container_lip
	icon = 'icons/obj/items/kitchen_tools.dmi'
	vis_flags = VIS_INHERIT_ID

/// Abstract reagent container used for transferring from non-containers e.g. sinks
/obj/item/reagent_container/temp
	flags_atom = FPRINT|OPENCONTAINER
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/temp/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)

/**
 * Cooking containers are used in ovens, fryers and so on, to hold multiple
 * ingredients for a recipe. They interact with the cooking process, and link
 * up with the cooking code dynamically. Originally sourced from the Aurora,
 * heavily retooled to actually work with PCWJ Holder for a portion of an
 * incomplete meal, allows a cook to temporarily offload recipes to work on
 * things factory-style, eliminating the need for 20 plates to get things done
 * fast.
 **/
/obj/item/reagent_container/cooking
	icon = 'icons/obj/items/kitchen_tools.dmi'
	w_class = SIZE_SMALL
	volume = 240
	flags_atom = FPRINT|OPENCONTAINER|NOREACT
	possible_transfer_amounts = null

	/// The [/datum/cooking/recipe_tracker] of the current food preparation.
	var/datum/cooking/recipe_tracker/tracker = null
	/// Icon state of the lip layer of the object
	var/lip = TRUE
	var/obj/effect/cooking_container_lip/lip_effect
	/// A flat quality reduction for removing an unfinished recipe from the container.
	var/removal_penalty = 0
	/// Record of what cooking has been done on this food.
	var/list/cooker_data = list()
	/// Preposition for human-readable recipe e.g. "in a pain", "on a grill".
	var/preposition = "In"
	/// Whether the container is in "mini" mode, that is, placed on a cooking machine and rendered
	/// with its smaller icons
	var/mini = FALSE

/obj/item/reagent_container/cooking/Initialize(mapload)
	. = ..()
	update_lip_effect()
	clear_cooking_data()

/obj/item/reagent_container/cooking/proc/update_lip_effect()
	if(lip)
		lip_effect = new
		lip_effect.icon_state = "[icon_state]_lip"

/obj/item/reagent_container/cooking/Destroy()
	. = ..()
	QDEL_NULL(tracker)
	QDEL_NULL(lip_effect)

/obj/item/reagent_container/cooking/get_examine_text(mob/user)
	. = ..()

	if(length(contents))
		. += get_content_info()
	. += SPAN_NOTICE("Use <b>unique action</b> when in hand, or <b>Ctrl-click</b> when on a machine to remove all items and reagents from this.")

	if(!reagents)
		return
	var/one_percent = reagents.total_volume / 100
	if(length(reagents.reagent_list))
		. += SPAN_NOTICE("It contains:")
	for(var/I in reagents.reagent_list)
		var/datum/reagent/R = I
		. += SPAN_NOTICE("[R.volume] units of [R] ([round(R.volume / one_percent)]%)")

/obj/item/reagent_container/cooking/proc/get_content_info()
	return "It contains [english_list(contents)]."

/obj/item/reagent_container/cooking/proc/get_usable_status()
	if(length(contents) == 0 && reagents.total_volume == 0)
		return PCWJ_CONTAINER_AVAILABLE

	return PCWJ_CONTAINER_BUSY

/obj/item/reagent_container/cooking/attackby(obj/item/used, mob/living/user, list/modifiers)
	process_item(user, used)

/// Attempt to progress the known recipes in the tracker with the item last used
/// on the container. Note that this is the same proc used for both steps like
/// adding items to a container, as well as cooking the container in a cooking
/// machine, such as an oven or stove. So in some cases `used` will be something
/// like a food item, and in other cases `used` will be an
/// [/obj/machinery/cooking].
/obj/item/reagent_container/cooking/proc/process_item(mob/user, obj/used)
	if(!istype(used))
		return PCWJ_NO_STEPS

	if(!tracker)
		if(!(type in GLOB.pcwj_recipe_dictionary))
			return PCWJ_NO_STEPS

		var/list/container_recipes = GLOB.pcwj_recipe_dictionary[type]
		if(!length(container_recipes))
			return PCWJ_NO_STEPS

		tracker = new(src)

		for(var/datum/cooking/recipe/recipe in container_recipes)
			tracker.recipes_last_completed_step[recipe] = 0

	if(!tracker && (length(contents) || reagents.total_volume != 0))
		to_chat(user, SPAN_NOTICE("\The [src] is full. Empty its contents first."))
		return PCWJ_CONTAINER_FULL

	var/process_reaction = tracker.process_item_wrap(user, used)
	react_to_process(process_reaction, user, used)
	return process_reaction

/obj/item/reagent_container/cooking/proc/react_to_process(reaction_status, mob/user, obj/used)
	if(istype(used, /obj/structure/machinery/cooking) && reaction_status == PCWJ_NO_STEPS)
		// When a finished recipe is still sitting on a cooking machine, and the
		// cooking machine is sending periodic process pings as it is activated,
		// the container will still be processed and a tracker created, because
		// the result from the finished recipe counts as the potential input to
		// a new recipe. Which is valid; it may be the input to a new recipe.
		// But if it's not, we don't want a message to keep showing up as if the
		// player is trying to step through a recipe.
		return

	if(reaction_status == PCWJ_NO_STEPS && !tracker.recipe_started)
		to_chat(user, SPAN_NOTICE("You don't know what you'd begin to make with this."))
		return

	switch(reaction_status)
		if(PCWJ_NO_RECIPES)
			to_chat(user, SPAN_NOTICE("You don't know what you'd begin to make with this."))
		if(PCWJ_NO_STEPS)
			to_chat(user, SPAN_NOTICE("You get a feeling this wouldn't improve the recipe."))
		if(PCWJ_SUCCESS, PCWJ_PARTIAL_SUCCESS)
			if(tracker.step_reaction_message && ismob(user))
				to_chat(user, SPAN_NOTICE("[tracker.step_reaction_message]"))

			update_icon()
		if(PCWJ_COMPLETE)
			if(tracker.step_reaction_message && ismob(user))
				to_chat(user, SPAN_NOTICE("[tracker.step_reaction_message]"))
				to_chat(user, SPAN_NOTICE("You finish cooking with [src]."))
			QDEL_NULL(tracker)
			clear_cooking_data()
			update_icon()

/obj/item/reagent_container/cooking/proc/handle_burning()
	// Only create a burnt mess with objects in us, so boiled water doesn't
	// turn into a burnt mess when left on the stove too long.
	if(length(contents))
		clear()
		new /obj/item/reagent_container/food/snacks/badrecipe(src)
	else
		clear()

	update_icon()

/obj/item/reagent_container/cooking/proc/handle_ignition()
	clear()
	update_icon()
	return TRUE

/obj/item/reagent_container/cooking/proc/do_empty(mob/user, atom/target, reagent_clear = TRUE)
	#ifdef PCWJ_DEBUG
	log_debug("cooking_container/do_empty() called!")
	#endif

	if(length(contents) || (reagent_clear && reagents.total_volume > 0))
		for(var/contained in contents)
			var/atom/movable/AM = contained
			remove_from_visible(AM)
			if(!target)
				AM.forceMove(get_turf(src))
			else
				AM.forceMove(get_turf(target))

		if(ismob(user))
			to_chat(user, SPAN_NOTICE("You remove everything from [src]."))

	if(reagent_clear)
		reagents.clear_reagents()

	update_icon()
	QDEL_NULL(tracker)
	clear_cooking_data()

/obj/item/reagent_container/cooking/unique_action(mob/user)
	do_empty(user)

/// Deletes contents and reagents of container.
/obj/item/reagent_container/cooking/proc/clear()
	contents = list()
	reagents.clear_reagents()
	QDEL_NULL(tracker)
	clear_cooking_data()

/obj/item/reagent_container/cooking/proc/cooker_temp_data(datum/cooking_surface/surface)
	if(!(surface.cooker_id in cooker_data))
		return null
	if(!(surface.temperature in cooker_data[surface.cooker_id]))
		return null

	return cooker_data[surface.cooker_id][surface.temperature]

/obj/item/reagent_container/cooking/proc/set_cooker_data(datum/cooking_surface/surface, val)
	if(!(surface.cooker_id in cooker_data))
		cooker_data[surface.cooker_id] = list()

	cooker_data[surface.cooker_id][surface.temperature] = val

/obj/item/reagent_container/cooking/proc/get_cooker_time(surface_name, temp)
	// can't fucking trust LAZYACCESSASSOC
	if(!(surface_name in cooker_data))
		return null
	if(!(temp in cooker_data[surface_name]))
		return null

	return cooker_data[surface_name][temp]

/obj/item/reagent_container/cooking/proc/clear_cooking_data()
	cooker_data.Cut()

/obj/item/reagent_container/cooking/update_icon()
	..()

	vis_contents.Remove(lip_effect)

	for(var/obj/content in vis_contents)
		remove_from_visible(content)

	for(var/i = length(contents), i >= 1, i--)
		var/obj/content = contents[i]
		add_to_visible(content)

	if(length(contents) && lip_effect)
		vis_contents += lip_effect

/obj/item/reagent_container/cooking/proc/add_to_visible(obj/our_item)
	our_item.pixel_x = initial(our_item.pixel_x)
	our_item.pixel_y = initial(our_item.pixel_y)
	our_item.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	our_item.blend_mode = BLEND_INSET_OVERLAY
	our_item.transform *= 0.6
	vis_contents += our_item

/obj/item/reagent_container/cooking/proc/remove_from_visible(obj/our_item)
	our_item.vis_flags = 0
	our_item.blend_mode = 0
	our_item.transform = null
	vis_contents.Remove(our_item)

/obj/item/reagent_container/cooking/proc/make_mini()
	mini = TRUE
	icon_state = "[initial(icon_state)]_s"
	update_lip_effect()
	update_icon()

/obj/item/reagent_container/cooking/proc/unmake_mini()
	mini = FALSE
	icon_state = initial(icon_state)
	update_lip_effect()
	update_icon()

/obj/item/reagent_container/cooking/board
	name = "cutting board"
	desc = "Good for making sandwiches on, too."
	icon_state = "cutting_board"
	item_state = "cutting_board"
	preposition = "On"

/obj/item/reagent_container/cooking/sushimat
	name = "Sushi Mat"
	desc = "A wooden mat used for efficient sushi crafting."
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "sushi_mat"
	lip = null
	preposition = "On"
	force = 5
	throwforce = 5
	throw_speed = 3
	throw_range = 3
	w_class = SIZE_SMALL

/obj/item/reagent_container/cooking/oven
	name = "oven dish"
	desc = "Put ingredients in this; designed for use with an oven. Warranty void if used."
	icon_state = "oven_dish"

/obj/item/reagent_container/cooking/oven/add_to_visible(obj/item/our_item)
	if(mini)
		our_item.pixel_x = 0
		our_item.pixel_y = -4
		our_item.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
		our_item.blend_mode = BLEND_INSET_OVERLAY
		our_item.transform *= 0.5
	else
		our_item.pixel_x = 0
		our_item.pixel_y = 0
		our_item.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
		our_item.blend_mode = BLEND_INSET_OVERLAY
		our_item.transform *= 0.5
	vis_contents += our_item

/obj/item/reagent_container/cooking/pan
	name = "pan"
	desc = "A normal pan."
	icon_state = "pan"
	force = 8
	throwforce = 10
	attack_verb = list("smashed", "fried")
	hitsound = 'sound/weapons/smash.ogg'

/obj/item/reagent_container/cooking/pan/add_to_visible(obj/our_item)
	if(mini)
		our_item.pixel_x = 0
		our_item.pixel_y = -1
		our_item.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
		our_item.blend_mode = BLEND_INSET_OVERLAY
		our_item.transform *= 0.5
		vis_contents += our_item
	else
		..()

/obj/item/reagent_container/cooking/pot
	name = "cooking pot"
	desc = "Boil things with this. Maybe even stick 'em in a stew."
	icon_state = "pot"
	hitsound = 'sound/weapons/smash.ogg'
	removal_penalty = 5
	force = 8
	throwforce = 10
	attack_verb = list("clanged", "boiled")
	w_class = SIZE_LARGE

/obj/item/reagent_container/cooking/deep_basket
	name = "deep fryer basket"
	desc = "Cwispy! Warranty void if used."
	icon_state = "deepfryer_basket"
	removal_penalty = 5
	var/frying = FALSE

/obj/item/reagent_container/cooking/deep_basket/add_to_visible(obj/our_item)
	if(mini)
		our_item.pixel_x = 1
		our_item.pixel_y = 0
		our_item.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
		our_item.blend_mode = BLEND_INSET_OVERLAY
		our_item.transform *= 0.5
		vis_contents += our_item
	else
		our_item.pixel_x = 4
		our_item.pixel_y = 0
		our_item.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
		our_item.blend_mode = BLEND_INSET_OVERLAY
		our_item.transform *= 0.6
		vis_contents += our_item

/obj/item/reagent_container/cooking/deep_basket/update_icon()
	. = ..()
	overlays.Cut()
	if(frying)
		overlays += image(icon = icon, icon_state = "fryerbasket_on")

/obj/item/reagent_container/cooking/grill_grate
	name = "grill grate"
	desc = "Primarily used to grill meat, place this on a grill and enjoy an ancient human tradition."
	icon_state = "grill_grate"
	lip = null

/obj/item/reagent_container/cooking/bowl
	name = "prep bowl"
	desc = "A bowl for mixing, or tossing a salad. Not to be eaten out of"
	icon_state = "bowl"
	removal_penalty = 2

/obj/item/reagent_container/cooking/icecream_bowl
	name = "freezing bowl"
	desc = "A stainless steel bowl that fits into the ice cream mixer."
	icon_state = "ice_cream_bowl"
	var/freezing_time = 0

/obj/item/reagent_container/cooking/icecream_bowl/make_mini()
	transform *= 0.8

/obj/item/reagent_container/cooking/icecream_bowl/unmake_mini()
	transform = null
