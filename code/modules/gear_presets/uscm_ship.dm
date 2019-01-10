/datum/equipment_preset/uscm_ship
	name = "USCM (ship roles)"

	languages = list("English")

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/cmo
	name = "USCM Chief Medical Officer (CMO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_CMO, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_CHEMISTRY)
	assignment = "Chief Medical Officer"
	rank = "Chief Medical Officer"
	paygrade = "CCMO"
	role_comm_title = "CMO"
	skills = /datum/skills/CMO

/datum/equipment_preset/uscm_ship/cmo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmo(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/syringe(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	//H.equip_to_slot_or_del(new /obj/item/clothing/head/cmo(H), WEAR_HEAD)//2.10.2018 Will want to work on this a bit more, it doesn't quite fit. - Joshuu
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_L_HAND)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/doctor
	name = "USCM Doctor"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY)
	assignment = "Doctor"
	rank = "Doctor"
	paygrade = "CD"
	role_comm_title = "Doc"
	skills = /datum/skills/doctor

/datum/equipment_preset/uscm_ship/doctor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/syringe(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_L_HAND)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/researcher
	name = "USCM Researcer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY)
	assignment = "Medical Researcher"
	rank = "Researcher"
	paygrade = "CD"
	role_comm_title = "Rsr"
	skills = /datum/skills/doctor

/datum/equipment_preset/uscm_ship/researcher/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/syringe(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), WEAR_J_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/liaison
	name = "USCM Corporate Liaison"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_IFF_MARINE, ACCESS_WY_CORPORATE, ACCESS_ILLEGAL_PIRATE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_RESEARCH, ACCESS_MARINE_MEDBAY, ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS) 
	assignment = "Corporate Liaison"
	rank = "Corporate Liaison"
	paygrade = "WY1"
	role_comm_title = "CL"
	skills = /datum/skills/civilian

/datum/equipment_preset/uscm_ship/liaison/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	//There is no suitable backpack for a CL really...
	//if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		//backItem = /obj/item/storage/backpack

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/liaison/nightmare
	name = "Nightmare USCM Corporate Liaison"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_PMC, ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE, ACCESS_WY_PMC_RED, ACCESS_WY_PMC_BLACK, ACCESS_WY_PMC_WHITE, ACCESS_WY_CORPORATE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/chief_engineer
	name = "USCM Chief Engineer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_BRIDGE, ACCESS_CIVILIAN_ENGINEERING)
	assignment = "Chief Engineer"
	rank = "Chief Engineer"
	paygrade = "O3"
	role_comm_title = "CE"
	skills = /datum/skills/CE

/datum/equipment_preset/uscm_ship/chief_engineer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/ce(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/electronics(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/maint
	name = "USCM Maintenance Tech"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	assignment = "Maintenance Tech"
	rank = "Maintenance Tech"
	paygrade = "E5"
	role_comm_title = "MT"
	skills = /datum/skills/MT

/datum/equipment_preset/uscm_ship/maint/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/t_scanner(H), WEAR_L_HAND)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/ro
	name = "USCM Requisitions Officer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_CARGO, ACCESS_MARINE_RO, ACCESS_MARINE_BRIDGE)
	assignment = "Requisitions Officer"
	rank = "Requisitions Officer"
	paygrade = "O3"
	role_comm_title = "RO"
	skills = /datum/skills/RO

/datum/equipment_preset/uscm_ship/ro/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/ro_suit(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/req(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/cargo
	name = "USCM Cargo Technician"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_CARGO)
	assignment = "Cargo Technician"
	rank = "Cargo Technician"
	paygrade = "E5"
	role_comm_title = "CT"
	skills = /datum/skills/CT

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
	name = "USCM Commander (CO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/gold
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY)
	assignment = "Commanding Officer"
	rank = "Commander"
	paygrade = "O5"
	role_comm_title = "CO"
	skills = /datum/skills/commander

/datum/equipment_preset/uscm_ship/commander/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/uscm_ship/commander/load_id(mob/living/carbon/human/H)
	. = ..()

	if(H.wear_id && RoleAuthority && RoleAuthority.roles_whitelist && (RoleAuthority.roles_whitelist[H.ckey] & WHITELIST_COMMANDER_COUNCIL))
		var/obj/item/card/id/W = H.wear_id
		W.paygrade = "O5E"

/datum/equipment_preset/uscm_ship/commander/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/mcommander

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/command(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marinechief/commander(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/techofficer/commander(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/cmateba/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm/tan(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/xo
	name = "USCM Executive Officer (XO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY)
	assignment = "Executive Officer"
	rank = "Executive Officer"
	paygrade = "O4"
	role_comm_title = "XO"
	skills = /datum/skills/XO

/datum/equipment_preset/uscm_ship/xo/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/uscm_ship/xo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/exec(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/so
	name = "USCM Staff Officer (SO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS)
	assignment = "Second Lieutenant"
	rank = "Staff Officer"
	paygrade = "O2"
	role_comm_title = "SO"
	skills = /datum/skills/SO

/datum/equipment_preset/uscm_ship/so/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/ro(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/po
	name = "USCM Pilot Officer (PO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PILOT)
	assignment = "Pilot Officer"
	rank = "Pilot Officer"
	paygrade = "O1" //Technically Second Lieutenant equivalent, but 2ndLT doesn't exist in Marine pay grade, so Ensign
	role_comm_title = "PO"
	skills = /datum/skills/pilot

/datum/equipment_preset/uscm_ship/po/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/pilot(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/pilot(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/mp
	name = "USCM Military Police (MP)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIG, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDBAY)
	assignment = "Military Police"
	rank = "Military Police"
	paygrade = "E6"
	role_comm_title = "MP"
	skills = /datum/skills/MP

/datum/equipment_preset/uscm_ship/mp/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mmpo(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm/red(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/cmp
	name = "USCM Chief MP (CMP)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIG, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PREP, ACCESS_MARINE_WO, ACCESS_MARINE_MEDBAY)
	assignment = "Chief MP"
	rank = "Chief MP"
	paygrade = "O3"
	role_comm_title = "CMP"
	skills = /datum/skills/CMP

/datum/equipment_preset/uscm_ship/cmp/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmpcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/warrant(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/WO(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm/wo(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/officer
	name = "USCM Officer (USCM Command)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY)
	assignment = "USCM Officer"
	rank = "USCM Officer"
	paygrade = "O5"
	role_comm_title = "Cpt"
	skills = /datum/skills/commander

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

	var/obj/item/device/pda/heads/pda = new(H)
	pda.owner = H.real_name
	pda.ownjob = "USCM Officer"
	pda.name = "PDA-[H.real_name] ([pda.ownjob])"

	H.equip_if_possible(pda, WEAR_R_STORE)
	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)
	H.equip_if_possible(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/admiral
	name = "USCM Admiral (USCM Command)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY)
	assignment = "USCM Admiral"
	rank = "USCM Admiral"
	paygrade = "O7"
	role_comm_title = "ADM"
	skills = /datum/skills/admiral

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

	var/obj/item/device/pda/heads/pda = new(H)
	pda.owner = H.real_name
	pda.ownjob = "USCM Admiral"
	pda.name = "PDA-[H.real_name] ([pda.ownjob])"

	H.equip_if_possible(pda, WEAR_R_STORE)
	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/upp_spy
	name = "UPP Spy"
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY)
	assignment = "Maintenance Tech"
	rank = "Maintenance Tech"
	paygrade = "E6E"
	role_comm_title = "MT"
	special_role = "UPP"
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
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/fleet_admiral
	name = "Fleet Admiral" //Renamed from Soviet Admiral
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	access = list()
	assignment = "Fleet Admiral"
	rank = "Fleet Admiral"
	paygrade = "O8"
	role_comm_title = "FADM"
	skills = /datum/skills/admiral

/datum/equipment_preset/uscm_ship/fleet_admiral/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_ship/fleet_admiral/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hgpiratecap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/eyepatch(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/hgpirate(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(H), WEAR_BODY)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/riot_mp
	name = "USCM Riot MP (RMP)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	access = list()
	assignment = "Riot Control"
	rank = "RMP"
	paygrade = "E6"
	role_comm_title = "RMP"
	skills = /datum/skills/CMP
	special_role = "RIOT"

/datum/equipment_preset/uscm_ship/riot_mp/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm_ship/riot_mp/load_gear(mob/living/carbon/human/H)
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
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/chem_grenade/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/chem_grenade/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/chem_grenade/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/chem_grenade/teargas(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/with_beanbags(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/with_beanbags(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)

/*****************************************************************************************************/

/datum/equipment_preset/uscm_ship/riot_mp/riot_cmp
	name = "USCM Riot Chief MP (RCMP)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Chief Riot Control"
	rank = "CRMP"
	role_comm_title = "CRMP"
	skills = /datum/skills/CMP