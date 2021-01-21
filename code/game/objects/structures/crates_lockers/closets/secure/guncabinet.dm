/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access = null
	health = 1000
	icon = 'icons/obj/structures/props/misc.dmi'
	icon_state = "base"
	icon_off ="base"
	icon_broken ="base"
	icon_locked ="base"
	icon_closed ="base"
	icon_opened = "base"
	req_access = list(ACCESS_MARINE_WO) //Trusting the CMP to be able to open the lockers on any alert level, just in case
	var/req_level = SEC_LEVEL_GREEN

/obj/structure/closet/secure_closet/guncabinet/examine()
	..()
	to_chat(usr, SPAN_NOTICE("[src] will only open on [num2seclevel(req_level)] security level."))

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	. = ..()
	GLOB.gun_cabinets += src
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/Destroy()
	GLOB.gun_cabinets -= src
	return ..()

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
/obj/structure/closet/secure_closet/guncabinet/bullet_act(var/obj/item/projectile/Proj)
	return 1

/obj/structure/closet/secure_closet/guncabinet/ex_act(severity)
	if(severity > EXPLOSION_THRESHOLD_MEDIUM)
		for(var/atom/movable/A in contents)//pulls everything out of the locker and hits it with an explosion
			A.forceMove(loc)
			A.ex_act(severity - EXPLOSION_THRESHOLD_LOW)
		qdel(src)

/obj/structure/closet/secure_closet/guncabinet/proc/check_sec_level(var/alert)
	if(alert < req_level)
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

/obj/structure/closet/secure_closet/guncabinet/mp_armory
//	req_access = list(ACCESS_MARINE_BRIG)
	req_level = SEC_LEVEL_RED

/obj/structure/closet/secure_closet/guncabinet/mp_armory/Initialize()
	. = ..()
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/ammo_magazine/shotgun/slugs(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)



/obj/structure/closet/secure_closet/guncabinet/riot_control
	name = "riot control equipment closet"
//	req_access = list(ACCESS_MARINE_BRIG)
	storage_capacity = 55 //lots of stuff to fit in
	req_level = SEC_LEVEL_RED

/obj/structure/closet/secure_closet/guncabinet/riot_control/Initialize()
	. = ..()
	new /obj/item/weapon/gun/shotgun/pump(src, TRUE)
	new /obj/item/weapon/gun/shotgun/pump(src, TRUE)
	new /obj/item/weapon/gun/shotgun/pump(src, TRUE)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/ammo_magazine/shotgun/beanbag(src)
	new /obj/item/ammo_magazine/shotgun/beanbag(src)
	new /obj/item/ammo_magazine/shotgun/beanbag(src)
	new /obj/item/ammo_magazine/shotgun/beanbag(src)
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(src, TRUE)
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

/obj/structure/closet/secure_closet/guncabinet/blue
	name = "blue level gun cabinet"
	req_level = SEC_LEVEL_BLUE

/obj/structure/closet/secure_closet/guncabinet/red
	name = "red level gun cabinet"
	req_level = SEC_LEVEL_RED

/obj/structure/closet/secure_closet/guncabinet/delta
	name = "delta level gun cabinet"
	req_level = SEC_LEVEL_DELTA
