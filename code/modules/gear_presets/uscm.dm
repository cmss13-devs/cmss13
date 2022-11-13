/datum/equipment_preset/uscm
	name = "USCM"
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	languages = list(LANGUAGE_ENGLISH)
	idtype = /obj/item/card/id/dogtag

	utility_under = list(/obj/item/clothing/under/marine)
	utility_hat = list(/obj/item/clothing/head/cmcap)
	utility_gloves = list(/obj/item/clothing/gloves/marine)
	utility_shoes = list(/obj/item/clothing/shoes/marine)
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
	var/auto_squad_name

/datum/equipment_preset/uscm/load_status(mob/living/carbon/human/H)
	H.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW)

/datum/equipment_preset/uscm/load_preset(mob/living/carbon/human/H, randomise, count_participant)
	. = ..()
	if(!auto_squad_name || is_admin_level(H.z))
		return
	if(!GLOB.data_core.manifest_modify(H.real_name, WEAKREF(H), assignment, rank))
		GLOB.data_core.manifest_inject(H)

	var/datum/squad/auto_squad = get_squad_by_name(auto_squad_name)
	if(auto_squad)
		transfer_marine_to_squad(H, auto_squad, H.assigned_squad, H.wear_id)
	if(!auto_squad.active)
		auto_squad.engage_squad(FALSE)

	H.marine_buy_flags &= ~MARINE_CAN_BUY_EAR
	H.sec_hud_set_ID()
	H.hud_set_squad()

	if(H.wear_l_ear)
		if(istype(H.wear_l_ear, /obj/item/device/radio/headset/almayer/marine))
			var/obj/item/device/radio/headset/almayer/marine/equipped_headset = H.wear_l_ear
			equipped_headset.add_hud_tracker(H)
	else if(H.wear_r_ear)
		if(istype(H.wear_r_ear, /obj/item/device/radio/headset/almayer/marine))
			var/obj/item/device/radio/headset/almayer/marine/equipped_headset = H.wear_r_ear
			equipped_headset.add_hud_tracker(H)


//*****************************************************************************************************/
/datum/equipment_preset/uscm/pfc
	name = "USCM Squad Rifleman"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrade = "ME2"
	role_comm_title = "RFN"
	skills = /datum/skills/pfc

/datum/equipment_preset/uscm/pfc/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/pfc/load_rank(mob/living/carbon/human/H)
	if(H.client)
		if(get_job_playtime(H.client, rank) < JOB_PLAYTIME_TIER_1)
			return "ME1"
	return paygrade

/datum/equipment_preset/uscm/pfc/cryo
	name = "USCM Cryo Squad Rifleman"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/pfc/cryo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/sg
	name = "USCM Squad Smartgunner"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrade = "ME3"
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/uscm/sg/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/sg/cryo
	name = "USCM Cryo Squad Smartgunner"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/sg/cryo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/sg/full
	name = "USCM Squad Smartgunner"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/sg/full/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/specrag(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)

/datum/equipment_preset/uscm/sg/full/load_status()
	return //No cryo munchies

//*****************************************************************************************************/

/datum/equipment_preset/uscm/tank
	name = "USCM Vehicle Crewman (CRMN) (Cryo)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_CREWMAN,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
	)
	assignment = JOB_CREWMAN
	rank = JOB_CREWMAN
	paygrade = "ME4"
	role_comm_title = "CRMN"
	minimum_age = 30
	skills = /datum/skills/tank_crew

/datum/equipment_preset/uscm/tank/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/vc(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/tanker, WEAR_JACKET)

/datum/equipment_preset/uscm/tank/load_status()
	return

//*****************************************************************************************************/

/datum/equipment_preset/uscm/tank/full
	name = "USCM Vehicle Crewman (CRMN)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/tanker)

/datum/equipment_preset/uscm/tank/full/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/vc(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech/tanker(H), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/smg/m39, /obj/item/ammo_magazine/smg/m39/extended, H, 0, 3)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/intel
	name = "USCM Intelligence Officer (IO) (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	idtype = /obj/item/card/id/silver
	access = list(
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_BRIG,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
	)
	assignment = JOB_INTEL
	rank = JOB_INTEL
	paygrade = "MO1"
	role_comm_title = "IO"
	skills = /datum/skills/intel

	utility_under = list(/obj/item/clothing/under/marine/officer/intel)

/datum/equipment_preset/uscm/intel/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/intel(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/tanker, WEAR_JACKET)

/datum/equipment_preset/uscm/intel/load_status()
	return //No cryo munchies

//*****************************************************************************************************/

/datum/equipment_preset/uscm/intel/full
	name = "USCM Intelligence Officer (IO)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/intel)

/datum/equipment_preset/uscm/intel/full/load_gear(mob/living/carbon/human/H)

	var/obj/item/clothing/under/marine/officer/intel/U = new(H)
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	U.attach_accessory(H, W)
	H.equip_to_slot_or_del(U, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/rto/intel(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/rto/intel(src), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(src), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/intel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/document(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)


	H.hud_set_squad()

/*****************************************************************************************************/
/datum/equipment_preset/uscm/spec
	name = "USCM (Cryo) Squad Weapons Specialist"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrade = "ME3"
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

/datum/equipment_preset/uscm/spec/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/specrag(H), WEAR_HEAD)

/datum/equipment_preset/uscm/spec/cryo
	name = "USCM Cryo Squad Weapons Specialist"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/spec/cryo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/spec/full_armor
	name = "USCM Weapons Specialist (B18 Armor)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/spec/full_armor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/specialist(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/specialist(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/spec/full_armor/load_status()
	return //No cryo munchies

//*****************************************************************************************************/

/datum/equipment_preset/uscm/medic
	name = "USCM Squad Hospital Corpsman"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrade = "ME3"
	role_comm_title = "HM"
	skills = /datum/skills/combat_medic

	utility_under = list(/obj/item/clothing/under/marine/medic)

/datum/equipment_preset/uscm/medic/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/medic/cryo
	name = "USCM Cryo Squad Hospital Corpsman"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/medic/cryo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/med(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/rto
	name = "USCM Squad Radio Telephone Operator"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_RTO_PREP)
	assignment = JOB_SQUAD_RTO
	rank = JOB_SQUAD_RTO
	paygrade = "ME4"
	role_comm_title = "RTO"
	skills = /datum/skills/rto

/datum/equipment_preset/uscm/rto/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/rto/cryo
	name = "USCM Cryo Squad Radio Telephone Operator"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/rto/cryo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/rto(H), WEAR_L_EAR)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/engineer
	name = "USCM Squad Combat Technician"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrade = "ME3"
	role_comm_title = "ComTech"
	skills = /datum/skills/combat_engineer

	utility_under = list(/obj/item/clothing/under/marine/engineer)

/datum/equipment_preset/uscm/engineer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/engineer/cryo
	name = "USCM Cryo Squad Combat Technician"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/engineer/cryo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/engi(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/leader
	name = "USCM Squad Leader"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrade = "ME5"
	role_comm_title = "SL"
	minimum_age = 27
	skills = /datum/skills/SL

/datum/equipment_preset/uscm/leader/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/leader/cryo
	name = "USCM Cryo Squad Leader"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/leader/cryo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/lead(H), WEAR_L_EAR)


//*****************************************************************************************************/
// ERT members that spawn with full gear from DEFCON

/datum/equipment_preset/uscm/private_equipped
	name = "USCM Squad Rifleman (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrade = "ME2"
	role_comm_title = "RFN"
	skills = /datum/skills/pfc/crafty

/datum/equipment_preset/uscm/private_equipped/load_rank(mob/living/carbon/human/H)
	if(H.client)
		if(get_job_playtime(H.client, rank) < JOB_PLAYTIME_TIER_1)
			return "ME1"
	return paygrade

/datum/equipment_preset/uscm/private_equipped/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41a(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/private_equipped/cryo
	name = "USCM Cryo Squad Rifleman (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO


//*****************************************************************************************************/

/datum/equipment_preset/uscm/leader_equipped
	name = "USCM Squad Leader (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrade = "ME5"
	role_comm_title = "SL"
	minimum_age = 27
	skills = /datum/skills/SL

/datum/equipment_preset/uscm/leader_equipped/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/lead(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/leader(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41a(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/leader_equipped/cryo
	name = "USCM Cryo Squad Leader (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO

//*****************************************************************************************************/

/datum/equipment_preset/uscm/smartgunner_equipped
	name = "USCM Squad Smartgunner (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrade = "ME3"
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/uscm/smartgunner_equipped/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)
	//Backup SMG Weapon
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(H), WEAR_L_EAR)

/datum/equipment_preset/uscm/smartgunner_equipped/cryo
	name = "USCM Cryo Squad Smartgunner (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO


//*****************************************************************************************************/

/datum/equipment_preset/uscm/engineer_equipped
	name = "USCM Squad Combat Technician (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrade = "ME3"
	role_comm_title = "ComTech"
	skills = /datum/skills/combat_engineer

	utility_under = list(/obj/item/clothing/under/marine/engineer)

/datum/equipment_preset/uscm/engineer_equipped/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/engi(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/engineer_equipped/cryo
	name = "USCM Cryo Squad Combat Technician (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO

//*****************************************************************************************************/

/datum/equipment_preset/uscm/medic_equipped
	name = "USCM Squad Hospital Corpsman (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrade = "ME3"
	role_comm_title = "HM"
	skills = /datum/skills/combat_medic

	utility_under = list(/obj/item/clothing/under/marine/medic)

/datum/equipment_preset/uscm/medic_equipped/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/med(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	if(prob(50))
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
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(H), WEAR_IN_BACK)

/datum/equipment_preset/uscm/medic_equipped/cryo
	name = "USCM Cryo Hospital Corpsman (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO


//*****************************************************************************************************/

/datum/equipment_preset/uscm/specialist_equipped
	name = "USCM Squad Weapons Specialist (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrade = "ME3"
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

/datum/equipment_preset/uscm/specialist_equipped/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(H), WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/magnetic_harness(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/spec_kit, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)

/datum/equipment_preset/uscm/specialist_equipped/cryo
	name = "USCM Cryo Squad Weapons Specialist (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO

//*****************************************************************************************************/

/datum/equipment_preset/uscm/specialist_equipped/sniper
	name = "USCM Sniper Specialist (Equipped)"

/datum/equipment_preset/uscm/specialist_equipped/sniper/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/ghillie(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/ghillie(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smock(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(H), WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/sniper/incendiary(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/sniper/flak(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/sniper/flak(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/sniper/M42A, /obj/item/ammo_magazine/sniper, H, 0, 5)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/rto_equipped
	name = "USCM Squad Radio Telephone Operator (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_RTO_PREP)
	assignment = JOB_SQUAD_RTO
	rank = JOB_SQUAD_RTO
	paygrade = "ME4"
	role_comm_title = "RTO"
	skills = /datum/skills/rto

/datum/equipment_preset/uscm/rto_equipped/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	var/obj/item/clothing/under/marine/rto/U = new(H)
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	U.attach_accessory(H, W)
	H.equip_to_slot_or_del(U, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/rto(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/rto(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/rto(src), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(src), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/rto(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)

	H.back.pickup()

/datum/equipment_preset/uscm/rto_equipped/cryo
	name = "USCM Cryo Squad Radio Telephone Operator (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO

//############ Marine Raiders #############
//Operator
/datum/equipment_preset/uscm/marsoc
	name = "Marine Raider"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Marine Raider"
	rank = JOB_MARINE_RAIDER
	role_comm_title = "Op."
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_TSL)
	skills = /datum/skills/commando/deathsquad
	auto_squad_name = SQUAD_SOF
	paygrade = "ME6"

/datum/equipment_preset/uscm/marsoc/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/uscm/marsoc/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/marsoc, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/super, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/super, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/super, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/marsoc, WEAR_FACE)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/marsoc, WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_HELMET)
	//uniform
	var/obj/item/clothing/under/marine/veteran/marsoc/M = new()
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/sof = new()
	H.equip_to_slot_or_del(sof, WEAR_JACKET)
	for(var/i in 1 to sof.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m40_sd, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite/m40_sd, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat/marsoc, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full, WEAR_R_STORE)

/datum/equipment_preset/uscm/marsoc/load_rank(mob/living/carbon/human/H)
	if(H.client)
		if(get_job_playtime(H.client, rank) > JOB_PLAYTIME_TIER_2)
			return "ME7"
	return paygrade

//Covert Raiders
/datum/equipment_preset/uscm/marsoc/covert
	name = "Marine Raiders (Covert)"
	uses_special_name = TRUE
/datum/equipment_preset/uscm/marsoc/covert/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	H.change_real_name(H, "[pick(nato_phonetic_alphabet)]")
	H.age = rand(20,30)
/datum/equipment_preset/uscm/marsoc/covert/load_rank(mob/living/carbon/human/H)
	return "O"

//Team Leader
/datum/equipment_preset/uscm/marsoc/sl
	name = "Marine Raider Team Leader"
	assignment = JOB_MARINE_RAIDER_SL
	rank = JOB_MARINE_RAIDER_SL
	role_comm_title = "TL."
	paygrade = "MO1"
	skills = /datum/skills/commando/deathsquad/leader

/datum/equipment_preset/uscm/marsoc/sl/load_rank(mob/living/carbon/human/H)
	if(H.client)
		if(get_job_playtime(H.client, rank) > JOB_PLAYTIME_TIER_2)
			return "MO2"
	return paygrade

//Codenamed Team Leader
/datum/equipment_preset/uscm/marsoc/sl/covert
	name = "Marine Raider Team Leader (Covert)"
	uses_special_name = TRUE
/datum/equipment_preset/uscm/marsoc/sl/covert/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	H.change_real_name(H, "[pick(nato_phonetic_alphabet)]")
	H.age = rand(20,30)
/datum/equipment_preset/uscm/marsoc/sl/covert/load_rank(mob/living/carbon/human/H)
	return "O"
//Officer
/datum/equipment_preset/uscm/marsoc/cmd
	name = "Marine Raider Officer"
	assignment = JOB_MARINE_RAIDER_CMD
	rank = JOB_MARINE_RAIDER_CMD
	role_comm_title = "CMD."
	paygrade = "MO3"
	skills = /datum/skills/commando/deathsquad/officer

/datum/equipment_preset/uscm/marsoc/cmd/load_rank(mob/living/carbon/human/H)
	if(H.client)
		if(get_job_playtime(H.client, rank) > JOB_PLAYTIME_TIER_3)
			return "MO4"
	return paygrade
