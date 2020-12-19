/datum/equipment_preset/uscm_ship
	name = "USCM (ship roles)"
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	minimum_age = 20
	languages = list("English")

	utility_under = list(/obj/item/clothing/under/marine/officer/command)
	utility_hat = list(/obj/item/clothing/head/cmcap)
	utility_gloves = list(/obj/item/clothing/gloves/marine)
	utility_shoes = list(/obj/item/clothing/shoes/marine/knife)
	utility_extra = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

	service_under = list(/obj/item/clothing/under/marine/officer/bridge)
	service_over = list(/obj/item/clothing/suit/storage/jacket/marine)
	service_hat = list(/obj/item/clothing/head/cmcap)
	service_shoes = list(/obj/item/clothing/shoes/dress)

	dress_under = list(/obj/item/clothing/under/marine/dress)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress)
	dress_hat = list(/obj/item/clothing/head/marine/peaked)
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/dress)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/liaison
	name = "USCM Corporate Liaison (CL)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	languages = list("English", "Japanese")

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
	utility_shoes = list(/obj/item/clothing/shoes)
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

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcl(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm_ship/liaison/load_rank(mob/living/carbon/human/H)
	if(H.client)
		var/playtime = get_job_playtime(H.client, rank)

		if(playtime > JOB_PLAYTIME_TIER_4)
			return "WY-XE"
		else if(playtime > JOB_PLAYTIME_TIER_3)
			return "WY-XD"
		else if(playtime > JOB_PLAYTIME_TIER_2)
			return "WY-XC"
		else
			return paygrade
	return paygrade

/*****************************************************************************************************/
/datum/equipment_preset/uscm_ship/liaison/nightmare
	name = "Nightmare USCM Corporate Liaison"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction_group = FACTION_LIST_MARINE_WY

	access = list(ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE, ACCESS_WY_PMC_RED, ACCESS_WY_PMC_BLACK, ACCESS_WY_PMC_WHITE, ACCESS_WY_CORPORATE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/chief_engineer
	name = "USCM Chief Engineer (CE)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_CE,
		ACCESS_MARINE_ENGINEERING,
		ACCESS_MARINE_BRIDGE,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_MARINE_COMMANDER,
		ACCESS_MARINE_LOGISTICS,
		ACCESS_MARINE_MAINT,
		ACCESS_MARINE_OT
	)
	assignment = JOB_CHIEF_ENGINEER
	rank = JOB_CHIEF_ENGINEER
	paygrade = "O3"
	role_comm_title = "CE"
	minimum_age = 27
	skills = /datum/skills/CE

	utility_under = list(/obj/item/clothing/under/marine/officer/ce)

/datum/equipment_preset/uscm_ship/chief_engineer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ce(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/ce(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/electronics(H), WEAR_R_STORE)

/*****************************************************************************************************/

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
	paygrade = "E5"
	role_comm_title = "MT"
	skills = /datum/skills/OT

	utility_under = list(/obj/item/clothing/under/marine/officer/engi)

/datum/equipment_preset/uscm_ship/maint/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/welding(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/demo_scanner(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/bag/trash(H), WEAR_L_HAND)

/*****************************************************************************************************/

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
	paygrade = "E5"
	role_comm_title = "OT"
	skills = /datum/skills/OT

	utility_under = list(/obj/item/clothing/under/marine/officer/engi)

/datum/equipment_preset/uscm_ship/ordn/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi/OT(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/demo_scanner(H), WEAR_L_STORE)

/*****************************************************************************************************/

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
	paygrade = "O3"
	role_comm_title = "RO"
	minimum_age = 27
	skills = /datum/skills/RO

	utility_under = list(/obj/item/clothing/under/rank/ro_suit)

/datum/equipment_preset/uscm_ship/ro/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ro(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/ro_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/custom(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/req(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/cargo
	name = "USCM Cargo Technician (CT)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_CARGO, ACCESS_MARINE_PREP)
	assignment = JOB_CARGO_TECH
	rank = JOB_CARGO_TECH
	paygrade = "E5"
	role_comm_title = "CT"
	skills = /datum/skills/CT

	utility_under = list(/obj/item/clothing/under/rank/cargotech)

/datum/equipment_preset/uscm_ship/cargo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ct(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargotech(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beanie(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/commander
	name = "USCM Captain (CO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/gold
	assignment = JOB_CO
	rank = JOB_CO
	paygrade = "O5"
	role_comm_title = "CO"
	minimum_age = 40
	skills = /datum/skills/commander

	utility_hat = list(/obj/item/clothing/head/beret/cm)
	utility_gloves = list(/obj/item/clothing/gloves/marine/techofficer/commander)
	utility_extra = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/beret/cm/tan)

	service_hat = list(/obj/item/clothing/head/beret/cm)
	service_shoes = list(/obj/item/clothing/shoes/dress/commander)
	service_extra = list(/obj/item/clothing/under/marine/officer/casual, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber)

	dress_under = list(/obj/item/clothing/under/marine/officer/formal/white, /obj/item/clothing/under/marine/officer/formal/black, /obj/item/clothing/under/marine/officer/dining)
	dress_extra = list(/obj/item/clothing/head/beret/marine/commander/dress, /obj/item/storage/large_holster/ceremonial_sword/full)
	dress_hat = list(/obj/item/clothing/head/marine/peaked/captain, /obj/item/clothing/head/cmcap/co/formal/white, /obj/item/clothing/head/cmcap/co/formal/black)
	dress_shoes = list(/obj/item/clothing/shoes/dress/commander)

/datum/equipment_preset/uscm_ship/commander/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/uscm_ship/commander/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/lockable
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/mcommander

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress/commander(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/cmateba/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)

	H.hud_set_squad()

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/commander/commodore
	name = "USCM Commodore (CO+)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/gold/commodore
	rank = JOB_CO
	paygrade = "O5E"
	role_comm_title = "CDRE"
	minimum_age = 45

/datum/equipment_preset/uscm_ship/commander/commodore/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)  // They need body clothing on so that we can put the mateba on
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/admiral(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/cdre(H), WEAR_HEAD)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/storage/mateba_case/commodore(H.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm_ship/commander/commodore/plus
	name = "USCM Commodore (CO++)"
	idtype = /obj/item/card/id/admiral

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/xo
	name = "USCM Executive Officer (XO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	assignment = JOB_XO
	rank = JOB_XO
	paygrade = "O4"
	role_comm_title = "XO"
	minimum_age = 35
	skills = /datum/skills/XO

	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)

/datum/equipment_preset/uscm_ship/xo/New()
	. = ..()
	access = get_all_marine_access() - ACCESS_MARINE_CAPTAIN

/datum/equipment_preset/uscm_ship/xo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/exec(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

	H.hud_set_squad()

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/so
	name = "USCM Staff Officer (SO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_COMMANDER, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS)
	assignment = JOB_SO
	rank = JOB_SO
	paygrade = "O2"
	role_comm_title = "SO"
	minimum_age = 25
	skills = /datum/skills/SO

/datum/equipment_preset/uscm_ship/so/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/ro(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)

	H.hud_set_squad()

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/sea
	name = "USCM Senior Enlisted Advisor (SEA)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access
	assignment = JOB_SEA
	rank = JOB_SEA
	paygrade = "E8"
	role_comm_title = "SEA"
	minimum_age = 40
	skills = /datum/skills/SEA

	service_hat = list(/obj/item/clothing/head/cmcap, /obj/item/clothing/head/drillhat)

/datum/equipment_preset/uscm_ship/sea/New()
	. = ..()
	access = get_all_marine_access() - ACCESS_MARINE_CAPTAIN

/datum/equipment_preset/uscm_ship/sea/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/custom(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/drillhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_L_STORE)

	H.hud_set_squad()

/datum/equipment_preset/uscm_ship/sea/load_rank(mob/living/carbon/human/H)
	if(H.client)
		if(get_job_playtime(H.client, JOB_SEA) >= JOB_PLAYTIME_TIER_1)
			return "E9"
	return paygrade

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/po
	name = "USCM Pilot Officer (PO) (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PILOT)
	assignment = JOB_PILOT
	rank = JOB_PILOT
	paygrade = "O1" //Technically Second Lieutenant equivalent, but 2ndLT doesn't exist in Marine pay grade, so Ensign
	role_comm_title = "PO"
	skills = /datum/skills/pilot

/datum/equipment_preset/uscm_ship/po/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/po/full
	name = "USCM Pilot Officer (PO)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/pilot)

/datum/equipment_preset/uscm_ship/po/full/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if(H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/pilot(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/pilot(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

	H.hud_set_squad()

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/officer
	name = "USCM Officer (USCM Command)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/admiral
	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = "USCM Officer"
	rank = "USCM Officer"
	paygrade = "O5"
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
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_ship/officer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_if_possible(new /obj/item/clothing/under/rank/centcom/officer(H), WEAR_BODY)
	H.equip_if_possible(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_if_possible(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)
	H.equip_if_possible(new /obj/item/clothing/head/beret/centcom/officer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)

	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)
	H.equip_if_possible(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/admiral
	name = "USCM Admiral (USCM Command)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/admiral
	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = "USCM Admiral"
	rank = "USCM Admiral"
	paygrade = "O7"
	role_comm_title = "RADM"
	minimum_age = 50
	skills = /datum/skills/admiral

	service_under = list(/obj/item/clothing/under/marine/officer/admiral)
	service_over = list(/obj/item/clothing/suit/armor/vest/admiral)
	service_gloves = list(/obj/item/clothing/gloves/black)
	service_hat = list(/obj/item/clothing/head/admiral)

/datum/equipment_preset/uscm_ship/admiral/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_ship/admiral/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/admiral(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/admiral(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/admiral(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/admiral(H), WEAR_JACKET)

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/flashbang(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/admiral(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)

	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

	H.hud_set_squad()

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/upp_spy
	name = "UPP Spy"
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_ORDNANCE_TECH
	rank = "UPP"
	paygrade = "E6"
	role_comm_title = "OT"
	skills = /datum/skills/spy
	languages = list("English", "Russian") //can speak russian, but it's not default

/datum/equipment_preset/uscm_ship/upp_spy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_EAR)

	//TODO: preload all of those items before equipping the backpack
	//Otherwise, if you spawn the spy next to other people
	//they will see messages for them putting guns and explosives into their backpack...
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/c99/upp/tranq(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99t(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99t(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)


/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/chef
	name = "USCM Mess Sergeant (MS)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_KITCHEN)
	assignment = JOB_MESS_SERGEANT
	rank = JOB_MESS_SERGEANT
	paygrade = "E5"
	role_comm_title = "MSgt"
	skills = /datum/skills/OT

	utility_under = list(/obj/item/clothing/under/marine/chef)

/datum/equipment_preset/uscm_ship/chef/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/chef(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/chef(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/chef(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
