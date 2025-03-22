//=============================//PMCS\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran
	flags_atom = NO_GAMEMODE_SKIN|NO_NAME_OVERRIDE //Let's make these keep their name and icon.
	built_in_visors = list()

/obj/item/clothing/head/helmet/marine/veteran/pmc
	name = "\improper PMC tactical cap"
	desc = "A protective cap made from flexible kevlar. Standard issue for most security forms in the place of a helmet."
	icon_state = "pmc_hat"
	icon = 'icons/obj/items/clothing/hats/hats_by_faction/WY.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats_by_faction/WY.dmi',
	)
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/veteran/pmc/black
	name = "\improper PMC black tactical cap"
	icon_state = "pmc_hat_dark"

/obj/item/clothing/head/helmet/marine/veteran/pmc/engineer
	name = "\improper PMC engineer helmet"
	desc = "An advanced technician helmet with a black finish, including advanced welding protection and resistence to the potential industrial hazards, but has less kevlar against potential firefights."
	icon_state = "pmc_engineer_helmet"
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	eye_protection = EYE_PROTECTION_WELDING
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEALLHAIR
	flags_heat_protection = BODY_FLAG_HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROT

/obj/item/clothing/head/helmet/marine/veteran/pmc/leader
	name = "\improper PMC beret"
	desc = "The pinnacle of fashion for any aspiring mercenary leader. Designed to protect the head from light impacts."
	icon_state = "officer_hat"

/obj/item/clothing/head/helmet/marine/veteran/pmc/sniper
	name = "\improper PMC sniper helmet"
	desc = "A helmet worn by PMC Marksmen."
	icon_state = "pmc_sniper_hat"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed
	name = "\improper PMC helmet"
	desc = "A standard enclosed helmet utilized by Weyland-Yutani PMC."
	icon_state = "pmc_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR

//=============================//PMC GUARD (POLICE)\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/guard
	name = "\improper PMC riot guard helmet"
	desc = "A modified enclosed helmet utilized by Weyland-Yutani PMC crowd control units."
	icon_state = "guard_heavy_helmet"
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/veteran/pmc/guard
	name = "\improper PMC guard tactical cap"
	icon_state = "guard_cap"

/obj/item/clothing/head/helmet/marine/veteran/pmc/guard/crewman
	name = "\improper PMC driver tactical cap"
	icon_state = "guard_cap"

/obj/item/clothing/head/helmet/marine/veteran/pmc/guard/lead
	name = "\improper PMC guard leader tactical cap"
	icon_state = "guard_lead_cap"
