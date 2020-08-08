#define AUTOLATHE_WIRE_HACK 	1
#define AUTOLATHE_WIRE_SHOCK	2
#define AUTOLATHE_WIRES_UNCUT	(AUTOLATHE_WIRE_HACK|AUTOLATHE_WIRE_SHOCK) // when none of the wires are cut

/obj/structure/machinery/autolathe
	name = "\improper autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	var/base_state = "autolathe"
	unacidable = TRUE
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100

	var/list/stored_material =  list("metal" = 30000, "glass" = 20000)
	var/list/projected_stored_material // will be <= stored_material values
	var/list/storage_capacity = list("metal" = 0, "glass" = 0)
	var/show_category = "All"
	var/list/printable = list() // data list of each printable item (for NanoUI)
	var/list/recipes
	var/list/categories
	var/list/disabled_categories = list("Explosives", "Medical", "Medical Containers")
	var/list/components = list(
		/obj/item/circuitboard/machine/autolathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)

	var/panel_open = FALSE
	var/hacked = FALSE
	var/seconds_electrified = 0
	var/busy = FALSE
	var/turf/make_loc

	var/wires = AUTOLATHE_WIRES_UNCUT

	var/list/queue = list()
	var/queue_max = AUTOLATHE_MAX_QUEUE

/obj/structure/machinery/autolathe/Initialize()
	. = ..()
	projected_stored_material = stored_material.Copy()

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
							recipe.resources[material] = round(I.matter[material]*1.25) // More expensive to produce than they are to recycle.
				qdel(I)

	//Create parts for lathe.
	component_parts = list()
	for(var/component in components)
		component_parts += new component(src)
	RefreshParts()

	update_printable()

/obj/structure/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/tool/screwdriver))
		if (!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You are not trained to dismantle machines..."))
			return
		panel_open = !panel_open
		icon_state = (panel_open ? "[base_state]_t": "[base_state]")
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance hatch of [src].")
		return

	if (panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(istype(O, /obj/item/device/multitool) || istype(O, /obj/item/tool/wirecutters))
			attack_hand(user)
			return

		//Dismantle the frame.
		if(istype(O, /obj/item/tool/crowbar))
			dismantle()
			return

	if (stat)
		return

	//Resources are being loaded.
	var/obj/item/eating = O
	if (!eating.matter)
		to_chat(user, "\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
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

	if (istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1,round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else if (user.temp_drop_inv_item(O))
		qdel(O)

	update_printable()
	updateUsrDialog()
	return TRUE //so the item's afterattack isn't called

/obj/structure/machinery/autolathe/process()
	if (seconds_electrified > 0)
		seconds_electrified--
	
	if (seconds_electrified <= 0)
		stop_processing()

/obj/structure/machinery/autolathe/attack_hand(var/mob/user)
	if (stat)
		return

	if (seconds_electrified != 0)
		shock(user, 50)

	user.set_interaction(src)
	ui_interact(user)

/obj/structure/machinery/autolathe/Topic(href, href_list)
	if(..())
		return

	usr.set_interaction(src)
	add_fingerprint(usr)

	if (href_list["change_category"])
		var/choice = input("Which category do you wish to display?") as null|anything in categories+"All"
		if(!choice) 
			return
		show_category = choice
		update_printable()
		return

	else if (href_list["cancel"])
		var/index = text2num(href_list["index"])
		if (index < 1 || index > queue.len)
			return
		
		var/list/to_del = queue[index]
		var/datum/autolathe/recipe/making = to_del[1]
		var/multiplier = to_del[2]

		if (making.name != href_list["name"])
			return
		else if (multiplier != text2num(href_list["multiplier"]))
			return
		
		for (var/material in making.resources)
			projected_stored_material[material] = min(projected_stored_material[material]+(making.resources[material]*multiplier), storage_capacity[material])

		to_chat(usr, SPAN_NOTICE("Removed the item \the [making.name] from the queue."))
		queue -= list(to_del)
		update_printable()
		updateUsrDialog()
		return

	else if (href_list["make"] && recipes)
		var/index = text2num(href_list["make"])
		var/multiplier = text2num(href_list["multiplier"])
		var/datum/autolathe/recipe/making

		if (!ishuman(usr))
			return
		
		if(!initial(make_loc))
			make_loc = get_step(loc, get_dir(src,usr))

		if (index > 0 && index <= recipes.len)
			making = recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if (!making || multiplier < 0 || multiplier > 100)
			var/turf/exploit_loc = get_turf(usr)
			message_staff("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])")
			return

		if (making.is_stack)
			if (try_queue(usr, making, make_loc, multiplier) == AUTOLATHE_START_PRINTING)
				start_printing()
			return
		
		for (var/i in 1 to multiplier)
			var/result = try_queue(usr, making, make_loc)
			switch (result)
				if (AUTOLATHE_FAILED)
					return
				if (AUTOLATHE_START_PRINTING)
					start_printing()			
		updateUsrDialog()
		return

	else if ((href_list["cutwire"]) && (panel_open))
		var/wire = text2num(href_list["cutwire"])

		if (!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(usr, SPAN_WARNING("You don't understand anything about this wiring..."))
			return

		if (!iswirecutter(usr.get_active_hand()))
			to_chat(usr, "You need wirecutters!")
			return

		if (isWireCut(wire))
			mend(wire, usr)
		else
			cut(wire, usr)

	else if ((href_list["pulsewire"]) && (panel_open))
		var/wire = text2num(href_list["pulsewire"])

		if (!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(usr, SPAN_WARNING("You don't understand anything about this wiring..."))
			return 0

		if (!ismultitool(usr.get_active_hand()))
			to_chat(usr, "You need a multitool!")
			return

		if (isWireCut(wire))
			to_chat(usr, "You can't pulse a cut wire.")
			return
		else
			pulse(wire, usr)

//Updates overall lathe storage size.
/obj/structure/machinery/autolathe/RefreshParts()
	..()
	var/tot_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		tot_rating += MB.rating

	for(var/material in storage_capacity)
		storage_capacity[material] = tot_rating  * 30000

/obj/structure/machinery/autolathe/proc/try_queue(var/mob/living/carbon/human/user, var/datum/autolathe/recipe/making, var/turf/make_loc, var/multiplier = 1)
	if (queue.len >= queue_max)
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

	if (busy)
		to_chat(usr, SPAN_NOTICE("Added the item \"[making.name]\" to the queue."))
		update_printable()
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

/obj/structure/machinery/autolathe/proc/print_item(var/datum/autolathe/recipe/making, var/multiplier, var/turf/make_loc)
	// Make sure autolathe can print the item
	for(var/material in making.resources)
		if(isnull(stored_material[material]) || stored_material[material] < (making.resources[material]*multiplier))
			visible_message("The [name] beeps rapidly, unable to print the current item \"[making.name]\".")
			return

	//Consume materials.
	for(var/material in making.resources)
		if(stored_material[material])
			stored_material[material] = max(0,stored_material[material]-(making.resources[material]*multiplier))

	update_printable()

	//Fancy autolathe animation.
	icon_state = "[base_state]_n"

	playsound(src, 'sound/machines/print.ogg', 25)
	sleep(SECONDS_5)
	playsound(src, 'sound/machines/print_off.ogg', 25)
	icon_state = "[base_state]"

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
		AUTOLATHE_WIRE_HACK    	= "Item template controller",
		AUTOLATHE_WIRE_SHOCK	= "Ground safety"
	)

/obj/structure/machinery/autolathe/proc/isWireCut(var/wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/autolathe/proc/cut(var/wire, var/mob/user)
	wires ^= getWireFlag(wire)

	switch (wire)
		if (AUTOLATHE_WIRE_HACK)
			hacked = TRUE
			visible_message(SPAN_NOTICE("A blue light turns on in the panel of \the [src]."))
			update_printable()
		if (AUTOLATHE_WIRE_SHOCK)
			shock(user, 50)
			seconds_electrified = -1
			visible_message(SPAN_DANGER("A green light turns on in the panel of \the [src] \
				as electric arcs continuously shoot off from it!"))

/obj/structure/machinery/autolathe/proc/mend(var/wire, var/mob/user)
	wires |= getWireFlag(wire)

	switch (wire)
		if (AUTOLATHE_WIRE_HACK)
			hacked = FALSE
			visible_message(SPAN_NOTICE("A blue light turns off in the panel of \the [src]."))
			update_printable()
		if (AUTOLATHE_WIRE_SHOCK)
			shock(user, 50)
			seconds_electrified = 0
			visible_message(SPAN_DANGER("A green light turns off in the panel of \the [src]."))

/obj/structure/machinery/autolathe/proc/pulse(var/wire, var/mob/user)
	switch (wire)
		if (AUTOLATHE_WIRE_HACK)
			hacked = !hacked
			visible_message(SPAN_NOTICE("A blue light flickers [hacked ? "on" : "off"] in the panel of \the [src]."))
			update_printable()
			add_timer(CALLBACK(src, .proc/flip_hacked), SECONDS_10)
		if (AUTOLATHE_WIRE_SHOCK)
			shock(user, 50)
			seconds_electrified = 10
			if (!machine_processing)
				start_processing()
			visible_message(SPAN_DANGER("A green light flashes in the panel of \the [src] \
				as electric arcs shoot off from it!"))

/obj/structure/machinery/autolathe/proc/flip_hacked()
	hacked = !hacked
	update_printable()

/obj/structure/machinery/autolathe/proc/update_printable()
	var/index = 0
	var/max_print_amt
	var/print_amt

	printable = list()

	for(var/datum/autolathe/recipe/R in recipes)
		index++

		if (R.hidden && !hacked || (show_category != "All" && show_category != R.category))
			continue
		
		var/list/print_data = list()

		print_data["name"] = R.name
		print_data["index"] = index
		print_data["can_make"] = TRUE
		print_data["materials"] = list()
		print_data["multipliers"] = null
		print_data["has_multipliers"] = FALSE
		print_data["hidden"] = R.hidden
		
		max_print_amt = -1

		if (!R.resources || !R.resources.len)
			print_data["materials"] = "No resources required"
		else
			//Make sure it's buildable and list requires resources.
			for (var/material in R.resources)
				if (isnull(projected_stored_material[material]) || projected_stored_material[material] < R.resources[material])
					print_data["can_make"] = FALSE
					max_print_amt = 0
				else
					print_amt = round(projected_stored_material[material]/R.resources[material])
				
				if (print_data["can_make"] && max_print_amt < 0 || max_print_amt > print_amt)
					max_print_amt = print_amt
				
				print_data["materials"][material] = "[R.resources[material]] [material]"

			if (print_data["can_make"] && max_print_amt > 1)
				print_data["has_multipliers"] = TRUE
				print_data["multipliers"] = list()

				var/max = max_print_amt

				if (R.is_stack)
					for (var/i = 5; i < max_print_amt; i += i) //5,10,20,40...
						print_data["multipliers"]["[i]"] =  i
				else
					max = min(max_print_amt, queue_max)
					for (var/i in 2 to (max - 1))
						print_data["multipliers"]["[i]"] =  i
				print_data["multipliers"]["[max]"] = max

		printable += list(print_data)

/obj/structure/machinery/autolathe/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
	if (!ishuman(user)) 
		return

	var/list/queue_list = list()
	var/i = 1
	for (var/params in queue)
		var/datum/autolathe/recipe/making = params[1]
		var/multiplier = params[2]
		queue_list += list(list("name" = making.name, "index" = i++, "multiplier" = multiplier))

	var/list/data = list(
		"materials" = stored_material,
		"capacity" = storage_capacity,
		"queued" = queue_list,
		"printable" = printable,
		"category" = show_category,
		"panel_open" = panel_open
	)

	var/list/wire_descriptions = get_wire_descriptions()
	var/list/panel_wires = list()
	for(var/wire = 1 to wire_descriptions.len)
		panel_wires += list(list("desc" = wire_descriptions[wire], "cut" = isWireCut(wire)))

	if(panel_wires.len)
		data["wires"] = panel_wires

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "autolathe.tmpl", "[name] Control Panel" , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/structure/machinery/autolathe/yautja
	name = "\improper yautja autolathe"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/structures/machinery/predautolathe.dmi'

/obj/structure/machinery/autolathe/full
	stored_material =  list("metal" = 75000, "glass" = 37500)

/obj/structure/machinery/autolathe/armylathe
	name = "\improper Armylathe"
	desc = "A specialized autolathe made for printing USCM weaponry and parts."
	icon_state = "armylathe"
	base_state = "armylathe"
	recipes = null
	categories = null
	disabled_categories = list("General", "Tools", "Engineering", "Devices and Components", "Medical", "Medical Containers", "Surgery", "Glassware")
	storage_capacity = list("metal" = 0, "plastic" = 0)
	components = list(
		/obj/item/circuitboard/machine/autolathe/armylathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)
	
/obj/structure/machinery/autolathe/armylathe/full
	stored_material =  list("metal" = 56250, "plastic" = 20000) //15 metal and 10 plastic sheets

/obj/structure/machinery/autolathe/armylathe/attack_hand(var/mob/user)
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
	density = 1
	bound_x = 32
	storage_capacity = list("plastic" = 0, "glass" = 0)
	disabled_categories = list("General", "Tools", "Engineering", "Devices and Components", "Surgery", "Explosives")
	make_loc = TRUE

/obj/structure/machinery/autolathe/medilathe/full
	stored_material =  list("plastic" = 40000, "glass" = 20000) //20 plastic and 10 glass sheets

/obj/structure/machinery/autolathe/medilathe/attack_hand(var/mob/user)
	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You have no idea how to operate the [name]."))
		return FALSE
	. = ..()

/obj/structure/machinery/autolathe/medilathe/Initialize()
	..()
	if(dir == SOUTH || dir == EAST)
		make_loc = get_step(get_step(loc, EAST), EAST)
	else
		make_loc = get_step(get_step(loc, EAST), WEST)