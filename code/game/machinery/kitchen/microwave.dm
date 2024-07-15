
/obj/structure/machinery/microwave
	name = "Microwave"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "mw"
	layer = ABOVE_TABLE_LAYER
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	flags_atom = OPENCONTAINER|NOREACT
	var/operating = 0 // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/global/list/datum/recipe/available_recipes // List of the recipes you can use
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 0


// see code/modules/food/recipes_microwave.dm for recipes

//*******************
//*   Initialising
//********************/

/obj/structure/machinery/microwave/Initialize()
	. = ..()
	create_reagents(100)
	reagents.my_atom = src
	if (!available_recipes)
		available_recipes = new
		for (var/type in (typesof(/datum/recipe)-/datum/recipe))
			available_recipes+= new type
		acceptable_items = new
		acceptable_reagents = new
		for (var/datum/recipe/recipe in available_recipes)
			for (var/item in recipe.items)
				acceptable_items |= item
			for (var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
			if (recipe.items)
				max_n_of_items = max(max_n_of_items,recipe.items.len)

		// This will do until I can think of a fun recipe to use dionaea in -
		// will also allow anything using the holder item to be microwaved into
		// impure carbon. ~Z
		acceptable_items |= /obj/item/holder

/obj/structure/machinery/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

//*******************
//*   Item Adding
//********************/

/obj/structure/machinery/microwave/attackby(obj/item/O as obj, mob/user as mob)
	if(broken > 0)
		if(broken == 2 && HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER)) // If it's broken and they're using a screwdriver
			user.visible_message( \
				SPAN_NOTICE("[user] starts to fix part of the microwave."), \
				SPAN_NOTICE("You start to fix part of the microwave.") \
			)
			if (do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message( \
					SPAN_NOTICE("[user] fixes part of the microwave."), \
					SPAN_NOTICE("You have fixed part of the microwave. Now use a wrench!") \
				)
				src.broken = 1 // Fix it a bit
		else if(src.broken == 1 && HAS_TRAIT(O, TRAIT_TOOL_WRENCH)) // If it's broken and they're doing the wrench
			user.visible_message( \
				SPAN_NOTICE("[user] starts to fix part of the microwave."), \
				SPAN_NOTICE("You start to fix part of the microwave.") \
			)
			if (do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message( \
					SPAN_NOTICE("[user] fixes the microwave."), \
					SPAN_NOTICE("You have fixed the microwave.") \
				)
				icon_state = "mw"
				broken = 0 // Fix it!
				dirty = 0 // just to be sure
				flags_atom = OPENCONTAINER
		else
			if(broken == 2)
				to_chat(user, SPAN_DANGER("It's broken! Use a screwdriver and a wrench to fix it!"))
			else
				to_chat(user, SPAN_DANGER("It's broken! Use a wrench to fix it!"))
			return 1
	else if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		. = ..()
		return
	else if(dirty==100) // The microwave is all dirty so can't be used!
		if(istype(O, /obj/item/reagent_container/spray/cleaner)) // If they're trying to clean it then let them
			user.visible_message( \
				SPAN_NOTICE("[user] starts to clean the microwave."), \
				SPAN_NOTICE("You start to clean the microwave.") \
			)
			if (do_after(user, 2 SECONDS * user.get_skill_duration_multiplier(SKILL_DOMESTIC), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				user.visible_message( \
					SPAN_NOTICE("[user]  has cleaned  the microwave."), \
					SPAN_NOTICE("You have cleaned the microwave.") \
				)
				dirty = 0 // It's clean!
				broken = 0 // just to be sure
				icon_state = "mw"
				flags_atom = OPENCONTAINER
		else //Otherwise bad luck!!
			to_chat(user, SPAN_DANGER("It's dirty! Clean it with a spray cleaner!"))
			return 1
	else if(operating)
		to_chat(user, SPAN_DANGER("It's running!"))
	else if(is_type_in_list(O,acceptable_items))
		if (contents.len>=max_n_of_items)
			to_chat(user, SPAN_DANGER("This [src] is full of ingredients, you cannot put more."))
			return 1
		if(istype(O, /obj/item/stack) && O:get_amount() > 1) // This is bad, but I can't think of how to change it
			var/obj/item/stack/S = O
			new O.type (src)
			S.use(1)
			user.visible_message( \
				SPAN_NOTICE("[user] has added one of [O] to \the [src]."), \
				SPAN_NOTICE("You add one of [O] to \the [src]."))
		else
		// user.before_take_item(O) //This just causes problems so far as I can tell. -Pete
			if(user.drop_held_item())
				O.forceMove(src)
				user.visible_message( \
					SPAN_NOTICE("[user] has added \the [O] to \the [src]."), \
					SPAN_NOTICE("You add \the [O] to \the [src]."))
	else if(istype(O,/obj/item/reagent_container/glass) || istype(O,/obj/item/reagent_container/food/drinks) || istype(O,/obj/item/reagent_container/food/condiment)) // TODO: typecache this
		if (!O.reagents)
			return 1
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.id in acceptable_reagents))
				to_chat(user, SPAN_DANGER("Your [O] contains components unsuitable for cookery."))
				return 1
	else if(istype(O,/obj/item/grab))
		return 1
	else
		to_chat(user, SPAN_DANGER("You have no idea what you can cook with this [O]."))
		return 1
	src.updateUsrDialog()

/obj/structure/machinery/microwave/attack_remote(mob/user as mob)
	return 0

/obj/structure/machinery/microwave/attack_hand(mob/user as mob)
	user.set_interaction(src)
	tgui_interact(user)

/obj/structure/machinery/microwave/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Microwave", "Microwave Controls")
		ui.open()

//*******************
//*   Microwave Menu
//********************/
/obj/structure/machinery/microwave/ui_data(mob/user)
	var/list/data = list()

	data["operating"] = operating
	data["broken"] = (broken > 0)
	data["dirty"] = (dirty == 100)

	var/list/ingredients = list()
	var/list/items_counts = list()
	var/list/items_measures = list()
	var/list/items_measures_p = list()

	for (var/obj/contents_item as anything in contents)
		var/display_name = contents_item.name

		if (istype(contents_item, /obj/item/reagent_container/food/snacks/tofu))
			items_measures[display_name] = "tofu chunk"
			items_measures_p[display_name] = "tofu chunks"
		if (istype(contents_item, /obj/item/reagent_container/food/snacks/meat)) //any meat
			items_measures[display_name] = "slab of meat"
			items_measures_p[display_name] = "slabs of meat"
		if (istype(contents_item, /obj/item/reagent_container/food/snacks/donkpocket))
			display_name = "Turnovers"
			items_measures[display_name] = "turnover"
			items_measures_p[display_name] = "turnovers"
		if (istype(contents_item, /obj/item/reagent_container/food/snacks/carpmeat))
			items_measures[display_name] = "fillet of meat"
			items_measures_p[display_name] = "fillets of meat"
		items_counts[display_name]++

	for (var/contents_item in items_counts)
		var/list/item = list()

		item["name"] = capitalize(contents_item)
		item["count"] = items_counts[contents_item]

		if (!(contents_item in items_measures))
			item["measure"] = "[lowertext(contents_item)][items_counts[contents_item] > 1 ? "s" : ""]" // Adds 's' for plurals.
		else if (items_counts[contents_item] == 1)
			item["measure"] = items_measures[contents_item]
		else
			item["measure"] = items_measures_p[contents_item]

		ingredients += list(item)

	for (var/datum/reagent/contents_reagent as anything in reagents.reagent_list)
		var/list/reagent = list()

		reagent["count"] = contents_reagent.volume
		reagent["measure"] = contents_reagent.volume > 1 ? "units" : "unit"

		reagent["name"] = contents_reagent.name
		if (contents_reagent.id == "hotsauce")
			reagent["name"] = "Hotsauce"
		if (contents_reagent.id == "frostoil")
			reagent["name"] = "Coldsauce"

		ingredients += list(reagent)

	data["ingredients"] = ingredients
	return data

//***********************************
//*   Microwave Menu Handling/Cooking
//************************************/

/obj/structure/machinery/microwave/proc/cook(time_multiplier = 1)
	if(inoperable() || operating)
		return

	start()
	if (reagents.total_volume==0 && !(locate(/obj) in contents)) //dry run
		if (!wzhzhzh(10 * time_multiplier))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	var/obj/cooked
	if (!recipe)
		dirty++
		if (prob(max(10,dirty*5)))
			if (!wzhzhzh(4 * time_multiplier))
				abort()
				return
			muck_start()
			wzhzhzh(4)
			muck_finish()
			cooked = fail()
			cooked.forceMove(src.loc)
			return
		else if (has_extra_item())
			if (!wzhzhzh(4 * time_multiplier))
				abort()
				return
			broke()
			cooked = fail()
			cooked.forceMove(src.loc)
			return
		else
			if (!wzhzhzh(10 * time_multiplier))
				abort()
				return
			stop()
			cooked = fail()
			cooked.forceMove(src.loc)
			return
	else
		var/halftime = floor(recipe.time/10/2)
		if (!wzhzhzh(halftime * time_multiplier))
			abort()
			return
		if (!wzhzhzh(halftime * time_multiplier))
			abort()
			cooked = fail()
			cooked.forceMove(src.loc)
			return
		cooked = recipe.make_food(src)
		stop()
		if(cooked)
			cooked.forceMove(src.loc)
		return

/obj/structure/machinery/microwave/proc/wzhzhzh(seconds as num)
	for (var/i=1 to seconds)
		if (inoperable())
			return 0
		use_power(500)
		sleep(10)
	return 1

/obj/structure/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in contents)
		if ( \
				!istype(O,/obj/item/reagent_container/food) && \
				!istype(O, /obj/item/grown) \
			)
			return 1
	return 0

/obj/structure/machinery/microwave/proc/start()
	src.visible_message(SPAN_NOTICE("The microwave turns on."), SPAN_NOTICE("You hear a microwave."))
	src.operating = 1
	src.icon_state = "mw1"
	src.updateUsrDialog()

/obj/structure/machinery/microwave/proc/abort()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/structure/machinery/microwave/proc/stop()
	playsound(src.loc, 'sound/machines/ding.ogg', 25, 1)
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/structure/machinery/microwave/proc/dispose()
	for (var/obj/O in contents)
		O.forceMove(src.loc)
	if (src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	to_chat(usr, SPAN_NOTICE("You dispose of the microwave contents."))
	src.updateUsrDialog()

/obj/structure/machinery/microwave/proc/muck_start()
	playsound(src.loc, 'sound/effects/splat.ogg', 25, 1) // Play a splat sound
	src.icon_state = "mwbloody1" // Make it look dirty!!

/obj/structure/machinery/microwave/proc/muck_finish()
	playsound(src.loc, 'sound/machines/ding.ogg', 25, 1)
	visible_message(SPAN_DANGER("The microwave gets covered in muck!"))
	dirty = 100 // Make it dirty so it can't be used util cleaned
	flags_atom = null //So you can't add condiments
	icon_state = "mwbloody" // Make it look dirty too
	operating = 0 // Turn it off again aferwards
	updateUsrDialog()

/obj/structure/machinery/microwave/proc/broke()
	var/datum/effect_system/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	icon_state = "mwb" // Make it look all busted up and shit
	visible_message(SPAN_DANGER("The microwave breaks!")) //Let them know they're stupid
	broken = 2 // Make it broken so it can't be used util fixed
	flags_atom = null //So you can't add condiments
	operating = 0 // Turn it off again aferwards
	updateUsrDialog()

/obj/structure/machinery/microwave/proc/fail()
	var/obj/item/reagent_container/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0
	for (var/obj/O in contents-ffuu)
		amount++
		if (O.reagents)
			var/id = O.reagents.get_master_reagent_id()
			if (id)
				amount+=O.reagents.get_reagent_amount(id)
		qdel(O)
	if(src.reagents)
		src.reagents.clear_reagents()
	ffuu.reagents.add_reagent("carbon", amount)
	ffuu.reagents.add_reagent("toxin", amount/10)
	return ffuu

/obj/structure/machinery/microwave/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch (action)
		if ("cook")
			cook(usr.get_skill_duration_multiplier(SKILL_DOMESTIC)) // picking the right microwave setting for the right food. when's the last time you used the special setting on the microwave? i bet you just slam the 30 second increment. Do you know how much programming went into putting the Pizza setting into a microwave emitter?

		if ("eject_all")
			dispose()

	return TRUE
