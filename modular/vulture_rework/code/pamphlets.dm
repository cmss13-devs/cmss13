#define VULTURE_MAP_ICONS 'modular/vulture_rework/icons/vulture_map.dmi'
#define VULTURE_HUD_ICONS 'modular/vulture_rework/icons/vulture_hud.dmi'

/mob/living/carbon/human/hud_set_squad()
    ..()
    var/datum/faction/F = get_faction(faction)
    if(!F)
        F = get_faction("Marine")
    var/image/holder = hud_list[F.hud_type]
    if(rank_fallback == "vulture")
        var/image/vulture_icon = image(VULTURE_HUD_ICONS, src, "hudsquad_vulture")
        holder.overlays += vulture_icon

/obj/item/pamphlet/trait/can_use(mob/living/carbon/human/user)
    if(user.job != JOB_SQUAD_MARINE)
        to_chat(user, SPAN_WARNING("Это может использовать только стрелок отряда."))
        return FALSE

    var/obj/item/card/id/ID = user.get_idcard()
    if(!ID) //not wearing an ID
        to_chat(user, SPAN_WARNING("Перед тем как это использовать, вы должны надеть ваш ID."))
        return FALSE
    if(!ID.check_biometrics(user))
        to_chat(user, SPAN_WARNING("Перед тем как это использовать, вы должны надеть ваш ID."))
        return FALSE
    var/obj/item/device/radio/headset/headset = user.get_type_in_ears(/obj/item/device/radio/headset)
    if(!headset)
        to_chat(user, SPAN_WARNING("Перед тем как это использовать, вы должны надеть ваш наушник."))
        return FALSE

    return ..()

/obj/item/pamphlet/trait/vulture/on_use(mob/living/carbon/human/user)
    . = ..()
    user.rank_fallback = "vulture"
    user.hud_set_squad()

    var/obj/item/card/id/ID = user.get_idcard()
    ID.set_assignment("Оператор ПТО" + " " + (user.assigned_squad ? (user.assigned_squad.get_name_ru()) : ""))
    ID.minimap_icon_override = "vulture"

    var/obj/item/device/radio/headset/headset = user.get_type_in_ears(/obj/item/device/radio/headset)
    if(headset)
        headset.minimap_path_blips_override = VULTURE_MAP_ICONS // --- Предложение так решить проблему  (рабочее, пупс лучший)
        user.update_minimap_icon()

    GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), "Оператор ПТО")

#undef VULTURE_MAP_ICONS
#undef VULTURE_HUD_ICONS
