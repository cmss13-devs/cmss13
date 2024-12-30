
/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "gas_alt"
	item_state = "gas_alt"
	icon = 'icons/obj/items/clothing/masks/gasmasks.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/gasmasks.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/masks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/masks_righthand.dmi',
	)
	flags_inventory = COVERMOUTH | COVEREYES | ALLOWINTERNALS | BLOCKGASEFFECT | ALLOWREBREATH | ALLOWCPR
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDELOWHAIR
	flags_cold_protection = BODY_FLAG_HEAD
	flags_equip_slot = SLOT_FACE|SLOT_WAIST
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	w_class = SIZE_SMALL
	gas_transfer_coefficient = 0.01
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	siemens_coefficient = 0.9
	vision_impair = VISION_IMPAIR_NONE
	var/gas_filter_strength = 1 //For gas mask filters
	var/list/filtered_gases = list("phoron", "sleeping_agent", "carbon_dioxide")

/obj/item/clothing/mask/gas/kutjevo
	name = "kutjevo respirator"
	desc = "A respirator worn on the face that filters out harmful air particles often present in the air of Kutjevo."
	icon_state = "kutjevo_respirator"
	item_state = "kutjevo_respirator"

/obj/item/clothing/mask/gas/pmc
	name = "\improper M8 pattern armored balaclava"
	desc = "An armored balaclava designed to conceal both the identity of the operator and act as an air-filter."
	item_state = "helmet"
	icon_state = "pmc_mask"
	icon = 'icons/obj/items/clothing/masks/masks_by_faction/WY.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/masks_by_faction/WY.dmi'
	)
	anti_hug = 3
	vision_impair = VISION_IMPAIR_NONE
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_NONE
	flags_inventory = COVERMOUTH|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR
	flags_equip_slot = SLOT_FACE

/obj/item/clothing/mask/gas/pmc/marsoc
	name = "\improper SOF armored balaclava"
	desc = "Designed for maximum protection -- and badassery. Provides protection against facial attacks, filters toxins, and conceals the wearer's identity."
	icon_state = "balaclava"
	icon = 'icons/obj/items/clothing/masks/balaclava.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/balaclava.dmi'
	)

/obj/item/clothing/mask/gas/pmc/upp
	name = "\improper UPP armored commando balaclava"
	icon_state = "upp_mask"
	icon = 'icons/obj/items/clothing/masks/masks_by_faction/UPP.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/masks_by_faction/UPP.dmi'
	)

/obj/item/clothing/mask/gas/pmc/leader
	name = "\improper M8 pattern armored balaclava"
	desc = "An armored balaclava designed to conceal both the identity of the operator and act as an air-filter. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_mask"

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	siemens_coefficient = 0.7
	flags_armor_protection = BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without their wig and mask."
	icon_state = "clown"
	item_state = "clown_hat"
	icon = 'icons/obj/items/clothing/masks/masks.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/masks.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/masks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/masks_righthand.dmi',
	)
	vision_impair = VISION_IMPAIR_NONE
	black_market_value = 25

/obj/item/clothing/mask/gas/fake_mustache
	name = "fake mustache"
	desc = "It is almost perfect."
	icon_state = "souto_man"
	icon = 'icons/obj/items/clothing/masks/masks.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/masks.dmi'
	)
	vision_impair = VISION_IMPAIR_NONE
	unacidable = TRUE
	flags_inventory = CANTSTRIP|COVEREYES|COVERMOUTH|ALLOWINTERNALS|ALLOWREBREATH|BLOCKGASEFFECT|ALLOWCPR|BLOCKSHARPOBJ

//=ROYAL MARINES=\\

/obj/item/clothing/mask/gas/pmc/royal_marine
	name = "\improper L7 gasmask"
	desc = "The L7 Gasmask used by members of the three world empires royal marines commando."
	icon_state = "rmc_mask"
	icon = 'icons/obj/items/clothing/masks/masks_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/masks_by_faction/TWE.dmi'
	)
	flags_atom = NO_NAME_OVERRIDE|NO_GAMEMODE_SKIN
