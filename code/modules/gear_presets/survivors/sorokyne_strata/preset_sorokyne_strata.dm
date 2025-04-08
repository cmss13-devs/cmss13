/datum/equipment_preset/survivor/engineer/soro_industry_contractor
	name = "Survivor - UPP - Ministry of Industry - Infrastructure Engineer"
	assignment = "Inzhener Infrastruktury"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp_bravo"
	faction_group = FACTION_LIST_SURVIVOR_UPP
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/soro_industry_contractor/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)

	var/random_utility_jumpsuit= rand(1,2)
	switch(random_utility_jumpsuit)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray/upp(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/engineer/soro_reactor_tech
	name = "Survivor - UPP - Ministry of Energy - Reactor Technician"
	assignment = "Tekhnik Reaktora"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp_bravo"
	faction_group = FACTION_LIST_SURVIVOR_UPP
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/soro_reactor_tech/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,25)
	switch(choice)
		if(1 to 12)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/short(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
		if(12 to 24)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/short(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
		if(25)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/radiation, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/radiation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/white/alt(new_human), WEAR_BODY)

	add_survivor_weapon_civilian(new_human)
	..()


/datum/job/nrodnyyvooruzhennyypolitsioner
	title = "Narodnyy Vooruzhennyy Politsioner"

/datum/equipment_preset/survivor/peoples_armed_police
	name = "Survivor - UPP - People's Armed Police Officer"
	assignment = "Narodnyy Vooruzhennyy Politsioner"
	faction_group = FACTION_LIST_SURVIVOR_PAP
	minimap_icon = "upp_sec"
	minimap_background = "background_upp_alpha"
	paygrades = list(PAY_SHORT_PAP_MLTS = JOB_PLAYTIME_TIER_0, PAY_SHORT_PAP_SMLTS = JOB_PLAYTIME_TIER_3, PAY_SHORT_PAP_STRSH = JOB_PLAYTIME_TIER_4)
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_PAP
	skills = /datum/skills/civilian/survivor/marshal
	access = list(ACCESS_UPP_GENERAL, ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)
	idtype = /obj/item/card/id/PaP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/peoples_armed_police/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PaP(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked/police, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/pap(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/SOF_belt/t73, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/pap, WEAR_BODY)

	add_survivor_weapon_security(new_human)
	..()

/datum/equipment_preset/survivor/upp/army
	name = "Survivor - UPP - Ministry of Defense - Army Reservist"
	assignment = "Armiyskiy Rezervist"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0)
	rank = JOB_SURVIVOR
	skills = /datum/skills/military/survivor/upp_private
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	minimap_icon = "upp_pvt"
	minimap_background = "background_upp"
	role_comm_title = "202/ARMY"
	idtype = /obj/item/card/id/dogtag/upp
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_UPP_GENERAL, ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)
	origin_override = ORIGIN_UPP

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/upp/army/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,4)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/army(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/balaclava(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/army(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/half_full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/army(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/balaclava(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/half_full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/army(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/army(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/half_full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_FACE)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/SOF_beret/reservist(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/army/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/half_full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/black(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
	..()

/datum/equipment_preset/survivor/doctor/soro
	name = "Survivor - UPP - Ministry of Health - Doctor"
	assignment = "Doktor Ministerstva Zdravookhraneniya"
	minimap_icon = "upp_doc"
	minimap_background = "background_upp_medical"
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/doctor/soro/load_gear(mob/living/carbon/human/new_human)

	var/random_civilian_satchel= rand(1,3)
	switch(random_civilian_satchel)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)

	var/random_tie= rand(1,6)
	switch(random_tie)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/black(new_human), WEAR_ACCESSORY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/blue(new_human), WEAR_ACCESSORY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/green(new_human), WEAR_ACCESSORY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/purple(new_human), WEAR_ACCESSORY)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/red(new_human), WEAR_ACCESSORY)

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

	var/random_professional_uniform= rand(1,3)
	switch(random_professional_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker, WEAR_HEAD)

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/scientist/soro
	name = "Survivor - UPP - Cosmos Exploration Corps Researcher"
	assignment = "Issledovatel' Korpusa Kosmicheskoy Eksploratsii"
	minimap_icon = "upp_sci"
	minimap_background = "background_upp_charlie"
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/scientist/soro/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/brown(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)

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

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)

	..()

/datum/equipment_preset/survivor/upp_colonist
	name = "UPP - Civilian"
	assignment = "Grazhdanin"
	flags = EQUIPMENT_PRESET_EXTRA
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	minimap_background = "background_upp_civillian"
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian
	access = list(ACCESS_CIVILIAN_PUBLIC)
	idtype = /obj/item/card/id
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/upp_colonist/load_gear(mob/living/carbon/human/new_human)

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

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/upp_fire_fighter
	name = "Survivor - UPP - Ministry of Public Safety - Fire Protection Specialist"
	assignment = "Spetsialist Po Pozharnoy Bezopasnosti"
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	role_comm_title = "FPPB"
	minimap_background = "background_upp_civillian"
	skills = /datum/skills/civilian/survivor/fire_fighter
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/upp_fire_fighter/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)

	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 30) // Firefighter
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/firefighter(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light/upp(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe, WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)

		if(30 to 50) // (Rare)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/firefighter(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light/upp(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/upp_miner
	name = "Survivor - UPP - Jutou Combine - Miner"
	assignment = "Jùtóu Combine - Shakhtyor"
	minimap_background = "background_upp_civillian"
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/upp_miner/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white/alt, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi5(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/hyperdyne
	name = "Survivor - UPP - Hyperdyne - Corporate Liaison" // Basically a Corporate Liaison for Hyperdyne instead of Weyland-Yutani. - Hyperdyne should be expanded in the future, more roles ect.
	assignment = "Hyperdyne - Corporate Liaison"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	paygrades = list(PAY_SHORT_WYC2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_WYC3 = JOB_PLAYTIME_TIER_2, PAY_SHORT_WYC4 = JOB_PLAYTIME_TIER_3, PAY_SHORT_WYC5 = JOB_PLAYTIME_TIER_4)
	faction_group = FACTION_HYPERDYNE
	rank = JOB_HC_EXECUTIVE
	faction = FACTION_HYPERDYNE
	faction_group = list(FACTION_HYPERDYNE, FACTION_LIST_SURVIVOR_UPP)
	idtype = /obj/item/card/id/silver/cl/hyperdyne
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_EXEC,
	)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	survivor_variant = CORPORATE_SURVIVOR
	minimap_icon = "hc_cl"
	minimap_background = "background_hc_management"

/datum/equipment_preset/survivor/hyperdyne/load_rank(mob/living/carbon/human/new_human, client/mob_client)
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

/datum/equipment_preset/survivor/hyperdyne/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/hyperdyne(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/black(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/hyperdyne_patch, WEAR_ACCESSORY)

	var/random_trenchcoat = rand(1,2)
	switch(random_trenchcoat)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat/brown(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat/grey(new_human), WEAR_JACKET)

	add_survivor_weapon_civilian(new_human)
	add_random_cl_survivor_loot(new_human)
	add_ice_colony_survivor_equipment(new_human)
	..()
