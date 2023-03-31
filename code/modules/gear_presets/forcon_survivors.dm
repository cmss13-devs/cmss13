///*****************************LV-522 Force Recon Survivors*******************************************************/
//Nanu told me to put them here so they dont clutter up survivors.dm

/datum/equipment_preset/survivor/forecon
	paygrade = "ME5"
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "FORECON"
	rank = JOB_SURVIVOR
	faction_group = list(FACTION_USCM, FACTION_SURVIVOR)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
	)

/datum/equipment_preset/survivor/forecon/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(H,pouch)
	uniform.attach_accessory(H,patch_uscm)
	uniform.attach_accessory(H,pin)
	uniform.attach_accessory(H,patch_forecon)
	H.equip_to_slot_or_del(uniform, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/facepaint/sniper(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE(H), WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_IN_BACK)
	GLOB.character_traits[/datum/character_trait/skills/spotter].apply_trait(H)

/datum/equipment_preset/survivor/forecon/add_survivor_weapon_security(mob/living/carbon/human/H)
	return

/datum/equipment_preset/survivor/forecon/proc/add_forecon_weapon(mob/living/carbon/human/H)
	var/random_gun = rand(1,3)
	switch(random_gun)
		if(1 , 2)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra(H), WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra(H), WEAR_IN_BACK)

/datum/equipment_preset/survivor/forecon/add_survivor_weapon_pistol(mob/living/carbon/human/H)
	return

/datum/equipment_preset/survivor/forecon/proc/add_forecon_weapon_pistol(mob/living/carbon/human/H)
	var/random_pistol = rand(1,5)
	switch(random_pistol)
		if(1 , 2)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(H), WEAR_IN_BELT)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BELT)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BELT)
		if(3 , 4)
			H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39, WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39(H), WEAR_IN_BELT)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/extended(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/extended(H), WEAR_IN_BACK)
		if(5)
			H.equip_to_slot_or_del(new /obj/item/device/motiondetector(H),WEAR_WAIST)

/datum/equipment_preset/survivor/forecon/add_random_survivor_equipment(mob/living/carbon/human/H)
	return

/datum/equipment_preset/survivor/forecon/proc/add_forecon_equipment(mob/living/carbon/human/H)
	var/random_equipment = rand(1,3)
	switch(random_equipment)
		if(1)
			H.equip_to_slot_or_del(new /obj/item/device/walkman(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/device/cassette_tape/indie(H), WEAR_IN_BACK)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/toy/deck(H), WEAR_IN_ACCESSORY)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(H), WEAR_IN_ACCESSORY)

/datum/equipment_preset/survivor/forecon/proc/spawn_random_headgear(mob/living/carbon/human/H)
	var/i = rand(1,10)
	switch(i)
		if (1 , 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(H), WEAR_HEAD)
		if (3 , 4)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/gray(H), WEAR_HEAD)
		if (5 , 6)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/durag(H), WEAR_HEAD)
		if (7 , 8)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/boonie/tan(H), WEAR_HEAD)
		if (9)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)

/datum/equipment_preset/survivor/forecon/standard
	name = "Survivor - USCM Reconnaissance Marine"
	assignment = "Reconnaissance Rifleman"
	skills = /datum/skills/military/survivor/forecon_standard

/datum/equipment_preset/survivor/forecon/standard/load_gear(mob/living/carbon/human/H)
	..()
	add_forecon_weapon_pistol(H)
	add_forecon_weapon(H)
	spawn_random_headgear(H)
	add_forecon_equipment(H)

///*****************************//

/datum/equipment_preset/survivor/forecon/tech
	name = "Survivor - USCM Reconnaissance Support Technician"
	assignment = "Reconnaissance Support Technician"
	skills = /datum/skills/military/survivor/forecon_techician

/datum/equipment_preset/survivor/forecon/tech/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/big(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	..()
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BACK)
	add_forecon_weapon(H)
	spawn_random_headgear(H)
	add_forecon_equipment(H)

///*****************************//

/datum/equipment_preset/survivor/forecon/marksman
	name = "Survivor - USCM Reconnaissance Designated Marksman"
	assignment = "Reconnaissance Marksman"
	skills = /datum/skills/military/survivor/forecon_marksman

/datum/equipment_preset/survivor/forecon/marksman/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra_custom(H), WEAR_L_HAND)
	..()
	add_forecon_weapon_pistol(H)
	spawn_random_headgear(H)
	add_forecon_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom(H), WEAR_IN_BACK)

///*****************************//

/datum/equipment_preset/survivor/forecon/smartgunner
	name = "Survivor - USCM Reconnaissance Smartgunner"
	assignment = "Reconnaissance Smartgunner"
	skills = /datum/skills/military/survivor/forecon_smartgunner

/datum/equipment_preset/survivor/forecon/smartgunner/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_R_HAND)
	..()
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(H), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BELT)
	add_forecon_weapon(H)
	spawn_random_headgear(H)
	add_forecon_equipment(H)

///*****************************//

/datum/equipment_preset/survivor/forecon/grenadier
	name = "Survivor - USCM Reconnaissance Grenadier"
	assignment = "Reconnaissance Grenadier"
	skills = /datum/skills/military/survivor/forecon_grenadier

/datum/equipment_preset/survivor/forecon/grenadier/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/launcher/grenade/m81/m79(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(H), WEAR_R_HAND)
	..()
	H.equip_to_slot_or_del(new /obj/item/storage/belt/grenade(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/incendiary(H), WEAR_IN_BACK)
	spawn_random_headgear(H)
	add_forecon_equipment(H)

//---------------------------\\

/datum/equipment_preset/survivor/forecon/squad_leader
	name = "Survivor - USCM Reconnaissance Squad Leader"
	assignment = "Reconnaissance Squad Leader"
	skills = /datum/skills/military/survivor/forecon_squad_leader
	paygrade = "MO1"

/datum/equipment_preset/survivor/forecon/squad_leader/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/o1/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(H,pouch)
	uniform.attach_accessory(H,patch_uscm)
	uniform.attach_accessory(H,pin)
	uniform.attach_accessory(H,patch_forecon)
	H.equip_to_slot_or_del(uniform, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump(H), WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/shotgun/slugs(H), WEAR_L_HAND)
	..()
	add_forecon_weapon_pistol(H)
	spawn_random_headgear(H)
	add_forecon_equipment(H)

//---------------------------\\

/datum/equipment_preset/survivor/forecon/major
	name = "Survivor - USCM Reconnaissance Major"
	assignment = "Reconnaissance Commander"
	skills = /datum/skills/commander
	paygrade = "MO4"
	idtype = /obj/item/card/id/gold
	role_comm_title = "FORECON CO"

/datum/equipment_preset/survivor/forecon/major/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/o4/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(H,pouch)
	uniform.attach_accessory(H,patch_uscm)
	uniform.attach_accessory(H,pin)
	uniform.attach_accessory(H,patch_forecon)
	H.equip_to_slot_or_del(uniform, WEAR_BODY)
	..()
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/cmateba(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/mateba/cmateba(H), WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(H), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(H), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(H), WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo/gold(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/davenport(H), WEAR_IN_BACK)

//----------------------\\

/datum/equipment_preset/synth/survivor/forecon
	name = "Survivor - USCM Synthetic"
	assignment = "Reconnaissance Synthetic"
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/synth/survivor/forecon/load_gear(mob/living/carbon/human/preset_human) //Bishop from Aliens
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi, WEAR_BODY)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(preset_human), WEAR_BACK)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(preset_human), WEAR_FEET)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch(preset_human), WEAR_ACCESSORY)
	preset_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(preset_human), WEAR_L_HAND)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(preset_human), WEAR_R_HAND)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(preset_human), WEAR_R_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(preset_human), WEAR_L_STORE)
