/datum/equipment_preset/uscm_ship/uscm_police
	name = "USCM (police roles)"
	faction = FACTION_MARINE
	minimum_age = 27

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/mp
	name = "USCM Military Police (MP)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_LOGISTICS,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_MORGUE,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING
	)
	assignment = JOB_POLICE
	rank = JOB_POLICE
	paygrade = "E6"
	role_comm_title = "MP"
	skills = /datum/skills/MP

	utility_under = list(/obj/item/clothing/under/marine/mp)
	utility_hat = list(/obj/item/clothing/head/helmet/beret/marine/mp)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

/datum/equipment_preset/uscm_ship/uscm_police/mp/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mmpo(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/beret/marine/mp(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/warden
	name = "USCM Military Warden (MW)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/silver

	access = list(
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_LOGISTICS,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_WO,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_COMMANDER,
		ACCESS_MARINE_MORGUE,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING
	)
	assignment = JOB_WARDEN
	rank = JOB_WARDEN
	paygrade = "O2"
	role_comm_title = "MW"
	skills = /datum/skills/CMP

	utility_under = list(/obj/item/clothing/under/marine/warden)
	utility_hat = list(/obj/item/clothing/head/helmet/beret/marine/mp/warden)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

/datum/equipment_preset/uscm_ship/uscm_police/warden/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mmpo(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/warden(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/warden(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/beret/marine/mp/warden(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/cmp
	name = "USCM Chief MP (CMP)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/silver

	access = list(
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_LOGISTICS,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_WO,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_COMMANDER,
		ACCESS_MARINE_MORGUE,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING
	)
	assignment = JOB_CHIEF_POLICE
	rank = JOB_CHIEF_POLICE
	paygrade = "O3"
	role_comm_title = "CMP"
	skills = /datum/skills/CMP

	utility_under = list(/obj/item/clothing/under/marine/officer/warrant)
	utility_hat = list(/obj/item/clothing/head/helmet/beret/marine/mp/cmp)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

/datum/equipment_preset/uscm_ship/uscm_police/cmp/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmpcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/warrant(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/WO(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/beret/marine/mp/cmp(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/riot_mp
	name = "USCM Riot MP (RMP)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list()
	assignment = "Riot Control"
	rank = "Riot"
	paygrade = "E6"
	role_comm_title = "RMP"
	skills = /datum/skills/CMP

	utility_under = list(/obj/item/clothing/under/marine/officer/warrant)
	utility_hat = list(/obj/item/clothing/head/helmet/beret/marine/mp/cmp)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

/datum/equipment_preset/uscm_ship/uscm_police/riot_mp/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_ship/uscm_police/riot_mp/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmpcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/warrant(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/riot/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/riot(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat/riot(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/flashbangs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/with_beanbags(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/with_beanbags(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/riot_mp/riot_cmp
	name = "USCM Riot Chief MP (RCMP)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Chief Riot Control"
	rank = "CRMP"
	paygrade = "E7"
	role_comm_title = "CRMP"
	skills = /datum/skills/CMP