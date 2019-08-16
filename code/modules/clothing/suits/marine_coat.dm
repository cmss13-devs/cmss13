/obj/item/clothing/suit/storage/co_jacket
	name = "Formal dress jacket."
	desc = "Smells like vanilla. Signifies prestige and power, if a little flashy. Light kevlar is sown into the fabric, along with other forms of basic protection. It has some hooks to allow pistol rigs to attach."
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	icon_state = "co_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = UPPER_TORSO|ARMS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	allowed = list(/obj/item/weapon/gun/,
	/obj/item/tank/emergency_oxygen,
	/obj/item/device/flashlight,
	/obj/item/storage/fancy/cigarettes,
	/obj/item/tool/lighter,
	/obj/item/weapon/baton,
	/obj/item/handcuffs,
	/obj/item/device/binoculars,
	/obj/item/weapon/combat_knife,
	/obj/item/storage/belt/gun/m4a3,
	/obj/item/storage/belt/gun/m44,
	/obj/item/storage/belt/gun/mateba,
	/obj/item/storage/belt/gun/smartpistol,)