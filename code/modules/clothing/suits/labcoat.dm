/obj/item/clothing/suit/storage/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat" //Is this even used for anything?
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

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
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

	verb/toggle()
		set name = "Toggle Labcoat Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.is_mob_restrained())
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

/obj/item/clothing/suit/storage/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo"
	item_state = "labcoat_cmo"

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
	//name = "Medical officer's labcoat"
	icon_state = "labcoatg"
	item_state = "labcoatg"

/obj/item/clothing/suit/storage/labcoat/researcher
	name = "researcher's labcoat"
	desc = "A high quality labcoat, seemingly worn by scholars and researchers alike. It has a distinct leathery feel to it, and goads you towards adventure."
	icon_state = "sciencecoat"
	item_state = "sciencecoat"

/obj/item/clothing/suit/storage/snow_suit
	name = "snow suit"
	desc = "A standard snow suit. It can protect the wearer from extreme cold."
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_state = "snowsuit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	blood_overlay_type = "armor"
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/snow_suit/doctor
	name = "doctor's snow suit"

/obj/item/clothing/suit/storage/snow_suit/survivor
	name = "robust snow suit"
	desc = "A snow suit. It can protect the wearer from extreme cold. This one seems to have been modified somewhat, and can both holster a gun and fit magazines."
	icon_state = "snowsuit" //needs new cool sprite
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW //<- this one is different
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	allowed = list(/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/sparepouch,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/melee/baseballbat,
		/obj/item/weapon/melee/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman)

/obj/item/clothing/suit/storage/snow_suit/survivor/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/snow_suit/soviet
	name = "soviet snowcoat"
	desc = "A winter coat made in some desolate snowplanet. This wintercoat was made from the fur of local wildlife which donated their fur for the greater good of UPP!"
	icon_state = "sovietcoat"
	item_state = "sovietcoat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	blood_overlay_type = "armor"
	siemens_coefficient = 0.7
	allowed = list(/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/sparepouch,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/melee/baseballbat,
		/obj/item/weapon/melee/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman)
