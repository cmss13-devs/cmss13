/obj/item/hardpoint/armor/concussive
	name = "\improper Concussive Armor"
	desc = "Protects the vehicle from high-impact weapons."

	icon_state = "concussive_armor"
	disp_icon = "tank"
	disp_icon_state = "concussive_armor"

	// anti melee armor
	type_multipliers = list(
		"slash" = 0.67,
		"blunt" = 0.67,
		"bullet" = 0.8,
		"explosive" = 0.8,
		"all" = 0.9
	)
