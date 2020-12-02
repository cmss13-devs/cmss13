/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled with medical items."
	icon_state = "secure_locked_medical_white"
	icon_closed = "secure_unlocked_medical_white"
	icon_locked = "secure_locked_medical_white"
	icon_opened = "secure_open_medical_white"
	icon_broken = "secure_closed_medical_white"
	icon_off = "secure_closed_medical_white"
	req_access = list(ACCESS_MARINE_MEDBAY)

/obj/structure/closet/secure_closet/medical1/Initialize()
	. = ..()
	new /obj/item/storage/box/syringes(src)
	new /obj/item/reagent_container/dropper(src)
	new /obj/item/reagent_container/dropper(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/bottle/inaprovaline(src)
	new /obj/item/reagent_container/glass/bottle/antitoxin(src)
	new /obj/item/storage/box/pillbottles(src)
	new /obj/item/storage/box/pillbottles(src)
	return

/obj/structure/closet/secure_closet/medical2
	name = "anesthetic closet"
	desc = "Used to knock people out."
	icon_state = "secure_locked_medical_white"
	icon_closed = "secure_unlocked_medical_white"
	icon_locked = "secure_locked_medical_white"
	icon_opened = "secure_open_medical_white"
	icon_broken = "secure_closed_medical_white"
	icon_off = "secure_closed_medical_white"
	req_access = list(ACCESS_MARINE_MEDBAY)

/obj/structure/closet/secure_closet/medical2/Initialize()
	. = ..()
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/clothing/mask/breath/medical(src)
	return

/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(ACCESS_MARINE_MEDBAY)
	icon_state = "secure_locked_medical_white"
	icon_closed = "secure_unlocked_medical_white"
	icon_locked = "secure_locked_medical_white"
	icon_opened = "secure_open_medical_white"
	icon_broken = "secure_closed_medical_white"
	icon_off = "secure_closed_medical_white"

/obj/structure/closet/secure_closet/medical3/Initialize()
	. = ..()
	new /obj/item/storage/belt/medical/full(src)
	new /obj/item/storage/belt/medical/full(src)
	new /obj/item/storage/backpack/marine/satchel(src)
	new /obj/item/clothing/under/rank/medical/green(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/storage/pouch/medical(src)
	new /obj/item/storage/pouch/medical(src)
	new /obj/item/storage/pouch/syringe(src)
	new /obj/item/storage/pouch/medkit(src)
	new /obj/item/storage/pouch/medkit(src)
	new /obj/item/storage/pouch/chem(src)
	new /obj/item/storage/pouch/chem(src)
	new /obj/item/storage/pouch/vials/full(src)
	new /obj/item/storage/pouch/vials/full(src)
	new /obj/item/storage/pouch/pressurized_reagent_canister(src)
	new /obj/item/storage/pouch/pressurized_reagent_canister(src)
	if(is_mainship_level(z))
		new /obj/item/device/radio/headset/almayer/doc(src)
	return

/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(ACCESS_MARINE_CMO)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

/obj/structure/closet/secure_closet/CMO/Initialize()
	. = ..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/under/rank/medical/green(src)
	new /obj/item/clothing/under/rank/medical/blue(src)
	new /obj/item/clothing/under/rank/medical/purple(src)
	new /obj/item/clothing/head/surgery/green(src)
	new /obj/item/clothing/head/surgery/blue(src)
	new /obj/item/clothing/head/surgery/purple(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/head/cmo(src)
	new /obj/item/device/radio/headset/almayer/cmo(src)
	new /obj/item/reagent_container/hypospray/tricordrazine(src)
	new /obj/item/device/flash(src)
	new /obj/item/storage/pouch/medical(src)
	new /obj/item/storage/pouch/syringe(src)
	new /obj/item/storage/pouch/medkit(src)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "secure_locked_medical_white"
	icon_closed = "secure_unlocked_medical_white"
	icon_locked = "secure_locked_medical_white"
	icon_opened = "secure_open_medical_white"
	icon_broken = "secure_closed_medical_white"
	icon_off = "secure_closed_medical_white"
	req_access = list(ACCESS_MARINE_CHEMISTRY)

/obj/structure/closet/secure_closet/chemical/Initialize()
	. = ..()
	for(var/i = 0, i < 4, i++)
		new /obj/item/storage/box/pillbottles(src)
	return

/obj/structure/closet/secure_closet/medical_wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_spark"
	icon_off = "medical_wall_off"
	anchored = 1
	density = 0
	wall_mounted = 1
	req_access = list(ACCESS_MARINE_MEDBAY)

/obj/structure/closet/secure_closet/medical_wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened
