/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid
	name = "\improper M7X Apesuit"
	desc = "The Latest in the line of Apesuits from Weyland Yutani, designed for use by combat droids, it's more compact and mobile then the original allowing for more mobility."
	icon_state = "combat_android_jacket"
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_VERY_HEAVY
	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_marine_armor = null
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc/combat_android)
	actions_types = null
	item_state_slots = list(WEAR_JACKET = "combat_android_jacket")
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/veteran/pmc/wy_droid/dark
	name = "\improper M7X Mark II Apesuit"
	desc = "The M7X Mark II Apesuit: Following recent archaeological studies on highly classified sites, W-Y's R and D Department managed to reverse engineer a more compact invisibility cloak for this armour from some their discoveries"
	icon_state = "invis_android_jacket"
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc/combat_android/dark)
	item_state_slots = list(WEAR_JACKET = "invis_android_jacket")
