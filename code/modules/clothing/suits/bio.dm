//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "bio hood"
	desc = "A hood that protects the head and face from biological contaminants."
	icon_state = "bio"
	icon = 'icons/obj/items/clothing/hats/hazard.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hazard.dmi'
	)
	permeability_coefficient = 0.2
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inventory = COVEREYES|COVERMOUTH
	flags_inv_hide = HIDEFACE|HIDEMASK|HIDEEARS|HIDEALLHAIR
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	siemens_coefficient = 0.9

/obj/item/clothing/head/bio_hood/synth
	desc = "A hood that protects the head and face from biological contaminants, synthetic compliant. Offers no real protection."
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio"
	item_state = "bio_suit"
	icon = 'icons/obj/items/clothing/suits/hazard.dmi'
	w_class = SIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.2
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	slowdown = 1
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	siemens_coefficient = 0.9
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/hazard.dmi',
	)

/obj/item/clothing/suit/storage/synthbio
	name = "bio suit"
	desc = "Synthetic compliant bio-hazard suit. Intended to allow a synthetic to offer the illusion of infection control to humans. Has had most of the internal protective lining removed, allowing it to hold equipment and be lighter to move in."
	icon_state = "bio"
	item_state = "bio_suit"
	icon = 'icons/obj/items/clothing/suits/hazard.dmi'
	allowed = list(
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/device/motiondetector,
	)
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/hazard.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
	icon_state = "bio_general"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio_general"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_HANDS|BODY_FLAG_FEET
	flags_inv_hide = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL

//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL

//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/security
	icon_state = "bio_security"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL


//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL

