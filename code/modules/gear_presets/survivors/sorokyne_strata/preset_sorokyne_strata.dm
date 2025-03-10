/datum/equipment_preset/survivor/engineer/soro_industry_contractor
	name = "Survivor - NORCOMM Industrial Contractor"
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

	..()

/datum/equipment_preset/survivor/engineer/soro_reactor_tech
	name = "Survivor - NORCOMM Reactor Technician"
	assignment = "NORCOMM Tekhnik Reaktora"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)

	..()

/datum/equipment_preset/survivor/security/soro
	name = "Survivor - UPP People's Armed Police Officer"
	assignment = "UPP Narodnyy Vooruzhennyy Politsioner"
	minimap_icon = "upp_sec"
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)
	role_comm_title = "MILTSY"
	skills = /datum/skills/cmb
	access = list(ACCESS_UPP_GENERAL, ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)
	idtype = /obj/item/card/id/silver

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/security/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked/police, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/pap, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/pap(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/SOF_belt/t73, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_IN_BACK)

	..()

/datum/equipment_preset/survivor/upp/army
	name = "Survivor - UPP Army Reservist"
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
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
	)

/datum/equipment_preset/survivor/upp/army/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,50)
	switch(choice)
		if(1 to 10)
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
		if(11 to 29)
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
		if(30 to 39)
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
		if(39 to 50)
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
	name = "Survivor - Ministry of Health Doctor"
	assignment = "Doktor Ministerstva Zdravookhraneniya"
	minimap_icon = "upp_doc"
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

/datum/equipment_preset/survivor/doctor/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/veteran/soviet_uniform_01(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)

	..()

/datum/equipment_preset/survivor/scientist/soro
	name = "Survivor - Cosmos Exploration Corps Researcher"
	assignment = "Issledovatel' Korpusa Kosmicheskoy Eksploratsii"
	minimap_icon = "upp_sci"
	minimap_background = "background_upp"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

/datum/equipment_preset/survivor/scientist/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox(new_human), WEAR_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	..()

/datum/equipment_preset/survivor/interstellar_human_rights_observer/soro
	name = "Survivor - Jutou Combine Mining Foreman"
	assignment = "Mining Foreman(Sorokyne)"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)

/datum/equipment_preset/survivor/interstellar_human_rights_observer/soro/load_gear(mob/living/carbon/human/new_human)

	..()

/datum/equipment_preset/survivor/corporate/soro
	name = "Survivor - NORCOMM Corporate Liaison"
	assignment = "NORCOMM Korporativnyy Svaznoy"
	faction_group = list(FACTION_UPP, FACTION_SURVIVOR)


/datum/equipment_preset/survivor/corporate/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/charcoal(new_human), WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	..()
