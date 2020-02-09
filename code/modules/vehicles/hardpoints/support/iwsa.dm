/obj/item/hardpoint/buff/support/weapons_sensor
	name = "Integrated Weapons Sensor Array"
	desc = "Improves the accuracy and fire rate of all onboard weapons"

	icon_state = "warray"
	disp_icon = "tank"
	disp_icon_state = "warray"

	point_cost = 300
	health = 250

	buff_multipliers = list(
		"cooldown" = 0.67,
		"accuracy" = 1.67
	)
