///*****************************US Army Survivors************************************************/
/datum/equipment_preset/survivor/army
	name = "Survivor - US Army"
	paygrades = list(PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "ARMY"
	minimap_background = "background_ua"
	rank = JOB_ARMY_TROOPER
	faction = FACTION_MARINE
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

/datum/equipment_preset/survivor/army/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/army/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/patch/army/patch_army = new()
	var/obj/item/clothing/accessory/patch/army/infantry/patch_infantry = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_army)
	uniform.attach_accessory(new_human,patch_infantry)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium/rto/army(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/army(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/army/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/army(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big/fake/orange(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_army(new_human), WEAR_L_EAR)

/datum/equipment_preset/survivor/army/add_survivor_weapon_security(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/army/proc/add_army_weapon(mob/living/carbon/human/new_human)
	var/random_gun = rand(1,3)
	switch(random_gun)
		if(1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/army(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/heap/empty(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra/army(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/heap/empty(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra(new_human), WEAR_IN_BACK)

/datum/equipment_preset/survivor/army/add_survivor_weapon_pistol(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/army/proc/add_army_weapon_pistol(mob/living/carbon/human/new_human)
	var/random_pistol = rand(1,5)
	switch(random_pistol)
		if(1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/mod88(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88(new_human), WEAR_IN_BELT)
		if(3 , 4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/full/extended, WEAR_WAIST)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human),WEAR_WAIST)

/datum/equipment_preset/survivor/army/add_random_survivor_equipment(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/army/proc/spawn_random_headgear(mob/living/carbon/human/new_human)
	var/i = rand(1,4)
	switch(i)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm/black/army(new_human), WEAR_HEAD)
		if (3 , 4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/rto/army(new_human), WEAR_HEAD)

/datum/equipment_preset/survivor/army/standard
	name = "Survivor - US Army Trooper"
	assignment = JOB_ARMY_TROOPER
	rank = JOB_ARMY_TROOPER
	skills = /datum/skills/military/survivor/army_standard
	minimap_icon = "hudsquad_trpr"

/datum/equipment_preset/survivor/army/standard/load_gear(mob/living/carbon/human/new_human)
	..()
	spawn_random_headgear(new_human)
	add_army_weapon_pistol(new_human)
	add_army_weapon(new_human)

///*****************************//

/datum/equipment_preset/survivor/army/engineer
	name = "Survivor - US Army Combat Engineering Technician"
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_ARMY_ENGI
	rank = JOB_ARMY_ENGI
	skills = /datum/skills/military/survivor/army_engineer
	minimap_icon = "hudsquad_cet"

/datum/equipment_preset/survivor/army/engineer/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/rto/army/engi(new_human), WEAR_HEAD)
	add_army_weapon(new_human)

/datum/equipment_preset/survivor/army/medic
	name = "Survivor - US Army Combat Medical Technician"
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_ARMY_MEDIC
	rank = JOB_ARMY_MEDIC
	skills = /datum/skills/military/survivor/army_medic
	minimap_icon = "hudsquad_cet"

/datum/equipment_preset/survivor/army/medic/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/rto/army/medic(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/big/army(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BACK)
	add_army_weapon(new_human)

/datum/equipment_preset/survivor/army/marksman
	name = "Survivor - US Army Marksman"
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_ARMY_MARKSMAN
	rank = JOB_ARMY_MARKSMAN
	skills = /datum/skills/military/survivor/army_marksman
	minimap_icon = "hudsquad_snpr"

/datum/equipment_preset/survivor/army/marksman/load_gear(mob/living/carbon/human/new_human)
	..()
	add_army_weapon_pistol(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm/black/army(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m4ra_custom(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/custom(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/extended(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m4ra/extended(new_human), WEAR_IN_BACK)

/datum/equipment_preset/survivor/army/gunner
	name = "Survivor - US Army Heavy Gunner"
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_ARMY_SMARTGUNNER
	rank = JOB_ARMY_SMARTGUNNER
	skills = /datum/skills/military/survivor/army_gunner
	minimap_icon = "hudsquad_mmg"

/datum/equipment_preset/survivor/army/gunner/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/mod88(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smartgun/empty(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot(new /obj/item/smartgun_battery(new_human), WEAR_IN_BACK)
	spawn_random_headgear(new_human)
	add_army_weapon(new_human)

/datum/equipment_preset/survivor/army/sl
	name = "Survivor - US Army Squad Leader"
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_ARMY_SNCO
	rank = JOB_ARMY_SNCO
	skills = /datum/skills/military/survivor/army_sl
	minimap_icon = "hudsquad_sl_army"

/datum/equipment_preset/survivor/army/sl/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_BACK)
	spawn_random_headgear(new_human)
	add_army_weapon_pistol(new_human)
	add_army_weapon(new_human)

///*****************************//
/// Army Commander ///

/datum/equipment_preset/survivor/army/co
	name = "Survivor - US Army Commander"
	paygrades = list(PAY_SHORT_MO4 = JOB_PLAYTIME_TIER_0)
	assignment = JOB_ARMY_CO
	rank = JOB_ARMY_CO
	idtype = /obj/item/card/id/gold
	skills = /datum/skills/commander
	minimap_icon = "hudsquad_co_army"

/datum/equipment_preset/survivor/army/co/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/cmateba(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/mateba/cmateba(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/classic(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo/gold(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/tequila(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/commander/black/army(new_human), WEAR_HEAD)

///*****************************//
/// Army Synthetic ///

/datum/equipment_preset/synth/survivor/army
	name = "Survivor - US Army Synthetic"
	paygrades = list(PAY_SHORT_ME8E = JOB_PLAYTIME_TIER_0)
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	assignment = JOB_ARMY_SYN
	rank = "Synthetic"
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/synth/survivor/army/load_gear(mob/living/carbon/human/preset_human)
	var/obj/item/clothing/under/marine/army/uniform = new()
	var/random_number = rand(1,2)
	switch(random_number)
		if(1)
			uniform.roll_suit_jacket(preset_human)
		if(2)
			uniform.roll_suit_sleeves(preset_human)
	preset_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(preset_human), WEAR_ACCESSORY)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/army(preset_human), WEAR_ACCESSORY)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/army/infantry(preset_human), WEAR_ACCESSORY)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/big/army(preset_human), WEAR_BACK)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/synvest(preset_human), WEAR_JACKET)
	preset_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(preset_human), WEAR_IN_JACKET)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(preset_human), WEAR_J_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big/fake/orange(preset_human), WEAR_EYES)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/army(preset_human), WEAR_HANDS)
	preset_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic, WEAR_IN_BACK)
	preset_human.equip_to_slot_or_del(new /obj/item/device/radio(preset_human), WEAR_IN_BACK)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/army/knife(preset_human), WEAR_FEET)
	preset_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(preset_human), WEAR_WAIST)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(preset_human), WEAR_R_HAND)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(preset_human), WEAR_R_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(preset_human), WEAR_L_STORE)
	preset_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_army(preset_human), WEAR_L_EAR)
	preset_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(preset_human), WEAR_HEAD)
