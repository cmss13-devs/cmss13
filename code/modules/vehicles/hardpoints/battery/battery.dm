/obj/item/hardpoint/battery
	name = "\improper battery"
	desc = "Supplies electrical power for a vehicle's onboard systems. Light enough to be carried by hand."

	slot = HDPT_BATTERY
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "battery-0"

	health = 350
	damage_multiplier = 0.15

	var/max_charge = 1000
	var/current_charge = 1000

/obj/item/hardpoint/battery/uscm
	name = "\improper WY-24 power bank"
	desc = "A Weyland-Yutani-manufactured 24V power bank, standard issue across the USCM ground vehicle fleet. Powers onboard systems such as the IFF module."

	max_charge = 2000
	current_charge = 2000

/obj/item/hardpoint/battery/civilian
	name = "\improper 12V civilian battery"
	desc = "A standard 12V civilian vehicle battery. Powers the starter and onboard electrics."

/obj/item/hardpoint/battery/proc/get_charge_percent()
	if(!max_charge)
		return 0
	return 100.0 * current_charge / max_charge

// Refreshes everything that depends on vehicle power when this battery is installed.
/obj/item/hardpoint/battery/on_install(obj/vehicle/multitile/vehicle)
	. = ..()
	recalculate_owner_turret(vehicle)
	vehicle?.recheck_iff_module()
	vehicle?.recheck_support_modules()
	vehicle?.recheck_visual_sensors()

// Forces every power-dependent recalculation to treat this departing battery as already gone.
/obj/item/hardpoint/battery/on_uninstall(obj/vehicle/multitile/vehicle)
	recalculate_owner_turret(vehicle, ignore_battery = TRUE)
	vehicle?.recheck_iff_module(ignore_battery = TRUE)
	vehicle?.recheck_support_modules(ignore_battery = TRUE)
	vehicle?.recheck_turn_signals(ignore_battery = TRUE)
	vehicle?.recheck_visual_sensors(ignore_battery = TRUE)
	update_icon()
	. = ..()

/// Rechecks everything that depends on vehicle power the instant this battery is destroyed.
/obj/item/hardpoint/battery/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	var/was_functional = health > 0
	. = ..()
	if(was_functional && health <= 0 && owner)
		recalculate_owner_turret(owner)
		owner.recheck_iff_module()
		owner.recheck_support_modules()
		owner.recheck_turn_signals()
		owner.recheck_visual_sensors()

/obj/item/hardpoint/battery/proc/recalculate_owner_turret(obj/vehicle/multitile/vehicle = owner, ignore_battery = FALSE)
	if(!vehicle)
		return
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
	if(turret)
		turret.recalculate_turn_rate(ignore_battery)

/// This module only has a loose obj sprite, no on-tank sprite.
/obj/item/hardpoint/battery/update_icon()
	var/suffix = 0
	if(get_integrity_percent() < 33)
		suffix = 2
	else if(get_integrity_percent() < 66)
		suffix = 1
	if(LAZYLEN(wound_tiers))
		suffix = max(suffix, 1)
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "battery-[suffix]"
