/obj/item/weapon/gun/boltaction/vulture
    var/iff_enabled = FALSE

/obj/item/weapon/gun/boltaction/vulture/Initialize(mapload, ...)
    . = ..()
    AddComponent(/datum/component/iff_fire_prevention)

/obj/item/weapon/gun/boltaction/vulture/set_gun_config_values()
    ..()
    bolt_delay = 35
    if(iff_enabled)
        damage_mult = 0.75
    else
        damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/boltaction/vulture/proc/toggle_iff_mode(mob/user, silent)
	to_chat(user, "[icon2html(src, user)] Вы [iff_enabled? "<B>выключили</b>" : "<B>включили</b>"] [src]'s ИФФ режим. Теперь вы [iff_enabled ? "можете стрелять в союзников" : "Не можете стрелять в союзников, и имеете сниженный урон"].")
	if(!silent)
		balloon_alert(user, "ИФФ режим [iff_enabled ? "выключен" : "включен"]")
		playsound(loc,'sound/machines/click.ogg', 25, 1)
	iff_enabled = !iff_enabled

	SEND_SIGNAL(src, COMSIG_GUN_ALT_IFF_TOGGLED, iff_enabled)
	recalculate_attachment_bonuses()
	set_gun_config_values()

/obj/item/attachable/stock/vulture
    desc = "Усиленный приклад для противотанковой винтовки M707 'Вультур', оснащённый встроенной системой переключения IFF для улучшенного управления наведением."
    flags_attach_features = ATTACH_ACTIVATION
    attachment_action_type = /datum/action/item_action/stock/vulture/stock_iff

/datum/action/item_action/stock/vulture/stock_iff
    name = "Toggle IFF Mode"
    action_icon_state = "frontline_toggle_on"
    listen_signal = COMSIG_KB_HUMAN_WEAPON_TOGGLE_FRONTLINE_MODE

/datum/action/item_action/stock/vulture/stock_iff/New(Target, obj/item/holder)
    . = ..()
    button.name = name
    button.overlays.Cut()
    button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/stock/vulture/stock_iff/action_activate()
    . = ..()
    var/obj/item/weapon/gun/boltaction/vulture/gun = holder_item
    if(istype(gun))
        gun.toggle_iff_mode(owner)
        action_icon_state = gun.iff_enabled ? "frontline_toggle_off" : "frontline_toggle_on"
        button.overlays.Cut()
        button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)
