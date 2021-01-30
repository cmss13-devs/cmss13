/obj/item/storage/pill_bottle/ultrazine/antag
    max_storage_space = 5
    skilllock = FALSE //Antags can open it
    idlock = FALSE
    
    pill_type_to_fill = /obj/item/reagent_container/pill/stimulant

    req_access = null
    req_role = null

/obj/item/storage/pill_bottle/ultrazine/antag/id_check(mob/user)
    if(!skillcheck(user, SKILL_ANTAG, SKILL_ANTAG_TRAINED))
        return FALSE

    . = ..()