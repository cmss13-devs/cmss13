
/datum/equipment_preset/uscm/walker
	name = "USCM Mech Crewman (MO) (Cryo)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_WALKER,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_ENGPREP
	)
	assignment = JOB_WALKER
	rank = JOB_WALKER
	paygrade = "ME4"
	role_comm_title = "CRMN"
	minimum_age = 30
	skills = /datum/skills/mech_pilot

	minimap_icon = "vc"

/datum/equipment_preset/uscm/walker/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/vc(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker/walker(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/tanker, WEAR_JACKET)

/datum/equipment_preset/uscm/walker/load_status()
	return

/obj/item/clothing/under/marine/officer/tanker/walker
	name = "mech operator uniform"
//	icon = 'fray-marines/icons/obj/mechpilot.dmi'
//	icon_state = "mecha_uniform"
//	worn_state = "marine_tanker"

/obj/item/clothing/head/helmet/marine/tech/tanker/walker
	name = "\improper M50 walker helmet"
	desc = "The lightweight M50 walker helmet is designed for use by armored crewmen in the USCM. It offers low weight protection, and allows agile movement inside the confines of an armored vehicle. Features a toggleable welding screen for eye protection."
//	icon = 'fray-marines/icons/obj/mechpilot.dmi'
//	icon_state = "mecha_helmet"
//	worn_state = "tanker_helmet"

/obj/item/clothing/suit/storage/marine/tanker/walker
	name = "\improper M3 pattern walker armor"
	desc = "A modified and refashioned suit of M3 Pattern armor designed to be worn by the loader of a USCM vehicle crew. While the suit is a bit more encumbering to wear with the crewman uniform, it offers the loader a degree of protection that would otherwise not be enjoyed."
//	icon = 'fray-marines/icons/obj/mechpilot.dmi'
//	icon_state = "mecha_armor"
//	worn_state = "tanker"
