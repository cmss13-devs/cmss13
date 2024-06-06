//////////////////// CIVILIAN ///////////////////////
////////////////////////////////////////////////////

// Civilian

/datum/equipment_preset/survivor/civilian_hybrisa
	name = "Survivor - Hybrisa - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/civilian_hybrisa/load_gear(mob/living/carbon/human/new_human)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	var/random_gear = rand(1,336)
	switch(random_gear)
		if(1 to 20) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/ferret(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
		if(20 to 40) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
		if(40 to 60) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_green(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(60 to 80) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(80 to 100) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(100 to 120) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_red(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(120 to 140) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(140 to 160) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(160 to 180) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker/red(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/ferret(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(180 to 200) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/stowaway(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(200 to 220) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/white_service(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(220 to 240) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/suspenders(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
		if(240 to 260) // Weymart-Employee
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/hybrisa/weymart(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/weymart(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/weymart(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(260 to 270) // Weymart-Employee (Rarer)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/hybrisa/weymart(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/weymart(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/weymart(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic(new_human.back), WEAR_IN_BACK)
		if(270 to 290) // Pizza Delivery
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/hybrisa/pizza_galaxy(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife(new_human.back), WEAR_IN_BACK)
		if(290 to 300) // Pizza Delivery (Rarer)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headband/red(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/civilian_vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/meatpizzaslice(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/kt42, WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/kt42, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/kt42, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/kt42, WEAR_IN_R_STORE)
		if(300 to 302) // Pizza Delivery (Very Rare)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/pizza_galaxy(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/meatpizzaslice(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb/m3717, WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
		if(302 to 322) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
		if(322 to 332) // Sanitation (Rarer)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/durag/black(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer, WEAR_R_HAND)
		if(332 to 336) // Firefighter (Very Rare)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/firefighter(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/ua_civvies(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/fire_light(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/owlf_mask(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe, WEAR_R_HAND)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/chaplain/hybrisa
	name = "Survivor - Hybrisa - Chaplain"
	assignment = "Chaplain"

/datum/equipment_preset/survivor/chaplain/hybrisa/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/nun(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/nun_hood(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/holidaypriest(new_human), WEAR_JACKET)
	..()

//////////////// COLONIAL MARSHALLS /////////////////
////////////////////////////////////////////////////

// Colonial Marshals

/datum/equipment_preset/survivor/hybrisa/CMB_officer

	name = "Survivor - Hybrisa - CMB Police Officer"
	assignment = "CMB Affiliated Officer"
	paygrade = PAY_SHORT_CMBD
	skills = /datum/skills/civilian/survivor/marshal
	flags = EQUIPMENT_PRESET_EXTRA
	idtype = /obj/item/card/id/deputy
	role_comm_title = "CMB DEP"
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_RESEARCH,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)

/datum/equipment_preset/survivor/hybrisa/CMB_officer/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,10)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/CMB_officer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud_blue, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)

	switch(choice)
		if(1 to 5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/CMB_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
		if(6 to 7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/CMB_cap_new, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/CMB_vest, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_BACK)
		if(8 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/CMB_peaked_cap_gold, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/CMB_vest, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower/black, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
	..()

//////////////// MEDICAL & SCIENCE //////////////////
////////////////////////////////////////////////////

// Doctors / Science

/datum/equipment_preset/survivor/doctor/hybrisa
	name = "Survivor - Hybrisa - Nova Medica Doctor"
	assignment = "Nova Medica - Doctor"

/datum/equipment_preset/survivor/doctor/hybrisa/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	..()

// Nova Medica - Paramedic

/datum/equipment_preset/survivor/hybrisa/hybrisa_paramedic
	name = "Survivor - Hybrisa - Nova Medica - EMT - Paramedic"
	assignment = "Nova Medica - EMT - Paramedic"
	paygrade = PAY_SHORT_CIV
	role_comm_title = "NM-PARA"
	paygrade = PAY_SHORT_CDOC
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Nova Medica - Paramedic"
	skills = /datum/skills/civilian/survivor/paramedic
	idtype = /obj/item/card/id/silver
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

/datum/equipment_preset/survivor/hybrisa/hybrisa_paramedic/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,25)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/FixOVein, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	switch(choice)
		if(1 to 9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_red_utility, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic/red, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/merc, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)
		if(10 to 19)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_green_utility, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)
		if(20 to 24)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/medical_green, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/heavy, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/heavy, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/heavy, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/heavy, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)
		if(25)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_red_utility, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic/red, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/medtech, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	..()

// Science

/datum/equipment_preset/survivor/scientist/hybrisa
	name = "Survivor - Hybrisa - Researcher"
	assignment = "Researcher"

/datum/equipment_preset/survivor/scientist/hybrisa/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/rd(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/jan(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	..()

///////////// MAINTENANCE & ENGINEERING /////////////
////////////////////////////////////////////////////

// Engineering & Maintenance

/datum/equipment_preset/survivor/trucker/hybrisa
	name = "Survivor - Hybrisa - Heavy Vehicle Operator"
	assignment = "Heavy Vehicle Operator"
	skills = /datum/skills/civilian/survivor/trucker

/datum/equipment_preset/survivor/trucker/hybrisa/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank(new_human), WEAR_IN_BACK)
	..()

/datum/equipment_preset/survivor/engineer/hybrisa/hydro
	name = "Survivor - Hybrisa - Electrical Engineer"
	assignment = "Electrical Engineer"

/datum/equipment_preset/survivor/engineer/hybrisa/hydro/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(new_human), WEAR_HEAD)
	..()

/datum/equipment_preset/survivor/engineer/hybrisa
	name = "Survivor - Hybrisa - Maintenance Technician"
	assignment = "Maintenance Technician"

/datum/equipment_preset/survivor/engineer/hybrisa/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	..()


//////////////// WEYLAND YUTANI /////////////////////
////////////////////////////////////////////////////

// Weyland Yutani Corpo

/datum/equipment_preset/survivor/corporate/hybrisa
	name = "Survivor - Hybrisa - Corporate Liaison"
	assignment = "Corporate Liaison"

/datum/equipment_preset/survivor/corporate/hybrisa/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/ivy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	..()

// WY Goons

/datum/equipment_preset/survivor/security/hybrisa
	name = "Survivor - Hybrisa - Weyland-Yutani Corporate Security Guard"
	assignment = "Weyland-Yutani Corporate Security Guard"

/datum/equipment_preset/survivor/security/hybrisa/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,30)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)

	switch(choice)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/WY_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
		if(11 to 29)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
		if(30)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa/lead, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa/lead, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	..()

// WY - Pilot

/datum/equipment_preset/survivor/corporate/Wey_PO
	name = "Survivor - Hybrisa - Weyland-Yutani - Commercial Pilot"
	assignment = "Weyland-Yutani - Commercial Pilot"
	skills = /datum/skills/civilian/survivor/wy_pilot
	role_comm_title = "WY-PO"
	paygrade = PAY_SHORT_WYC2
	idtype = /obj/item/card/id/captains_spare
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_LOGISTICS,ACCESS_WY_FLIGHT,ACCESS_CIVILIAN_COMMAND)

/datum/equipment_preset/survivor/corporate/Wey_PO/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,4)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/WY_PO_cap, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/WY_pilot, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headset, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)

	switch(choice)
		if(1 to 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hybrisa/WY_Pilot, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator, WEAR_EYES)
		if(2 to 4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hybrisa/WY_Pilot, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator_silver, WEAR_EYES)
	..()

//////////////// KELLAND MINING /////////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/survivor/miner/kelland
	name = "Survivor - Hybrisa - KMCC - Miner"
	assignment = "KMCC - Miner"
	skills = /datum/skills/civilian/survivor/miner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/datum/equipment_preset/survivor/miner/kelland/load_gear(mob/living/carbon/human/new_human)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	var/random_gear = rand(1,85)
	switch(random_gear)
		if(1 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/red, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/kelland_mining, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
		if(50 to 70)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hybrisa_kelland(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/kelland_mining, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
		if(70 to 80)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/heavy, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hybrisa_kelland(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
		if(80 to 85)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/light, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hybrisa_kelland(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/royal_marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	add_survivor_weapon_civilian(new_human)
	..()
