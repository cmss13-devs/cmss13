/datum/equipment_preset/survivor/engineer/soro
	name = "Survivor - NORCOMM Contractor"
	assignment = "NORCOMM Mining Contractor"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp"

/datum/equipment_preset/survivor/engineer/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/black(new_human), WEAR_JACKET)


	..()


/datum/equipment_preset/survivor/security/soro
	name = "Survivor - UPP Security"
	assignment = "UPP Security"
	minimap_icon = "upp_sec"
	minimap_background = "background_upp"

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/engineer/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/black(new_human), WEAR_JACKET)


	..()

/datum/equipment_preset/survivor/upp/army
	name = "Survivor - UPP Colonial Guard"
	assignment = "UPP Kolonialnaya Gvardiya"
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

	var/choice = rand(1,30)
	switch(choice)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/army(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/balaclava(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/army(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
		if(11 to 29)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/army(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/balaclava(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
		if(30)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/army(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/army(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/brown/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ak4047(new_human), WEAR_J_STORE)
	..()

/datum/equipment_preset/survivor/doctor/soro
	name = "Survivor - Sorokyne Strata Doctor"
	assignment = "Ministry of Health Doctor"
	minimap_icon = "upp_doc"
	minimap_background = "background_upp"

/datum/equipment_preset/survivor/doctor/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/veteran/soviet_uniform_01(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)

	..()

/datum/equipment_preset/survivor/scientist/soro
	name = "Survivor - CEC Researcher"
	assignment = "Cosmos Exploration Corps Mining Researcher"
	minimap_icon = "upp_sci"
	minimap_background = "background_upp"

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


/datum/equipment_preset/survivor/interstellar_human_rights_observer/soro/load_gear(mob/living/carbon/human/new_human)

	..()

/datum/equipment_preset/survivor/corporate/soro
	name = "Survivor - Sorokyne Strata Corporate Liaison"
	assignment = "NORCOMM Corporate Liaison"

/datum/equipment_preset/survivor/corporate/soro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/charcoal(new_human), WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	..()
