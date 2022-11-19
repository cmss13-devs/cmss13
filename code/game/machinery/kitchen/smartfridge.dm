#define FRIDGE_WIRE_SHOCK		1
#define FRIDGE_WIRE_SHOOT_INV	2
#define FRIDGE_WIRE_IDSCAN		3

#define FRIDGE_LOCK_COMPLETE	1
#define FRIDGE_LOCK_ID			2
#define FRIDGE_LOCK_NOLOCK		3

/* SmartFridge.  Much todo
*/
/obj/structure/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "smartfridge"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	flags_atom = NOREACT
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/icon_panel = "smartfridge-panel"
	var/item_quants = list()
	var/ispowered = TRUE //starts powered
	var/is_secure_fridge = FALSE
	var/seconds_electrified = 0;
	var/shoot_inventory = FALSE
	var/locked = FRIDGE_LOCK_ID
	var/panel_open = FALSE //Hacking a smartfridge
	var/wires = 7
	var/networked = FALSE
	var/transfer_mode = FALSE

/obj/structure/machinery/smartfridge/Initialize(mapload, ...)
	. = ..()
	GLOB.vending_products[/obj/item/reagent_container/glass/bottle] = 1
	GLOB.vending_products[/obj/item/storage/pill_bottle] = 1

/obj/structure/machinery/smartfridge/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_container/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/structure/machinery/smartfridge/process()
	if(!src.ispowered)
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/structure/machinery/smartfridge/power_change()
	..()
	if( !(stat & NOPOWER) )
		src.ispowered = TRUE
		icon_state = icon_on
	else
		spawn(rand(0, 15))
			src.ispowered = FALSE
			icon_state = icon_off

//*******************
//*   Item Adding
//********************/

/obj/structure/machinery/smartfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		. = ..()
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, icon_panel)
		nanomanager.update_uis(src)
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_MULTITOOL)||HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
		if(panel_open)
			attack_hand(user)
		return

	if(!ispowered)
		to_chat(user, SPAN_NOTICE("\The [src] is unpowered and useless."))
		return

	if(accept_check(O))
		if(user.drop_held_item())
			add_item(O)
			user.visible_message(SPAN_NOTICE("[user] has added \the [O] to \the [src]."), \
								 SPAN_NOTICE("You add \the [O] to \the [src]."))

	else if(istype(O, /obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				P.remove_from_storage(G,src)
				if(item_quants[G.name])
					item_quants[G.name] += G
				else
					item_quants[G.name] = list(G)
				plants_loaded++
		if(plants_loaded)

			user.visible_message( \
				SPAN_NOTICE("[user] loads \the [src] with \the [P]."), \
				SPAN_NOTICE("You load \the [src] with \the [P]."))
			if(P.contents.len > 0)
				to_chat(user, SPAN_NOTICE("Some items are refused."))

	else if(!(O.flags_item & NOBLUDGEON)) //so we can spray, scan, c4 the machine.
		to_chat(user, SPAN_NOTICE("\The [src] smartly refuses [O]."))
		return 1

/obj/structure/machinery/smartfridge/attack_remote(mob/user)
	return 0

/obj/structure/machinery/smartfridge/attack_hand(mob/user)
	if(!ispowered)
		to_chat(user, SPAN_WARNING("[src] has no power."))
		return
	if(seconds_electrified != 0)
		if(shock(user, 100))
			return

	tgui_interact(user)

/obj/structure/machinery/smartfridge/proc/add_item(var/obj/item/O)
	O.forceMove(src)
	if(item_quants[O.name])
		item_quants[O.name] += O
	else
		item_quants[O.name] = list(O)

/obj/structure/machinery/smartfridge/proc/add_network_item(var/obj/item/O)
	if(is_in_network())
		chemical_data.shared_item_storage.Add(O)

		if(chemical_data.shared_item_quantity[O.name])
			chemical_data.shared_item_quantity[O.name]++
		else
			chemical_data.shared_item_quantity[O.name] = 1
		return TRUE
	return FALSE

//*******************
//*   SmartFridge Menu
//********************/

/obj/structure/machinery/smartfridge/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SmartFridge", name)
		ui.open()

/obj/structure/machinery/smartfridge/ui_static_data(mob/user)
	. = ..(user)
	.["networked"] = is_in_network()

/obj/structure/machinery/smartfridge/ui_data(mob/user)
	. = list()
	.["secure"] = is_secure_fridge
	.["transfer_mode"] = transfer_mode
	.["locked"] = locked

	var/list/wire_descriptions = get_wire_descriptions()
	var/list/panel_wires = list()
	for(var/wire = 1 to wire_descriptions.len)
		panel_wires += list(list("desc" = wire_descriptions[wire], "cut" = isWireCut(wire)))

	.["electrical"] = list(
		"electrified" = seconds_electrified > 0,
		"panel_open" = panel_open,
		"wires" = panel_wires,
		"shoot_inventory" = shoot_inventory,
	)

	var/list/local_items = list()
	for (var/i=1 to length(item_quants))
		var/obj/item_index = item_quants[i]
		var/list/item_list = item_quants[item_index]
		var/count = length(item_list)
		if(count < 1)
			continue

		var/item_name = item_list[1].name
		var/item_path = item_list[1].type
		var/item_desc = item_list[1].desc

		var/imgid = replacetext(replacetext("[item_path]", "/obj/item/", ""), "/", "-")

		var/item_type = "other"
		if(ispath(item_path, /obj/item/reagent_container/glass/bottle/))
			item_type = "bottle"
		else if(ispath(item_path, /obj/item/storage/pill_bottle/))
			item_type = "pills"

		if (count > 0)
			var/list/local_item = list(
				"display_name" = capitalize(item_name),
				"item" = item_path,
				"index" = i,
				"quantity" = count,
				"image" = imgid,
				"category" = item_type,
				"desc" = item_desc,
			)
			local_items += list(local_item)

	var/list/networked_items = list()
	if(is_in_network())
		for (var/i=1 to length(chemical_data.shared_item_quantity))
			var/item_name = chemical_data.shared_item_quantity[i]
			var/count = chemical_data.shared_item_quantity[item_name]
			if (count > 0)
				var/list/networked_item = list("display_name" = capitalize(item_name), "index" = i, "quantity" = count)
				networked_items += list(networked_item)

	.["storage"] = list(
		"contents" = local_items,
		"networked" = networked_items,
	)

/obj/structure/machinery/smartfridge/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/vending_products))

/obj/structure/machinery/smartfridge/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	src.add_fingerprint(user)

	switch(action)
		if("vend")
			if(!ispowered)
				to_chat(user, SPAN_WARNING("[src] has no power."))
				return FALSE
			if (!in_range(src, usr))
				return FALSE
			if(is_secure_fridge)
				if(locked == FRIDGE_LOCK_COMPLETE)
					to_chat(usr, SPAN_DANGER("Access denied."))
					return FALSE
				if(!allowed(usr) && locked == FRIDGE_LOCK_ID)
					to_chat(usr, SPAN_DANGER("Access denied."))
					return FALSE
			var/index=params["index"]
			var/amount=params["amount"]

			var/K = quantity_holder[index]
			var/count = length(quantity_holder[K])

			if(count > 0)
				quantity_holder[K] = max(count - amount, 0)
				var/i = amount
				if(!transfer_mode)
					for(var/obj/O in source)
						if(O.name == K)
							source.Remove(O)
							O.forceMove(loc)
							i--
							if (i <= 0)
								return TRUE

/obj/structure/machinery/smartfridge/Topic(href, href_list)
	if (..()) return 0

	var/mob/user = usr
	var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, "main")

	src.add_fingerprint(user)

	if (href_list["close"])
		user.unset_interaction()
		ui.close()
		return FALSE

	if (href_list["toggletransfer"])
		if(is_secure_fridge)
			if(locked == FRIDGE_LOCK_COMPLETE)
				to_chat(usr, SPAN_DANGER("Access denied."))
				return FALSE
			if(!allowed(usr) && locked == FRIDGE_LOCK_ID)
				to_chat(usr, SPAN_DANGER("Access denied."))
				return FALSE
		if(is_in_network() && !transfer_mode)
			transfer_mode = TRUE
		else
			transfer_mode = FALSE
		return TRUE

	if (href_list["vend"])
		if(!ispowered)
			to_chat(usr, SPAN_WARNING("[src] has no power."))
			return FALSE
		if (!in_range(src, usr))
			return FALSE
		if(is_secure_fridge)
			if(locked == FRIDGE_LOCK_COMPLETE)
				to_chat(usr, SPAN_DANGER("Access denied."))
				return FALSE
			if(!allowed(usr) && locked == FRIDGE_LOCK_ID)
				to_chat(usr, SPAN_DANGER("Access denied."))
				return FALSE
		var/index = text2num(href_list["vend"])
		var/amount = text2num(href_list["amount"])
		var/from_network = text2num(href_list["network"])


		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		var/list/source = contents
		var/list/quantity_holder = item_quants
		// Validate we can reach the shared network.
		transfer_mode = transfer_mode && is_in_network()

		if(is_in_network() && from_network)
			source = chemical_data.shared_item_storage
			quantity_holder = chemical_data.shared_item_quantity

		var/K = quantity_holder[index]
		var/count = quantity_holder[K]

		if(count > 0)
			quantity_holder[K] = max(count - amount, 0)
			var/i = amount
			if(!transfer_mode)
				for(var/obj/O in source)
					if(O.name == K)
						source.Remove(O)
						O.forceMove(loc)
						i--
						if (i <= 0)
							return TRUE
			else
				for(var/obj/O in source)
					if(O.name == K)
						if(from_network)
							contents.Add(O)
							item_quants[K]++
							source.Remove(O)
						else
							chemical_data.shared_item_storage.Add(O)
							chemical_data.shared_item_quantity[K]++
							source.Remove(O)
						i--
						if(i <= 0)
							return TRUE

		return TRUE

	if (panel_open)
		if (href_list["cutwire"])
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(user, "You need wirecutters!")
				return TRUE

			var/wire = text2num(href_list["cutwire"])
			if (isWireCut(wire))
				mend(wire)
			else
				cut(wire)
			return TRUE

		if (href_list["pulsewire"])
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
				to_chat(usr, "You need a multitool!")
				return TRUE

			var/wire = text2num(href_list["pulsewire"])
			if (isWireCut(wire))
				to_chat(usr, "You can't pulse a cut wire.")
				return TRUE

			pulse(wire)
			return TRUE

	return FALSE

//*************
//*	Hacking
//**************/

/obj/structure/machinery/smartfridge/proc/get_wire_descriptions()
	return list(
		FRIDGE_WIRE_SHOCK      = "Ground safety",
		FRIDGE_WIRE_SHOOT_INV  = "Dispenser motor control",
		FRIDGE_WIRE_IDSCAN     = "ID scanner"
	)

/obj/structure/machinery/smartfridge/proc/cut(var/wire)
	wires ^= getWireFlag(wire)

	switch(wire)
		if(FRIDGE_WIRE_SHOCK)
			seconds_electrified = -1
			visible_message(SPAN_DANGER("Electric arcs shoot off from \the [src]!"))
		if (FRIDGE_WIRE_SHOOT_INV)
			if(!shoot_inventory)
				shoot_inventory = TRUE
				visible_message(SPAN_WARNING("\The [src] begins whirring noisily."))
		if(FRIDGE_WIRE_IDSCAN)
			locked = FRIDGE_LOCK_COMPLETE //totally lock it down
			visible_message(SPAN_NOTICE("\The [src] emits a slight thunk."))

/obj/structure/machinery/smartfridge/proc/mend(var/wire)
	wires |= getWireFlag(wire)
	switch(wire)
		if(FRIDGE_WIRE_SHOCK)
			seconds_electrified = 0
		if (FRIDGE_WIRE_SHOOT_INV)
			shoot_inventory = FALSE
			visible_message(SPAN_NOTICE("\The [src] stops whirring."))
		if(FRIDGE_WIRE_IDSCAN)
			locked = FRIDGE_LOCK_ID //back to normal
			visible_message(SPAN_NOTICE("\The [src] emits a click."))

/obj/structure/machinery/smartfridge/proc/pulse(var/wire)
	switch(wire)
		if(FRIDGE_WIRE_SHOCK)
			seconds_electrified = 30
			visible_message(SPAN_DANGER("Electric arcs shoot off from \the [src]!"))
		if(FRIDGE_WIRE_SHOOT_INV)
			shoot_inventory = !shoot_inventory
			if(shoot_inventory)
				visible_message(SPAN_WARNING("\The [src] begins whirring noisily."))
			else
				visible_message(SPAN_NOTICE("\The [src] stops whirring."))
		if(FRIDGE_WIRE_IDSCAN)
			locked = FRIDGE_LOCK_NOLOCK //open sesame
			visible_message(SPAN_NOTICE("\The [src] emits a click."))

/obj/structure/machinery/smartfridge/proc/isWireCut(var/wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for (var/O in item_quants)
		var/list/item_list = item_quants[O]
		if(length(item_list) <= 0) //Try to use a record that actually has something to dump.
			continue
		var/obj/target_item = item_quants[1]
		item_list.Remove(target_item)
		for(var/obj/T in contents)
			if(T.name == O)
				T.forceMove(src.loc)
				throw_item = T
				break
		break
	if(!throw_item)
		return 0
	INVOKE_ASYNC(throw_item, /atom/movable/proc/throw_atom, target, 16, SPEED_AVERAGE, src)
	src.visible_message(SPAN_DANGER("<b>[src] launches [throw_item.name] at [target.name]!</b>"))
	return 1

/obj/structure/machinery/smartfridge/proc/is_in_network()
	return networked && is_mainship_level(z)



//********************
//*	Smartfridge types
//*********************/

/obj/structure/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "seeds"
	icon_on = "seeds"
	icon_off = "seeds-off"

/obj/structure/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

//the secure subtype does nothing, I'm only keeping it to avoid conflicts with maps.
/obj/structure/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Medicine Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	icon_state = "smartfridge" //To fix the icon in the map editor.
	icon_on = "smartfridge_chem"
	is_secure_fridge = TRUE
	req_one_access = list(ACCESS_MARINE_CMO, 33)

/obj/structure/machinery/smartfridge/secure/medbay/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_container/glass/))
		return 1
	if(istype(O,/obj/item/storage/pill_bottle/))
		return 1
	if(istype(O,/obj/item/reagent_container/pill/))
		return 1
	return 0


/obj/structure/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	is_secure_fridge = TRUE
	req_access = list(39)
	icon_state = "smartfridge_virology"
	icon_on = "smartfridge_virology"
	icon_off = "smartfridge_virology-off"

/obj/structure/machinery/smartfridge/secure/virology/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_container/glass/beaker/vial/))
		return 1
	return 0


/obj/structure/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."
	is_secure_fridge = TRUE
	req_one_access = list(ACCESS_MARINE_CMO, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MEDPREP)
	networked = TRUE

/obj/structure/machinery/smartfridge/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/storage/pill_bottle) || istype(O,/obj/item/reagent_container) || istype(O,/obj/item/storage/fancy/vials))
		return 1
	return 0

/obj/structure/machinery/smartfridge/chemistry/antag
	req_one_access = list(ACCESS_ILLEGAL_PIRATE)

/obj/structure/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."


/obj/structure/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."

/obj/structure/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_container/glass) || istype(O,/obj/item/reagent_container/food/drinks) || istype(O,/obj/item/reagent_container/food/condiment))
		return 1
