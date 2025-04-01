/obj/structure/machinery/portable_atmospherics
	name = "atmoalter"
	use_power = USE_POWER_NONE
	var/destroyed = 0

/obj/structure/machinery/portable_atmospherics/proc/disconnect()
	anchored = FALSE
	return 1


/obj/structure/machinery/portable_atmospherics/attackby(obj/item/W, mob/user)
	if((istype(W, /obj/item/device/analyzer)) && Adjacent(user))
		visible_message(SPAN_DANGER("[user] has used [W] on [icon2html(icon, viewers(src))]"))
		to_chat(user, SPAN_NOTICE(" Results of analysis of [icon2html(icon, user)]"))
		to_chat(user, SPAN_NOTICE(" Tank is empty!"))




/obj/structure/machinery/portable_atmospherics/powered
	var/power_rating
	var/power_losses
	var/last_power_draw = 0
	var/obj/item/cell/cell

/obj/structure/machinery/portable_atmospherics/powered/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(cell)
			to_chat(user, "There is already a power cell installed.")
			return

		var/obj/item/cell/C = I

		if(user.drop_inv_item_to_loc(C, src))
			C.add_fingerprint(user)
			cell = C
			user.visible_message(SPAN_NOTICE("[user] opens the panel on [src] and inserts [C]."), SPAN_NOTICE("You open the panel on [src] and insert [C]."))
		return

	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		if(!cell)
			to_chat(user, SPAN_DANGER("There is no power cell installed."))
			return

		user.visible_message(SPAN_NOTICE("[user] opens the panel on [src] and removes [cell]."), SPAN_NOTICE("You open the panel on [src] and remove [cell]."))
		cell.add_fingerprint(user)
		cell.forceMove(loc)
		cell = null
		return

	. = ..()

