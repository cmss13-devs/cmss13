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
    X.create_shriekwave(color = "#FF0000")

    for(var/mob/living/carbon/C in view(7, X))
        if(ishuman(C))
            var/mob/living/carbon/human/H = C
            H.disable_special_items()

            var/obj/item/clothing/gloves/yautja/YG = locate(/obj/item/clothing/gloves/yautja) in H
            if(isYautja(H) && YG)
                if(YG.cloaked)
                    YG.decloak(H)

                YG.cloak_timer = xeno_cooldown * 0.1
        else if(isXeno(C) && X.can_not_harm(C))
            var/datum/behavior_delegate/predalien_base/P = X.behavior_delegate
            if(!istype(P))
                continue
            new /datum/effects/xeno_buff(C, X, ttl = (0.25 SECONDS * P.kills + 3 SECONDS), bonus_damage = bonus_damage_scale * P.kills, bonus_speed = (bonus_speed_scale * P.kills))


    for(var/mob/M in view(X))
        if(M && M.client)
            shake_camera(M, 10, 1)

    apply_cooldown()

    . = ..()
    return

/datum/action/xeno_action/activable/smash/use_ability(atom/A)
    var/mob/living/carbon/Xenomorph/X = owner

    if (!action_cooldown_check())
        return

    if (!X.check_state())
        return

    var/datum/behavior_delegate/predalien_base/P = X.behavior_delegate
    if(!istype(P))
        return

    if(!check_plasma_owner())
        return

    if(!do_after(X, activation_delay, INTERRUPT_ALL, BUSY_ICON_GENERIC))
        to_chat(X, "Keep still whilst trying to smash into the ground")

        var/real_cooldown = xeno_cooldown

        xeno_cooldown = 3 SECONDS
        apply_cooldown()
        xeno_cooldown = real_cooldown
        return

    if(!check_and_use_plasma_owner())
        return

    playsound(X.loc, pick(smash_sounds), 50, 0, status = 0)
    X.visible_message(SPAN_XENOHIGHDANGER("[X] smashes into the ground!"))

    X.create_stomp()

    for(var/mob/living/carbon/C in oview(round(P.kills * 0.5 + 2), X))
        if(!X.can_not_harm(C) && C.stat != DEAD)
            C.frozen = 1
            C.update_canmove()

            if (ishuman(C))
                var/mob/living/carbon/human/H = C
                H.update_xeno_hostile_hud()

            addtimer(CALLBACK(GLOBAL_PROC, .proc/unroot_human, C), get_xeno_stun_duration(C, freeze_duration))


    for(var/mob/M in view(X))
        if(M && M.client)
            shake_camera(M, 0.2 SECONDS, 1)

    apply_cooldown()

    . = ..()
    return

/datum/action/xeno_action/activable/devastate/use_ability(atom/A)
    var/mob/living/carbon/Xenomorph/X = owner

    if (!action_cooldown_check())
        return

    if (!X.check_state())
        return

    if (!isXenoOrHuman(A) || X.can_not_harm(A))
        to_chat(X, SPAN_XENOWARNING("You must target a hostile!"))
        return

    if (get_dist_sqrd(A, X) > 2)
        to_chat(X, SPAN_XENOWARNING("[A] is too far away!"))
        return

    var/mob/living/carbon/H = A

    if (H.stat == DEAD)
        to_chat(X, SPAN_XENOWARNING("[H] is dead, why would you want to touch them?"))
        return

    var/datum/behavior_delegate/predalien_base/P = X.behavior_delegate
    if(!istype(P))
        return

    if (!check_and_use_plasma_owner())
        return

    H.frozen = 1
    H.update_canmove()

    if (ishuman(H))
        var/mob/living/carbon/human/Hu = H
        Hu.update_xeno_hostile_hud()

    apply_cooldown()

    X.frozen = 1
    X.anchored = 1
    X.update_canmove()

    if (do_after(X, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
        X.emote("roar")
        X.visible_message(SPAN_XENOHIGHDANGER("[X] rips open the guts of [H]!"), SPAN_XENOHIGHDANGER("You rip open the guts of [H]!"))
        H.spawn_gibs()
        playsound(get_turf(H), 'sound/effects/gibbed.ogg', 30, 1)
        H.KnockDown(get_xeno_stun_duration(H, 0.5))
        H.apply_armoured_damage(get_xeno_damage_slash(H, base_damage + damage_scale * P.kills), ARMOR_MELEE, BRUTE, "chest", 20)

        X.animation_attack_on(H)
        X.flick_attack_overlay(H, "slash")

    X.frozen = 0
    X.anchored = 0
    X.update_canmove()

    unroot_human(H)

    X.visible_message(SPAN_XENODANGER("[X] rapidly slices into [H]!"))

    . = ..()
    return
