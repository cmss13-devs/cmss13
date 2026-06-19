//////////////////// CIVILIAN ///////////////////////
////////////////////////////////////////////////////

// Civilian

/datum/equipment_preset/survivor/fire_colony/civilian
	name = "Survivor - Fire Colony - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/fire_colony/civilian/load_gear(mob/living/carbon/human/new_human)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)

	var/random_gear = rand(0, 6)

	switch(random_gear)
		if(0) //
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(1) //
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle/drysuit(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(2) //
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle/grey(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(3) //
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle/grey/drysuit(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(4) //
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle/grey(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/lasalle_security(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/lasalle_security(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human.back), WEAR_FACE)
		if(5) //
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/lasalle(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/cbrn/lava(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/fireproof_gloves(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/fireproof_boots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human.back), WEAR_FACE)
		if(6) //
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/seegson_security(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/lasalle_security(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big/chrome(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/lasalle_security(new_human), WEAR_FEET)
	add_survivor_rare_item(new_human)
	add_survivor_weapon_civilian(new_human)

	..()



//////////////// MEDICAL & SCIENCE //////////////////
////////////////////////////////////////////////////

// Doctors / Science

/datum/equipment_preset/survivor/fire_colony/doctor
	name = "Survivor - Fire Colony - Medical Technician"
	assignment = "Lasalle-Bionational - Medical Technician"
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/fire_colony/doctor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/white(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/lasalle(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/lasalle(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/science_gloves(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/silver_white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/science_coif(new_human), WEAR_HEAD)

	var/random_gear = rand(0, 10)
	switch(random_gear)
		if(5, 9)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full(new_human), WEAR_R_STORE)
		if(10)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit(new_human), WEAR_R_STORE)
	add_random_survivor_medical_gear(new_human)
	add_survivor_weapon_civilian(new_human)
	..()


// Science

/datum/equipment_preset/survivor/fire_colony/scientist_xenoarchaeologist
	name = "Survivor - Fire Colony - Xenoarchaeologist"
	assignment = "Lasalle-Bionational - Xenoarchaeologist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/fire_colony/scientist_xenoarchaeologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(0, 10)
	switch(random_gear)
		if(1, 6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/lasalle/purple(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/silver_white(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/science_gloves(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/lasalle/purple(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/science_coif/purple(new_human), WEAR_HEAD)
		if(7, 9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/lasalle/purple(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/silver_white(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/science_gloves(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/lasalle(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/lasalle(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human), WEAR_FACE)
		if(9, 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/lasalle/purple(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/silver_white(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/science_gloves/yellow(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/lasalle/purple(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/science_coif/purple(new_human), WEAR_HEAD)

	add_survivor_weapon_civilian(new_human)
	add_random_survivor_research_gear(new_human)
	..()

/datum/equipment_preset/survivor/fire_colony/scientist_xenobiologist
	name = "Survivor - Fire Colony - Xenobiologist"
	assignment = "Lasalle-Bionational - Xenobiologist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/fire_colony/scientist_xenobiologist/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/white(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/lasalle/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/lasalle/blue(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/silver_white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science/blue(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/science_gloves(new_human), WEAR_HANDS)

	var/random_gear = rand(0, 10)
	switch(random_gear)
		if(0, 7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/science_coif/blue(new_human), WEAR_HEAD)

	add_survivor_weapon_civilian(new_human)
	add_random_survivor_research_gear(new_human)
	..()

/datum/equipment_preset/survivor/fire_colony/scientist_xenoflora
	name = "Survivor - Fire Colony - Xenoflora Specialist"
	assignment = "Lasalle-Bionational - Xenoflora Specialist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/fire_colony/scientist_xenoflora/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/hyd(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/lasalle/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/lasalle/green(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/science_gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/silver_white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/bag/plants(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/analyzer/plant_analyzer(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/science_coif/green(new_human), WEAR_HEAD)

	add_survivor_weapon_civilian(new_human)
	add_random_survivor_research_gear(new_human)
	..()

///////////// MAINTENANCE & ENGINEERING /////////////
////////////////////////////////////////////////////

// Engineering & Maintenance

/datum/equipment_preset/survivor/fire_colony/engineer
	name = "Survivor - Fire Colony - Engineer"
	assignment = "Lasalle-Bionational - Industrial Technician"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/fire_colony/engineer/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,4)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle/yellow(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle/yellow/drysuit(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle/yellow/drysuit(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/lasalle_security(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/fireproof_gloves(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/lasalle/yellow/drysuit(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/cbrn/lava(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/fireproof_boots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	add_survivor_weapon_civilian(new_human)
	..()

//////////////// LASALLE BIONATIONAL CORPORATE /////////////////////
////////////////////////////////////////////////////

// Lasalle Bionational Corpo

/datum/equipment_preset/survivor/corporate/lasalle_bionational
	name = "Survivor - Fire Colony - Corporate Liaison"
	assignment = "Lasalle-Bionational - Corporate Liaison"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	paygrades = list(PAY_SHORT_WYC2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_WYC3 = JOB_PLAYTIME_TIER_2, PAY_SHORT_WYC4 = JOB_PLAYTIME_TIER_3, PAY_SHORT_WYC5 = JOB_PLAYTIME_TIER_4)
	faction_group = FACTION_LIST_SURVIVOR_WY
	idtype = /obj/item/card/id/silver/clearance_badge/cl
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_COMMAND,ACCESS_WY_GENERAL,ACCESS_WY_COLONIAL,ACCESS_WY_EXEC,)

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/corporate/lasalle_bionational/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,45)
	switch(choice)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
		if(10 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/jacket(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
		if(20 to 30)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
		if(30 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/brown/jacket(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
		if(40 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/mod88(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88/penetrating(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88/penetrating(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/jacket_only(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	add_random_cl_survivor_loot(new_human)
	..()

// Lasalle Corporate Security - (Goons)

/datum/equipment_preset/survivor/fire_colony/corporate_goon
	name = "Survivor - Fire Colony - Corporate Security Guard"
	assignment = "Lasalle-Bionational - Corporate Security Guard"
	assignment = JOB_WY_GOON
	job_title = JOB_WY_GOON
	minimap_icon = "goon_standard"
	minimap_background = "background_goon"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR)
	origin_override = ORIGIN_WY_SEC
	paygrades = list(PAY_SHORT_WY_SEC = JOB_PLAYTIME_TIER_0, PAY_SHORT_WY_SEC_SPEC = JOB_PLAYTIME_TIER_4)
	skills = /datum/skills/civilian/survivor/goon
	idtype = /obj/item/card/id/silver/cl
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_RESEARCH,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,ACCESS_WY_EXEC,ACCESS_WY_GENERAL,ACCESS_WY_COLONIAL)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/fire_colony/corporate_goon/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lasalle_security(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/lasalle_security(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lasalle_security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/lasalle_security(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/lasalle_security(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/lasalle(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/lasalle(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/lasalle(new_human), WEAR_FACE)

	var/choice = rand(1,30)
	switch(choice)
		if(1 to 10)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)

		if(11 to 29)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)

		if(30)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)

	..()

//-------------------------------------------------------

//////////////// SNYTHETICS /////////////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/synth/survivor/fire_colony
	flags = EQUIPMENT_PRESET_STUB

// Civilian

/datum/equipment_preset/synth/survivor/fire_colony/civilian
	name = "Survivor - Fire Colony - Synthetic - Civilian"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/synth/survivor/fire_colony/civilian/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,7)
	switch(choice)
		if(1) // Weymart-Employee
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/weymart(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/weymart(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/weymart(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/mop(new_human), WEAR_R_HAND)
		if(3) // Pizza Delivery
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/pizza_galaxy(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/pizzabox/pizza_galaxy/mystery(new_human.back), WEAR_IN_BACK)
		if(4) // Fire Protection
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_R_HAND)
		if(5) // Cuppa Joe's Barista
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/cuppa_joes(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/apron/cuppa_joes(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(6) // Landing Pad Attendant Synth
			new_human.equip_to_slot_or_del(new /obj/item/clothing/ears/earmuffs(new_human), WEAR_R_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/yellow(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/stack/flag/red(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/lightstick/red(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
		if(7) // Bartender
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bowlerhat(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective/grey(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/tequila(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/cognac(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/grenadine(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/rum(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/beer_pack(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/baseballbat(new_human), WEAR_L_HAND)
		if(8) // Chef Synth
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/corporate_formal(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/sliceable/lemoncake(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/utensil/fork(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/chef(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife/butcher(new_human), WEAR_L_HAND)
	..()

// Engineer

/datum/equipment_preset/synth/survivor/fire_colony/engineer_survivor
	name = "Survivor - Fire Colony - Synthetic - Engineer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/fire_colony/engineer_survivor/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,5)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/engineering_utility_oversuit(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human.back), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/engineering_utility_oversuit/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human.back), WEAR_IN_BACK)
	..()

// Medical

/datum/equipment_preset/synth/survivor/fire_colony/paramedic
	name = "Survivor - Fire Colony - Synthetic - Emergency Medical Technician - Paramedic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/fire_colony/paramedic/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,25)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white, WEAR_FEET)

	switch(choice)
		if(1 to 9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_red_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic/red(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(10 to 19)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_green_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(20 to 24)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/medical_green(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(25)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_red_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic/red(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/medtech(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
	..()

// Security

/datum/equipment_preset/synth/survivor/fire_colony/detective
	name = "Survivor - Fire Colony - Synthetic - Detective"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/fire_colony/detective/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,2)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full/synth(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human.back), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/fedora/grey(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective/grey(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full/synth(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human.back), WEAR_IN_BACK)
	..()

// Corporate

/datum/equipment_preset/synth/survivor/fire_colony/exec_bodyguard
	name = "Survivor - Fire Colony - Synthetic - Executive Bodyguard"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/synth/survivor/fire_colony/exec_bodyguard/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,45)
	switch(choice)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
		if(10 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/jacket(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
		if(20 to 30)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue(new_human), WEAR_EYES)
		if(30 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/brown/jacket(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue(new_human), WEAR_EYES)
		if(40 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/jacket_only(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	add_random_cl_survivor_loot(new_human)
	..()

// Science

/datum/equipment_preset/synth/survivor/fire_colony/xenoarchaeologist
	name = "Survivor - Fire Colony - Synthetic - Xenoarchaeologist"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/fire_colony/xenoarchaeologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,55)
	switch(random_gear)
		if(1 to 25)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
		if(25 to 35)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/synthbio/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/synth/wy_bio(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
		if(35 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/synthbio/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/synth/wy_bio(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
		if(50 to 55)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/synthbio/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/synth/wy_bio/alt(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
	..()
