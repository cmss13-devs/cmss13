// thingy to print robot limbs :3

/obj/structure/machinery/bioprinter
	name = "\improper Weyland-Yutani synthetic limb printer 2000"
	desc = "A machine that can produce synthetic limbs of dubious quality. Smells of smoke and battery acid. The USCM has recently rejected an offer for the 3000 series, which can also print synthetic organs, on the basis of unreliability."
	icon = 'icons/obj/structures/machinery/surgery.dmi'

	anchored = TRUE
	density = TRUE

	icon_state = "bioprinter"

	var/working = FALSE
	var/stored_metal = 0
	var/max_metal = 500
	var/global/list/products
	var/print_time // time at which an organ will be printed
	var/datum/bioprinter_recipe/printing_item // what it is printing

/obj/structure/machinery/bioprinter/Initialize()
	. = ..()
	if(isnull(products))
		products = list()
		for(var/i in subtypesof(/datum/bioprinter_recipe))
			var/datum/bioprinter_recipe/bp_recipe = new i
			products += bp_recipe

/obj/structure/machinery/bioprinter/update_icon()
	. = ..()
	icon_state = initial(icon_state)
	if(working)
		icon_state = "[icon_state]_working"

/obj/structure/machinery/bioprinter/attack_hand(mob/user)
	if(inoperable())
		return

	tgui_interact(user)

/obj/structure/machinery/bioprinter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/sheet/metal))
		if(stored_metal == max_metal)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
			return
		var/obj/item/stack/sheet/metal/M = W
		var/sheets_to_eat = (round((max_metal - stored_metal), 100))/100
		if(!sheets_to_eat)
			sheets_to_eat = 1
		if(M.amount >= sheets_to_eat)
			stored_metal += sheets_to_eat * 100
			M.use(sheets_to_eat)
		else
			stored_metal += M.amount * 100
			M.use(M.amount)
		if(stored_metal > max_metal)
			stored_metal = max_metal
		to_chat(user, SPAN_NOTICE("\The [src] processes \the [W]."))
	else
		return..()

/obj/structure/machinery/bioprinter/get_examine_text(mob/user)
	. = ..()
	. += "It has [stored_metal] metal left."

/obj/structure/machinery/bioprinter/ui_static_data(mob/user)
	var/list/data = list()

	var/list/recipes = list()
	for(var/i in products)
		var/datum/bioprinter_recipe/recipe = i
		recipes += list(list(
			"recipe_id" = recipe,
			"name" = recipe.title,
			"time" = recipe.time,
			"metal" = recipe.metal
		))
	data["recipes"] = recipes
	data["metal_max"] = max_metal

	return data

/obj/structure/machinery/bioprinter/ui_data(mob/user)
	var/list/data = list()

	data["working"] = working
	data["metal_amt"] = stored_metal
	data["printtime"] = print_time
	data["worldtime"] = world.time
	if(printing_item)
		data["printingitem"] = printing_item.title
		data["printingitemtime"] = printing_item.time

	return data

/obj/structure/machinery/bioprinter/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BioSyntheticPrinter", "Limb Printer")
		ui.open()

/obj/structure/machinery/bioprinter/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/bioprinter/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/bioprinter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("print")
			if(working)
				//If we're already printing something then we're too busy to multi task.
				to_chat(usr, SPAN_NOTICE("[src] is busy at the moment."))
				return FALSE
			var/recipe = params["recipe_id"]
			var/valid_recipe = FALSE
			for(var/datum/bioprinter_recipe/product_recipes in products)
				if(product_recipes.type == text2path(recipe))
					valid_recipe = TRUE
					break
			if(!valid_recipe)
				log_admin("[key_name(usr)] attempted to print an invalid recipe ([recipe]) on \the [src].")
				message_admins("[key_name(usr)] attempted to print an invalid recipe on \the [src].")
				return FALSE
			var/datum/bioprinter_recipe/recipe_datum = new recipe
			if(stored_metal < recipe_datum.metal)
				to_chat(usr, SPAN_NOTICE("[src] does not have enough stored metal."))
				QDEL_NULL(recipe_datum)
				return FALSE
			stored_metal -= recipe_datum.metal
			to_chat(usr, SPAN_NOTICE("\The [src] is now printing the selected organ. Please hold."))
			working = TRUE
			update_icon()
			var/new_organ = recipe_datum.path
			print_time = world.time + recipe_datum.time
			printing_item = recipe_datum
			addtimer(CALLBACK(src, PROC_REF(print_limb), new_organ), recipe_datum.time)
			QDEL_NULL(recipe_datum)
			return TRUE
		if("eject")
			var/sheets_to_print = (stored_metal/100)
			sheets_to_print -= 0.5
			sheets_to_print = round(sheets_to_print, 1)
			stored_metal -= sheets_to_print*100
			visible_message("\The [src] ejects [sheets_to_print] metal sheets from its storage.")
			new /obj/item/stack/sheet/metal(get_turf(src), sheets_to_print)
			return TRUE


/obj/structure/machinery/bioprinter/proc/print_limb(limb_path)
	if(inoperable())
		//In case we lose power or anything between the print and the callback we don't want to permenantly break the printer
		working = FALSE
		return
	new limb_path(get_turf(src))
	working = FALSE
	update_icon()
	printing_item = null
	visible_message("\The [src] spits out a new organ.")
	return


/datum/bioprinter_recipe
	var/title = "recipe"
	var/path = /obj/item/robot_parts/head //error part
	var/time = LIMB_PRINTING_TIME
	var/metal = LIMB_METAL_AMOUNT

/datum/bioprinter_recipe/l_arm
	title = "synthetic left arm"
	path = /obj/item/robot_parts/arm/l_arm

/datum/bioprinter_recipe/r_arm
	title = "synthetic right arm"
	path = /obj/item/robot_parts/arm/r_arm

/datum/bioprinter_recipe/r_leg
	title = "synthetic right leg"
	path = /obj/item/robot_parts/leg/r_leg

/datum/bioprinter_recipe/l_leg
	title = "synthetic left leg"
	path = /obj/item/robot_parts/leg/l_leg
