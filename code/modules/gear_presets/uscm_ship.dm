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
		ACCESS_WY_CORPORATE,
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_MEDBAY,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_WY_CORPORATE_DS,
		ACCESS_CIVILIAN_COMMAND,
	)
	assignment = JOB_CORPORATE_LIAISON
	rank = JOB_CORPORATE_LIAISON
	paygrade = "WY-XB-X"
	role_comm_title = "CL"
	skills = /datum/skills/civilian

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

/datum/equipment_preset/uscm_ship/liaison/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/lockable/liaison
	//There is no suitable backpack for a CL really...
	//if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		//backItem = /obj/item/storage/backpack

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcl(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm_ship/liaison/load_rank(mob/living/carbon/human/H)
	if(H.client)
		var/playtime = get_job_playtime(H.client, rank)
		if(H.client.prefs.playtime_perks)
			if(playtime > JOB_PLAYTIME_TIER_4)
				return "WY-XE"
			else if(playtime > JOB_PLAYTIME_TIER_3)
				return "WY-XD"
			else if(playtime > JOB_PLAYTIME_TIER_2)
				return "WY-XC"
			else
				return paygrade
	return paygrade

//*****************************************************************************************************/
/datum/equipment_preset/uscm_ship/liaison/nightmare
	name = "Nightmare USCM Corporate Liaison"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction_group = FACTION_LIST_MARINE_WY

	access = list(ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE, ACCESS_WY_PMC_RED, ACCESS_WY_PMC_BLACK, ACCESS_WY_PMC_WHITE, ACCESS_WY_CORPORATE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/chief_engineer
	name = "USCM Chief Engineer (CE)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_CE,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_BRIDGE,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_MARINE_COMMANDER,
		ACCESS_MARINE_LOGISTICS,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT,
		ACCESS_MARINE_SYNTH
	)
	assignment = JOB_CHIEF_ENGINEER
	rank = JOB_CHIEF_ENGINEER
	paygrade = "MO2"
	role_comm_title = "CE"
	minimum_age = 27
	skills = /datum/skills/CE

	utility_under = list(/obj/item/clothing/under/marine/officer/ce)
	dress_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey)

/datum/equipment_preset/uscm_ship/chief_engineer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ce(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/ce(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/electronics(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/maint
	name = "USCM Maintenance Technician (MT)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_ENGINEERING,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_MARINE_MAINT
	)
	assignment = JOB_MAINT_TECH
	rank = JOB_MAINT_TECH
	paygrade = "ME2"
	role_comm_title = "MT"
	skills = /datum/skills/MT

	utility_under = list(/obj/item/clothing/under/marine/officer/engi)

/datum/equipment_preset/uscm_ship/maint/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/welding(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/demo_scanner(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/bag/trash(H), WEAR_L_HAND)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/ordn
	name = "USCM Ordnance Technician (OT)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_ENGINEERING,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT

	)
	assignment = JOB_ORDNANCE_TECH
	rank = JOB_ORDNANCE_TECH
	paygrade = "ME2"
	role_comm_title = "OT"
	skills = /datum/skills/OT

	utility_under = list(/obj/item/clothing/under/marine/officer/engi)

/datum/equipment_preset/uscm_ship/ordn/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi/OT(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/demo_scanner(H), WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/ro
	name = "USCM Requisitions Officer (RO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_CARGO,
		ACCESS_MARINE_RO,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_LOGISTICS,
		ACCESS_MARINE_COMMANDER,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
		ACCESS_MARINE_PREP
	)
	assignment = JOB_CHIEF_REQUISITION
	rank = JOB_CHIEF_REQUISITION
	paygrade = "MO2"
	role_comm_title = "RO"
	minimum_age = 27
	skills = /datum/skills/RO

	utility_under = list(/obj/item/clothing/under/rank/ro_suit)
	dress_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey)

/datum/equipment_preset/uscm_ship/ro/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ro(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/ro_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/req(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/cargo
	name = "USCM Cargo Technician (CT)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_CARGO, ACCESS_MARINE_PREP)
	assignment = JOB_CARGO_TECH
	rank = JOB_CARGO_TECH
	paygrade = "ME2"
	role_comm_title = "CT"
	skills = /datum/skills/CT

	utility_under = list(/obj/item/clothing/under/rank/cargotech)

/datum/equipment_preset/uscm_ship/cargo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ct(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargotech(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beanie(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/commander
	name = "USCM Commanding Officer (CO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/gold
	assignment = JOB_CO
	rank = JOB_CO
	paygrade = "MO4"
	role_comm_title = "CO"
	minimum_age = 30
	skills = /datum/skills/commander

	utility_under = list(/obj/item/clothing/under/marine,/obj/item/clothing/under/marine/officer/command)
	utility_hat = list(/obj/item/clothing/head/cmcap,/obj/item/clothing/head/beret/cm/tan)
	utility_extra = list(/obj/item/clothing/glasses/sunglasses,/obj/item/clothing/glasses/sunglasses/big,/obj/item/clothing/glasses/sunglasses/aviator,/obj/item/clothing/glasses/mbcg)

	service_under = list(/obj/item/clothing/under/marine/officer/formal/white, /obj/item/clothing/under/marine/officer/formal/black)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)
	service_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)
	service_hat = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/marine/commander/dress, /obj/item/clothing/head/beret/marine/commander/black)

	dress_under = list(/obj/item/clothing/under/marine/dress, /obj/item/clothing/under/marine/officer/formal/servicedress)
	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)
	dress_hat = list(/obj/item/clothing/head/marine/peaked/captain/white, /obj/item/clothing/head/marine/peaked/captain/black)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/white, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/black, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/suit, /obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey, /obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat)

/datum/equipment_preset/uscm_ship/commander/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/uscm_ship/commander/load_gear(mob/living/carbon/human/H)
	var/sidearm = "Mateba"
	var/kit = null
	var/sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
	var/backItem = /obj/item/storage/backpack/satchel/lockable

	if(H.client && H.client.prefs)
		sidearm = H.client.prefs.commander_sidearm
		switch(sidearm)
			if("Mateba")
				sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
				kit = /obj/item/storage/mateba_case/captain
			if("Colonel's Mateba")
				sidearmpath = /obj/item/storage/belt/gun/mateba/council/full
				kit = /obj/item/storage/mateba_case/captain/council
			if("Desert Eagle")
				sidearmpath = /obj/item/storage/belt/gun/m4a3/heavy/co
			if("Golden Desert Eagle")
				sidearmpath = /obj/item/storage/belt/gun/m4a3/heavy/co_golden
			if("M4A3 Custom")
				sidearmpath = /obj/item/storage/belt/gun/m4a3/commander
			if("VP78")
				sidearmpath = /obj/item/storage/belt/gun/m4a3/vp78

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress/commander(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new sidearmpath(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/command(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(H), WEAR_L_HAND)
	if(kit)
		H.equip_to_slot_or_del(new kit(H), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/commander/council
	name = "USCM Commanding Officer (CO+)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/gold/council
	rank = JOB_CO
	paygrade = "MO5"
	role_comm_title = "CO"
	minimum_age = 35

/datum/equipment_preset/uscm_ship/commander/council/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/council(H), WEAR_HEAD)
	. = ..()

/datum/equipment_preset/uscm_ship/commander/council/plus
	name = "USCM Commanding Officer (CO++)"
	idtype = /obj/item/card/id/general
	paygrade = "MO6"

/datum/equipment_preset/uscm_ship/commander/council/plus/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/councilchief(H), WEAR_HEAD)
	. = ..()

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/xo
	name = "USCM Executive Officer (XO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	assignment = JOB_XO
	rank = JOB_XO
	paygrade = "MO3"
	role_comm_title = "XO"
	minimum_age = 35
	skills = /datum/skills/XO

	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full, /obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey)

/datum/equipment_preset/uscm_ship/xo/New()
	. = ..()
	access = get_all_marine_access() - ACCESS_MARINE_CAPTAIN

/datum/equipment_preset/uscm_ship/xo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/exec(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/so
	name = "USCM Staff Officer (SO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_COMMANDER, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS)
	assignment = JOB_SO
	rank = JOB_SO
	paygrade = "MO1"
	role_comm_title = "SO"
	minimum_age = 25
	skills = /datum/skills/SO

/datum/equipment_preset/uscm_ship/so/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/ro(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_L_HAND)

	dress_extra = list(/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey)
//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/sea
	name = "USCM Senior Enlisted Advisor (SEA)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access
	assignment = JOB_SEA
	rank = JOB_SEA
	paygrade = "ME7"
	role_comm_title = "SEA"
	minimum_age = 40
	skills = /datum/skills/SEA

	service_hat = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/drillhat)
	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full, /obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey)

/datum/equipment_preset/uscm_ship/sea/New()
	. = ..()
	access = get_all_marine_access() - ACCESS_MARINE_CAPTAIN

/datum/equipment_preset/uscm_ship/sea/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/custom(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/drillhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/whistle(H), WEAR_R_HAND)

/datum/equipment_preset/uscm_ship/sea/load_rank(mob/living/carbon/human/H)
	if(H.client)
		var/grade8 = "ME8E"
		var/grade9 = "ME9E"

		if(H.client && H.client.prefs)
			var/path = H.client.prefs.sea_path
			if(path == "Technical")
				grade8 = "ME8"
				grade9 = "ME9"

		if(!H.client.prefs.playtime_perks)
			return paygrade
		if(get_job_playtime(H.client, JOB_SEA) >= JOB_PLAYTIME_TIER_3)
			return grade9
		else if(get_job_playtime(H.client, JOB_SEA) >= JOB_PLAYTIME_TIER_1)
			return grade8
	return paygrade

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/po
	name = "USCM Pilot (DP) (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PILOT)
	assignment = JOB_PILOT
	rank = JOB_PILOT
	paygrade = "MO1"
	role_comm_title = "DP"
	skills = /datum/skills/pilot

/datum/equipment_preset/uscm_ship/po/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/po/full
	name = "USCM Pilot Officer (PO)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/pilot)

/datum/equipment_preset/uscm_ship/po/full/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/pilot(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/pilot(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/dcc
	name = "USCM Dropship Crew Chief (DCC) (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PILOT)
	assignment = JOB_DROPSHIP_CREW_CHIEF
	rank = JOB_DROPSHIP_CREW_CHIEF
	paygrade = "ME5"
	role_comm_title = "DCC"
	skills = /datum/skills/crew_chief

/datum/equipment_preset/uscm_ship/dcc/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot/dcc(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/dcc/full
	name = "USCM Dropship Crew Chief (DCC)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/pilot/dcc)

/datum/equipment_preset/uscm_ship/dcc/full/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot/dcc(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/dcc(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/officer
	name = "USCM Officer (USCM Command)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/general
	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = "USCM Officer"
	rank = "USCM Officer"
	paygrade = "MO3"
	role_comm_title = "Cpt"
	minimum_age = 40
	skills = /datum/skills/commander

	utility_hat = list(/obj/item/clothing/head/beret/cm)
	utility_gloves = list(/obj/item/clothing/gloves/marine/techofficer/commander)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm/tan)

	service_hat = list(/obj/item/clothing/head/beret/cm)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)

	dress_extra = list(/obj/item/clothing/head/beret/marine/commander/dress,/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey, /obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat, /obj/item/storage/large_holster/ceremonial_sword/full)
	dress_hat = list(/obj/item/clothing/head/marine/peaked/captain)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)

/datum/equipment_preset/uscm_ship/officer/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_ship/officer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_if_possible(new /obj/item/clothing/under/rank/centcom/officer(H), WEAR_BODY)
	H.equip_if_possible(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_if_possible(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)
	H.equip_if_possible(new /obj/item/clothing/head/beret/centcom/officer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)

	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)
	H.equip_if_possible(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/chef
	name = "USCM Mess Technician (MST)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_KITCHEN)
	assignment = JOB_MESS_SERGEANT
	rank = JOB_MESS_SERGEANT
	paygrade = "ME2"
	role_comm_title = "MST"
	skills = /datum/skills/mess_technician

	utility_under = list(/obj/item/clothing/under/marine/chef)

/datum/equipment_preset/uscm_ship/chef/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/chef(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/chef(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/chef(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/prisoner
	name = "USCM Prisoner (PFC)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	var/preset_type = /datum/equipment_preset/uscm/pfc
	var/datum/equipment_preset/preset

	var/entry_message = {"You were arrested for %ARRESTREASON%. As such, you're being held inside the brig until after the current operation finishes."}
	var/list/arrest_reasons = list(
		"extreme hooliganism",
		"pantsing the CO",
		"converting the APC's catalytic converter into a bong",
		"overthrowing the RO",
		"beating on a CLF PoW during an interrogation",
		"flirting with a member of the CIC",
		"getting into a serious fight over the last fresh cheeseburger",
		"lighting up a joint during drug test day",
		"nut tapping an MP"
	)

/datum/equipment_preset/uscm_ship/prisoner/New()
	. = ..()

	preset = new preset_type

	uses_special_name = preset.uses_special_name
	languages = preset.languages
	skills = preset.skills
	assignment = preset.assignment
	rank = preset.rank
	paygrade = preset.paygrade
	role_comm_title = preset.role_comm_title
	minimum_age = preset.minimum_age
	faction = preset.faction
	faction_group = preset.faction_group

/datum/equipment_preset/uscm_ship/prisoner/load_preset(mob/living/carbon/human/human, randomise, count_participant, client/mob_client, show_job_gear)
	. = ..()
	handle_spawn_message(human)

/datum/equipment_preset/uscm_ship/prisoner/load_race(mob/living/carbon/human/human, var/client/mob_client)
	return preset.load_race(human, mob_client)

/datum/equipment_preset/uscm_ship/prisoner/load_name(mob/living/carbon/human/human, var/randomise, var/client/mob_client)
	return preset.load_name(human, randomise, mob_client)

/datum/equipment_preset/uscm_ship/prisoner/load_gear(mob/living/carbon/human/human)
	human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer(human), WEAR_L_EAR)
	human.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(human), WEAR_BODY)
	human.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(human), WEAR_FEET)

/datum/equipment_preset/uscm_ship/prisoner/load_vanity(mob/living/carbon/human/human, var/client/mob_client)
	if(human.disabilities & NEARSIGHTED)
		var/obj/item/clothing/glasses/regular/P = new /obj/item/clothing/glasses/regular()
		if(!human.equip_to_slot_if_possible(P, WEAR_EYES))
			if(istype(human.glasses, /obj/item/clothing/glasses))
				var/obj/item/clothing/glasses/EYES = human.glasses
				if(EYES.prescription) //if they already have prescription glasses they don't need new ones
					return
			if(!human.equip_to_slot_if_possible(P, WEAR_IN_BACK))
				if(!human.equip_to_slot_if_possible(P, WEAR_L_HAND))
					if(!human.equip_to_slot_if_possible(P, WEAR_R_HAND))
						P.forceMove(human.loc)

/datum/equipment_preset/uscm_ship/prisoner/proc/handle_spawn_message(mob/living/carbon/human/human)
	var/list/entry_display = list()
	entry_display += SPAN_ROLE_BODY("|______________________|")
	entry_display += SPAN_ROLE_HEADER("You are \a [assignment]")
	entry_display += SPAN_ROLE_BODY("[replacetext(entry_message, "%ARRESTREASON%", pick(arrest_reasons))]")
	entry_display += SPAN_ROLE_BODY("|______________________|")
	to_chat(human, entry_display.Join("\n"))

/datum/equipment_preset/uscm_ship/prisoner/clf
	name = "USCM Prisoner (CLF Soldier)"
	preset_type = /datum/equipment_preset/clf/soldier

	entry_message = {"You were taken prisoner during an engagement with the USCM in Operation Tachyon Tackle. You were %ARRESTREASON%. You are being held prisoner until the Almayer can offload you at a USCM dock."}
	arrest_reasons = list(
		"defending a line when you got shot and rushed down. You managed to stabilize the wound, but were surrounded the next moment you looked up",
		"asleep when the battle broke out, forgot your rifle, and were forced to hold one of the sandbag defense lines in your skivvies. Debris from an explosion knocked you out and you awoke in cuffs",
		"firing your weapon at the advancing APC when you saw your buddies get gunned down and run over. Your nerves shattered and you raised your gun in surrender",
		"throwing an IED at an approaching USCM squad, but it detonated in the air right in front of you, knocking you out instantly. When you came to, you were surrounded by a group of marines pointing their guns at you"
	)

/datum/equipment_preset/uscm_ship/prisoner/clf/leader
	name = "USCM Prisoner (CLF Leader)"
	preset_type = /datum/equipment_preset/clf/leader

	arrest_reasons = list(
		"ordering a squad of men to charge forward and hold the line, when a grenade landed just behind you, blowing your squad away. You were knocked unconscious, and when you came to, you were cuffed in the back of an APC",
		"loading a wounded CLF guerilla onto your shoulders when a bullet hit you in the torso, dropping you to the floor. The guerilla took the next burst. Thankfully, you were hidden beneath the body until one of the marines passing over you noticed you and took you prisoner",
		"ordering your engineers to set up defensive lines when a faulty crate of IEDs started cooking off a dozen metres from your position. You were far enough away to survive, but a chunk of debris hit you on the helmet and knocked you out cold. When you came to, a USCM marine had their gun to your head",
		"firing a HMG at a dropship, before it unleashed a couple mini-rockets at your location. You dove into cover, but it only barely managed to keep you alive from the explosion. You were too wounded to move, and were captured when marines advanced past your position"
	)
