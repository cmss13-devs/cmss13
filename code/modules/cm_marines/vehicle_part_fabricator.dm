
/obj/structure/machinery/part_fabricator
	name = "part fabricator"
	desc = "A large automated 3D printer for producing runtime errors."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	icon = 'icons/obj/structures/machinery/drone_fab.dmi'
	icon_state = "drone_fab_idle"
	var/busy = FALSE
	var/generate_points = TRUE
	var/valid_parts = null
	var/valid_ammo = null

/obj/structure/machinery/part_fabricator/New()
	..()
	start_processing()

/obj/structure/machinery/part_fabricator/proc/get_point_store()
    return 0

/obj/structure/machinery/part_fabricator/proc/add_to_point_store(var/number = 1)
    return

/obj/structure/machinery/part_fabricator/proc/spend_point_store(var/number = 1)
    return

/obj/structure/machinery/part_fabricator/dropship/ui_data(mob/user)
	return list(
		"points" = get_point_store()
	)

/obj/structure/machinery/part_fabricator/power_change()
	..()
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/structure/machinery/part_fabricator/process()
	if(SSticker.current_state < GAME_STATE_PLAYING)
		return
	if(stat & NOPOWER)
		icon_state = "drone_fab_nopower"
		return
	if(busy)
		icon_state = "drone_fab_active"
		return
	else
		icon_state = "drone_fab_idle"
	if(generate_points)
		add_to_point_store()

/obj/structure/machinery/part_fabricator/proc/build_part(part_type, cost, mob/user)
	set waitfor = 0
	if(stat & NOPOWER) return
	if(get_point_store() < cost)
		to_chat(user, SPAN_WARNING("You don't have enough points to build that."))
		return
	visible_message(SPAN_NOTICE("[src] starts printing something."))
	spend_point_store(cost)
	icon_state = "drone_fab_active"
	busy = TRUE
	addtimer(CALLBACK(src, .proc/do_build_part, part_type), 10 SECONDS)

/obj/structure/machinery/part_fabricator/proc/do_build_part(part_type)
	busy = FALSE
	playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
	new part_type(get_step(src, SOUTHEAST))
	vending_stat_bump(part_type, src.type)
	icon_state = "drone_fab_idle"

/obj/structure/machinery/part_fabricator/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(busy)
		to_chat(usr, SPAN_WARNING("The [name] is busy. Please wait for completion of previous operation."))
		return

	if(action == "produce")
		var/produce = text2path(params["path"])
		var/cost = text2num(params["cost"])
		var/exploiting = TRUE

		if (valid_parts && ispath(produce, valid_parts))
			exploiting = FALSE
		else if (valid_ammo && ispath(produce, valid_ammo))
			exploiting = FALSE

		if (cost < 0)
			exploiting = TRUE

		if (exploiting)
			log_admin("Bad topic: [usr] may be trying to HREF exploit [src] with [produce], [cost]")
			return

		build_part(produce, cost, usr)
		return
	else
		log_admin("Bad topic: [usr] may be trying to HREF exploit [src]")
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

/obj/structure/machinery/part_fabricator/dropship
	name = "dropship part fabricator"
	desc = "A large automated 3D printer for producing dropship parts."
	req_access = list(ACCESS_MARINE_DROPSHIP)
	valid_parts = /obj/structure/dropship_equipment
	valid_ammo = /obj/structure/ship_ammo

/obj/structure/machinery/part_fabricator/dropship/get_point_store()
    return supply_controller.dropship_points

/obj/structure/machinery/part_fabricator/dropship/add_to_point_store(var/number = 1)
    supply_controller.dropship_points += number

/obj/structure/machinery/part_fabricator/dropship/spend_point_store(var/number = 1)
    supply_controller.dropship_points -= number

/obj/structure/machinery/part_fabricator/dropship/ui_static_data(mob/user)
	var/list/static_data = list()
	static_data["Equipment"] = list()
	for(var/build_type in typesof(/obj/structure/dropship_equipment))
		var/obj/structure/dropship_equipment/DE = build_type
		if(SSticker.mode && MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_COMBAT_CAS) && initial(DE.combat_equipment))
			continue
		var/build_name = initial(DE.name)
		var/build_description = initial(DE.desc)
		var/build_cost = initial(DE.point_cost)
		if(build_cost)
			static_data["Equipment"] += list(list(
				"name" = capitalize_first_letters(build_name),
				"desc" = build_description,
				"path" = build_type,
				"cost" = build_cost
			))

	static_data["Ammo"] = list()
	for(var/build_type in typesof(/obj/structure/ship_ammo))
		var/obj/structure/ship_ammo/SA = build_type
		if(SSticker.mode && MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_COMBAT_CAS) && initial(SA.combat_equipment))
			continue
		var/build_name = initial(SA.name)
		var/build_description = initial(SA.desc)
		var/build_cost = initial(SA.point_cost)
		if(build_cost)
			static_data["Ammo"] += list(list(
				"name" = capitalize_first_letters(build_name),
				"desc" = build_description,
				"path" = build_type,
				"cost" = build_cost
			))

	return static_data

/// WARNING: IF YOU DECIDE TO READD THIS, GIVE THE HARDPOINTS POINT COSTS
/obj/structure/machinery/part_fabricator/tank
	name = "vehicle part fabricator"
	desc = "A large automated 3D printer for producing vehicle parts."
	req_access = list(ACCESS_MARINE_CREWMAN)
	generate_points = FALSE
	valid_parts = /obj/item/hardpoint
	valid_ammo = /obj/item/ammo_magazine/hardpoint

	unacidable = TRUE
	indestructible = TRUE

/obj/structure/machinery/part_fabricator/tank/get_point_store()
    return supply_controller.tank_points

/obj/structure/machinery/part_fabricator/tank/add_to_point_store(var/number = 1)
    supply_controller.tank_points += number

/obj/structure/machinery/part_fabricator/tank/spend_point_store(var/number = 1)
    supply_controller.tank_points -= number

/obj/structure/machinery/part_fabricator/tank/ui_static_data(mob/user)
	var/list/static_data = list()
	static_data["Equipment"] = list()
	for(var/build_type in typesof(/obj/item/hardpoint))
		var/obj/item/hardpoint/TE = build_type
		var/build_name = initial(TE.name)
		var/build_description = initial(TE.desc)
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
		var/obj/item/ammo_magazine/hardpoint/TA = build_type
		var/build_name = initial(TA.name)
		var/build_description = initial(TA.desc)
		var/build_cost = 0
		if(build_cost)
			static_data["Ammo"] += list(list(
				"name" = capitalize_first_letters(build_name),
				"desc" = build_description,
				"path" = build_type,
				"cost" = build_cost
			))

	return static_data
