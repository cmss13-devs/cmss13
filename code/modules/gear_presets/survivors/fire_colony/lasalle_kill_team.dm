// Lasalle Bionational Merc Insert

/datum/equipment_preset/survivor/lasalle_merc
	name = "Survivor - Lasalle-Bionational - BHIG"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_LB_MERC
	job_title = JOB_LB_MERC
	faction = FACTION_LASALLE_BIONATIONAL
	faction_group = FACTION_LIST_SURVIVOR_LASALLE_BIONATIONAL
	paygrades = list(PAY_SHORT_PMC_OP = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/silver/cl/lasalle_bionational
	skills = /datum/skills/civilian/survivor/pmc
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_FRENCH)
	minimap_icon = "ls_merc"
	minimap_background = "background_lasalle"
	origin_override = ORIGIN_LB_MERC

	access = list(
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_MEDICAL,
		ACCESS_WY_SECURITY,
		ACCESS_WY_RESEARCH,
		ACCESS_WY_ARMORY,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/lasalle_merc/load_vanity(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/lasalle_merc/standard
	name = "Survivor - Lasalle-Bionational - BHIG - Operator"

/datum/equipment_preset/survivor/lasalle_merc/standard/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/lb_merc(new_human), WEAR_BODY)
	//accessory
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/lb_merc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/lb_merc(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/lasalle_bionational/lb_merc(new_human), WEAR_L_EAR)
	//helmet + suit + backpack
	switch(rand(1,3))
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/lb_merc(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/lb_merc(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/lb_merc(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/lb_merc(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/lb_merc(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/lb_merc(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/lb_merc(new_human), WEAR_HANDS)

	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/lb_merc/b92fs_suppressed, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	add_lb_merc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)

/datum/equipment_preset/survivor/lasalle_merc/medic
	name = "Survivor - Lasalle-Bionational - BHIG - Medical Specialist"
	assignment = JOB_LB_MERC_MEDIC
	job_title = JOB_LB_MERC_MEDIC
	paygrades = list(PAY_SHORT_PMC_MS = JOB_PLAYTIME_TIER_0)
	role_comm_title = "MS"
	skills = /datum/skills/civilian/survivor/pmc/medic
	minimap_icon = "ls_med"

/datum/equipment_preset/survivor/lasalle_merc/medic/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/lb_merc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/lb_merc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/lb_merc(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/lasalle_bionational/lb_merc(new_human), WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/lb_merc(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/lb_merc(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/medic(new_human), WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/lb_merc/b92fs_suppressed, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_R_HAND)
	//eyewear
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	add_lb_merc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)

/datum/equipment_preset/survivor/lasalle_merc/engineer
	name = "Survivor - Lasalle-Bionational - BHIG - Technical Specialist"
	assignment = JOB_LB_MERC_ENGI
	job_title = JOB_LB_MERC_ENGI
	paygrades = list(PAY_SHORT_PMC_TEC = JOB_PLAYTIME_TIER_0)
	role_comm_title = "TEC"
	skills = /datum/skills/civilian/survivor/pmc/engineer
	minimap_icon = "ls_engi"

/datum/equipment_preset/survivor/lasalle_merc/engineer/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/lb_merc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/lb_merc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/lb_merc(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/lasalle_bionational/lb_merc(new_human), WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/lb_merc/engi(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/lb_merc(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert/black, WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/lb_merc/b92fs_suppressed(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_R_HAND)
	add_lb_merc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)

/datum/equipment_preset/survivor/lasalle_merc/leader
	name = "Survivor - Lasalle-Bionational - BHIG - Team Leader"
	assignment = JOB_LB_MERC_TL
	job_title = JOB_LB_MERC_TL
	paygrades = list(PAY_SHORT_PMC_TL = JOB_PLAYTIME_TIER_0)
	role_comm_title = "TL"
	skills = /datum/skills/civilian/survivor/pmc/lead
	minimap_icon = "ls_leader"

/datum/equipment_preset/survivor/lasalle_merc/leader/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/lb_merc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/lb_merc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/lb_merc(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/lasalle_bionational/lb_merc(new_human), WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/lb_merc/leader(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/lb_merc(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/lb_merc/b92fs_suppressed(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	//eyewear
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor(new_human), WEAR_EYES)
	add_lb_merc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)

// only used on the spawner of all of those above...
/datum/equipment_preset/synth/survivor/lasalle_merc
	name = "Survivor - Synthetic - Lasalle-Bionational - BHIG - Support Synthetic"
	faction = FACTION_LASALLE_BIONATIONAL
	faction_group = FACTION_LIST_SURVIVOR_LASALLE_BIONATIONAL
	access = list(
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_MEDICAL,
		ACCESS_WY_SECURITY,
		ACCESS_WY_RESEARCH,
		ACCESS_WY_ARMORY,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)
	idtype = /obj/item/card/id/silver/cl/lasalle_bionational
	assignment = JOB_LB_MERC_SYN
	job_title = JOB_LB_MERC_SYN
	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)
	role_comm_title = "LB Syn"

	minimap_icon = "ls_synth"
	minimap_background = "background_lasalle"
	origin_override = ORIGIN_LB_MERC

	skills = /datum/skills/synthetic
	locked_generation = SYNTH_GEN_THREE

/datum/equipment_preset/synth/survivor/lasalle_merc/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/lb_merc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch/black(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/scalpel/manager(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/canteen(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/lb_merc/synth(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/lb_merc(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/lasalle_bionational/lb_merc(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big/chrome(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/lb_merc(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/lb_merc/knife(new_human), WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/a1/lb_black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crew_monitor(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/makeshift(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/wy/lb_merc(new_human), WEAR_WAIST)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wrench(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire/wy(new_human), WEAR_R_STORE)

// only used on the spawner of all of those above...
/datum/equipment_preset/survivor/lasalle_merc/lasalle_commander
	name = "Survivor - Lasalle-Bionational - BHIG - Operations Commander"
	assignment = JOB_LB_MERC_COMMANDER
	job_title = JOB_LB_MERC_COMMANDER
	paygrades = list(PAY_SHORT_PMC_FOL = JOB_PLAYTIME_TIER_0)
	role_comm_title = "OCO"
	skills = /datum/skills/civilian/survivor/pmc/co_survivor
	minimap_icon = "ls_com"

/datum/equipment_preset/survivor/lasalle_merc/lasalle_commander/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/lb_merc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/black(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/a_m36(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/a_m36(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/a_m36(new_human), WEAR_IN_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/lb_merc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/lb_merc(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/lasalle_bionational/lb_merc(new_human), WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/lb_merc/commander(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/lb_merc(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_JACKET)
	//weapon
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/a_m36(new_human), WEAR_J_STORE)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black(new_human), WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human), WEAR_IN_BACK) // There is a chance PMC CO replaces PMC Engi during spawn.
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/lb_merc/b92fs_suppressed, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_advanced(new_human), WEAR_R_STORE) //In case a medic doesn't spawn.
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact(new_human), WEAR_IN_BACK) //In case a medic doesn't spawn.
	new_human.equip_to_slot_or_del(new /obj/item/tool/crew_monitor(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/a_m36(new_human), WEAR_IN_BACK)
	//eyewear
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor(new_human), WEAR_EYES)
	add_random_survivor_equipment(new_human) //No random PMC gun for them. Overwatch esque role, so SMG.
