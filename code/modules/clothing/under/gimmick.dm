
/obj/item/clothing/under/gimmick
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW
	has_sensor = UNIFORM_NO_SENSORS
	displays_id = 0
	icon = 'icons/obj/items/clothing/halloween_clothes.dmi'
	item_icons = list(
		WEAR_BODY = 'icons/obj/items/clothing/halloween_clothes.dmi',
	)

/obj/item/clothing/suit/gimmick
	icon = 'icons/obj/items/clothing/halloween_clothes.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/obj/items/clothing/halloween_clothes.dmi',
	)

/obj/item/clothing/shoes/gimmick
	icon = 'icons/obj/items/clothing/halloween_clothes.dmi'
	item_icons = list(
		WEAR_FEET = 'icons/obj/items/clothing/halloween_clothes.dmi',
	)

/obj/item/clothing/mask/gimmick
	icon = 'icons/obj/items/clothing/halloween_clothes.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/obj/items/clothing/halloween_clothes.dmi',
	)

/obj/item/clothing/gloves/gimmick
	icon = 'icons/obj/items/clothing/halloween_clothes.dmi'
	item_icons = list(
		WEAR_HANDS = 'icons/obj/items/clothing/halloween_clothes.dmi',
	)

//JASON
/obj/item/clothing/under/gimmick/jason
	name = "dirty work attire"
	desc = "Perfect thing to wear when digging graves."
	icon_state = "jason_suit"

/obj/item/clothing/mask/gimmick/jason
	name = "hockey mask"
	desc = "It smells like teenage spirit."
	icon_state = "jason_mask"
	anti_hug = 100

/obj/item/clothing/suit/gimmick/jason
	name = "musty jacket"
	desc = "A killer fashion statement."
	icon_state = "jason_jacket"
	item_state = "jason_jacket"

//RAMBO
/obj/item/clothing/under/gimmick/rambo
	name = "combat pants"
	desc = "The only thing a man needs when he's up against the world."
	icon_state = "rambo_suit"
	flags_armor_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN

/obj/item/clothing/suit/gimmick/rambo
	name = "pendant"
	desc = "It's a precious stone and something of a talisman of protection."
	flags_armor_protection = BODY_FLAG_CHEST
	flags_cold_protection = BODY_FLAG_CHEST
	flags_heat_protection = BODY_FLAG_CHEST
	icon_state = "rambo_pendant"

//MCCLANE
/obj/item/clothing/under/gimmick/mcclane
	name = "holiday attire"
	desc = "The perfect outfit for a Christmas holiday with family. Shoes not included."
	icon_state = "mcclane_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS

//DUTCH
/obj/item/clothing/under/gimmick/dutch
	name = "combat fatigues"
	desc = "Just another pair of military fatigues for a grueling tour in a jungle."
	icon_state = "dutch_suit"
	flags_armor_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN

/obj/item/clothing/suit/armor/gimmick/dutch
	name = "armored jacket"
	desc = "It's hot in the jungle. Sometimes it's hot and heavy, and sometimes it's hell on earth."
	icon_state = "dutch_armor"
	flags_armor_protection = BODY_FLAG_CHEST
	flags_cold_protection = BODY_FLAG_CHEST
	flags_heat_protection = BODY_FLAG_CHEST
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
	)

//ROBOCOP
/obj/item/clothing/under/gimmick/robocop
	name = "metal body"
	desc = "It may be metallic, but it contains the heart and soul of Alex J. Murphy."
	icon_state = "robocop_suit"
	flags_atom = FPRINT|CONDUCT

/obj/item/clothing/shoes/gimmick/robocop
	name = "polished metal boots"
	desc = "The perfect size to stomp on the scum of Detroit."
	icon_state = "robocop_shoes"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	flags_inventory = FPRINT|CONDUCT|NOSLIPPING

/obj/item/clothing/gloves/gimmick/robocop
	name = "metal hands"
	desc = "The cold, unfeeling hands of the law."
	icon_state = "robocop_gloves"
	flags_atom = FPRINT|CONDUCT
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE

/obj/item/clothing/head/helmet/gimmick/robocop
	name = "polished metal helm"
	desc = "The impersonal face of the law. Constructed from titanium and laminated with kevlar."
	icon_state = "robocop_helmet"
	item_state = "robocop_helmet"
	icon = 'icons/obj/items/clothing/halloween_clothes.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/obj/items/clothing/halloween_clothes.dmi',
	)
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDETOPHAIR
	anti_hug = 100

/obj/item/clothing/suit/armor/gimmick
	icon = 'icons/obj/items/clothing/halloween_clothes.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/obj/items/clothing/halloween_clothes.dmi',
	)

/obj/item/clothing/suit/armor/gimmick/robocop
	name = "polished metal armor"
	desc = "Clean and well maintained, unlike the ugly streets of Detroit. Constructed from titanium and laminated with kevlar."
	icon_state = "robocop_armor"
	item_state = "robocop_armor"
	slowdown = 1
	flags_atom = FPRINT|CONDUCT
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	allowed = list(/obj/item/weapon/gun/pistol/auto9)
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE

//LUKE
/obj/item/clothing/under/gimmick/skywalker
	name = "black jumpsuit"
	desc = "A simple, utilitarian jumpsuit worn by one who has mastered the force."
	icon_state = "skywalker_suit"

/obj/item/clothing/shoes/gimmick/skywalker
	name = "black boots"
	desc = "Perfectly functional, this pair of boots has stomped on many planets and starships."
	icon_state = "skywalker_shoes"
	flags_inventory = FPRINT|NOSLIPPING

/obj/item/clothing/gloves/gimmick/skywalker
	name = "black glove"
	desc = "Something to cover up that artificial hand... Who says heroes can't be self-conscious?"
	icon_state = "skywalker_gloves"
