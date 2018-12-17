
/datum/equipment_preset/other
	name = "Other"

/datum/equipment_preset/other/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))

/*****************************************************************************************************/

/datum/equipment_preset/other/pmc_standard
	name = "Weyland-Yutani PMC (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/pmc_standard/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "Weyland-Yutani PMC (Standard)"
	W.rank = "PMC Standard"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.paygrade = "PMC1"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "PMC"
		H.mind.special_role = "MODE"

/datum/equipment_preset/other/pmc_standard/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc)

/datum/equipment_preset/other/pmc_standard/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	var/choice = rand(1,4)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/baton(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)

	switch(choice)
		if(1,2,3)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap(H.back), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap(H.back), WEAR_IN_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_vp70(H), WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_vp70(H), WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(H.back), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(H.back), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(H.back), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/other/pmc_leader
	name = "Weyland-Yutani PMC (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/pmc_leader/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "PMC Officer"
	W.rank = "PMC Leader"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.paygrade = "PMC4"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "SL"
		H.mind.assigned_role = "PMC Leader"
		H.mind.special_role = "MODE"

/datum/equipment_preset/other/pmc_leader/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/SL/pmc)

/datum/equipment_preset/other/pmc_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/leader(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/leader(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/leader(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/baton(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/other/pmc_gunner
	name = "Weyland-Yutani PMC (Gunner)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/pmc_gunner/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "PMC Specialist"
	W.rank = "PMC Gunner"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.paygrade = "PMC3"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Spc"
		H.mind.assigned_role = "PMC"
		H.mind.special_role = "MODE"

/datum/equipment_preset/other/pmc_gunner/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/smartgunner/pmc)

/datum/equipment_preset/other/pmc_gunner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/gunner(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack/snow(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)

/*****************************************************************************************************/

/datum/equipment_preset/other/pmc_sniper
	name = "Weyland-Yutani PMC (Sniper)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/pmc_sniper/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "PMC Sniper"
	W.rank = "PMC Sharpshooter"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.paygrade = "PMC3"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Spc"
		H.mind.assigned_role = "PMC"
		H.mind.special_role = "MODE"

/datum/equipment_preset/other/pmc_sniper/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/specialist/pmc)

/datum/equipment_preset/other/pmc_sniper/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/sniper(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/sniper(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/elite(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sniper(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/other/deathsquad
	name = "Weyland-Yutani Deathsquad"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/deathsquad/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Commando"
	W.rank = "PMC Commando"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "DEATH SQUAD"

/datum/equipment_preset/other/deathsquad/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/commando/deathsquad)

/datum/equipment_preset/other/deathsquad/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles	(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/commando(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/commando(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/commando(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite(H), WEAR_J_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/other/freelancer_standard
	name = "Freelancer (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/freelancer_standard/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.assignment = "Freelancer"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_all_accesses()
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "FREELANCERS"

/datum/equipment_preset/other/freelancer_standard/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc)

/datum/equipment_preset/other/freelancer_standard/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general(H), WEAR_R_STORE)

	spawn_merc_gun(H)
	spawn_rebel_gun(H,1)

/*****************************************************************************************************/

/datum/equipment_preset/other/freelancer_medic
	name = "Freelancer (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/freelancer_medic/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.assignment = "Freelancer Medic"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_all_accesses()
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "FREELANCERS"

/datum/equipment_preset/other/freelancer_medic/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/combat_medic)

/datum/equipment_preset/other/freelancer_medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

	spawn_merc_gun(H)

/*****************************************************************************************************/

/datum/equipment_preset/other/freelancer_leader
	name = "Freelancer (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/freelancer_leader/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.assignment = "Freelancer Warlord"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_all_accesses()
	if(H.mind)
		H.mind.role_comm_title = "Lead"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "FREELANCERS"

/datum/equipment_preset/other/freelancer_leader/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/SL)

/datum/equipment_preset/other/freelancer_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer/beret(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

	spawn_merc_gun(H)
	spawn_merc_gun(H,1)

/datum/equipment_preset/other/freelancer_leader/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English", "Russian", "Tradeband", "Sainja"))

/*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_heavy
	name = "Mercenary (Heavy)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mercenary_heavy/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Mercenary"
	W.rank = "Mercenary Enforcer"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "MERCENARIES"

/datum/equipment_preset/other/mercenary_heavy/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/mercenary)

/datum/equipment_preset/other/mercenary_heavy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)

	spawn_merc_gun(H)
	spawn_merc_gun(H,1)

/*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_miner
	name = "Mercenary (Miner)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mercenary_miner/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Mercenary"
	W.rank = "Mercenary Worker"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "MERCENARIES"

/datum/equipment_preset/other/mercenary_miner/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/mercenary)

/datum/equipment_preset/other/mercenary_miner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_engineer
	name = "Mercenary (Engineer)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mercenary_engineer/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Mercenary"
	W.rank = "Mercenary Engineer"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "MERCENARIES"

/datum/equipment_preset/other/mercenary_engineer/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/mercenary)

/datum/equipment_preset/other/mercenary_engineer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/engineer(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/engineer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/other/business_person
	name = "Business Person"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/business_person/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access = get_all_centcom_access()
	W.assignment = "Corporate Representative"
	W.registered_name = H.real_name
	H.equip_if_possible(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"

/datum/equipment_preset/other/business_person/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/civilian)

/datum/equipment_preset/other/business_person/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_if_possible(new /obj/item/clothing/under/lawyer/bluesuit(H), WEAR_BODY)
	H.equip_if_possible(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_if_possible(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)

	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)
	H.equip_if_possible(new /obj/item/clipboard(H), WEAR_WAIST)

/*****************************************************************************************************/

/datum/equipment_preset/other/compression_suit
	name = "Mk50 Compression Suit"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/compression_suit/load_id(mob/living/carbon/human/H)
	. = ..()

/datum/equipment_preset/other/compression_suit/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc)

/datum/equipment_preset/other/compression_suit/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots(H), WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/compression(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/compression(H), WEAR_HEAD)
	var /obj/item/tank/jetpack/J = new /obj/item/tank/jetpack/oxygen(H)
	H.equip_to_slot_or_del(J, WEAR_BACK)
	J.toggle()
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), WEAR_FACE)
	J.Topic(null, list("stat" = 1))
	spawn_merc_gun(H)
