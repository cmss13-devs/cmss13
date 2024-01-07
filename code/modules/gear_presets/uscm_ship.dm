/datum/equipment_preset/uscm_ship
	name = "USCM (ship roles)"
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	minimum_age = 20
	languages = list(LANGUAGE_ENGLISH)

	utility_under = list(/obj/item/clothing/under/marine/officer/command)
	utility_hat = list(/obj/item/clothing/head/cmcap)
	utility_gloves = list(/obj/item/clothing/gloves/marine)
	utility_shoes = list(/obj/item/clothing/shoes/marine/knife)
	utility_extra = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

	service_under = list(/obj/item/clothing/under/marine/officer/bridge)
	service_over = list(/obj/item/clothing/suit/storage/jacket/marine/service, /obj/item/clothing/suit/storage/jacket/marine/service/mp)
	service_hat = list(/obj/item/clothing/head/cmcap)
	service_shoes = list(/obj/item/clothing/shoes/dress)

	dress_under = list(/obj/item/clothing/under/marine/dress)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress)
	dress_hat = list(/obj/item/clothing/head/marine/peaked)
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/dress)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/liaison
	name = "USCM Corporate Liaison (CL)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver/cl
	access = list(
		ACCESS_WY_GENERAL,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_MEDBAY,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_WY_FLIGHT,
		ACCESS_CIVILIAN_COMMAND,
	)
	assignment = JOB_CORPORATE_LIAISON
	rank = JOB_CORPORATE_LIAISON
	paygrade = PAY_SHORT_WYC2
	role_comm_title = "CL"
	skills = /datum/skills/civilian

	minimap_icon = "cl"
	minimap_background = MINIMAP_ICON_BACKGROUND_CIVILIAN

	utility_under = list(/obj/item/clothing/under/liaison_suit/outing)
	utility_hat = list()
	utility_gloves = list()
	utility_shoes = list(/obj/item/clothing/shoes/laceup)
	utility_extra = list(/obj/item/clothing/under/liaison_suit/suspenders)

	service_under = list(/obj/item/clothing/under/liaison_suit)
	service_over = list()
	service_hat = list()
	service_shoes = list(/obj/item/clothing/shoes/laceup)

	dress_under = list(/obj/item/clothing/under/liaison_suit/formal)
	dress_over = list()
	dress_hat = list()
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/laceup)

/datum/equipment_preset/uscm_ship/liaison/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_LIAISON)

/datum/equipment_preset/uscm_ship/liaison/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel/lockable/liaison
	//There is no suitable backpack for a CL really...
	//if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		//back_item = /obj/item/storage/backpack

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcl(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

/datum/equipment_preset/uscm_ship/liaison/load_rank(mob/living/carbon/human/new_human)
	if(new_human.client)
		var/playtime = get_job_playtime(new_human.client, rank)
		if(new_human.client.prefs.playtime_perks)
			if(playtime > JOB_PLAYTIME_TIER_4)
				return PAY_SHORT_WYC5
			else if(playtime > JOB_PLAYTIME_TIER_3)
				return PAY_SHORT_WYC4
			else if(playtime > JOB_PLAYTIME_TIER_2)
				return PAY_SHORT_WYC3
			else
				return paygrade
	return paygrade

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/reporter
	name = "Combat Correspondent"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_MEDBAY,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_PRESS,
	)
	assignment = JOB_COMBAT_REPORTER
	rank = JOB_COMBAT_REPORTER
	paygrade = PAY_SHORT_CIV
	role_comm_title = "PRESS"
	skills = /datum/skills/civilian
	idtype = /obj/item/card/id/silver/cl

	minimap_icon = "correspondent"
	minimap_background = MINIMAP_ICON_BACKGROUND_CIVILIAN

/datum/equipment_preset/uscm_ship/reporter/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/reporter(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/reporter(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/reporter(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera_film(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm_ship/reporter_uscm
	name = "Combat Correspondent"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE
	access = list(
		ACCESS_MARINE_COMMAND,
		ACCESS_PRESS,
		ACCESS_MARINE_PREP,
	)
	assignment = JOB_COMBAT_REPORTER
	rank = JOB_COMBAT_REPORTER
	paygrade = PAY_SHORT_ME4
	role_comm_title = "CC"
	skills = /datum/skills/pfc
	idtype = /obj/item/card/id/dogtag

	minimap_icon = "correspondent"
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uscm_ship/reporter_uscm/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	var/obj/item/clothing/under/marine/uniform = new()
	uniform.attach_accessory(new_human, new /obj/item/clothing/accessory/storage/black_vest/brown_vest)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/reporter(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera_film(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/chief_engineer
	name = "USCM Chief Engineer (CE)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_CE,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_COMMAND,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_MARINE_DATABASE,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
		ACCESS_MARINE_SYNTH,
		ACCESS_MARINE_AI,
	)
	assignment = JOB_CHIEF_ENGINEER
	rank = JOB_CHIEF_ENGINEER
	paygrade = PAY_SHORT_MO1
	role_comm_title = "CE"
	minimum_age = 27
	skills = /datum/skills/CE

	minimap_icon = list("engi" = MINIMAP_ICON_COLOR_HEAD)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

	utility_under = list(/obj/item/clothing/under/marine/officer/ce)

/datum/equipment_preset/uscm_ship/chief_engineer/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/tech
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine/tech

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ce(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/ce(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/electronics(new_human), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/maint
	name = "USCM Maintenance Technician (MT)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_ENGINEERING,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_MARINE_MAINT,
	)
	assignment = JOB_MAINT_TECH
	rank = JOB_MAINT_TECH
	paygrade = PAY_SHORT_ME2
	role_comm_title = "MT"
	skills = /datum/skills/MT

	minimap_icon = "engi"

	utility_under = list(/obj/item/clothing/under/marine/officer/engi)

/datum/equipment_preset/uscm_ship/maint/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/tech
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine/tech

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/demo_scanner(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/bag/trash(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/welder_chestrig, (new_human), WEAR_R_HAND)

/datum/equipment_preset/uscm_ship/maint/load_rank(mob/living/carbon/human/new_human)
	if(new_human.client)
		if(get_job_playtime(new_human.client, rank) < JOB_PLAYTIME_TIER_1)
			return PAY_SHORT_ME1
	return paygrade

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/ordn
	name = "USCM Ordnance Technician (OT)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_ENGINEERING,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,

	)
	assignment = JOB_ORDNANCE_TECH
	rank = JOB_ORDNANCE_TECH
	paygrade = PAY_SHORT_ME2
	role_comm_title = "OT"
	skills = /datum/skills/OT

	minimap_icon = "ot"

	utility_under = list(/obj/item/clothing/under/marine/officer/engi)

/datum/equipment_preset/uscm_ship/ordn/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/tech
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine/tech

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi/OT(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/demo_scanner(new_human), WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/qm
	name = "USCM Quartermaster (QM)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_CARGO,
		ACCESS_MARINE_RO,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_PREP,
	)
	assignment = JOB_CHIEF_REQUISITION
	rank = JOB_CHIEF_REQUISITION
	paygrade = PAY_SHORT_ME7
	role_comm_title = "QM"
	minimum_age = 27
	skills = /datum/skills/RO

	minimap_background = MINIMAP_ICON_BACKGROUND_CIC
	minimap_icon = list("ct" = MINIMAP_ICON_COLOR_HEAD)

	utility_under = list(/obj/item/clothing/under/rank/qm_suit)

/datum/equipment_preset/uscm_ship/qm/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/tech
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/industrial

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/qm(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/qm_suit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/req/ro(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flash(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/cargo
	name = "USCM Cargo Technician (CT)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_CARGO, ACCESS_MARINE_PREP)
	assignment = JOB_CARGO_TECH
	rank = JOB_CARGO_TECH
	paygrade = PAY_SHORT_ME2
	role_comm_title = "CT"
	skills = /datum/skills/CT

	minimap_icon = "ct"

	utility_under = list(/obj/item/clothing/under/rank/cargotech)

/datum/equipment_preset/uscm_ship/cargo/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/tech
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/industrial

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ct(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargotech(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/req(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)

/datum/equipment_preset/uscm_ship/cargo/load_rank(mob/living/carbon/human/new_human)
	if(new_human.client)
		if(get_job_playtime(new_human.client, rank) < JOB_PLAYTIME_TIER_1)
			return PAY_SHORT_ME1
	return paygrade

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/commander
	name = "USCM Commanding Officer (CO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/gold
	assignment = JOB_CO
	rank = JOB_CO
	paygrade = PAY_SHORT_MO4
	role_comm_title = "CO"
	minimum_age = 30
	skills = /datum/skills/commander

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_COMMANDER)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

	utility_under = list(/obj/item/clothing/under/marine, /obj/item/clothing/under/marine/officer/command, /obj/item/clothing/under/marine/officer/boiler)
	utility_hat = list(/obj/item/clothing/head/cmcap,/obj/item/clothing/head/beret/cm/tan)
	utility_extra = list(/obj/item/clothing/glasses/sunglasses,/obj/item/clothing/glasses/sunglasses/big,/obj/item/clothing/glasses/sunglasses/aviator,/obj/item/clothing/glasses/mbcg)

	service_under = list(/obj/item/clothing/under/marine/officer/formal/white, /obj/item/clothing/under/marine/officer/formal/black)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)
	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)
	service_hat = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/marine/commander/dress, /obj/item/clothing/head/beret/marine/commander/black, /obj/item/clothing/head/marine/peaked/service)

	dress_under = list(/obj/item/clothing/under/marine/dress, /obj/item/clothing/under/marine/officer/formal/servicedress)
	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)
	dress_hat = list(/obj/item/clothing/head/marine/peaked/captain/white, /obj/item/clothing/head/marine/peaked/captain/black, /obj/item/clothing/head/marine/peaked)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/white, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/black, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/suit, /obj/item/clothing/suit/storage/jacket/marine/dress)

/datum/equipment_preset/uscm_ship/commander/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/datum/equipment_preset/uscm_ship/commander/load_race(mob/living/carbon/human/new_human, client/mob_client)
	..()
	ADD_TRAIT(new_human, TRAIT_EMOTE_CD_EXEMPT, TRAIT_SOURCE_JOB)

/datum/equipment_preset/uscm_ship/commander/load_gear(mob/living/carbon/human/new_human)
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

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress/commander(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new sidearmpath(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/command(new_human), WEAR_L_STORE)
	if(kit)
		new_human.equip_to_slot_or_del(new kit(new_human), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/commander/council
	name = "USCM Commanding Officer (CO+)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/gold/council
	rank = JOB_CO
	paygrade = PAY_SHORT_MO5
	role_comm_title = "CO"
	minimum_age = 35

	dress_over = list(
		/obj/item/clothing/suit/storage/jacket/marine/dress/officer/white,
		/obj/item/clothing/suit/storage/jacket/marine/dress/officer/black,
		/obj/item/clothing/suit/storage/jacket/marine/dress/officer/suit,
		/obj/item/clothing/suit/storage/jacket/marine/dress/officer/falcon,
	)

/datum/equipment_preset/uscm_ship/commander/council/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/council(new_human), WEAR_HEAD)
	. = ..()

/datum/equipment_preset/uscm_ship/commander/council/plus
	name = "USCM Commanding Officer (CO++)"
	idtype = /obj/item/card/id/general
	paygrade = PAY_SHORT_MO6

/datum/equipment_preset/uscm_ship/commander/council/plus/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/councilchief(new_human), WEAR_HEAD)
	. = ..()

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/xo
	name = "USCM Executive Officer (XO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	assignment = JOB_XO
	rank = JOB_XO
	paygrade = PAY_SHORT_MO3
	role_comm_title = "XO"
	minimum_age = 35
	skills = /datum/skills/XO

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_HEAD)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)

/datum/equipment_preset/uscm_ship/xo/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_MAIN)

/datum/equipment_preset/uscm_ship/xo/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/marine/peaked/service(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/so
	name = "USCM Staff Officer (SO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SO
	rank = JOB_SO
	paygrade = PAY_SHORT_MO1
	role_comm_title = "SO"
	minimum_age = 25
	skills = /datum/skills/SO

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_BRONZE)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uscm_ship/so/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/bridge(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_L_HAND)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/sea
	name = "USCM Senior Enlisted Advisor (SEA)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access
	assignment = JOB_SEA
	rank = JOB_SEA
	paygrade = PAY_SHORT_ME7
	role_comm_title = "SEA"
	minimum_age = 40
	skills = /datum/skills/SEA

	minimap_icon = "sea"

	service_hat = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/drillhat)

/datum/equipment_preset/uscm_ship/sea/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_MAIN)

/datum/equipment_preset/uscm_ship/sea/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/custom(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/drillhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flash(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/whistle(new_human), WEAR_R_HAND)

/datum/equipment_preset/uscm_ship/sea/load_rank(mob/living/carbon/human/rankee)
	if(rankee?.client?.prefs?.pref_special_job_options[rank])
		paygrade = get_paygrade_id_by_name(rankee.client.prefs.pref_special_job_options[rank])

	return paygrade

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/auxiliary_officer
	name = "USCM Auxiliary Support Officer (ASO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	assignment = JOB_AUXILIARY_OFFICER
	rank = JOB_AUXILIARY_OFFICER
	paygrade = PAY_SHORT_MO2
	role_comm_title = "ASO"
	minimum_age = 27
	skills = /datum/skills/auxiliary_officer

	minimap_icon = list("cic" = MINIMAP_ICON_COLOR_SILVER)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uscm_ship/auxiliary_officer/New()
	. = ..()
	access = list(
		ACCESS_MARINE_SENIOR,
		ACCESS_MARINE_DATABASE,
		ACCESS_MARINE_ASO,
		ACCESS_MARINE_COMMAND,
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_ARMORY,
		ACCESS_MARINE_MEDBAY,
		ACCESS_MARINE_CE,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
		ACCESS_MARINE_RO,
		ACCESS_MARINE_CARGO,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_PILOT,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_KITCHEN,
		ACCESS_PRESS,
	)

/datum/equipment_preset/uscm_ship/auxiliary_officer/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/alt(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/aso(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/po
	name = "USCM Pilot (DP) (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_PILOT)
	assignment = JOB_PILOT
	rank = JOB_PILOT
	paygrade = PAY_SHORT_MO1
	role_comm_title = "DP"
	skills = /datum/skills/pilot

	minimap_icon = "pilot"

/datum/equipment_preset/uscm_ship/po/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/po(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/po/full
	name = "USCM Pilot Officer (PO)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/pilot)

/datum/equipment_preset/uscm_ship/po/full/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/po(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/pilot(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/pilot(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/dcc
	name = "USCM Dropship Crew Chief (DCC) (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_PILOT)
	assignment = JOB_DROPSHIP_CREW_CHIEF
	rank = JOB_DROPSHIP_CREW_CHIEF
	paygrade = PAY_SHORT_ME5
	role_comm_title = "DCC"
	skills = /datum/skills/crew_chief

	minimap_icon = "dcc"

/datum/equipment_preset/uscm_ship/dcc/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/po(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot/dcc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/dcc/full
	name = "USCM Dropship Crew Chief (DCC)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/pilot/dcc)

/datum/equipment_preset/uscm_ship/dcc/full/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/po(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot/dcc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/dcc(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/officer
	name = "USCM Officer (USCM Command)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/general
	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = "USCM Officer"
	rank = "USCM Officer"
	paygrade = PAY_SHORT_MO3
	role_comm_title = "Cpt"
	minimum_age = 40
	skills = /datum/skills/commander

	utility_hat = list(/obj/item/clothing/head/beret/cm)
	utility_gloves = list(/obj/item/clothing/gloves/marine/techofficer/commander)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm/tan)

	service_hat = list(/obj/item/clothing/head/beret/cm)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)

	dress_extra = list(/obj/item/clothing/head/beret/marine/commander/dress, /obj/item/storage/large_holster/ceremonial_sword/full)
	dress_hat = list(/obj/item/clothing/head/marine/peaked/captain)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)

/datum/equipment_preset/uscm_ship/officer/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/datum/equipment_preset/uscm_ship/officer/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	new_human.equip_if_possible(new /obj/item/clothing/under/rank/centcom/officer(new_human), WEAR_BODY)
	new_human.equip_if_possible(new /obj/item/clothing/shoes/centcom(new_human), WEAR_FEET)
	new_human.equip_if_possible(new /obj/item/clothing/gloves/white(new_human), WEAR_HANDS)
	new_human.equip_if_possible(new /obj/item/clothing/head/beret/centcom/officer(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)

	new_human.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_if_possible(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/chef
	name = "USCM Mess Technician (MST)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_KITCHEN)
	assignment = JOB_MESS_SERGEANT
	rank = JOB_MESS_SERGEANT
	paygrade = PAY_SHORT_ME2
	role_comm_title = "MST"
	skills = /datum/skills/mess_technician

	minimap_icon = "mst"

	utility_under = list(/obj/item/clothing/under/marine/chef)

/datum/equipment_preset/uscm_ship/chef/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/chef(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/chef(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/chef(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)

/datum/equipment_preset/uscm_ship/chef/load_rank(mob/living/carbon/human/new_human)
	if(new_human.client)
		if(get_job_playtime(new_human.client, rank) < JOB_PLAYTIME_TIER_1)
			return PAY_SHORT_ME1
	return paygrade
