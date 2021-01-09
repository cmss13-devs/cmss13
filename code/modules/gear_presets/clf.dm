/datum/equipment_preset/clf
	name = FACTION_CLF
	languages = list("Japanese", "English")
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
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_clf)] [pick(last_names_clf)]"
	else
		random_name = "[pick(first_names_female_clf)] [pick(last_names_clf)]"
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
	role_comm_title = "Grl"

	skills = /datum/skills/clf

/datum/equipment_preset/clf/soldier/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	spawn_rebel_belt(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_R_STORE)

	spawn_rebel_weapon(H)
	spawn_rebel_weapon(H,1)

//*****************************************************************************************************/

/datum/equipment_preset/clf/soldier/cryo
	name = "CLF Cryo Soldier"

/datum/equipment_preset/clf/soldier/cryo/load_gear(mob/living/carbon/human/H)
	return

//*****************************************************************************************************/

/datum/equipment_preset/clf/survivor
	name = "CLF Survivor"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/civilian/survivor/clf

/datum/equipment_preset/clf/survivor/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	spawn_rebel_belt(H)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/clf/engineer
	name = "CLF Engineer"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_CLF_ENGI
	rank = JOB_CLF_ENGI
	role_comm_title = "Tech"

	skills = /datum/skills/clf/combat_engineer

/datum/equipment_preset/clf/engineer/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

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
	role_comm_title = "Med"
	skills = /datum/skills/clf/combat_medic

/datum/equipment_preset/clf/medic/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full(H), WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)

	spawn_rebel_weapon(H)

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
	role_comm_title = "Spc"
	skills = /datum/skills/clf/specialist

/datum/equipment_preset/clf/specialist/load_gear(mob/living/carbon/human/H)

	//specific armor for specialist
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/swat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/sparepouch(H), WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)

	spawn_rebel_specialist_weapon(H)

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
	role_comm_title = "Ldr"
	skills = /datum/skills/clf/leader

/datum/equipment_preset/clf/leader/load_gear(mob/living/carbon/human/H)

	//No random armor, so that it's more clear that he's the leader
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	spawn_rebel_belt(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_R_STORE)

	spawn_rebel_weapon(H)
	spawn_rebel_weapon(H,1)

//*****************************************************************************************************/

/datum/equipment_preset/clf/synth
	name = "CLF Multipurpose Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/early_synthetic
	assignment = "CLF Multipurpose Synthetic"
	rank = "CLF Multipurpose Synthetic"
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
	H.set_species("Early Synthetic")

/datum/equipment_preset/clf/synth/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia, WEAR_JACKET)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/heavy, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/heavy, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/heavy, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/attachable/bayonet/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/synth, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

//*****************************************************************************************************/



/datum/equipment_preset/clf/leader/cryo
	name = "CLF Cryo Leader"

/datum/equipment_preset/clf/leader/cryo/load_gear(mob/living/carbon/human/H)
	return
