/obj/item/device/multitool/antag
    hack_speed = SECONDS_1

#define SHOW_HACK_MESSAGE user.visible_message(SPAN_DANGER("[user] hacks [target]."), SPAN_NOTICE("You hack [target]."))

/obj/item/device/multitool/antag/afterattack(atom/target, mob/user, flag)
    if(!skillcheck(user, SKILL_ANTAG, SKILL_ANTAG_TRAINED))
        return . = ..()

    if(istype(target, /obj/structure/machinery/door/airlock))
        var/obj/structure/machinery/door/airlock/D = target

        if(!D.density || D.unacidable)
            return . = ..()

        user.visible_message(SPAN_DANGER("[user] begins to hack open [target]!"), SPAN_NOTICE("You start to hack open [target]."))

        if(!do_after(user, hack_speed, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target, INTERRUPT_ALL))
            to_chat(user, SPAN_WARNING("You decide not to hack [target]."))
            return
        
        user.visible_message(SPAN_DANGER("[user] hacks open [target]."), SPAN_NOTICE("You hack open [target]."))

        D.unlock()
        D.open()
    
    else if(istype(target, /obj/structure/machinery/door_control))
        var/obj/structure/machinery/door_control/D = target

        SHOW_HACK_MESSAGE
        D.attack_hand(user, TRUE)

    else if(istype(target, /obj/structure/machinery/power/apc))
        var/obj/structure/machinery/power/apc/A = target

        if(!A.locked)
            return
        
        SHOW_HACK_MESSAGE
        A.locked = FALSE
        A.update_icon()
    else
        . = ..()

#undef SHOW_HACK_MESSAGE