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
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e2/pin = new()
	var/obj/item/clothing/accessory/patch/army/patch_army = new()
	var/obj/item/clothing/accessory/patch/army/infantry/patch_infantry = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_army)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_infantry)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium/rto(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big/fake/orange(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_army(new_human), WEAR_L_EAR)
	GLOB.character_traits[/datum/character_trait/skills/spotter].apply_trait(new_human)

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
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
		if(3 , 4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/full/extended, WEAR_WAIST)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human),WEAR_WAIST)

/datum/equipment_preset/survivor/army/add_random_survivor_equipment(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/army/proc/spawn_random_headgear(mob/living/carbon/human/new_human)
	var/i = rand(1,3)
	switch(i)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
		if (2, 3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/rto(new_human), WEAR_HEAD)

/datum/equipment_preset/survivor/army/standard
	name = "Survivor - US Army Trooper"
	assignment = JOB_ARMY_TROOPER
	rank = JOB_ARMY_TROOPER
	skills = /datum/skills/military/survivor/army_standard
	minimap_icon = "army_trpr"

/datum/equipment_preset/survivor/army/standard/load_gear(mob/living/carbon/human/new_human)
	..()
	spawn_random_headgear(new_human)
	add_army_weapon_pistol(new_human)
	add_army_weapon(new_human)

///*****************************//
