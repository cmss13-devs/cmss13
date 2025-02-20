//Config stuff
#define SUPPLY_STATION_AREATYPE /area/supply/station //Type of the supply shuttle area for station
#define SUPPLY_STATION_AREATYPE_VEHICLE /area/supply/station/vehicle
#define SUPPLY_DOCK_AREATYPE /area/supply/dock //Type of the supply shuttle area for dock
#define SUPPLY_DOCK_AREATYPE_VEHICLE /area/supply/dock/vehicle
#define SUPPLY_COST_MULTIPLIER 1.08
#define ASRS_COST_MULTIPLIER 1.2

#define KILL_MENDOZA -1

GLOBAL_LIST_EMPTY_TYPED(asrs_empty_space_tiles_list, /turf/open/floor/almayer/empty)
GLOBAL_SUBTYPE_PATHS_LIST_INDEXED(supply_packs_types, /datum/supply_packs, name)
GLOBAL_REFERENCE_LIST_INDEXED_SORTED(supply_packs_datums, /datum/supply_packs, type)

GLOBAL_DATUM_INIT(supply_controller, /datum/controller/supply, new())

/area/supply
	ceiling = CEILING_METAL

/area/supply/station //only to be common ancestor use faction areas
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0
	ambience_exterior = AMBIENCE_ALMAYER
/area/supply/station/uscm
	name = "Supply Shuttle USCM"

/area/supply/station/upp
	name = "Supply Shuttle UPP"

/area/supply/dock
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0
/area/supply/dock/uscm
	name = "USCM Supply Shuttle"

/area/supply/dock/upp
	name = "Supply Shuttle UPP"

/area/supply/station_vehicle
	name = "Vehicle ASRS"
	icon_state = "shuttle3"
	requires_power = 0

/area/supply/dock_vehicle
	name = "Vehicle ASRS"
	icon_state = "shuttle3"
	requires_power = 0

//SUPPLY PACKS MOVED TO /code/defines/obj/supplypacks.dm

/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/structures/props/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = MOB_LAYER
	var/collide_message_busy // Timer to stop collision spam

/obj/structure/plasticflaps/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_UNDER|PASS_THROUGH

/obj/structure/plasticflaps/BlockedPassDirs(atom/movable/mover, target_dir)
	if((mover.pass_flags.flags_pass & pass_flags.flags_can_pass_all) || !iscarbon(mover))
		return NO_BLOCKED_MOVEMENT

	return BLOCKED_MOVEMENT

/obj/structure/plasticflaps/Collided(atom/movable/AM)
	var/mob/living/carbon/C = AM
	if (!istype(C))
		return
	if (ishuman_strict(C))
		return
	if(collide_message_busy > world.time)
		return

	collide_message_busy = world.time + 3 SECONDS
	C.visible_message(SPAN_NOTICE("[C] tries to go through \the [src]."),
	SPAN_NOTICE("You try to go through \the [src]."))

	if(do_after(C, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		C.forceMove(get_turf(src))

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(5))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "\improper Airtight plastic flaps"
	desc = "Heavy-duty, airtight, plastic flaps."

/obj/structure/machinery/computer/supply
	name = "Supply ordering console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "request"
	density = TRUE
	circuit = /obj/item/circuitboard/computer/ordercomp
	var/datum/controller/supply/linked_supply_controller
	var/faction = FACTION_MARINE
	var/asrs_name = "Automated Storage and Retrieval System"

	/// What message should be displayed to the user when the UI is accessed
	var/system_message = null

	/// If we should prevent the current_order() contents going over the number of points
	var/calculate_max_order = FALSE

	/// What the user currently has in their cart
	var/current_order = list()

/obj/structure/machinery/computer/supply/Initialize()
	. = ..()
	switch(faction)
		if(FACTION_MARINE)
			linked_supply_controller = GLOB.supply_controller
		if(FACTION_UPP)
			linked_supply_controller = GLOB.supply_controller_upp
		else
			linked_supply_controller = GLOB.supply_controller //we default to normal budget on wrong input
	LAZYADD(linked_supply_controller.bound_supply_computer_list, src)

/obj/structure/machinery/computer/supply/attack_hand(mob/user)
	if(..())
		return

	tgui_interact(user)

/obj/structure/machinery/computer/supply/attack_remote(mob/user)
	return attack_hand(user)

/obj/structure/machinery/computer/supply/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SupplyComputer")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/structure/machinery/computer/supply/ui_data(mob/user)
	. = ..()

	.["system_message"] = system_message

	.["points"] = linked_supply_controller.points

	.["current_order"] = list()
	for(var/pack_type in current_order)
		var/datum/supply_packs/pack = GLOB.supply_packs_datums[pack_type]

		var/list_pack = pack.get_list_representation()
		list_pack["quantity"] = current_order[pack_type]

		.["current_order"] += list(list_pack)

	var/datum/shuttle/ferry/supply/shuttle = linked_supply_controller.shuttle
	.["shuttle_status"] = "lowered"
	if (shuttle.has_arrive_time())
		.["shuttle_status"] = "moving"
		return

	if (shuttle.at_station() )
		.["shuttle_status"] = "raised"

		switch(shuttle.docking_controller?.get_docking_status())
			if ("docked")
				.["shuttle_status"] = "raised"
			if ("undocked")
				.["shuttle_status"] = "lowered"
			if ("docking")
				.["shuttle_status"] = "raising"
			if ("undocking")
				.["shuttle_status"] = "lowering"

/obj/structure/machinery/computer/supply/ui_static_data(mob/user)
	. = ..()

	.["categories"] = linked_supply_controller.all_supply_groups

	.["all_items"] = list()
	.["valid_categories"] = list()

	.["categories_to_objects"] = list()
	for(var/pack_type in GLOB.supply_packs_datums)
		var/datum/supply_packs/pack = GLOB.supply_packs_datums[pack_type]

		if(!pack.buyable)
			continue

		if(isnull(pack.contains) && isnull(pack.containertype))
			continue

		if(!(pack.group in (list() + linked_supply_controller.all_supply_groups + linked_supply_controller.contraband_supply_groups)))
			continue

		if(!pack.contraband && length(pack.group))
			.["valid_categories"] |= pack.group

		var/list_pack = pack.get_list_representation()

		if(length(pack.group))
			if(!.["categories_to_objects"][pack.group])
				.["categories_to_objects"][pack.group] = list()

			.["categories_to_objects"][pack.group] += list(
				list_pack
			)

		.["all_items"] += list(
			list_pack
		)

/obj/structure/machinery/computer/supply/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(!ishuman(ui.user))
		return
	var/mob/living/carbon/human/human_user = ui.user

	switch(action)
		if("adjust_cart")
			var/picked_pack = text2path(params["pack"])
			var/datum/supply_packs/pack = GLOB.supply_packs_datums[picked_pack]
			if(!pack || !is_buyable(pack))
				return

			var/adjust_to = params["to"]
			if(adjust_to == "min")
				current_order -= picked_pack
				return TRUE

			var/used_points = 0
			var/used_dollars = 0

			for(var/pack_type in current_order)
				var/datum/supply_packs/iter_pack = GLOB.supply_packs_datums[pack_type]
				if(isnum(adjust_to) && pack_type == picked_pack)
					continue // if manually specifying number, we calculate later how many it can be set to

				used_points += (iter_pack.cost * current_order[pack_type])
				used_dollars += (iter_pack.dollar_cost * current_order[pack_type])

			if(!isnum(adjust_to))
				return

			var/number_to_get = floor(adjust_to)
			if(!calculate_max_order)
				current_order[picked_pack] = number_to_get

				if(number_to_get <= 0)
					current_order -= picked_pack

				return TRUE

			var/cost_to_use = pack.dollar_cost ? pack.dollar_cost : pack.cost
			var/points_to_use = pack.dollar_cost ? linked_supply_controller.black_market_points : linked_supply_controller.points
			var/used_to_use = pack.dollar_cost ? used_dollars : used_points

			var/available_points = points_to_use - used_to_use

			var/number_to_hold
			if(cost_to_use * number_to_get > available_points)
				number_to_hold = floor(available_points / cost_to_use)
			else
				number_to_hold = number_to_get

			if(number_to_hold <= 0)
				current_order -= picked_pack
				return TRUE

			current_order[picked_pack] = number_to_hold
			return TRUE

		if("discard_cart")
			current_order = list()

			return TRUE

		if("request_cart")
			var/reason = params["reason"]
			if(!length(reason))
				return

			var/to_order = list()
			for(var/item in current_order)
				var/datum/supply_packs/pack = GLOB.supply_packs_datums[item]

				if(!pack || !is_buyable(pack))
					continue

				for(var/iterator in 1 to current_order[item])
					to_order += pack

			var/id_name = human_user.get_authentification_name()
			var/assignment = human_user.get_assignment()

			var/datum/supply_order/supply_order = new
			supply_order.ordernum = linked_supply_controller.ordernum++
			supply_order.objects = to_order
			supply_order.reason = reason
			supply_order.orderedby = id_name
			supply_order.orderedby_rank = assignment
			current_order = list()

			print_form(supply_order)

			linked_supply_controller.requestlist += supply_order
			system_message = "Thanks for your request. The cargo team will process it as soon as possible."
			return TRUE

		if("acknowledged")
			system_message = null
			return TRUE

		if("keyboard")
			playsound(src, "keyboard", 15, 1)

/obj/structure/machinery/computer/supply/proc/print_form(datum/supply_order/order)
	var/list/accesses = list()

	for(var/datum/supply_packs/pack as anything in order.objects)
		var/access = get_access_desc(pack.access)
		if(length(access))
			accesses += access

	var/obj/item/paper/reqform = new(loc)
	reqform.name = "Requisition Form - #[order.ordernum]"

	reqform.info += "<h3>[MAIN_SHIP_NAME] Supply Requisition Form</h3><hr>"
	reqform.info += "INDEX: #[order.ordernum]<br>"
	reqform.info += "REQUESTED BY: [order.orderedby]<br>"
	reqform.info += "RANK: [order.orderedby_rank]<br>"
	reqform.info += "REASON: [order.reason]<br>"
	reqform.info += "ACCESS RESTRICTION: [english_list(accesses, nothing_text = "None")]<br>"
	reqform.info += "CONTENTS:<br>"
	for(var/datum/supply_packs/supply_pack as anything in order.objects)
		reqform.info += supply_pack.manifest
	reqform.info += "<hr>"
	reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

	reqform.update_icon()

/obj/structure/machinery/computer/supply/proc/is_buyable(datum/supply_packs/supply_pack)
	if(!supply_pack.buyable)
		return FALSE

	if(supply_pack.contraband && !contraband_buyable())
		return FALSE

	if(isnull(supply_pack.contains) && isnull(supply_pack.containertype))
		return FALSE

	return TRUE

/obj/structure/machinery/computer/supply/proc/contraband_buyable()
	return FALSE

/obj/structure/machinery/computer/supply/asrs
	name = "ASRS console"
	desc = "A console for the Automated Storage Retrieval System"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "supply"
	density = TRUE
	req_access = list(ACCESS_MARINE_CARGO)
	circuit = /obj/item/circuitboard/computer/supplycomp
	calculate_max_order = TRUE

	var/can_order_contraband = FALSE
	var/black_market_lockout = FALSE


/obj/structure/machinery/computer/supply/Destroy()
	. = ..()
	LAZYREMOVE(linked_supply_controller.bound_supply_computer_list, src)

/obj/structure/machinery/computer/supply/asrs/attackby(obj/item/hit_item, mob/user)
	if(istype(hit_item, /obj/item/spacecash))
		if(can_order_contraband)
			var/obj/item/spacecash/slotted_cash = hit_item
			if(slotted_cash.counterfeit == TRUE)
				to_chat(user, SPAN_NOTICE("You find a small horizontal slot at the bottom of the console. You try to feed \the [slotted_cash] into it, but it rejects it! Maybe it's counterfeit?"))
				return
			to_chat(user, SPAN_NOTICE("You find a small horizontal slot at the bottom of the console. You feed \the [slotted_cash] into it.."))
			linked_supply_controller.black_market_points += slotted_cash.worth
			qdel(slotted_cash)
		else
			to_chat(user, SPAN_NOTICE("You find a small horizontal slot at the bottom of the console. You try to feed \the [hit_item] into it, but it's seemingly blocked off from the inside."))
			return
	. = ..()

/obj/structure/machinery/computer/supply/asrs/contraband_buyable()
	return can_order_contraband && !black_market_lockout

/obj/structure/machinery/computer/supply/asrs/proc/toggle_contraband(contraband_enabled = FALSE)
	can_order_contraband = contraband_enabled
	for(var/obj/structure/machinery/computer/supply/asrs/computer in linked_supply_controller.bound_supply_computer_list)
		if(computer.can_order_contraband)
			linked_supply_controller.black_market_enabled = TRUE
			return
	linked_supply_controller.black_market_enabled = FALSE

	//If any computers are able to order contraband, it's enabled. Otherwise, it's disabled!

/// Prevents use of black market, even if it is otherwise enabled. If any computer has black market locked out, it applies across all of the currently established ones.
/obj/structure/machinery/computer/supply/asrs/proc/lock_black_market(market_locked = FALSE)
	for(var/obj/structure/machinery/computer/supply/asrs/computer in linked_supply_controller.bound_supply_computer_list)
		if(market_locked)
			computer.black_market_lockout = TRUE

/obj/structure/machinery/computer/supply_drop_console
	name = "Supply Drop Console"
	desc = "An old-fashioned computer hooked into the nearby Supply Drop system."
	icon_state = "security_cam"
	circuit = /obj/item/circuitboard/computer/supply_drop_console
	req_access = list(ACCESS_MARINE_CARGO)
	var/x_supply = 0
	var/y_supply = 0
	var/z_supply = 0
	var/datum/squad/current_squad = null
	var/drop_cooldown = 1 MINUTES
	var/can_pick_squad = TRUE
	var/faction = FACTION_MARINE
	var/obj/structure/closet/crate/loaded_crate
	COOLDOWN_DECLARE(next_fire)

/obj/structure/machinery/computer/supply_drop_console/ui_status(mob/user)
	. = ..()
	if(inoperable(MAINT))
		return UI_CLOSE

/obj/structure/machinery/computer/supply_drop_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/supply_drop_console/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SupplyDropConsole", name)
		ui.open()

/obj/structure/machinery/computer/supply_drop_console/ui_static_data(mob/user)
	var/list/data = list()

	var/list/squad_list = list()
	for(var/datum/squad/current_squad in GLOB.RoleAuthority.squads)
		if(current_squad.active && current_squad.faction == faction && current_squad.equipment_color)
			squad_list += list(list(
				"squad_name" = current_squad.name,
				"squad_color" = current_squad.equipment_color
				))

	data["can_pick_squad"] = can_pick_squad
	data["squad_list"] = squad_list

	return data

/obj/structure/machinery/computer/supply_drop_console/ui_data(mob/user)
	var/list/data = list()

	check_pad()
	data["current_squad"] = current_squad
	data["launch_cooldown"] = drop_cooldown
	data["nextfiretime"] = next_fire
	data["worldtime"] = world.time
	data["x_offset"] = x_supply
	data["y_offset"] = y_supply
	data["z_offset"] = z_supply
	data["loaded"] = loaded_crate
	if(loaded_crate)
		data["crate_name"] = loaded_crate.name
	else
		data["crate_name"] = null

	return data

/obj/structure/machinery/computer/supply_drop_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_x")
			var/new_x = text2num(params["set_x"])
			if(!new_x)
				return
			x_supply = new_x
			. = TRUE

		if("set_y")
			var/new_y = text2num(params["set_y"])
			if(!new_y)
				return
			y_supply = new_y
			. = TRUE

		if("set_z")
			var/new_z = text2num(params["set_z"])
			if(!new_z)
				return
			z_supply = new_z
			. = TRUE

		if("pick_squad")
			if(can_pick_squad)
				var/datum/squad/selected = get_squad_by_name(params["squad_name"])
				if(selected)
					current_squad = selected
					attack_hand(usr)
					. = TRUE
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Invalid input. Aborting.")]")
					. = TRUE

		if("send_beacon")
			if(current_squad)
				if(!COOLDOWN_FINISHED(src, next_fire))
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Supply drop not yet available! Please wait [COOLDOWN_TIMELEFT(src, next_fire)/10] seconds!")]")
					return
				else
					handle_supplydrop()
					. = TRUE

		if("refresh_pad")
			check_pad()
			. = TRUE

/obj/structure/machinery/computer/supply_drop_console/attack_hand(mob/user)
	if(..())  //Checks for power outages
		return
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE
	tgui_interact(user)
	return

/obj/structure/machinery/computer/supply_drop_console/proc/check_pad()
	if(!current_squad.drop_pad)
		loaded_crate = null
		return FALSE
	var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc
	if(C)
		loaded_crate = C
		return C
	else
		loaded_crate = null
		return FALSE

/obj/structure/machinery/computer/supply_drop_console/proc/handle_supplydrop()
	SHOULD_NOT_SLEEP(TRUE)
	var/obj/structure/closet/crate/crate = check_pad()
	if(!crate)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("No crate was detected on the drop pad. Get Requisitions on the line!")]")
		return

	var/x_coord = deobfuscate_x(x_supply)
	var/y_coord = deobfuscate_y(y_supply)
	var/z_coord = deobfuscate_z(z_supply)

	if(!is_ground_level(z_coord))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The target zone appears to be out of bounds. Please check coordinates.")]")
		return

	var/turf/T = locate(x_coord, y_coord, z_coord)
	if(!T)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Error, invalid coordinates.")]")
		return

	var/area/A = get_area(T)
	if(A && CEILING_IS_PROTECTED(A.ceiling, CEILING_PROTECTION_TIER_2))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone is underground. The supply drop cannot reach here.")]")
		return

	if(istype(T, /turf/open/space) || T.density)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone appears to be obstructed or out of bounds. Package would be lost on drop.")]")
		return

	if(crate.opened)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The crate is not secure on the drop pad. Please close it!")]")
		return

	crate.visible_message(SPAN_WARNING("\The [crate] loads into a launch tube. Stand clear!"))
	current_squad.send_message("'[crate.name]' supply drop incoming. Heads up!")
	current_squad.send_maptext(crate.name, "Incoming Supply Drop:")
	COOLDOWN_START(src, next_fire, drop_cooldown)
	if(ismob(usr))
		var/mob/M = usr
		M.count_niche_stat(STATISTICS_NICHE_CRATES)

	playsound(crate.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehh
	var/obj/structure/droppod/supply/pod = new(null, crate)
	crate.forceMove(pod)
	pod.launch(T)
	log_ares_requisition("Supply Drop", "Launch [crate.name] to X[x_supply], Y[y_supply].", usr.real_name)
	log_game("[key_name(usr)] launched supply drop '[crate.name]' to X[x_coord], Y[y_coord].")
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("'[crate.name]' supply drop launched! Another launch will be available in five minutes.")]")

//A limited version of the above console
//Can't pick squads, drops less often
//Uses Echo squad as a placeholder to access its own drop pad
/obj/structure/machinery/computer/supply_drop_console/limited
	circuit = /obj/item/circuitboard/computer/supply_drop_console/limited
	drop_cooldown = 5 MINUTES //higher cooldown than usual
	can_pick_squad = FALSE//Can't pick squads

/obj/structure/machinery/computer/supply_drop_console/limited/New()
	..()
	current_squad = get_squad_by_name("Echo") //Hardwired into Echo

/obj/structure/machinery/computer/supply_drop_console/limited/attack_hand(mob/user)
	if(!current_squad)
		current_squad = get_squad_by_name("Echo") //Hardwired into Echo
	. = ..()

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/old_stuff/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = TRUE
	opacity = FALSE
*/

/datum/supply_order
	var/ordernum
	var/list/datum/supply_packs/objects

	var/orderedby = null

	/// The assignment of the user submitting the request
	var/orderedby_rank

	var/approvedby = null

	/// The user submitted reason as to why they want this order
	var/reason

/datum/supply_order/proc/get_list_representation()
	var/type_to_quantity = list()
	for(var/datum/supply_packs/packs as anything in objects)
		if(!type_to_quantity[packs.type])
			type_to_quantity[packs.type] = 0

		type_to_quantity[packs.type]++

	var/order_contents = list()
	for(var/pack_type in type_to_quantity)
		var/datum/supply_packs/pack = GLOB.supply_packs_datums[pack_type]
		var/to_append = pack.get_list_representation()
		to_append["quantity"] = type_to_quantity[pack_type]

		order_contents += list(to_append)

	return list(
		"order_num" = ordernum,
		"contents" = order_contents,
		"ordered_by" = orderedby,
		"approved_by" = approvedby,
		"reason" = reason,
	)

/datum/supply_order/proc/buy(obj/structure/machinery/computer/supply/asrs/buyer)
	var/ordered = list()

	for(var/datum/supply_packs/pack as anything in objects)
		if(!buyer.is_buyable(pack))
			continue

		if(buyer.linked_supply_controller.points - pack.cost < 0)
			continue

		if(buyer.linked_supply_controller.black_market_points - pack.dollar_cost < 0)
			continue

		buyer.linked_supply_controller.points -= pack.cost
		buyer.linked_supply_controller.black_market_points -= pack.dollar_cost

		if(buyer.linked_supply_controller.black_market_heat != -1) // -1 Heat means heat is disabled
			// black market heat added is crate heat +- up to 25% of crate heat
			buyer.linked_supply_controller.black_market_heat = clamp(buyer.linked_supply_controller.black_market_heat + pack.crate_heat + (pack.crate_heat * rand(rand(-0.25,0),0.25)), 0, 100)

		ordered += pack

	for(var/datum/supply_packs/pack as anything in ordered)
		pack.cost = floor(pack.cost * SUPPLY_COST_MULTIPLIER)

	if(buyer.linked_supply_controller.black_market_heat == 100)
		buyer.linked_supply_controller.black_market_investigation()

	if(length(ordered))
		if(objects ~! ordered)
			buyer.system_message = "Could not purchase all items. Available items have been purchased."

		objects = ordered
		buyer.linked_supply_controller.requestlist -= src
		buyer.linked_supply_controller.shoppinglist += src
		return TRUE

/datum/controller/supply
	var/turf/supply_elevator
	var/processing = 1
	var/processing_interval = 30 SECONDS
	var/iteration = 0
	/// Current supply points
	var/points = 0
	/// Multiplier to the amount of points awarded based on marine scale
	var/points_scale = 120
	var/points_per_process = 1.5
	var/points_per_slip = 1
	var/points_per_crate = 2

	//black market stuff
	///in Weyland-Yutani dollars - Not Stan_Albatross.
	var/black_market_points = 5 // 5 to start with to buy the scanner.
	///If the black market is enabled.
	var/black_market_enabled = FALSE
	///How close the CMB is to investigating | 100 sends an ERT
	var/black_market_heat = 0

	/// This contains a list of all typepaths of sold items and how many times they've been received. Used to calculate points dropoff (Can't send down a hundred blue souto cans for infinite points)
	var/list/black_market_sold_items

	/// If the players killed him by sending a live hostile below.. this goes false and they can't order any more contraband.
	var/mendoza_status = TRUE

	/// How many processing intervals do we get random crates for each pool. Currently only [ASRS_POOL_MAIN] gets scaled amount of crates.
	var/list/base_random_crate_intervals = list(ASRS_POOL_MAIN = 10, ASRS_POOL_FOOD = 60)
	/// How many partial crates are stored in ASRS per pool to smooth amount given out
	var/list/random_crates_carry = list()
	/// Pools mapped to list of random ASRS packs that belong to it
	var/list/asrs_supply_packs_by_pool

	var/crate_iteration = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	//shuttle movement
	var/datum/shuttle/ferry/supply/shuttle

	var/obj/item/paper/manifest/manifest_to_print = /obj/item/paper/manifest
	var/obj/structure/machinery/computer/supply/asrs/bound_supply_computer_list

	var/list/all_supply_groups = list(
		"Operations",
		"Weapons",
		"Vehicle Ammo",
		"Vehicle Equipment",
		"Attachments",
		"Ammo",
		"Weapons Specialist Ammo",
		"Restricted Equipment",
		"Clothing",
		"Medical",
		"Engineering",
		"Research",
		"Supplies",
		"Food",
		"Gear",
		"Mortar",
		"Explosives",
		"Reagent tanks",
		)

	var/list/contraband_supply_groups = list(
		"Seized Items",
		"Shipside Contraband",
		"Surplus Equipment",
		"Contraband Ammo",
		"Deep Storage",
		"Miscellaneous"
		)
	//dropship part fabricator's points, so we can reference them globally (mostly for DEFCON)
	var/dropship_points = 10000 //gains roughly 18 points per minute | Original points of 5k doubled due to removal of prespawned ammo.
	var/tank_points = 0

/datum/controller/supply/New()
	. = ..()
	ordernum = rand(1,9000)
	LAZYINITLIST(black_market_sold_items)
	asrs_supply_packs_by_pool = list()
	for(var/subtype in subtypesof(/datum/supply_packs_asrs))
		var/datum/supply_packs_asrs/initial_datum = subtype
		var/pool = initial(initial_datum.pool)
		if(!pool)
			continue
		LAZYADD(asrs_supply_packs_by_pool[pool], new subtype())
	random_crates_carry = list()
	for(var/pool in base_random_crate_intervals)
		random_crates_carry[pool] = 0

/datum/controller/supply/Destroy(force, ...)
	. = ..()
	qdel(supply_elevator)
	for(var/console in bound_supply_computer_list) //removal of this datum breakes the consoles anyway
		qdel(console)

/datum/controller/supply/proc/start_processing()
	START_PROCESSING(SSslowobj, src)

//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcomm and the station
/datum/controller/supply/process(delta_time)
	iteration++
	points += points_per_process
	if(iteration < 20)
		return
	for(var/pool in base_random_crate_intervals)
		var/interval = base_random_crate_intervals[pool]
		if(interval && iteration % interval == 0 && length(shoppinglist) <= 20)
			add_random_crates(pool)
		crate_iteration++

//This adds function adds the amount of crates that calculate_crate_amount returns
/datum/controller/supply/proc/add_random_crates(pool)
	for(var/crate_count in 1 to calculate_crate_amount(pool))
		add_random_crate(pool)

//Here we calculate the amount of crates to spawn.
//Marines get one crate for each the amount of XENOS on the surface devided by the amount of marines per crate.
//They always get the mincrates amount.
/datum/controller/supply/proc/calculate_crate_amount(pool)
	if(pool != ASRS_POOL_MAIN)
		return 1 // Pool scaling coming in a future update if needed, for now tweak base_random_crate_intervals instead

	var/ground_xenos_amount = SSticker.mode.count_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))
	var/crate_amount = max(0, sqrt(ground_xenos_amount/ASRS_XENO_CRATES_DIVIDER))

	if(crate_iteration <= 5 && crate_amount < 4)
		crate_amount = 4

	var/unit_crate_amount = floor(crate_amount)
	var/carry = crate_amount - unit_crate_amount
	random_crates_carry[pool] += carry
	var/total_carry = random_crates_carry[pool]

	if(total_carry >= 1)
		var/additional_crates = floor(total_carry)
		random_crates_carry[pool] -= additional_crates
		unit_crate_amount += additional_crates

	return unit_crate_amount

//Here we pick what crate type to send to the marines.
//This is a weighted pick based upon their cost.
//Their cost will go up if the crate is picked
/datum/controller/supply/proc/add_random_crate(pool)
	if(!asrs_supply_packs_by_pool[pool])
		return
	var/datum/supply_packs_asrs/supply_info = pick_weighted_crate(asrs_supply_packs_by_pool[pool])
	if(!GLOB.supply_packs_datums[supply_info.reference_package])
		return

	supply_info.cost = floor(supply_info.cost * ASRS_COST_MULTIPLIER) //We still do this to raise the weight
	//We have to create a supply order to make the system spawn it. Here we transform a crate into an order.
	var/datum/supply_order/supply_order = new /datum/supply_order()
	supply_order.ordernum = ordernum++
	supply_order.objects = list(GLOB.supply_packs_datums[supply_info.reference_package])
	supply_order.orderedby = "ASRS"
	supply_order.approvedby = "ASRS"
	//We add the order to the shopping list
	shoppinglist += supply_order

//Here we weigh the crate based upon it's cost
/datum/controller/supply/proc/pick_weighted_crate(list/datum/supply_packs_asrs/cratelist)
	var/list/datum/supply_packs_asrs/weighted_crate_list = list()
	for(var/datum/supply_packs_asrs/crate in cratelist)
		var/weight = (floor(10000/crate.cost))
		weighted_crate_list[crate] = weight
	return pick_weight(weighted_crate_list)

//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living) && !black_market_enabled)
		return TRUE

	for(var/i=1, i<=length(A.contents), i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

// Called when the elevator is lowered.
/datum/controller/supply/proc/sell()
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
		return

	// Sell crates.
	for(var/obj/structure/closet/crate/C in area_shuttle)
		points += points_per_crate
		qdel(C)

	// Sell manifests.
	var/screams = FALSE
	for(var/atom/movable/movable_atom in area_shuttle)
		if(istype(movable_atom, /obj/item/paper/manifest))
			var/obj/item/paper/manifest/M = movable_atom
			if(LAZYLEN(M.stamped))
				points += points_per_slip

		//black market points
		if(black_market_enabled)
			var/points_to_add = get_black_market_value(movable_atom)
			if(points_to_add == KILL_MENDOZA)
				screams = TRUE
				kill_mendoza()
			black_market_sold_items[movable_atom.type] += 1
			black_market_points += points_to_add

		// Don't disintegrate humans! Maul their corpse instead. >:)
		if(ishuman(movable_atom))
			var/timer = 0.5 SECONDS
			screams = TRUE
			for(var/index in 1 to 10)
				timer += 0.5 SECONDS
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(maul_human), movable_atom), timer)

		// Delete everything else.
		else
			qdel(movable_atom)

	if(screams)
		for(var/atom/computer as anything in bound_supply_computer_list)
			computer.balloon_alert_to_viewers("you hear horrifying noises coming from the elevator!")

/proc/maul_human(mob/living/carbon/human/mauled_human)
	mauled_human.visible_message(SPAN_HIGHDANGER("The machinery crushes [mauled_human]"), SPAN_HIGHDANGER("The elevator machinery is CRUSHING YOU!"))

	if(mauled_human.stat != DEAD)
		mauled_human.emote("scream")

	mauled_human.throw_random_direction(2, spin = TRUE)
	mauled_human.apply_effect(5, WEAKEN)
	shake_camera(mauled_human, 20, 1)
	mauled_human.apply_armoured_damage(60, ARMOR_MELEE, BRUTE, rand_zone())

//Buyin
/datum/controller/supply/proc/buy()
	var/area/area_shuttle = shuttle?.get_location_area()
	if(!area_shuttle || !length(shoppinglist))
		return

	// Try to find an available turf to place our package
	var/list/turf/clear_turfs = list()
	for(var/turf/T in area_shuttle)
		if(T.density || LAZYLEN(T.contents))
			continue
		clear_turfs += T

	for(var/datum/supply_order/order in shoppinglist)
		for(var/datum/supply_packs/package as anything in order.objects)

			// No space! Forget buying, it's no use.
			if(!length(clear_turfs))
				shoppinglist.Cut()
				return

			if(package.contraband == TRUE && prob(5))
			// Mendoza loaded the wrong order in. What a dunce!
				var/list/contraband_list
				for(var/supply_type in GLOB.supply_packs_datums)
					var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_type]
					if(supply_pack.contraband == FALSE)
						continue
					LAZYADD(contraband_list, supply_pack)
				package = pick(contraband_list)

			// Container generation
			var/turf/target_turf = pick(clear_turfs)
			clear_turfs.Remove(target_turf)
			var/atom/container = target_turf

			if(package.containertype)
				container = new package.containertype(target_turf)
				if(package.containername)
					container.name = package.containername

			// Lock it up if it's something that can be
			if(isobj(container) && package.access)
				var/obj/lockable = container
				lockable.req_access = list(package.access)

			// Contents generation
			var/list/content_names = list()
			var/list/content_types = package.contains
			if(package.randomised_num_contained)
				content_types = list()
				for(var/i in 1 to package.randomised_num_contained)
					content_types += pick(package.contains)
			for(var/typepath in content_types)
				var/atom/item = new typepath(container)
				content_names += item.name

			// Manifest generation
			var/obj/item/paper/manifest/slip
			if(!package.contraband) // I'm sorry boss i misplaced it...
				slip = new /obj/item/paper/manifest(container)
				slip.ordername = package.name
				slip.ordernum = order.ordernum
				slip.orderedby = order.orderedby
				slip.approvedby = order.approvedby
				slip.packages = content_names
				slip.generate_contents()
				slip.update_icon()
	shoppinglist.Cut()

/obj/item/paper/manifest
	name = "Supply Manifest"
	var/ordername
	var/ordernum
	var/orderedby
	var/approvedby
	var/list/packages

/obj/item/paper/manifest/read_paper(mob/user, scramble = FALSE)
	var/paper_info = info
	if(scramble)
		paper_info = stars_decode_html(info)
	// Tossing ref in widow id as this allows us to read multiple manifests at same time
	show_browser(user, "<BODY class='paper'>[paper_info][stamps]</BODY>", null, "manifest\ref[src]", "size=550x650")
	onclose(user, "manifest\ref[src]")

/obj/item/paper/manifest/proc/generate_contents()
	// You don't tell anyone this is inspired from player-made fax layouts,
	// or else, capiche ? Yes this is long, it's 80 col standard
	info = "   \
		<style>    \
			#container { width: 500px; min-height: 500px; margin: 25px auto;  \
					font-family: monospace; padding: 0; font-size: 130% }  \
			#title { font-size: 250%; letter-spacing: 8px; \
					font-weight: bolder; margin: 20px auto }   \
			.header { font-size: 130%; text-align: center; }   \
			.important { font-variant: small-caps; font-size = 130%;   \
						font-weight: bolder; }    \
			.tablelabel { width: 150px; }  \
			.field { font-style: italic; } \
			li { list-style-type: disc; list-style-position: inside; } \
			table { table-layout: fixed }  \
		</style><div id='container'>   \
		<div class='header'>   \
			<p id='title' class='important'>A.S.R.S.</p>   \
			<p class='important'>Automatic Storage Retrieval System</p>    \
			<p class='field'>Order #[ordernum]</p> \
		</div><hr><table>  \
		<colgroup> \
			<col class='tablelabel important'> \
			<col class='field'>    \
		</colgroup>    \
		<tr><td>Shipment:</td> \
		<td>[ordername]</td></tr>  \
		<tr><td>Ordered by:</td>   \
		<td>[orderedby]</td></tr>  \
		<tr><td>Approved by:</td>  \
		<td>[approvedby]</td></tr> \
		<tr><td># packages:</td>   \
		<td class='field'>[length(packages)]</td></tr> \
		</table><hr><p class='header important'>Contents</p>   \
		<ul class='field'>"

	for(var/packagename in packages)
		info += "<li>[packagename]</li>"

	info += "  \
		</ul><br/><hr><br/><p class='important header'>    \
			Please stamp below and return to confirm receipt of shipment   \
		</p></div>"

	name = "[name] - [ordername]"

/obj/structure/machinery/computer/supply/asrs/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/supply/asrs/attack_hand(mob/user as mob)
	if(!is_mainship_level(z))
		return
	if(!allowed(user))
		to_chat(user, SPAN_DANGER("Access Denied."))
		return

	if(..())
		return

	tgui_interact(user)

/obj/structure/machinery/computer/supply/asrs/ui_data(mob/user)
	. = ..()

	.["dollars"] = linked_supply_controller.black_market_points

	.["requests"] = list()
	for(var/datum/supply_order/order as anything in linked_supply_controller.requestlist)
		.["requests"] += list(
			order.get_list_representation()
		)

	.["pending"] = list()
	for(var/datum/supply_order/order as anything in linked_supply_controller.shoppinglist)
		.["pending"] += list(
			order.get_list_representation()
		)

	var/used_points = 0
	var/used_dollars = 0
	for(var/pack_type in current_order)
		var/datum/supply_packs/pack = GLOB.supply_packs_datums[pack_type]

		used_points += (pack.cost * current_order[pack_type])
		used_dollars += (pack.dollar_cost * current_order[pack_type])

	.["used_points"] = used_points
	.["used_dollars"] = used_dollars

	var/datum/shuttle/ferry/supply/shuttle = linked_supply_controller.shuttle
	.["can_launch"] = shuttle.can_launch()
	.["can_force"] = shuttle.can_force()
	.["can_cancel"] = shuttle.can_cancel()

	.["black_market"] = can_order_contraband
	.["mendoza_status"] = linked_supply_controller.mendoza_status
	.["locked_out"] = black_market_lockout

/obj/structure/machinery/computer/supply/asrs/ui_static_data(mob/user)
	. = ..()

	.["contraband_categories"] = linked_supply_controller.contraband_supply_groups

/obj/structure/machinery/computer/supply/asrs/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(!ishuman(ui.user))
		return
	var/mob/living/carbon/human/human_user = ui.user
	var/id_name = human_user.get_authentification_name()
	var/assignment = human_user.get_assignment()

	switch(action)
		if("place_order")
			var/to_order = list()
			for(var/item in current_order)
				var/datum/supply_packs/pack = GLOB.supply_packs_datums[item]

				if(!pack || !is_buyable(pack))
					continue

				for(var/iterator in 1 to current_order[item])
					to_order += pack

			var/datum/supply_order/supply_order = new
			supply_order.ordernum = linked_supply_controller.ordernum++
			supply_order.objects = to_order
			supply_order.orderedby = id_name
			supply_order.orderedby_rank = assignment
			supply_order.approvedby = id_name

			print_form(supply_order)

			current_order = list()

			if(supply_order.buy(src))
				return TRUE

			linked_supply_controller.requestlist += supply_order
			system_message = "Unable to purchase order, order has been placed in Requests."
			return TRUE

		if("change_order")
			var/datum/supply_order/order

			var/ordernum = params["ordernum"]
			if(!isnum(ordernum))
				return

			for(var/datum/supply_order/iter_order as anything in linked_supply_controller.requestlist)
				if(ordernum != iter_order.ordernum)
					continue

				order = iter_order
				break

			if(!istype(order))
				return

			switch(params["order_status"])
				if("approve")
					order.approvedby = id_name
					if(order.buy(src))
						return TRUE

					system_message = "Unable to approve order, order remains in Requests."
					return TRUE
				if("deny")
					linked_supply_controller.requestlist -= order
					qdel(order)

					return TRUE

		if("send")
			var/datum/shuttle/ferry/supply/shuttle = linked_supply_controller.shuttle

			if(shuttle.at_station())
				if (shuttle.forbidden_atoms_check())
					system_message = "For safety reasons, the Automated Storage and Retrieval System cannot store live organisms, classified nuclear weaponry or homing beacons."
					return TRUE
				shuttle.launch(src)
				return TRUE

			shuttle.launch(src)
			return TRUE

		if("force_launch")
			linked_supply_controller.shuttle.force_launch()
			return TRUE

		if("cancel_launch")
			linked_supply_controller.shuttle.cancel_launch()
			return TRUE

/obj/structure/machinery/computer/supply/asrs/ui_assets(mob/user)
	. = ..()

	. += get_asset_datum(/datum/asset/simple/paper)

/proc/get_black_market_value(atom/movable/movable_atom)
	var/return_value
	if(istype(movable_atom, /obj/item/stack))
		var/obj/item/stack/black_stack = movable_atom
		return_value += (black_stack.black_market_value * black_stack.amount)
	else
		return_value = movable_atom.black_market_value

	// so they cant sell the same thing over and over and over
	return_value = POSITIVE(return_value - GLOB.supply_controller.black_market_sold_items[movable_atom.type] * 0.5)
	return return_value

/datum/controller/supply/proc/kill_mendoza()
	if(!mendoza_status)
		return //cant kill him twice

	mendoza_status = FALSE // he'll die soon enough, and in the meantime will be too busy to handle requests.

	//mendoza notices the bad guy

	play_sound_handler("alien_growl", 0.5 SECONDS)
	play_sound_handler("male_scream", 1 SECONDS)

	//mendoza is attacked by it
	play_sound_handler("alien_claw_flesh", 2 SECONDS)
	play_sound_handler("alien_claw_flesh", 2.5 SECONDS)
	play_sound_handler(pick("male_scream", "male_pain"), 3 SECONDS)

	//reacting...
	play_sound_handler("gun_shotgun_tactical", 4 SECONDS)
	play_sound_handler("gun_shotgun_tactical", 5 SECONDS)
	play_sound_handler("m4a3", 6 SECONDS)
	play_sound_handler("m4a3", 6.5 SECONDS)
	play_sound_handler("m4a3", 7 SECONDS)
	play_sound_handler("m4a3", 7.5 SECONDS)

	//it didnt work.
	play_sound_handler(pick("male_scream", "male_pain"), 8.5 SECONDS)
	play_sound_handler(pick("male_scream", "male_pain"), 9 SECONDS)

	// he's dead!
	play_sound_handler("alien_bite", 10 SECONDS)
	play_sound_handler('sound/handling/click_2.ogg', 11 SECONDS) // armor suit light turns off (cause he died)

	var/list/turf/open/clear_turfs = list()
	var/area/area_shuttle = shuttle?.get_location_area()
	if(!area_shuttle)
		return
	for(var/turf/elevator_turfs in area_shuttle)
		if(elevator_turfs.density || LAZYLEN(elevator_turfs.contents))
			continue
		clear_turfs |= elevator_turfs
	var/turf/chosen_turf = pick(clear_turfs)

	//his corpse
	new /obj/effect/decal/remains/human(chosen_turf)
	new /obj/effect/decal/cleanable/blood(chosen_turf)

	//some of his blood
	new /obj/effect/decal/cleanable/blood(pick(clear_turfs))
	new /obj/effect/decal/cleanable/blood(pick(clear_turfs))

	//some of the xeno's blood
	new /obj/effect/decal/cleanable/blood/xeno(pick(clear_turfs))

/datum/controller/supply/proc/get_rand_sound_tile()
	var/atom/sound_tile = pick(GLOB.asrs_empty_space_tiles_list)
	return sound_tile

/datum/controller/supply/proc/play_sound_handler(sound_to_play, timer)
	/// For code readability.
	addtimer(CALLBACK(GLOBAL_PROC, /proc/playsound, get_rand_sound_tile(), sound_to_play, 25, FALSE), timer)

/datum/controller/supply/proc/black_market_investigation()
	black_market_heat = -1
	SSticker.mode.get_specific_call(/datum/emergency_call/inspection_cmb/black_market, TRUE, TRUE) // "Inspection - Colonial Marshals Ledger Investigation Team"
	log_game("Black Market Inspection auto-triggered.")

/obj/structure/machinery/computer/supply/asrs/proc/post_signal(command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency)
		return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)

/obj/structure/machinery/computer/supply/asrs/vehicle
	name = "vehicle ASRS console"
	desc = "A console for an Automated Storage and Retrieval System. This one is tied to a deep storage unit for vehicles."
	req_access = list(ACCESS_MARINE_CREWMAN)
	circuit = /obj/item/circuitboard/computer/supplycomp/vehicle
	// Can only retrieve one vehicle per round
	var/spent = FALSE
	var/tank_unlocked = TRUE
	var/list/allowed_roles = list(JOB_TANK_CREW)

	var/list/vehicles

/datum/vehicle_order
	var/name = "vehicle order"

	var/obj/vehicle/ordered_vehicle
	var/unlocked = TRUE
	var/failure_message = "<font color=\"red\"><b>Not enough resources were allocated to repair this vehicle during this operation.</b></font><br>"

/datum/vehicle_order/proc/has_vehicle_lock()
	return FALSE

/datum/vehicle_order/proc/on_created(obj/vehicle/V)
	return

/datum/vehicle_order/tank
	name = "M34A2 Longstreet Light Tank"
	ordered_vehicle = /obj/effect/vehicle_spawner/tank/decrepit

/datum/vehicle_order/tank/has_vehicle_lock()
	return

/datum/vehicle_order/tank/broken
	name = "Smashed M34A2 Longstreet Light Tank"
	ordered_vehicle = /obj/effect/vehicle_spawner/tank/hull/broken

/datum/vehicle_order/tank/plain
	name = "M34A2 Longstreet Light Tank"
	ordered_vehicle = /obj/effect/vehicle_spawner/tank

/datum/vehicle_order/apc
	name = "M577 Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc/decrepit

/datum/vehicle_order/apc/med
	name = "M577-MED Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc_med/decrepit

/datum/vehicle_order/apc/cmd
	name = "M577-CMD Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc_cmd/decrepit

/datum/vehicle_order/apc/empty
	name = "Barebones M577 Armored Personal Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc/unarmed/broken

/datum/vehicle_order/arc
	name = "M540-B Armored Recon Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/arc

/datum/vehicle_order/arc/has_vehicle_lock()
	return

/obj/structure/machinery/computer/supply/asrs/vehicle/Initialize()
	. = ..()

	vehicles = list(
		new /datum/vehicle_order/tank/plain
	)

	if(!GLOB.VehicleElevatorConsole)
		GLOB.VehicleElevatorConsole = src

/obj/structure/machinery/computer/supply/asrs/vehicle/Destroy()
	GLOB.VehicleElevatorConsole = null
	return ..()

/obj/structure/machinery/computer/supply/asrs/vehicle/attack_hand(mob/living/carbon/human/H as mob)
	if(inoperable())
		return

	if(LAZYLEN(allowed_roles) && !allowed_roles.Find(H.job)) //replaced Z-level restriction with role restriction.
		to_chat(H, SPAN_WARNING("This console isn't for you."))
		return

	if(!allowed(H))
		to_chat(H, SPAN_DANGER("Access Denied."))
		return

	H.set_interaction(src)
	post_signal("supply_vehicle")

	var/dat = ""

	if(!SSshuttle.vehicle_elevator)
		return

	dat += "Platform position: "
	if (SSshuttle.vehicle_elevator.mode != SHUTTLE_IDLE)
		dat += "Moving"
	else
		if(is_mainship_level(SSshuttle.vehicle_elevator.z))
			dat += "Raised"
			if(!spent)
				dat += "<br>\[<a href='byond://?src=\ref[src];lower_elevator=1'>Lower</a>\]"
		else
			dat += "Lowered"
	dat += "<br><hr>"

	if(spent)
		dat += "No vehicles are available for retrieval."
	else
		dat += "Available vehicles:<br>"

		for(var/d in vehicles)
			var/datum/vehicle_order/VO = d

			if(VO.has_vehicle_lock())
				dat += VO.failure_message
			else
				dat += "<a href='byond://?src=\ref[src];get_vehicle=\ref[VO]'>[VO.name]</a><br>"

	show_browser(H, dat, asrs_name, "computer", "size=575x450")

/obj/structure/machinery/computer/supply/asrs/vehicle/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!is_mainship_level(z))
		return
	if(spent)
		return
	if(!linked_supply_controller)
		world.log << "## ERROR: Eek. The linked_supply_controller controller datum is missing somehow."
		return

	if (!SSshuttle.vehicle_elevator)
		world.log << "## ERROR: Eek. The supply/elevator datum is missing somehow."
		return

	if(isturf(loc) && ( in_range(src, usr) || isSilicon(usr) ) )
		usr.set_interaction(src)

	if(href_list["get_vehicle"])
		if(is_mainship_level(SSshuttle.vehicle_elevator.z) || SSshuttle.vehicle_elevator.mode != SHUTTLE_IDLE)
			to_chat(usr, SPAN_WARNING("The elevator needs to be in the cargo bay dock to call a vehicle up!"))
			return
		// dunno why the +1 is needed but the vehicles spawn off-center
		var/turf/middle_turf = get_turf(SSshuttle.vehicle_elevator)

		var/obj/vehicle/multitile/ordered_vehicle

		var/datum/vehicle_order/VO = locate(href_list["get_vehicle"])
		if(!(VO in vehicles))
			return

		if(VO?.has_vehicle_lock())
			return
		spent = TRUE
		ordered_vehicle = new VO.ordered_vehicle(middle_turf)
		SSshuttle.vehicle_elevator.request(SSshuttle.getDock("almayer vehicle"))

		VO.on_created(ordered_vehicle)

		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_VEHICLE_ORDERED, ordered_vehicle)

	else if(href_list["lower_elevator"])
		if(!is_mainship_level(SSshuttle.vehicle_elevator.z))
			return

		SSshuttle.vehicle_elevator.request(SSshuttle.getDock("adminlevel vehicle"))

	add_fingerprint(usr)
	updateUsrDialog()
