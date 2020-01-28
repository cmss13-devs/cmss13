/obj/item/clothing/suit/storage/jacket/marine
	name = "marine service jacket"
	desc = "A service jacket typically worn by officers of the USCM. It has shards of light Kevlar to help protect against stabbing weapons, bullets, and shrapnel from explosions, a small EMF distributor to help null energy-based weapons, and a hazmat chemical filter weave to ward off biological and radiation hazards."
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	icon_state = "coat_officer"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
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
	/obj/item/attachable/bayonet,
	/obj/item/storage/belt/gun/m4a3,
	/obj/item/storage/belt/gun/m44,
	/obj/item/storage/belt/gun/mateba,
	/obj/item/storage/belt/gun/smartpistol,)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/jacket/marine/New(loc)
	..()
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)

/obj/item/clothing/suit/storage/jacket/marine/dress
	name = "marine dress jacket"
	desc = "Smells like vanilla. Signifies prestige and power, if a little flashy."
	icon_state = "marine_formal"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/suit/storage/jacket/marine/dress/officer
	name = "marine officer dress jacket"
	icon_state = "co_jacket"
