/obj/item/hardpoint/buff/armor/caustic
	name = "Caustic Armor"
	desc = "Protects vehicles from most types of acid"

	icon_state = "caustic_armor"
	disp_icon = "tank"
	disp_icon_state = "caustic_armor"

	point_cost = 800
	health = 1000

	type_multipliers = list(
		"acid" = 0.67,
		"all" = 0.9
	)
