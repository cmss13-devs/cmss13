/obj/item/hardpoint/support/weapons_sensor
	name = "\improper Integrated Weapons Sensor Array"
	desc = "Improves the accuracy and fire rate of all onboard weapons."

	icon_state = "warray"
	disp_icon = "tank"
	disp_icon_state = "warray"

	px_offsets = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 32),
		"8" = list(0, 0)
	)

	health = 550

	buff_multipliers = list(
		"cooldown" = 0.67,
		"accuracy" = 1.67
	)

	var/turret_turn_rate_buff = 1.2

/**
 * Also scales the turret's turn rate and recalculates it, on top of the normal
 * cooldown/accuracy handling from ..().
 */
/obj/item/hardpoint/support/weapons_sensor/apply_buff(obj/vehicle/multitile/vehicle)
	if(buff_applied)
		return
	. = ..()
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
	if(turret)
		turret.turret_turn_rate_mult *= turret_turn_rate_buff
		turret.recalculate_turn_rate()

/// Reverses apply_buff()'s turret turn rate scaling.
/obj/item/hardpoint/support/weapons_sensor/remove_buff(obj/vehicle/multitile/vehicle)
	if(!buff_applied)
		return
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
	. = ..()
	if(turret)
		turret.turret_turn_rate_mult /= turret_turn_rate_buff
		turret.recalculate_turn_rate()
