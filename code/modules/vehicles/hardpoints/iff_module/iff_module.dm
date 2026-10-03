/obj/item/hardpoint/iff_module
	name = "\improper IFF module"
	desc = "Sets whether the vehicle's weapons recognize friendly IFF-tagged rounds."

	slot = HDPT_IFF_MODULE
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "iff-0"

	health = 300
	damage_multiplier = 0.2
	power_draw = IFF_MODULE_POWER_DRAW

	/// Faction this module is set to, used for weapon IFF checks.
	var/set_faction = FACTION_MARINE

	/// TRUE if the crew wants IFF broadcasting on.
	var/manually_enabled = FALSE

/obj/item/hardpoint/iff_module/uscm
	name = "\improper AN/PPX-4 IFF module"
	desc = "This module allows crewed turrets to respect friend-and-foe identifications. Necessary for unmanned, automated turrets to operate."

/obj/item/hardpoint/iff_module/update_icon()
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "iff-[get_shared_damage_suffix()]"

/// List of factions selectable from the module.
/obj/item/hardpoint/iff_module/proc/get_selectable_factions()
	return list(FACTION_MARINE, FACTION_UPP, FACTION_TWE, FACTION_PMC, FACTION_CLF, FACTION_WY, FACTION_NEUTRAL)

/obj/item/hardpoint/iff_module/attack_self(mob/user)
	. = ..()
	var/chosen = tgui_input_list(user, "Set IFF faction", "IFF Module", get_selectable_factions(), set_faction)
	if(!chosen || !Adjacent(user))
		return
	set_faction = chosen
	to_chat(user, SPAN_NOTICE("You set \the [src]'s IFF faction to [set_faction]."))

/obj/item/hardpoint/iff_module/get_examine_text(mob/user)
	. = ..()
	. += "It's set to recognize [set_faction] IFF."

/// Whether this module is currently broadcasting a working IFF signal.
/obj/item/hardpoint/iff_module/proc/is_functional(ignore_battery = FALSE)
	if(!manually_enabled || health <= 0 || get_wound_effect_flag("iff_disabled"))
		return FALSE
	return owner && owner.has_vehicle_power(ignore_battery)

/**
 * Manually toggles this module's IFF broadcast on/off.
 * Turning it back on is blocked if the module is destroyed, disabled, or unpowered.
 */
/obj/item/hardpoint/iff_module/proc/toggle_online(mob/user)
	if(manually_enabled)
		manually_enabled = FALSE
		check_functional_transition()
		to_chat(user, SPAN_NOTICE("You shut down \the [src]'s IFF broadcast."))
		return

	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is destroyed - it can't be reactivated."))
		return
	if(get_wound_effect_flag("iff_disabled"))
		to_chat(user, SPAN_WARNING("\The [src] is too damaged to reactivate - repair it first."))
		return
	if(!owner || !owner.has_vehicle_power())
		to_chat(user, SPAN_WARNING("\The [src] has no power - start the engine or install a charged battery first."))
		return

	manually_enabled = TRUE
	check_functional_transition()
	to_chat(user, SPAN_NOTICE("You bring \the [src]'s IFF broadcast back online."))

/obj/item/hardpoint/iff_module/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	. = ..()
	check_functional_transition()

/obj/item/hardpoint/iff_module/recalculate_wound_effects()
	. = ..()
	check_functional_transition()

/obj/item/hardpoint/iff_module/on_install(obj/vehicle/multitile/vehicle)
	. = ..()
	check_functional_transition(vehicle)

// Forces the offline state directly since the vehicle will have no IFF module left after this.
/obj/item/hardpoint/iff_module/on_uninstall(obj/vehicle/multitile/vehicle)
	check_functional_transition(vehicle, force_offline = TRUE)
	update_icon()
	. = ..()

/**
 * Plays an online/offline beep whenever this vehicle's IFF functional state changes.
 * Forces manually_enabled off on shutdown, requires a deliberate toggle_online() to recover.
 *
 * Arguments:
 * * vehicle = The vehicle to check/update. Defaults to owner.
 * * force_offline = Treat this as a hard "no module" transition.
 * * ignore_battery = Passed through to is_functional()/has_vehicle_power().
 */
/obj/item/hardpoint/iff_module/proc/check_functional_transition(obj/vehicle/multitile/vehicle = owner, force_offline = FALSE, ignore_battery = FALSE)
	if(!vehicle)
		return
	var/currently_functional = force_offline ? FALSE : is_functional(ignore_battery)
	if(currently_functional == vehicle.iff_online)
		return
	vehicle.iff_online = currently_functional
	if(!currently_functional)
		manually_enabled = FALSE
	playsound(vehicle, currently_functional ? 'sound/vehicles/iffbeepactive.ogg' : 'sound/vehicles/iffbeepoff.ogg', 40, FALSE)
	vehicle.refresh_hardpoint_actions()
	vehicle.refresh_overwatch_camera_state()
