
/obj/item/clothing/suit/armor
	icon = 'icons/obj/items/clothing/suits/armor.dmi'
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	siemens_coefficient = 0.6
	w_class = SIZE_HUGE
	allowed = list(/obj/item/weapon/gun, /obj/item/storage/backpack/general_belt) //Guns only.
	uniform_restricted = list(/obj/item/clothing/under)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	slowdown = SLOWDOWN_ARMOR_LIGHT

	pickup_sound = "armorequip"
	drop_sound = "armorequip"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/armor.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)

/obj/item/clothing/suit/armor/mob_can_equip(mob/living/carbon/human/M, slot, disable_warning = 0)
	. = ..()
	if (.)
		if(issynth(M) && M.allow_gun_usage == FALSE)
			M.visible_message(SPAN_DANGER("Your programming prevents you from wearing this!"))
			return 0

//armored vest

/obj/item/clothing/suit/armor/vest
	name = "armored vest"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
	)

/obj/item/clothing/suit/armor/vest/dutch
	name = "armored jacket"
	desc = "It's hot in the jungle. Sometimes it's hot and heavy, and sometimes it's hell on earth."
	icon = 'icons/obj/items/clothing/suits/misc_ert.dmi'
	icon_state = "dutch_armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/dutch)

/obj/item/clothing/suit/armor/vest/security
	name = "Wey-Yu security armor"
	desc = "An armored vest that protects against some damage. This one has a Weyland-Yutani corporate badge."
	icon_state = "armorsec"
	item_state = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)

/obj/item/clothing/suit/armor/vest/warden
	name = "Warden's jacket"
	desc = "An armored jacket with silver rank pips and livery."
	icon_state = "warden_jacket"
	item_state = "armor"
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)

/obj/item/clothing/suit/armor/laserproof
	name = "Ablative Armor Vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM


/obj/item/clothing/suit/armor/bulletproof/badge
	icon_state = "bulletproofbadge"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)

/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	slowdown = 1
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ
	siemens_coefficient = 0.5
	time_to_unequip = 20
	time_to_equip = 20

/obj/item/clothing/suit/armor/gladiator
	name = "gladiator armor"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state = "gladiator"
	icon = 'icons/obj/items/clothing/suits/misc_ert.dmi'
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEJUMPSUIT
	siemens_coefficient = 0.5
	time_to_unequip = 20
	time_to_equip = 20
	allowed = list(
		/obj/item/weapon/sword,
		/obj/item/weapon/shield/riot,
		/obj/item/device/flashlight,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/misc_ert.dmi',
	)

/obj/item/clothing/suit/armor/riot/marine
	name = "\improper M5 riot control armor"
	desc = "A heavily modified suit of M2 MP Armor used to suppress riots from buckethead marines. Slows you down a lot."
	icon_state = "riot"
	item_state = "swat_suit"
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	time_to_unequip = 20
	time_to_equip = 20

/obj/item/clothing/suit/armor/riot/marine/vintage_riot
	desc = "Barring the slightly off-color plates, it's preserved quite well."
	icon_state = "old_riot"

/obj/item/clothing/suit/armor/swat
	name = "swat suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	icon = 'icons/obj/items/clothing/suits/donator.dmi'
	gas_transfer_coefficient = 0.01

	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/baton,/obj/item/restraint/handcuffs,/obj/item/tank/emergency_oxygen)
	slowdown = 1
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_inventory = BLOCKSHARPOBJ|NOPRESSUREDMAGE
	flags_inv_hide = HIDEGLOVES|HIDESHOES
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT
	siemens_coefficient = 0.6
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/donator.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)

/obj/item/clothing/suit/armor/swat/officer
	name = "officer jacket"
	desc = "An armored jacket used in special operations."
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)

/obj/item/clothing/suit/armor/det_suit
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)

/obj/item/clothing/suit/armor/hos
	name = "armored coat"
	desc = "A greatcoat enhanced with a special alloy for some protection and style."
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	icon_state = "hos"
	item_state = "hos"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEJUMPSUIT
	siemens_coefficient = 0.6
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)
