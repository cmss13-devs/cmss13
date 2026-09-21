/obj/item/hardpoint/turret_ring
	name = "\improper turret ring"
	desc = "Lets the turret rotate. Slows the turret's turn rate as it takes damage."

	slot = HDPT_TURRET_RING
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "ring-0"

	health = 400
	damage_multiplier = 0.15
	power_draw = TURRET_RING_IDLE_POWER_DRAW

/obj/item/hardpoint/turret_ring/uscm
	name = "\improper M39 turret ring"
	desc = "Lets a vehicle's mounted weapon traverse. Slows its turn rate as it takes damage."

/obj/item/hardpoint/turret_ring/update_icon()
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "ring-[get_shared_damage_suffix()]"

/obj/item/hardpoint/turret_ring/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	. = ..()
	recalculate_owner_turret()

/obj/item/hardpoint/turret_ring/recalculate_wound_effects()
	. = ..()
	recalculate_owner_turret()

/obj/item/hardpoint/turret_ring/on_install(obj/vehicle/multitile/vehicle)
	. = ..()
	recalculate_owner_turret(vehicle)

/// Forces every turret/weapon this ring drives to 0 turn rate directly, since the ring is already known to be departing.
/obj/item/hardpoint/turret_ring/on_uninstall(obj/vehicle/multitile/vehicle)
	if(vehicle)
		var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
		if(turret)
			turret.max_angular_velocity = 0
		for(var/obj/item/hardpoint/weapon in vehicle.hardpoints)
			if(weapon != src)
				weapon.max_angular_velocity = 0
	update_icon()
	. = ..()

/**
 * Refreshes the vehicle's turret turn rate so it reflects this ring's current integrity - both the
 * holder-based turret (if any) and any top-level rotating weapon that's its own rotation owner (e.g.
 * the APC's dualcannon/frontalcannon).
 *
 * Arguments:
 * * vehicle = Vehicle to look up the turret/weapons on. Defaults to owner.
 */
/obj/item/hardpoint/turret_ring/proc/recalculate_owner_turret(obj/vehicle/multitile/vehicle = owner)
	if(!vehicle)
		return
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
	if(turret)
		turret.recalculate_turn_rate()
	for(var/obj/item/hardpoint/weapon in vehicle.hardpoints)
		if(weapon != src)
			weapon.recalculate_own_turn_rate()
