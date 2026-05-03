//////////////////// CIVILIAN ///////////////////////
////////////////////////////////////////////////////

// Civilian

/datum/equipment_preset/survivor/caperiver/civilian
	name = "Survivor - Cape River - Assistant"
	assignment = "Assistant"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/caperiver/civilian/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/spear(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	add_survivor_rare_item(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

// Engineer

/datum/equipment_preset/survivor/caperiver/engineer
	name = "Survivor - Cape River - Engineer"
	assignment = "Con-Am Engineer"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/caperiver/engineer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	add_survivor_weapon_civilian(new_human)
	..()

// Security Officer

/datum/equipment_preset/survivor/caperiver/security_officer
	name = "Survivor - Con-Am - Security Officer"
	assignment = "Con-Am Security"
	skills = /datum/skills/civilian/survivor/marshal
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	job_title = JOB_CMB
	role_comm_title = "SEC"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/caperiver/security_officer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/cmb(new_human), WEAR_HEAD)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(new_human), WEAR_HANDS)
	add_survivor_weapon_security(new_human)
	..()

// Scientist

/datum/equipment_preset/survivor/caperiver/scientist
	name = "Survivor - Cape River - Scientist"
	assignment = "Cape River Scientist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/caperiver/scientist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/purple(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/purple(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/unique/tier_three(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)
	add_random_survivor_research_gear(new_human)
	..()

// Medical

/datum/equipment_preset/survivor/caperiver/doctor
	name = "Survivor - Cape River - Doctor"
	assignment = "Cape River Station Doctor"
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/caperiver/doctor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/lightblue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/first_responder/full(new_human), WEAR_R_STORE)
	add_random_survivor_medical_gear(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

// Corporate

/datum/equipment_preset/survivor/conam_cl
	name = "Survivor - Cape River - Con-Am - Corporate Liaison" // A Corporate Liaison for Con-Amalagaged instead of Weyland-Yutani.
	assignment = "Con-Am - Corporate Liaison"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	paygrades = list(PAY_SHORT_WYC2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_WYC3 = JOB_PLAYTIME_TIER_2, PAY_SHORT_WYC4 = JOB_PLAYTIME_TIER_3, PAY_SHORT_WYC5 = JOB_PLAYTIME_TIER_4)
	job_title = JOB_HC_EXECUTIVE
	faction = FACTION_SURVIVOR
	idtype = /obj/item/card/id/silver/cl
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_WY_COLONIAL,
	)
	languages = list(LANGUAGE_ENGLISH)
	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/conam_cl/load_rank(mob/living/carbon/human/new_human, client/mob_client)
	if(paygrades.len == 1)
		return paygrades[1]
	var/playtime
	if(!mob_client)
		playtime = JOB_PLAYTIME_TIER_1
	else
		playtime = get_job_playtime(mob_client, JOB_CORPORATE_LIAISON)
		if((playtime >= JOB_PLAYTIME_TIER_1) && !mob_client.prefs.playtime_perks)
			playtime = JOB_PLAYTIME_TIER_1
	var/final_paygrade
	for(var/current_paygrade as anything in paygrades)
		var/required_time = paygrades[current_paygrade]
		if(required_time - playtime > 0)
			break
		final_paygrade = current_paygrade
	if(!final_paygrade)
		. = "???"
		CRASH("[key_name(new_human)] spawned with no valid paygrade.")

	return final_paygrade

/datum/equipment_preset/survivor/conam_cl/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather/fancy(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/gold(new_human), WEAR_ACCESSORY)
	add_survivor_weapon_civilian(new_human)
	add_random_cl_survivor_loot(new_human)
	..()

// Captain (CO Role)
/datum/equipment_preset/survivor/caperiver/captain
	name = "Survivor - Cape River - Captain"
	assignment = "Cape River Captain"
	skills = /datum/skills/commander
	idtype = /obj/item/card/id/gold
	role_comm_title = "Captain"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/caperiver/captain/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/director(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/disk/nuclear(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/stamp/captain(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/alt(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather(new_human), WEAR_HANDS)
	..()
