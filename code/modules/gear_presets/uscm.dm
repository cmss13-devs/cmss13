
/datum/equipment_preset/uscm
	name = "USCM"

/datum/equipment_preset/uscm/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))

/datum/equipment_preset/uscm/load_status(mob/living/carbon/human/H)
	H.nutrition = rand(60,250)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/pfc
	name = "USCM PFC (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/uscm/pfc/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP)
	W.assignment = "Squad Marine"
	W.rank = "Squad Marine"
	W.registered_name = H.real_name
	W.paygrade = "E2"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Mar"
		H.mind.assigned_role = "Squad Marine"

/datum/equipment_preset/uscm/pfc/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc)

/datum/equipment_preset/uscm/pfc/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels

/*****************************************************************************************************/

/datum/equipment_preset/uscm/pfc/full_plasma_rifle
	name = "USCM PFC (Plasma Rifle)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm/pfc/full_plasma_rifle/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(H), WEAR_BACK)
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
	name = "USCM Smartgunner (Cryo)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm/sg/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	W.assignment = "Squad Smartgunner"
	W.rank = "Squad Smartgunner"
	W.registered_name = H.real_name
	W.paygrade = "E3"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "LCpl"
		H.mind.assigned_role = "Squad Smartgunner"

/datum/equipment_preset/uscm/sg/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/smartgunner)

/datum/equipment_preset/uscm/sg/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels

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

/datum/equipment_preset/uscm/tank/full
	name = "USCM Tank Crewman"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm/tank/full/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

/datum/equipment_preset/uscm/tank/full/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/tank_crew)

/datum/equipment_preset/uscm/tank/full/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.assignment = "Tank Crewman"
	W.rank = "Tank Crewman"
	W.registered_name = H.real_name
	W.paygrade = "O1"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "TC"
		H.mind.assigned_role = "Tank Crewman"

/datum/equipment_preset/uscm/tank/full/load_status()
	return //No cryo munchies

/*****************************************************************************************************/


/datum/equipment_preset/uscm/spec/full_armor
	name = "USCM Specialist (Armor)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/uscm/tank/full_armor/load_gear(mob/living/carbon/human/H)
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

/datum/equipment_preset/uscm/spec/full_armor/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/specialist)

/datum/equipment_preset/uscm/spec/full_armor/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/dogtag/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	W.assignment = "Squad Specialist"
	W.rank = "Squad Specialist"
	W.registered_name = H.real_name
	W.paygrade = "E5"
	H.equip_to_slot_or_del(W, WEAR_ID)
	
	if(H.mind)
		H.mind.role_comm_title = "Spc"
		H.mind.assigned_role = "Squad Specialist"

/datum/equipment_preset/uscm/spec/full_armor/load_status()
	return //No cryo munchies








