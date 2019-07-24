

/obj/item/clothing/suit/bio/marine
	name = "marine hazardous materials suit"
	desc = "A suit worn by members of the biohazardous response and containment teams. Armoured and fire resistant."
	icon_state = "marine-hazmat"
	item_state = "haz-marine"
	icon = 'icons/mob/suit_0.dmi'
	w_class = SIZE_MEDIUM
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_ULTRAHIGH
	armor_internaldamage = CLOTHING_ARMOR_LOW
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer, /obj/item/weapon/gun/energy/laser, /obj/item/weapon/gun/energy/pulse_rifle, \
	/obj/item/weapon/gun/energy/taser, /obj/item/weapon/melee/baton, /obj/item/weapon/gun/energy/gun)
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/bio/marine
	name = "marine hazardous materials helmet and mask"
	desc = "A helmet worn by members of the biohazardous response and containment teams. Armoured and fire resistant."
	icon_state = "marine-hazmask"
	item_state = "haz_mask"
	icon = 'icons/mob/head.dmi'
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_ULTRAHIGH
	armor_internaldamage = CLOTHING_ARMOR_LOW
	siemens_coefficient = 0.6
