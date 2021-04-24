/obj/item/clothing/gloves/antag
    name = "suspicious gloves"
    desc = "Black gloves, both insulated and immune to the detection of " + MAIN_AI_SYSTEM + "."
    // "[]" won't work here because it wouldn't be a constant expression

    icon_state = "black"
    item_state = "bgloves"

    siemens_coefficient = 0
    permeability_coefficient = 0.05
    flags_cold_protection = BODY_FLAG_HANDS
    min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
    flags_heat_protection = BODY_FLAG_HANDS
    max_heat_protection_temperature = GLOVES_max_heat_protection_temperature

    hide_prints = TRUE

/obj/item/clothing/gloves/antag/mob_can_equip(mob/user, slot)
    if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
        to_chat(user, SPAN_WARNING("It wouldn't be wise to put these gloves on!"))
        return FALSE
    . = ..()
