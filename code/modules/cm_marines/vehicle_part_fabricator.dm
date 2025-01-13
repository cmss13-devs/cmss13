
/obj/structure/machinery/part_fabricator
	name = "part fabricator"
	desc = "A large automated 3D printer for producing runtime errors."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	icon = 'icons/obj/structures/machinery/drone_fab.dmi'
	icon_state = "drone_fab_idle"
	var/busy = FALSE
	var/generate_points = TRUE
	var/omnisentry_price_scale = 100
	var/omnisentry_price = 300
	var/faction = FACTION_MARINE
	var/datum/controller/supply/linked_supply_controller
	var/list/datum/build_queue_entry/build_queue = list()

/obj/structure/machinery/part_fabricator/upp
	name = "UPP part fabricator"
	faction = FACTION_UPP


/datum/build_queue_entry
	var/item
	var/cost

/datum/build_queue_entry/New(item, cost)
	src.item = item
	src.cost = cost

/obj/structure/machinery/part_fabricator/get_examine_text(mob/user)
	. = ..()
	to_chat(user, build_queue ? "It has [length(build_queue)] items in the queue" : "the build queue is empty")

/obj/structure/machinery/part_fabricator/New()
	..()
	switch(faction)
		if(FACTION_MARINE)
			linked_supply_controller = GLOB.supply_controller
		if(FACTION_UPP)
			linked_supply_controller = GLOB.supply_controller_upp
		else
			linked_supply_controller = GLOB.supply_controller
	start_processing()

/obj/structure/machinery/part_fabricator/proc/get_point_store()
	return 0

/obj/structure/machinery/part_fabricator/proc/add_to_point_store(number = 1)
	return

/obj/structure/machinery/part_fabricator/proc/spend_point_store(number = 1)
	return

/obj/structure/machinery/part_fabricator/dropship/ui_data(mob/user)
	var/index = 1
	var/list/build_queue_formatted = list()
	for(var/datum/build_queue_entry/entry in build_queue)
		var/obj/structure/build_item = entry.item
		build_queue_formatted += list(list(
			"name" = build_item.name,
			"cost" = entry.cost,
			"index" = index
		))

		index += 1

	return list(
		"points" = get_point_store(),
		"omnisentrygun_price" = omnisentry_price,
		"BuildQueue" = build_queue_formatted
	)

/obj/structure/machinery/part_fabricator/power_change()
	..()
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/structure/machinery/part_fabricator/process()
	if(SSticker.current_state < GAME_STATE_PLAYING)
		return

	if(generate_points)
		add_to_point_store()

	process_build_queue()

	update_icon()

/obj/structure/machinery/part_fabricator/proc/process_build_queue()
	if(stat & NOPOWER)
		return

	if(busy)
		return

	if(length(build_queue))
		busy = TRUE
		var/datum/build_queue_entry/entry = build_queue[1]

		var/is_omnisentry = ispath(entry.item, /obj/structure/ship_ammo/sentry)

		if((is_omnisentry && get_point_store() < omnisentry_price) || get_point_store() < entry.cost)
			if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_PRINTER_ERROR))
				balloon_alert_to_viewers("out of points - printing paused!")
				visible_message(SPAN_WARNING("[src] flashes a warning light."))
				TIMER_COOLDOWN_START(src, COOLDOWN_PRINTER_ERROR, 20 SECONDS)
			busy = FALSE
			return

		if(is_omnisentry)
			spend_point_store(omnisentry_price)
			omnisentry_price += omnisentry_price_scale
		else
			spend_point_store(entry.cost)

		visible_message(SPAN_NOTICE("[src] starts printing something."))
		addtimer(CALLBACK(src, PROC_REF(produce_part), entry), 3 SECONDS)

/obj/structure/machinery/part_fabricator/proc/build_part(part_type, cost, mob/user)
	set waitfor = FALSE
	if(stat & NOPOWER)
		return

	if(ispath(part_type, /obj/structure/ship_ammo/sentry))
		cost = omnisentry_price

	if(get_point_store() < cost)
		to_chat(user, SPAN_WARNING("You don't have enough points to build that."))
		return

	build_queue += new /datum/build_queue_entry(part_type, cost)

/obj/structure/machinery/part_fabricator/proc/produce_part(datum/build_queue_entry/entry)
	build_queue.Remove(entry)

	busy = FALSE
	playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
	new entry.item(get_step(src, SOUTHEAST))
	icon_state = "drone_fab_idle"

/obj/structure/machinery/part_fabricator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	if(action == "produce")
		var/cost = 0
		var/is_ammo = params["is_ammo"]
		var/index = params["index"]

		if(is_ammo == 0)
			var/produce_list = list()
			var/possible_produce = typesof(/obj/structure/dropship_equipment)
			for(var/p_produce in possible_produce)
				var/obj/structure/dropship_equipment/produce = p_produce
				if(produce.faction_exclusive)
					if(produce.faction_exclusive != faction)
						continue
				produce_list += produce
			var/obj/structure/dropship_equipment/produce = produce_list[index]
			if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_combat_cas) && produce.combat_equipment)
				log_admin("Bad topic: [user] may be trying to HREF exploit [src] to bypass no combat cas")
				return
			cost = initial(produce.point_cost)
			build_part(produce, cost, user)
			return TRUE

		else
			var/produce_list = list()
			var/possible_produce = typesof(/obj/structure/ship_ammo)
			for(var/p_produce in possible_produce)
				var/obj/structure/dropship_equipment/produce = p_produce
				if(produce.faction_exclusive)
					if(produce.faction_exclusive != faction)
						continue
				produce_list += produce
			var/obj/structure/dropship_equipment/produce = produce_list[index]
			if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_combat_cas) && produce.combat_equipment)
				log_admin("Bad topic: [user] may be trying to HREF exploit [src] to bypass no combat cas")
				return
			cost = initial(produce.point_cost)
			build_part(produce, cost, user)
			return TRUE

	if(action == "cancel")
		var/index = params["index"]

		if(length(build_queue))
			if(index == null || index > length(build_queue))
				return

			if(busy && index == 1)
				to_chat(user, SPAN_WARNING("Cannot cancel currently produced item."))
				return

			var/datum/build_queue_entry/entry = build_queue[index]

			build_queue.Remove(entry)
			return TRUE

	else
		log_admin("Bad topic: [user] may be trying to HREF exploit [src]")
		return

/obj/structure/machinery/part_fabricator/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE
	tgui_interact(user)

/obj/structure/machinery/part_fabricator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PartFabricator", "Part Fabricator")
		ui.open()

/obj/structure/machinery/part_fabricator/update_icon()
	. = ..()
	if(stat & NOPOWER)
		icon_state = "drone_fab_nopower"
		return
	if(busy)
		icon_state = "drone_fab_active"
		return

	icon_state = "drone_fab_idle"

/obj/structure/machinery/part_fabricator/dropship
	name = "dropship part fabricator"
	desc = "A large automated 3D printer for producing dropship parts. You can recycle parts or ammo in it, and get 80% of your points back, by clicking it while holding them in a powerloader claw."
	req_access = list(ACCESS_MARINE_DROPSHIP)

	unslashable = TRUE
	unacidable = TRUE
	faction = FACTION_MARINE

/obj/structure/machinery/part_fabricator/dropship/upp
	name = "UPP dropship part fabricator"
	faction = FACTION_UPP
	req_access = list(ACCESS_UPP_FLIGHT)


/obj/structure/machinery/part_fabricator/dropship/get_point_store()
	return linked_supply_controller.dropship_points

/obj/structure/machinery/part_fabricator/dropship/add_to_point_store(number = 1)
	linked_supply_controller.dropship_points += number

/obj/structure/machinery/part_fabricator/dropship/spend_point_store(number = 1)
	linked_supply_controller.dropship_points -= number

/obj/structure/machinery/part_fabricator/dropship/ui_static_data(mob/user)
	var/list/static_data = list()
	static_data["Equipment"] = list()
	var/is_ammo = 0
	var/index = 1
	for(var/build_type in typesof(/obj/structure/dropship_equipment))
		var/obj/structure/dropship_equipment/dropship_equipment_data = build_type
		if(dropship_equipment_data.faction_exclusive)
			if(faction != dropship_equipment_data.faction_exclusive)
				continue

		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_combat_cas) && dropship_equipment_data.combat_equipment)
			index +=  1
			continue
		var/build_name = initial(dropship_equipment_data.name)
		var/build_description = initial(dropship_equipment_data.desc)
		var/build_cost = initial(dropship_equipment_data.point_cost)
		if(build_cost)
			static_data["Equipment"] += list(list(
				"name" = capitalize_first_letters(build_name),
				"desc" = build_description,
				"cost" = build_cost,
				"index" = index,
				"is_ammo" = is_ammo
			))
		index += 1

	static_data["Ammo"] = list()
	is_ammo = 1
	index = 1
	for(var/build_type in typesof(/obj/structure/ship_ammo))
		var/obj/structure/ship_ammo/ship_ammo_data = build_type
		if(ship_ammo_data.faction_exclusive)
			if(faction != ship_ammo_data.faction_exclusive)
				continue
		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_combat_cas) && ship_ammo_data.combat_equipment)
			index = index + 1
			continue
		var/build_name = initial(ship_ammo_data.name)
		var/build_description = initial(ship_ammo_data.desc)
		var/build_cost = initial(ship_ammo_data.point_cost)
		if(build_cost)
			static_data["Ammo"] += list(list(
				"name" = capitalize_first_letters(build_name),
				"desc" = build_description,
				"cost" = build_cost,
				"index" = index,
				"is_ammo" = is_ammo
			))
		index += 1

	return static_data

/obj/structure/machinery/part_fabricator/dropship/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/powerloader_clamp_used = I
		recycle_equipment(powerloader_clamp_used, user)
		return
	return ..()

/obj/structure/machinery/part_fabricator/dropship/proc/recycle_equipment(obj/item/powerloader_clamp/powerloader_clamp_used, mob/living/user)
	if(!powerloader_clamp_used.loaded)
		to_chat(user, SPAN_WARNING("There is nothing loaded in \the [powerloader_clamp_used]."))
		return

	var/recycle_points
	if(istype(powerloader_clamp_used.loaded, /obj/structure/dropship_equipment))
		var/obj/structure/dropship_equipment/sold_eqipment = powerloader_clamp_used.loaded
		recycle_points = sold_eqipment.point_cost
	else if(istype(powerloader_clamp_used.loaded, /obj/structure/ship_ammo))
		var/obj/structure/ship_ammo/sold_eqipment = powerloader_clamp_used.loaded
		if(!sold_eqipment.ammo_count)
			to_chat(user, SPAN_WARNING("\The [sold_eqipment] is empty!"))
			return
		if(sold_eqipment.ammo_count != sold_eqipment.max_ammo_count)
			recycle_points = (sold_eqipment.point_cost * (sold_eqipment.ammo_count / sold_eqipment.max_ammo_count))
			to_chat(user, SPAN_WARNING("\The [sold_eqipment] is not fully loaded, and less points will be able to be refunded."))
		else
			recycle_points = sold_eqipment.point_cost
			if(istype(powerloader_clamp_used.loaded, /obj/structure/ship_ammo/sentry))
				recycle_points = omnisentry_price - omnisentry_price_scale

	if(!recycle_points)
		to_chat(user, SPAN_WARNING("\The [powerloader_clamp_used.loaded] can't be recycled!"))
		return

	var/thing_to_recycle = powerloader_clamp_used.loaded
	to_chat(user, SPAN_WARNING("You start recycling \the [powerloader_clamp_used.loaded]!"))
	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	if(!user || !do_after(user, (3 SECONDS) * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, powerloader_clamp_used.loaded, INTERRUPT_ALL))
		to_chat(user, SPAN_NOTICE("You stop recycling \the [thing_to_recycle]."))
		return
	if(istype(powerloader_clamp_used.loaded, /obj/structure/ship_ammo/sentry))
		omnisentry_price -= omnisentry_price_scale
	for(var/obj/thing as anything in powerloader_clamp_used.loaded)
		thing.forceMove(loc) // no sentries popping out when we qdel please
		qdel(thing)
	qdel(powerloader_clamp_used.loaded)
	powerloader_clamp_used.loaded = null
	to_chat(user, SPAN_NOTICE("You recycle \the [thing_to_recycle] into [src], and get back [floor(recycle_points * 0.8)] points."))
	msg_admin_niche("[key_name(user)] recycled a [thing_to_recycle] into \the [src] for [floor(recycle_points * 0.8)] points.")
	add_to_point_store(floor(recycle_points * 0.8))
	playsound(loc, 'sound/machines/fax.ogg', 40, 1)
	powerloader_clamp_used.update_icon()


// WARNING: IF YOU DECIDE TO READD THIS, GIVE THE HARDPOINTS POINT COSTS
/// Fabricator for individual tank parts
/obj/structure/machinery/part_fabricator/tank
	name = "vehicle part fabricator"
	desc = "A large automated 3D printer for producing vehicle parts."
	req_access = list(ACCESS_MARINE_CREWMAN)
	generate_points = FALSE

	unacidable = TRUE
	explo_proof = TRUE
	faction = FACTION_MARINE

/obj/structure/machinery/part_fabricator/tank/upp
	name = "UPP vehicle part fabricator"
	faction = FACTION_UPP

/obj/structure/machinery/part_fabricator/tank/get_point_store()
	return linked_supply_controller.tank_points

/obj/structure/machinery/part_fabricator/tank/add_to_point_store(number = 1)
	linked_supply_controller.tank_points += number

/obj/structure/machinery/part_fabricator/tank/spend_point_store(number = 1)
	linked_supply_controller.tank_points -= number

/obj/structure/machinery/part_fabricator/tank/ui_static_data(mob/user)
	var/list/static_data = list()
	static_data["Equipment"] = list()
	for(var/build_type in typesof(/obj/item/hardpoint))
		var/obj/item/hardpoint/hardpoint_data = build_type
		var/build_name = initial(hardpoint_data.name)
		var/build_description = initial(hardpoint_data.desc)
		var/build_cost = 0
		if(build_cost)
			static_data["Equipment"] += list(list(
				"name" = capitalize_first_letters(build_name),
				"desc" = build_description,
				"path" = build_type,
				"cost" = build_cost
			))

	static_data["Ammo"] = list()
	for(var/build_type in typesof(/obj/item/ammo_magazine/hardpoint))
		var/obj/item/ammo_magazine/hardpoint/ammo_data = build_type
		var/build_name = initial(ammo_data.name)
		var/build_description = initial(ammo_data.desc)
		var/build_cost = 0
		if(build_cost)
			static_data["Ammo"] += list(list(
				"name" = capitalize_first_letters(build_name),
				"desc" = build_description,
				"path" = build_type,
				"cost" = build_cost
			))

	return static_data
