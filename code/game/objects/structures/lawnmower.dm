
/obj/structure/lawnmower
    name = "Lawnmower"
    desc = "An armored vehicle, highly effective at close range combat"
    icon = 'icons/obj/structures/mememower.dmi'
    icon_state = "lawnmower"
    dir = WEST
    anchored = FALSE
    density = TRUE
    layer = ABOVE_LYING_MOB_LAYER
    
/obj/structure/lawnmower/Move(atom/NewLoc, dir)
    . = ..()
    if(.)
        var/mowed = FALSE
        for(var/mob/living/carbon/C in NewLoc)
            C.apply_damage(100, BRUTE, "r_foot")
            mowed = TRUE
        if(mowed)
            playsound(src, 'sound/machines/lawnmower.ogg',70, TRUE)

/obj/structure/lawnmower/Dispose()
    new /obj/item/limb/foot/r_foot(get_turf(loc))
    . = ..()    
