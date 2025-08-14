

/*
Everything below isn't used or out of place.

*/


// ----- Prisoner Survivors
// Used in Fiorina Science Annex.
/datum/equipment_preset/survivor/prisoner
	name = "Survivor - Prisoner"
	assignment = "Prisoner"
	skills = /datum/skills/civilian/survivor/prisoner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/prisoner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/riot(new_human), WEAR_HEAD)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human.back), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)
	add_ice_colony_survivor_equipment(new_human)
	..()

// Used in Fiorina Science Annex.
/datum/equipment_preset/survivor/gangleader
	name = "Survivor - Gang Leader"
	assignment = "Gang Leader"
	skills = /datum/skills/civilian/survivor/gangleader
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/gangleader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(new_human), WEAR_BODY)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/riot(new_human), WEAR_HEAD)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human.back), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)
	add_ice_colony_survivor_equipment(new_human)
	..()

// ----- Civilian Survivor

// Used in LV-624, Solaris Ridge, Trijent Dam, Fiorina Science Annex and Kutjevo Refinery.
/datum/equipment_preset/survivor/civilian
	name = "Survivor - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/civilian/load_gear(mob/living/carbon/human/new_human)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)

	var/random_civilian_backpack= rand(1,11)
	switch(random_civilian_backpack)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm/blue(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm/red_line(new_human), WEAR_BACK)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm/orange_line(new_human), WEAR_BACK)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm/green(new_human), WEAR_BACK)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
		if(9)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
		if(10)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
		if(11)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)

	var/obj/item/clothing/suit/storage/jacket_to_equip
	var/random_civilian_jacket = rand(1, 13)

	switch(random_civilian_jacket)
		if(1)
			jacket_to_equip = new /obj/item/clothing/suit/storage/webbing(new_human)
		if(2)
			jacket_to_equip = new /obj/item/clothing/suit/storage/jacket/marine/vest/tan(new_human)
		if(3)
			jacket_to_equip = new /obj/item/clothing/suit/storage/jacket/marine/vest(new_human)
		if(4)
			jacket_to_equip = new /obj/item/clothing/suit/storage/jacket/marine/vest/grey(new_human)
		if(5)
			jacket_to_equip = new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human)
		if(6)
			jacket_to_equip = new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human)
		if(7)
			jacket_to_equip = new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human)
		if(8)
			jacket_to_equip = new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_brown(new_human)
		if(9)
			jacket_to_equip = new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_blue(new_human)
		if(10)
			jacket_to_equip = new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_red(new_human)
		if(11)
			jacket_to_equip = new /obj/item/clothing/suit/storage/apron/overalls(new_human)
		if(12)
			jacket_to_equip = new /obj/item/clothing/suit/storage/apron/overalls/red(new_human)
		if(13)
			jacket_to_equip = new /obj/item/clothing/suit/storage/apron/overalls/tan(new_human)

	if(jacket_to_equip)
		if(prob(55))
			qdel(jacket_to_equip)
		else
			new_human.equip_to_slot_or_del(jacket_to_equip, WEAR_JACKET)

	var/random_civilian_uniform = rand(1,24)
	switch(random_civilian_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/white(new_human), WEAR_BODY)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(new_human), WEAR_BODY)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/darkred(new_human), WEAR_BODY)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(new_human), WEAR_BODY)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightred(new_human), WEAR_BODY)
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
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility(new_human), WEAR_BODY)
		if(10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/blue(new_human), WEAR_BODY)
		if(11)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown(new_human), WEAR_BODY)
		if(12)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
		if(13)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/red(new_human), WEAR_BODY)
		if(14)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/yellow(new_human), WEAR_BODY)
		if(15)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
		if(16)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
		if(17)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/blue(new_human), WEAR_BODY)
		if(18)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
		if(19)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
		if(20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
		if(21)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/orange(new_human), WEAR_BODY)
		if(22)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu(new_human), WEAR_BODY)
		if(23)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/r_bla(new_human), WEAR_BODY)
		if(24)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/w_br(new_human), WEAR_BODY)

	var/random_civilian_shoe = rand(1,11)
	switch(random_civilian_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/yellow(new_human), WEAR_FEET)
		if(7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
		if(8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
		if(9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(new_human), WEAR_FEET)
		if(10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
		if(11)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)

	add_survivor_rare_item(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/civilian_unique
	name = "Survivor - Civilian Unique"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/civilian_unique/load_gear(mob/living/carbon/human/new_human)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)

	var/random_gear = rand(0, 17)
	switch(random_gear)
		if(0) // Sleepy Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pj/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/slippers(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/roller/bedroll/comfy(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/bedsheet/bedroll/blue(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pj/red(new_human.back), WEAR_IN_BACK)
		if(1) // Bug Exterminator Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/cbrn_non_armored(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/bugkiller(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
		if(2) // Janitor
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/vir(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/purple(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/purple(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/galoshes(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/metal_foam(new_human.back), WEAR_IN_BACK)
		if(3) // Bar Tender
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/waiter(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bowlerhat(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/paper_bin(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/whiskey(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(new_human.back), WEAR_IN_BACK)
		if(4) // Botanist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/hyd(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/hatchet(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade(new_human.back), WEAR_IN_BACK)
		if(5) // Butcher
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmbandana/tan(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/chef(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic/stain(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife/butcher(new_human.back), WEAR_IN_BACK)
		if(6) // Ripley outfit from Aliens
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/stompers(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank/survivor(new_human.back), WEAR_IN_BACK)
		if(7) // Escaped Colony Prisoner
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/escaped_prisoner_colony(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/double/sawn(new_human.back), WEAR_L_HAND)
		if(8) // Stowaway
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hippie(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/stowaway(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/briefcase/stowaway(new_human.back), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000/counterfeit(new_human.back), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/small/black(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/small(new_human.back), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/small(new_human.back), WEAR_IN_R_STORE)
		if(9) // Private Detective
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/tan(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human.back), WEAR_IN_BACK)
		if(10) // Landing Pad Attendant
			new_human.equip_to_slot_or_del(new /obj/item/clothing/ears/earmuffs(new_human), WEAR_R_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/yellow(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/stack/flag/red(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
		if(11) // High roller
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cowboy(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big/fake/yellow(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/cohiba(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/checkered(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/lawyer/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather/fancy(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo/gold(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/toy/deck(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/toy/dice(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigar/tarbacktube(new_human), WEAR_IN_R_STORE)
		if(12) // Prepper
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/foil(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/civilian_vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/steward(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/tech(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/wy(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/wy(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/waterbottle(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/waterbottle(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/food/upp/soup(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/food/upp/stew(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/canteen(new_human), WEAR_IN_R_STORE)
		if(13) // Mad Scientist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/kutjevo(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm/green(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/green(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/green(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/pamphlet/skill/science(new_human.back), WEAR_IN_BACK)
		if(14) // Cameraman
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/reporter(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/broadcasting(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera/oldcamera(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera_film(new_human), WEAR_IN_R_STORE)
		if(15) // Pro Welder
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding/painted(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/support(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/utility_vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/pamphlet/skill/engineer(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/weldpack(new_human.back), WEAR_R_HAND)
		if(16) // Farmer
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm/orange_line(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/straw(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/tool/minihoe(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/grown/wheat(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/grown/wheat(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/grown/wheat(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/tool/scythe(new_human.back), WEAR_R_HAND)
		if(17) // Fisherman
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator/silver(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/boonie/fisherman(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls/tan(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/fish_bait(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/fish_bait(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/fish_bait(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/fishing_pole(new_human), WEAR_R_HAND)
	add_survivor_rare_item(new_human)
	add_survivor_weapon_civilian(new_human)

	..()

// --- Salesman Survivor

// after double check salesman isn't being used anywhere.
/datum/equipment_preset/survivor/salesman
	name = "Survivor - Salesman"
	assignment = "Salesman"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/data
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/salesman/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/document(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	add_random_cl_survivor_loot(new_human)
	add_survivor_weapon_civilian(new_human)
	add_ice_colony_survivor_equipment(new_human)
	..()


// ----- Roughneck Survivor

// Used in Trijent Dam.
/datum/equipment_preset/survivor/roughneck
	name = "Survivor - Roughneck"
	assignment = "Roughneck"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/roughneck/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large(new_human), WEAR_R_STORE)
	add_merc_survivor_weapon(new_human)
	add_ice_colony_survivor_equipment(new_human)
	..()

// ----- Bum Survivor

// Used in New Varadero.
/datum/equipment_preset/survivor/beachbum
	name = "Survivor - Beach Bum"
	assignment = "Beach Bum"
	skills = /datum/skills/civilian/survivor/prisoner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/beachbum/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/shorts/red(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/weed(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/boonie(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/beer_pack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife/butcher(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/wypacket(new_human.back), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)
	add_ice_colony_survivor_equipment(new_human)
	..()

// ----- WY Survivors

// Used in LV-624.
/datum/equipment_preset/survivor/goon
	name = "Survivor - Corporate Security Goon"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_WY_GOON
	job_title = JOB_WY_GOON
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/silver/cl
	skills = /datum/skills/civilian/survivor/goon
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_PMC)
	origin_override = ORIGIN_WY_SEC
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_BRIG, ACCESS_WY_COLONIAL)
	minimap_icon = "goon_standard"
	minimap_background = "background_goon"

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/goon/load_vanity(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/goon/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/black, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate/no_lock, WEAR_J_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)


// ----- Mercenary Survivors

// after double check pmc/miner isn't being used anywhere.
/datum/equipment_preset/survivor/pmc/miner
	name = "Survivor - Mercenary"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	assignment = "Mercenary"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/pmc/miner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	add_merc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)


// after double check pmc/freelancer isn't being used anywhere.
/datum/equipment_preset/survivor/pmc/freelancer
	name = "Survivor - Freelancer"
	assignment = "Freelancer"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/pmc/freelancer/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	spawn_merc_helmet(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	add_merc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)

// New Varadero CO Survivor.
/datum/equipment_preset/survivor/new_varadero/commander
	name = "Survivor - LACN Commander"
	assignment = "LACN Commander"
	skills = /datum/skills/commander
	paygrades = list(PAY_SHORT_NO5 = JOB_PLAYTIME_TIER_0)
	minimap_icon = "xo"
	minimap_background = "background_shipside"
	idtype = /obj/item/card/id/gold
	role_comm_title = "LACN CDR"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/new_varadero/commander/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)

	var/obj/item/clothing/suit/storage/jacket/marine/service/suit = new()
	suit.icon_state = "[suit.initial_icon_state]_o"
	suit.buttoned = FALSE

	var/obj/item/clothing/accessory/ranks/navy/o5/pin = new()
	suit.attach_accessory(new_human, pin)

	new_human.equip_to_slot_or_del(suit, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)

	..()

// ----- Hostile Survivors

/// used in Shivas Snowball

/datum/equipment_preset/survivor/clf/cold
	name = "CLF Survivor (Cold)"

//children of spawn rebel shoes proc
/datum/equipment_preset/survivor/clf/cold/spawn_rebel_suit(mob/living/carbon/human/human)
	if(!istype(human))
		return
	var/suitpath = pick(
		/obj/item/clothing/suit/storage/militia,
		/obj/item/clothing/suit/storage/militia/vest,
		/obj/item/clothing/suit/storage/militia/brace,
		/obj/item/clothing/suit/storage/militia/partial,
		)
	human.equip_to_slot_or_del(new suitpath, WEAR_JACKET)

//children of spawn rebel helmet proc
/datum/equipment_preset/survivor/clf/cold/spawn_rebel_helmet(mob/living/carbon/human/human)
	if(!istype(human))
		return
	var/helmetpath = pick(
		/obj/item/clothing/head/militia,
		/obj/item/clothing/head/militia/bucket,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/head/helmet/skullcap,
		/obj/item/clothing/head/helmet/swat,
		)
	human.equip_to_slot_or_del(new helmetpath, WEAR_HEAD)

//children of spawn rebel shoes proc
/datum/equipment_preset/survivor/clf/cold/spawn_rebel_shoes(mob/living/carbon/human/human)
	if(!istype(human))
		return
	var/shoespath = /obj/item/clothing/shoes/combat
	human.equip_to_slot_or_del(new shoespath, WEAR_FEET)
