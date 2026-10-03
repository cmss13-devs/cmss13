/obj/item/hardpoint/engine
	name = "\improper Power Plant"
	desc = "A vehicle's engine block. Too heavy and awkwardly shaped to be man-handled. A power loader is needed to lift it in or out."

	slot = HDPT_ENGINE
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "engine-0"

	w_class = SIZE_MASSIVE
	density = TRUE
	anchored = TRUE

	health = 500
	damage_multiplier = 0.15

	var/engine_temperature = T20C
	/// world.time before which the overheat wound check won't roll again.
	var/next_overheat_wound_roll = 0

// Too heavy to man-handle.
/obj/item/hardpoint/engine/attack_hand(mob/user)
	return

/// Shuts the engine off if it's removed while still running.
/obj/item/hardpoint/engine/on_uninstall(obj/vehicle/multitile/vehicle)
	if(vehicle?.engine_on)
		vehicle.set_engine_on(FALSE)
	update_icon()
	. = ..()

/// Shuts the engine off the moment it's destroyed by damage.
/obj/item/hardpoint/engine/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	. = ..()
	if(health <= 0 && owner?.engine_on)
		owner.set_engine_on(FALSE)

/obj/item/hardpoint/engine/tank
	name = "\improper  Lunnar-Welsun AGT1200"
	desc = "A 1200HP gas turbine power plant driving the M34A2 Longstreet. Too heavy and awkwardly shaped to be man-handled. A power loader is needed to lift it in or out."

	health = 550

/obj/item/hardpoint/engine/apc
	name = "\improper Alphatech TD800 "
	desc = "A 760HP turbocharged diesel piston engine driving the M577 Armored Personnel Carrier. Too heavy and awkwardly shaped to be man-handled. A power loader is needed to lift it in or out."

/obj/item/hardpoint/engine/arc
	name = "\improper Alphatech TD700"
	desc = "A 655HP turbocharged diesel piston engine driving the M540-B Armored Recon Carrier. Too heavy and awkwardly shaped to be man-handled. A power loader is needed to lift it in or out."

// Shared by every colony van variant.
/obj/item/hardpoint/engine/van
	name = "\improper Alphatech D400"
	desc = "A commercial 360HP diesel piston engine block. Too heavy and awkwardly shaped to be man-handled. A power loader is needed to lift it in or out."

/obj/item/hardpoint/engine/update_icon()
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "engine-[get_shared_damage_suffix()]"

// I wasn't going to add this initially, but allowing an engine to overheat ad infinitum doesn't seem very nice
/obj/item/hardpoint/engine/proc/is_overheating()
	return engine_temperature > ENGINE_OVERHEAT_THRESHOLD

/**
 * Reports how hot this engine is, as a percent from room temperature to overheating.
 *
 * Returns:
 * * 0 at room temperature, 100 at the overheat threshold, and beyond 100 past that.
 */
/obj/item/hardpoint/engine/proc/get_temperature_percent()
	var/range = ENGINE_OVERHEAT_THRESHOLD - T20C
	if(!range)
		return 0
	return 100 * (engine_temperature - T20C) / range
