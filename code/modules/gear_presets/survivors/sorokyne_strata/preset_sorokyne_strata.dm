/datum/equipment_preset/survivor/engineer/soro_industry_contractor
	name = "Survivor - UPP - NORCOMM Industrial Contractor"
	assignment = "NORCOMM Promyshlennyy Podryadchik"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/black(new_human), WEAR_JACKET)

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/engineer/soro_reactor_tech
	name = "Survivor - UPP - NORCOMM Reactor Technician"
	assignment = "NORCOMM Tekhnik Reaktora"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/soro_reactor_tech/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,25)
	switch(choice)
		if(1 to 12)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/white/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/short(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
		if(12 to 24)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/white/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/short(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
		if(25)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/radiation, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/white/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/radiation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(new_human), WEAR_IN_BACK)

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/peoples_armed_police
	name = "Survivor - UPP - People's Armed Police Officer"
	assignment = "UPP Narodnyy Vooruzhennyy Politsioner"
	minimap_icon = "upp_sec"
	minimap_background = "background_upp"
	origin_override = ORIGIN_UPP
	paygrades = list(PAY_SHORT_UCM = JOB_PLAYTIME_TIER_0)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	role_comm_title = "MILTSY"
	skills = /datum/skills/cmb
	access = list(ACCESS_UPP_GENERAL, ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)
	idtype = /obj/item/card/id/silver
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/peoples_armed_police/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/PaP(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked/police, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/pap, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/pap(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/SOF_belt/t73, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
	add_survivor_weapon_security(new_human)
	..()

/datum/equipment_preset/survivor/upp/army
	name = "Survivor - UPP - Army Reservist"
	assignment = "UPP Armiyskiy Rezervist"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0)
	origin_override = ORIGIN_UPP
	rank = JOB_SURVIVOR
	skills = /datum/skills/military/survivor/upp_private
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	minimap_icon = "upp_pvt"
	minimap_background = "background_upp"
	role_comm_title = "202/ARMY"
	idtype = /obj/item/card/id/dogtag/upp
	flags = EQUIPMENT_PRESET_EXTRA
	access = list(ACCESS_UPP_GENERAL, ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

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
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/army(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/balaclava(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/army(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/army(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_FACE)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/ivanberet/SOF_beret/reservist(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/army/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)
	..()

/datum/equipment_preset/survivor/doctor/soro
	name = "Survivor - UPP - Ministry of Health Doctor"
	assignment = "Doktor Ministerstva Zdravookhraneniya"
	minimap_icon = "upp_doc"
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

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

	var/random_professional_uniform= rand(1,3)
	switch(random_professional_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)

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

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)

	var/random_professional_shoe = rand(1,2)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/scientist/soro
	name = "Survivor - UPP Cosmos Exploration Corps Researcher"
	assignment = "Issledovatel' Korpusa Kosmicheskoy Eksploratsii"
	minimap_icon = "upp_sci"
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/scientist/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)

	..()

/datum/equipment_preset/survivor/upp_colonist
	name = "UPP - Civilian"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_COLONIST
	assignment = "Grazhdanin"
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian
	access = list(ACCESS_CIVILIAN_PUBLIC)
	idtype = /obj/item/card/id

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
	name = "Survivor - UPP - Fire Protection Specialist"
	assignment = "Spetsialist Po Pozharnoy Bezopasnosti"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	role_comm_title = "FPPB"
	skills = /datum/skills/civilian/survivor/fire_fighter
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/upp_fire_fighter/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 30) // Firefighter
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe, WEAR_R_HAND)
		if(30 to 50) // (Rare)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/firefighter(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	..()

///.

/datum/equipment_preset/survivor/upp_miner
	name = "Survivor - UPP - Jutou Combine - Miner"
	assignment = "Shakhtyor"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/upp_miner/load_gear(mob/living/carbon/human/new_human)

	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/corporate/soro
	name = "Survivor - UPP - NORCOMM Corporate Liaison"
	assignment = "NORCOMM Korporativnyy Svaznoy"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/corporate/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/charcoal(new_human), WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	..()
