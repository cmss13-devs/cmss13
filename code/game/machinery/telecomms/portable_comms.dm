/obj/structure/machinery/constructable_frame/porta_comms
	name = "portable telecommunications unit"
	desc = "A portable compact TC-4T telecommunications construction kit. Used to set up subspace communications lines between planetary and extra-planetary locations. Needs cabling."
	icon = 'icons/obj/structures/machinery/comm_tower2.dmi'
	icon_state = "construct_0_0"
	required_skill = SKILL_ENGINEER_TRAINED
	required_dismantle_skill = 5
	density = TRUE
	anchored = FALSE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/constructable_frame/porta_comms/update_icon()
	..()
	var/is_wired = 0
	for(var/obj/item/I in contents)
		if(iswire(I))
			is_wired = 1
			break
	if(components)
		switch(length(components))
			if(0 to 8)
				icon_state = "construct_[length(contents)]_[is_wired]"
			else
				icon_state = "construct_8_1"
	else if(state)
		icon_state = "construct_1_0"
	else
		icon_state = "construct_0_0"

/obj/structure/machinery/constructable_frame/porta_comms/ex_act(severity)
	return

/obj/structure/machinery/constructable_frame/porta_comms/attackby(obj/item/I, mob/user)
	var/area/A = get_area(src)
	if (!A.can_build_special)
		to_chat(usr, SPAN_DANGER("You don't want to deploy this here!"))
		return
	if(istype(I, /obj/item/circuitboard/machine) && !istype(I, /obj/item/circuitboard/machine/telecomms/relay/tower))
		return
	. = ..()


// charge drained
#define PORTABLE_TCOMMS_DRAIN_PER_SECOND (2000 / 300)
#define PORTABLE_TCOMMS_MAX_CELLS 2

/obj/structure/machinery/telecomms/relay/preset/tower/portable
	desc = "A portable compact TC-4T telecommunications tower. Used to set up subspace communications lines between planetary and extra-planetary locations. Runs off two power cells behind a screwed-down panel."
	var/panel_open = FALSE
	var/last_drain_time = 0

/obj/structure/machinery/telecomms/relay/preset/tower/portable/Initialize(mapload, ...)
	LAZYADD(component_parts, new /obj/item/cell(src))
	LAZYADD(component_parts, new /obj/item/cell(src))
	return ..()

/obj/structure/machinery/telecomms/relay/preset/tower/portable/proc/get_cells()
	var/list/cells = list()
	for(var/obj/item/cell/cell in component_parts)
		cells += cell
	return cells

/obj/structure/machinery/telecomms/relay/preset/tower/portable/proc/get_total_charge()
	var/total = 0
	for(var/obj/item/cell/cell as anything in get_cells())
		total += cell.charge
	return total

/obj/structure/machinery/telecomms/relay/preset/tower/portable/proc/get_total_maxcharge()
	var/total = 0
	for(var/obj/item/cell/cell as anything in get_cells())
		total += cell.maxcharge
	return total

/obj/structure/machinery/telecomms/relay/preset/tower/portable/proc/drain_cells(amount)
	for(var/obj/item/cell/cell as anything in get_cells())
		if(amount <= 0)
			break
		var/taken = min(cell.charge, amount)
		cell.use(taken)
		amount -= taken
	return get_total_charge() > 0

/obj/structure/machinery/telecomms/relay/preset/tower/portable/inoperable(additional_flags)
	if(panel_open || get_total_charge() <= 0)
		return TRUE
	return ..()

/obj/structure/machinery/telecomms/relay/preset/tower/portable/tcomms_startup()
	. = ..()
	last_drain_time = world.time
	start_processing()

/obj/structure/machinery/telecomms/relay/preset/tower/portable/tcomms_shutdown()
	. = ..()
	stop_processing()

/obj/structure/machinery/telecomms/relay/preset/tower/portable/process()
	if(!on)
		stop_processing()
		return
	var/elapsed = world.time - last_drain_time
	last_drain_time = world.time
	if(drain_cells(elapsed / (1 SECONDS) * PORTABLE_TCOMMS_DRAIN_PER_SECOND))
		return
	toggled = FALSE
	visible_message(SPAN_WARNING("[src] whines as its power cells run dry and it shuts down."))
	update_state()

/obj/structure/machinery/telecomms/relay/preset/tower/portable/toggle_state(mob/user)
	if(!toggled)
		if(panel_open)
			to_chat(user, SPAN_WARNING("[src]'s cell panel needs to be screwed shut first!"))
			return
		if(get_total_charge() <= 0)
			to_chat(user, SPAN_WARNING("[src] has no charge left. Replace its power cells"))
			return
	return ..()

/obj/structure/machinery/telecomms/relay/preset/tower/portable/get_examine_text(mob/user)
	. = ..()
	var/list/cells = get_cells()
	var/maxcharge = get_total_maxcharge()
	if(!length(cells) || !maxcharge)
		. += SPAN_WARNING("It has no power cells")
	else
		. += SPAN_NOTICE("It has [length(cells)] power cell\s installed at [floor(get_total_charge() / maxcharge * 100)]% charge")
	if(panel_open)
		. += SPAN_WARNING("Its cell panel is unscrewed")

/obj/structure/machinery/telecomms/relay/preset/tower/portable/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		toggle_panel(I, user)
		return
	if(HAS_TRAIT(I, TRAIT_TOOL_CROWBAR))
		remove_cells(user)
		return
	if(istype(I, /obj/item/cell))
		insert_cell(I, user)
		return
	return ..()

/obj/structure/machinery/telecomms/relay/preset/tower/portable/proc/can_service(mob/user)
	if(user.action_busy)
		return FALSE
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
		to_chat(user, SPAN_WARNING("You dont have the skills for [src]..."))
		return FALSE
	return TRUE

/obj/structure/machinery/telecomms/relay/preset/tower/portable/proc/toggle_panel(obj/item/I, mob/user)
	if(!can_service(user))
		return
	user.visible_message(SPAN_NOTICE("[user] strts [panel_open ? "screwing shut" : "unscrwing"] the cell panel on [src]."),
	SPAN_NOTICE("You start [panel_open ? "screwing shut" : "unscrewing"] the cell panel on [src]."))
	playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
	if(!do_after(user, 2 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
		return
	panel_open = !panel_open
	if(panel_open)
		toggled = FALSE
	user.visible_message(SPAN_NOTICE("[user] [panel_open ? "unscrews" : "screws shut"] the cell panel on [src]."),
	SPAN_NOTICE("You [panel_open ? "unscrew" : "screw shut"] the cell panel on [src]."))
	update_state()

/obj/structure/machinery/telecomms/relay/preset/tower/portable/proc/remove_cells(mob/user)
	if(!panel_open)
		to_chat(user, SPAN_WARNING("You need to unscrew the cell panel first!"))
		return
	var/list/cells = get_cells()
	if(!length(cells))
		to_chat(user, SPAN_WARNING("[src] has no power cells to remove."))
		return
	if(!can_service(user))
		return
	user.visible_message(SPAN_NOTICE("[user] starts prying the power cells out of [src]."),
	SPAN_NOTICE("You start prying the power cells out of [src]."))
	playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
	if(!do_after(user, 2 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
		return
	for(var/obj/item/cell/cell as anything in get_cells())
		LAZYREMOVE(component_parts, cell)
		cell.forceMove(loc)
	user.visible_message(SPAN_NOTICE("[user] pries the power cells out of [src]."),
	SPAN_NOTICE("You pry the power cells out [src]."))

/obj/structure/machinery/telecomms/relay/preset/tower/portable/proc/insert_cell(obj/item/cell/cell, mob/user)
	if(!panel_open)
		to_chat(user, SPAN_WARNING("You need to unscrew the cell panel first!"))
		return
	if(length(get_cells()) >= PORTABLE_TCOMMS_MAX_CELLS)
		to_chat(user, SPAN_WARNING("[src] can't fit any more power cells."))
		return
	if(!can_service(user))
		return
	if(!user.drop_inv_item_to_loc(cell, src))
		return
	LAZYADD(component_parts, cell)
	playsound(loc, 'sound/machines/click.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] slots [cell] into [src]."),
	SPAN_NOTICE("You slot [cell] into [src]."))

#undef PORTABLE_TCOMMS_DRAIN_PER_SECOND
#undef PORTABLE_TCOMMS_MAX_CELLS
