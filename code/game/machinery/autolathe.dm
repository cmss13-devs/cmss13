#define AUTOLATHE_WIRE_HACK 1
#define AUTOLATHE_WIRE_SHOCK 2
#define AUTOLATHE_WIRES_UNCUT (AUTOLATHE_WIRE_HACK|AUTOLATHE_WIRE_SHOCK) // when none of the wires are cut

/obj/structure/machinery/autolathe
	name = "\improper autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	var/base_state = "autolathe"
	unacidable = TRUE
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100

	var/list/stored_material = list("metal" = 30000, "glass" = 2000)
	var/list/projected_stored_material // will be <= stored_material values
	var/list/storage_capacity = list("metal" = 0, "glass" = 0)
	var/list/printables = list() // data list of each printable item (for tgUI)
	var/list/recipes
	var/list/categories
	var/list/disabled_categories = AUTOLATHE_STANDARD_DISABLED_CATS_LIST
	var/list/components = list(
		/obj/item/circuitboard/machine/autolathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)

	var/panel_open = FALSE
	var/hacked = FALSE
	var/shocked = FALSE
	var/busy = FALSE
	var/turf/make_loc

	var/wires = AUTOLATHE_WIRES_UNCUT

	/// theme for tgui
	var/tgui_theme = "normal"
	/// queue of items to be printed after the current one is done
	var/list/queue = list()
	/// max length of the queue
	var/queue_max = AUTOLATHE_MAX_QUEUE
	/// the item the autolathe is currently printing. Used for tgui
	var/list/currently_making_data = list()

/obj/structure/machinery/autolathe/proc/electrify(seconds_to_unshock)
	shocked = TRUE
	visible_message(SPAN_WARNING("Electric arcs begin to fly off \the [src]!"), SPAN_WARNING("You hear zaps!"), 3)
	addtimer(VARSET_CALLBACK(src, shocked, FALSE), seconds_to_unshock)

/obj/structure/machinery/autolathe/Initialize(mapload, ...)
	. = ..()
	projected_stored_material = stored_material.Copy()
	if(!mapload)
		for(var/res as anything in projected_stored_material)
			projected_stored_material[res] = 0
			stored_material[res] = 0

	//Create global autolathe recipe list if it hasn't been made already.
	if(isnull(recipes))
		recipes = list()
		categories = list()
		for(var/R in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe-/datum/autolathe/recipe/armylathe-/datum/autolathe/recipe/medilathe)
			var/datum/autolathe/recipe/recipe = new R
			if(recipe.category in disabled_categories)
				continue
			recipes += recipe
			categories |= recipe.category

			var/obj/item/I = new recipe.path
			if(I.matter && !recipe.resources) //This can be overidden in the datums.
				recipe.resources = list()
				for(var/material in I.matter)
					if(!isnull(storage_capacity[material]))
						if(istype(I,/obj/item/stack/sheet))
							recipe.resources[material] = I.matter[material] //Doesn't take more if it's just a sheet or something. Get what you put in.
						else
							recipe.resources[material] = floor(I.matter[material]*1.25) // More expensive to produce than they are to recycle.
			QDEL_NULL(I)

	//Create parts for lathe.
	for(var/component in components)
		LAZYADD(component_parts, new component(src))
	RefreshParts()
	update_printables()

// --- TGUI GOES HERE --- \\

/obj/structure/machinery/autolathe/attack_hand(mob/user)
	if(..())
		return
	if(shocked)
		shock(user, 50)
		return
	tgui_interact(user)

/obj/structure/machinery/autolathe/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autolathe", "[name] control panel")
		ui.open()

/obj/structure/machinery/autolathe/ui_data(mob/user)
	var/list/data = list()

	if(queue.len)
		var/list/queue_list = list()
		var/i = 0
		for(var/params in queue)
			i++
			var/datum/autolathe/recipe/making = params[1]
			var/multiplier = params[2]
			queue_list += list(list("name" = making.name, "multiplier" = multiplier, "index" = i))

		data["queued"] = queue_list
	else
		data["queued"] = null

	if(currently_making_data.len)
		data["currently_making"] = currently_making_data
	else
		data["currently_making"] = null

	data["materials"] = stored_material
	data["printables"] = printables

	var/list/wire_descriptions = get_wire_descriptions()
	var/list/panel_wires = list()
	for(var/wire = 1 to wire_descriptions.len)
		panel_wires += list(list("desc" = wire_descriptions[wire], "cut" = isWireCut(wire)))

	data["electrical"] = list(
		"electrified" = shocked,
		"panel_open" = panel_open,
		"wires" = panel_wires,
		"powered" = stat & NOPOWER,
	)

	return data

/obj/structure/machinery/autolathe/ui_static_data(mob/user)
	var/list/data = list()

	var/list/catslist = list(AUTOLATHE_CATEGORY_ALL)

	catslist.Add(categories)

	data["selectable_categories"] = catslist
	data["capacity"] = storage_capacity
	data["queuemax"] = queue_max
	data["theme"] = tgui_theme

	return data

/obj/structure/machinery/autolathe/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	switch(action)
		if("cancel")
			var/index = params["index"]
			if(index < 1 || index > queue.len)
				return

			var/list/to_del = queue[index]
			var/datum/autolathe/recipe/making = to_del[1]
			var/multiplier = to_del[2]

			if(making.name != params["name"])
				return
			else if(multiplier != params["multiplier"])
				return

			for (var/material in making.resources)
				projected_stored_material[material] = min(projected_stored_material[material]+(making.resources[material]*multiplier), storage_capacity[material])

			to_chat(usr, SPAN_NOTICE("Removed the item \"[making.name]\" from the queue."))
			queue -= list(to_del)
			update_printables()
			. = TRUE

		if("make")
			if(!recipes)
				return

			var/index = params["index"]
			var/multiplier = text2num(params["multiplier"])
			var/datum/autolathe/recipe/making

			if(!ishuman(usr))
				return

			if(!initial(make_loc))
				make_loc = get_step(loc, get_dir(src,usr))

			if(index > 0 && index <= recipes.len)
				making = recipes[index]

			//Exploit detection, not sure if necessary after rewrite.
			if(!making || multiplier < 0 || multiplier > 100)
				var/turf/exploit_loc = get_turf(usr)
				message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "[ADMIN_JMP(exploit_loc)]" : "null"])")
				return

			if(making.is_stack)
				if(try_queue(usr, making, make_loc, multiplier) == AUTOLATHE_START_PRINTING)
					start_printing()
				return

			for (var/i in 1 to multiplier)
				var/result = try_queue(usr, making, make_loc)
				switch (result)
					if(AUTOLATHE_FAILED)
						return
					if(AUTOLATHE_START_PRINTING)
						start_printing()
			. = TRUE

		if("cutwire")
			if(!panel_open)
				return FALSE
			if(!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(usr, SPAN_WARNING("You don't understand anything about this wiring..."))
				return FALSE
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(usr, SPAN_WARNING("You need wirecutters!"))
				return TRUE

			var/wire = params["wire"]
			cut(wire)
			return TRUE
		if("fixwire")
			if(!panel_open)
				return FALSE
			if(!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(usr, SPAN_WARNING("You don't understand anything about this wiring..."))
				return FALSE
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(usr, SPAN_WARNING("You need wirecutters!"))
				return TRUE
			var/wire = params["wire"]
			mend(wire)
			return TRUE
		if("pulsewire")
			if(!panel_open)
				return FALSE
			if(!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(usr, SPAN_WARNING("You don't understand anything about this wiring..."))
				return FALSE
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
				to_chat(usr, "You need multitool!")
				return TRUE
			var/wire = params["wire"]
			if (isWireCut(wire))
				to_chat(usr, SPAN_WARNING("You can't pulse a cut wire."))
				return TRUE
			pulse(wire)
			return TRUE

// --- END TGUI --- \\

/obj/structure/machinery/autolathe/attackby(obj/item/O as obj, mob/user as mob)
	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You are not trained to dismantle machines..."))
			return
		panel_open = !panel_open
		icon_state = (panel_open ? "[base_state]_t": "[base_state]")
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance hatch of [src].")
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(HAS_TRAIT(O, TRAIT_TOOL_MULTITOOL) || HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
			attack_hand(user)
			return

		//Dismantle the frame.
		if(HAS_TRAIT(O, TRAIT_TOOL_CROWBAR))
			dismantle()
			return

	if(inoperable())
		return

	//Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.matter)
		to_chat(user, "\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	var/filltype = 0    // Used to determine message.
	var/total_used = 0  // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)

		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		projected_stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(!filltype)
		to_chat(user, SPAN_DANGER("\The [src] is full. Please remove material from the [name] in order to insert more."))
		return
	else if(filltype == 1)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("[base_state]_o",src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1,floor(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else if(user.temp_drop_inv_item(O))
		qdel(O)

	update_printables()
	updateUsrDialog()
	return TRUE //so the item's afterattack isn't called

//Updates overall lathe storage size.
/obj/structure/machinery/autolathe/RefreshParts()
	..()
	var/tot_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		tot_rating += MB.rating

	for(var/material in storage_capacity)
		storage_capacity[material] = tot_rating  * 30000

/obj/structure/machinery/autolathe/proc/try_queue(mob/living/carbon/human/user, datum/autolathe/recipe/making, turf/make_loc, multiplier = 1)
	if(queue.len >= queue_max)
		to_chat(usr, SPAN_DANGER("The [name] has queued the maximum number of operations. Please wait for completion of current operation."))
		return AUTOLATHE_FAILED

	//This needs some work.
	use_power(max(2000, (making.power_use*multiplier)))

	//Check if we still have the materials.
	for(var/material in making.resources)
		if(projected_stored_material[material] && projected_stored_material[material] >= (making.resources[material]*multiplier))
			continue
		to_chat(user, SPAN_DANGER("The [name] does not have the materials to create \the [making.name]."))
		return AUTOLATHE_FAILED

	for (var/material in making.resources)
		projected_stored_material[material] = max(0, projected_stored_material[material]-(making.resources[material]*multiplier))

	var/list/print_params = list(making, multiplier, make_loc)
	queue += list(print_params) // This notation is necessary because of how adding to lists works

	if(busy)
		to_chat(usr, SPAN_NOTICE("Added the item \"[making.name]\" to the queue."))
		update_printables()
		return AUTOLATHE_QUEUED

	return AUTOLATHE_START_PRINTING

/obj/structure/machinery/autolathe/proc/start_printing()
	set waitfor = FALSE

	var/list/print_params

	busy = TRUE

	while (queue.len)
		print_params = queue[1]
		queue -= list(print_params)
		print_item(arglist(print_params))

	busy = FALSE

/obj/structure/machinery/autolathe/proc/print_item(datum/autolathe/recipe/making, multiplier, turf/make_loc)
	// Make sure autolathe can print the item
	for(var/material in making.resources)
		if(isnull(stored_material[material]) || stored_material[material] < (making.resources[material]*multiplier))
			visible_message("The [name] beeps rapidly, unable to print the current item \"[making.name]\".")
			return

	//Consume materials.
	for(var/material in making.resources)
		if(stored_material[material])
			stored_material[material] = max(0,stored_material[material]-(making.resources[material]*multiplier))

	update_printables()

	currently_making_data = list(
		"name" = making.name,
		"multiplier" = multiplier
	)
	SStgui.update_uis(src)

	//Print speed based on w_class.
	var/obj/item/item = making.path
	var/size = initial(item.w_class)
	var/print_speed = clamp(size, 2, 5) SECONDS

	//Fancy autolathe animation.
	icon_state = "[base_state]_n"

	playsound(src, 'sound/machines/print.ogg', 25)
	sleep(print_speed)
	playsound(src, 'sound/machines/print_off.ogg', 25)
	icon_state = "[base_state]"

	currently_making_data = list()
	SStgui.update_uis(src)

	//Sanity check.
	if(!making || !src)
		return

	//Create the desired item.
	var/obj/item/I = new making.path(make_loc)
	if(multiplier > 1 && istype(I,/obj/item/stack))
		var/obj/item/stack/S = I
		S.amount = multiplier

/obj/structure/machinery/autolathe/proc/get_wire_descriptions()
	return list(
		AUTOLATHE_WIRE_HACK = "Item template controller",
		AUTOLATHE_WIRE_SHOCK = "Ground safety"
	)

/obj/structure/machinery/autolathe/proc/isWireCut(wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/autolathe/proc/cut(wire, mob/user)
	wires ^= getWireFlag(wire)

	switch (wire)
		if(AUTOLATHE_WIRE_HACK)
			hacked = TRUE
			visible_message(SPAN_NOTICE("A blue light turns on in the panel of \the [src]."))
			update_printables()
		if(AUTOLATHE_WIRE_SHOCK)
			shock(user, 50)
			shocked = TRUE
			visible_message(SPAN_DANGER("A green light turns on in the panel of \the [src] \
				as electric arcs continuously shoot off from it!"))

/obj/structure/machinery/autolathe/proc/mend(wire, mob/user)
	wires |= getWireFlag(wire)

	switch (wire)
		if(AUTOLATHE_WIRE_HACK)
			hacked = FALSE
			visible_message(SPAN_NOTICE("A blue light turns off in the panel of \the [src]."))
			update_printables()
		if(AUTOLATHE_WIRE_SHOCK)
			shock(user, 50)
			shocked = FALSE
			visible_message(SPAN_DANGER("A green light turns off in the panel of \the [src]."))

/obj/structure/machinery/autolathe/proc/pulse(wire, mob/user)
	switch (wire)
		if(AUTOLATHE_WIRE_HACK)
			hacked = !hacked
			visible_message(SPAN_NOTICE("A blue light flickers [hacked ? "on" : "off"] in the panel of \the [src]."))
			update_printables()
			addtimer(CALLBACK(src, PROC_REF(flip_hacked)), 10 SECONDS)
		if(AUTOLATHE_WIRE_SHOCK)
			shock(user, 50)
			electrify(10 SECONDS)
			if(!machine_processing)
				start_processing()
			visible_message(SPAN_DANGER("A green light flashes in the panel of \the [src] \
				as electric arcs shoot off from it!"))

/obj/structure/machinery/autolathe/proc/flip_hacked()
	hacked = !hacked
	update_printables()

/obj/structure/machinery/autolathe/proc/update_printables()
	var/index = 0
	var/max_print_amt
	var/print_amt

	printables = list()

	for(var/datum/autolathe/recipe/R in recipes)
		index++

		if(R.hidden && !hacked)
			continue

		var/list/print_data = list()

		print_data["name"] = R.name
		print_data["index"] = index
		print_data["can_make"] = TRUE
		print_data["materials"] = list()
		print_data["multipliers"] = null
		print_data["has_multipliers"] = FALSE
		print_data["hidden"] = R.hidden
		print_data["recipe_category"] = R.category

		max_print_amt = -1

		if(!R.resources || !R.resources.len)
			print_data["materials"] = "No resources required"
		else
			//Make sure it's buildable and list requires resources.
			for(var/material in R.resources)
				if(isnull(projected_stored_material[material]) || projected_stored_material[material] < R.resources[material])
					print_data["can_make"] = FALSE
					max_print_amt = 0
				else
					print_amt = floor(projected_stored_material[material]/R.resources[material])

				if(print_data["can_make"] && max_print_amt < 0 || max_print_amt > print_amt)
					max_print_amt = print_amt

				print_data["materials"][material] = "[R.resources[material]] [material]"

			if(print_data["can_make"] && max_print_amt > 1)
				print_data["has_multipliers"] = TRUE
				print_data["multipliers"] = list()

				var/max = max_print_amt

				if(R.is_stack)
					for (var/i = 5; i < max_print_amt; i += i) //5,10,20,40...
						print_data["multipliers"]["[i]"] =  i
				else
					max = min(max_print_amt, queue_max)
					for (var/i in 2 to (max - 1))
						print_data["multipliers"]["[i]"] =  i
				print_data["multipliers"]["[max]"] = max

		printables += list(print_data)

/obj/structure/machinery/autolathe/full
	stored_material =  list("metal" = 40000, "glass" = 20000)

/obj/structure/machinery/autolathe/armylathe
	name = "\improper Armylathe"
	desc = "A specialized autolathe made for printing USCM weaponry and parts."
	icon_state = "armylathe"
	base_state = "armylathe"
	recipes = null
	categories = null
	disabled_categories = AUTOLATHE_ARMYLATHE_DISABLED_CATS_LIST
	storage_capacity = list("metal" = 0, "plastic" = 0)
	stored_material =  list("metal" = 0, "plastic" = 0)
	components = list(
		/obj/item/circuitboard/machine/autolathe/armylathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen,
	)

/obj/structure/machinery/autolathe/armylathe/full
	stored_material =  list("metal" = 56250, "plastic" = 20000) //15 metal and 10 plastic sheets

/obj/structure/machinery/autolathe/armylathe/attack_hand(mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You have no idea how to operate the [name]."))
		return FALSE
	. = ..()

/obj/structure/machinery/autolathe/medilathe
	name = "\improper Medilathe"
	desc = "A specialized autolathe made for printing medical items."
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	icon_state = "medilathe"
	base_state = "medilathe"
	active_power_usage = 1000
	layer = BELOW_OBJ_LAYER
	recipes = null
	categories = null
	density = TRUE
	bound_x = 32
	storage_capacity = list("glass" = 0, "plastic" = 0)
	stored_material =  list("glass" = 0, "plastic" = 0)
	disabled_categories = AUTOLATHE_MEDILATHE_DISABLED_CATS_LIST
	make_loc = TRUE
	tgui_theme = "weyland"

/obj/structure/machinery/autolathe/medilathe/full
	stored_material =  list("glass" = 20000, "plastic" = 40000) //20 plastic and 10 glass sheets

/obj/structure/machinery/autolathe/medilathe/attack_hand(mob/user)
	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DOCTOR))
		to_chat(user, SPAN_WARNING("You have no idea how to operate \the [name]."))
		return FALSE
	. = ..()

/obj/structure/machinery/autolathe/medilathe/Initialize()
	. = ..()
	if(dir == SOUTH || dir == EAST)
		make_loc = get_step(get_step(loc, EAST), EAST)
	else
		make_loc = get_step(get_step(loc, EAST), WEST)
