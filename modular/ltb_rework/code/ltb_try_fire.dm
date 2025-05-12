/obj/item/hardpoint/primary/cannon
    var/making_shot = 0

/obj/item/hardpoint/primary/cannon/try_fire(atom/target, mob/living/user, params)

    var/obj/item/hardpoint/support/artillery_module/module = owner.find_hardpoint("\improper Artillery Module")

    if(module && module.is_active && !making_shot && get_dist(owner, target) > 8)
        if(health <= 0)
            to_chat(user, SPAN_WARNING("<b>\The [name] is broken!</b>"))
            return NONE

        if(ammo && ammo.current_rounds <= 0)
            click_empty(user)
            return NONE

        if(!in_firing_arc(target))
            to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
            return NONE

        var/target_turf = get_turf(target)
        making_shot = TRUE

        var/datum/beam/laser_beam = owner.beam(target_turf, "laser_green", 'icons/effects/beam.dmi', 1 SECONDS, beam_type = /obj/effect/ebeam)
        laser_beam.visuals.alpha = 50

        var/obj/effect/overlay/temp/laser_coordinate/marker = new(target_turf, "laser_marker_green")
        spawn(10)
            qdel(marker)

        to_chat(user, SPAN_WARNING("Наводим орудие на цель"))
        playsound(owner,'modular/ltb_rework/sound/turret.ogg', 80, TRUE, 8)
        spawn(10)
            playsound(target_turf, 'modular/ltb_rework/sound/shell.ogg', 70, FALSE, 5)
        spawn(20)
            making_shot = FALSE
            handle_fire(target_turf, user, params)
        return NONE
    else if(!making_shot)
        return ..()
