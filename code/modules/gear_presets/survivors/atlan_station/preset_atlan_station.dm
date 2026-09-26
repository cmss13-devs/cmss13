/datum/equipment_preset/survivor/atlan_cec_scientist
	name = "Survivor - UPP - Atlan Cosmos Exploration Corps Researcher"
	assignment = "Issledovatel' Korpusa Kosmicheskoy Eksploratsii"
	minimap_icon = "upp_sci"
	minimap_background = "background_upp_bravo"
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_CHINESE)
	job_title = JOB_CEC_DOCENT
	paygrades = list(PAY_SHORT_CEC2 = JOB_PLAYTIME_TIER_0)
	faction = list(FACTION_CEC, FACTION_UPP)
	faction_group = FACTION_LIST_SURVIVOR_CEC
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP
	skills = /datum/skills/civilian/survivor/scientist
	idtype = /obj/item/card/id/cec

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/atlan_cec_scientist/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/cec(new_human), WEAR_L_EAR)
	var/random_gloves = rand(1,2)
	switch(random_gloves)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(new_human), WEAR_HANDS)


	var/random_scientist_satchel= rand(1,3)
	switch(random_scientist_satchel)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)

	var/random_scientist_glasses= rand(1,3)
	switch(random_scientist_glasses)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_FACE)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hippie(new_human), WEAR_FACE)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_FACE)

	var/random_professional_shoe = rand(1,3)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)

	var/random_uniform = rand(1,3)
	switch(random_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray/upp(new_human), WEAR_BODY)

	var/random_labcoat_number = rand(1,3)
	var/obj/item/clothing/suit/storage/labcoat/surv_labcoat
	switch(random_labcoat_number)
		if(1)
			surv_labcoat = new /obj/item/clothing/suit/storage/labcoat/cec/red
		if(2)
			surv_labcoat = new /obj/item/clothing/suit/storage/labcoat/cec/red_hood
		if(3)
			surv_labcoat = new /obj/item/clothing/suit/storage/labcoat/cec/blue

	if(prob(50))
		surv_labcoat.toggle()

	new_human.equip_to_slot_or_del(surv_labcoat, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	// gun //
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/np92(new_human), WEAR_L_HAND)

	//eyewear//
	var/random_goggles = rand(1,2)
	switch(random_goggles)
		if(1)
			if(new_human.disabilities & NEARSIGHTED)
				new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
			else
				new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
		if(2)
			if(new_human.disabilities & NEARSIGHTED)
				new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science/prescription(new_human), WEAR_EYES)
			else
				new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			..()

/datum/equipment_preset/survivor/cec_liaison
	name = "Survivor - UPP - Atlan Cosmos Exploration Corps Liaison" //CEC Representative/Liaison, higher academic standing and the cec scientist supervisor
	assignment = "Svyaz' Korpusa Kosmicheskoy Eksploratsii"
	minimap_icon = "upp_sci"
	minimap_background = "background_upp_bravo"
	job_title = JOB_CEC_PROFESSOR
	skills = /datum/skills/civilian/survivor/scientist
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_ENGLISH, LANGUAGE_CHINESE)
	paygrades = list(PAY_SHORT_CEC3 = JOB_PLAYTIME_TIER_0)
	faction = list(FACTION_CEC, FACTION_UPP)
	faction_group = FACTION_LIST_SURVIVOR_CEC
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP
	idtype = /obj/item/card/id/cec

	survivor_variant = CORPORATE_SURVIVOR


/datum/equipment_preset/survivor/cec_liaison/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	var/random_scientist_satchel= rand(1,3)
	switch(random_scientist_satchel)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)

	var/random_scientist_glasses= rand(1,3)
	switch(random_scientist_glasses)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_FACE)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hippie(new_human), WEAR_FACE)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_FACE)

	var/random_professional_shoe = rand(1,3)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)

	var/random_uniform = rand(1,3)
	switch(random_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)

	var/random_tie = rand(1,3)
	switch(random_tie)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie(new_human), WEAR_ACCESSORY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/red(new_human), WEAR_ACCESSORY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/black(new_human), WEAR_ACCESSORY)

	var/random_labcoat_number = rand(1,3)
	var/obj/item/clothing/suit/storage/labcoat/surv_labcoat
	switch(random_labcoat_number)
		if(1)
			surv_labcoat = new /obj/item/clothing/suit/storage/labcoat/cec/red
		if(2)
			surv_labcoat = new /obj/item/clothing/suit/storage/labcoat/cec/red_hood
		if(3)
			surv_labcoat = new /obj/item/clothing/suit/storage/labcoat/cec/blue

	if(prob(50))
		surv_labcoat.toggle()

	new_human.equip_to_slot_or_del(surv_labcoat, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/tool/pen(new_human), WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/cec(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	// gun //
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/np92(new_human), WEAR_L_HAND)
	add_random_cl_survivor_loot(new_human)
	..()

/datum/equipment_preset/survivor/upp_colonist_atlan
	name = "UPP - Atlan Civilian"
	assignment = "Grazhdanin"
	flags = EQUIPMENT_PRESET_EXTRA
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	minimap_background = "background_upp_civilian"
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor
	access = list(ACCESS_CIVILIAN_PUBLIC)
	idtype = /obj/item/card/id
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/upp_colonist_atlan/load_gear(mob/living/carbon/human/new_human)

	var/random_civilian_backpack= rand(1,8)
	switch(random_civilian_backpack)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)

	var/random_civilian_jacket= rand(1,8)
	switch(random_civilian_jacket)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/black(new_human), WEAR_JACKET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/tan(new_human), WEAR_JACKET)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human), WEAR_JACKET)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_brown(new_human), WEAR_JACKET)

	var/random_civilian_uniform = rand(1,18)
	switch(random_civilian_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/blue(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/brown(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightbrown(new_human), WEAR_BODY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(new_human), WEAR_BODY)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/yellow(new_human), WEAR_BODY)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/orange(new_human), WEAR_BODY)
		if(9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi1(new_human), WEAR_BODY)
		if(10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi2(new_human), WEAR_BODY)
		if(11)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi3(new_human), WEAR_BODY)
		if(12)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi4(new_human), WEAR_BODY)
		if(13)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility(new_human), WEAR_BODY)
		if(14)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/blue(new_human), WEAR_BODY)
		if(15)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown(new_human), WEAR_BODY)
		if(16)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
		if(17)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/red(new_human), WEAR_BODY)
		if(18)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/yellow(new_human), WEAR_BODY)

	var/random_civilian_shoe = rand(1,9)
	switch(random_civilian_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(new_human), WEAR_FEET)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
		if(9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/atlan_cargo
	name = "Survivor - UPP - Atlan Logistics Technician"
	assignment = "Logisticheskiy Tekhnik"
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	role_comm_title = "Log."
	minimap_background = "background_upp_civilian"
	minimap_icon = "upp_cargo"
	skills = /datum/skills/civilian/survivor/miner
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/atlan_cargo/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)

	var/random_uniform = rand(1,11)
	switch(random_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi1(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi2(new_human), WEAR_BODY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi3(new_human), WEAR_BODY)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi4(new_human), WEAR_BODY)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility(new_human), WEAR_BODY)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/blue(new_human), WEAR_BODY)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown(new_human), WEAR_BODY)
		if(9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
		if(10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/red(new_human), WEAR_BODY)
		if(11)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/yellow(new_human), WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	//  back  //
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/chestrig(new_human), WEAR_BACK)
	// pockets //
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)

/datum/equipment_preset/survivor/atlan_doctor
	name = "Survivor - UPP - Ministry of Health - Atlan Doctor"
	assignment = "Doktor Ministerstva Zdravookhraneniya"
	minimap_icon = "upp_doc"
	minimap_background = "background_upp_medical"
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP
	skills = /datum/skills/civilian/survivor/doctor

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/atlan_doctor/load_gear(mob/living/carbon/human/new_human)
	var/random_civilian_satchel= rand(1,3)
	switch(random_civilian_satchel)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)

	var/random_professional_shoe = rand(1,2)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)

	var/random_labcoat = rand(1,2)
	switch(random_labcoat)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/long(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)

	var/random_professional_uniform= rand(1,6)
	switch(random_professional_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/white(new_human), WEAR_BODY)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/lightblue(new_human), WEAR_BODY)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/morgue(new_human), WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	// gun //
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/np92(new_human), WEAR_L_HAND)
	..()

/datum/equipment_preset/survivor/engineer/atlan_processing_engineer
	name = "Survivor - UPP - Ministry of Industry - Atlan Refinery Engineer"
	assignment = "Inzhener Neftepererabatyvayushchiy Zavod"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp_civilian"
	faction_group = FACTION_LIST_SURVIVOR_UPP
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/atlan_processing_engineer/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)

	var/random_utility_jumpsuit= rand(1,2)
	switch(random_utility_jumpsuit)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray/upp(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)

	..()


/datum/equipment_preset/survivor/upp_atlan_pilot
	name = "Survivor - UPP - Jutou Combine - Atlan Atmospheric Mining Pilot"
	assignment = "Jùtóu Combine - Pilot Atmosfernyy Mayninga"
	minimap_background = "background_upp_civilian"
	skills = /datum/skills/civilian/survivor/atlan_pilot
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP
	access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_ENGINEERING, ACCESS_UPP_FLIGHT)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/upp_atlan_pilot/load_gear(mob/living/carbon/human/new_human)


	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi5(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_FACE)
	var/random_hat = rand(1,2)
	switch(random_hat)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white/alt(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)

	..()

/datum/equipment_preset/survivor/atlan_security
	name = "Survivor - UPP - Atlan Station Security Officer"
	assignment = "Sotrudnik Sluzhby Bezopasnosti"
	faction_group = FACTION_LIST_SURVIVOR_PAP
	minimap_icon = "upp_sec"
	minimap_background = "background_upp"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_UE4 = JOB_PLAYTIME_TIER_1, PAY_SHORT_UE5 = JOB_PLAYTIME_TIER_2)
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE, LANGUAGE_GERMAN)
	faction = FACTION_UPP
	skills = /datum/skills/civilian/survivor/marshal
	access = list(ACCESS_UPP_GENERAL, ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)
	idtype = /obj/item/card/id/dogtag/upp
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/atlan_security/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	var/choice = rand(1,2)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73(new_human), WEAR_WAIST)
	..()

/datum/equipment_preset/survivor/engineer/atlan_tech
	name = "Survivor - UPP - Atlan Station Maintenance Technician"
	assignment = "Tekhnik Po Obsluzhivaniyu"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp_civilian"
	faction_group = FACTION_LIST_SURVIVOR_UPP
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/atlan_tech/load_gear(mob/living/carbon/human/new_human)
	// uniform and clothing //
	var/uniform = rand(1,7)
	switch(uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/red(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/yellow(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/engi(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	// headgear //
	var/headgear = rand(1,3)
	switch(headgear)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(WEAR_FACE) // removes goggles?

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	// gear //
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	..()


//-------------------------------------------------------

//////////////// SYNTHETICS /////////////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/synth/survivor/atlan
	flags = EQUIPMENT_PRESET_STUB

// Civilian

/datum/equipment_preset/synth/survivor/atlan/civilian
	name = "Survivor - Atlan Station - Synthetic - Civilian"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP
	minimap_icon = "upp_synth"
	minimap_background = "background_upp_civilian"

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/civilian/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,6)
	switch(choice)
		if(1) // Amospheric Mining Pilot
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi5(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_FACE)
			var/random_hat = rand(1,2)
			switch(random_hat)
				if(1)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white/alt(new_human), WEAR_HEAD)
				if(2)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
		if(2) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/upp(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/cbrn_non_armored(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/cbrn_non_armored(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/mop(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
		if(3) // Fire Protection
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/firefighter(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light/upp/synth(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
		if(4) // Landing Pad Attendant Synth
			new_human.equip_to_slot_or_del(new /obj/item/clothing/ears/earmuffs(new_human), WEAR_R_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/stack/flag/red(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/lightstick/red(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/prop/tableflag/upp(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
		if(5) // Bartender
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka/civi(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/tan(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/bag/plasticbag(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/baseballbat/metal(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
		if(6) // Chef Synth
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi2(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic/stain(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/utensil/fork(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife/butcher(new_human), WEAR_L_HAND)
	..()

// Engineer

/datum/equipment_preset/synth/survivor/atlan/engineer
	name = "Survivor - Atlan Station - Synthetic - Engineering Synthetic" // ENGINEER
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP
	minimap_icon = "upp_synth"
	minimap_background = "background_upp_civilian"

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/engineer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
	var/choice = rand(1,3)
	switch(choice)
		if(1) // Reactor Engineer
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/short(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/white/alt(new_human), WEAR_BODY)
		if(2) // Refinery Engineer
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather, WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
		if(3) // Maintenance Technician
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
			// headgear //
			var/headgear = rand(1,3)
			switch(headgear)
				if(1)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_FACE)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
				if(2)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_FACE)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)
				if(3)
					new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_HEAD)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	var/random_utility_jumpsuit= rand(1,2)
	switch(random_utility_jumpsuit)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray/upp(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)

	..()

// Medical

/datum/equipment_preset/synth/survivor/atlan/doctor
	name = "Survivor - Atlan Station - Synthetic - Doctor"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP
	minimap_icon = "upp_synth"
	minimap_background = "background_upp_medical"


	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/doctor/load_gear(mob/living/carbon/human/new_human)
	var/random_civilian_satchel= rand(1,3)
	switch(random_civilian_satchel)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)

	var/random_professional_shoe = rand(1,2)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)

	var/random_labcoat = rand(1,2)
	switch(random_labcoat)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/long(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	var/random_professional_uniform= rand(1,6)
	switch(random_professional_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/white(new_human), WEAR_BODY)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/lightblue(new_human), WEAR_BODY)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/morgue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)

	..()

// Security

/datum/equipment_preset/synth/survivor/atlan/security
	name = "Survivor - Atlan Station - Synthetic - Security"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP
	minimap_icon = "upp_synth"
	minimap_background = "background_upp"

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/security/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	var/choice = rand(1,2)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/black(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/UPP/full(new_human), WEAR_WAIST)

	..()

// Corporate

/datum/equipment_preset/synth/survivor/atlan/corporate
	name = "Survivor - Atlan Station - Synthetic - CEC Support Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	job_title = JOB_CEC_SYNTH
	assignment = JOB_CEC_SYNTH
	role_comm_title = "CEC Syn"
	faction = list(FACTION_CEC, FACTION_UPP)
	faction_group = FACTION_LIST_SURVIVOR_CEC
	idtype = /obj/item/card/id/cec
	survivor_variant = CORPORATE_SURVIVOR
	origin_override = ORIGIN_UPP
	minimap_icon = "upp_synth"
	minimap_background = "background_upp_bravo"

/datum/equipment_preset/synth/survivor/atlan/corporate/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,2)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/cec(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/combat(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/cec(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray/upp(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/combat(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
	add_random_cl_survivor_loot(new_human)
	..()

// Science

/datum/equipment_preset/synth/survivor/atlan/scientist
	name = "Survivor - Atlan Station - Synthetic - CEC Technician"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	job_title = JOB_CEC_SYNTH
	assignment = JOB_CEC_SYNTH
	role_comm_title = "CEC Syn"
	faction = list(FACTION_CEC, FACTION_UPP)
	faction_group = FACTION_LIST_SURVIVOR_CEC
	origin_override = ORIGIN_UPP
	minimap_icon = "upp_synth"
	minimap_background = "background_upp_bravo"


	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/scientist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/cec(new_human), WEAR_L_EAR)

	var/random_gloves = rand(1,2)
	switch(random_gloves)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)

	var/random_professional_shoe = rand(1,3)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)

	var/random_synth_uniform = rand(1,6)
	switch(random_synth_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/orange(new_human), WEAR_BODY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/blue(new_human), WEAR_BODY)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)

	var/random_labcoat_number = rand(1,1)
	var/obj/item/clothing/suit/storage/labcoat/surv_labcoat
	switch(random_labcoat_number)
		if(1)
			surv_labcoat = new /obj/item/clothing/suit/storage/labcoat/cec/blue

	if(prob(50))
		surv_labcoat.toggle()

	new_human.equip_to_slot_or_del(surv_labcoat, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)

	..()




// CO SURV STATION ADMINISTRATOR

/datum/equipment_preset/survivor/atlan/co_survivor_commandant
	name = "CO Survivor - UPP - Atlan Station Commandant" // Basically the station's SOF/Military Commander, Commissar skills, cool revolver, etc...
	assignment = JOB_UPP_CO_OFFICER
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	job_title = JOB_UPP_CO_OFFICER
	role_comm_title = "UPP Kommandant"
	minimap_icon = "upp_plt"
	minimap_background = "background_upp"
	idtype = /obj/item/card/id/dogtag/upp
	faction_group = FACTION_LIST_SURVIVOR_UPP
	paygrades = list(PAY_SHORT_UO4C = JOB_PLAYTIME_TIER_0)
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH, LANGUAGE_CHINESE, LANGUAGE_GERMAN)
	faction = FACTION_UPP
	skills = /datum/skills/upp/commissar
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/atlan/co_survivor_commandant/load_gear(mob/living/carbon/human/new_human)
	var/random_jumper = rand(1,2)
	switch(random_jumper)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/sweater_alt(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/sweater(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/SOF_beret(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/SOF_armor(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_JACKET)

	..()
