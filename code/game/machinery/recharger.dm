//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/recharger
	name = "\improper recharger"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "recharger"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 4
	active_power_usage = 15000 //15 kW
	black_market_value = 35
	var/obj/item/charging = null
	var/percent_charge_complete = 0
	var/list/allowed_devices = list(/obj/item/weapon/baton, /obj/item/cell, /obj/item/weapon/gun/energy, /obj/item/device/defibrillator, /obj/item/tool/portadialysis, /obj/item/clothing/suit/auto_cpr)

	var/charge_amount = 1000

/obj/structure/machinery/recharger/attackby(obj/item/G as obj, mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	var/allowed = 0
	for (var/allowed_type in allowed_devices)
		if (istype(G, allowed_type)) allowed = 1

	if(allowed)
		if(charging)
			to_chat(user, SPAN_DANGER("\A [charging] is already charging here."))
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		var/area/current_area = get_area(src)
		if(!isarea(current_area) || (current_area.power_equip == 0 && !current_area.unlimited_power))
			to_chat(user, SPAN_DANGER("\The [name] blinks red as you try to insert the item!"))
			return
		if(istype(G, /obj/item/device/defibrillator))
			var/obj/item/device/defibrillator/defibrillator = G
			if(defibrillator.ready)
				to_chat(user, SPAN_WARNING("It won't fit, put the paddles back into \the [defibrillator] first!"))
				return
		if(istype(G, /obj/item/tool/portadialysis))
			var/obj/item/tool/portadialysis/portadialysis = G
			if(portadialysis.attached)
				to_chat(user, SPAN_WARNING("It won't fit, detach it from [portadialysis.attached] first!"))
				return
		if(user.drop_inv_item_to_loc(G, src))
			charging = G
			start_processing()
			update_icon()
	else if(HAS_TRAIT(G, TRAIT_TOOL_WRENCH))
		if(charging)
			to_chat(user, SPAN_DANGER("Remove \the [charging] first!"))
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)

/obj/structure/machinery/recharger/attack_hand(mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		stop_processing()
		percent_charge_complete = 0
		update_icon()

/obj/structure/machinery/recharger/process()
	if(inoperable() || !anchored)
		update_use_power(USE_POWER_NONE)
		update_icon()
		return
	if(!charging)
		update_use_power(USE_POWER_IDLE)
		percent_charge_complete = 0
		update_icon()
	//This is an awful check. Holy cow.
	else
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/laser_gun = charging
			if(!laser_gun.works_in_recharger)
				return;
			if(!laser_gun.cell.fully_charged())
				laser_gun.cell.give(charge_amount)
				percent_charge_complete = laser_gun.cell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/weapon/baton))
			var/obj/item/weapon/baton/stunbaton = charging
			if(stunbaton.bcell)
				if(!stunbaton.bcell.fully_charged())
					stunbaton.bcell.give(charge_amount)
					percent_charge_complete = stunbaton.bcell.percent()
					update_use_power(USE_POWER_ACTIVE)
					update_icon()
				else
					percent_charge_complete = 100
					update_use_power(USE_POWER_IDLE)
					update_icon()
			else
				percent_charge_complete = 0
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/device/defibrillator))
			var/obj/item/device/defibrillator/defibrillator = charging
			if(!defibrillator.dcell.fully_charged())
				defibrillator.dcell.give(active_power_usage*CELLRATE)
				percent_charge_complete = defibrillator.dcell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return



		if(istype(charging, /obj/item/clothing/suit/auto_cpr))
			var/obj/item/clothing/suit/auto_cpr/auto_cpr = charging
			if(!auto_cpr.pdcell.fully_charged())
				auto_cpr.pdcell.give(active_power_usage*CELLRATE)
				percent_charge_complete = auto_cpr.pdcell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/tool/portadialysis))
			var/obj/item/tool/portadialysis/portadialysis = charging
			if(!portadialysis.pdcell.fully_charged())
				portadialysis.pdcell.give(active_power_usage*CELLRATE)
				percent_charge_complete = portadialysis.pdcell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/cell))
			var/obj/item/cell/power_cell = charging
			if(!power_cell.fully_charged())
				power_cell.give(active_power_usage*CELLRATE)
				percent_charge_complete = power_cell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		/* Disable defib recharging
		if(istype(charging, /obj/item/device/defibrillator))
			var/obj/item/device/defibrillator/defibrillator = charging
			if(defibrillator.dcell)
				if(!defibrillator.dcell.fully_charged())
					icon_state = icon_state_charging
					defibrillator.dcell.give(active_power_usage*CELLRATE)
					update_use_power(USE_POWER_ACTIVE)
				else
					icon_state = icon_state_charged
					update_use_power(USE_POWER_IDLE)
			else
				icon_state = icon_state_idle
				update_use_power(USE_POWER_IDLE)
			return
		*/

/obj/structure/machinery/recharger/power_change()
	..()
	update_icon()

/obj/structure/machinery/recharger/emp_act(severity)
	if(inoperable() || !anchored)
		..(severity)
		return
/*
	if(istype(charging,  /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/laser_gun = charging
		if(laser_gun.power_supply)
			laser_gun.power_supply.emp_act(severity)
*/
	if(istype(charging, /obj/item/weapon/baton))
		var/obj/item/weapon/baton/stunbaton = charging
		if(stunbaton.bcell)
			stunbaton.bcell.charge = 0
	..(severity)

/obj/structure/machinery/recharger/update_icon() //we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	src.overlays = 0
	if((inoperable()))
		return
	else if(!charging)
		overlays += "recharger-power"
		return

	if(percent_charge_complete < 25)
		overlays += "recharger-10"
	else if(percent_charge_complete >= 25 && percent_charge_complete < 50)
		overlays += "recharger-25"
	else if(percent_charge_complete >= 50 && percent_charge_complete < 75)
		overlays += "recharger-50"
	else if(percent_charge_complete >= 75 && percent_charge_complete < 100)
		overlays += "recharger-75"
	else if(percent_charge_complete >= 100)
		overlays += "recharger-100"

	if(istype(charging, /obj/item/weapon/gun/energy))
		overlays += "recharger-taser"//todo make more generic I guess. It works for now -trii
	else if(istype(charging, /obj/item/weapon/baton))
		overlays += "recharger-baton"

/obj/structure/machinery/recharger/get_examine_text(mob/user)
	. = ..()
	. += "There's [charging ? "[charging]" : "nothing"] in the charger."
	if(charging)
		if(istype(charging, /obj/item/cell))
			var/obj/item/cell/power_cell = charging
			. += "Current charge: [power_cell.charge] ([power_cell.percent()]%)"

/obj/structure/machinery/recharger/unanchored
	anchored = FALSE

/*
/obj/structure/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 25000 //25 kW , It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/baton)
	icon_state_charged = "wrecharger2"
	icon_state_idle = "wrecharger0"
	icon_state_charging = "wrecharger1"
*/
