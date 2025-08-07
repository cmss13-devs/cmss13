/obj/item/clothing/suit/storage/marine/veteran/pmc
	name = "\improper M4 pattern PMC armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind."
	icon_state = "pmc_armor"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/WY.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/WY.dmi'
	)
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/tool/crowbar,
		/obj/item/storage/large_holster/katana,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/sword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/tool/crew_monitor,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc)
	item_state_slots = list(WEAR_JACKET = "pmc_armor")
	lamp_icon = "pmc_lamp"
	light_color = LIGHT_COLOR_FLARE
	lamp_light_color = LIGHT_COLOR_FLARE

/obj/item/clothing/suit/storage/marine/veteran/pmc/no_lamp
	flags_marine_armor = null
	actions_types = null

/obj/item/clothing/suit/storage/marine/veteran/pmc/guard
	name = "\improper M4 pattern PMC guard armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. This one belongs to high profile elite guard within the W-Y PMC."
	icon_state = "guard_armor"
	item_state_slots = list(WEAR_JACKET = "guard_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/guard/heavy
	name = "\improper M4 pattern PMC riot guard armor"
	icon_state = "guard_armor_spec"
	item_state_slots = list(WEAR_JACKET = "guard_armor_spec")
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/marine/veteran/pmc/guard/vest
	name = "\improper M4 pattern PMC guard bulletproof armor"
	icon_state = "guard_vest"
	item_state_slots = list(WEAR_JACKET = "guard_vest")
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/marine/veteran/pmc/engineer
	name = "\improper M4 pattern engineer PMC armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high elemental protection, like shock, fire and fragments, lacks in terms of kevlar for bullet protection."
	icon_state = "pmc_engineer_armor"
	item_state_slots = list(WEAR_JACKET = "pmc_engineer_armor")
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_marine_armor = null
	actions_types = null

/obj/item/clothing/suit/storage/marine/veteran/pmc/light
	name = "\improper M4 pattern light PMC armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. Has some armor plating removed for extra mobility."
	icon_state = "pmc_armor_light"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	item_state_slots = list(WEAR_JACKET = "pmc_armor_light")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/bulletproof
	name = "\improper M4 pattern PMC bulletproof armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. Has some armor plating removed for extra mobility."
	icon_state = "pmc_vest"
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	slowdown = SLOWDOWN_ARMOR_SUPER_LIGHT
	item_state_slots = list(WEAR_JACKET = "pmc_vest")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/bulletproof/guard
	name = "\improper M4 pattern PMC guard bulletproof armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. This one belongs to high profile elite guard within the W-Y PMC."
	icon_state = "guard_vest"
	item_state_slots = list(WEAR_JACKET = "guard_vest")

/obj/item/clothing/suit/storage/marine/veteran/pmc/leader
	name = "\improper M4 pattern PMC leader armor"
	desc = "A modification of the standard Armat Systems M3 armor. Designed for high-profile security operators and corporate mercenaries in mind. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_armor"
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc/leader)
	item_state_slots = list(WEAR_JACKET = "officer_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/leader/guard
	name = "\improper M4 pattern PMC guard leader armor"
	icon_state = "guard_armor_officer"
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/pmc)
	item_state_slots = list(WEAR_JACKET = "guard_armor_officer")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth
	name = "\improper M4 Synthetic PMC armor"
	desc = "A serious modification of the standard Armat Systems M3 armor. This variant was designed for PMC Support Units in the field, with every armor insert removed. It's designed with the idea of a high speed lifesaver in mind."
	icon_state = "pmc_vest"
	item_state_slots = list(WEAR_JACKET = "pmc_vest")
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	storage_slots = 3
	slowdown = SLOWDOWN_ARMOR_SUPER_LIGHT

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth/Initialize()
	flags_atom |= NO_NAME_OVERRIDE
	flags_marine_armor |= SYNTH_ALLOWED
	return ..()

/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc
	name = "\improper M4 pattern PMC gunner armor"
	desc = "A modification of the standard Armat Systems M3 armor. Hooked up with harnesses and straps allowing the user to carry an M56 Smartgun."
	icon_state = "heavy_armor"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/WY.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/WY.dmi'
	)
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN|SMARTGUN_HARNESS
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	item_state_slots = list(WEAR_JACKET = "heavy_armor")
	flags_marine_armor = null
	actions_types = null
