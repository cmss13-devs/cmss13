/obj/item/hardpoint/buff/armor/paladin
	name = "Paladin Armor"
	desc = "Protects the vehicle from large incoming explosive projectiles"

	icon_state = "paladin_armor"
	disp_icon = "tank"
	disp_icon_state = "paladin_armor"

	point_cost = 600
	health = 1000

	type_multipliers = list(
		"explosive" = 0.67,
		"all" = 0.9
	)
