/datum/equipment_preset/uscm_ship/uscm_police
	name = "USCM (police roles)"
	faction = FACTION_MARINE
	minimum_age = 27

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/mp
	name = "USCM Military Police (MP)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_DATABASE,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_MORGUE,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
	)
	assignment = JOB_POLICE
	rank = JOB_POLICE
	paygrade = "ME5"
	role_comm_title = "MP"
	skills = /datum/skills/MP

	minimap_icon = "mp"

	utility_under = list(/obj/item/clothing/under/marine/mp)
	utility_hat = list(/obj/item/clothing/head/beret/marine/mp)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

	service_over = list(/obj/item/clothing/suit/storage/jacket/marine/service/mp)

/datum/equipment_preset/uscm_ship/uscm_police/mp/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mmpo(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

/datum/equipment_preset/uscm_ship/uscm_police/mp/load_rank(mob/living/carbon/human/human)
	if(human.client && get_job_playtime(human.client, rank) < JOB_PLAYTIME_TIER_1)
		return "ME3"
	return paygrade

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/warden
	name = "USCM Military Warden (MW)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/silver

	access = list(
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_DATABASE,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_ARMORY,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_MORGUE,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
	)
	assignment = JOB_WARDEN
	rank = JOB_WARDEN
	paygrade = "MO1"
	role_comm_title = "MW"
	skills = /datum/skills/MW

	minimap_icon = "warden"

	utility_under = list(/obj/item/clothing/under/marine/warden)
	utility_hat = list(/obj/item/clothing/head/beret/marine/mp/warden)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

	service_over = list(/obj/item/clothing/suit/storage/jacket/marine/service/warden)

/datum/equipment_preset/uscm_ship/uscm_police/warden/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmpcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/warden(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/warden(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/warden(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/cmp
	name = "USCM Chief MP (CMP)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/silver

	access = list(
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_DATABASE,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_CMP,
		ACCESS_MARINE_ARMORY,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_SENIOR,
		ACCESS_MARINE_MORGUE,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
		ACCESS_MARINE_SYNTH,
	)
	assignment = JOB_CHIEF_POLICE
	rank = JOB_CHIEF_POLICE
	paygrade = "MO2"
	role_comm_title = "CMP"
	skills = /datum/skills/CMP

	minimap_icon = list("mp" = MINIMAP_ICON_COLOR_HEAD)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

	utility_under = list(/obj/item/clothing/under/marine/officer/warrant)
	utility_hat = list(/obj/item/clothing/head/beret/marine/mp/cmp)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

	service_over = list(/obj/item/clothing/suit/storage/jacket/marine/service/cmp)

/datum/equipment_preset/uscm_ship/uscm_police/cmp/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmpcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/warrant(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/WO(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/cmp(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/riot_mp
	name = "USCM Riot MP (RMP)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list()
	assignment = JOB_RIOT
	rank = JOB_RIOT
	paygrade = "ME5"
	role_comm_title = "RMP"
	skills = /datum/skills/CMP

	utility_under = list(/obj/item/clothing/under/marine/officer/warrant)
	utility_hat = list(/obj/item/clothing/head/beret/marine/mp/cmp)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

/datum/equipment_preset/uscm_ship/uscm_police/riot_mp/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_ship/uscm_police/riot_mp/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmpcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/warrant(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/riot/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/riot(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat/riot(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/flashbangs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large/beanbag/riot(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large/beanbag/riot(H), WEAR_R_STORE)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/uscm_police/riot_mp/riot_cmp
	name = "USCM Riot Chief MP (RCMP)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_RIOT_CHIEF
	rank = JOB_RIOT_CHIEF
	paygrade = "MO1"
	role_comm_title = "CRMP"
	skills = /datum/skills/CMP
