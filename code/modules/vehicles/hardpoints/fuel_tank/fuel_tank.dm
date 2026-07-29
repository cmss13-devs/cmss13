/obj/item/hardpoint/fuel_tank
	name = "\improper fuel tank"
	desc = "Holds a vehicle's fuel supply. Light enough to be carried by hand."

	slot = HDPT_FUEL_TANK
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "fuel-0"

	flags_atom = OPENCONTAINER

	health = 550
	damage_multiplier = 0.15

	var/max_fuel = 500
	var/native_fuel_id = "jp8"
	/// Vehicle moves since the last fuel leak puddle drop.
	var/moves_since_puddle = 0
	/// TRUE while a gauze patch is masking the leak.
	var/list/taped_wounds
	var/amount_per_transfer_from_this = 25
	var/possible_transfer_amounts = list(10, 25, 50, 100, 250, 500)

// Shared by the tank and APC.
/obj/item/hardpoint/fuel_tank/uscm
	name = "\improper M39 fuel tank"
	desc = "The standard-issue main fuel tank of the USCM's amored vehicles. Runs best on JP-8, but can make do with welding fuel or cooking oil in a pinch."

/obj/item/hardpoint/fuel_tank/arc
	name = "\improper M540-B fuel tank"
	desc = "The compact main fuel tank of the M540-B Armored Recon Carrier. Runs best on JP-8, but can make do with welding fuel or cooking oil in a pinch."
	max_fuel = 200

/obj/item/hardpoint/fuel_tank/van
	name = "\improper diesel fuel tank"
	desc = "A commercial diesel fuel tank. Runs best on Diesel, but can make do with welding fuel or cooking oil in a pinch."
	max_fuel = 150
	native_fuel_id = "diesel"

/obj/item/hardpoint/fuel_tank/Initialize(mapload)
	. = ..()
	create_reagents(max_fuel)
	reagents.add_reagent(native_fuel_id, max_fuel)
	START_PROCESSING(SSslowobj, src)

/obj/item/hardpoint/fuel_tank/Destroy()
	STOP_PROCESSING(SSslowobj, src)
	return ..()

/// Sets this tank's per-transfer amount.
/obj/item/hardpoint/fuel_tank/verb/set_APTFT()
	set name = "Set Transfer Amount"
	set category = "Object"
	set src in view(1)

	if(!reagents)
		return

	var/new_amount = tgui_input_list(usr, "Amount per transfer from this:", "[src]", possible_transfer_amounts)
	if(new_amount)
		amount_per_transfer_from_this = new_amount

/**
 * Drains fuel from an active leak wound.
 * Drains at a flat rate once fully destroyed.
 */
/obj/item/hardpoint/fuel_tank/process(delta_time)
	if(health <= 0)
		consume_fuel(HARDPOINT_BUSTED_LEAK_RATE * delta_time)
		return
	if(LAZYACCESS(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak))
		return
	var/leak_rate = get_wound_effect_sum("passive_leak_rate")
	if(leak_rate <= 0)
		return
	consume_fuel(leak_rate * delta_time)

/// Drops a fuel puddle as the vehicle moves, based on leak severity.
/obj/item/hardpoint/fuel_tank/on_move(turf/old, turf/new_turf, move_dir)
	. = ..()
	var/leak_tier = LAZYACCESS(wound_tiers, /datum/hardpoint_wound_family/fuel_tank_leak)
	if(!leak_tier || LAZYACCESS(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak))
		moves_since_puddle = 0
		return

	var/moves_per_puddle = (leak_tier >= 2) ? 1 : 3
	moves_since_puddle++
	if(moves_since_puddle < moves_per_puddle)
		return
	moves_since_puddle = 0

	var/turf/leak_turf = get_turf(owner)
	if(leak_turf)
		new /obj/effect/decal/cleanable/liquid_fuel(leak_turf, 1)

/obj/item/hardpoint/fuel_tank/proc/get_fuel_percent()
	if(!reagents || !max_fuel)
		return 0
	return 100.0 * reagents.total_volume / max_fuel

/obj/item/hardpoint/fuel_tank/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It contains:")
	if(reagents && length(reagents.reagent_list))
		for(var/datum/reagent/current_reagent in reagents.reagent_list)
			. += SPAN_NOTICE(" [current_reagent.volume] units of [current_reagent.name].")
	else
		. += SPAN_NOTICE(" Nothing.")

/// Pours the held item's reagents into this tank.
/obj/item/hardpoint/fuel_tank/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/stack/medical/bruise_pack))
		try_tape_leak(item, user)
		return

	if(!item.reagents)
		return ..()

	if(!item.reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [item] is empty."))
		return ATTACKBY_HINT_NO_AFTERATTACK

	if(!can_accept_reagents(item.reagents))
		to_chat(user, SPAN_WARNING("You can't pour that into \the [src]!"))
		return ATTACKBY_HINT_NO_AFTERATTACK

	var/available = max_fuel - reagents.total_volume
	if(available <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is full!"))
		return ATTACKBY_HINT_NO_AFTERATTACK

	var/transferred = item.reagents.trans_to(src, available)
	to_chat(user, SPAN_NOTICE("You pour [transferred] units of fuel into \the [src]."))
	return ATTACKBY_HINT_NO_AFTERATTACK

/// Drains this tank's contents into another reagent-holding target.
/obj/item/hardpoint/fuel_tank/afterattack(atom/target, mob/user, proximity)
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
 * Refills this tank from a fixed reagent dispenser.
 *
 * Arguments:
 * * dispenser = The dispenser being drawn from.
 * * user = Whoever is doing the refilling.
 */
/obj/item/hardpoint/fuel_tank/proc/try_refill_from_dispenser(obj/structure/reagent_dispensers/dispenser, mob/user)
	if(!dispenser.reagents || !dispenser.dispensing)
		return
	if(!dispenser.reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [dispenser] is empty."))
		return
	if(!can_accept_reagents(dispenser.reagents))
		to_chat(user, SPAN_WARNING("\The [dispenser] doesn't contain anything suitable for \the [src]."))
		return

	var/available = max_fuel - reagents.total_volume
	if(available <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is full!"))
		return

	var/transferred = dispenser.reagents.trans_to(src, min(available, amount_per_transfer_from_this))
	if(!transferred)
		to_chat(user, SPAN_WARNING("You fail to draw anything from \the [dispenser]."))
		return
	to_chat(user, SPAN_NOTICE("You fill \the [src] with [transferred] units from \the [dispenser]."))

/**
 * Checks every reagent in a source holder is flagged as valid vehicle fuel.
 *
 * Arguments:
 * * source = Reagent holder being poured into this tank.
 *
 * Returns:
 * * FALSE if source holds any reagent without vehicle_fuel set, TRUE otherwise.
 */
/obj/item/hardpoint/fuel_tank/proc/can_accept_reagents(datum/reagents/source)
	for(var/datum/reagent/reagent in source.reagent_list)
		if(!reagent.vehicle_fuel)
			return FALSE
	return TRUE

/**
 * Burns fuel, removing the same fraction from every loaded reagent.
 *
 * Arguments:
 * * amount = Units of fuel to remove.
 *
 * Returns:
 * * Units actually removed.
 */
/obj/item/hardpoint/fuel_tank/proc/consume_fuel(amount)
	if(!reagents || reagents.total_volume <= 0 || amount <= 0)
		return 0

	var/actual_amount = min(amount, reagents.total_volume)
	var/fraction = actual_amount / reagents.total_volume
	for(var/datum/reagent/current_reagent as anything in reagents.reagent_list.Copy())
		reagents.remove_reagent(current_reagent.id, current_reagent.volume * fraction)
	return actual_amount

/**
 * Volume-weighted performance penalty from whatever fuel is loaded.
 *
 * Returns:
 * * 1 for pure full-spec fuel (vehicle_fuel_performance_mult >= 1, e.g. JP-8 or Diesel), up to
 *   OFF_LABEL_FUEL_PENALTY for pure off-label fuel.
 */
/obj/item/hardpoint/fuel_tank/proc/get_fuel_blend_penalty()
	if(!reagents || !reagents.total_volume)
		return 1

	var/weighted_penalty = 0
	for(var/datum/reagent/current_reagent in reagents.reagent_list)
		var/reagent_penalty = (current_reagent.vehicle_fuel_performance_mult >= 1) ? 1 : OFF_LABEL_FUEL_PENALTY
		weighted_penalty += reagent_penalty * (current_reagent.volume / reagents.total_volume)
	return weighted_penalty

/**
 * Volume-weighted top speed/acceleration multiplier from whatever fuel is loaded.
 *
 * Returns:
 * * 1 for an empty tank, blended otherwise.
 */
/obj/item/hardpoint/fuel_tank/proc/get_fuel_performance_mult()
	if(!reagents || !reagents.total_volume)
		return 1

	var/weighted_mult = 0
	for(var/datum/reagent/current_reagent in reagents.reagent_list)
		weighted_mult += current_reagent.vehicle_fuel_performance_mult * (current_reagent.volume / reagents.total_volume)
	return weighted_mult

/// Fraction (0-1) of this tank's volume made up of the given reagent id.
/obj/item/hardpoint/fuel_tank/proc/get_reagent_fraction(reagent_id)
	if(!reagents || !reagents.total_volume)
		return 0
	return reagents.get_reagent_amount(reagent_id) / reagents.total_volume

/**
 * Patches an active fuel leak with gauze. Damage can tear it back off.
 *
 * Arguments:
 * * gauze = The gauze roll used.
 * * user = Whoever is applying it.
 */
/obj/item/hardpoint/fuel_tank/proc/try_tape_leak(obj/item/stack/medical/bruise_pack/gauze, mob/living/user)
	var/leak_tier = LAZYACCESS(wound_tiers, /datum/hardpoint_wound_family/fuel_tank_leak)
	if(!leak_tier)
		to_chat(user, SPAN_WARNING("\The [src] isn't leaking - there's nothing to patch."))
		return
	if(LAZYACCESS(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak))
		to_chat(user, SPAN_WARNING("\The [src]'s leak is already taped up."))
		return

	user.visible_message(SPAN_NOTICE("[user] starts wrapping gauze around \the [src]'s leak."), SPAN_NOTICE("You start wrapping gauze around \the [src]'s leak."))
	if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return
	if(!gauze || QDELETED(gauze) || gauze != user.get_active_hand() || LAZYACCESS(wound_tiers, /datum/hardpoint_wound_family/fuel_tank_leak) != leak_tier || LAZYACCESS(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak))
		return

	gauze.use(1)
	LAZYSET(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak, TRUE)
	owner?.update_icon()
	user.visible_message(SPAN_NOTICE("[user] tapes up \the [src]'s leak with gauze."), SPAN_NOTICE("You tape up \the [src]'s leak with gauze."))

/// A gauze-taped leak has a chance to tear back open under continued damage.
/obj/item/hardpoint/fuel_tank/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	. = ..()
	if(!damage || !LAZYACCESS(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak))
		return
	if(!prob(50 + damage * 2.5))
		return
	LAZYREMOVE(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak)
	owner?.update_icon()
	notify_crew_of_wound("The gauze patch on the fuel tank tears loose - the leak's back!", "The metal beast's patched wound tears open once more!", FALSE)

/// Prunes taped_wounds once a wound is actually repaired.
/obj/item/hardpoint/fuel_tank/recalculate_wound_effects()
	. = ..()
	if(LAZYLEN(taped_wounds) && !LAZYACCESS(wound_tiers, /datum/hardpoint_wound_family/fuel_tank_leak))
		LAZYREMOVE(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak)
		owner?.update_icon()

/// This module only has a loose obj sprite, no on-tank sprite.
/obj/item/hardpoint/fuel_tank/update_icon()
	var/suffix
	if(LAZYACCESS(taped_wounds, /datum/hardpoint_wound_family/fuel_tank_leak))
		suffix = 3
	else
		suffix = (get_integrity_percent() < 33) ? 2 : ((get_integrity_percent() < 66) ? 1 : 0)
		suffix = max(suffix, LAZYACCESS(wound_tiers, /datum/hardpoint_wound_family/fuel_tank_leak) || 0)
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "fuel-[suffix]"

/obj/item/hardpoint/fuel_tank/on_uninstall(obj/vehicle/multitile/vehicle)
	update_icon()
	. = ..()
