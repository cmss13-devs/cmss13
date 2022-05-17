/datum/equipment_preset/clf
	name = FACTION_CLF
	languages = list(LANGUAGE_JAPANESE, LANGUAGE_ENGLISH)
	assignment = JOB_CLF
	rank = FACTION_CLF
	faction = FACTION_CLF
	idtype = /obj/item/card/id/data

/datum/equipment_preset/clf/New()
	. = ..()
	access = get_antagonist_access()

/datum/equipment_preset/clf/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE, 40;FEMALE)
	var/random_name
	if(prob(50))
		if(H.gender == MALE)
			if(prob(50))
				random_name = "[pick(first_names_male_clf)] [pick(last_names_clf)]"
		else
			random_name = "[pick(first_names_female_clf)] [pick(last_names_clf)]"
	else
		random_name = "[capitalize(randomly_generate_japanese_word(rand(1, 4)))] [capitalize(randomly_generate_japanese_word(rand(1, 4)))]"
	H.change_real_name(H, random_name)
	H.age = rand(17,45)
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19

//*****************************************************************************************************/

/datum/equipment_preset/clf/soldier
	name = "CLF Soldier"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF
	rank = JOB_CLF
	role_comm_title = "GRL"

	skills = /datum/skills/clf

/datum/equipment_preset/clf/soldier/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/colonist/clf/jumpsuit = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	jumpsuit.attach_accessory(H, W)
	H.equip_to_slot_or_del(jumpsuit, WEAR_BODY)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/full/random(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/cmb(H), WEAR_BACK)
	if(prob(50))
		spawn_rebel_smg(H)
	else
		spawn_rebel_rifle(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(H), WEAR_L_EAR)


//*****************************************************************************************************/

/datum/equipment_preset/clf/soldier/cryo
	name = "CLF Cryo Soldier"

/datum/equipment_preset/clf/soldier/cryo/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/clf/engineer
	name = "CLF Engineer"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_ENGI
	rank = JOB_CLF_ENGI
	role_comm_title = "TECH"

	skills = /datum/skills/clf/combat_engineer

/datum/equipment_preset/clf/engineer/load_gear(mob/living/carbon/human/H)

	var/obj/item/clothing/under/colonist/clf/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)

	spawn_rebel_suit(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)

	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson/refurbished, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/welding, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/cct, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/low_grade_full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_R_STORE)

	spawn_rebel_weapon(H)
	spawn_rebel_weapon(H,1)

//*****************************************************************************************************/

/datum/equipment_preset/clf/engineer/cryo
	name = "CLF Cryo Engineer"

/datum/equipment_preset/clf/engineer/cryo/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/clf/medic
	name = "CLF Medic"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_MEDIC
	rank = JOB_CLF_MEDIC
	role_comm_title = "MED"
	skills = /datum/skills/clf/combat_medic

/datum/equipment_preset/clf/medic/load_gear(mob/living/carbon/human/H)

	var/obj/item/clothing/under/colonist/clf/CLF = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	CLF.attach_accessory(H, W)
	H.equip_to_slot_or_del(CLF, WEAR_BODY)

	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BELT)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/structure/bed/portable_surgery(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large(H), WEAR_R_STORE)

	spawn_rebel_smg(H)

//*****************************************************************************************************/

/datum/equipment_preset/clf/medic/cryo
	name = "CLF Cryo Medic"

/datum/equipment_preset/clf/medic/cryo/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/clf/specialist
	name = "CLF Specialist"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_SPECIALIST
	rank = JOB_CLF_SPECIALIST
	role_comm_title = "SPC"
	skills = /datum/skills/clf/specialist

/datum/equipment_preset/clf/specialist/load_gear(mob/living/carbon/human/H)

	//jumpsuit and their webbing
	var/obj/item/clothing/under/colonist/clf/CLF = new()
	var/obj/item/clothing/accessory/storage/webbing/five_slots/W = new()
	CLF.attach_accessory(H, W)
	H.equip_to_slot_or_del(CLF, WEAR_BODY)
	//clothing
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/swat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/cct(H), WEAR_L_EAR)
	//standard backpack stuff
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	//specialist backpack stuff
	H.equip_to_slot_or_del(new /obj/item/prop/folded_anti_tank_sadar(H), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_IN_BACK)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)

	if(prob(75))
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
		spawn_rebel_specialist_weapon(H, 10)
	else
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_JACKET)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_JACKET)
		spawn_weapon(/obj/item/weapon/gun/lever_action/r4t, /obj/item/ammo_magazine/handful/lever_action, H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/clf/specialist/cryo
	name = "CLF Cryo Specialist"

/datum/equipment_preset/clf/specialist/cryo/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/clf/leader
	name = "CLF Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_LEADER
	rank = JOB_CLF_LEADER
	role_comm_title = "LDR"
	skills = /datum/skills/clf/leader

/datum/equipment_preset/clf/leader/load_gear(mob/living/carbon/human/H)

	//No random armor, so that it's more clear that he's the leader
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/cct(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/screwdriver(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/multitool(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_R_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/mar40, /obj/item/ammo_magazine/rifle/mar40, H)

//*****************************************************************************************************/

/datum/equipment_preset/clf/synth
	name = "CLF Multipurpose Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/colonial_synthetic
	assignment = JOB_CLF_SYNTH
	rank = JOB_CLF_SYNTH
	role_comm_title = "SYN"


/datum/equipment_preset/clf/synth/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_clf)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_clf)]"
	H.change_real_name(H, random_name)
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/data

/datum/equipment_preset/clf/synth/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_COLONY)

/datum/equipment_preset/clf/synth/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/colonist/clf/CLF = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	CLF.attach_accessory(H, W)
	H.equip_to_slot_or_del(CLF, WEAR_BODY)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/mar40/carbine, /obj/item/ammo_magazine/rifle/mar40/extended, H, 0, 10)

	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/cct(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/synth, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

//*****************************************************************************************************/



/datum/equipment_preset/clf/leader/cryo
	name = "CLF Cryo Leader"

/datum/equipment_preset/clf/leader/cryo/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/clf/commander
	name = "CLF Cell Commander"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_COMMANDER
	rank = JOB_CLF_COMMANDER
	role_comm_title = "CMDR"
	skills = /datum/skills/clf/commander

/datum/equipment_preset/clf/commander/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/cct(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia/smartgun(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba/highimpact(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba/highimpact(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/clf(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack/clf(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/clf/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(H), WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_R_STORE)
