/obj/item/clothing/suit/storage/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat" //Is this even used for anything?
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/device/analyzer,
		/obj/item/stack/medical,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/syringe,
		/obj/item/reagent_container/hypospray,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/paper,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/tool/surgery/hemostat,
		/obj/item/tool/surgery/cautery,
		/obj/item/tool/surgery/retractor,
		/obj/item/tool/surgery/surgicaldrill,
		/obj/item/tool/surgery/circular_saw,
		/obj/item/tool/surgery/scalpel,
		/obj/item/tool/surgery/FixOVein,
		/obj/item/tool/surgery/bonesetter,
		/obj/item/roller,
		/obj/item/tool/surgery/bonegel,
		/obj/item/stack/nanopaste,
		/obj/item/reagent_container/blood,
		/obj/item/reagent_container/spray/cleaner,

		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/device/motiondetector,

	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	var/buttoned = TRUE
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi'
	)


/obj/item/clothing/suit/storage/labcoat/verb/toggle()
	set name = "Toggle Labcoat Buttons"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0

	if(src.buttoned == TRUE)
		src.icon_state = "[initial(icon_state)]_open"
		src.buttoned = FALSE
	else
		src.icon_state = initial(icon_state) //doesn't need to be a string
		src.buttoned = TRUE
	update_clothing_icon()

/obj/item/clothing/suit/storage/labcoat/red
	name = "red labcoat"
	desc = "A suit that protects against minor chemical spills. This one is red."
	icon_state = "red_labcoat"
	item_state = "red_labcoat"

/obj/item/clothing/suit/storage/labcoat/blue
	name = "blue labcoat"
	desc = "A suit that protects against minor chemical spills. This one is blue."
	icon_state = "blue_labcoat"
	item_state = "blue_labcoat"

/obj/item/clothing/suit/storage/labcoat/purple
	name = "purple labcoat"
	desc = "A suit that protects against minor chemical spills. This one is purple."
	icon_state = "purple_labcoat"
	item_state = "purple_labcoat"

/obj/item/clothing/suit/storage/labcoat/orange
	name = "orange labcoat"
	desc = "A suit that protects against minor chemical spills. This one is orange."
	icon_state = "orange_labcoat"
	item_state = "orange_labcoat"

/obj/item/clothing/suit/storage/labcoat/green
	name = "green labcoat"
	desc = "A suit that protects against minor chemical spills. This one is green."
	icon_state = "green_labcoat"
	item_state = "green_labcoat"

/obj/item/clothing/suit/storage/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen"
	item_state = "labgreen"

/obj/item/clothing/suit/storage/labcoat/genetics
	name = "Geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen"

/obj/item/clothing/suit/storage/labcoat/chemist
	name = "Chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem"

/obj/item/clothing/suit/storage/labcoat/virologist
	name = "Virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir"
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/suit/storage/labcoat/science
	name = "Scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox"

/obj/item/clothing/suit/storage/labcoat/officer
	name = "Chief Medical Officer's labcoat"
	desc = "A green sleek long labcoat, designed to distinguish a higher ranking medical personnel. Fabric has a better protection against chemical hazards."
	icon_state = "labcoatg"
	item_state = "labcoatg"
	armor_bio = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/labcoat/researcher
	name = "researcher's labcoat"
	desc = "A high-quality labcoat, seemingly worn by scholars and researchers alike. It has a distinct leathery feel to it, and goads you towards adventure."
	icon_state = "sciencecoat"
	item_state = "sciencecoat"

/obj/item/clothing/suit/storage/labcoat/wy
	name = "W-Y researcher's labcoat"
	desc = "A high-quality corporate labcoat, seemingly worn by science consultants and researchers alike. Built using robust materials for engaging dangerous experiments."
	icon_state = "wy_rc_labcoat"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/WY.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/WY.dmi'
	)
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW

/obj/item/clothing/suit/chef/classic/medical
	name = "medical's apron"
	desc = "A basic and sterile white apron, good for surgical and, of course, other medical practices."

/obj/item/clothing/suit/storage/snow_suit
	name = "snow suit"
	desc = "A standard snow suit. It can protect the wearer from extreme cold."
	icon = 'icons/obj/items/clothing/suits/coats_robes.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/coats_robes.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/suits_righthand.dmi',
	)
	icon_state = "snowsuit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	blood_overlay_type = "armor"
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/snow_suit/doctor
	name = "doctor's snow suit"

/obj/item/clothing/suit/storage/snow_suit/synth
	name = "synthetic's snow suit"
	desc = "A snow suit designed for keeping synthetic units within acceptable temperature ranges in extremely cold environments to prevent power supply inefficiency. Due to advancements made in synthetic insulation, they are not required for most cold environments."
	armor_melee = CLOTHING_ARMOR_NONE //no free armor for synths
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/device/motiondetector,
	)

/obj/item/clothing/suit/storage/snow_suit/survivor
	name = "robust snow suit"
	icon_state = "snowsuit" //needs new cool sprite
	desc = "A snow suit. It can protect the wearer from extreme cold. This one seems to have been modified somewhat, and can both holster a gun and fit magazines."
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

/obj/item/clothing/suit/storage/snow_suit/survivor/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/snow_suit/survivor/parka
	name = "Parent Parka"
	desc = "A winter coat made to withstand the frigged cold weather of the arctic deserts. W-Y branded Parka"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/red
	name = "Security Parka"
	icon_state = "redpark"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/navy
	name = "Navy Parka"
	icon_state = "navypark"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/yellow
	name = "yellow Parka"
	icon_state = "yellowpark"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/green
	name = "Green Parka"
	icon_state = "greenpark"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/purple
	name = "Purple Parka"
	icon_state = "purplepark"

/obj/item/clothing/suit/storage/snow_suit/soviet
	name = "soviet snowcoat"
	desc = "A winter coat made in some desolate snowplanet. This wintercoat was made from the fur of local wildlife which donated their fur for the greater good of UPP!"
	icon_state = "sovietcoat"
	item_state = "sovietcoat"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/UPP.dmi'
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	blood_overlay_type = "armor"
	siemens_coefficient = 0.7
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/UPP.dmi'
	)


/obj/item/clothing/suit/storage/snow_suit/liaison
	name = "liaison's winter coat"
	desc = "A Weyland-Yutani winter coat. Only the best comfort for the liaison in a cold environment."
	icon_state = "snowsuit_liaison"
	icon = 'icons/obj/items/clothing/suits/suits_by_faction/WY.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/suits_by_faction/WY.dmi'
	)

/obj/item/clothing/suit/storage/snow_suit/liaison/modified
	name = "modified liaison's winter coat"
	desc = "A Weyland-Yutani winter coat. This one has been modified to holster guns and other objects. Only the best comfort and utility for the liaison surviving in a cold, hostile environment."
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

/obj/item/clothing/suit/storage/labcoat/brown
	icon_state = "labcoat_brown"
	item_state = "labcoat_brown"

/obj/item/clothing/suit/storage/labcoat/short
	icon_state = "labcoat_short"
	item_state = "labcoat_short"

/obj/item/clothing/suit/storage/labcoat/long
	icon_state = "labcoat_long"
	item_state = "labcoat_long"
