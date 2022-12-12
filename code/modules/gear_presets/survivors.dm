/datum/equipment_preset/survivor
	name = JOB_SURVIVOR
	assignment = JOB_SURVIVOR
	rank = JOB_SURVIVOR

	skills = /datum/skills/civilian/survivor
	languages = list(LANGUAGE_ENGLISH)
	paygrade = "C"
	idtype = /obj/item/card/id/lanyard
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	origin_override = ORIGIN_CIVILIAN

	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(H)
	var/random_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.change_real_name(H, random_name)
	H.age = rand(21,45)

/datum/equipment_preset/survivor/load_gear(mob/living/carbon/human/H) // Essentially where you will put the most essential piece of kit you want survivors to spawn with.
	add_random_survivor_equipment(H)
	add_survivor_weapon(H)
	add_survivor_weapon_pistol(H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(H), WEAR_IN_BACK)

/datum/equipment_preset/survivor/load_id(mob/living/carbon/human/H, client/mob_client)
	var/obj/item/clothing/under/uniform = H.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
		uniform.sensor_faction = FACTION_COLONIST
	return ..()


// ----- Scientist Survivor

/datum/equipment_preset/survivor/scientist
	name = "Survivor - Scientist"
	assignment = "Scientist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_ENGINEERING)

/datum/equipment_preset/survivor/scientist/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/virologist(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/green(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/chem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/paper/research_notes/good(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(H), WEAR_IN_JACKET)

	..()

/datum/equipment_preset/survivor/scientist/soro
	name = "Survivor - Sorokyne Strata Researcher"
	assignment = "Sorokyne Strata Researcher"

/datum/equipment_preset/survivor/scientist/soro/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor(H), WEAR_JACKET)

	..()

/datum/equipment_preset/survivor/scientist/shiva
	name = "Survivor - Shivas Snowball Researcher"
	assignment = "Shivas Snowball Researcher"

/datum/equipment_preset/survivor/scientist/shiva/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor/parka/purple(H), WEAR_JACKET)

	..()

/datum/equipment_preset/survivor/scientist/corsat
	name = "Survivor - CORSAT Researcher"
	assignment = "CORSAT Researcher"

/datum/equipment_preset/survivor/scientist/corsat/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/scientist/florina
	name = "Survivor - Florina Researcher"
	assignment = "Florina Researcher"

/datum/equipment_preset/survivor/scientist/florina/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/purple(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/purple(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/science(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/chem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/scientist/lv
	name = "Survivor - LV-624 Archeologist"
	assignment = "LV-624 Archeologist"

/datum/equipment_preset/survivor/scientist/lv/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/boonie(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/scientist/solaris
	name = "Survivor - Solaris Scientist"
	assignment = "Solaris Scientist"

/datum/equipment_preset/survivor/scientist/solaris/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/virologist(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/green(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(H), WEAR_FEET)

	..()

// ----- Doctor Survivor

/datum/equipment_preset/survivor/doctor
	name = "Survivor - Doctor"
	assignment = "Doctor"
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)


/datum/equipment_preset/survivor/doctor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(H), WEAR_JACKET)
	add_random_survivor_medical_gear(H)


	..()

/datum/equipment_preset/survivor/doctor/trijent
	name = "Survivor - Trijent Doctor"
	assignment = "Trijent Dam Doctor"

/datum/equipment_preset/survivor/doctor/trijent/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/doctor/soro
	name = "Survivor - Sorokyne Strata Doctor"
	assignment = "Sorokyne Strata Doctor"

/datum/equipment_preset/survivor/doctor/soro/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/veteran/soviet_uniform_01(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/doctor/corsat
	name = "Survivor - CORSAT Doctor"
	assignment = "CORSAT Doctor"

/datum/equipment_preset/survivor/doctor/corsat/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/doctor/florina
	name = "Survivor - Florina Doctor"
	assignment = "Florina Doctor"

/datum/equipment_preset/survivor/doctor/florina/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/doctor/kutjevo
	name = "Survivor - Kutjevo Doctor"
	assignment = "Kutjevo Doctor"

/datum/equipment_preset/survivor/doctor/kutjevo/load_gear(mob/living/carbon/human/H)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	add_random_kutjevo_survivor_uniform(H)
	add_random_kutjevo_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)

	..()

/datum/equipment_preset/survivor/doctor/lv
	name = "Survivor - LV-624 Emergency Medical Technician"
	assignment = "LV-624 Emergency Medical Technician"

/datum/equipment_preset/survivor/doctor/lv/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)

	..()

/datum/equipment_preset/survivor/doctor/solaris
	name = "Survivor - Solaris Doctor"
	assignment = "Solaris Doctor"

/datum/equipment_preset/survivor/doctor/solaris/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/purple(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/purple(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/doctor/shiva
	name = "Survivor - Shivas Snowball Doctor"
	assignment = "Shivas Snowball Doctor"

/datum/equipment_preset/survivor/doctor/shiva/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor/parka/green(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)

	..()

// ----- CL Survivor

/datum/equipment_preset/survivor/corporate
	name = "Survivor - Corporate Liaison"
	assignment = "Corporate Liaison"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/cl
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_WY_CORPORATE,
		ACCESS_CIVILIAN_COMMAND
	)

/datum/equipment_preset/survivor/corporate/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/formal(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	add_random_cl_survivor_loot(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/corporate/shiva
	name = "Survivor - Shivas Snowball Corporate Liaison"
	assignment = "Shivas Snowball Corporate Liaison"

/datum/equipment_preset/survivor/corporate/shiva/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/formal(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor/parka/navy(H), WEAR_JACKET)

	..()

// ----- Security Survivor

/datum/equipment_preset/survivor/security
	name = "Survivor - Security"
	assignment = "Security"
	skills = /datum/skills/civilian/survivor/marshal
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/data
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/security/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(H), WEAR_HEAD)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/security/trijent
	name = "Survivor - Trijent Security Guard"
	assignment = "Trijent Dam Security Guard"

/datum/equipment_preset/survivor/security/trijent/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_security/navyblue(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/beret/marine/mp/mpcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/security/soro
	name = "Survivor - Sorokyne Strata Security"
	assignment = "Sorokyne Strata Security"

/datum/equipment_preset/survivor/security/soro/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/veteran/soviet_uniform_01(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/soviet(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)

	..()

/datum/equipment_preset/survivor/security/corsat
	name = "Survivor - CORSAT Security Guard"
	assignment = "Weyland-Yutani Corporate Security Guard"

/datum/equipment_preset/survivor/security/corsat/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/formal/servicedress(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC(H), WEAR_HEAD)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/security/florina
	name = "Survivor - Florina Prison Guard"
	assignment = "Florina Prison Guard"

/datum/equipment_preset/survivor/security/florina/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/security/kutjevo
	name = "Survivor - Kutjevo Security Guard"
	assignment = "Kutjevo Security Guard"


/datum/equipment_preset/survivor/security/kutjevo/load_gear(mob/living/carbon/human/H)
	add_random_kutjevo_survivor_uniform(H)
	add_random_kutjevo_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/security/lv
	name = "Survivor - LV-624 Security Guard"
	assignment = "Weyland-Yutani Corporate Security Guard"

/datum/equipment_preset/survivor/security/lv/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/formal/servicedress(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/security/shiva
	name = "Survivor - Shivas Snowball Security Guard"
	assignment = "United Americas Peacekeeper"

/datum/equipment_preset/survivor/security/shiva/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/security/solaris
	name = "Survivor - Solaris United Americas Peacekeepers"
	assignment = "United Americas Peacekeeper"

/datum/equipment_preset/survivor/security/solaris/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	..()

// ----- Prisioner Survivors

/datum/equipment_preset/survivor/prisoner
	name = "Survivor - Prisoner"
	assignment = "Prisoner"
	skills = /datum/skills/civilian/survivor/prisoner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/prisoner/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	if(prob(50)) H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(H), WEAR_HEAD)
	if(prob(50)) H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H.back), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/gangleader
	name = "Survivor - Gang Leader"
	assignment = "Gang Leader"
	skills = /datum/skills/civilian/survivor/gangleader
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/gangleader/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	if(prob(50)) H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(H), WEAR_HEAD)
	if(prob(50)) H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H.back), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), WEAR_FEET)

	..()

// ----- Civilian Survivor

/datum/equipment_preset/survivor/civilian
	name = "Survivor - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/civilian/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pj/red(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)

	..()

// ----- Chef Survivor

/datum/equipment_preset/survivor/chef
	name = "Survivor - Chef"
	assignment = "Chef"
	skills = /datum/skills/civilian/survivor/chef
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/chef/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/tool/kitchen/rollingpin(H.back), WEAR_IN_BACK)

	..()

// ----- Botanist Survivor

/datum/equipment_preset/survivor/botanist
	name = "Survivor - Botanist"
	assignment = "Botanist"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_MEDBAY,
	)

/datum/equipment_preset/survivor/botanist/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/hyd(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/tool/hatchet(H.back), WEAR_IN_BACK)

	..()

// ----- Chaplain Survivor

/datum/equipment_preset/survivor/chaplain
	name = "Survivor - Chaplain"
	assignment = "Chaplain"
	skills = /datum/skills/civilian/survivor/chaplain
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/datum/equipment_preset/survivor/chaplain/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/holidaypriest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/bible/booze(H.back), WEAR_IN_BACK)

	..()

/datum/equipment_preset/survivor/chaplain/trijent
	name = "Survivor - Trijent Chaplain"
	assignment = "Trijent Chaplain"

/datum/equipment_preset/survivor/chaplain/trijent/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/nun(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/nun_hood(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/holidaypriest(H), WEAR_JACKET)

	..()

/datum/equipment_preset/survivor/chaplain/kutjevo
	name = "Survivor - Kutjevo Chaplain"
	assignment = "Kutjevo Chaplain"

/datum/equipment_preset/survivor/chaplain/kutjevo/load_gear(mob/living/carbon/human/H)
	add_random_kutjevo_survivor_uniform(H)
	add_random_kutjevo_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)

	..()

/datum/equipment_preset/survivor/chaplain/lv
	name = "Survivor - LV-624 Priest"
	assignment = "LV-624 Priest"

/datum/equipment_preset/survivor/chaplain/lv/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/priest_robe(H), WEAR_JACKET)

	..()

/datum/equipment_preset/survivor/chaplain/solaris
	name = "Survivor - Solaris Chaplain"
	assignment = "Solaris Chaplain"

/datum/equipment_preset/survivor/chaplain/solaris/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/holidaypriest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/nun_hood(H), WEAR_HEAD)

	..()

// ----- Engineering Survivor

/datum/equipment_preset/survivor/engineer
	name = "Survivor - Engineer"
	assignment = "Engineer"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS
		)

/datum/equipment_preset/survivor/engineer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/largetank(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

	..()


/datum/equipment_preset/survivor/engineer/trijent
	name = "Survivor - Dam Maintenance Technician"
	assignment = "Dam Maintenance Technician"

/datum/equipment_preset/survivor/engineer/trijent/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	..()


/datum/equipment_preset/survivor/engineer/lv
	name = "Survivor - LV-624 Engineer"
	assignment = "LV-624 Engineer"

/datum/equipment_preset/survivor/engineer/lv/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/dispatch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/engineer/shiva
	name = "Survivor - Shivas Snowball Engineer"
	assignment = "Shivas Snowball Engineer"

/datum/equipment_preset/survivor/engineer/shiva/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor/parka/yellow(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/engineer/soro
	name = "Survivor - Sorokyne Strata Political Prisioner"
	assignment = "Sorokyne Strata Political Prisioner"

/datum/equipment_preset/survivor/engineer/soro/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)

	..()

/datum/equipment_preset/survivor/engineer/trijent/hydro
	name = "Survivor - Hydro Electric Engineer"
	assignment = "Hydro Electric Engineer"

/datum/equipment_preset/survivor/engineer/trijent/hydro/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mt(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/engineer/corsat
	name = "Survivor - Corsat Station Engineer"
	assignment = "Corsat Station Engineer"

/datum/equipment_preset/survivor/engineer/corsat/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/techofficer(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/engineer/florina
	name = "Survivor - Florina Engineer"
	assignment = "Florina Engineer"

/datum/equipment_preset/survivor/engineer/florina/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/white(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/engineer/kutjevo
	name = "Survivor - Kutjevo Engineer"
	assignment = "Kutjevo Engineer"

/datum/equipment_preset/survivor/engineer/kutjevo/load_gear(mob/living/carbon/human/H)
	add_random_kutjevo_survivor_uniform(H)
	add_random_kutjevo_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)

	..()

/datum/equipment_preset/survivor/engineer/solaris
	name = "Survivor - Solaris Engineer"
	assignment = "Solaris Engineer"

/datum/equipment_preset/survivor/engineer/solaris/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/yellow(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)

	..()

// ----- Miner Survivor

/datum/equipment_preset/survivor/miner
	name = "Survivor - Miner"
	assignment = "Miner"
	skills = /datum/skills/civilian/survivor/miner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/datum/equipment_preset/survivor/miner/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/tool/pickaxe(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H.back), WEAR_IN_BACK)

	..()

// --- Salesman Survivor

/datum/equipment_preset/survivor/salesman
	name = "Survivor - Salesman"
	assignment = "Salesman"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/data
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/salesman/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	add_random_cl_survivor_loot(H)
	..()

// ---- Trucker Survivor

/datum/equipment_preset/survivor/trucker
	name = "Survivor - Trucker"
	assignment = "Trucker"
	skills = /datum/skills/civilian/survivor/trucker
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS
		)

/datum/equipment_preset/survivor/trucker/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/overalls(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/yellow(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H.back), WEAR_IN_BACK)

	..()

/datum/equipment_preset/survivor/trucker/lv
	name = "Survivor - LV-624 Cargo Technician"
	assignment = "LV-624 Cargo Technician"

/datum/equipment_preset/survivor/trucker/lv/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargo(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/yellow(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)

	..()

/datum/equipment_preset/survivor/trucker/kutjevo
	name = "Survivor - Kutjevo Heavy Vehicle Operator"
	assignment = "Kutjevo Heavy Vehicle Operator"

/datum/equipment_preset/survivor/trucker/kutjevo/load_gear(mob/living/carbon/human/H)
	add_random_kutjevo_survivor_uniform(H)
	add_random_kutjevo_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)

	..()

/datum/equipment_preset/survivor/trucker/solaris
	name = "Survivor - Solaris Heavy Vehicle Operator"
	assignment = "Solaris Heavy Vehicle Operator"
	skills = /datum/skills/civilian/survivor/trucker

/datum/equipment_preset/survivor/trucker/solaris/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/worker_overalls(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/red(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/shotgun/buckshot(H.back), WEAR_IN_BACK)

	..()

/datum/equipment_preset/survivor/trucker/trijent
	name = "Survivor - Trijent Dam Heavy Vehicle Operator"
	assignment = "Trijent Dam Heavy Vehicle Operator"
	skills = /datum/skills/civilian/survivor/trucker

/datum/equipment_preset/survivor/trucker/trijent/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank(H), WEAR_IN_BACK)

	..()


// ---- Colonial Marshall Survivor

/datum/equipment_preset/survivor/colonial_marshal
	name = "Survivor - Colonial Marshall"
	assignment = "Colonial Marshall"
	skills = /datum/skills/civilian/survivor/marshal
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/cl
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/colonial_marshal/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(H), WEAR_HEAD)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/colonial_marshal/florina
	name = "Survivor - United Americas Riot Officer"
	assignment = "United Americas Riot Officer"

/datum/equipment_preset/survivor/colonial_marshal/florina/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/ua_riot(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/ua_riot(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/colonial_marshal/lv
	name = "Survivor - LV-624 Head of Security"
	assignment = "LV-624 Head of Security"

/datum/equipment_preset/survivor/colonial_marshal/lv/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_security/navyblue(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/colonial_marshal/solaris
	name = "Survivor - Solaris Colonial Marshal"
	assignment = "Solaris Colonial Marshal"

/datum/equipment_preset/survivor/colonial_marshal/solaris/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/colonial_marshal/kutjevo
	name = "Survivor - Kutjevo Colonial Marshal"
	assignment = "Kutjevo Colonial Marshal"

/datum/equipment_preset/survivor/colonial_marshal/kutjevo/load_gear(mob/living/carbon/human/H)
	add_random_kutjevo_survivor_uniform(H)
	add_random_kutjevo_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

	..()

/datum/equipment_preset/survivor/colonial_marshal/shiva
	name = "Survivor - Shiva Colonial Marshal"
	assignment = "Shiva Snowball Colonial Marshal"

/datum/equipment_preset/survivor/colonial_marshal/shiva/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/corp(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor/parka/red(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)

	..()

// ----- CL Survivor

/datum/equipment_preset/survivor/interstellar_commerce_commission_liason
	name = "Survivor - Interstellar Commerce Commission Liaison"
	assignment = "Interstellar Commerce Commission Liaison"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_WY_CORPORATE,
		ACCESS_CIVILIAN_LOGISTICS
		)

/datum/equipment_preset/survivor/interstellar_commerce_commission_liason/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(H), WEAR_HANDS)
	add_random_cl_survivor_loot(H)

	..()

/datum/equipment_preset/survivor/interstellar_commerce_commission_liason/corsat
	name = "Survivor - Interstellar Commerce Commission Liaison CORSAT"
	assignment = "Interstellar Commerce Commission Liaison"

/datum/equipment_preset/survivor/interstellar_commerce_commission_liason/corsat/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/formal(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H), WEAR_JACKET)



	..()

// ----- Roughneck Survivor

/datum/equipment_preset/survivor/roughneck
	name = "Survivor - Roughneck"
	assignment = "Roughneck"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC
		)

/datum/equipment_preset/survivor/roughneck/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/white(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)

	..()

// ----- Interstellar Human Rights Survivor

/datum/equipment_preset/survivor/interstellar_human_rights_observer
	name = "Survivor - Interstellar Human Rights Observer"
	assignment = "Interstellar Human Rights Observer"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_WY_CORPORATE,
		ACCESS_CIVILIAN_LOGISTICS
		)

/datum/equipment_preset/survivor/interstellar_human_rights_observer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/suspenders(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	add_random_cl_survivor_loot(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/interstellar_human_rights_observer/soro
	name = "Survivor - Soro Interstellar Human Rights Observer"
	assignment = "Interstellar Human Rights Observer"


/datum/equipment_preset/survivor/interstellar_human_rights_observer/soro/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), WEAR_HEAD)

	..()

// ----- WY Survivors

/datum/equipment_preset/survivor/goon
	name = "Survivor - Corporate Security Goon"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_WY_GOON
	faction = FACTION_WY
	faction_group = FACTION_LIST_WY
	rank = JOB_WY_GOON
	paygrade = "WEY-GOON"
	idtype = /obj/item/card/id/silver/cl
	skills = /datum/skills/civilian/survivor/goon
	languages = list(LANGUAGE_ENGLISH)
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_WY_CORPORATE,
		ACCESS_CIVILIAN_LOGISTICS
	)

/datum/equipment_preset/survivor/goon/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/goon, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/corporate, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/light/corporate, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/corporate, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88_near_empty, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate, WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

/datum/equipment_preset/survivor/pmc
	name = "Survivor - PMC"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = "Weyland-Yutani PMC (Standard)"
	faction = FACTION_PMC
	faction_group = FACTION_LIST_WY
	rank = JOB_PMC
	paygrade = "PMC-OP"
	idtype = /obj/item/card/id/pmc
	skills = /datum/skills/civilian/survivor/pmc
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_WY_CORPORATE,
		ACCESS_CIVILIAN_LOGISTICS
		)

/datum/equipment_preset/survivor/pmc/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	add_pmc_survivor_weapon(H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)

	..()

/datum/equipment_preset/survivor/wy/manager/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/survivor/wy/manager
	name = "Survivor - Corporate Supervisor"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = "WY-5G"
	skills = /datum/skills/civilian/manager_survivor
	assignment = "Colony Supervisor"
	role_comm_title = "Supervisor"
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver/clearance_badge/manager
	faction_group = FACTION_LIST_WY
	access = list(
		ACCESS_WY_CORPORATE,
		ACCESS_ILLEGAL_PIRATE,
		ACCESS_MARINE_BRIDGE,
		ACCESS_MARINE_DROPSHIP,
		ACCESS_MARINE_RESEARCH,
		ACCESS_MARINE_MEDBAY
	)

/datum/equipment_preset/survivor/wy/manager/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(H), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/manager(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/manager(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/paper/research_notes/good(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(H), WEAR_IN_JACKET)
	add_random_cl_survivor_loot(H)

	..()

// ----- Mercenary Survivors

/datum/equipment_preset/survivor/pmc/miner/one
	name = "Survivor - Mercenary"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	assignment = "Mercenary"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC
		)

/datum/equipment_preset/survivor/pmc/miner/one/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner, WEAR_HEAD)

	..()

/datum/equipment_preset/survivor/pmc/freelancer
	name = "Survivor - Freelancer"
	assignment = "Freelancer"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC
		)

/datum/equipment_preset/survivor/pmc/freelancer/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	spawn_merc_helmet(H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	..()

// ----- Hostile Survivors

/datum/equipment_preset/survivor/clf
	name = "CLF Survivor"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/civilian/survivor/clf
	faction = FACTION_CLF
	faction_group = list(FACTION_CLF) //they were not a part of the colony and as such do not have survivor or marine IFF

/datum/equipment_preset/survivor/clf/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	spawn_rebel_belt(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)

	..()
