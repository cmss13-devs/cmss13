/obj/item/clothing/gloves/antag
	name = "suspicious gloves"
	desc = "Black gloves, both insulated and immune to the detection of " + DEFAULT_AI_SYSTEM + "."
	// "[]" won't work here because it wouldn't be a constant expression
	// DEFAULT_AI_SYSTEM for the same reason, admin-only item i've never seen used so if the ai name is wrong its not the end of the world

	icon_state = "black"
	item_state = "bgloves"
	siemens_coefficient = 0
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

	hide_prints = TRUE

/obj/item/clothing/gloves/antag/mob_can_equip(mob/user, slot)
	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		to_chat(user, SPAN_WARNING("It wouldn't be wise to put these gloves on!"))
		return FALSE
	. = ..()
