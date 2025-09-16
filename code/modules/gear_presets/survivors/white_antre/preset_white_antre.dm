//////////////////// CIVILIAN ///////////////////////
////////////////////////////////////////////////////

// Base Template

/datum/equipment_preset/survivor_antre
	name = JOB_SURVIVOR
	assignment = JOB_SURVIVOR
	job_title = JOB_SURVIVOR

	skills = /datum/skills/civilian/survivor
	languages = list(LANGUAGE_ENGLISH)
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/lanyard
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_SURVIVOR)
	origin_override = ORIGIN_CIVILIAN

	access = list(ACCESS_CIVILIAN_PUBLIC)

	minimap_icon = "surv"
	minimap_background = "background_civillian"

	var/survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor_antre/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(new_human)
	var/random_name = capitalize(pick(new_human.gender == MALE ? GLOB.first_names_male : GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(21,45)

/datum/equipment_preset/survivor_antre/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)

/datum/equipment_preset/survivor_antre/load_id(mob/living/carbon/human/new_human, client/mob_client)
	var/obj/item/clothing/under/uniform = new_human.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
	return ..()

// Civilian

/datum/equipment_preset/survivor_antre/civilian
	name = "Survivor - White Antre - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor_antre/civilian/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,8)
	switch(random_gear)
		if(1) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
		if(2) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
		if(3) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(4) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(5) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(6) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(7) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(8) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)

// Corporate Executive

/datum/equipment_preset/survivor_antre/corporate
	name = "Survivor - White Antre - Corporate Junior Director"
	assignment = "Corporate Junior Director"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	paygrades = list(PAY_SHORT_WYC3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_WYC4 = JOB_PLAYTIME_TIER_2)
	faction_group = FACTION_LIST_SURVIVOR_WY
	idtype = /obj/item/card/id/silver/clearance_badge/cl
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_COMMAND,ACCESS_WY_GENERAL,ACCESS_WY_COLONIAL,ACCESS_WY_EXEC,)

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor_antre/corporate/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,20)
	switch(choice)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/coffee(new_human), WEAR_L_HAND)
		if(10 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/wy_exec_suit_uniform(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/coffee(new_human), WEAR_L_HAND)
	add_random_cl_survivor_loot(new_human)
	..()


// Site Security

/datum/equipment_preset/survivor_antre/site_security
	name = "Survivor - White Antre - Site Security Guard"
	assignment = "White Antre - Site Security Guard"
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

/datum/equipment_preset/survivor_antre/site_security/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,30)
	switch(choice)
		if(1 to 30)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/wy_cap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/wy(new_human), WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/stack/medical/ointment(new_human), WEAR_IN_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack(new_human), WEAR_IN_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/stack/medical/splint(new_human), WEAR_IN_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/packet/tricordrazine(new_human), WEAR_IN_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/baton(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs(new_human.back), WEAR_IN_BACK)
	..()

//Scientist

/datum/equipment_preset/survivor_antre/scientist_xenobiologist
	name = "Survivor - White Antre - Xenobiologist"
	assignment = "Xenobiologist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor_antre/scientist_xenobiologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,20)
	switch(random_gear)
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(11 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
	add_random_survivor_research_gear(new_human)
	..()

// Medical

/datum/equipment_preset/survivor_antre/doctor
	name = "Survivor - White Antre - Medical Doctor"
	assignment = "Doctor"
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor_antre/doctor/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,45)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)

	switch(choice)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
		if(20 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
		if(35 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	add_random_survivor_medical_gear(new_human)
	..()

// Engineer

/datum/equipment_preset/survivor_antre/maint_engineer
	name = "Survivor - White Antre - Maintenance Engineer"
	assignment = "Electrical Engineer"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor_antre/maint_engineer/load_gear(mob/living/carbon/human/new_human)
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
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/dblue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/engineering_utility/alt(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/engineering_utility_oversuit/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)

	..()
