#define FRIDGE_WIRE_SHOCK 1
#define FRIDGE_WIRE_SHOOT_INV 2
#define FRIDGE_WIRE_IDSCAN 3

#define FRIDGE_LOCK_COMPLETE 1
#define FRIDGE_LOCK_ID 2
#define FRIDGE_LOCK_NOLOCK 3

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
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	flags_atom = NOREACT
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/icon_panel = "smartfridge-panel"
	var/list/item_quants = list() //! Assoc list of names -> list(items)
	var/ispowered = TRUE //starts powered
	var/is_secure_fridge = FALSE
	var/shoot_inventory = FALSE
	var/locked = FRIDGE_LOCK_ID
	var/panel_open = FALSE //Hacking a smartfridge
	var/wires = 7
	var/networked = FALSE
	var/transfer_mode = FALSE

	COOLDOWN_DECLARE(electrified_cooldown)

/obj/structure/machinery/smartfridge/Initialize(mapload, ...)
	. = ..()
	GLOB.vending_products[/obj/item/reagent_container/glass/bottle] = 1
	GLOB.vending_products[/obj/item/storage/pill_bottle] = 1

/obj/structure/machinery/smartfridge/Destroy(force)
	if(is_in_network()) // Delete all contents from networked storage index
		for(var/atom/movable/item as anything in contents)
			delete_contents(item)
	item_quants.Cut()
	return ..() // parent will delete contents if we're not networked

/// Deletes given object in contents of the smartfridge
/obj/structure/machinery/smartfridge/proc/delete_contents(obj/item/item)
	if(item.loc != src)
		return
	contents -= item
	if(item_quants[item.name])
		item_quants[item.name] -= item
	if(is_in_network() && GLOB.chemical_data.shared_item_storage[item.name])
		GLOB.chemical_data.shared_item_storage[item.name] -= item
	qdel(item)

/obj/structure/machinery/smartfridge/proc/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/reagent_container/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/structure/machinery/smartfridge/process()
	if(!src.ispowered)
		return
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/structure/machinery/smartfridge/power_change()
	..()
	if( !(stat & NOPOWER) )
		ispowered = TRUE
		icon_state = icon_on
	else
		spawn(rand(0, 15))
			ispowered = FALSE
			icon_state = icon_off

//*******************
//*   Item Adding
//********************/

/obj/structure/machinery/smartfridge/attackby(obj/item/O as obj, mob/user as mob)
	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		. = ..()
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, icon_panel)
		SSnano.nanomanager.update_uis(src)
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
			add_local_item(O)
			user.visible_message(SPAN_NOTICE("[user] has added \the [O] to \the [src]."),
								SPAN_NOTICE("You add \the [O] to \the [src]."))

	else if(istype(O, /obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				P.remove_from_storage(G, src)
				add_local_item(G)
				plants_loaded++
		if(plants_loaded)

			user.visible_message(
				SPAN_NOTICE("[user] loads \the [src] with \the [P]."),
				SPAN_NOTICE("You load \the [src] with \the [P]."))
			if(length(P.contents) > 0)
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
	if(!COOLDOWN_FINISHED(src, electrified_cooldown))
		if(shock(user, 100))
			return

	tgui_interact(user)

/obj/structure/machinery/smartfridge/proc/add_local_item(obj/item/O)
	add_item(item_quants, O)

/obj/structure/machinery/smartfridge/proc/add_item(list/target, obj/item/O)
	O.forceMove(src)
	if(target[O.name])
		target[O.name] += O
	else
		target[O.name] = list(O)

/obj/structure/machinery/smartfridge/proc/add_network_item(obj/item/O)
	if(is_in_network())
		add_item(GLOB.chemical_data.shared_item_storage, O)
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

/obj/structure/machinery/smartfridge/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/smartfridge/ui_static_data(mob/user)
	. = list()
	.["networked"] = is_in_network()

/obj/structure/machinery/smartfridge/ui_data(mob/user)
	. = list()
	.["secure"] = is_secure_fridge
	.["transfer_mode"] = transfer_mode
	.["locked"] = locked

	var/list/wire_descriptions = get_wire_descriptions()
	var/list/panel_wires = list()
	for(var/wire = 1 to length(wire_descriptions))
		panel_wires += list(list("desc" = wire_descriptions[wire], "cut" = isWireCut(wire)))

	.["electrical"] = list(
		"electrified" = !COOLDOWN_FINISHED(src, electrified_cooldown),
		"panel_open" = panel_open,
		"wires" = panel_wires,
		"shoot_inventory" = shoot_inventory,
		"powered" = ispowered,
	)

	var/list/local_items = list()
	for (var/i=1 to length(item_quants))
		var/item_index = item_quants[i]
		var/list/item_list = item_quants[item_index]
		var/count = length(item_list)
		if(count < 1)
			continue

		var/obj/example = item_list[1]
		var/item_name = example.name
		var/item_path = example.type
		var/item_desc = example.desc

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
		for (var/i=1 to length(GLOB.chemical_data.shared_item_storage))
			var/item_index = GLOB.chemical_data.shared_item_storage[i]
			var/list/item_list = GLOB.chemical_data.shared_item_storage[item_index]
			var/count = length(item_list)
			if(count < 1)
				continue
			var/obj/example = item_list[1]
			var/item_name = example.name
			var/item_path = example.type
			var/item_desc = example.desc

			var/imgid = replacetext(replacetext("[item_path]", "/obj/item/", ""), "/", "-")

			var/item_type = "other"
			if(ispath(item_path, /obj/item/reagent_container/glass/bottle/))
				item_type = "bottle"
			else if(ispath(item_path, /obj/item/storage/pill_bottle/))
				item_type = "pills"

			if (count > 0)
				var/list/networked_item = list(
					"display_name" = capitalize(item_name),
					"item" = item_path,
					"index" = i,
					"quantity" = count,
					"image" = imgid,
					"category" = item_type,
					"desc" = item_desc,
				)
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
			if(inoperable())
				to_chat(user, SPAN_WARNING("\The [src] has no power."))
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

			var/list/target_list = item_quants
			if(params["isLocal"] == 0)
				target_list = GLOB.chemical_data.shared_item_storage

			var/item_index = target_list[index]
			var/list/item_list = target_list[item_index]

			var/count = length(item_list)

			if(count <= 0)
				return FALSE

			var/i = amount
			for(var/obj/item in item_list)
				item_list.Remove(item)
				item.forceMove(loc)
				user.put_in_any_hand_if_possible(item, disable_warning = TRUE)
				i--
				if (i <= 0)
					return TRUE
		if("transfer")
			if(inoperable())
				to_chat(user, SPAN_WARNING("\The [src] has no power."))
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

			var/source = item_quants
			var/target = GLOB.chemical_data.shared_item_storage
			if(params["isLocal"] == 0)
				source = GLOB.chemical_data.shared_item_storage
				target = item_quants

			var/item_index = source[index]
			var/list/item_list = source[item_index]
			var/count = length(item_list)

			if(count <= 0)
				return FALSE

			var/i = amount
			for(var/obj/item in item_list)
				item_list.Remove(item)
				add_item(target, item)
				i--
				if (i <= 0)
					return TRUE
		if("cutwire")
			if(!panel_open)
				return FALSE
			if(!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(usr, SPAN_WARNING("You don't understand anything about this wiring..."))
				return FALSE
			var/obj/item/held_item = user.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(user, SPAN_WARNING("You need wirecutters!"))
				return TRUE

			var/wire = params["wire"]
			cut(wire)
			return TRUE
		if("fixwire")
			if(!panel_open)
				return FALSE
			if(!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(usr, SPAN_WARNING("You don't understand anything about this wiring..."))
				return FALSE
			var/obj/item/held_item = user.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(user, SPAN_WARNING("You need wirecutters!"))
				return TRUE
			var/wire = params["wire"]
			mend(wire)
			return TRUE
		if("pulsewire")
			if(!panel_open)
				return FALSE
			if(!skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(usr, SPAN_WARNING("You don't understand anything about this wiring..."))
				return FALSE
			var/obj/item/held_item = user.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
				to_chat(user, "You need multitool!")
				return TRUE
			var/wire = params["wire"]
			if (isWireCut(wire))
				to_chat(usr, SPAN_WARNING("You can't pulse a cut wire."))
				return TRUE
			pulse(wire)
			return TRUE
	return FALSE

//*************
//* Hacking
//**************/

/obj/structure/machinery/smartfridge/proc/get_wire_descriptions()
	return list(
		FRIDGE_WIRE_SHOCK   = "Ground safety",
		FRIDGE_WIRE_SHOOT_INV  = "Dispenser motor control",
		FRIDGE_WIRE_IDSCAN  = "ID scanner"
	)

/obj/structure/machinery/smartfridge/proc/cut(wire)
	wires ^= getWireFlag(wire)

	switch(wire)
		if(FRIDGE_WIRE_SHOCK)
			COOLDOWN_START(src, electrified_cooldown, 12 HOURS)
			visible_message(SPAN_DANGER("Electric arcs shoot off from \the [src]!"))
		if (FRIDGE_WIRE_SHOOT_INV)
			if(!shoot_inventory)
				shoot_inventory = TRUE
				visible_message(SPAN_WARNING("\The [src] begins whirring noisily."))
		if(FRIDGE_WIRE_IDSCAN)
			locked = FRIDGE_LOCK_COMPLETE //totally lock it down
			visible_message(SPAN_NOTICE("\The [src] emits a slight thunk."))

/obj/structure/machinery/smartfridge/proc/mend(wire)
	wires |= getWireFlag(wire)
	switch(wire)
		if(FRIDGE_WIRE_SHOCK)
			COOLDOWN_RESET(src, electrified_cooldown)
		if (FRIDGE_WIRE_SHOOT_INV)
			shoot_inventory = FALSE
			visible_message(SPAN_NOTICE("\The [src] stops whirring."))
		if(FRIDGE_WIRE_IDSCAN)
			locked = FRIDGE_LOCK_ID //back to normal
			visible_message(SPAN_NOTICE("\The [src] emits a click."))

/obj/structure/machinery/smartfridge/proc/pulse(wire)
	switch(wire)
		if(FRIDGE_WIRE_SHOCK)
			COOLDOWN_START(src, electrified_cooldown, 30 SECONDS)
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

/obj/structure/machinery/smartfridge/proc/isWireCut(wire)
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
		target_item.forceMove(src.loc)
		throw_item = target_item
		break
	if(!throw_item)
		return 0
	INVOKE_ASYNC(throw_item, /atom/movable/proc/throw_atom, target, 16, SPEED_AVERAGE, src)
	src.visible_message(SPAN_DANGER("<b>[src] launches [throw_item.name] at [target.name]!</b>"))
	return 1

/obj/structure/machinery/smartfridge/proc/is_in_network()
	return networked && is_mainship_level(z)



//********************
//* Smartfridge types
//*********************/

/obj/structure/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "seeds"
	icon_on = "seeds"
	icon_off = "seeds-off"

/obj/structure/machinery/smartfridge/seeds/accept_check(obj/item/O as obj)
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
	req_one_access = list(ACCESS_MARINE_CMO)

/obj/structure/machinery/smartfridge/secure/medbay/accept_check(obj/item/O as obj)
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

/obj/structure/machinery/smartfridge/secure/virology/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/reagent_container/glass/beaker/vial/))
		return 1
	return 0


/obj/structure/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."
	is_secure_fridge = TRUE
	req_one_access = list(ACCESS_MARINE_CMO, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MEDPREP)
	networked = TRUE

/obj/structure/machinery/smartfridge/chemistry/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/storage/pill_bottle) || istype(O,/obj/item/reagent_container) || istype(O,/obj/item/storage/fancy/vials))
		return 1
	return 0

/obj/structure/machinery/smartfridge/chemistry/antag
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)

/obj/structure/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."


/obj/structure/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."

/obj/structure/machinery/smartfridge/drinks/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/reagent_container/glass) || istype(O,/obj/item/reagent_container/food/drinks) || istype(O,/obj/item/reagent_container/food/condiment))
		return 1
