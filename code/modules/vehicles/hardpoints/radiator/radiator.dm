/obj/item/hardpoint/radiator
	name = "\improper radiator"
	desc = "Cools a vehicle's power plant. Light enough to be carried by hand."

	slot = HDPT_RADIATOR
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "radiator-0"

	flags_atom = OPENCONTAINER

	health = 350
	damage_multiplier = 0.15

	var/max_coolant = 300
	var/amount_per_transfer_from_this = 25
	var/possible_transfer_amounts = list(10, 25, 50, 100, 250, 500)

/obj/item/hardpoint/radiator/uscm
	name = "\improper M39 radiator"
	desc = "The standard-issue radiator assembly of a USCM ground vehicle. Keeps the power plant from overheating under load."

// Civilian equivalent, shared by every colony van variant.
/obj/item/hardpoint/radiator/civilian
	name = "\improper civilian radiator"
	desc = "A commercial-grade radiator assembly. Keeps the engine from overheating under load."

/obj/item/hardpoint/radiator/update_icon()
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "radiator-[get_shared_damage_suffix()]"

/obj/item/hardpoint/radiator/on_uninstall(obj/vehicle/multitile/vehicle)
	update_icon()
	. = ..()

/obj/item/hardpoint/radiator/Initialize(mapload)
	. = ..()
	create_reagents(max_coolant)
	reagents.add_reagent("water", max_coolant)
	START_PROCESSING(SSslowobj, src)

/obj/item/hardpoint/radiator/Destroy()
	STOP_PROCESSING(SSslowobj, src)
	return ..()

/// Sets this radiator's per-transfer amount.
/obj/item/hardpoint/radiator/verb/set_APTFT()
	set name = "Set Transfer Amount"
	set category = "Object"
	set src in view(1)

	if(!reagents)
		return

	var/new_amount = tgui_input_list(usr, "Amount per transfer from this:", "[src]", possible_transfer_amounts)
	if(new_amount)
		amount_per_transfer_from_this = new_amount

/**
 * Drains coolant from an active leak wound.
 * Drains at a flat rate once fully destroyed.
 */
/obj/item/hardpoint/radiator/process(delta_time)
	if(health <= 0)
		consume_coolant(HARDPOINT_BUSTED_LEAK_RATE * delta_time)
		return
	var/leak_rate = get_wound_effect_sum("passive_leak_rate")
	if(leak_rate <= 0)
		return
	consume_coolant(leak_rate * delta_time)

/**
 * Reports how full this radiator currently is.
 *
 * Returns:
 * * Current coolant level as a percentage (0-100) of max_coolant. 0 if max_coolant is unset.
 */
/obj/item/hardpoint/radiator/proc/get_coolant_percent()
	if(!reagents || !max_coolant)
		return 0
	return 100.0 * reagents.total_volume / max_coolant

/obj/item/hardpoint/radiator/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It contains:")
	if(reagents && length(reagents.reagent_list))
		for(var/datum/reagent/current_reagent in reagents.reagent_list)
			. += SPAN_NOTICE(" [current_reagent.volume] units of [current_reagent.name].")
	else
		. += SPAN_NOTICE(" Nothing.")

/// Pours the held item's reagents into this radiator.
/obj/item/hardpoint/radiator/attackby(obj/item/item, mob/user)
	if(!item.reagents)
		return ..()

	if(!item.reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [item] is empty."))
		return ATTACKBY_HINT_NO_AFTERATTACK

	if(!can_accept_reagents(item.reagents))
		to_chat(user, SPAN_WARNING("You can't pour that into \the [src]!"))
		return ATTACKBY_HINT_NO_AFTERATTACK

	var/available = max_coolant - reagents.total_volume
	if(available <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is full!"))
		return ATTACKBY_HINT_NO_AFTERATTACK

	var/transferred = item.reagents.trans_to(src, available)
	to_chat(user, SPAN_NOTICE("You pour [transferred] units of coolant into \the [src]."))
	return ATTACKBY_HINT_NO_AFTERATTACK

/// Drains this radiator's contents into another reagent-holding target.
/obj/item/hardpoint/radiator/afterattack(atom/target, mob/user, proximity)
	if(!proximity || ismob(target))
		return ..()

	if(istype(target, /obj/structure/reagent_dispensers))
		var/obj/structure/reagent_dispensers/dispenser = target
		try_refill_from_dispenser(dispenser, user)
		return

	if(!reagents || !reagents.total_volume)
		return ..()
	if(!target.reagents || !target.is_open_container())
		return ..()

	var/room = target.reagents.maximum_volume - target.reagents.total_volume
	if(room <= 0)
		to_chat(user, SPAN_WARNING("\The [target] is full."))
		return

	var/drained = reagents.trans_to(target, min(room, amount_per_transfer_from_this))
	to_chat(user, SPAN_NOTICE("You pour [drained] units from \the [src] into \the [target]."))

/**
 * Refills this radiator from a fixed reagent dispenser.
 *
 * Arguments:
 * * dispenser = The dispenser being drawn from.
 * * user = Whoever is doing the refilling.
 */
/obj/item/hardpoint/radiator/proc/try_refill_from_dispenser(obj/structure/reagent_dispensers/dispenser, mob/user)
	if(!dispenser.reagents || !dispenser.dispensing)
		return
	if(!dispenser.reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [dispenser] is empty."))
		return
	if(!can_accept_reagents(dispenser.reagents))
		to_chat(user, SPAN_WARNING("\The [dispenser] doesn't contain anything suitable for \the [src]."))
		return

	var/available = max_coolant - reagents.total_volume
	if(available <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is full!"))
		return

	var/transferred = dispenser.reagents.trans_to(src, min(available, amount_per_transfer_from_this))
	if(!transferred)
		to_chat(user, SPAN_WARNING("You fail to draw anything from \the [dispenser]."))
		return
	to_chat(user, SPAN_NOTICE("You fill \the [src] with [transferred] units from \the [dispenser]."))

/**
 * Checks every reagent in a source holder is flagged as valid radiator coolant.
 *
 * Arguments:
 * * source = Reagent holder being poured into this radiator.
 *
 * Returns:
 * * FALSE if source holds any reagent without vehicle_coolant set, TRUE otherwise.
 */
/obj/item/hardpoint/radiator/proc/can_accept_reagents(datum/reagents/source)
	for(var/datum/reagent/reagent in source.reagent_list)
		if(!reagent.vehicle_coolant)
			return FALSE
	return TRUE

/**
 * Consumes coolant, removing the same fraction from every loaded reagent.
 *
 * Arguments:
 * * amount = Units of coolant to remove.
 *
 * Returns:
 * * Units actually removed.
 */
/obj/item/hardpoint/radiator/proc/consume_coolant(amount)
	if(!reagents || reagents.total_volume <= 0 || amount <= 0)
		return 0

	var/actual_amount = min(amount, reagents.total_volume)
	var/fraction = actual_amount / reagents.total_volume
	for(var/datum/reagent/current_reagent as anything in reagents.reagent_list.Copy())
		reagents.remove_reagent(current_reagent.id, current_reagent.volume * fraction)
	return actual_amount

/**
 * How effectively this radiator is currently cooling the engine.
 *
 * Returns:
 * * 0-1 scale, 0 if destroyed or out of coolant, 1 at full health and full coolant.
 */
/obj/item/hardpoint/radiator/proc/get_cooling_effectiveness()
	if(!reagents || reagents.total_volume <= 0)
		return 0
	return (get_integrity_percent() / 100) * (get_coolant_percent() / 100)
