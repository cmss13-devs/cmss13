/datum/action/xeno_action/activable/predalien_roar/use_ability(atom/A)
    var/mob/living/carbon/Xenomorph/X = owner

    if (!action_cooldown_check())
        return

    if (!X.check_state())
        return
    
    if(!check_and_use_plasma_owner())
        return
    
    playsound(X.loc, screech_sound_effect, 75, 0, status = 0)
    X.visible_message(SPAN_XENOHIGHDANGER("[X] emits a guttural roar!"))
    X.create_shriekwave()

    for(var/mob/living/carbon/human/H in oview(7, X))
        H.disable_special_items()

        var/obj/item/clothing/gloves/yautja/YG = locate(/obj/item/clothing/gloves/yautja) in H
        if(isYautja(H) && YG)
            if(YG.cloaked)
                YG.decloak(H)

            YG.cloak_timer = 6

    for(var/mob/M in view(M))
        if(M && M.client)
            shake_camera(M, 10, 1)
    
    apply_cooldown()

    . = ..()
    return

/datum/action/xeno_action/activable/pounce/predalien/additional_effects(mob/living/L)
    var/mob/living/carbon/Xenomorph/X = owner

    if(!istype(X))
        return

    if(isYautja(L))
        new /datum/effects/xeno_slow(L, X, ttl = yautja_slowdown_time)
        to_chat(L, SPAN_XENOHIGHDANGER("You are slowed as [X] knocks you off balance!"))

        L.KnockDown(yautja_knockdown_time)
    else
        L.KnockDown(knockdown_duration)

    . = ..()