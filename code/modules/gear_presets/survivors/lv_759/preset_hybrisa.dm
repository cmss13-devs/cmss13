//////////////////// CIVILIAN ///////////////////////
////////////////////////////////////////////////////

// Civilian

/datum/equipment_preset/survivor/hybrisa/civilian
	name = "Survivor - Hybrisa - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/civilian/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,10)
	switch(random_gear)
		if(1) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/grey(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
		if(2) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
		if(3) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_green(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(4) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(5) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(6) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_red(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(7) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/ferret(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(8) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(9) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker/red(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(10) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/royal_marine(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/bomber/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/steward(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/royal_marine(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
	add_survivor_rare_item(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

// Office Workers

/datum/equipment_preset/survivor/hybrisa/civilian_office
	name = "Survivor - Hybrisa - Civilian - Office Worker"
	assignment = "Civilian - Office Worker"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/civilian_office/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,6)
	switch(random_gear)
		if(1) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/stowaway(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/white_service(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/suspenders(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
		if(4) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(5) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/white_service(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(6) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blazer(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
	add_survivor_rare_item(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

// Weymart Employee

/datum/equipment_preset/survivor/hybrisa/weymart
	name = "Survivor - Hybrisa - Civilian - Weymart Employee"
	assignment = "Civilian - Weymart Employee"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/weymart/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 45) // Weymart-Employee
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/weymart(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/weymart(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/weymart(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(45 to 50) // Weymart-Employee (Rarer)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/weymart(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/weymart(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/weymart(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic(new_human.back), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	..()

// Sanitation

/datum/equipment_preset/survivor/hybrisa/sanitation
	name = "Survivor - Hybrisa - Civilian - Material Reprocessing Technician"
	assignment = "Civilian - Material Reprocessing Technician"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/sanitation/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 20) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
		if(20 to 30) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
		if(30 to 45) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
		if(45 to 50) // Sanitation (Rarer)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/durag/black(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/survivor(new_human), WEAR_R_HAND)
	add_survivor_weapon_civilian(new_human)
	..()

// Pizza Galaxy

/datum/equipment_preset/survivor/hybrisa/pizza_galaxy
	name = "Survivor - Hybrisa - Civilian - Pizza Galaxy Delivery Driver"
	assignment = "Civilian - Pizza Galaxy Delivery Driver"
	idtype = /obj/item/card/id/pizza
	skills = /datum/skills/civilian/survivor/pizza_delivery_driver
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/pizza_galaxy/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,65)
	switch(random_gear)
		if(1 to 45) // Pizza Delivery
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/pizza_galaxy(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/pizzabox/pizza_galaxy/mystery(new_human.back), WEAR_IN_BACK)
		if(45 to 60) // Pizza Delivery (Rarer)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headband/red(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/civilian_vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/pizzabox/pizza_galaxy/mystery(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/kt42(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/kt42(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/kt42(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/kt42(new_human), WEAR_IN_R_STORE)
		if(60 to 65) // Pizza Delivery (Very Rare)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/pizza_galaxy(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/pizzabox/pizza_galaxy/mystery(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb/m3717(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_R_STORE)
	add_survivor_weapon_civilian(new_human)
	..()

// Fire Protection Specialist

/datum/equipment_preset/survivor/hybrisa/fire_fighter
	name = "Survivor - Hybrisa - Civilian - Fire Protection Specialist"
	assignment = "Civilian - Fire Protection Specialist"
	role_comm_title = "FPS"
	skills = /datum/skills/civilian/survivor/fire_fighter
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/fire_fighter/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 30) // Firefighter
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_R_HAND)
		if(30 to 50) // (Rare)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/firefighter(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	..()

// Cuppa Joe's Employee

/datum/equipment_preset/survivor/hybrisa/cuppa_joes
	name = "Survivor - Hybrisa - Civilian - Cuppa Joe's Barista"
	assignment = "Civilian - Cuppa Joe's Barista"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/cuppa_joes/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 45) // Cuppa Joe's Barista
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/cuppa_joes(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/apron/cuppa_joes(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(45 to 50) // Cuppa Joe's Barista (Rarer)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/cuppa_joes(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/apron/cuppa_joes(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/m15(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/m15(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	add_survivor_weapon_civilian(new_human)
	..()

//////////////// COLONIAL MARSHALLS /////////////////
////////////////////////////////////////////////////

// NSPA - (Neroid Sector Policing Authority) - TWE style Police, like the CMB but for heavy TWE focused colonies.

/datum/equipment_preset/survivor/hybrisa/nspa_constable

	name = "Survivor - Hybrisa - NSPA Constable"
	assignment = "NSPA Constable"
	faction_group = FACTION_LIST_SURVIVOR_NSPA
	paygrades = list(PAY_SHORT_CST = JOB_PLAYTIME_TIER_0, PAY_SHORT_SC = JOB_PLAYTIME_TIER_3, PAY_SHORT_SGT = JOB_PLAYTIME_TIER_4)
	skills = /datum/skills/civilian/survivor/marshal
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/nspa_silver
	faction = FACTION_NSPA
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_RESEARCH,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)
	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/nspa_constable/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,100)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/l54/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue(new_human), WEAR_EYES)

	switch(choice)
		if(1 to 25)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_jacket(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
		if(25 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_formal_jacket(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
		if(50 to 75)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/nspa_vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber(new_human.back), WEAR_IN_BACK)
		if(75 to 80)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_hazard_jacket(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_R_STORE)
		if(80 to 95)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap_goldandsilver(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/nspa_hazard(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag(new_human), WEAR_IN_R_STORE)
		if(95 to 100)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap_gold(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_formal_jacket(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag(new_human), WEAR_IN_R_STORE)
	..()

//////////////// MEDICAL & SCIENCE //////////////////
////////////////////////////////////////////////////

// Doctors / Science

/datum/equipment_preset/survivor/hybrisa/doctor
	name = "Survivor - Hybrisa - Medical Doctor"
	assignment = "Doctor"
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/doctor/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,45)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit(new_human), WEAR_R_STORE)

	switch(choice)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
		if(20 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
		if(35 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/medical_red(new_human), WEAR_JACKET)
	add_random_survivor_medical_gear(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

// Nova Medica - Paramedic

/datum/equipment_preset/survivor/hybrisa/paramedic
	name = "Survivor - Hybrisa - Emergency Medical Technician - Paramedic"
	assignment = "Emergency Medical Technician - Paramedic"
	paygrades = list(PAY_SHORT_CPARA = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = "EMT - Paramedic"
	skills = /datum/skills/civilian/survivor/paramedic
	idtype = /obj/item/card/id/silver
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/paramedic/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,25)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)

	switch(choice)
		if(1 to 9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_red_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic/red(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(10 to 19)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_green_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(20 to 24)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/medical_green(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(25)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_red_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic/red(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/medtech(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended(new_human), WEAR_IN_R_STORE)
	add_random_survivor_medical_gear(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

// Science

/datum/equipment_preset/survivor/hybrisa/scientist_xenoarchaeologist
	name = "Survivor - Hybrisa - Xenoarchaeologist"
	assignment = "Xenoarchaeologist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/scientist_xenoarchaeologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,55)
	switch(random_gear)
		if(1 to 25)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_EYES)
		if(25 to 35)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/wy_bio/alt(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
		if(35 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/wy_bio/alt(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
		if(50 to 55)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/wy_bio(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	add_random_survivor_research_gear(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/scientist_xenobiologist
	name = "Survivor - Hybrisa - Xenobiologist"
	assignment = "Xenobiologist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/scientist_xenobiologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(20 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_EYES)
		if(45 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/civilian_vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headband/tan(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/survivor(new_human), WEAR_R_HAND)
	add_survivor_weapon_civilian(new_human)
	add_random_survivor_research_gear(new_human)
	..()

///////////// MAINTENANCE & ENGINEERING /////////////
////////////////////////////////////////////////////

// Engineering & Maintenance

/datum/equipment_preset/survivor/hybrisa/heavy_vehicle_operator
	name = "Survivor - Hybrisa - Heavy Vehicle Operator"
	assignment = "Heavy Vehicle Operator"
	skills = /datum/skills/civilian/survivor/trucker
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/heavy_vehicle_operator/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,6)
	new_human.equip_to_slot_or_del(new /obj/item/hardpoint/locomotion/van_wheels(new_human), WEAR_R_HAND)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/tan(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/tan(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/brown_vest(new_human), WEAR_ACCESSORY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/gray(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker/red(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator/silver(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headset(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/frontier(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/ferret(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/yellow(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest(new_human), WEAR_ACCESSORY)
	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/hybrisa/electrical_engineer
	name = "Survivor - Hybrisa - Electrical Engineer"
	assignment = "Electrical Engineer"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/electrical_engineer/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,3)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/engineering_utility_oversuit/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	add_survivor_weapon_civilian(new_human)
	..()

// Construction Worker

/datum/equipment_preset/survivor/hybrisa/construction_worker
	name = "Survivor - Hybrisa - Construction Worker"
	assignment = "Construction Worker"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/construction_worker/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,3)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human.back), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human.back), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/engineering_utility_oversuit(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/nailgun(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	add_survivor_weapon_civilian(new_human)
	..()

//////////////// WEYLAND YUTANI /////////////////////
////////////////////////////////////////////////////

// Weyland Yutani Corpo

/datum/equipment_preset/survivor/corporate/hybrisa
	name = "Survivor - Hybrisa - Corporate Liaison"
	assignment = "Corporate Liaison"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	paygrades = list(PAY_SHORT_WYC2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_WYC3 = JOB_PLAYTIME_TIER_2, PAY_SHORT_WYC4 = JOB_PLAYTIME_TIER_3, PAY_SHORT_WYC5 = JOB_PLAYTIME_TIER_4, PAY_SHORT_WYC6 = JOB_PLAYTIME_TIER_5, PAY_SHORT_WYC7 = JOB_PLAYTIME_TIER_6, PAY_SHORT_WYC8 = JOB_PLAYTIME_TIER_7, PAY_SHORT_WYC9 = JOB_PLAYTIME_TIER_8)
	faction_group = FACTION_LIST_SURVIVOR_WY
	idtype = /obj/item/card/id/silver/clearance_badge/cl
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_COMMAND,ACCESS_WY_GENERAL,ACCESS_WY_COLONIAL,ACCESS_WY_EXEC,)

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/corporate/hybrisa/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,45)
	switch(choice)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
		if(10 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/jacket(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
		if(20 to 30)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
		if(30 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/brown/jacket(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
		if(40 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/mod88(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88/penetrating(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88/penetrating(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/jacket_only(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/fur_lined_trench_coat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	add_random_cl_survivor_loot(new_human)
	..()

// WY Goons

/datum/equipment_preset/survivor/hybrisa/corporate_goon
	name = "Survivor - Hybrisa - Weyland-Yutani - Corporate Security Guard"
	assignment = "Weyland-Yutani - Corporate Security Guard"
	assignment = JOB_WY_GOON
	job_title = JOB_WY_GOON
	minimap_icon = "goon_standard"
	minimap_background = "background_goon"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR)
	origin_override = ORIGIN_WY_SEC
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0, PAY_SHORT_CSPO = JOB_PLAYTIME_TIER_4)
	skills = /datum/skills/civilian/survivor/goon
	idtype = /obj/item/card/id/silver/cl
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_RESEARCH,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,ACCESS_WY_EXEC,ACCESS_WY_GENERAL,ACCESS_WY_COLONIAL)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/corporate_goon/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,30)
	switch(choice)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/wy_cap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
		if(11 to 29)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
		if(30)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa/lead(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa/lead(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human.back), WEAR_IN_BACK)
	..()

// WY - Pilot

/datum/equipment_preset/survivor/hybrisa/wey_po
	name = "Survivor - Hybrisa - Weyland-Yutani - Commercial Pilot"
	assignment = "Weyland-Yutani - Commercial Pilot"
	skills = /datum/skills/civilian/survivor/wy_pilot
	paygrades = list(PAY_SHORT_WYPO2 = JOB_PLAYTIME_TIER_0)
	faction_group = FACTION_LIST_SURVIVOR_WY
	idtype = /obj/item/card/id/gold
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_LOGISTICS,ACCESS_WY_FLIGHT,ACCESS_CIVILIAN_COMMAND,ACCESS_WY_GENERAL,ACCESS_WY_COLONIAL,ACCESS_WY_EXEC)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/hybrisa/wey_po/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,4)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/wy_po_cap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hybrisa/wy_Pilot(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_pilot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)

	switch(random_gear)
		if(1 to 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
		if(2 to 4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator/silver(new_human), WEAR_EYES)
	add_random_cl_survivor_loot(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

//////////////// KELLAND MINING /////////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/survivor/hybrisa/kelland_miner
	name = "Survivor - Hybrisa - KMCC - Miner"
	assignment = "KMCC - Miner"
	skills = /datum/skills/civilian/survivor/miner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/datum/equipment_preset/survivor/hybrisa/kelland_miner/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,85)
	switch(random_gear)
		if(1 to 35)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/red/kelland(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/hybrisa_kelland_alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
		if(35 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/hybrisa_kelland_alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
		if(50 to 70)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/red/kelland(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/kelland_mining(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
		if(70 to 80)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/hybrisa_kelland(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended(new_human), WEAR_IN_R_STORE)
		if(80 to 85)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/hybrisa_kelland_alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/royal_marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/p90(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90(new_human), WEAR_IN_R_STORE)
	add_survivor_weapon_civilian(new_human)
	..()

//-------------------------------------------------------

//////////////// SNYTHETICS /////////////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/synth/survivor/hybrisa
	flags = EQUIPMENT_PRESET_STUB

// Civilian

/datum/equipment_preset/synth/survivor/hybrisa/civilian
	name = "Survivor - Hybrisa - Synthetic - Civilian"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/synth/survivor/hybrisa/civilian/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,7)
	switch(choice)
		if(1) // Weymart-Employee
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/weymart(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/weymart(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/weymart(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/mop(new_human), WEAR_R_HAND)
		if(3) // Pizza Delivery
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/pizza_galaxy(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/pizzabox/pizza_galaxy/mystery(new_human.back), WEAR_IN_BACK)
		if(4) // Fire Protection
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_R_HAND)
		if(5) // Cuppa Joe's Barista
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/cuppa_joes(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/apron/cuppa_joes(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(6) // Landing Pad Attendant Synth
			new_human.equip_to_slot_or_del(new /obj/item/clothing/ears/earmuffs(new_human), WEAR_R_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/yellow(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/stack/flag/red(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/lightstick/red(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
		if(7) // Bartender
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bowlerhat(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective/grey(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/tequila(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/cognac(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/grenadine(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/rum(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/beer_pack(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/baseballbat(new_human), WEAR_L_HAND)
		if(8) // Chef Synth
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/corporate_formal(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/sliceable/lemoncake(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/utensil/fork(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/chef(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife/butcher(new_human), WEAR_L_HAND)
	..()

// Engineer

/datum/equipment_preset/synth/survivor/hybrisa/engineer_survivor
	name = "Survivor - Hybrisa - Synthetic - Engineer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/hybrisa/engineer_survivor/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,5)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/engineering_utility_oversuit(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human.back), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/engineering_utility_oversuit/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human.back), WEAR_IN_BACK)
	..()

// Medical

/datum/equipment_preset/synth/survivor/hybrisa/paramedic
	name = "Survivor - Hybrisa - Synthetic - Emergency Medical Technician - Paramedic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/hybrisa/paramedic/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,25)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white, WEAR_FEET)

	switch(choice)
		if(1 to 9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_red_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic/red(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(10 to 19)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_green_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(20 to 24)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/medical_green(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(25)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/EMT_red_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/paramedic/red(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/medtech(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
	..()

// Security

/datum/equipment_preset/synth/survivor/hybrisa/detective
	name = "Survivor - Hybrisa - Synthetic - Detective"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/hybrisa/detective/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,2)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full/synth(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human.back), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/fedora/grey(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective/grey(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/WY/full/synth(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human.back), WEAR_IN_BACK)
	..()

// Corporate

/datum/equipment_preset/synth/survivor/hybrisa/exec_bodyguard
	name = "Survivor - Hybrisa - Synthetic - Executive Bodyguard"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/synth/survivor/hybrisa/exec_bodyguard/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,45)
	switch(choice)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
		if(10 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/jacket(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
		if(20 to 30)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue(new_human), WEAR_EYES)
		if(30 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/brown/jacket(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue(new_human), WEAR_EYES)
		if(40 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform/jacket_only(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	add_random_cl_survivor_loot(new_human)
	..()

// Science

/datum/equipment_preset/synth/survivor/hybrisa/xenoarchaeologist
	name = "Survivor - Hybrisa - Synthetic - Xenoarchaeologist"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/hybrisa/xenoarchaeologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,55)
	switch(random_gear)
		if(1 to 25)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
		if(25 to 35)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/synthbio/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/synth/wy_bio(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
		if(35 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/synthbio/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/synth/wy_bio(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
		if(50 to 55)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/synthbio/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/synth/wy_bio/alt(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
	..()
