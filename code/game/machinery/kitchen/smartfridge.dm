#define FRIDGE_WIRE_SHOCK 1
#define FRIDGE_WIRE_SHOOT_INV 2
#define FRIDGE_WIRE_IDSCAN 3
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
	var/ispowered = 1 //starts powered
	var/isbroken = 0
	var/is_secure_fridge = 0
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/panel_open = 0 //Hacking a smartfridge
	var/wires = 7
	var/networked = FALSE
	var/transfer_mode = FALSE

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
		src.ispowered = 1
		if(!isbroken)
			icon_state = icon_on
	else
		spawn(rand(0, 15))
			src.ispowered = 0
			if(!isbroken)
				icon_state = icon_off

//*******************
//*   Item Adding
//********************/

/obj/structure/machinery/smartfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(iswrench(O))
		. = ..()
		return

	if(istype(O, /obj/item/tool/screwdriver))
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, icon_panel)
		nanomanager.update_uis(src)
		return

	if(istype(O, /obj/item/device/multitool)||istype(O, /obj/item/tool/wirecutters))
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

		nanomanager.update_uis(src)

	else if(istype(O, /obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				P.remove_from_storage(G,src)
				if(item_quants[G.name])
					item_quants[G.name]++
				else
					item_quants[G.name] = 1
				plants_loaded++
		if(plants_loaded)

			user.visible_message( \
				SPAN_NOTICE("[user] loads \the [src] with \the [P]."), \
				SPAN_NOTICE("You load \the [src] with \the [P]."))
			if(P.contents.len > 0)
				to_chat(user, SPAN_NOTICE("Some items are refused."))

		nanomanager.update_uis(src)

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

	ui_interact(user)

/obj/structure/machinery/smartfridge/proc/add_item(var/obj/item/O)
	O.forceMove(src)

	if(item_quants[O.name])
		item_quants[O.name]++
	else
		item_quants[O.name] = 1

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

/obj/structure/machinery/smartfridge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_interaction(src)

	var/data[0]
	data["contents"] = null
	data["wires"] = null
	data["panel_open"] = panel_open
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure_fridge
	data["networked"] = is_in_network()
	data["transfer_mode"] = transfer_mode

	var/list/items[0]
	for (var/i=1 to length(item_quants))
		var/K = item_quants[i]
		var/count = item_quants[K]
		if (count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(K)), "vend" = i, "quantity" = count)))

	if (length(items) > 0)
		data["contents"] = items

	if(is_in_network())
		var/list/networked_items = list()
		for (var/i=1 to length(chemical_data.shared_item_quantity))
			var/K = chemical_data.shared_item_quantity[i]
			var/count = chemical_data.shared_item_quantity[K]
			if (count > 0)
				networked_items.Add(list(list("display_name" = html_encode(capitalize(K)), "vend" = i, "quantity" = count)))

		if (length(networked_items) > 0)
			data["networked_contents"] = networked_items

	var/list/wire_descriptions = get_wire_descriptions()
	var/list/panel_wires = list()
	for(var/wire = 1 to wire_descriptions.len)
		panel_wires += list(list("desc" = wire_descriptions[wire], "cut" = isWireCut(wire)))

	if (panel_wires)
		data["wires"] = panel_wires

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "smartfridge.tmpl", src.name, 420, 500)
		ui.set_initial_data(data)
		ui.open()

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
			if(!allowed(usr) && locked != -1)
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
			if(!allowed(usr) && locked != -1)
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
							item_quants[K] += 1
							source.Remove(O)
						else
							chemical_data.shared_item_storage.Add(O)
							chemical_data.shared_item_quantity[K] += 1
							source.Remove(O)
						i--
						if(i <= 0)
							return TRUE

		return TRUE

	if (panel_open)
		if (href_list["cutwire"])
			if (!( istype(usr.get_active_hand(), /obj/item/tool/wirecutters) ))
				to_chat(user, "You need wirecutters!")
				return TRUE

			var/wire = text2num(href_list["cutwire"])
			if (isWireCut(wire))
				mend(wire)
			else
				cut(wire)
			return TRUE

		if (href_list["pulsewire"])
			if (!istype(usr.get_active_hand(), /obj/item/device/multitool))
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
				shoot_inventory = 1
				visible_message(SPAN_WARNING("\The [src] begins whirring noisily."))
		if(FRIDGE_WIRE_IDSCAN)
			locked = 1
			visible_message(SPAN_NOTICE("\The [src] emits a slight thunk."))

/obj/structure/machinery/smartfridge/proc/mend(var/wire)
	wires |= getWireFlag(wire)
	switch(wire)
		if(FRIDGE_WIRE_SHOCK)
			seconds_electrified = 0
		if (FRIDGE_WIRE_SHOOT_INV)
			shoot_inventory = 0
			visible_message(SPAN_NOTICE("\The [src] stops whirring."))
		if(FRIDGE_WIRE_IDSCAN)
			locked = 0
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
			locked = -1
			visible_message(SPAN_NOTICE("\The [src] emits a click."))

/obj/structure/machinery/smartfridge/proc/isWireCut(var/wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for (var/O in item_quants)
		if(item_quants[O] <= 0) //Try to use a record that actually has something to dump.
			continue

		item_quants[O]--
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
	req_one_access = list(ACCESS_MARINE_CMO, ACCESS_MARINE_CHEMISTRY)
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
