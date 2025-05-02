//=============================//Marine Raiders\\==================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/sof
	name = "\improper SOF Armor"
	desc = "A heavily customized suit of M3 armor. Used by Marine Raiders."
	icon_state = "marsoc"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	unacidable = TRUE
	flags_atom = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE|NO_GAMEMODE_SKIN
	storage_slots = 4


//=============================//GENERIC FACTIONAL ARMOR ITEM\\==================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE //Let's make these keep their name and icon.

//===========================//DISTRESS\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/bear
	name = "\improper H1 Iron Bears vest"
	desc = "A protective vest worn by Iron Bears mercenaries."
	icon_state = "bear_armor"
	icon = 'icons/obj/items/clothing/suits/misc_ert.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/misc_ert.dmi',
	)
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/bear)

/obj/item/clothing/suit/storage/marine/veteran/dutch
	name = "\improper D2 armored vest"
	desc = "A protective vest worn by some seriously experienced mercs."
	icon_state = "dutch_armor"
	icon = 'icons/obj/items/clothing/suits/misc_ert.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/misc_ert.dmi',
	)
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS //Makes no sense but they need leg/arm armor too.
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	light_range = 7
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/dutch)

/obj/item/clothing/suit/storage/marine/veteran/van_bandolier
	name = "safari jacket"
	desc = "A tailored hunting jacket, cunningly lined with segmented armor plates. Sometimes the game shoots back."
	icon_state = "van_bandolier"
	item_state = "van_bandolier_jacket"
	icon = 'icons/obj/items/clothing/suits/jackets.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/jackets.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)
	blood_overlay_type = "coat"
	flags_marine_armor = NO_FLAGS //No shoulder light.
	actions_types = list()
	slowdown = SLOWDOWN_ARMOR_LIGHT
	storage_slots = 2
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/van_bandolier)
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/shotgun/van_bandolier,
	)

//===========================//U.P.P\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/faction
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT


/obj/item/clothing/suit/storage/marine/faction/UPP
	name = "\improper UM5 personal armor"
	desc = "Standard body armor of the UPP military, the UM5 (Union Medium MK5) is a medium body armor, roughly on par with the M3 pattern body armor in service with the USCM, specialized towards ballistics protection. Unlike the M3, however, the plate has a heavier neckplate. This has earned many UA members to refer to UPP soldiers as 'tin men'."
	icon_state = "upp_armor"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UPP.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UPP.dmi'
	)
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	storage_slots = 1
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP, /obj/item/clothing/under/marine/veteran/UPP/medic, /obj/item/clothing/under/marine/veteran/UPP/engi)

/obj/item/clothing/suit/storage/marine/faction/UPP/support
	name = "\improper UL6 personal armor"
	desc = "Standard body armor of the UPP military, the UL6 (Union Light MK6) is a light body armor, slightly weaker than the M3 pattern body armor in service with the USCM, specialized towards ballistics protection. This set of personal armor lacks the iconic neck piece and some of the armor in favor of user mobility."
	storage_slots = 3
	icon_state = "upp_armor_support"
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH

/obj/item/clothing/suit/storage/marine/faction/UPP/support/synth
	name = "\improper UL6 Synthetic personal armor"
	desc = "Modified variant of the UL6 personel armor system intended to be useable by Synthetic units. Offers no protection but very little movement impairment."
	flags_marine_armor = ARMOR_LAMP_OVERLAY|SYNTH_ALLOWED
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS

/obj/item/clothing/suit/storage/marine/faction/UPP/commando
	name = "\improper UM5CU personal armor"
	desc = "A modification of the UM5, designed for stealth operations."
	icon_state = "upp_armor_commando"
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT

/obj/item/clothing/suit/storage/marine/faction/UPP/heavy
	name = "\improper UH7 heavy plated armor"
	desc = "An extremely heavy-duty set of body armor in service with the UPP military, the UH7 (Union Heavy MK7) is known for having powerful ballistic protection, alongside a noticeable neck guard, fortified in order to allow the wearer to endure the stresses of the bulky helmet."
	icon_state = "upp_armor_heavy"
	storage_slots = 3
	slowdown = SLOWDOWN_ARMOR_HEAVY
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_ALL_BUT_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS

/obj/item/clothing/suit/storage/marine/faction/UPP/heavy/Initialize()
	. = ..()
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/minigun,
		/obj/item/ammo_magazine/pkp,
		)

/obj/item/clothing/suit/storage/marine/faction/UPP/officer
	name = "\improper UL4 officer jacket"
	desc = "A lightweight jacket, issued to officers of the UPP's military. Slightly protective from incoming damage, best off with proper armor however."
	icon_state = "upp_coat_officer"
	slowdown = SLOWDOWN_ARMOR_NONE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_LOW //wear actual armor if you go into combat
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 3
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP/officer)

/obj/item/clothing/suit/storage/marine/faction/UPP/kapitan
	name = "\improper UL4 senior officer jacket"
	desc = "A lightweight jacket, issued to senior officers of the UPP's military. Made of high-quality materials, even going as far as having the ranks and insignia of the Kapitan and their Company emblazoned on the shoulders and front of the jacket. Slightly protective from incoming damage, best off with proper armor however."
	icon_state = "upp_coat_kapitan"
	slowdown = SLOWDOWN_ARMOR_NONE
	armor_melee = CLOTHING_ARMOR_LOW //wear actual armor if you go into combat
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	storage_slots = 4
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP/officer)

/obj/item/clothing/suit/storage/marine/faction/UPP/mp
	name = "\improper UL4 camouflaged jacket"
	desc = "A lightweight jacket, issued to troops when they're not expected to engage in combat. Still studded to the brim with kevlar shards, though the synthread construction reduces its effectiveness."
	icon_state = "upp_coat_mp"
	slowdown = SLOWDOWN_ARMOR_NONE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_LOW //wear actual armor if you go into combat
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 4
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/UPP)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/marine/faction/UPP/jacket/ivan
	name = "\improper UH4 Camo Jacket"
	desc = "An experimental heavily armored variant of the UL4 given to only the most elite units... usually."
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_HANDS|BODY_FLAG_FEET
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	storage_slots = 2


//===========================//FREELANCER\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/faction/freelancer
	name = "freelancer cuirass"
	desc = "An armored protective chestplate scrapped together from various plates. It keeps up remarkably well, as the craftsmanship is solid, and the design mirrors such armors in the UPP and the USCM. The many skilled craftsmen in the freelancers ranks produce these vests at a rate about one a month."
	icon_state = "freelancer_armor"
	icon = 'icons/obj/items/clothing/suits/misc_ert.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/misc_ert.dmi',
	)
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	storage_slots = 2
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/freelancer)

//this one is for CLF
/obj/item/clothing/suit/storage/militia
	name = "colonial militia hauberk"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops."
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/CLF.dmi'
	icon_state = "rebel_armor"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/CLF.dmi'
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	uniform_restricted = list(/obj/item/clothing/under/colonist)
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/militia/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/militia/vest
	name = "colonial militia vest"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops. This extremely light variant protects only the chest and abdomen."
	icon_state = "clf_2"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	slowdown = 0.2
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/militia/brace
	name = "colonial militia brace"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops. This extremely light variant has some of the chest pieces removed."
	icon_state = "clf_3"
	flags_armor_protection = BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	slowdown = 0.2
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/militia/partial
	name = "colonial militia partial hauberk"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops. This even lighter variant has some of the arm pieces removed."
	icon_state = "clf_4"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	slowdown = 0.2

/obj/item/clothing/suit/storage/militia/smartgun
	name = "colonial militia harness"
	desc = "The hauberk of a colonist militia member, created from boiled leather and some modern armored plates. While not the most powerful form of armor, and primitive compared to most modern suits of armor, it gives the wearer almost perfect mobility, which suits the needs of the local colonists. It is also quick to don, easy to hide, and cheap to produce in large workshops. This one has straps interweaved with the plates, that allow the user to fire a captured smartgun, if a bit uncomfortably."
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS

//===========================//CMB\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/CMB
	name = "\improper CMB Deputy jacket"
	desc = "A thick and stylish black leather jacket with a Marshal's Deputy badge pinned to it. The back is enscribed with the powerful letters of 'DEPUTY' representing justice, authority, and protection in the outer rim. The laws of the Earth stretch beyond the Sol."
	icon_state = "CMB_jacket"
	item_state = "CMB_jacket"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/CMB.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/CMB.dmi'
	)
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/CMB/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/CMB/marshal
	name = "\improper CMB Marshal jacket"
	desc = "A thick and stylish black leather jacket with a Marshal's badge pinned to it. The back is enscribed with the powerful letters of 'MARSHAL' representing justice, authority, and protection in the outer rim. The laws of the Earth stretch beyond the Sol."
	icon_state = "CMB_jacket_marshal"
	item_state = "CMB_jacket_marshal"

/obj/item/clothing/suit/storage/marine/veteran/cmb
	name = "\improper M4R pattern CMB armor"
	desc = "A dark set of armor, which is a modification of the security variant of Armat Systems M3 armor. Designed for riot control and protest suppression in mind. The side of it has a metallic insignia with 'CMB RIOT CONTROL' on it. The laws of the Earth stretch beyond the Sol."
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/CMB.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/CMB.dmi'
	)
	icon_state = "cmb_heavy_armor"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	storage_slots = 3


	slowdown = SLOWDOWN_ARMOR_MEDIUM
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/cmb)
	item_state_slots = list(WEAR_JACKET = "cmb_heavy_armor")

/obj/item/clothing/suit/storage/marine/veteran/cmb/light
	name = "\improper M4R pattern CMB light armor"
	icon_state = "cmb_light_armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM

	slowdown = SLOWDOWN_ARMOR_LIGHT
	item_state_slots = list(WEAR_JACKET = "cmb_light_armor")

/obj/item/clothing/suit/storage/marine/veteran/cmb/spec
	name = "\improper M4R-S pattern CMB SWAT armor"
	icon_state = "cmb_elite_armor"
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGH

	slowdown = SLOWDOWN_ARMOR_LIGHT
	item_state_slots = list(WEAR_JACKET = "cmb_elite_armor")

/obj/item/clothing/suit/storage/marine/veteran/cmb/leader
	name = "\improper M4R pattern CMB Marshal armor"
	icon_state = "cmb_sheriff_armor"
	desc = "A custom fit variation of the CMB Riot armor, intended to be worn the Marshals themselves, has a golden lining with rank insignia. Has additional layer of lightweigh protective materials."
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH

	item_state_slots = list(WEAR_JACKET = "cmb_sheriff_armor")

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/mercenary
	name = "\improper K12 ceramic plated armor"
	desc = "A set of grey, heavy ceramic armor with dark blue highlights. It is the standard uniform of an unknown mercenary group working in the sector."
	icon_state = "mercenary_heavy_armor"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/CLF.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/CLF.dmi'
	)
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
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
		/obj/item/weapon/sword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/mercenary)
	item_state_slots = list(WEAR_JACKET = "mercenary_heavy_armor")

/obj/item/clothing/suit/storage/marine/veteran/mercenary/heavy
	name = "\improper Modified K12 ceramic plated armor"
	desc = "A set of grey, heavy ceramic armor with dark blue highlights. It has been modified with extra ceramic plates placed in its storage pouch, and seems intended to support an extremely heavy weapon."
	armor_melee = CLOTHING_ARMOR_ULTRAHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGHPLUS
	storage_slots = 1

/obj/item/clothing/suit/storage/marine/veteran/mercenary/miner
	name = "\improper Y8 armored miner vest"
	desc = "A set of beige, light armor built for protection while mining. It is a specialized uniform of an unknown mercenary group working in the sector."
	icon_state = "mercenary_miner_armor"
	storage_slots = 3
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
		/obj/item/weapon/sword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	uniform_restricted = list(/obj/item/clothing/under/marine/veteran/mercenary)
	item_state_slots = list(WEAR_JACKET = "mercenary_miner_armor")

/obj/item/clothing/suit/storage/marine/veteran/mercenary/support
	name = "\improper Z7 armored vest"
	desc = "A set of blue armor with yellow highlights built for protection while building or carrying out medical treatment in highly dangerous environments. It is a specialized uniform of an unknown mercenary group working in the sector."
	icon_state = "mercenary_engineer_armor"
	item_state_slots = list(WEAR_JACKET = "mercenary_engineer_armor")

/obj/item/clothing/suit/storage/marine/M3G/hefa
	name = "\improper HEFA Knight armor"
	desc = "A thick piece of armor adorning a HEFA. Usually seen on a HEFA knight."
	icon_state = "hefadier"
	icon = 'icons/obj/items/clothing/suits/misc_ert.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/misc_ert.dmi',
	)
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	flags_item = NO_CRYO_STORE
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_GIGAHIGH


//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/MP/provost
	name = "\improper M3 pattern Provost armor"
	desc = "A standard Provost M3 Pattern Chestplate. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."
	icon_state = "pvmedium"
	item_state_slots = list(WEAR_JACKET = "pvmedium")
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	storage_slots = 3

/obj/item/clothing/suit/storage/marine/MP/provost/tml
	name = "\improper M3 pattern Senior Provost armor"
	desc = "A more refined Provost M3 Pattern Chestplate for senior officers. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."
	icon_state = "pvleader"
	item_state_slots = list(WEAR_JACKET = "pvleader")

/obj/item/clothing/suit/storage/marine/MP/provost/marshal
	name = "\improper M5 pattern Provost Marshal armor"
	desc = "A custom fit luxury armor suit for Provost Marshals. Useful for letting your men know who is in charge when taking to the field."
	icon_state = "pvmarshal"
	item_state_slots = list(WEAR_JACKET = "pvmarshal")
	w_class = SIZE_MEDIUM
	storage_slots = 4

/obj/item/clothing/suit/storage/marine/MP/provost/light
	name = "\improper M3 pattern Provost light armor"
	desc = "A lighter Provost M3 Pattern Chestplate. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."
	icon_state = "pvlight"
	item_state_slots = list(WEAR_JACKET = "pvlight")
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT

/obj/item/clothing/suit/storage/marine/MP/provost/light/flexi
	name = "\improper M3 pattern Provost flexi-armor"
	desc = "A flexible and easy to store M3 Pattern Chestplate. Protects the chest from ballistic rounds, bladed objects and accidents. It has a small leather pouch strapped to it for limited storage."
	w_class = SIZE_MEDIUM
	icon_state = "pvlight_2"
	item_state_slots = list(WEAR_JACKET = "pvlight_2")
	storage_slots = 2

//================//UNITED AMERICAS RIOT CONTROL\\=====================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/ua_riot
	name = "\improper UA-M1 body armor"
	desc = "Based on the M-3 pattern employed by the USCM, the UA-M1 body armor is employed by UA security, riot control and union-busting teams. While robust against melee and bullet attacks, it critically lacks coverage of the legs and arms."
	icon_state = "ua_riot"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT  // it's lighter
	uniform_restricted = list(/obj/item/clothing/under/marine/ua_riot)
	flags_atom = NO_GAMEMODE_SKIN

/obj/item/clothing/suit/storage/marine/veteran/ua_riot/synth
	name = "\improper UA-M1S Synthetic body armor"
	desc = "Based on the M-3 pattern employed by the USCM, the UA-M1 body armor is employed by UA security, riot control and union-busting teams. The UA-1MS modification is Synthetic programming compliant, sacrificing protection for speed and carrying capacity."
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	slowdown = SLOWDOWN_ARMOR_SUPER_LIGHT
	storage_slots = 3
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE
	flags_marine_armor = ARMOR_SQUAD_OVERLAY|ARMOR_LAMP_OVERLAY|SYNTH_ALLOWED

//================//=ROYAL MARINES=\\====================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/royal_marine
	name = "kestrel armoured vest"
	desc = "A customizable personal armor system used by the Three World Empire's Royal Marines Commandos. Designers from a Weyland Yutani subsidary, Lindenthal-Ehrenfeld Militärindustrie, iterated on the USCMC's M3 pattern personal armor in their Tokonigara lab to create an armor systemed to suit the unique needs of the Three World Empire's smaller but better equipped Royal Marines."
	icon_state = "rmc_light"
	item_state = "rmc_light"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/TWE.dmi'
	)
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
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
		/obj/item/weapon/sword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

/obj/item/clothing/suit/storage/marine/veteran/royal_marine/light //RMC Rifleman Armor
	icon_state = "rmc_light"
	item_state = "rmc_light"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	slowdown = SLOWDOWN_ARMOR_LIGHT

/obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/team_leader //RMC TL & LT Armor
	name = "kestrel armoured carry vest"
	icon_state = "rmc_light_padded"
	item_state = "rmc_light_padded"
	storage_slots = 7

/obj/item/clothing/suit/storage/marine/veteran/royal_marine/smartgun //Smartgun Spec Armor
	name = "kestrel armoured smartgun harness"
	icon_state = "rmc_smartgun"
	item_state = "rmc_smartgun"
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN|SMARTGUN_HARNESS

/obj/item/clothing/suit/storage/marine/veteran/royal_marine/pointman //Pointman Spec Armor
	name = "kestrel pointman armour"
	desc = "A heavier version of the armor system used by the Three World Empire's Royal Marines Commandos. Designers from a Weyland Yutani subsidary, Lindenthal-Ehrenfeld Militärindustrie, iterated on the USCMC's M3 pattern personal armor in their Tokonigara lab to create an armor systemed to suit the unique needs of the Three World Empire's smaller but better equipped Royal Marines."
	icon_state = "rmc_pointman"
	item_state = "rmc_pointman"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	storage_slots = 7
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/atom/movable/marine_light
	light_system = DIRECTIONAL_LIGHT

//CBRN
/obj/item/clothing/suit/storage/marine/cbrn
	name = "\improper M3-M armor"
	desc = "While lacking the appearance of the M3 pattern armor worn in regular service, this armor piece is still a derivative of it. It has been heavily modified to fit over the MOPP suit with additional padding and Venlar composite layers removed, so as not to restrict the wearer’s movement. However, with the reduction of composite layers, the personal protection offered is less than desired with complaints having been lodged since 2165."
	icon_state = "cbrn"
	item_state = "cbrn"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UA.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UA.dmi'
	)
	slowdown = SLOWDOWN_ARMOR_HEAVY
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad =CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_marine_armor = NO_FLAGS
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	uniform_restricted = list(/obj/item/clothing/under/marine/cbrn)

/obj/item/clothing/suit/storage/marine/cbrn/advanced
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
