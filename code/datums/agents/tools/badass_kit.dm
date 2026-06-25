/obj/item/storage/box/badass_kit
	name = "suspicious box"
	desc = "A compact and suspicious looking box. This one is small enough to fit into a bag."

	w_class = SIZE_MEDIUM

	storage_slots = 2


/obj/item/storage/box/badass_kit/Initialize()
	. = ..()
	new/obj/item/device/encryptionkey/sec(src)
	new/obj/item/clothing/glasses/sunglasses/antag(src)

/obj/item/clothing/glasses/sunglasses/antag
	flags_equip_slot = SLOT_EYES

	flags_armor_protection = BODY_FLAG_EYES|BODY_FLAG_FACE

	armor_energy = CLOTHING_ARMOR_HARDCORE
	eye_protection = EYE_PROTECTION_WELDING


/obj/item/clothing/glasses/hud/health/antag_sunglasses
	desc = "Generic off-brand eyewear, used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	icon_state = "sun"
	item_state = "sun"
	icon = 'icons/obj/items/clothing/glasses/glasses.dmi'
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/glasses/glasses.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/glasses_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/glasses.dmi',
	)

	flags_equip_slot = SLOT_EYES

	flags_armor_protection = BODY_FLAG_EYES|BODY_FLAG_FACE
	actions_types = list()

	armor_energy = CLOTHING_ARMOR_HARDCORE
	eye_protection = EYE_PROTECTION_WELDING

	hud_type = MOB_HUD_MEDICAL_ADVANCED
	req_skill = SKILL_ANTAG
	req_skill_level = SKILL_ANTAG_AGENT
