
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
	var/valid_parts = null
	var/valid_ammo = null

/obj/structure/machinery/part_fabricator/New()
	..()
	start_processing()

/obj/structure/machinery/part_fabricator/proc/get_point_store()
	return 0

/obj/structure/machinery/part_fabricator/proc/add_to_point_store(number = 1)
	return

/obj/structure/machinery/part_fabricator/proc/spend_point_store(number = 1)
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
	addtimer(CALLBACK(src, PROC_REF(do_build_part), part_type), 10 SECONDS)

/obj/structure/machinery/part_fabricator/proc/do_build_part(part_type)
	busy = FALSE
	playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
	new part_type(get_step(src, SOUTHEAST))
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
	desc = "A large automated 3D printer for producing dropship parts. You can recycle parts or ammo in it, and get 80% of your points back, by clicking it while holding them in a powerloader claw."
	req_access = list(ACCESS_MARINE_DROPSHIP)
	valid_parts = /obj/structure/dropship_equipment
	valid_ammo = /obj/structure/ship_ammo

/obj/structure/machinery/part_fabricator/dropship/get_point_store()
	return supply_controller.dropship_points

/obj/structure/machinery/part_fabricator/dropship/add_to_point_store(number = 1)
	supply_controller.dropship_points += number

/obj/structure/machinery/part_fabricator/dropship/spend_point_store(number = 1)
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

/obj/structure/machinery/part_fabricator/dropship/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		recycle_equipment(PC, user)
		return
	return ..()

/obj/structure/machinery/part_fabricator/dropship/proc/recycle_equipment(obj/item/powerloader_clamp/PC, mob/living/user)
	if(!PC.loaded)
		to_chat(user, SPAN_WARNING("There is nothing loaded in \the [PC]."))
		return

	var/recycle_points
	if(istype(PC.loaded, /obj/structure/dropship_equipment))
		var/obj/structure/dropship_equipment/SE = PC.loaded
		recycle_points = SE.point_cost
	else if(istype(PC.loaded, /obj/structure/ship_ammo))
		var/obj/structure/ship_ammo/SE = PC.loaded
		if(!SE.ammo_count)
			to_chat(user, SPAN_WARNING("\The [SE] is empty!"))
			return
		if(SE.ammo_count != SE.max_ammo_count)
			recycle_points = (SE.point_cost * (SE.ammo_count / SE.max_ammo_count))
			to_chat(user, SPAN_WARNING("\The [SE] is not fully loaded, and less points will be able to be refunded."))
		else
			recycle_points = SE.point_cost

	if(!recycle_points)
		to_chat(user, SPAN_WARNING("\The [PC.loaded] can't be recycled!"))
		return

	var/thing_to_recycle = PC.loaded
	to_chat(user, SPAN_WARNING("You start recycling \the [PC.loaded]!"))
	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	if(!user || !do_after(user, (7 SECONDS) * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, PC.loaded, INTERRUPT_ALL))
		to_chat(user, SPAN_NOTICE("You stop recycling \the [thing_to_recycle]."))
		return
	for(var/obj/thing as anything in PC.loaded)
		thing.forceMove(loc) // no sentries popping out when we qdel please
		qdel(thing)
	qdel(PC.loaded)
	PC.loaded = null
	to_chat(user, SPAN_NOTICE("You recycle \the [thing_to_recycle] into [src], and get back [round(recycle_points * 0.8)] points."))
	msg_admin_niche("[key_name(user)] recycled a [thing_to_recycle] into \the [src] for [round(recycle_points * 0.8)] points.")
	add_to_point_store(round(recycle_points * 0.8))
	playsound(loc, 'sound/machines/fax.ogg', 40, 1)
	PC.update_icon()


// WARNING: IF YOU DECIDE TO READD THIS, GIVE THE HARDPOINTS POINT COSTS
/// Fabricator for individual tank parts
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

/obj/structure/machinery/part_fabricator/tank/add_to_point_store(number = 1)
	supply_controller.tank_points += number

/obj/structure/machinery/part_fabricator/tank/spend_point_store(number = 1)
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
