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

	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover/officer)
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/dress)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/liaison
	name = "USCM Corporate Liaison (CL)"
	faction = FACTION_WY
	faction_group =	FACTION_LIST_MARINE_WY
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_CIVILIAN

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
	paygrades = list(PAY_SHORT_WYC2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_WYC3 = JOB_PLAYTIME_TIER_2, PAY_SHORT_WYC4 = JOB_PLAYTIME_TIER_3, PAY_SHORT_WYC5 = JOB_PLAYTIME_TIER_4)
	role_comm_title = "CL"
	skills = /datum/skills/civilian

	minimap_icon = "cl"
	minimap_background = "background_goon"

/datum/equipment_preset/uscm_ship/liaison/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_LIAISON)

/datum/equipment_preset/uscm_ship/liaison/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel/lockable/liaison
	//There is no suitable backpack for a CL really...
	//if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		//back_item = /obj/item/storage/backpack

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcl(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/ivy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/reporter
	name = "Combat Correspondent (Press)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_CIVILIAN

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
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	role_comm_title = "PRESS"
	skills = /datum/skills/civilian
	idtype = /obj/item/card/id/silver/cl

	minimap_icon = "correspondent"
	minimap_background = "background_civillian"
	dress_under = list()
	dress_over = list()
	dress_hat = list()

/datum/equipment_preset/uscm_ship/reporter/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/reporter(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/reporter(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/reporter(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK) // Needs backpack for loadout gear to spawn

/datum/equipment_preset/uscm_ship/reporter/load_preset(mob/living/carbon/human/new_human, randomise, count_participant, client/mob_client, show_job_gear)
	. = ..()
	new_human.marine_buyable_categories[CIVILIAN_CAN_BUY_BACKPACK] = 1
	new_human.marine_buyable_categories[CIVILIAN_CAN_BUY_UTILITY] = 1

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
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CC"
	skills = /datum/skills/pfc
	idtype = /obj/item/card/id/dogtag

	minimap_icon = "correspondent"
	minimap_background = "background_civillian"

	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

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
	paygrades = list(PAY_SHORT_MO1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_MO2 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "CE"
	minimum_age = 27
	skills = /datum/skills/CE

	minimap_icon = "ce"
	minimap_background = "background_command"

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
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "MT"
	skills = /datum/skills/MT

	minimap_icon = "mt"
	minimap_background = "background_shipside"

	utility_under = list(/obj/item/clothing/under/marine/officer/engi)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

/datum/equipment_preset/uscm_ship/maint/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/tech
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine/tech

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

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
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "OT"
	skills = /datum/skills/OT

	minimap_icon = "ot"
	minimap_background = "background_shipside"

	utility_under = list(/obj/item/clothing/under/marine/officer/engi)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

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
	paygrades = list(PAY_SHORT_ME6 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME8 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "QM"
	minimum_age = 27
	skills = /datum/skills/RO

	minimap_icon = "cargo"
	minimap_background = "background_command"

	utility_under = list(/obj/item/clothing/under/rank/qm_suit)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

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

	access = list(ACCESS_MARINE_CARGO)
	assignment = JOB_CARGO_TECH
	rank = JOB_CARGO_TECH
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "CT"
	skills = /datum/skills/CT

	minimap_icon = "cargo"
	minimap_background = "background_shipside"

	utility_under = list(/obj/item/clothing/under/rank/cargotech)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

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

//*****************************************************************************************************/


//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/xo
	name = "USCM Executive Officer (XO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	assignment = JOB_XO
	rank = JOB_XO
	paygrades = list(PAY_SHORT_MO3 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "XO"
	minimum_age = 35
	skills = /datum/skills/XO

	minimap_icon = "xo"
	minimap_background = "background_command"

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
	paygrades = list(PAY_SHORT_MO1 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SO"
	minimum_age = 25
	skills = /datum/skills/SO

	minimap_icon = "so"
	minimap_background = "background_command"

/datum/equipment_preset/uscm_ship/so/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
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
	assignment = JOB_SEA
	rank = JOB_SEA
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SEA"
	minimum_age = 40
	skills = /datum/skills/SEA

	minimap_icon = "sea"
	minimap_background = "background_command"

	service_hat = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/drillhat)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

/datum/equipment_preset/uscm_ship/sea/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_MAIN)

/datum/equipment_preset/uscm_ship/sea/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/sea(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/custom(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/drillhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flash(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/whistle(new_human), WEAR_R_HAND)

/datum/equipment_preset/uscm_ship/sea/load_rank(mob/living/carbon/human/rankee, client/mob_client)
	mob_client?.toggle_newplayer_ic_hud(TRUE)
	if(rankee?.client?.prefs?.pref_special_job_options[rank])
		var/paygrade_choice = get_paygrade_id_by_name(rankee.client.prefs.pref_special_job_options[rank])
		return paygrade_choice
	..()

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/auxiliary_officer
	name = "USCM Auxiliary Support Officer (ASO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	assignment = JOB_AUXILIARY_OFFICER
	rank = JOB_AUXILIARY_OFFICER
	paygrades = list(PAY_SHORT_MO2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_MO3 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "ASO"
	minimum_age = 27
	skills = /datum/skills/auxiliary_officer

	minimap_icon = "aso"
	minimap_background = "background_command"

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

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/aso(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/gp
	name = "USCM Gunship Pilot (GP) (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_PILOT)
	assignment = JOB_CAS_PILOT
	rank = JOB_CAS_PILOT
	paygrades = list(PAY_SHORT_MO1 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "GP"
	skills = /datum/skills/pilot

	minimap_icon = "gp"
	minimap_background = "background_command"

/datum/equipment_preset/uscm_ship/gp/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/po(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/gp/full
	name = "USCM Gunship Pilot (GP)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/pilot)

/datum/equipment_preset/uscm_ship/gp/full/load_gear(mob/living/carbon/human/new_human)
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

/datum/equipment_preset/uscm_ship/dp
	name = "USCM Dropship Pilot (DP) (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_PILOT)
	assignment = JOB_DROPSHIP_PILOT
	rank = JOB_DROPSHIP_PILOT
	paygrades = list(PAY_SHORT_MO1 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "DP"
	skills = /datum/skills/pilot

	minimap_icon = "pilot"
	minimap_background = "background_command"

/datum/equipment_preset/uscm_ship/dp/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/po(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/dp/full
	name = "USCM Dropship Pilot (DP)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/pilot)

/datum/equipment_preset/uscm_ship/dp/full/load_gear(mob/living/carbon/human/new_human)
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
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME6 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "DCC"
	skills = /datum/skills/crew_chief

	minimap_icon = "dcc"
	minimap_background = "background_shipside"

	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

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
	paygrades = list(PAY_SHORT_MO3 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Cpt"
	minimum_age = 40
	skills = /datum/skills/commander

	utility_hat = list(/obj/item/clothing/head/beret/cm)
	utility_gloves = list(/obj/item/clothing/gloves/marine)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm/tan)

	service_hat = list(/obj/item/clothing/head/beret/cm)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)

	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)

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
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "MST"
	skills = /datum/skills/mess_technician

	minimap_icon = "mst"
	minimap_background = "background_shipside"

	utility_under = list(/obj/item/clothing/under/marine/chef)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

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
