/obj/item/hardpoint/armor/paladin
	name = "\improper Paladin Armor"
	desc = "Protects the vehicle from large incoming explosive projectiles."

	icon_state = "paladin_armor"
	disp_icon = "tank"
	disp_icon_state = "paladin_armor"

	// anti suicide armor
	type_multipliers = list(
		"explosive" = 0.2,
		"bullet" = 0.8,
		"slash" = 0.9,
		"blunt" = 0.9,
		"all" = 0.9
	)
