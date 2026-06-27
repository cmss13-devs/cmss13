/datum/equipment_preset/survivor/new_varadero
	faction = FACTION_MARINE
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_SPANISH)
	minimap_background = "background_medical_WO" // placeholder
	flags = EQUIPMENT_PRESET_START_OF_ROUND


/datum/equipment_preset/survivor/new_varadero/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/grey/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)

/datum/equipment_preset/survivor/new_varadero/add_survivor_weapon_security(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/new_varadero/proc/add_lacn_weapon(mob/living/carbon/human/new_human)
	var/random_gun = rand(1,6)
	switch(random_gun)
		if(1 to 2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BACK)
		if(3 to 4)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/l42a(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/l42a/heap/empty(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/l42a(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/l42a(new_human), WEAR_IN_BACK)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/heap/empty(new_human), WEAR_IN_BACK) // high ammo cap per mag so only gets fluff magazine as extra
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/heap/empty(new_human), WEAR_IN_BACK)
		if(6)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)


//////////////// Latin American Colonial Navy /////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/lacn_police
	name = "Survivor - LACN Army Polícia"
	assignment = JOB_LACN_POLICE
	job_title = JOB_LACN_POLICE
	role_comm_title = "LACN MP"
	minimap_icon = "mp"
	skills = /datum/skills/military/survivor/lacn_MP
	paygrades = list(PAY_SHORT_NE6 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_RESEARCH,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/lacn_police/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/lacn/uniform = new()
	var/obj/item/clothing/accessory/ranks/navy/e6/pin = new()
	uniform.attach_accessory(new_human,pin)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/MP(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/mp(new_human), WEAR_JACKET)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/lacn_marine
	name = "Survivor - LACN Fusilier"
	assignment = JOB_LACN_MARINE
	job_title  = JOB_LACN_MARINE
	role_comm_title = "LACN FUS"
	minimap_icon = "private"
	skills = /datum/skills/military/survivor/lacn_standard
	paygrades = list(PAY_SHORT_NE2 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/lacn_marine/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/lacn/uniform = new()
	var/obj/item/clothing/accessory/ranks/navy/e2/pin = new()
	uniform.attach_accessory(new_human,pin)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/tech/LACN(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/green(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	add_lacn_weapon(new_human)
	..()

//////////////// MEDICAL SURVIVORS /////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/doctor
	name = "Survivor - New Varadero Medical Technician"
	assignment = "LACN Medical Technician"
	job_title  = JOB_LACN_MEDIC
	role_comm_title = "LACN MEDTECH"
	minimap_icon = "field_doctor"
	paygrades = list(PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE5 = JOB_PLAYTIME_TIER_3)
	skills = /datum/skills/civilian/survivor/doctor
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/doctor/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,45)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)

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
	add_lacn_weapon(new_human)
	..()

//////////////// ENGINEER SURVIVORS /////////////////
////////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/vhccrew
	name = "Survivor - New Varadero Vehicle Crew"
	assignment = "LACN Vehicle Crewman"
	job_title = JOB_TANK_CREW
	paygrades = list(PAY_SHORT_NE3 = JOB_PLAYTIME_TIER_0)
	minimap_icon = "vc"
	role_comm_title = "LACN VC"
	skills = /datum/skills/military/survivor/lacn_vhccrew
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/vhclcrew/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/lacn/uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech/tanker(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/tech/LACN(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/green(new_human), WEAR_JACKET)
	add_random_survivor_medical_gear(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/cargotech
	name = "Survivor - New Varadero Cargo Technician"
	assignment = "LACN Cargo Technician"
	job_title = JOB_CARGO_TECH
	role_comm_title = "LACN CT"
	paygrades = list(PAY_SHORT_NE2 = JOB_PLAYTIME_TIER_0)
	minimap_icon = "cargo"
	skills = /datum/skills/military/survivor/lacn_vhccrew
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/cargotech/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/rank/utility/brown = new()
	var/obj/item/clothing/accessory/ranks/navy/e4/pin = new()
	uniform.attach_accessory(new_human,pin)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/tan(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/tech/LACN(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
	add_random_survivor_medical_gear(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/groundcrew
	name = "Survivor - New Varadero Ground Crew"
	assignment = "LACN Aviation Ground Crewmen"
	job_title  = JOB_LACN_GROUND
	role_comm_title = "LACN AGC"
	minimap_icon = "dcc"
	skills = /datum/skills/military/survivor/lacn_groundcrew
	paygrades = list(PAY_SHORT_NE3 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/groundcrew/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/lacn/uniform = new()
	var/obj/item/clothing/accessory/ranks/navy/e4/pin = new()
	uniform.attach_accessory(new_human,pin)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headset(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/blue(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/tech/LACN(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_IN_BACK)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/pilot
	name = "Survivor - New Varadero Pilot"
	assignment = JOB_LACN_PILOT
	job_title  = JOB_LACN_PILOT
	role_comm_title = "LACN PO"
	minimap_icon = "wy_pilot"
	skills = /datum/skills/military/survivor/lacn_pilot
	paygrades = list(PAY_SHORT_NO1 = JOB_PLAYTIME_TIER_0,)
	idtype = /obj/item/card/id/dogtag
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS,ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/lacn_pilot/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/officer/pilot/flight = new()
	var/obj/item/clothing/accessory/ranks/navy/o1/pin = new()
	uniform.attach_accessory(new_human,pin)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/pilot(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/pilot(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/welding(new_human), WEAR_IN_BACK)
	add_lacn_weapon(new_human)
	..()

//////////////// THETA RESEARCH /////////////////
/////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/scientist
	name = "Survivor - WY New Varadero Researcher"
	assignment = "New Varadero Researcher"
	job_title  = JOB_LACN_PILOT
	role_comm_title = "WY RSR"
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	minimap_icon = "researcher"
	minimap_background = "background_pmc"
	skills = /datum/skills/civilian/survivor/scientist
	idtype = /obj/item/card/id/silver
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/scientist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/utility_vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/chem(new_human), WEAR_BACK)
	add_random_survivor_research_gear(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/scientist_xenoarchaeologist
	name = "Survivor - WY New Varadero Xenoarchaeologist"
	assignment = "New Varadero Xenoarchaeologist"
	role_comm_title = "WY XARC"
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	minimap_icon = "goon_sci"
	minimap_background = "background_pmc"
	skills = /datum/skills/civilian/survivor/scientist
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,55)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)

	switch(random_gear)
		if(1 to 25)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
		if(25 to 35)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/wy_bio/alt(new_human), WEAR_HEAD)
		if(35 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/wy_bio/alt(new_human), WEAR_HEAD)
		if(50 to 55)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/cbrn(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headband/tan(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/survivor(new_human), WEAR_R_HAND)
	add_lacn_weapon(new_human)
	add_random_survivor_research_gear(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/scientist_xenobiologist
	name = "Survivor - WY New Varadero Xenobiologist"
	assignment = "New Varadero Xenobiologist"
	role_comm_title = "WY XBIO"
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	minimap_icon = "goon_sci"
	minimap_background = "background_pmc"
	skills = /datum/skills/civilian/survivor/scientist
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/scientist_xenobiologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,50)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(new_human), WEAR_BODY)

	switch(random_gear)
		if(1 to 20))
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
		if(20 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
		if(45 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/pilot(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/cbrn(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(new_human), WEAR_FACE)
	add_lacn_weapon(new_human)
	add_random_survivor_research_gear(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/rd
	name = "Survivor - WY New Varadero RD"
	assignment = "New Varadero Research Director"
	role_comm_title = "WY RD"
	minimap_icon = "goon_sci_lead"
	minimap_background = "background_wy_management"
	paygrades = list(PAY_SHORT_CCMOC = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/scientist
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/rd/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/rd(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/cm/tan(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard, WEAR_L_HAND)
	add_random_cl_survivor_loot(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/labass
	name = "Survivor - WY New Varadero Lab Assistant"
	assignment = "New Varadero Lab Assistant"
	role_comm_title = "WY Rsr Ast"
	minimap_icon = "chemist_wo"
	skills = /datum/skills/civilian/survivor
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH,)

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/labass/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/utility/gray(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_J_STORE)
	add_random_survivor_research_gear(new_human)
	add_survivor_rare_item(new_human)
	add_lacn_weapon(new_human)
	..()

//////////////// CIVILIAN/CORPORATE SURVIVORS /////////////////
//////////////////////////////////////////////////////////////

/datum/equipment_preset/survivor/new_varadero/assrep
	name = "Survivor - New Varadero - UA Assistant Representative"
	assignment = "UA Assistant Representative"
	role_comm_title = "Asst Rep"
	minimap_icon = "recruiter"
	minimap_background = "background_ua"
	paygrades = list(PAY_SHORT_CREP = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY,ACCESS_CIVILIAN_COMMAND,ACCESS_MARINE_COMMAND, ACCESS_MARINE_GENERAL, ACCESS_MARINE_MEDBAY)
	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/assrep/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000(new_human.back), WEAR_IN_BACK)
	add_random_cl_survivor_loot(new_human)
	add_lacn_weapon(new_human)
	..()

/datum/equipment_preset/survivor/new_varadero/chaplain
	name = "Survivor - New Varadero Priest"
	assignment = "LACN Base Chaplain"
	paygrades = list(PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "LACN CHAP"
	skills = /datum/skills/civilian/survivor/chaplain

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/new_varadero/chaplain/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/rank/utility = new()
	var/obj/item/clothing/accessory/ranks/navy/e4/pin = new()
	uniform.attach_accessory(new_human,pin)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/priest_robe(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/bible/booze(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general(new_human), WEAR_R_STORE)
	add_survivor_rare_item(new_human)
	add_lacn_weapon(new_human)
	..()