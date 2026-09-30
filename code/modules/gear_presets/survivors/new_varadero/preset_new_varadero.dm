/datum/equipment_preset/survivor/new_varadero
	job_title = JOB_SURVIVOR
	faction = FACTION_LACN
	faction_group = FACTION_LIST_SURVIVOR_LACN
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_SPANISH)

/datum/equipment_preset/survivor/new_varadero/load_gear(mob/living/carbon/human/new_human)
	add_random_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/urban/knife(new_human), WEAR_FEET)

/datum/equipment_preset/survivor/new_varadero/add_survivor_weapon_security(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/new_varadero/proc/add_lacn_weapon(mob/living/carbon/human/new_human)
	var/random_gun = rand(1,6)
	switch(random_gun)
		if(1 , 2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m20a(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m20a(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m20a(new_human), WEAR_IN_BACK)
		if(3 to 5)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/l42a(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/l42a/heap/empty(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/l42a(new_human), WEAR_IN_BACK)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)


//////////////// Latin American Colonial Navy /////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/lacn_police
	name = "Survivor -  New Varadero - LACN Army Policia"
	assignment = JOB_LACN_POLICE
	role_comm_title = "LACN MP"
	minimap_icon = "mp"
	minimap_background = "background_wo" // placeholder
	origin_override = ORIGIN_USCM
	skills = /datum/skills/lacn/MP
	paygrades = list(PAY_SHORT_NE6 = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_RESEARCH,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/lacn_police/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,3)
	var/obj/item/clothing/under/marine/lacn/police = new()
	var/obj/item/clothing/accessory/ranks/navy/e6/pin = new()
	var/obj/item/clothing/accessory/armband/mp = new()
	police.attach_accessory(new_human,pin)
	police.attach_accessory(new_human,mp)
	new_human.equip_to_slot_or_del(police, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown/lacn(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(new_human), WEAR_WAIST)
	add_lacn_weapon(new_human)

	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn/socap(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/mp/mpcap(new_human), WEAR_HEAD)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn/boonie(new_human), WEAR_HEAD)
	..()

/datum/equipment_preset/survivor/new_varadero/lacn_marine
	name = "Survivor - New Varadero - LACN Fusilier"
	assignment = JOB_LACN_MARINE
	role_comm_title = "LACN Fus"
	minimap_icon = "private"
	origin_override = ORIGIN_USCM
	skills = /datum/skills/lacn/standard
	paygrades = list(PAY_SHORT_NE2 = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/lacn_marine/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,4)

	var/obj/item/clothing/under/marine/lacn/uniform = new()
	var/obj/item/clothing/accessory/patch/ua = new()
	uniform.attach_accessory(new_human,ua)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown/lacn(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)

	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/lacn(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/gray(new_human), WEAR_HEAD)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn/boonie(new_human), WEAR_HEAD)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn(new_human), WEAR_HEAD)
	add_lacn_weapon(new_human)
	..()


// New Varadero CO Survivor.
/datum/equipment_preset/survivor/new_varadero/commander
	name = "Survivor - LACN Commander"
	assignment = "LACN Commander"
	job_title  = JOB_LACN_COMMANDER
	role_comm_title = "LACN CDR"
	minimap_icon = "xo"
	minimap_background = "background_wo" // placeholder
	origin_override = ORIGIN_USCM
	skills = /datum/skills/commander
	paygrades = list(PAY_SHORT_LACNO5 = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/gold
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_RESEARCH,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)

/datum/equipment_preset/survivor/new_varadero/commander/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/co(new_human), WEAR_BODY)
	var/obj/item/clothing/suit/storage/jacket/marine/lacn/bridgecoat = new()
	var/obj/item/clothing/accessory/ranks/navy/o5/pin = new()
	var/obj/item/clothing/accessory/patch/ua = new()
	bridgecoat.attach_accessory(new_human,pin)
	bridgecoat.attach_accessory(new_human,ua)
	new_human.equip_to_slot_or_del(bridgecoat, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/multicolor/fountain(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911/custom(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn/copeaked(new_human), WEAR_HEAD)

	..()

//////////////// MEDICAL SURVIVORS /////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/doctor
	name = "Survivor - New Varadero - LACN Medical Technician"
	assignment = "LACN Medical Technician"
	job_title  = JOB_LACN_DOCTOR
	role_comm_title = "LACN MEDTECH"
	minimap_icon = "field_doctor"
	minimap_background = "background_wo" // placeholder
	origin_override = ORIGIN_USCM
	paygrades = list(PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE5 = JOB_PLAYTIME_TIER_3)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	skills = /datum/skills/civilian/survivor/doctor
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/doctor/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,45)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/medic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn(new_human), WEAR_HEAD)

	switch(choice)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest(new_human), WEAR_JACKET)
		if(21 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr(new_human), WEAR_JACKET)
		if(41 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/medical_red(new_human), WEAR_JACKET)

	add_random_survivor_medical_gear(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/firefighter
	name = "Survivor - New Varadero - LACN Airport Firefighter (Doctor)"
	assignment = "LACN Aviation Rescue & Fire Protection Specialist" //combo of regional names for the role
	job_title  = JOB_LACN_FIREFIGHTER
	role_comm_title = "LACN ARFPS"
	minimap_icon = "nurse"
	minimap_background = "background_wo" // placeholder
	origin_override = ORIGIN_USCM
	paygrades = list(PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE5 = JOB_PLAYTIME_TIER_3)
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/firefighter/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,45)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/medic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/fire_light(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human.back), WEAR_IN_BACK)

	switch(choice)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/firefighter(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
		if(21 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
		if(41 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/mod88(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88/penetrating(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88/penetrating(new_human), WEAR_IN_ACCESSORY)

	add_random_survivor_medical_gear(new_human)
	add_lacn_weapon(new_human)
	..()

//////////////// ENGINEER SURVIVORS /////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/vhccrew
	name = "Survivor - New Varadero - LACN Vehicle Crew"
	assignment = "LACN Vehicle Crewman"
	job_title  = JOB_LACN_TANK
	paygrades = list(PAY_SHORT_NE3 = JOB_PLAYTIME_TIER_0)
	minimap_icon = "vc"
	role_comm_title = "LACN VC"
	origin_override = ORIGIN_USCM
	skills = /datum/skills/lacn/vhccrew
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/vhccrew/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,3)

	var/obj/item/clothing/under/marine/lacn/uniform = new()
	var/obj/item/clothing/accessory/ranks/navy/e3/pin = new()
	var/obj/item/clothing/accessory/patch/ua = new()
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,ua)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/hardpoint/locomotion/van_wheels(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)

	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown/lacn(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/lacn(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/lacn/flight(new_human), WEAR_JACKET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)

	add_random_survivor_medical_gear(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/groundcrew
	name = "Survivor - New Varadero - LACN Ground Crew"
	assignment = "LACN Aviation Ground Crewman"
	job_title = JOB_LACN_GROUND
	role_comm_title = "LACN GCM" // GC = groupchat. Done to at least make it somewhat distinct
	minimap_icon = "engi"
	minimap_background = "background_wo" // placeholder
	origin_override = ORIGIN_USCM
	skills = /datum/skills/lacn/groundcrew
	paygrades = list(PAY_SHORT_NE3 = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/groundcrew/load_gear(mob/living/carbon/human/new_human)
	var/choice = rand(1,6)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/lacn/flight(new_human), WEAR_JACKET)

	switch(choice)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/engi(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/lacn/utility(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/engi/alt(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/req(new_human), WEAR_BODY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/lacn/utility(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/engi(new_human), WEAR_BODY)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/req(new_human), WEAR_BODY)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/engi/alt(new_human), WEAR_BODY)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/pilot
	name = "Survivor - New Varadero - LACN Pilot"
	assignment = JOB_LACN_PILOT
	role_comm_title = "LACN PO"
	minimap_icon = "wy_pilot"
	minimap_background = "background_wo" // placeholder
	origin_override = ORIGIN_USCM
	skills = /datum/skills/lacn/pilot
	paygrades = list(PAY_SHORT_NO1 = JOB_PLAYTIME_TIER_0,)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/pilot/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/pilot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/lacn/utility(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/lacn/flight(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_IN_BACK)

	add_lacn_weapon(new_human)
	..()

//////////////// THETA RESEARCH //////////////////
//////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/scientist
	name = "Survivor - New Varadero - Researcher"
	assignment = "New Varadero Researcher"
	role_comm_title = "WY RSR"
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	minimap_icon = "researcher"
	minimap_background = "background_pmc"
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_LACN)
	skills = /datum/skills/civilian/survivor/scientist
	origin_override = ORIGIN_CIVILIAN
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/scientist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,3)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)

	switch(random_gear)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/utility_vest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/long(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(new_human), WEAR_FACE)
	add_random_survivor_research_gear(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/scientist_xenobiologist
	name = "Survivor - New Varadero - Xenobiologist"
	assignment = "New Varadero Xenobiologist"
	role_comm_title = "WY XBIO"
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	minimap_icon = "goon_sci"
	minimap_background = "background_pmc"
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_LACN)
	skills = /datum/skills/civilian/survivor/scientist
	origin_override = ORIGIN_CIVILIAN
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/scientist_xenobiologist/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,50)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)

	switch(random_gear)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
		if(21 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/short(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(46 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/pilot(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(new_human), WEAR_FACE)

	add_lacn_weapon(new_human)
	add_random_survivor_research_gear(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/rd
	name = "Survivor - New Varadero - Research Director"
	assignment = "New Varadero Research Director"
	role_comm_title = "WY RD"
	minimap_icon = "goon_sci_lead"
	minimap_background = "background_pmc"
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_LACN)
	paygrades = list(PAY_SHORT_CCMOC = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/scientist
	origin_override = ORIGIN_CIVILIAN
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)

	survivor_variant = CORPORATE_SURVIVOR //Under corpo so corpo surv mains have an option for a role with WY background

/datum/equipment_preset/survivor/new_varadero/rd/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/rd(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm/tan(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)

	add_random_cl_survivor_loot(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/labass
	name = "Survivor - New Varadero - Lab Assistant"
	assignment = "New Varadero Lab Assistant"
	role_comm_title = "WY RSR AST"
	minimap_icon = "chemist_wo"
	minimap_background = "background_pmc"
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_LACN)
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	skills = /datum/skills/civilian/survivor
	origin_override = ORIGIN_CIVILIAN

	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH,)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/labass/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/pamphlet/upgradeable/science(new_human.back), WEAR_IN_BACK)
	add_survivor_rare_item(new_human)
	add_lacn_weapon(new_human)
	..()

//////////////// CIVILIAN/CORPORATE SURVIVORS /////////////////
//////////////////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/assrep
	name = "Survivor - New Varadero - UA Assistant Representative"
	assignment = "UA Assistant Representative"
	role_comm_title = "UA AST REP"
	minimap_icon = "recruiter"
	minimap_background = "background_ua"
	origin_override = ORIGIN_USCM
	paygrades = list(PAY_SHORT_CREP = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,ACCESS_MARINE_COMMAND, ACCESS_MARINE_GENERAL, ACCESS_MARINE_MEDBAY)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/assrep/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR) // placeholder TODO: give "UA comms"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)

	add_random_cl_survivor_loot(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/chaplain
	name = "Survivor - New Varadero Priest"
	assignment = "Base Chaplain"
	minimap_icon = "engi"
	minimap_background = "background_wo"
	paygrades = list(PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "LACN Chap"
	skills = /datum/skills/civilian/survivor/chaplain
	origin_override = ORIGIN_USCM
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,ACCESS_MARINE_COMMAND, ACCESS_MARINE_GENERAL, ACCESS_MARINE_MEDBAY)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/chaplain/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/lacn/uniform = new()
	var/obj/item/clothing/accessory/ranks/navy/e4/pin = new()
	var/obj/item/clothing/accessory/patch/ua = new()
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,ua)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/priest_robe(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/bible/booze(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general(new_human), WEAR_R_STORE)
	add_survivor_rare_item(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/miner
	name = "Survivor - New Varadero - Miner"
	assignment = "UA Mining Contractor"
	skills = /datum/skills/civilian/survivor/miner
	origin_override = ORIGIN_CIVILIAN
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/datum/equipment_preset/survivor/new_varadero/miner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/brown(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	add_survivor_rare_item(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/civilian
	name = "Survivor - New Varadero - Civilian"
	assignment = "UA Civil Contractor"
	skills = /datum/skills/civilian/survivor
	origin_override = ORIGIN_CIVILIAN
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/new_varadero/civilian/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	var/random_gear = rand(0, 7)
	switch(random_gear)
		if(0) //generic contractor
			new_human.equip_to_slot_or_del(new /obj/item/clothing/ears/earmuffs(new_human), WEAR_R_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE) //close enough to a dust mask
		if(1) //sanitation contractor
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/metal_foam(new_human.back), WEAR_IN_BACK)
		if(2) //Occupational Health Safety and Wellbeing Professional contractor
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/ears/earmuffs(new_human), WEAR_R_EAR)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/molle/lacn(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(3) //Defense Consultant contractor
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
		if(4) //Records Archivist contractor
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
		if(5) //Information Technology Specialist contractor
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/tan(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/stompers(new_human), WEAR_FEET)
		if(6) //Photographier
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/reporter(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(7) //journo
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/reporter(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/device/broadcasting(new_human), WEAR_R_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera/oldcamera(new_human), WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/camera_film(new_human), WEAR_IN_R_STORE)

	add_survivor_rare_item(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/beachbum //This role doesnt make much sense here, but too iconic to remove or chunk into a contractor var soooo pretend its a REALLY lazy private contracter or something ig
	name = "Survivor - New Varadero - Beach Bum"
	assignment = "Beach Bum"
	skills = /datum/skills/civilian/survivor/prisoner
	origin_override = ORIGIN_CIVILIAN
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/new_varadero/beachbum/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/shorts/red(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/weed(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/lacn/boonie(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/beer_pack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife/butcher(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/wypacket(new_human.back), WEAR_IN_BACK)
	add_lacn_weapon(new_human)
	add_ice_colony_survivor_equipment(new_human)
	..()


/////////////////// SYNTHETIC SURVIVORS ///////////////////////
//////////////////////////////////////////////////////////////

/datum/equipment_preset/synth/survivor/new_varadero
	flags = EQUIPMENT_PRESET_STUB

/datum/equipment_preset/synth/survivor/new_varadero/lacnsyn
	name = "Survivor - New Varadero Base Synthetic"
	assignment = JOB_LACN_SYN
	role_comm_title = "LACN Syn"
	minimap_icon = "synth"
	minimap_background = "background_wo"
	faction = FACTION_LACN
	faction_group = FACTION_LIST_SURVIVOR_LACN
	languages = ALL_SYNTH_LANGUAGES
	idtype = /obj/item/card/id/gold
	origin_override = ORIGIN_USCM
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/synth/survivor/new_varadero/lacnsyn/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof/survivor_lacn(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/synthetic/lacn/synth(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing/brown/lacn(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/big(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/synth/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic(new_human), WEAR_IN_BACK)
	add_random_survivor_medical_gear(new_human)
	..()
