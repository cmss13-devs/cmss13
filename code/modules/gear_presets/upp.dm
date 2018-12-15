

/datum/equipment_preset/upp
	name = "UPP"

/datum/equipment_preset/upp/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("Russian", "English"))

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier
	name = "UPP Soldier (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/soldier/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "UPP Soldier"
	W.registered_name = H.real_name
	W.access = get_antagonist_access()
	W.paygrade = "E1"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/upp/soldier/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc/crafty)

/datum/equipment_preset/upp/soldier/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/survivor
	name = "UPP Survivor"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/survivor/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "UPP Soldier"
	W.registered_name = H.real_name
	W.access = get_antagonist_access()
	W.paygrade = "E1"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/upp/survivor/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/civilian/survivor/doctor)

/datum/equipment_preset/upp/survivor/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier_medic
	name = "UPP Soldier (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/soldier_medic/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "UPP Medic"
	W.registered_name = H.real_name
	W.paygrade = "E4"
	W.access = get_antagonist_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Cpl"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/upp/soldier_medic/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/combat_medic/crafty)

/datum/equipment_preset/upp/soldier_medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/combatLifesaver/upp(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/skorpion/upp(H), WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/skorpion(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/skorpion(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/upp_smg, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier_heavy
	name = "UPP Soldier (Heavy)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/soldier_heavy/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "UPP Specialist"
	W.registered_name = H.real_name
	W.paygrade = "E5"
	W.access = get_antagonist_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Spc"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/upp/soldier_heavy/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/specialist/upp)

/datum/equipment_preset/upp/soldier_heavy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/heavy(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP/heavy(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/c99/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier_leader
	name = "UPP Soldier (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/soldier_leader/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "UPP Leader"
	W.registered_name = H.real_name
	W.paygrade = "E6"
	W.access = get_antagonist_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "SL"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/upp/soldier_leader/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/SL/upp)

/datum/equipment_preset/upp/soldier_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/heavy(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/standard(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando
	name = "UPP Commando (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/commando/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "UPP Commando"
	W.registered_name = H.real_name
	W.paygrade = "E2"
	W.access = get_antagonist_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/upp/commando/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/commando)

/datum/equipment_preset/upp/commando/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon	(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando_medic
	name = "UPP Commando (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/commando_medic/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "UPP Commando Medic"
	W.registered_name = H.real_name
	W.paygrade = "E4"
	W.access = get_antagonist_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Cpl"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/upp/commando_medic/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/commando/medic)

/datum/equipment_preset/upp/commando_medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon	(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando_medic
	name = "UPP Commando (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/commando_medic/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "UPP Commando Leader"
	W.registered_name = H.real_name
	W.paygrade = "E6"
	W.access = get_antagonist_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "SL"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "UPP"

/datum/equipment_preset/upp/commando_medic/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/commando/leader)

/datum/equipment_preset/upp/commando_medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon	(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
