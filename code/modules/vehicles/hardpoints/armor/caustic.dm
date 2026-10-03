/obj/item/hardpoint/armor/caustic
	name = "\improper Caustic Armor"
	desc = "Protects vehicles from most types of acid."

	icon_state = "caustic_armor"
	disp_icon = "tank"
	disp_icon_state = "caustic_armor"

	// anti boiler spitter sentinel armor
	type_multipliers = list(
		"acid" = 0.67,
		"all" = 0.9
	)
	protects_internal_modules = TRUE
	neuro_wound_chance_mult = 0.67
