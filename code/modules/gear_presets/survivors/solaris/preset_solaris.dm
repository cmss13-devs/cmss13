/datum/equipment_preset/survivor/trucker/solaris
	name = "Survivor - Solaris Heavy Vehicle Operator"
	assignment = "Solaris Heavy Vehicle Operator"
	skills = /datum/skills/civilian/survivor/trucker

/datum/equipment_preset/survivor/trucker/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls/red(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker/red(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(new_human), WEAR_EYES)
	..()

/datum/equipment_preset/survivor/colonial_marshal/solaris
	name = "Survivor - Solaris Colonial Marshal Deputy"
	assignment = "CMB Deputy"

/datum/equipment_preset/survivor/colonial_marshal/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/engineer/solaris
	name = "Survivor - Solaris Engineer"
	assignment = "Solaris Engineer"

/datum/equipment_preset/survivor/engineer/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	..()

/datum/equipment_preset/survivor/scientist/solaris
	name = "Survivor - Solaris Scientist"
	assignment = "Solaris Scientist"

/datum/equipment_preset/survivor/scientist/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/corporate_formal(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/doctor/solaris
	name = "Survivor - Solaris Doctor"
	assignment = "Solaris Doctor"

/datum/equipment_preset/survivor/doctor/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/lightblue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmo(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/chaplain/solaris
	name = "Survivor - Solaris Chaplain"
	assignment = "Solaris Chaplain"

/datum/equipment_preset/survivor/chaplain/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/holidaypriest(new_human), WEAR_JACKET)
	add_survivor_rare_item(new_human)
	..()

/datum/equipment_preset/survivor/security/solaris
	name = "Survivor - Solaris United Americas Peacekeepers"
	assignment = "United Americas Peacekeeper"
	minimap_icon = "peacekeeper"
	minimap_background = "background_ua"

/datum/equipment_preset/survivor/security/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/solaris_ridge/co_survivor
	name = "CO Survivor - Solaris Marshal"
	assignment = "CMB Marshal"
	job_title = JOB_CMB_TL
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	role_comm_title = "CMB MAR"
	paygrades = list(PAY_SHORT_CMBM = JOB_PLAYTIME_TIER_0)
	minimap_icon = "deputy"
	faction_group = list(FACTION_MARSHAL, FACTION_MARINE, FACTION_SURVIVOR)
	idtype = /obj/item/card/id/marshal
	skills = /datum/skills/cmb/co_survivor
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/solaris_ridge/co_survivor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/cmb/light(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb/tactical(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/cmb(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles/cmb_riot_shield(new_human), WEAR_IN_BACK)
	..()

/datum/equipment_preset/survivor/uscm/solaris
	name = "Survivor - Solaris United States Colonial Marine Corps Recruiter"
	assignment = "USCM Recruiter"
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	minimap_icon = "recruiter"
	minimap_background = "background_medical"
	skills = /datum/skills/civilian/survivor/uscm_recruiter

/datum/equipment_preset/survivor/uscm/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/ranks/marine/e5(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)
	..()

/datum/equipment_preset/survivor/corporate/solaris
	name = "Survivor - Solaris Corporate Liaison"
	assignment = "Solaris Corporate Liaison"

/datum/equipment_preset/survivor/corporate/solaris/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/ivy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	..()

// Synths

/datum/equipment_preset/synth/survivor/solaris
	flags = EQUIPMENT_PRESET_STUB

/datum/equipment_preset/synth/survivor/solaris/civilian
	name = "Survivor - Solaris - Synthetic - Civilian"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/synth/survivor/solaris/civilian/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,7)
	switch(choice)
		if(1) // Colony Supervision Synthetic
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headset(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_L_HAND)
		if(2) // Roughneck
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm/orange_line(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker/red(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/hardpoint/locomotion/van_wheels(new_human), WEAR_R_HAND)
		if(3) // Miner 1
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/neckerchief/gray(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_L_HAND)
		if(4) // Miner 2
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/utility_vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe/hammer(new_human), WEAR_L_HAND)
		if(5) // Miner 3
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/red(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls/tan(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_L_HAND)
		if(6) // Cargo Pilot
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headset(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wysquare(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_L_HAND)
		if(7) // Bartender
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/tie/black(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/whiskey(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/rum(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/fedora/grey(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/electronic_cigarette(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/baseballbat/metal(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/beer_pack(new_human), WEAR_R_HAND)
	..()

/datum/equipment_preset/synth/survivor/solaris/engineer
	name = "Survivor - Solaris - Synthetic - Engineer"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/synth/survivor/solaris/engineer/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,2)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)

	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_L_HAND)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/engineering_utility_oversuit(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	..()

/datum/equipment_preset/synth/survivor/solaris/medical
	name = "Survivor - Solaris - Synthetic - Medical"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/synth/survivor/solaris/medical/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,3)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/stethoscope(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)

	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/grey(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/grey(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
	..()

/datum/equipment_preset/synth/survivor/solaris/ua_peacekeeper
	name = "Survivor - Solaris - Synthetic - United Americas Peacekeepers"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	role_comm_title = "UA Syn"
	minimap_background = "background_ua"
	idtype = /obj/item/card/id/data

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/solaris/ua_peacekeeper/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot/synth(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full/synth, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_L_HAND)
	..()

/datum/equipment_preset/synth/survivor/solaris/uscm_recruiter
	name = "Survivor - Solaris - Synthetic - United States Colonial Marine Corps Recruiter"
	assignment = "USCM Recruitment Synthetic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	paygrades = list(PAY_SHORT_MWO = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/gold
	origin_override = ORIGIN_USCM

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/solaris/uscm_recruiter/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,5)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/bridge(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/uasquare(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/ranks/marine/wo(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_L_HAND)

	switch(choice)
		if(1 to 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service(new_human), WEAR_JACKET)
		if(3 to 4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown(new_human), WEAR_JACKET)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/synvest(new_human), WEAR_JACKET)
	..()

/datum/equipment_preset/synth/survivor/solaris/corporate
	name = "Survivor - Solaris - Synthetic - Corporate Assistant"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/cl
	role_comm_title = "WY Syn"

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/synth/survivor/solaris/corporate/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/field(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/grey(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/wy_cap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human), WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_L_HAND)
	..()
