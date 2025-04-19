/obj/item/clothing/suit/storage/marine/veteran/pmc/commando
	name = "\improper MY7 pattern Commando armor"
	desc = "A modification of the W-Y PMC armor patterns. Designed for elite corporate mercenaries in mind."
	icon_state = "commando_armor"
	item_state_slots = list(WEAR_JACKET = "commando_armor")
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	storage_slots = 4
	flags_marine_armor = null
	actions_types = null

/obj/item/clothing/suit/storage/marine/veteran/pmc/commando/damaged //survivor variant
	name = "damaged MY7 pattern Commando armor"
	desc = "A modification of the W-Y PMC armor patterns. Designed for elite corporate mercenaries in mind. This one has a lot of scratches and acid damage."
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	storage_slots = 3

/obj/item/clothing/suit/storage/marine/veteran/pmc/commando/leader
	name = "\improper MY7 pattern Commando leader armor"
	desc = "A modification of the W-Y PMC armor patterns. Designed for elite corporate mercenaries in mind. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "commando_armor_leader"
	item_state_slots = list(WEAR_JACKET = "commando_armor_leader")

/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc/commando
	name = "\improper MY7 pattern Commando gunner armor"
	desc = "A modification of the standard Armat Systems M3 armor. Hooked up with harnesses and straps allowing the user to carry an M56 Smartgun."
	icon_state = "commando_armor_sg"
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN|SMARTGUN_HARNESS
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	storage_slots = 4
	item_state_slots = list(WEAR_JACKET = "commando_armor_sg")

/obj/item/clothing/suit/storage/marine/veteran/pmc/apesuit
	name = "\improper M5X Apesuit"
	desc = "A complex system of overlapping plates intended to render the wearer all but impervious to small arms fire. A passive exoskeleton supports the weight of the armor, allowing a human to carry its massive bulk."
	icon_state = "ape_suit"
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_VERY_HEAVY
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc/apesuit)
	item_state_slots = list(WEAR_JACKET = "ape_suit")
	unacidable = TRUE
	flags_marine_armor = null
	actions_types = null
