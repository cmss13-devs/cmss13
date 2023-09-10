
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
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/tanker, WEAR_JACKET)

/datum/equipment_preset/uscm/tank/load_status()
	return
