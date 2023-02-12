/datum/equipment_preset/wo
	name = "WO"
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	languages = list(LANGUAGE_ENGLISH)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/wo/load_status(mob/living/carbon/human/H)
	H.nutrition = NUTRITION_NORMAL


//*****************************************************************************************************/

/datum/equipment_preset/wo/commander
	name = "WO Commanding Officer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	assignment = JOB_WO_CO
	rank = JOB_WO_CO
	paygrade = "MO2"
	role_comm_title = "CDR"
	skills = /datum/skills/commander
	idtype = /obj/item/card/id/gold

	minimap_icon = "co"

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
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/officer/white, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/black, /obj/item/clothing/suit/storage/jacket/marine/dress/officer/suit)

/datum/equipment_preset/wo/commander/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/wo/commander/load_gear(mob/living/carbon/human/H)
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

	//back
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	if(kit)
		H.equip_to_slot_or_del(new kit(H), WEAR_IN_BACK)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	//uniform
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/command(H), WEAR_BODY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/SO(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/mercsword/ceremonial(H), WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new sidearmpath(H), WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/techofficer/commander(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress/commander(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(H), WEAR_L_HAND)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/command(H), WEAR_L_STORE)


//*****************************************************************************************************/

/datum/equipment_preset/wo/xo
	name = "WO Lieutenant Commander"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	assignment = JOB_WO_XO
	rank = JOB_WO_XO
	paygrade = "MO1"
	role_comm_title = "LCDR"
	skills = /datum/skills/XO
	idtype = /obj/item/card/id/silver

	minimap_icon = "xo"

	dress_extra = list(/obj/item/storage/large_holster/ceremonial_sword/full)

/datum/equipment_preset/wo/xo/New()
	. = ..()
	access = get_all_marine_access()

/datum/equipment_preset/wo/xo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	//back
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_L_EAR)
	//uniform
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/exec(H), WEAR_BODY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/SO(H), WEAR_JACKET)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/wo/cmp
	name = "WO Honor Guard Squad Leader"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_BRIG, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PREP, ACCESS_MARINE_WO, ACCESS_MARINE_MEDBAY)
	assignment = JOB_WO_CHIEF_POLICE
	rank = JOB_WO_CHIEF_POLICE
	paygrade = "ME5"
	role_comm_title = "HGSL"
	skills = /datum/skills/honor_guard/lead
	idtype = /obj/item/card/id/silver

	minimap_icon = "cmp"

/datum/equipment_preset/wo/cmp/load_gear(mob/living/carbon/human/H)

	//uniform
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	//back
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_BACK)
	//head
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/mp_honor/com(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/chiefofficer(H), WEAR_HEAD)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(H), WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	//SG headset
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)
//*****************************************************************************************************/

/datum/equipment_preset/wo/vhg
	name = "WO Veteran Honor Guard" //SO
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS)
	assignment = JOB_WO_SO
	rank = JOB_WO_SO
	paygrade = "ME4"
	role_comm_title = "VHG"
	skills = /datum/skills/honor_guard/vet
	idtype = /obj/item/card/id/silver

	minimap_icon = "so"

/datum/equipment_preset/wo/vhg/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	//back
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/alt(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/mp_honor/com(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(H), WEAR_EYES)
	//uniform
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/leader(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(H), WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(H), WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/officer(H), WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_L_STORE)


//*****************************************************************************************************/

/datum/equipment_preset/wo/hgs
	name = "WO Honor Guard Specialist" //Tank crew
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS)
	assignment = JOB_WO_CREWMAN
	rank = JOB_WO_CREWMAN
	paygrade = "ME3"
	role_comm_title = "HGS"
	skills = /datum/skills/honor_guard/spec
	idtype = /obj/item/card/id/gold

	minimap_icon = "spec"

/datum/equipment_preset/wo/hgs/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	//back
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	//head
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/mp_honor(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/logisticsofficer(H), WEAR_HEAD)
	//uniform
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/officer(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/spec_kit(H), WEAR_R_HAND)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)


//*****************************************************************************************************/

/datum/equipment_preset/wo/hg
	name = "WO Honor Guard" //MP
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_BRIG, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_WO_POLICE
	rank = JOB_WO_POLICE
	paygrade = "ME2"
	role_comm_title = "HG"
	skills = /datum/skills/honor_guard

	minimap_icon = "mp"

/datum/equipment_preset/wo/hg/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel/sec
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/security

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/mp_honor(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/officer(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/leader(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/logisticsofficer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/wo/mortar_crew
	name = "WO Mortar Crew" //PO
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PILOT)
	assignment = JOB_WO_PILOT
	rank = JOB_WO_PILOT
	paygrade = "ME3"
	role_comm_title = "MC"
	skills = /datum/skills/mortar_crew

	minimap_icon = "vc"

/datum/equipment_preset/wo/mortar_crew/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/eng, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/mortar, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/mortar, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses, WEAR_IN_BACK)


//*****************************************************************************************************/

/datum/equipment_preset/wo/quartermaster
	name = "WO Quartermaster"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_CARGO, ACCESS_MARINE_RO, ACCESS_MARINE_BRIDGE)
	assignment = JOB_WO_CHIEF_REQUISITION
	rank = JOB_WO_CHIEF_REQUISITION
	paygrade = "ME8"
	role_comm_title = "QM"
	skills = /datum/skills/RO
	idtype = /obj/item/card/id/silver

	minimap_icon = "ro"

/datum/equipment_preset/wo/quartermaster/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/techofficer(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/custom(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/req(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/wo/cargo
	name = "WO Bunker Crew Logistics" //CT
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING, ACCESS_MARINE_CARGO)
	assignment = JOB_WO_REQUISITION
	rank = JOB_WO_REQUISITION
	paygrade = "ME4"
	role_comm_title = "BCL"
	skills = /datum/skills/CE
	idtype = /obj/item/card/id

/datum/equipment_preset/wo/cargo/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/eng(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/ct(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/wo/head_surgeon
	name = "WO Head Surgeon" //CMO
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_CMO, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_WO_CMO
	rank = JOB_WO_CMO
	paygrade = "CCMO"
	role_comm_title = "HS"
	skills = /datum/skills/CMO
	idtype = /obj/item/card/id/silver

	minimap_icon = "cmo"

/datum/equipment_preset/wo/head_surgeon/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmo(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	//H.equip_to_slot_or_del(new /obj/item/clothing/head/cmo(H), WEAR_HEAD)//2.10.2018 Will want to work on this a bit more, it doesn't quite fit. - Joshuu
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/wo/doctor
	name = "WO Field Doctor"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_WO_DOCTOR
	rank = JOB_WO_DOCTOR
	paygrade = "CD"
	role_comm_title = "Doc"
	skills = /datum/skills/doctor
	idtype = /obj/item/card/id

	minimap_icon = "doctor"

/datum/equipment_preset/wo/doctor/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/wo/chemist
	name = "WO Chemist"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_WO_RESEARCHER
	rank = JOB_WO_RESEARCHER
	paygrade = "CD"
	role_comm_title = "Chem"
	skills = /datum/skills/researcher
	idtype = /obj/item/card/id

	minimap_icon = "researcher"

/datum/equipment_preset/wo/chemist/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/doc(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/purple(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(H), WEAR_JACKET)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/wo/bcm
	name = "WO Bunker Crew Master" //CE
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_BRIDGE, ACCESS_CIVILIAN_ENGINEERING, ACCESS_MARINE_LOGISTICS)
	assignment = JOB_WO_CHIEF_ENGINEER
	rank = JOB_WO_CHIEF_ENGINEER
	paygrade = "ME5"
	role_comm_title = "BCM"
	skills = /datum/skills/CE
	idtype = /obj/item/card/id/silver

	minimap_icon = "ce"

/datum/equipment_preset/wo/bcm/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/eng(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/wo/bc
	name = "WO Bunker Crew" //OT
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_BRIDGE, ACCESS_CIVILIAN_ENGINEERING, ACCESS_MARINE_LOGISTICS)
	assignment = JOB_WO_ORDNANCE_TECH
	rank = JOB_WO_ORDNANCE_TECH
	paygrade = "ME4"
	role_comm_title = "BC"
	skills = /datum/skills/OT
	idtype = /obj/item/card/id

	minimap_icon = "mt"

/datum/equipment_preset/wo/bc/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/eng(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/wo/reporter
	name = "WO Combat Reporter" //CL
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(
		ACCESS_WY_CORPORATE, ACCESS_ILLEGAL_PIRATE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_RESEARCH, ACCESS_MARINE_MEDBAY, ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)
	assignment = JOB_WO_CORPORATE_LIAISON
	rank = JOB_WO_CORPORATE_LIAISON
	paygrade = "WYC2"
	role_comm_title = "PRESS"
	skills = /datum/skills/civilian
	idtype = /obj/item/card/id/silver/cl

	minimap_icon = "surv"
	minimap_background = MINIMAP_ICON_BACKGROUND_CIVILIAN

/datum/equipment_preset/wo/reporter/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	//There is no suitable backpack for a CL really...
	//if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		//backItem = /obj/item/storage/backpack

	H.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/suspenders(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/camera(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/camera_film(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone(H), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/wo/marine
	name = "WO Dust Raider" //Stub other Marine equipment stems from
	flags = EQUIPMENT_PRESET_STUB

//*****************************************************************************************************/

/datum/equipment_preset/wo/marine/sl
	name = "WO Dust Raider Squad Leader"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrade = "ME5"
	role_comm_title = "SL"
	skills = /datum/skills/SL

/datum/equipment_preset/wo/marine/sl/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/leader(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/map/whiskey_outpost_map(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/designator(H), WEAR_IN_BACK)

	add_common_wo_equipment(H)

//*****************************************************************************************************/

/datum/equipment_preset/wo/marine/spec
	name = "WO Dust Raider Squad Weapons Specialist"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrade = "ME3"
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

/datum/equipment_preset/wo/marine/spec/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(H), WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/magnetic_harness(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/spec_kit, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)

	add_common_wo_equipment(H)

//*****************************************************************************************************/

/datum/equipment_preset/wo/marine/sg
	name = "WO Dust Raider Squad Smartgunner"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrade = "ME3"
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/wo/marine/sg/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)

	add_common_wo_equipment(H)

//*****************************************************************************************************/

/datum/equipment_preset/wo/marine/engineer
	name = "WO Dust Raider Squad Combat Technician"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrade = "ME3"
	role_comm_title = "ComTech"
	skills = /datum/skills/combat_engineer

/datum/equipment_preset/wo/marine/engineer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)

	generate_random_marine_primary_for_wo(H)
	add_common_wo_equipment(H)

//*****************************************************************************************************/

/datum/equipment_preset/wo/marine/medic
	name = "WO Dust Raider Hospital Corpsman"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrade = "ME3"
	role_comm_title = "HM"
	skills = /datum/skills/combat_medic

/datum/equipment_preset/wo/marine/medic/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_JACKET)
	generate_random_marine_primary_for_wo(H)
	add_common_wo_equipment(H)

//*****************************************************************************************************/

/datum/equipment_preset/wo/marine/pfc
	name = "WO Dust Raider Rifleman (PFC)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_WO

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrade = "ME2"
	role_comm_title = "RFN"
	skills = /datum/skills/pfc

/datum/equipment_preset/wo/marine/pfc/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)

	generate_random_marine_primary_for_wo(H)
	add_common_wo_equipment(H)
