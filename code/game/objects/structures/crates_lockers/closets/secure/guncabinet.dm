/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access_txt = "0"
	health = 1000 //bullet_act says that if the health is above 999, it won't act, so
	icon = 'icons/obj/structures/misc.dmi'
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
	usr << "<span class='notice'>[src] will only open on [num2seclevel(req_level)] security level.</span>"

/obj/structure/closet/secure_closet/guncabinet/New()
	..()
	gun_cabinets += src
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/Dispose()
	gun_cabinets -= src
	..()

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

/obj/structure/closet/secure_closet/guncabinet/proc/check_sec_level(var/alert)
	if(alert != req_level && alert < req_level)
		for(var/mob/living/L in contents)
			L.loc = src.loc
			L << "<span class='warning'>You are forced out of [src]!</span>"
		if(!locked)
			locked = 1
	else
		if(locked)
			locked = 0
	for(var/mob/O in viewers(src, 3))
		if((O.client && !( O.blinded )))
			O << "<span class='notice'>[src] [locked ? "locks" : "unlocks"] itself.</span>"
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/mp_armory
//	req_access = list(ACCESS_MARINE_BRIG)
	req_level = SEC_LEVEL_RED

/obj/structure/closet/secure_closet/guncabinet/mp_armory/New()
	..()
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/ammo_magazine/shotgun(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)



/obj/structure/closet/secure_closet/guncabinet/riot_control
	name = "riot control equipment closet"
//	req_access = list(ACCESS_MARINE_BRIG)
	storage_capacity = 55 //lots of stuff to fit in
	req_level = SEC_LEVEL_RED

/obj/structure/closet/secure_closet/guncabinet/riot_control/New()
	..()
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
	new /obj/item/weapon/gun/launcher/m81/riot(src, TRUE)
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
