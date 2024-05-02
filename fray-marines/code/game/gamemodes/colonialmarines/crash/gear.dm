/datum/equipment_preset/crash
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE

//*****************************************************************************************************//

/datum/equipment_preset/synth/uscm/crash
	name = "Special Ship Support Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

/datum/equipment_preset/synth/uscm/crash/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/synth(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/RO(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/brown_vest(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/tan(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_L_STORE)

//*****************************************************************************************************//

/datum/equipment_preset/crash/commander
	name = "Special Ship Commander"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	assignment = JOB_CRASH_CO
	rank = JOB_CRASH_CO
	paygrade = "O5"
	role_comm_title = "CDR"
	skills = /datum/skills/commander
	idtype = /obj/item/card/id/gold

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

/datum/equipment_preset/crash/commander/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/datum/equipment_preset/crash/commander/load_gear(mob/living/carbon/human/new_human)
	var/sidearm = "Mateba"
	var/kit = null
	var/sidearmpath = /obj/item/storage/belt/gun/mateba/cmateba/full
	var/backItem = /obj/item/storage/backpack/satchel/lockable

	if(new_human.client && new_human.client.prefs)
		sidearm = new_human.client.prefs.commander_sidearm
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
	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)
	if(kit)
		new_human.equip_to_slot_or_del(new kit(new_human), WEAR_IN_BACK)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/command(new_human), WEAR_BODY)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/SO(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/sword/ceremonial(new_human), WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new sidearmpath(new_human), WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/techofficer/commander(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress/commander(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_L_HAND)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/command(new_human), WEAR_L_STORE)

//*****************************************************************************************************//

/datum/equipment_preset/crash/head_surgeron
	name = "Special Ship Head Surgeon" //CMO
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_CMO, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
	assignment = JOB_CRASH_CMO
	rank = JOB_CRASH_CMO
	paygrade = "CCMO"
	role_comm_title = "HS"
	skills = /datum/skills/CMO
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/crash/head_surgeron/load_gear(mob/living/carbon/human/new_human)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cmo(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(new_human), WEAR_HEAD)
	//new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmo(new_human), WEAR_HEAD)//2.10.2018 Will want to work on this a bit more, it doesn't quite fit. - Joshuu
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(new_human), WEAR_J_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human.back), WEAR_IN_BACK)

//*****************************************************************************************************//

/datum/equipment_preset/crash/bcm
	name = "Special Ship Crew Master" //CE
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_CRASH_CHIEF_ENGINEER
	rank = JOB_CRASH_CHIEF_ENGINEER
	paygrade = "E8"
	role_comm_title = "BCM"
	skills = /datum/skills/CE
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/crash/bcm/load_gear(mob/living/carbon/human/new_human)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/eng(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(new_human), WEAR_IN_BACK)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/pfc
	name = "USCM Squad Rifleman (PFC)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrade = "ME2"
	role_comm_title = "RFN"
	skills = /datum/skills/pfc

/datum/equipment_preset/crash/marine/pfc/load_gear(mob/living/carbon/human/new_human)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(new_human), WEAR_JACKET)

	generate_random_marine_primary_for_wo(new_human)
	add_common_wo_equipment(new_human)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/spec
	name = "USCM Squad Squad Weapons Specialist"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrade = "ME3"
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

/datum/equipment_preset/crash/marine/spec/load_gear(mob/living/carbon/human/new_human)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/magnetic_harness(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/spec_kit, WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(new_human), WEAR_L_STORE)

	add_common_wo_equipment(new_human)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/sg
	name = "USCM Squad Smartgunner"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrade = "ME3"
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/crash/marine/sg/load_gear(mob/living/carbon/human/new_human)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/specrag(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(new_human), WEAR_EYES)

	add_common_wo_equipment(new_human)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/medic
	name = "USCM Squad Hospital Corpsman"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrade = "ME3"
	role_comm_title = "HM"
	skills = /datum/skills/combat_medic

/datum/equipment_preset/crash/marine/medic/load_gear(mob/living/carbon/human/new_human)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(new_human), WEAR_L_STORE)

	generate_random_marine_primary_for_wo(new_human)
	add_common_wo_equipment(new_human)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/sl
	name = "USCM Squad Squad Leader"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrade = "ME5"
	role_comm_title = "SL"
	skills = /datum/skills/SL

/datum/equipment_preset/crash/marine/sl/load_gear(mob/living/carbon/human/new_human)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium/leader(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/map/current_map(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/designator(new_human), WEAR_IN_BACK)

	add_common_wo_equipment(new_human)

//*****************************************************************************************************//

/datum/equipment_preset/crash/marine/engineer
	name = "USCM Squad Combat Technician"
	flags = EQUIPMENT_PRESET_START_OF_ROUND_CRASH

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrade = "ME3"
	role_comm_title = "ComTech"
	skills = /datum/skills/combat_engineer

/datum/equipment_preset/crash/marine/engineer/load_gear(mob/living/carbon/human/new_human)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if(new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	new_human.equip_to_slot_or_del(new backItem(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_L_STORE)

	generate_random_marine_primary_for_wo(new_human)
	add_common_wo_equipment(new_human)

//*****************************************************************************************************//
