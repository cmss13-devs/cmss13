/obj/item/hardpoint/buff/armor/ballistic
	name = "Ballistic Armor"
	desc = "Protects the vehicle from high-penetration weapons"

	icon_state = "ballistic_armor"
	disp_icon = "tank"
	disp_icon_state = "ballistic_armor"

	point_cost = 600
	health = 1000

	type_multipliers = list(
		"bullet" = 0.67,
		"slash" = 0.67,
		"all" = 0.9
	)
