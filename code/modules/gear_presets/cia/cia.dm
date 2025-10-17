/// CIA Agents ///

/datum/equipment_preset/cia
	name = "CIA Agent (Civilian Clothing)"
	flags = EQUIPMENT_PRESET_EXTRA
	minimum_age = 25
	job_title = JOB_CIA
	assignment = JOB_CIA
	skills = /datum/skills/cia/field_agent
	languages = ALL_HUMAN_LANGUAGES
	faction = FACTION_CIA
	faction_group = FACTION_LIST_CIA_MARINE

	paygrades = list(PAY_SHORT_CIA_IA = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CIV"
	minimap_icon = "cia_ia"
	minimap_background = "background_civillian"
	idtype = /obj/item/card/id/adaptive

/datum/equipment_preset/cia/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL) + list(ACCESS_CIA)

/datum/equipment_preset/cia/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()

	//Give them a random piece of civvie clothing.
	var/random_outfit = pick(
		/obj/item/clothing/under/liaison_suit/black,
		/obj/item/clothing/under/liaison_suit/brown,
		/obj/item/clothing/under/liaison_suit/field,
		/obj/item/clothing/under/liaison_suit/outing,
	)

	var/random_suit = pick(
		/obj/item/clothing/suit/storage/jacket/marine/corporate/black,
		/obj/item/clothing/suit/storage/jacket/marine/corporate/brown,
		/obj/item/clothing/suit/storage/jacket/marine/corporate/blue,
		/obj/item/clothing/suit/storage/jacket/marine/bomber,
		/obj/item/clothing/suit/storage/jacket/marine/bomber/red,
		/obj/item/clothing/suit/storage/jacket/marine/bomber/grey,
		/obj/item/clothing/suit/storage/jacket/marine/vest,
		/obj/item/clothing/suit/storage/jacket/marine/vest/tan,
		/obj/item/clothing/suit/storage/jacket/marine/vest/grey,
	)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new random_outfit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new random_suit(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia/covert(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human), WEAR_IN_BACK)

/// USCM Placements ///

/datum/equipment_preset/cia/officer
	name = "CIA Agent (USCM Liaison - 1st Lieutenant)"
	job_title = JOB_CIA_LIAISON
	assignment = JOB_CIA_LIAISON
	paygrades = list(PAY_SHORT_MO2 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "ILO"
	minimap_icon = "cia_lo"
	minimap_background = "background_ua"

/datum/equipment_preset/cia/officer/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/bridge(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/m1911(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia/covert(new_human), WEAR_IN_BACK)

/datum/equipment_preset/cia/officer/o3
	name = "CIA Senior Agent (USCM Liaison - Captain)"
	paygrades = list(PAY_SHORT_MO3 = JOB_PLAYTIME_TIER_0)
	minimum_age = 30
	skills = /datum/skills/cia/field_agent/senior

/datum/equipment_preset/cia/officer/o3/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL) + list(ACCESS_CIA, ACCESS_CIA_SENIOR)

/datum/equipment_preset/uscm/marsoc/low_threat/cia
	name = "Marine Raider Advisor (CIA Senior Agent)"
	minimum_age = 30
	skills = /datum/skills/cia/field_agent/senior

/datum/equipment_preset/uscm/marsoc/low_threat/cia/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL) + list(ACCESS_CIA, ACCESS_CIA_SENIOR)

/datum/equipment_preset/uscm/marsoc/low_threat/cia/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	//Custom reduced loadout versus normal MARSOC
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/marsoc, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/portable_vendor/antag/cia, WEAR_IN_BACK) //CIA equipment
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/marsoc, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_HELMET)
	//uniform
	var/obj/item/clothing/under/marine/veteran/marsoc/uniform = new()
	var/obj/item/clothing/accessory/storage/black_vest/accessory = new()
	uniform.attach_accessory(new_human, accessory)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	for(var/i in 1 to accessory.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/sof/armor = new()
	new_human.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/xm40, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite/xm40/ap, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat/marsoc, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full, WEAR_R_STORE)

