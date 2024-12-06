/obj/structure/watchtower
    name = "watchtower"
    icon = 'icons/obj/structures/watchtower.dmi'
    icon_state = "stage1"

    density = TRUE
    bound_width = 64
    bound_height = 96

    var/stage = 1

/obj/structure/watchtower/Initialize()
    var/list/turf/turfs = CORNER_BLOCK(get_turf(src), 2, 2)

    for(var/turf/current_turf in turfs)
        new /obj/structure/blocker/invisible_wall(current_turf)

/obj/structure/watchtower/Destroy()
    var/list/turf/turfs = CORNER_BLOCK(get_turf(src), 2, 2)

    for(var/turf/current_turf in turfs)
        for(var/obj/structure/blocker/invisible_wall in current_turf.contents)
            qdel(invisible_wall)
            new /obj/structure/girder(current_turf)

/obj/structure/watchtower/update_icon(roof=TRUE)
    . = ..()
    icon_state = "stage[stage]"

    if(stage >= 5)
        overlays += image(icon=icon, icon_state="railings", layer=ABOVE_MOB_LAYER, pixel_y=25)

    if (stage == 7 && roof)
        overlays += image(icon=icon, icon_state="roof", layer=ABOVE_MOB_LAYER, pixel_y=51)

/obj/structure/watchtower/attackby(obj/item/W, mob/user)
    switch(stage)
        if(1)
            if(!istype(W, /obj/item/stack/rods))
                return

            var/obj/item/stack/rods/rods = W

            if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
                return

            if(rods.use(10))
                to_chat(user, SPAN_NOTICE("You add connection rods to the watchtower."))
                stage = 2
                update_icon()
            else
                to_chat(user, SPAN_NOTICE("You failed to construct the connection rods. You need more rods."))

            return
        if(2)
            if(!iswelder(W))
                return

            if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
                to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
                return

            if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
                return

            to_chat(user, SPAN_NOTICE("You weld the connection rods to the frame."))
            stage = 2.5

            return
        if(2.5)
            if(!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
                return

            if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
                return

            to_chat(user, SPAN_NOTICE("You summon a black hole and somehow produce more matter to elevate the frame."))
            stage = 3
            update_icon()

            return
        if(3)
            if(!HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
                return

            var/obj/item/stack/sheet/metal/metal = user.get_inactive_hand()
            if(!istype(metal))
                to_chat(user, SPAN_BOLDWARNING("You need metal sheets in your offhand to continue construction of the watchtower."))
                return FALSE

            if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
                return

            if(metal.use(10))
                to_chat(user, SPAN_NOTICE("You construct the watchtower platform."))
                stage = 4
                update_icon()
            else
                to_chat(user, SPAN_NOTICE("You failed to construct the watchtower platform, you need more metal sheets in your offhand."))

            return
        if(4)
            if(!HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
                return

            var/obj/item/stack/sheet/plasteel/plasteel = user.get_inactive_hand()
            if(!istype(plasteel))
                to_chat(user, SPAN_BOLDWARNING("You need plasteel sheets in your offhand to continue construction of the watchtower."))
                return FALSE

            if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
                return

            if(plasteel.use(10))
                to_chat(user, SPAN_NOTICE("You construct the watchtower railing."))
                stage = 5
                update_icon()
            else
                to_chat(user, SPAN_NOTICE("You failed to construct the watchtower railing, you need more plasteel sheets in your offhand."))

            return
        if(5)
            if (!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
                return

            var/obj/item/stack/rods/rods = user.get_inactive_hand()
            if(!istype(rods))
                to_chat(user, SPAN_BOLDWARNING("You need metal rods in your offhand to continue construction of the watchtower."))
                return FALSE

            if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
                return

            if(rods.use(10))
                to_chat(user, SPAN_NOTICE("You construct the watchtower support rods."))
                stage = 6
                update_icon()
            else
                to_chat(user, SPAN_NOTICE("You failed to construct the watchtower support rods, you need more metal rods in your offhand."))

            return
        if(6)
            if (!iswelder(W))
                return

            if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
                to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
                return

            var/obj/item/stack/sheet/plasteel/plasteel = user.get_inactive_hand()
            if(!istype(plasteel))
                to_chat(user, SPAN_BOLDWARNING("You need plasteel sheets in your offhand to continue construction of the watchtower."))
                return FALSE

            if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
                return

            if(plasteel.use(10))
                to_chat(user, SPAN_NOTICE("You complete the watchtower."))
                stage = 7
                update_icon()
                

            else
                to_chat(user, SPAN_NOTICE("You failed to complete the watchtower, you need more plasteel sheets in your offhand."))

            return

/obj/structure/watchtower/proc/complete()
    var/turf/above = (get_turf(src)).above()
    var/list/turf/turfs = CORNER_BLOCK(above, 2, 3)

    for(var/turf/current_turf in turfs)
        var/turf/below = current_turf.below()
        new below.type(current_turf)

    new /obj/structure/watchtower/fake(above)


/obj/structure/watchtower/attack_hand(mob/user)
    if(get_turf(user) == locate(x, y-1, z))
        if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
            return

        var/turf/actual_turf = locate(x, y+1, z)
        user.forceMove(actual_turf.above())
        user.client.view += 5
    else if(get_turf(user) == locate(x, y+1, z))
        if(!do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
            return

        var/turf/actual_turf = locate(x, y-1, z)
        user.forceMove(actual_turf.below())
        user.client.view -= 5

/obj/structure/watchtower/fake
    stage = 7
    icon_state = "stage7"

/obj/structure/watchtower/fake/Initialize()
    update_icon(roof=FALSE)
    return

/obj/structure/watchtower/complete
    stage = 7
    icon_state = "stage7"

/obj/structure/watchtower/complete/Initialize()
    . = ..()
    update_icon(roof=TRUE)
    complete()
