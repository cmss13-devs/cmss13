//covers and front plates and other stuff


// THE HELMET ACCESSORY PARENT
/obj/item/clothing/accessory/helmet
	name = "potato helmet"
	desc = "ahelp if you see this."
	w_class = SIZE_SMALL
	garbage = TRUE // for all intents and purposes, yes
	worn_accessory_limit = 1 // no reason to have multiple back straps, youre gonna look stupid with this on a higher number
	icon = 'icons/obj/items/clothing/accessory/helmet_accessories.dmi'
	accessory_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/accessory/helmet_accessories.dmi',
	)
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/accessory/helmet_accessories.dmi', // doesnt exactly matter on the other attachments as they wouldnt be able to fit on the thing as garb anyway
	)

//frontplates and stuff
/obj/item/clothing/accessory/helmet/frontstrap
	name = "fried strap"
	worn_accessory_slot = ACCESSORY_SLOT_HELM_A

/obj/item/clothing/accessory/helmet/frontstrap/marine_frontplate
	name = "\improper M11 Helmet Frontplate attachment"
	icon_state = "marine_frontplate"
	flags_obj = OBJ_IS_HELMET_GARB // its small enough

/obj/item/clothing/accessory/helmet/frontstrap/co_frontplate
	name = "\improper M11C Helmet Frontplate attachment"
	icon_state = "co_frontplate"
	flags_obj = OBJ_IS_HELMET_GARB

//the lobster tail and dust ruffles... mmm ruffles have ridges...
/obj/item/clothing/accessory/helmet/backstrap
	name = "salad strap"
	worn_accessory_slot = ACCESSORY_SLOT_HELM_B
	w_class = SIZE_MEDIUM

/obj/item/clothing/accessory/helmet/backstrap/marine_lobster
	name = "\improper M10 Helmet Lobster-tail attachment"
	icon = 'icons/obj/items/clothing/accessory/accessories_by_map/jungle.dmi'
	icon_state = "marine_lobster"
	accessory_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/accessory/accessories_by_map/jungle.dmi',
	)

/obj/item/clothing/accessory/helmet/backstrap/marine_lobster/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/corp_label/armat)

	if(!(flags_atom & NO_GAMEMODE_SKIN))
		select_gamemode_skin(type, null)

/obj/item/clothing/accessory/helmet/backstrap/marine_lobster/select_gamemode_skin(expected_type, list/override_icon_state)
	. = ..()
	if(flags_atom & MAP_COLOR_INDEX)
		return
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/accessory/accessories_by_map/jungle.dmi'
			accessory_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/accessory/accessories_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/accessory/accessories_by_map/classic.dmi'
			accessory_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/accessory/accessories_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/accessory/accessories_by_map/desert.dmi'
			accessory_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/accessory/accessories_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/accessory/accessories_by_map/snow.dmi'
			accessory_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/accessory/accessories_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/accessory/accessories_by_map/urban.dmi'
			accessory_icons[WEAR_HEAD] = 'icons/mob/humans/onmob/clothing/accessory/accessories_by_map/urban.dmi'

/obj/item/clothing/accessory/helmet/backstrap/sadar_lobster
	name = "\improper M3-T Helmet Lobster-tail attachment"
	icon_state = "sadar_lobster"

/obj/item/clothing/accessory/helmet/backstrap/dust_ruffle
	name = "\improper M12 Helmet Dust-ruffle attachment"
	icon_state = "marine_ruffle"
	w_class = SIZE_TINY


// covers
/obj/item/clothing/accessory/helmet/cover
	name = "potato cover"
	desc = "ahelp if you see this."
	flags_obj = OBJ_IS_HELMET_GARB
	w_class = SIZE_TINY
	worn_accessory_slot = ACCESSORY_SLOT_HELM_C
	worn_accessory_limit = 2 // cover a helmet with a raincover and a netting i guess

/obj/item/clothing/accessory/helmet/cover/raincover
	name = "raincover"
	desc = "The standard M10 combat helmet is already water-resistant at depths of up to 10 meters. This makes the top potentially water-proof. At least it's something."
	icon_state = "raincover"

/obj/item/clothing/accessory/helmet/cover/raincover/jungle
	name = "jungle raincover"
	icon_state = "raincover_jungle"

/obj/item/clothing/accessory/helmet/cover/raincover/desert
	name = "desert raincover"
	icon_state = "raincover_desert"

/obj/item/clothing/accessory/helmet/cover/raincover/urban
	name = "urban raincover"
	icon_state = "raincover_urban"

/obj/item/clothing/accessory/helmet/cover/netting
	name = "combat netting"
	desc = "Probably combat netting for a helmet. Probably just an extra hairnet that got ordered for the phantom Almayer cooking staff. Probably useless."
	icon_state = "netting"

/obj/item/clothing/accessory/helmet/cover/netting/desert
	name = "desert combat netting"
	icon_state = "netting_desert"

/obj/item/clothing/accessory/helmet/cover/netting/jungle
	name = "jungle combat netting"
	icon_state = "netting_jungle"

/obj/item/clothing/accessory/helmet/cover/netting/urban
	name = "urban combat netting"
	icon_state = "netting_urban"


// helmet decor, think insignias and bands and stuff
/obj/item/clothing/accessory/helmet/decor
	name = "fish decor"
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/accessory/helmet/decor
	name = "\improper MP Helmet Insignia & Band"
	worn_accessory_slot = ACCESSORY_SLOT_HELM_D
	icon_state = "mp_band"
