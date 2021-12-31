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
	service_over = list(/obj/item/clothing/suit/storage/jacket/marine/service)
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
	if(!auto_squad_name)
		return
	if(!GLOB.data_core.manifest_modify(H.real_name, WEAKREF(H), assignment, rank))
		GLOB.data_core.manifest_inject(H)

	var/datum/squad/auto_squad = get_squad_by_name(auto_squad_name)
	if(auto_squad)
		transfer_marine_to_squad(H, auto_squad, H.assigned_squad, H.wear_id)

	H.marine_buy_flags &= ~MARINE_CAN_BUY_EAR
	H.sec_hud_set_ID()
	H.hud_set_squad()

//*****************************************************************************************************/

/datum/equipment_preset/uscm/pfc
	name = "USCM (Cryo) Squad Marine (PFC)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrade = "ME2"
	role_comm_title = "Mar"
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

/datum/equipment_preset/uscm/pfc/echo
	name = "USCM Echo Squad Marine (PFC)"
	auto_squad_name = SQUAD_NAME_5

/datum/equipment_preset/uscm/pfc/echo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/pfc/full_plasma_rifle
	name = "USCM PFC (Pulse Rifle)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/pfc/full_plasma_rifle/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/pfc/full_plasma_rifle/load_status()
	return //No cryo munchies

//*****************************************************************************************************/

/datum/equipment_preset/uscm/sg
	name = "USCM (Cryo) Smartgunner"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrade = "ME4"
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/uscm/sg/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/sg/echo
	name = "USCM Echo Smartgunner"
	auto_squad_name = SQUAD_NAME_5

/datum/equipment_preset/uscm/sg/echo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/sg/full
	name = "USCM Smartgunner"
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
	paygrade = "ME7"
	role_comm_title = "CRMN"
	minimum_age = 30
	skills = /datum/skills/tank_crew

/datum/equipment_preset/uscm/tank/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

/datum/equipment_preset/uscm/tank/load_status()
	return

//*****************************************************************************************************/

/datum/equipment_preset/uscm/tank/full
	name = "USCM Vehicle Crewman (CRMN)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/tanker)

/datum/equipment_preset/uscm/tank/full/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tanker(H), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/smg/m39, /obj/item/ammo_magazine/smg/m39/extended, H, 0, 3)

	H.hud_set_squad()

/*****************************************************************************************************/
/datum/equipment_preset/uscm/spec
	name = "USCM (Cryo) Squad Specialist"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrade = "ME4"
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

/datum/equipment_preset/uscm/spec/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/specrag(H), WEAR_HEAD)

/datum/equipment_preset/uscm/spec/echo
	name = "USCM Echo Squad Specialist"
	auto_squad_name = SQUAD_NAME_5

/datum/equipment_preset/uscm/spec/echo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/spec/full_armor
	name = "USCM Specialist (B18 Armor)"
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
	name = "USCM (Cryo) Squad Medic"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrade = "ME3"
	role_comm_title = "Med"
	skills = /datum/skills/combat_medic

	utility_under = list(/obj/item/clothing/under/marine/medic)

/datum/equipment_preset/uscm/medic/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/medic/echo
	name = "USCM Echo Squad Medic"
	auto_squad_name = SQUAD_NAME_5

/datum/equipment_preset/uscm/medic/echo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo/med(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/rto
	name = "USCM (Cryo) Squad RT Operator"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_RTO_PREP)
	assignment = JOB_SQUAD_RTO
	rank = JOB_SQUAD_RTO
	paygrade = "ME5"
	role_comm_title = "RTO"
	skills = /datum/skills/rto

/datum/equipment_preset/uscm/rto/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/rto/echo
	name = "USCM Echo Squad RT Operator"
	auto_squad_name = SQUAD_NAME_5

/datum/equipment_preset/uscm/rto/echo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo/rto(H), WEAR_L_EAR)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/engineer
	name = "USCM (Cryo) Squad Engineer"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrade = "ME3"
	role_comm_title = "Eng"
	skills = /datum/skills/combat_engineer

	utility_under = list(/obj/item/clothing/under/marine/engineer)

/datum/equipment_preset/uscm/engineer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/engineer/echo
	name = "USCM Echo Squad Engineer"
	auto_squad_name = SQUAD_NAME_5

/datum/equipment_preset/uscm/engineer/echo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo/engi(H), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/leader
	name = "USCM (Cryo) Squad Leader"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrade = "ME6"
	role_comm_title = "SL"
	minimum_age = 27
	skills = /datum/skills/SL

/datum/equipment_preset/uscm/leader/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/datum/equipment_preset/uscm/leader/echo
	name = "USCM Echo Squad Leader"
	auto_squad_name = SQUAD_NAME_5

/datum/equipment_preset/uscm/leader/echo/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo/lead(H), WEAR_L_EAR)


//*****************************************************************************************************/
// ERT members that spawn with full gear from DEFCON

/datum/equipment_preset/uscm/private_equipped
	name = "USCM Cryo Squad Marine (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrade = "ME2"
	role_comm_title = "Pfc"
	skills = /datum/skills/pfc/crafty

/datum/equipment_preset/uscm/private_equipped/load_rank(mob/living/carbon/human/H)
	if(H.client)
		if(get_job_playtime(H.client, rank) < JOB_PLAYTIME_TIER_1)
			return "ME1"
	return paygrade

/datum/equipment_preset/uscm/private_equipped/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo(H), WEAR_L_EAR)
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

/datum/equipment_preset/uscm/private_equipped/echo
	name = "USCM Echo Squad Marine (Equipped)"
	auto_squad_name = SQUAD_NAME_5


//*****************************************************************************************************/

/datum/equipment_preset/uscm/leader_equipped
	name = "USCM Cryo Squad Leader (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrade = "ME6"
	role_comm_title = "SL"
	minimum_age = 27
	skills = /datum/skills/SL

/datum/equipment_preset/uscm/leader_equipped/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo/lead(H), WEAR_L_EAR)
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

/datum/equipment_preset/uscm/leader_equipped/echo
	name = "USCM Echo Squad Leader (Equipped)"
	auto_squad_name = SQUAD_NAME_5

//*****************************************************************************************************/

/datum/equipment_preset/uscm/smartgunner_equipped
	name = "USCM Cryo Squad Smartgunner (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrade = "ME4"
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
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo(H), WEAR_L_EAR)

/datum/equipment_preset/uscm/smartgunner_equipped/echo
	name = "USCM Echo Squad Smartgunner (Equipped)"
	auto_squad_name = SQUAD_NAME_5


//*****************************************************************************************************/

/datum/equipment_preset/uscm/engineer_equipped
	name = "USCM Cryo Squad Engineer (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrade = "ME3"
	role_comm_title = "Eng"
	skills = /datum/skills/combat_engineer

	utility_under = list(/obj/item/clothing/under/marine/engineer)

/datum/equipment_preset/uscm/engineer_equipped/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo/engi(H), WEAR_L_EAR)
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

/datum/equipment_preset/uscm/engineer_equipped/echo
	name = "USCM Echo Squad Engineer (Equipped)"
	auto_squad_name = SQUAD_NAME_5

//*****************************************************************************************************/

/datum/equipment_preset/uscm/medic_equipped
	name = "USCM Cryo Squad Medic (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrade = "ME3"
	role_comm_title = "Med"
	skills = /datum/skills/combat_medic

	utility_under = list(/obj/item/clothing/under/marine/medic)

/datum/equipment_preset/uscm/medic_equipped/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo/med(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(H), WEAR_L_STORE)
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

/datum/equipment_preset/uscm/medic_equipped/echo
	name = "USCM Echo Squad Medic (Equipped)"
	auto_squad_name = SQUAD_NAME_5


//*****************************************************************************************************/

/datum/equipment_preset/uscm/specialist_equipped
	name = "USCM Cryo Squad Specialist (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrade = "ME4"
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
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_BACK)

/datum/equipment_preset/uscm/specialist_equipped/echo
	name = "USCM Echo Squad Specialist (Equipped)"
	auto_squad_name = SQUAD_NAME_5

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
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo(H), WEAR_L_EAR)
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
	name = "USCM Cryo Squad RT Operator (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_RTO_PREP)
	assignment = JOB_SQUAD_RTO
	rank = JOB_SQUAD_RTO
	paygrade = "ME5"
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
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/echo/rto(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/rto(src), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(src), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/rto(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)

/datum/equipment_preset/uscm/rto_equipped/echo
	name = "USCM Echo Squad RT Operator (Equipped)"
	auto_squad_name = SQUAD_NAME_5

/datum/equipment_preset/marsoc
	name = "MARSOC Operator"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MARINE
	assignment = "MARSOC Operator"
	uses_special_name = TRUE
	rank = JOB_MARSOC
	role_comm_title = "Op."
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_TSL)
	skills = /datum/skills/commando/deathsquad
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/marsoc/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	H.change_real_name(H, "[pick(nato_phonetic_alphabet)]")
	H.age = rand(20,30)

/datum/equipment_preset/marsoc/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/marsoc/load_gear(mob/living/carbon/human/H)
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
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/marsoc, WEAR_FACE)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/marsoc, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/functional, WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_HELMET)
	//uniform
	var/obj/item/clothing/under/marine/veteran/marsoc/M = new()
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/marsoc/armor = new()
	H.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
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
