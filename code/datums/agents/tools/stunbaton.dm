/obj/item/weapon/melee/baton/antag
    name = "altered stunbaton"

    req_one_access = null
    hitcost = 500
    stunforce = 40
    has_user_lock = FALSE

/obj/item/weapon/melee/baton/antag/check_user_auth(mob/user)
    if(!skillcheck(user, SKILL_ANTAG, SKILL_ANTAG_TRAINED))
        user.visible_message(SPAN_NOTICE("[src] beeps as [user] picks it up"), SPAN_DANGER("WARNING: Unauthorized user detected. Denying access..."))
        user.Daze(10)
        user.visible_message(SPAN_WARNING("[src] beeps and sends a shock through [user]'s body!"))
        deductcharge(hitcost)

        return FALSE

    return TRUE