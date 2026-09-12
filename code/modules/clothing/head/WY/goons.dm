
//=============================//WY PRIVATE SECURITY (GOONS)\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate
	name = "\improper WY corporate security helmet"
	desc = "A basic skull-helm worn by corporate security assets, graded to protect your head from an unruly scientist armed with a crowbar."
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/WY.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/WY.dmi'
	)
	icon_state = "sec_helmet"
	item_state = "sec_helmet"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/ppo
	icon_state = "ppo_helmet"
	item_state = "ppo_helmet"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/medic
	desc = "A basic skull-helm worn by corporate security assets. This variant lacks a visor, granting the wearer a better view of any potential patients."
	icon_state = "med_helmet"
	item_state = "med_helmet"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/engi
	name = "\improper WY corporate security technician helmet"
	desc = "A basic skull-helm worn by corporate security assets. This variant comes equipped with a standard-issue integrated welding visor. Prone to fogging up over prolonged use."
	icon_state = "eng_helmet"
	item_state = "eng_helmet"
	built_in_visors = list(new /obj/item/device/helmet_visor/welding_visor/goon)

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lead
	desc = "A basic skull-helm worn by corporate security assets. This variant is worn by low-level guards that have too much brainmatter to fit into the old one. Or so they say."
	icon_state = "sec_lead_helmet"
	item_state = "sec_lead_helmet"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo
	desc = "A basic skull-helm worn by corporate security assets. This variant comes with a wider brim to protect the user from the harsh climate of the desert."
	icon_state = "sec_helmet_kutjevo"
	item_state = "sec_helmet_kutjevo"

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo/medic
	desc = "A basic skull-helm worn by corporate security assets. This variant comes with a wider brim to protect the user from the harsh climate of the desert and has a medical cross across the front."
	icon_state = "sec_medic_helmet_kutjevo"
	item_state = "sec_medic_helmet_kutjevo"

// Lasalle Security

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lasalle_security
	name = "\improper Lasalle Bionational security helmet"
	desc = "A full face helmet worn by Lasalle Bionatonal corporate security assets."
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/LASALLE.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/LASALLE.dmi'
	)
	icon_state = "lasalle_security_helmet"
	item_state = "lasalle_security_helmet"

	flags_inv_hide = HIDEEARS|HIDEEYES|HIDETOPHAIR

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lasalle_security/Initialize()
	. = ..()
	RemoveElement(/datum/element/corp_label/wy)
	AddElement(/datum/element/corp_label/bionational)
