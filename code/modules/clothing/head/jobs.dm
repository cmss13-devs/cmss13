
//Bartender
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chefhat"
	item_state = "chefhat"
	desc = "The commander in chef's head wear."
	siemens_coefficient = 0.9

//Cult
/obj/item/clothing/head/cultist_hood
	name = "black hood"
	desc = "It's hood that covers the head."
	icon_state = "chaplain_hood"
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEARS|HIDEALLHAIR
	siemens_coefficient = 0.9
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_EYES

	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROT

	armor_bio = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEARS|HIDEALLHAIR
	siemens_coefficient = 0.9

//Mime
/obj/item/clothing/head/beret
	name = "beret"
	desc = "A beret, an artist's favorite headwear."
	icon_state = "beret"
	siemens_coefficient = 0.9
	flags_armor_protection = 0
	pickup_sound = null
	drop_sound = null
	icon = 'icons/obj/items/clothing/hats/berets.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/berets.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/hats_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/hats_righthand.dmi'
	)

//Security
/obj/item/clothing/head/beret/sec
	name = "security beret"
	desc = "A beret with the security insignia emblazoned on it. For officers that are more inclined towards style than safety."
	icon_state = "beret_badge"

/obj/item/clothing/head/beret/sec/alt
	name = "officer beret"
	desc = "A navy-blue beret with an officer's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "officerberet"

/obj/item/clothing/head/beret/sec/hos
	name = "officer beret"
	desc = "A navy-blue beret with a captain's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "hosberet"

/obj/item/clothing/head/beret/sec/warden
	name = "warden beret"
	desc = "A navy-blue beret with a warden's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "wardenberet"

/obj/item/clothing/head/beret/eng
	name = "engineering beret"
	desc = "A beret with the engineering insignia emblazoned on it. For engineers that are more inclined towards style than safety."
	icon_state = "e_beret_badge"

/obj/item/clothing/head/beret/jan
	name = "purple beret"
	desc = "A stylish, if purple, beret."
	icon_state = "purpleberet"


//Medical
/obj/item/clothing/head/surgery
	name = "surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	icon_state = "surgcap_blue"
	blood_overlay_type = "surgcap"
	icon = 'icons/obj/items/clothing/hats/surgical_caps.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/surgical_caps.dmi'
	)
	flags_inv_hide = HIDETOPHAIR

/obj/item/clothing/head/surgery/blue
	name = "doctor's surgical cap"
	desc = "A cap doctors wear during operations. Keeps their hair from tickling your internal organs. Typically worn by doctors, this one reminds you of blueberries."
	icon_state = "surgcap_blue"

/obj/item/clothing/head/surgery/lightblue
	name = "nurse's surgical cap"
	desc = "A cap nurses wear while they assist during operations. Keeps their hair from tickling your internal organs. Typically worn by nurses, this one is baby blue."
	icon_state = "surgcap_lightblue"

/obj/item/clothing/head/surgery/green
	name = "surgeon's surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. Typically worn by surgeons, this one is jade green."
	icon_state = "surgcap_green"

/obj/item/clothing/head/surgery/morgue
	name = "morgue surgical cap"
	desc = "A cap doctors wear while making autopsies, rather than during operations. Keeps their hair from dropping and interfering with incision scans. This one is a black as coal."
	icon_state = "surgcap_morgue"

/obj/item/clothing/head/surgery/pharmacist
	name = "pharmaceutical physician's surgical cap"
	desc = "A cap pharmaceutical physicians wear during to protect their scalp from chemical mishaps. It also keeps their hair from tickling your internal organs while they operate. It's white with an orange rim."
	icon_state = "surgcap_pharm"

/obj/item/clothing/head/surgery/cmo
	name = "chief medical officer's surgical cap"
	desc = "A striped cap the Chief Medical Officer wears during operations. Keeps their hair from tickling your internal organs. It's green with peach stripes to match the stripes on their lab coat."
	icon_state = "surgcap_cmo"

/obj/item/clothing/head/surgery/purple
	name = "purple surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is a rich wine color."
	icon_state = "surgcap_purple"

/obj/item/clothing/head/surgery/olive
	name = "olive surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is olive green."
	icon_state = "surgcap_olive"

/obj/item/clothing/head/surgery/brown
	name = "brown surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is a rusty brown color."
	icon_state = "surgcap_brown"

/obj/item/clothing/head/surgery/grey
	name = "grey surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is a mundane grey color."
	icon_state = "surgcap_grey"

/obj/item/clothing/head/surgery/white
	name = "white surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is snow white."
	icon_state = "surgcap_white"

//Detective

/obj/item/clothing/head/fedora
	name = "\improper tan fedora"
	desc = "A classic tan fedora."
	icon = 'icons/obj/items/clothing/hats/formal_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/formal_hats.dmi'
	)
	icon_state = "fedora_tan"
	item_state = "fedora_tan"
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS

/obj/item/clothing/head/fedora/brown
	name = "\improper brown fedora"
	desc = "A classic brown fedora."
	icon_state = "fedora_brown"
	item_state = "fedora_brown"

/obj/item/clothing/head/fedora/grey
	name = "\improper grey fedora"
	desc = "A classic grey fedora."
	icon_state = "fedora_grey"
	item_state = "fedora_grey"
