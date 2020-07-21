/obj/structure/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "ccharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 40000	//40 kW. (this the power drawn when charging)
	power_channel = POWER_CHANNEL_EQUIP
	var/obj/item/cell/charging = null
	var/chargelevel = -1

/obj/structure/machinery/cell_charger/proc/updateicon()
	icon_state = "ccharger[charging ? 1 : 0]"

	if(charging && !(inoperable()) )

		var/newlevel = 	round(charging.percent() * 4.0 / 99)

		if(chargelevel != newlevel)

			overlays.Cut()
			overlays += "ccharger-o[newlevel]"

			chargelevel = newlevel
	else
		overlays.Cut()

/obj/structure/machinery/cell_charger/examine(mob/user)
	..()
	to_chat(user, "There's [charging ? "a" : "no"] cell in the charger.")
	if(charging)
		to_chat(user, "Current charge: [charging.charge]")

/obj/structure/machinery/cell_charger/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/cell) && anchored)
		if(charging)
			to_chat(user, SPAN_DANGER("There is already a cell in the charger."))
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, SPAN_DANGER("The [name] blinks red as you try to insert the cell!"))
				return

			if(user.drop_inv_item_to_loc(W, src))
				charging = W
				user.visible_message("[user] inserts a cell into the charger.", "You insert a cell into the charger.")
				chargelevel = -1
				start_processing()
		updateicon()
	else if(istype(W, /obj/item/tool/wrench))
		if(charging)
			to_chat(user, SPAN_DANGER("Remove the cell first!"))
			return

		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] the cell charger [anchored ? "to" : "from"] the ground.")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)

/obj/structure/machinery/cell_charger/attack_hand(mob/user)
	if(charging)
		usr.put_in_hands(charging)
		charging.add_fingerprint(user)
		charging.updateicon()

		src.charging = null
		user.visible_message("[user] removes the cell from the charger.", "You remove the cell from the charger.")
		chargelevel = -1
		updateicon()
		stop_processing()

/obj/structure/machinery/cell_charger/attack_remote(mob/user)
	return

/obj/structure/machinery/cell_charger/emp_act(severity)
	if(inoperable())
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)


/obj/structure/machinery/cell_charger/process()
	if((inoperable()) || !anchored)
		update_use_power(0)
		return

	if (charging && !charging.fully_charged())
		charging.give(active_power_usage*CELLRATE)
		update_use_power(2)

		updateicon()
	else
		update_use_power(1)
