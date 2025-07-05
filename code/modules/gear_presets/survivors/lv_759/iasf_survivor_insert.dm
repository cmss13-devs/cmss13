///////////////////////////////////////////////////////////////////

/// Hybrisa - IASF - Paratrooper survivors

/datum/equipment_preset/survivor/iasf
	name = "Survivor - IASF"
	paygrades = list(PAY_SHORT_IASFE2 = JOB_PLAYTIME_TIER_0)
	job_title = JOB_SURVIVOR
	skills = /datum/skills/iasf
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	faction = FACTION_IASF
	faction_group = FACTION_LIST_SURVIVOR_IASF
	minimap_icon = "rmc_rifleman"
	minimap_background = "background_iasf"
	role_comm_title = "24/PARA"
	idtype = /obj/item/card/id/dogtag
	flags = EQUIPMENT_PRESET_EXTRA
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
	)

/datum/equipment_preset/survivor/iasf/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/royal_marine/iasf/uniform = new()
	var/random_number = rand(1,4)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/neckerchief/brown, WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/iasf, WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/neckerchief/brown, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/iasf, WEAR_JACKET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/neckerchief/brown, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/rmc/service/iasf_combat_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine/generic(new_human), WEAR_IN_BACK)
		if(4)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/iasf, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/iasf_para_belt/webley_near_empty(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/iasf_beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/royal_marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/iasf(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/twe, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/iasf, WEAR_JACKET)

///////////////////////////////////////////////////////////////////

/datum/equipment_preset/survivor/iasf/paratrooper
	name = "Survivor - IASF Paratrooper"
	paygrades = list(PAY_SHORT_IASFE2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_IASFE2 = JOB_PLAYTIME_TIER_1)
	assignment = "IASF - Paratrooper"
	job_title = JOB_TWE_IASF_PARA
	skills = /datum/skills/iasf

/datum/equipment_preset/survivor/iasf/paratrooper/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/royal_marine/iasf/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)

	..()

///////////////////////////////////////////////////////////////////

/datum/equipment_preset/survivor/iasf/engi
	name = "Survivor - IASF Combat Engineer"
	paygrades = list(PAY_SHORT_IASFE3 = JOB_PLAYTIME_TIER_0)
	assignment = "IASF - Combat Engineer"
	job_title = JOB_TWE_IASF_PARA_ENGI

	minimap_icon = "rmc_breacher"

	skills = /datum/skills/iasf/engi

/datum/equipment_preset/survivor/iasf/engi/load_gear(mob/living/carbon/human/new_human)

	var/obj/item/clothing/under/marine/veteran/royal_marine/iasf/uniform = new()
	var/R = rand(1,2)
	switch(R)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine/iasf (new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/iasf, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)

	..()

///////////////////////////////////////////////////////////////////

/datum/equipment_preset/survivor/iasf/medic
	name = "Survivor - IASF Combat Medical Technician"
	paygrades = list(PAY_SHORT_IASFE3 = JOB_PLAYTIME_TIER_0)
	assignment = "IASF - Combat Medical Technician"
	job_title = JOB_TWE_IASF_PARA_MEDIC

	minimap_icon = "rmc_medic"

	skills = /datum/skills/iasf/medic

/datum/equipment_preset/survivor/iasf/medic/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/royal_marine/iasf/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/iasf, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine/generic(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/rmc/survivor(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90/twe, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90/twe, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90/twe, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/medium/medic(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BACK)

	..()

///////////////////////////////////////////////////////////////////

/datum/equipment_preset/survivor/iasf/pilot
	name = "Survivor - IASF Dropship Pilot"
	assignment = "IASF - Dropship Pilot"
	job_title = JOB_TWE_IASF_PARA_PILOT
	minimap_icon = "pilot"
	paygrades = list(PAY_SHORT_IASFE4 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/iasf/pilot

/datum/equipment_preset/survivor/iasf/pilot/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine/pilot (new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine/iasf (new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/iasf, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90/twe, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90/twe, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90/twe, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)

	..()

///////////////////////////////////////////////////////////////////

/datum/equipment_preset/survivor/iasf/squad_leader
	name = "Survivor - IASF Squad Leader"
	paygrades = list(PAY_SHORT_IASFE5 = JOB_PLAYTIME_TIER_0)
	assignment = "IASF - Squad Leader"
	job_title = JOB_TWE_IASF_PARA_SQUAD_LEADER
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	role_comm_title = "24/PARA SL"

	minimap_icon = "rmc_teamleader"

	skills = /datum/skills/iasf/leader

/datum/equipment_preset/survivor/iasf/squad_leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine/iasf (new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/iasf, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/iasf_beret/tl(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)

	..()

///////////////////////////////////////////////////////////////////

/datum/equipment_preset/synth/survivor/iasf_synth
	name = "Survivor - IASF - Support Synthetic"
	assignment = "IASF - Support Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA
	languages = ALL_SYNTH_LANGUAGES
	job_title = JOB_TWE_IASF_PARA_SYNTH
	faction = FACTION_IASF
	faction_group = FACTION_LIST_SURVIVOR_IASF
	skills = /datum/skills/colonial_synthetic
	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "24/PARA Syn"
	minimap_background = "background_iasf"
	minimap_icon = "synth"

/datum/equipment_preset/synth/survivor/iasf_synth/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/royal_marine/iasf/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/iasf, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/iasf_beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/iasf, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/small_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/iasf/synth, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/rmc/survivor(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/twe, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/electronics, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/royal_marine/knife, WEAR_FEET)

///////////////////////////////////////////////////////////////////

// Hybrisa - IASF - CO Survivor.

/datum/equipment_preset/survivor/hybrisa/iasf_commander
	name = "Survivor - IASF Commander"
	assignment = "IASF - Commander"
	faction = FACTION_IASF
	faction_group = FACTION_LIST_SURVIVOR_IASF
	skills = /datum/skills/iasf/commander
	paygrades = list(PAY_SHORT_IASFO5 = JOB_PLAYTIME_TIER_0)
	job_title = JOB_TWE_IASF_PARA_COMMANDER
	minimap_icon = "rmc_commander"
	minimap_background = "background_iasf"
	idtype = /obj/item/card/id/gold
	role_comm_title = "IASF CDR"
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

/datum/equipment_preset/survivor/hybrisa/iasf_commander/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/black, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/neckerchief/brown, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/royal_marine/iasf(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/rmc/service/iasf_co(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/royal_marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/iasf(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/iasf_commander_cap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/iasf_para_belt/custom/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)

	..()
