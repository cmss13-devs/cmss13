/obj/item/hardpoint/armor/ballistic
	name = "\improper Ballistic Armor"
	desc = "Protects the vehicle from high-penetration weapons."

	icon_state = "ballistic_armor"
	disp_icon = "tank"
	disp_icon_state = "ballistic_armor"

	// anti FF armor
	type_multipliers = list(
		"bullet" = 0.2,
		"explosive" = 0.8,
		"slash" = 0.9,
		"blunt" = 0.9,
		"all" = 0.9
	)
