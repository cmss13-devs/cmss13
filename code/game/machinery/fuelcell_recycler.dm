/obj/structure/machinery/fuelcell_recycler
	name = "\improper fuel cell recycler"
	desc = "A large machine with whirring fans and two cylindrical holes in the top. Used to regenerate fuel cells."
	icon = 'icons/obj/structures/machinery/fusion_eng.dmi'
	icon_state = "recycler"
	density = TRUE
	active_power_usage = 15000
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

	///How much to recharge the cells per process
	var/recharge_amount = 5
	///A fuel cell in the recycler
	var/obj/item/fuel_cell/cell_left
	///A fuel cell in the recycler
	var/obj/item/fuel_cell/cell_right

/obj/structure/machinery/fuelcell_recycler/Destroy()
	. = ..()
	QDEL_NULL(cell_left)
	QDEL_NULL(cell_right)

/obj/structure/machinery/fuelcell_recycler/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("It is [machine_processing ? "online" : "offline"].")
	if(!ishuman(user))
		return

	if(cell_left)
		. += SPAN_INFO("The left cell is at [cell_left.get_fuel_percent()]%.")
	if(cell_right)
		. += SPAN_INFO("The right cell is at [cell_right.get_fuel_percent()]%.")

/obj/structure/machinery/fuelcell_recycler/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/fuel_cell))
		to_chat(user, SPAN_NOTICE("[src] rejects [attacking_item]. It can only regenerate fuel cells."))
		return
	var/obj/item/fuel_cell/cell = attacking_item

	if(cell_left && cell_right)
		to_chat(user, SPAN_NOTICE("[src] cannot regenerate any more fuel cells. Remove [cell_left] or [cell_right] first."))
		return

	if(cell.get_fuel_percent() == 100)
		to_chat(user, SPAN_NOTICE("[cell] is already full and does not need to be regenerated."))
		return

	if(!user.drop_inv_item_to_loc(cell, src))
		to_chat(user, SPAN_WARNING("You fail to insert [cell] into [src]."))
		return

	add_fingerprint(user)
	var/inserted_to_left = TRUE
	if(!cell_left)
		cell_left = cell
	else if(!cell_right)
		inserted_to_left = FALSE
		cell_right = cell

	to_chat(user, SPAN_NOTICE("You insert [cell] into the [inserted_to_left ? "left" : "right"] fuel cell receptacle."))
	update_icon()
	if(!machine_processing)
		visible_message(SPAN_NOTICE("[src] starts whirring as it turns on."))
		update_use_power(USE_POWER_ACTIVE)
		start_processing()

/obj/structure/machinery/fuelcell_recycler/attack_hand(mob/user)
	if(!cell_left && !cell_right)
		to_chat(user, SPAN_NOTICE("[src] is empty."))
		return

	add_fingerprint(user)
	cell_left?.update_icon()
	cell_right?.update_icon()

	if(cell_left && cell_right)
		if(cell_left.get_fuel_percent() >= cell_right.get_fuel_percent())
			user.put_in_hands(cell_left)
			cell_left = null
		else
			user.put_in_hands(cell_right)
			cell_right = null
		update_icon()
		return

	if(cell_left)
		user.put_in_hands(cell_left)
		cell_left = null
		update_icon()
		return

	if(cell_right)
		user.put_in_hands(cell_right)
		cell_right = null
		update_icon()

/obj/structure/machinery/fuelcell_recycler/process()
	if(inoperable())
		turn_off()
		return

	if(!cell_left && !cell_right)
		balloon_alert_to_viewers("no cells detected.")
		turn_off()
		return

	if((!cell_right && cell_left?.is_regenerated()) || (!cell_left && cell_right?.is_regenerated()) || (cell_left?.is_regenerated() && cell_right?.is_regenerated()))
		balloon_alert_to_viewers("all cells charged.")
		turn_off()
		return

	if(cell_left && !cell_left.is_regenerated())
		recharge_cell(cell_left)

	if(cell_right && !cell_right.is_regenerated())
		recharge_cell(cell_right)

	update_icon()

/obj/structure/machinery/fuelcell_recycler/power_change()
	..()
	update_icon()

/obj/structure/machinery/fuelcell_recycler/update_icon()
	overlays.Cut()

	if(cell_left)
		overlays += "overlay_left_cell"
	if(cell_right)
		overlays += "overlay_right_cell"

	if(inoperable())
		icon_state = "recycler"
		return

	if(cell_left)
		if(cell_left.is_regenerated())
			overlays += "overlay_left_charged"
		else
			overlays += "overlay_left_charging"

	if(cell_right)
		if(cell_right.is_regenerated())
			overlays += "overlay_right_charged"
		else
			overlays += "overlay_right_charging"

	if(!machine_processing)
		icon_state = "recycler"
		return
	icon_state = "recycler_on"

/obj/structure/machinery/fuelcell_recycler/ex_act(severity)
	if(indestructible)
		return
	. = ..()

/obj/structure/machinery/fuelcell_recycler/proc/turn_off()
	visible_message(SPAN_NOTICE("[src] stops whirring as it turns off."))
	stop_processing()
	update_icon()
	update_use_power(USE_POWER_NONE)

/obj/structure/machinery/fuelcell_recycler/proc/recharge_cell(obj/item/fuel_cell/cell)
	cell.modify_fuel(recharge_amount)
	if(!cell.new_cell)
		cell.new_cell = TRUE

/obj/structure/machinery/fuelcell_recycler/full/Initialize(mapload, ...)
	. = ..()
	cell_left = new(src)
	cell_right = new(src)
	update_icon()

//reactor full cells
/obj/item/fuel_cell
	name = "\improper WL-6 universal fuel cell"
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "cell-full"
	desc = "A rechargeable fuel cell designed to work as a power source for the Cheyenne-Class transport or for Westingland S-52 Reactors."
	///How much fuel is in the reactor
	var/fuel_amount = 100
	///Max amount that the cell can hold
	var/max_fuel_amount = 100
	///If the fuel cell has been used since last recharge
	var/new_cell = TRUE

/obj/item/fuel_cell/update_icon()
	switch(get_fuel_percent())
		if(-INFINITY to 0)
			icon_state = "cell-empty"
		if(0 to 25)
			icon_state = "cell-low"
		if(25 to 75)
			icon_state = "cell-medium"
		if(75 to 99)
			icon_state = "cell-high"
		if(100 to INFINITY)
			icon_state = "cell-full"

/obj/item/fuel_cell/get_examine_text(mob/user)
	.  = ..()
	if(ishuman(user))
		. += "The fuel indicator reads: [get_fuel_percent()]%"

///Percentage of fuel left in the cell
/obj/item/fuel_cell/proc/get_fuel_percent()
	return floor(100 * fuel_amount/max_fuel_amount)

///Whether the fuel cell is full
/obj/item/fuel_cell/proc/is_regenerated()
	return (fuel_amount == max_fuel_amount)

/// increase or decrease fuel, making sure it cannot go above the max
/obj/item/fuel_cell/proc/modify_fuel(amount)
	fuel_amount = clamp(fuel_amount + amount, 0, max_fuel_amount)

/obj/item/fuel_cell/used
	new_cell = FALSE
