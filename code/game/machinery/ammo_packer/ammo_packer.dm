#define AMMO_PACKER_MODE_PACK_LOOSE 1
#define AMMO_PACKER_MODE_PACK_MAGAZINES 2
#define AMMO_PACKER_MODE_PACK_ITEMS 3
#define AMMO_PACKER_MODE_RECYCLE_MAGAZINE 4

#define AMMO_PACKER_ROUNDS_BOX_LOADED "ROUNDS"
#define AMMO_PACKER_MAGAZINE_BOX_LOADED "MAGAZINES"
#define AMMO_PACKER_HANDFULS_MAGAZINE_BOX_LOADED "CARTRIDGES" // >:c
#define AMMO_PACKER_ITEM_BOX_LOADED "ITEMS"

/obj/structure/machinery/ammo_packer
	name = "ammo packer"
	desc = "A machine used for assembling ammo boxes and packing items."
	icon_state = "autolathe"
	var/base_state = "ammo_packer"
	icon = 'icons/obj/structures/machinery/ammo_packer.dmi'
	unacidable = TRUE
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	use_power = USE_POWER_IDLE
	machine_processing = TRUE
	idle_power_usage = 10
	active_power_usage = 100

	/// Flavour text for the model name of the machine
	var/model = "Armat 54-I Ammo Packer"
	var/panel_open = FALSE
	/// Theme for tgui
	var/tgui_theme = "ntos_terminal"

	/// All the stuff for ammo box recipes (stolen from autolathe code) ///

	/// Which faction's stuff can this make?
	var/list/factions = list(FACTION_MARINE, FACTION_NEUTRAL)
	var/sheet_amount = 0
	var/sheet_storage_capacity = 50
	var/projected_sheet_cost = 0
	var/list/printables = list() // data list of each printable item (for tgUI)
	var/list/recipes
	var/list/categories
	var/list/components = list(
		/obj/item/circuitboard/machine/autolathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)
	/// queue of items to be printed after the current one is done
	var/list/queue = list()
	/// Max length of the queue
	var/queue_max = 8
	/// The item the autolathe is currently printing. Used for tgui
	var/list/currently_making_data = list()
	/// Where boxes get spat out once made
	var/turf/make_loc
	/// Are we busy making a box?
	var/busy = FALSE
	/// Is the machine hacked? Being hacked means all recipes are available
	var/hacked = FALSE

	/// Ammo packing stuff ///
	/// Which ammo packing mode are we on?
	var/mode = AMMO_PACKER_MODE_PACK_LOOSE
	/// Is the ammo packer busy doing ammo management things?
	var/packer_busy = FALSE
	/// Are we ejecting magazines?
	var/ejecting_magazines = FALSE
	/// Are we ejecting items?
	var/ejecting_items = FALSE

	var/obj/item/ammo_box/loaded_box
	var/loaded_box_max_storage
	/// What type of stuff does the loaded box store?
	var/loaded_box_load_type = "UNKNOWN"

	var/list/magazines_in_storage = list()
	var/max_magazine_storage = 30
	/// List of every magazine we can put in
	var/list/magazine_whitelist = list()

	var/list/items_in_storage = list()
	var/max_item_storage = 30
	/// List of every item we can put in (magazines are thrown into the magazine whitelist. see below)
	var/list/item_whitelist = list()


	/// Debug list for recipes that lack a category
	var/list/stinky_garbage = list()

/obj/structure/machinery/ammo_packer/Initialize(mapload, ...)
	. = ..()

	//Create global autolathe recipe list if it hasn't been made already.
	if(isnull(recipes))
		recipes = list()
		categories = list()
		for(var/recipe_path in subtypesof(/datum/ammo_packer/recipe))
			var/datum/ammo_packer/recipe/new_recipe = new recipe_path
			if(!new_recipe.path) //check if there's a path, otherwise don't add it
				QDEL_NULL(new_recipe)
				continue
			for(var/faction in factions)
				if(faction in new_recipe.factions)
					new_recipe.hidden = FALSE
			recipes |= new_recipe
			categories |= new_recipe.category
			 //updates the whitelists based off what can be loaded into the ammo box
			var/recipe_amm_box = new_recipe.path
			if(ispath(recipe_amm_box, /obj/item/ammo_box/magazine))
				var/obj/item/ammo_box/magazine/recipe_ammo_box = new_recipe.path
				if(ispath(recipe_ammo_box.magazine_type, /obj/item/ammo_magazine))
					magazine_whitelist |= recipe_ammo_box.magazine_type
				else
					item_whitelist |= recipe_ammo_box.magazine_type
			//adds recipes without a category (shows up as null but is still included in the list) to a debug list so you can go fix it
			if(!new_recipe.category)
				stinky_garbage += new_recipe

	//Create parts for lathe.
	for(var/component in components)
		LAZYADD(component_parts, new component(src))
	RefreshParts()
	update_printables()

/obj/structure/machinery/ammo_packer/RefreshParts()
	..()
	var/total_rating = 0
	var/number_of_bins = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		total_rating += MB.rating
		number_of_bins++
	total_rating = round(total_rating/number_of_bins)
	sheet_storage_capacity = sheet_storage_capacity * total_rating
	max_item_storage = max_item_storage * total_rating
	max_magazine_storage = max_magazine_storage * total_rating

// --- TGUI GOES HERE --- \\

/obj/structure/machinery/ammo_packer/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/structure/machinery/ammo_packer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AmmoPacker", "[model] control panel")
		ui.open()

/obj/structure/machinery/ammo_packer/ui_data(mob/user)
	var/list/data = list()

	if(length(queue))
		var/list/queue_list = list()
		var/i = 0
		for(var/params in queue)
			i++
			var/datum/ammo_packer/recipe/making = params[1]
			var/multiplier = params[2]
			queue_list += list(list("name" = making.name, "multiplier" = multiplier, "index" = i))

		data["queued"] = queue_list
	else
		data["queued"] = null

	if(length(currently_making_data))
		data["currently_making"] = currently_making_data
	else
		data["currently_making"] = null

	data["sheet_amount"] = sheet_amount
	data["printables"] = printables

	data["packer_busy"] = packer_busy
	data["box_loaded"] = loaded_box ? TRUE : FALSE
	data["loaded_box_max_storage"] = loaded_box_max_storage

	if(loaded_box)
		switch(loaded_box_load_type)
			if(AMMO_PACKER_ROUNDS_BOX_LOADED)
				var/obj/item/ammo_box/rounds/loose_ammo_box = loaded_box
				data["loaded_box_stored_amount"] = loose_ammo_box.bullet_amount
			if(AMMO_PACKER_HANDFULS_MAGAZINE_BOX_LOADED)
				var/obj/item/ammo_magazine/stupid_handfuls_internal_mag = locate(/obj/item/ammo_magazine) in loaded_box.contents
				data["loaded_box_stored_amount"] = stupid_handfuls_internal_mag.current_rounds
			else
				data["loaded_box_stored_amount"] = length(loaded_box.contents)
	else
		data["loaded_box_stored_amount"] = 0

	data["loaded_box_load_type"] = loaded_box_load_type

	data["max_magazine_storage"] = max_magazine_storage
	data["number_of_magazines_stored"] = round(length(magazines_in_storage))
	data["ejecting_magazines"] = ejecting_magazines
	data["max_item_storage"] = max_item_storage
	data["number_of_items_stored"] = round(length(items_in_storage))
	data["ejecting_items"] = ejecting_items
	return data

/obj/structure/machinery/ammo_packer/ui_static_data(mob/user)
	var/list/data = list()

	var/list/allcategories = list("All")

	allcategories.Add(categories)

	data["selectable_categories"] = allcategories
	data["capacity"] = sheet_storage_capacity
	data["queuemax"] = queue_max
	data["theme"] = tgui_theme

	return data

/obj/structure/machinery/ammo_packer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	switch(action)
		// ammo box making stuff
		if("cancel")
			var/index = params["index"]
			if(index < 1 || index > length(queue))
				return

			var/list/to_del = queue[index]
			var/datum/ammo_packer/recipe/queued_recipe = to_del[1]
			var/multiplier = to_del[2]

			if(queued_recipe.name != params["name"])
				return
			else if(multiplier != params["multiplier"])
				return

			projected_sheet_cost--

			to_chat(usr, SPAN_NOTICE("Removed the item \"[queued_recipe.name]\" from the queue."))
			queue -= list(to_del)
			update_printables()
			. = TRUE

		if("make")
			if(!recipes)
				return

			var/index = params["index"]
			var/multiplier = text2num(params["multiplier"])
			var/datum/ammo_packer/recipe/selected_recipe

			if(!ishuman(usr))
				return

			if(!initial(make_loc))
				make_loc = get_step(loc, get_dir(src,usr))

			if(index > 0 && index <= length(recipes))
				selected_recipe = recipes[index]


			for (var/i in 1 to multiplier)
				var/result = try_queue(usr, selected_recipe, make_loc)
				switch (result)
					if(AUTOLATHE_FAILED)
						return
					if(AUTOLATHE_START_PRINTING)
						start_printing()
			. = TRUE

		if("eject_box")
			if(!ishuman(usr))
				return
			unload_ammo_box(usr)
			return TRUE

		if("stop")
			if(!ishuman(usr))
				return
			packer_busy = FALSE
			return TRUE

		if("eject_magazines")
			if(!ishuman(usr))
				return
			eject_items_in_list(usr, magazines_in_storage, TRUE)
			return TRUE

		if("eject_items")
			if(!ishuman(usr))
				return
			eject_items_in_list(usr, items_in_storage, FALSE)
			return TRUE

		// ammo box loading stuff

// --- END TGUI --- \\

/obj/structure/machinery/ammo_packer/power_change(area/master_area = null)
	..()
	var/has_power
	if(master_area)
		has_power = master_area.powered(power_channel)
	else
		has_power = powered(power_channel)

	if(has_power)
		icon_state = "[base_state]"
	else
		icon_state = "[base_state]_no_power"

/obj/structure/machinery/ammo_packer/inoperable(additional_flags = 0)
	. = ..()
	if(panel_open || !anchored)
		return TRUE

/obj/structure/machinery/ammo_packer/attackby(obj/item/attacking_item as obj, mob/user as mob)
	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("You are not trained to dismantle machines..."))
			return
		panel_open = !panel_open
		icon_state = (panel_open ? "[base_state]_panel": "[base_state]")
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance hatch of [src].")
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(HAS_TRAIT(attacking_item, TRAIT_TOOL_MULTITOOL) || HAS_TRAIT(attacking_item, TRAIT_TOOL_WIRECUTTERS))
			attack_hand(user)
			return

		//Dismantle the frame.
		if(HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
			dismantle()
			return

	if(inoperable())
		return ..()

	// Loading ammo box
	if(ispath(attacking_item.type, /obj/item/ammo_box))
		load_ammo_box(attacking_item, user)
		return

	// Loading magazines that are in the whitelist
	if((attacking_item.type in magazine_whitelist))
		attempt_load_magazine(attacking_item, user)
		return

	// Loading items that are in the whitelist
	if((attacking_item.type in item_whitelist)) // god forbid someone makes a box of tools or cardboard
		attempt_load_item(attacking_item, user)
		return

	// Loading cardboard
	if(!istype(attacking_item,/obj/item/stack/sheet/cardboard))
		return ..()
	var/obj/item/stack/sheet/cardboard/inserted_cardboard = attacking_item
	var/inserted_sheet_amount = inserted_cardboard.get_amount()

	if(sheet_amount >= sheet_storage_capacity)
		to_chat(user, SPAN_DANGER("\The [src] is full. Please remove material from the [src] in order to insert more."))
		return TRUE
	if(sheet_amount + inserted_sheet_amount >= sheet_storage_capacity)
		to_chat(user, "You fill \the [src] to capacity with \the [inserted_cardboard].")
		var/storage_space_left = sheet_storage_capacity - sheet_amount
		var/amount_to_insert = clamp(inserted_sheet_amount, 1, storage_space_left)
		inserted_cardboard.use(amount_to_insert)
		sheet_amount += amount_to_insert
	else
		to_chat(user, "You fill \the [src] with \the [inserted_cardboard].")
		inserted_cardboard.use(inserted_sheet_amount)
		sheet_amount += inserted_sheet_amount

	flick("[base_state]_insert",src) // Play the insert animation

	update_printables()
	updateUsrDialog()
	return TRUE //so the item's afterattack isn't called

/obj/structure/machinery/ammo_packer/proc/try_queue(mob/living/carbon/human/user, datum/autolathe/recipe/making, turf/make_loc, multiplier = 1)
	if(inoperable())
		return AUTOLATHE_FAILED

	if(length(queue) >= queue_max)
		to_chat(usr, SPAN_DANGER("The [name] has queued the maximum number of operations. Please wait for completion of current operation."))
		return AUTOLATHE_FAILED

	//This needs some work.
	use_power(active_power_usage)

	//Check if we still have the materials.
	if(sheet_amount <= projected_sheet_cost)
		to_chat(user, SPAN_DANGER("The [name] does not have the materials to create \the [making.name]."))
		return AUTOLATHE_FAILED

	projected_sheet_cost++

	var/list/print_params = list(making, multiplier, make_loc)
	queue += list(print_params) // This notation is necessary because of how adding to lists works

	if(busy)
		to_chat(usr, SPAN_NOTICE("Added the item \"[making.name]\" to the queue."))
		update_printables()
		return AUTOLATHE_QUEUED

	return AUTOLATHE_START_PRINTING

/obj/structure/machinery/ammo_packer/proc/start_printing()
	set waitfor = FALSE

	var/list/print_params

	busy = TRUE

	while(length(queue))
		if(inoperable())
			break
		print_params = queue[1]
		queue -= list(print_params)
		print_item(arglist(print_params))

	busy = FALSE

/obj/structure/machinery/ammo_packer/proc/print_item(datum/ammo_packer/recipe/recipe_to_print, multiplier, turf/make_loc)
	// Make sure autolathe can print the item
	if(!sheet_amount)
		projected_sheet_cost--
		visible_message("The [name] beeps rapidly, unable to print the current item \"[recipe_to_print.name]\".")
		return

	//Consume materials.
	projected_sheet_cost--
	sheet_amount--

	update_printables()

	currently_making_data = list(
		"name" = recipe_to_print.name,
		"multiplier" = multiplier
	)
	SStgui.update_uis(src)

	playsound(src, 'sound/machines/print.ogg', 25)
	sleep(2 SECONDS)
	playsound(src, 'sound/machines/print_off.ogg', 25)


	currently_making_data = list()
	SStgui.update_uis(src)

	//Sanity check.
	if(!recipe_to_print || !src)
		return

	icon_state = "[base_state]_eject"

	//Create the desired item.
	new recipe_to_print.path(make_loc)

	sleep(1 SECONDS)

	icon_state = "[base_state]"

/obj/structure/machinery/ammo_packer/proc/flip_hacked()
	hacked = !hacked
	update_printables()

/obj/structure/machinery/ammo_packer/proc/update_printables()
	var/index = 0
	var/max_print_amt

	printables = list()

	for(var/datum/ammo_packer/recipe/our_recipe in recipes)
		index++

		if(our_recipe.hidden && !hacked)
			continue

		var/list/print_data = list()

		print_data["name"] = our_recipe.name
		print_data["index"] = index
		print_data["can_make"] = TRUE
		print_data["multipliers"] = null
		print_data["has_multipliers"] = FALSE
		print_data["hacked"] = our_recipe.hidden
		print_data["recipe_category"] = our_recipe.category

		max_print_amt = sheet_amount

		if(!sheet_amount)
			print_data["can_make"] = FALSE

		if(print_data["can_make"] && max_print_amt > 1)
			print_data["has_multipliers"] = TRUE
			print_data["multipliers"] = list()

			var/max = min(max_print_amt, 4)
			for (var/i in 2 to (max - 1))
				print_data["multipliers"]["[i]"] =  i
			print_data["multipliers"]["[max]"] = max

		printables += list(print_data)

// Ammo box checks
/obj/structure/machinery/ammo_packer/proc/is_loose_ammo_box(obj/item/ammo_box/box_to_check)
	if(!box_to_check)
		return FALSE
	if(ispath(box_to_check.type, /obj/item/ammo_box/rounds))
		return TRUE
	return FALSE

/obj/structure/machinery/ammo_packer/proc/is_handfuls_ammo_box(obj/item/ammo_box/box_to_check)
	if(!box_to_check)
		return FALSE
	if(!ispath(box_to_check.type, /obj/item/ammo_box/magazine))
		return FALSE
	var/obj/item/ammo_box/magazine/magazine_box_to_check = box_to_check
	if(magazine_box_to_check.handfuls)
		return TRUE
	return FALSE

// Ammo loading procs
/obj/structure/machinery/ammo_packer/proc/load_ammo_box(obj/item/ammo_box/box_to_load, mob/user)
	if(inoperable())
		return
	if(!box_to_load || !user)
		return
	if(packer_busy)
		to_chat(user, SPAN_WARNING("[src] is busy!"))
		return
	if(loaded_box)
		to_chat(user, SPAN_WARNING("There is something already loaded in the [src]!"))
		return
	icon_state = "[base_state]_box"
	packer_busy = TRUE
	to_chat(usr, SPAN_NOTICE("You start loading the [box_to_load] into the [src]."))
	if(!do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		icon_state = "[base_state]"
		packer_busy = FALSE
		return
	icon_state = "[base_state]"
	if(inoperable() || !packer_busy)
		packer_busy = FALSE
		to_chat(user, SPAN_WARNING("[src] is busy!"))
		return
	user.drop_inv_item_to_loc(box_to_load, src)
	box_to_load.forceMove(src)
	loaded_box = box_to_load
	// set the max storage amount for the box and load type (for UI and mode)
	if(is_loose_ammo_box(loaded_box))
		var/obj/item/ammo_box/rounds/loose_ammo_box = box_to_load
		loaded_box_max_storage = loose_ammo_box.max_bullet_amount
		loaded_box_load_type = AMMO_PACKER_ROUNDS_BOX_LOADED
	else
		var/obj/item/ammo_box/magazine/magazine_ammo_box = box_to_load
		loaded_box_max_storage = magazine_ammo_box.num_of_magazines
		if(ispath(magazine_ammo_box.type, /obj/item/ammo_box/magazine/misc))
			loaded_box_load_type = AMMO_PACKER_ITEM_BOX_LOADED
		if(is_handfuls_ammo_box(magazine_ammo_box))
			loaded_box_load_type = AMMO_PACKER_HANDFULS_MAGAZINE_BOX_LOADED
		else
			loaded_box_load_type = AMMO_PACKER_MAGAZINE_BOX_LOADED

	packer_busy = FALSE
	playsound(src, 'sound/handling/ammobox_drop.ogg', 25, TRUE)
	to_chat(usr, SPAN_NOTICE("You load the [box_to_load] into the [src]."))
	visible_message("[user] loads the [box_to_load] into the [src].")

/obj/structure/machinery/ammo_packer/proc/unload_ammo_box(mob/user)
	if(inoperable())
		return
	if(!user)
		return
	if(packer_busy)
		to_chat(user, SPAN_WARNING("The [src] is busy!"))
		return
	if(!loaded_box)
		to_chat(user, SPAN_WARNING("There is nothing to eject!"))
		return
	icon_state = "[base_state]_box"
	packer_busy = TRUE
	to_chat(usr, SPAN_NOTICE("You start unloading the [loaded_box] from the [src]."))
	if(!do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		icon_state = "[base_state]"
		packer_busy = FALSE
		return
	icon_state = "[base_state]"
	if(inoperable() || !packer_busy)
		packer_busy = FALSE
		to_chat(user, SPAN_WARNING("[src] is busy!"))
		return
	user.put_in_hands(loaded_box)
	loaded_box = null
	loaded_box_max_storage = 0
	loaded_box_load_type = "UNKNOWN"
	packer_busy = FALSE
	playsound(src, 'sound/handling/ammobox_pickup.ogg', 25, TRUE)
	to_chat(usr, SPAN_NOTICE("You unload the [loaded_box] from the [src]."))
	visible_message("[user] unloads the [loaded_box] from the [src].")

/obj/structure/machinery/ammo_packer/proc/attempt_load_magazine(obj/magazine, mob/user)
	if(!magazine || !user)
		return
	if(length(magazines_in_storage) >= max_magazine_storage)
		to_chat(user, SPAN_WARNING("The [src] cannot hold anymore magazines!"))
		return
	magazines_in_storage += magazine
	user.drop_inv_item_to_loc(magazine, src)
	magazine.forceMove(src)
	playsound(src, 'sound/machines/switch.ogg', 25, TRUE)
	to_chat(usr, SPAN_NOTICE("You put the [magazine] into the [src]."))
	visible_message("[user] puts [magazine] into the [src].")

/obj/structure/machinery/ammo_packer/proc/attempt_load_item(obj/item, mob/user)
	if(!item || !user)
		return
	if(length(items_in_storage) >= max_item_storage)
		to_chat(user, SPAN_WARNING("The [src] cannot hold anymore miscellaneous items!"))
		return
	items_in_storage += item
	user.drop_inv_item_to_loc(item, src)
	item.forceMove(src)
	playsound(src, 'sound/machines/switch.ogg', 25, TRUE)
	to_chat(usr, SPAN_NOTICE("You put the [item] into the [src]."))
	visible_message("[user] puts [item] into the [src].")

/obj/structure/machinery/ammo_packer/proc/eject_items_in_list(mob/user, list/stuff_to_eject, is_ejecting_magazines)
	if(!user)
		return
	if(isnull(is_ejecting_magazines))
		return
	if(inoperable())
		return
	if(packer_busy)
		to_chat(user, SPAN_WARNING("The [src] is busy!"))
		return
	if(!length(stuff_to_eject))
		return
	if(is_ejecting_magazines)
		ejecting_magazines = TRUE
	else
		ejecting_items = TRUE
	packer_busy = TRUE
	while(length(stuff_to_eject) && packer_busy)
		for(var/obj/item in stuff_to_eject)
			if(inoperable() || !packer_busy)
				break
			var/turf/exit = get_step(src,(EAST))
			if(exit.density)
				exit = get_turf(src)
			item.forceMove(exit)
			stuff_to_eject -= item
			playsound(src, 'sound/machines/terminal_eject.ogg', 15, TRUE)
			sleep(0.5 SECONDS)
	if(is_ejecting_magazines)
		ejecting_magazines = FALSE
	else
		ejecting_items = FALSE
	packer_busy = FALSE
