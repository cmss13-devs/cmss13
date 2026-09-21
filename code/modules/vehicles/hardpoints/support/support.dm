/obj/item/hardpoint/support
	name = "support hardpoint"
	desc = "Support module, providing passive buffs and active abilities."

	slot = HDPT_SUPPORT
	hdpt_layer = HDPT_LAYER_SUPPORT

	damage_multiplier = 0.075

/// Support modules switch to their damaged sprite on any active wound
/obj/item/hardpoint/support/get_mounted_damage_suffix(threshold_pct = 50)
	if(get_integrity_percent() < threshold_pct)
		return 1
	return LAZYLEN(wound_tiers) ? 1 : 0

/**
 * Whether this module's own effect should currently be active.
 * FALSE if destroyed, disabled by a wound, or the vehicle has no power.
 *
 * Arguments:
 * * vehicle = Defaults to owner.
 * * ignore_battery = Passed through to has_vehicle_power().
 */
/obj/item/hardpoint/support/proc/is_functional(obj/vehicle/multitile/vehicle = owner, ignore_battery = FALSE)
	return health > 0 && !get_wound_effect_flag("module_disabled") && vehicle && vehicle.has_vehicle_power(ignore_battery)

/**
 * Applies or removes this module's own effect to match is_functional() right now.
 * Subtypes with a real active ability, like Artillery Module, override this too.
 *
 * Arguments:
 * * vehicle = Defaults to owner.
 * * ignore_battery = Passed through to is_functional().
 */
/obj/item/hardpoint/support/proc/refresh_functional_state(obj/vehicle/multitile/vehicle = owner, ignore_battery = FALSE)
	if(!vehicle)
		return
	if(is_functional(vehicle, ignore_battery))
		apply_buff(vehicle)
	else
		remove_buff(vehicle)

/obj/item/hardpoint/support/on_install(obj/vehicle/multitile/vehicle)
	. = ..()
	refresh_functional_state(vehicle)

/obj/item/hardpoint/support/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	. = ..()
	refresh_functional_state()

/obj/item/hardpoint/support/recalculate_wound_effects()
	. = ..()
	refresh_functional_state()
