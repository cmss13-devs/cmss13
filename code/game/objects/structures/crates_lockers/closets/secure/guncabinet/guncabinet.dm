/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access = null
	health = 1000
	icon = 'icons/obj/structures/props/furniture/misc.dmi'
	icon_state = "base"
	icon_off ="base"
	icon_broken ="base"
	icon_locked ="base"
	icon_closed ="base"
	icon_opened = "base"
	req_access = list(ACCESS_MARINE_ARMORY)
	var/req_level = SEC_LEVEL_GREEN

/obj/structure/closet/secure_closet/guncabinet/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("[src] will only open on [num2seclevel(req_level)] security level.")

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	. = ..()
	update_icon()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_SECURITY_LEVEL_CHANGED, PROC_REF(sec_changed))

/obj/structure/closet/secure_closet/guncabinet/proc/sec_changed(datum/source, new_sec)
	SIGNAL_HANDLER
	if(new_sec < req_level)
		if(locked)
			return
		for(var/mob/living/L in contents)
			L.forceMove(loc)
			to_chat(L, SPAN_WARNING("You are forced out of [src]!"))
		if(!locked)
			locked = TRUE
	else
		if(locked)
			locked = FALSE
	visible_message(SPAN_NOTICE("[src] [locked ? "locks" : "unlocks"] itself."), null, null, 3)
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	overlays.Cut()
	if(opened)
		overlays += icon(icon,"door_open")
	else
		overlays += icon(src.icon,"door")

		if(broken)
			overlays += icon(src.icon,"broken")
		else if (locked)
			overlays += icon(src.icon,"locked")
		else
			overlays += icon(src.icon,"open")

//immune to bullets
/obj/structure/closet/secure_closet/guncabinet/bullet_act(obj/projectile/Proj)
	return 1

/obj/structure/closet/secure_closet/guncabinet/ex_act(severity)
	if(severity > EXPLOSION_THRESHOLD_MEDIUM)
		contents_explosion(severity - EXPLOSION_THRESHOLD_LOW)
		deconstruct(FALSE)

//this is used on corsat.(leaving it as a prop i guess)
/obj/structure/closet/secure_closet/guncabinet/riot_control
	name = "riot control equipment closet"
// req_access = list(ACCESS_MARINE_BRIG)
	storage_capacity = 55 //lots of stuff to fit in
	req_level = SEC_LEVEL_BLUE

/obj/structure/closet/secure_closet/guncabinet/riot_control/Initialize()
	. = ..()
	new /obj/item/weapon/gun/shotgun/combat/riot(src, TRUE)
	new /obj/item/weapon/gun/shotgun/combat/riot(src, TRUE)
	new /obj/item/weapon/gun/shotgun/combat/riot(src, TRUE)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/ammo_magazine/shotgun/beanbag/riot(src)
	new /obj/item/ammo_magazine/shotgun/beanbag/riot(src)
	new /obj/item/ammo_magazine/shotgun/beanbag/riot(src)
	new /obj/item/ammo_magazine/shotgun/beanbag/riot(src)
	new /obj/item/weapon/gun/launcher/grenade/m84(src, TRUE)
	new /obj/item/storage/box/nade_box/tear_gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/head/helmet/riot(src)
	new /obj/item/clothing/head/helmet/riot(src)
	new /obj/item/clothing/head/helmet/riot(src)
	new /obj/item/clothing/suit/armor/riot/marine(src)
	new /obj/item/clothing/suit/armor/riot/marine(src)
	new /obj/item/clothing/suit/armor/riot/marine(src)
	new /obj/item/storage/box/flashbangs(src)

/obj/structure/closet/secure_closet/guncabinet/green
	name = "green level gun cabinet"
	req_level = SEC_LEVEL_GREEN

/obj/structure/closet/secure_closet/guncabinet/red
	name = "red level gun cabinet"
	req_level = SEC_LEVEL_RED

/obj/structure/closet/secure_closet/guncabinet/delta
	name = "delta level gun cabinet"
	req_level = SEC_LEVEL_DELTA

/obj/structure/closet/secure_closet/guncabinet/wy
	name = "weyland yutani gun cabinet"
	req_access = ACCESS_WY_SECURITY
