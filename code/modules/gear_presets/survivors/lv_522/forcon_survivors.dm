///*****************************LV-522 Force Recon Survivors*******************************************************/
//Nanu told me to put them here so they dont clutter up survivors.dm
/datum/equipment_preset/survivor/forecon
	paygrade = PAY_SHORT_ME5
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "FORECON"
	rank = JOB_SURVIVOR
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
	)

	dress_shoes = list(/obj/item/clothing/shoes/dress)
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)

/datum/equipment_preset/survivor/forecon/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_forecon(new_human), WEAR_L_EAR)
	GLOB.character_traits[/datum/character_trait/skills/spotter].apply_trait(new_human)

/datum/equipment_preset/survivor/forecon/add_survivor_weapon_security(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/forecon/proc/add_forecon_weapon(mob/living/carbon/human/new_human)
	var/random_gun = rand(1,3)
	switch(random_gun)
		if(1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra(new_human), WEAR_IN_BACK)

/datum/equipment_preset/survivor/forecon/add_survivor_weapon_pistol(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/forecon/proc/add_forecon_weapon_pistol(mob/living/carbon/human/new_human)
	var/random_pistol = rand(1,5)
	switch(random_pistol)
		if(1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
		if(3 , 4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/extended(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/extended(new_human), WEAR_IN_BACK)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human),WEAR_WAIST)

/datum/equipment_preset/survivor/forecon/add_random_survivor_equipment(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/forecon/proc/add_forecon_equipment(mob/living/carbon/human/new_human)
	var/random_equipment = rand(1,3)
	switch(random_equipment)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/device/walkman(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/cassette_tape/indie(new_human), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/toy/deck(new_human), WEAR_IN_ACCESSORY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(new_human), WEAR_IN_ACCESSORY)

/datum/equipment_preset/survivor/forecon/proc/spawn_random_headgear(mob/living/carbon/human/new_human)
	var/i = rand(1,10)
	switch(i)
		if (1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
		if (3 , 4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/gray(new_human), WEAR_HEAD)
		if (5 , 6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/durag(new_human), WEAR_HEAD)
		if (7 , 8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/boonie/tan(new_human), WEAR_HEAD)
		if (9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)

/datum/equipment_preset/survivor/forecon/standard
	name = "Survivor - USCM Reconnaissance Marine"
	assignment = JOB_FORECON_RIFLEMAN
	skills = /datum/skills/military/survivor/forecon_standard

/datum/equipment_preset/survivor/forecon/standard/load_gear(mob/living/carbon/human/new_human)
	..()
	add_forecon_weapon_pistol(new_human)
	add_forecon_weapon(new_human)
	spawn_random_headgear(new_human)
	add_forecon_equipment(new_human)

///*****************************//

/datum/equipment_preset/survivor/forecon/tech
	name = "Survivor - USCM Reconnaissance Support Technician"
	assignment = JOB_FORECON_SUPPORT
	skills = /datum/skills/military/survivor/forecon_techician

/datum/equipment_preset/survivor/forecon/tech/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/big(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BACK)
	add_forecon_weapon(new_human)
	spawn_random_headgear(new_human)
	add_forecon_equipment(new_human)

///*****************************//

/datum/equipment_preset/survivor/forecon/marksman
	name = "Survivor - USCM Reconnaissance Designated Marksman"
	assignment = JOB_FORECON_MARKSMAN
	skills = /datum/skills/military/survivor/forecon_marksman

/datum/equipment_preset/survivor/forecon/marksman/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra_custom(new_human), WEAR_L_HAND)
	..()
	add_forecon_weapon_pistol(new_human)
	spawn_random_headgear(new_human)
	add_forecon_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom(new_human), WEAR_IN_BACK)

///*****************************//

/datum/equipment_preset/survivor/forecon/smartgunner
	name = "Survivor - USCM Reconnaissance Smartgunner"
	assignment = JOB_FORECON_SMARTGUNNER
	skills = /datum/skills/military/survivor/forecon_smartgunner

/datum/equipment_preset/survivor/forecon/smartgunner/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot(new /obj/item/smartgun_battery(new_human), WEAR_IN_BACK)
	add_forecon_weapon(new_human)
	spawn_random_headgear(new_human)
	add_forecon_equipment(new_human)

///*****************************//

/datum/equipment_preset/survivor/forecon/sniper
	name = "Survivor - USCM Reconnaissance Sniper"
	assignment = JOB_FORECON_SNIPER
	skills = /datum/skills/military/survivor/forecon_sniper

/datum/equipment_preset/survivor/forecon/sniper/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot(new /obj/item/clothing/suit/storage/marine/ghillie/forecon(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_forecon(new_human), WEAR_L_EAR)
	spawn_random_headgear(new_human)
	add_forecon_equipment(new_human)
	add_forecon_weapon_pistol(new_human)

//---------------------------\\

/datum/equipment_preset/survivor/forecon/squad_leader
	name = "Survivor - USCM Reconnaissance Squad Leader"
	assignment = JOB_FORECON_SL
	skills = /datum/skills/military/survivor/forecon_squad_leader
	paygrade = PAY_SHORT_MO1

	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover/officer)

/datum/equipment_preset/survivor/forecon/squad_leader/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/o1/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/shotgun/slugs(new_human), WEAR_L_HAND)
	..()
	add_forecon_weapon_pistol(new_human)
	spawn_random_headgear(new_human)
	add_forecon_equipment(new_human)

//---------------------------\\

/datum/equipment_preset/survivor/forecon/major
	name = "Survivor - USCM Reconnaissance Major"
	assignment = JOB_FORECON_CO
	skills = /datum/skills/commander
	paygrade = PAY_SHORT_MO4
	idtype = /obj/item/card/id/gold
	role_comm_title = "FORECON CO"

	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover/officer)

/datum/equipment_preset/survivor/forecon/major/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/o4/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/windbreaker/windbreaker_green(new_human), WEAR_JACKET)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/cmateba(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/mateba/cmateba(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo/gold(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/davenport(new_human), WEAR_IN_BACK)

//----------------------\\

/datum/equipment_preset/synth/survivor/forecon
	name = "Survivor - Synthetic - FORECON Synth"
	assignment = JOB_FORECON_SYN
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/synth/survivor/forecon/load_gear(mob/living/carbon/human/preset_human) //Bishop from Aliens
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi, WEAR_BODY)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(preset_human), WEAR_BACK)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red/knife(preset_human), WEAR_FEET)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch(preset_human), WEAR_ACCESSORY)
	preset_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(preset_human), WEAR_L_HAND)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(preset_human), WEAR_R_HAND)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(preset_human), WEAR_R_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(preset_human), WEAR_L_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_forecon(preset_human), WEAR_L_EAR)
