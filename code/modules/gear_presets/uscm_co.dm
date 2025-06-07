/datum/equipment_preset/uscm_co
	name = "USCM Commanding Officer (CO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE

	idtype = /obj/item/card/id/gold
	assignment = JOB_CO
	job_title = JOB_CO
	paygrades = list(PAY_SHORT_MO4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CO"
	minimum_age = 30
	skills = /datum/skills/commander
	var/whitelist_level = WHITELIST_NORMAL


	var/list/equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/bridge,
		WEAR_L_STORE = /obj/item/storage/pouch/pistol/command,
		WEAR_R_STORE = /obj/item/storage/pouch/general/large,
		WEAR_FEET =	/obj/item/clothing/shoes/marine/knife,
	)


	utility_under = list(/obj/item/clothing/under/marine, /obj/item/clothing/under/marine/officer/command, /obj/item/clothing/under/marine/officer/boiler)
	utility_hat = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm/tan)
	utility_extra = list(/obj/item/clothing/glasses/sunglasses, /obj/item/clothing/glasses/sunglasses/big, /obj/item/clothing/glasses/sunglasses/aviator, /obj/item/clothing/glasses/mbcg)

	service_under = list(/obj/item/clothing/under/marine/officer/formal/gray, /obj/item/clothing/under/marine/officer/formal/turtleneck)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)
	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/patchless)
	service_hat = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/marine/commander/dress, /obj/item/clothing/head/beret/marine/commander/black, /obj/item/clothing/head/marine/peaked/service)

	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer, /obj/item/clothing/suit/storage/jacket/marine/dress)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover/officer)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)
	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)

	minimap_icon = "co"
	minimap_background = "background_command"


/datum/equipment_preset/uscm_co/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/datum/equipment_preset/uscm_co/load_race(mob/living/carbon/human/new_human, client/mob_client)
	..()
	ADD_TRAIT(new_human, TRAIT_EMOTE_CD_EXEMPT, TRAIT_SOURCE_JOB)


/datum/equipment_preset/uscm_co/load_gear(mob/living/carbon/human/new_human)
	var/sidearm = "Mateba"
	var/kit = null
	var/sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
	var/back_item = /obj/item/storage/backpack/satchel/lockable

	if(new_human.client && new_human.client.prefs)
		sidearm = new_human.client.prefs.commander_sidearm
		switch(sidearm)
			if(CO_GUN_MATEBA)
				sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
				kit = /obj/item/storage/mateba_case/captain
			if(CO_GUN_MATEBA_SPECIAL)
				sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/special
			if(CO_GUN_MATEBA_COUNCIL)
				sidearmpath = /obj/item/storage/belt/gun/mateba/council/full
				kit = /obj/item/storage/mateba_case/captain/council
			if(CO_GUN_DEAGLE)
				sidearmpath = /obj/item/storage/belt/gun/m4a3/heavy/co
			if(CO_GUN_DEAGLE_COUNCIL)
				sidearmpath = /obj/item/storage/belt/gun/m4a3/heavy/co_golden
	switch(whitelist_level)
		if(WHITELIST_COUNCIL)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/council(new_human), WEAR_HEAD)
		if(WHITELIST_LEADER)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/councilchief(new_human), WEAR_HEAD)
	. = ..()


	for(var/equipment in equipment_to_spawn)
		var/equipment_path = islist(equipment_to_spawn[equipment]) ? pick(equipment_to_spawn[equipment]) : equipment_to_spawn[equipment]
		new_human.equip_to_slot_or_del(new equipment_path(new_human), equipment)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom/co(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/command(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new sidearmpath(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)

	if(kit)
		new_human.equip_to_slot_or_del(new kit(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm_co/infantry
	name = "Shipside - CO - Infantry"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap/req/ro,
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
		WEAR_L_HAND = /obj/item/device/binoculars/range/designator,
		WEAR_R_STORAGE = /obj/item/storage/pouch/general/large,
		WEAR_JACKET = /obj/item/clothing/suit/storage/webbing,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/formal/gray,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses
	)

/datum/equipment_preset/uscm_co/infantry/council
	name = "Shipside - CO - Infantry - COUNCIL"
	idtype = /obj/item/card/id/gold/council
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_COUNCIL

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/infantry/council/plus
	name = "Shipside - CO - Infantry - SENATOR"
	idtype = /obj/item/card/id/general
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_LEADER

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/intel

	name = "Shipside - CO - Intel"
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/beret/marine/commander/black,
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/formal/turtleneck,
		WEAR_FACE = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black,
		WEAR_JACKET = /obj/item/clothing/suit/storage/utility_vest,
		WEAR_FEET =   /obj/item/clothing/shoes/marine/knife,
		WEAR_HANDS = /obj/item/clothing/gloves/marine/black,
	)

/datum/equipment_preset/uscm_co/intel/council

	name = "Shipside - CO - Intel - COUNCIL"
	idtype = /obj/item/card/id/gold/council
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_COUNCIL

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/intel/council/plus
	name = "Shipside - CO - Intel - SENATOR"
	idtype = /obj/item/card/id/general
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_LEADER

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/medical

	name = "Shipside - CO - Medical"
	equipment_to_spawn = list(
		WEAR_HEAD =	/obj/item/clothing/head/beret/marine/commander/dress,
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/command,
		WEAR_JACKET = /obj/item/clothing/suit/storage/jacket/marine/dress/officer/patchless,
		WEAR_FEET = /obj/item/clothing/shoes/white,
		WEAR_HANDS = /obj/item/clothing/gloves/white,
	)

/datum/equipment_preset/uscm_co/medical/council

	name = "Shipside - CO - Medical - COUNCIL"
	idtype = /obj/item/card/id/gold/council
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_COUNCIL

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/medical/council/plus
	name = "Shipside - CO - Medical - SENATOR"
	idtype = /obj/item/card/id/general
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_LEADER

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/aviation

	name = "Shipside - CO - Aviation"
	equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/formal/turtleneck,
		WEAR_L_STORE = /obj/item/storage/pouch/pistol/command,
		WEAR_R_STORE = /obj/item/storage/pouch/general/large,
		WEAR_FEET =	/obj/item/clothing/shoes/marine/knife,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_HEAD = /obj/item/clothing/head/beret/marine/commander/black,
		WEAR_JACKET = /obj/item/clothing/suit/storage/jacket/marine/pilot,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/aviator,
	)

/datum/equipment_preset/uscm_co/aviation/council

	name = "Shipside - CO - Aviation - COUNCIL"
	idtype = /obj/item/card/id/gold/council
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_COUNCIL

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/aviation/council/plus
	name = "Shipside - CO - Aviation - SENATOR"
	idtype = /obj/item/card/id/general
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_LEADER

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/tanker

	name = "Shipside - CO - Tanker"
	equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_L_STORE = /obj/item/storage/pouch/pistol/command,
		WEAR_R_STORE = /obj/item/storage/pouch/general/large,
		WEAR_FEET =	/obj/item/clothing/shoes/marine/knife,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_JACKET = /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/boiler,
		WEAR_FACE = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan,
		WEAR_HEAD = /obj/item/clothing/head/cmcap/req/ro,
	)

/datum/equipment_preset/uscm_co/tanker/council
	name = "Shipside - CO - Tanker - COUNCIL"
	idtype = /obj/item/card/id/gold/council
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_COUNCIL

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)


/datum/equipment_preset/uscm_co/tanker/council/plus
	name = "Shipside - CO - Tanker - SENATOR"
	idtype = /obj/item/card/id/general
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_LEADER


	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/engineering

	name = "Shipside - CO - Engineering"
	equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_L_STORE = /obj/item/storage/pouch/pistol/command,
		WEAR_R_STORE = /obj/item/storage/pouch/general/large,
		WEAR_FEET =	/obj/item/clothing/shoes/marine/knife,
		WEAR_HANDS = /obj/item/clothing/gloves/yellow,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/command,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/storage/tool_webbing,
		WEAR_JACKET = /obj/item/clothing/suit/storage/utility_vest,
		WEAR_HEAD = /obj/item/clothing/head/beret/eng,
	)

/datum/equipment_preset/uscm_co/engineering/council
	name = "Shipside - CO - Engineering - COUNCIL"
	idtype = /obj/item/card/id/gold/council
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_COUNCIL

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/engineering/council/plus
	name = "Shipside - CO - Engineering - SENATOR"
	idtype = /obj/item/card/id/general
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_LEADER

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/logistics
	name = "Shipside - CO - Logistics"
	equipment_to_spawn = list(
		WEAR_L_EAR = /obj/item/device/radio/headset/almayer/mcom/cdrcom/co,
		WEAR_L_STORE = /obj/item/storage/pouch/pistol/command,
		WEAR_R_STORE = /obj/item/storage/pouch/general/large,
		WEAR_FEET =	/obj/item/clothing/shoes/marine/knife,
		WEAR_HANDS = /obj/item/clothing/gloves/yellow,
		WEAR_BODY = /obj/item/clothing/under/marine/officer/command,
		WEAR_ACCESSORY = /obj/item/clothing/accessory/storage/tool_webbing,
		WEAR_JACKET = /obj/item/clothing/suit/storage/jacket/marine/vest/tan,
		WEAR_HEAD = /obj/item/clothing/head/beret/cm/tan,
	)

/datum/equipment_preset/uscm_co/logistics/council
	name = "Shipside - CO - Logistics - COUNCIL"
	idtype = /obj/item/card/id/gold/council
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_COUNCIL

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/logistics/council/plus
	name = "Shipside - CO - Logistics - SENATOR"
	idtype = /obj/item/card/id/general
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)
	whitelist_level = WHITELIST_LEADER

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/visitor
	name = "USCM Observer (Major) (VO)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_USCM_OBSV
	job_title = JOB_USCM_OBSV
	role_comm_title = "VO"
	minimap_background = "background_medical_WO"

/datum/equipment_preset/uscm_co/council
	name = "USCM Commanding Officer (CO+)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/gold/council
	job_title = JOB_CO
	paygrades = list(PAY_SHORT_MO5 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CO"
	minimum_age = 35


	dress_over = list(
		/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer,
		/obj/item/clothing/suit/storage/jacket/marine/dress/officer/falcon,
		/obj/item/clothing/suit/storage/jacket/marine/dress,
	)

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

/datum/equipment_preset/uscm_co/council/plus
	name = "USCM Commanding Officer (CO++)"
	idtype = /obj/item/card/id/general
	paygrades = list(PAY_SHORT_MO6 = JOB_PLAYTIME_TIER_0)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior, /obj/item/clothing/under/marine/dress/blues/general)

	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/commander, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)
