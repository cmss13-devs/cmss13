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

// --- Данный прок более не существует, а иконки надо как-то обновлять.
// Был переработан из-за ПРа https://github.com/cmss13-devs/cmss13/pull/8963

// /datum/equipment_preset/get_minimap_icon(mob/living/carbon/human/user)
//     var/image/final_icon = ..()

//     var/obj/item/card/id/ID = user.get_idcard()
//     if(ID.minimap_icon_override == "vulture")
//         var/mutable_appearance/icon = image(VULTURE_MAP_ICONS, "vulture")
//         icon.appearance_flags = RESET_COLOR
//         final_icon.overlays += icon

//     return final_icon

// ---------------------
// Предложение как пофиксить.
/*
Залезть в прок /obj/item/device/radio/headset/proc/update_minimap_icon()
по пути code/game/objects/items/devices/radio/headset.dm

Добавить туда:
	if(wearer.assigned_squad)
		var/image/underlay = image(minimap_path_blips, null, "squad_underlay")
		var/image/overlay = image(minimap_path_blips, null, icon_to_use)
		// SS220 EDIT - START --- минимап блипы тоже от нас
		if(minimap_path_blips_override)
			overlay = image(minimap_path_blips_override, null, icon_to_use)
		else
			overlay = image(minimap_path_blips, null, icon_to_use)
		// SS220 EDIT - END
		background.overlays += underlay
		background.overlays += overlay

А в переменные радиосета:
	var/minimap_path_blips = 'icons/ui_icons/map_blips.dmi' // SS220 ADD
	var/minimap_path_blips_override // SS220 ADD

Почему сам не сделал?
Нет времени оттестировать и отдебажить, возможно этот метод и вовсе нерабочий будет.
Плюс стоит такое изменение еще и на оффы закинуть, чтобы всё было не хардкодом, а через переменную.

*/
// ---------------------


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
		headset.minimap_path_blips_override = VULTURE_MAP_ICONS // --- Предложение так решить проблему
        headset.update_minimap_icon()

    GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), "Оператор ПТО")

#undef VULTURE_MAP_ICONS
#undef VULTURE_HUD_ICONS
