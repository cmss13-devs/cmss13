//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	item_state = "capspacehelmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	permeability_coefficient = 0.01
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH

//Captain's space suit This is not the proper path but I don't currently know enough about how this all works to mess with it.
/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive Weyland-Yutani armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	w_class = SIZE_LARGE
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun, /obj/item/ammo_magazine, /obj/item/weapon/baton,/obj/item/restraint/handcuffs)
	slowdown = 1.5
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = NOPRESSUREDMAGE
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT
	siemens_coefficient = 0.7
