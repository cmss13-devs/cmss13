/obj/item/storage/pill_bottle/ultrazine/antag
    max_storage_space = 5
    skilllock = SKILL_MEDICAL_DEFAULT //Antags can open it
    idlock = FALSE

    pill_type_to_fill = /obj/item/reagent_container/pill/stimulant

    req_access = null
    req_role = null

/obj/item/storage/pill_bottle/ultrazine/antag/id_check(mob/user)
    if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
        return FALSE

    . = ..()
