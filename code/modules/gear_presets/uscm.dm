
/datum/equipment_preset/uscm
	name = "USCM"

	languages = list("English")
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uscm/load_status(mob/living/carbon/human/H)
	H.nutrition = rand(60,250)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/pfc
	name = "USCM (Cryo) Squad Marine (PFC)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	assignment = "Squad Marine"
	rank = "Squad Marine"
	paygrade = "E2"
	role_comm_title = "Mar"
	skills = /datum/skills/pfc

/datum/equipment_preset/uscm/pfc/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)


/*****************************************************************************************************/

/datum/equipment_preset/uscm/pfc/full_plasma_rifle
	name = "USCM PFC (Pulse Rifle)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm/pfc/full_plasma_rifle/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/combat_knife(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/pfc/full_plasma_rifle/load_status()
	return //No cryo munchies

/*****************************************************************************************************/

/datum/equipment_preset/uscm/sg
	name = "USCM (Cryo) Smartgunner"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = "Squad Smartgunner"
	rank = "Squad Smartgunner"
	paygrade = "E4"
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/uscm/sg/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/sg/full
	name = "USCM Smartgunner"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm/sg/full/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/specrag(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/combat_knife(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)

/datum/equipment_preset/uscm/sg/full/load_status()
	return //No cryo munchies

/*****************************************************************************************************/

/datum/equipment_preset/uscm/tank
	name = "USCM Tank Crewman (TC)"
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_TANK)
	assignment = "Tank Crewman"
	rank = "Tank Crewman"
	paygrade = "E7"
	role_comm_title = "TC"
	skills = /datum/skills/tank_crew

/datum/equipment_preset/uscm/tank/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/industrial

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tanker(H), WEAR_HEAD)

/datum/equipment_preset/uscm/tank/load_status()
	return //No cryo munchies

/*****************************************************************************************************/

/datum/equipment_preset/uscm/intel
	name = "USCM Intelligence Officer (IO)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	idtype = /obj/item/card/id/silver
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PREP)
	assignment = "Intelligence Officer"
	rank = "Intelligence Officer"
	paygrade = "O1"
	role_comm_title = "IO"
	skills = /datum/skills/intel

/datum/equipment_preset/uscm/intel/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	var/obj/item/clothing/under/marine/officer/bridge/U = new(H)
	var/obj/item/clothing/tie/storage/webbing/W = new()
	U.hastie = W
	W.on_attached(U)

	H.equip_to_slot_or_del(U, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/ro(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/MP/intel(src), WEAR_JACKET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/document(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), WEAR_L_HAND)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/spec
	name = "USCM (Cryo) Squad Specialist"
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = "Squad Specialist"
	rank = "Squad Specialist"
	paygrade = "E5"
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

/datum/equipment_preset/uscm/spec/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/specrag(H), WEAR_HEAD)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/spec/full_armor
	name = "USCM Specialist (Armor)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm/spec/full_armor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/specialist(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/combat_knife(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/specialist(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/spec/full_armor/load_status()
	return //No cryo munchies

/*****************************************************************************************************/

/datum/equipment_preset/uscm/medic
	name = "USCM (Cryo) Squad Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = "Squad Medic"
	rank = "Squad Medic"
	paygrade = "E3"
	role_comm_title = "Med"
	skills = /datum/skills/combat_medic

/datum/equipment_preset/uscm/medic/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/medic
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/medic

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/engineer
	name = "USCM (Cryo) Squad Engineer"
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = "Squad Engineer"
	rank = "Squad Engineer"
	paygrade = "E3"
	role_comm_title = "Eng"
	skills = /datum/skills/combat_engineer

/datum/equipment_preset/uscm/engineer/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel/tech
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine/tech

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/leader
	name = "USCM (Cryo) Squad Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = "Squad Leader"
	rank = "Squad Leader"
	paygrade = "E6"
	role_comm_title = "SL"
	skills = /datum/skills/SL

/datum/equipment_preset/uscm/leader/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)