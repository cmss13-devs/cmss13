///////////////////////
///////HUMANS//////////
///////////////////////

/datum/equipment_preset/survivor/chaplain/trijent
	name = "Survivor - Trijent Chaplain"
	assignment = "Trijent Dam Chaplain"

/datum/equipment_preset/survivor/chaplain/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/nun(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/nun_hood(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/holidaypriest(new_human), WEAR_JACKET)
	add_survivor_rare_item(new_human)
	..()

/datum/equipment_preset/survivor/security/trijent
	name = "Survivor - Trijent Security Guard"
	assignment = JOB_WY_SEC
	job_title = JOB_WY_SEC
	minimap_background = "background_goon"
	minimap_icon = "cmp"
	faction = FACTION_WY
	idtype = /obj/item/card/id/silver/cl
	faction_group = list(FACTION_WY, FACTION_SURVIVOR)
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_WY_GENERAL, ACCESS_WY_COLONIAL, ACCESS_WY_MEDICAL, ACCESS_WY_ENGINEERING)

/datum/equipment_preset/survivor/security/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/sec(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/nspa/trijent
	name = "Survivor - Trijent NSPA Constable"
	assignment = "NSPA Constable"
	faction_group = FACTION_LIST_SURVIVOR_NSPA
	paygrades = list(PAY_SHORT_CST = JOB_PLAYTIME_TIER_0, PAY_SHORT_SC = JOB_PLAYTIME_TIER_3, PAY_SHORT_SGT = JOB_PLAYTIME_TIER_4)
	skills = /datum/skills/civilian/survivor/marshal
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/nspa_silver
	faction = FACTION_NSPA
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_RESEARCH,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)
	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/nspa/trijent/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,100)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue, WEAR_EYES)

	switch(choice)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
		if(20 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_formal_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
		if(40 to 75)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer/warm_weather, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/cmb(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/nspa_vest, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_BACK)
		if(75 to 80)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer/warm_weather, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/cmb(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_hazard_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
		if(80 to 95)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer/warm_weather, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/cmb(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap_goldandsilver, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/nspa_hazard, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
		if(95 to 100)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap_gold, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_formal_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
	..()

/datum/equipment_preset/survivor/doctor/trijent
	name = "Survivor - Trijent Doctor"
	assignment = "Trijent Dam Doctor"

/datum/equipment_preset/survivor/doctor/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/scientist/trijent
	name = "Survivor - Trijent Researcher"
	assignment = "Trijent Dam Researcher"

/datum/equipment_preset/survivor/scientist/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/rd(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/jan(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/trucker/trijent
	name = "Survivor - Trijent Heavy Vehicle Operator"
	assignment = "Trijent Dam Heavy Vehicle Operator"
	skills = /datum/skills/civilian/survivor/trucker

/datum/equipment_preset/survivor/trucker/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank(new_human), WEAR_IN_BACK)
	..()

/datum/equipment_preset/survivor/engineer/trijent/hydro
	name = "Survivor - Hydro Electric Engineer"
	assignment = "Hydro Electric Engineer"

/datum/equipment_preset/survivor/engineer/trijent/hydro/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(new_human), WEAR_HEAD)
	..()

/datum/equipment_preset/survivor/engineer/trijent
	name = "Survivor - Dam Maintenance Technician"
	assignment = "Dam Maintenance Technician"

/datum/equipment_preset/survivor/engineer/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/corporate/trijent
	name = "Survivor - Trijent Corporate Liaison"
	assignment = "Trijent Dam Corporate Liaison"

/datum/equipment_preset/survivor/corporate/trijent/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/ivy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	..()

///////////////////////
///////SYNTHETICS//////
///////////////////////

/datum/equipment_preset/synth/survivor/nspa_synth
	name = "Survivor - Synthetic - NSPA Investigative Synthetic"
	idtype = /obj/item/card/id/nspa_silver
	role_comm_title = "NSPA Syn"
	paygrades = list(PAY_SHORT_CST = JOB_PLAYTIME_TIER_0)
	faction = FACTION_NSPA
	faction_group = list(FACTION_NSPA, FACTION_SURVIVOR)
	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/synth/survivor/nspa_synth/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,100)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue, WEAR_EYES)

	switch(choice)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
		if(20 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_formal_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
		if(40 to 75)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer/warm_weather, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/cmb(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/nspa_hazard, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_BACK)
		if(75 to 80)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer/warm_weather, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/cmb(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_hazard_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
		if(80 to 95)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer/warm_weather, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/cmb(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap_goldandsilver, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/nspa_hazard, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
		if(95 to 100)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/nspa_officer, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/nspa_peaked_cap_gold, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/hybrisa/nspa_formal_jacket, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/full, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)

	..()
