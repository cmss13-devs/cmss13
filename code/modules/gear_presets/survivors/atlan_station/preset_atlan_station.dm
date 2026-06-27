// can't get CO surv (station administrator) and CEC Rep (corporate surv type) to work, this document will stay for future reference/use if I can figure it out or find someone else to do it or help me in great depth


/datum/equipment_preset/survivor/engineer/atlan_processing_engineer
	name = "Survivor - UPP - Ministry of Industry - Refinery Engineer"
	assignment = "Inzhener Neftepererabatyvayushchiy Zavod"
	minimap_icon = "upp_cont"
	minimap_background = "background_upp_bravo"
	faction_group = FACTION_LIST_SURVIVOR_UPP
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/atlan_processing_engineer/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)

	var/random_utility_jumpsuit= rand(1,2)
	switch(random_utility_jumpsuit)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray/upp(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)

	add_survivor_weapon_civilian(new_human)
	..()


/datum/equipment_preset/survivor/upp_atlan_miner
	name = "Survivor - UPP - Jutou Combine - Atmospheric Miner"
	assignment = "Jùtóu Combine - Atmosfernyy Shakhtyor"
	minimap_background = "background_upp_civilian"
	skills = /datum/skills/civilian/survivor/miner
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/upp_atlan_miner/load_gear(mob/living/carbon/human/new_human)

	var/random_hat = rand(1,2)
	switch(random_hat)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white/alt(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather, WEAR_FACE)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi5(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt, WEAR_ACCESSORY)
	add_survivor_rare_item(new_human)
	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/cec_liaison/atlan
	name = "Survivor - UPP - Cosmos Exploration Corps Liaison" //CEC Representative/Liaison, in exchange for no WY/Hyperdyne connections they get scientist skills
	assignment = "Svyaz' Korpusa Kosmicheskoy Eksploratsii"
	minimap_icon = "upp_sci"
	minimap_background = "background_hc_management"
	skills = /datum/skills/civilian/survivor/scientist
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/cec_liaison/atlan/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch(new_human), WEAR_ACCESSORY)

	var/random_trenchcoat = rand(1,2)
	switch(random_trenchcoat)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat/brown(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/trenchcoat/grey(new_human), WEAR_JACKET)

	var/random_scientist_satchel= rand(1,3)
	switch(random_scientist_satchel)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)

	var/random_scientist_glasses= rand(1,3)
	switch(random_scientist_glasses)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_FACE)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hippie(new_human), WEAR_FACE)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_FACE)

	var/random_professional_shoe = rand(1,3)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
	..()




//-------------------------------------------------------

//////////////// SYNTHETICS /////////////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/synth/survivor/atlan
	flags = EQUIPMENT_PRESET_STUB

// Civilian

/datum/equipment_preset/synth/survivor/atlan/civilian
	name = "Survivor - Atlan Station - Synthetic - Civilian"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/civilian/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,6)
	switch(choice)
		if(1) // Miner
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white/alt(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi5(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
		if(2) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/upp(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/cbrn_non_armored(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/cbrn_non_armored(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/mop(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
		if(3) // Fire Protection
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/firefighter(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light/upp/synth(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/attachable/attached_gun/extinguisher(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
		if(4) // Landing Pad Attendant Synth
			new_human.equip_to_slot_or_del(new /obj/item/clothing/ears/earmuffs(new_human), WEAR_R_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/stack/flag/red(new_human), WEAR_IN_BELT)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/lightstick/red(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/prop/tableflag/upp(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
		if(5) // Bartender
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka/civi(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/tan(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/bag/plasticbag(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/baseballbat/metal(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
		if(6) // Chef Synth
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/civi2(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic/stain(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/utensil/fork(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife/butcher(new_human), WEAR_L_HAND)
	..()

// Engineer

/datum/equipment_preset/synth/survivor/atlan/engineer
	name = "Survivor - Atlan Station - Synthetic - Reactor Plant Synthetic" // ENGINEER
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/engineer/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/short(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/maintenance_jack(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/white/alt(new_human), WEAR_BODY)

	..()

// Medical

/datum/equipment_preset/synth/survivor/atlan/doctor
	name = "Survivor - Atlan Station - Synthetic - Doctor"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/doctor/load_gear(mob/living/carbon/human/new_human)
	var/random_civilian_satchel= rand(1,3)
	switch(random_civilian_satchel)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)

	var/random_tie= rand(1,6)
	switch(random_tie)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/black(new_human), WEAR_ACCESSORY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie(new_human), WEAR_ACCESSORY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/green(new_human), WEAR_ACCESSORY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/purple(new_human), WEAR_ACCESSORY)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/red(new_human), WEAR_ACCESSORY)

	var/random_professional_shoe = rand(1,2)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)

	var/random_labcoat = rand(1,2)
	switch(random_labcoat)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/long(new_human), WEAR_JACKET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)

	var/random_professional_uniform= rand(1,3)
	switch(random_professional_uniform)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/civi/plant_worker(new_human), WEAR_HEAD)

	..()

// Security

/datum/equipment_preset/synth/survivor/atlan/security
	name = "Survivor - Atlan Station - Synthetic - Army or PaP" // Either Army Reservist or PaP (COP)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/security/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,2)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/army_beret(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/army/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/recon(new_human), WEAR_L_EAR)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PaP(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked/police(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/pap(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/black/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/alt(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/pap(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/UPP/full(new_human), WEAR_WAIST)

	..()

// Corporate

/datum/equipment_preset/synth/survivor/atlan/corporate
	name = "Survivor - Atlan Station - Synthetic - Hyperdyne - Executive Bodyguard"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction_group = FACTION_HYPERDYNE
	faction = FACTION_HYPERDYNE
	job_title = JOB_HC_SEC_SYNTH
	assignment = JOB_HC_SEC_SYNTH
	role_comm_title = "HC Sec Syn"
	faction_group = FACTION_LIST_SURVIVOR_HYPERDYNE
	idtype = /obj/item/card/id/silver/cl/hyperdyne
	survivor_variant = CORPORATE_SURVIVOR
	minimap_background = "background_hc_management"
	minimap_icon = "hc_synth"

/datum/equipment_preset/synth/survivor/atlan/corporate/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,2)
	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/hyperdyne(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective/neutral(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/black(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/hyperdyne_patch, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/combat(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/lawyer/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/hyperdyne(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective/grey(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/black(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/hyperdyne_patch, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/combat(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/lawyer/light_brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator/silver(new_human), WEAR_EYES)
	add_random_cl_survivor_loot(new_human)
	..()

// Science

/datum/equipment_preset/synth/survivor/atlan/scientist
	name = "Survivor - Atlan Station - Synthetic - Cosmos Exploration Corps Researcher"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	origin_override = ORIGIN_UPP

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/synth/survivor/atlan/scientist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown/upp(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/brown(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/shovel(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)

	..()




// CO SURV STATION ADMINISTRATOR

/datum/equipment_preset/survivor/atlan/co_survivor
	name = "CO Survivor - UPP - Orbital Station Administrator" // gets UPP UL4 officer jacket and UL8 ushanka, skills of an UPP commisar, cool UPP pistol
	assignment = "Menedzher Orbitalnoy Stantsii"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	role_comm_title = "UPP Menedzher"
	minimap_icon = "upp_plt"
	minimap_background = "background_upp"
	faction_group = FACTION_LIST_SURVIVOR_UPP
	faction = FACTION_UPP
	skills = /datum/skills/upp/commissar
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/atlan/co_survivor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/officer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	..()
