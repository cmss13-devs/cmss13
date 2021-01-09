/datum/equipment_preset/other
	name = "Other"

/datum/equipment_preset/other/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))

//*****************************************************************************************************/

/datum/equipment_preset/other/mutineer
	name = "Mutineer"
	flags = EQUIPMENT_PRESET_EXTRA

	faction = FACTION_MUTINEER

/datum/equipment_preset/other/mutineer/load_status(mob/living/carbon/human/H)
	. = ..()
	H.faction = FACTION_MUTINEER
	H.hud_set_squad()

/datum/equipment_preset/other/mutineer/leader
	name = "Mutineer Leader"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mutineer/leader/load_status(mob/living/carbon/human/H)
	for(var/datum/action/human_action/activable/mutineer/A in H.actions)
		A.remove_action(H)

	var/list/abilities = subtypesof(/datum/action/human_action/activable/mutineer)


	for(var/type in abilities)
		var/datum/action/human_action/activable/mutineer/M = new type()
		M.give_action(H)


/datum/equipment_preset/other/freelancer
	name = "Freelancer"

	assignment = "Freelancer"
	rank = FACTION_FREELANCER
	idtype = /obj/item/card/id/data
	faction = FACTION_FREELANCER

/datum/equipment_preset/other/freelancer/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/other/freelancer/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_colonist)] [pick(last_names_colonist)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_colonist)] [pick(last_names_colonist)]"
	H.change_real_name(H, random_name)
	H.age = rand(20,45)
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/standard
	name = "Freelancer (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/freelancer

/datum/equipment_preset/other/freelancer/standard/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	spawn_merc_helmet(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_merc_weapon(H)

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/medic
	name = "Freelancer (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Freelancer Medic"

	skills = /datum/skills/freelancer/combat_medic

/datum/equipment_preset/other/freelancer/medic/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	spawn_merc_helmet(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	spawn_merc_weapon(H)

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/leader
	name = "Freelancer (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Freelancer Warlord"
	languages = list("English", "Russian", "Japanese", "Sainja")

	skills = /datum/skills/freelancer/SL

/datum/equipment_preset/other/freelancer/leader/load_gear(mob/living/carbon/human/H)

	//No random helmet, so that it's more clear that he's the leader
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/freelancer/beret, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_merc_weapon(H,0,7)
	spawn_merc_weapon(H,1)

//*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_heavy
	name = "Mercenary (Heavy)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Enforcer"
	rank = "Mercenary"
	skills = /datum/skills/mercenary
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/mercenary_heavy/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/mercenary_heavy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)

	spawn_merc_weapon(H,0,7)
	spawn_merc_weapon(H,1)

//*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_miner
	name = "Mercenary (Miner)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Worker"
	rank = "Mercenary"
	skills = /datum/skills/mercenary
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/mercenary_miner/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/mercenary_miner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_engineer
	name = "Mercenary (Engineer)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "Mercenary Engineer"
	rank = "Mercenary"
	skills = /datum/skills/mercenary
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/mercenary_engineer/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/mercenary_engineer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/engineer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/engineer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/engineer, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/other/business_person
	name = "Business Person"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/silver/cl
	assignment = "Corporate Representative"
	rank = "Corporate Representative"
	skills = /datum/skills/civilian

/datum/equipment_preset/other/business_person/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/other/business_person/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_if_possible(new /obj/item/clothing/under/lawyer/bluesuit, WEAR_BODY)
	H.equip_if_possible(new /obj/item/clothing/shoes/centcom, WEAR_FEET)
	H.equip_if_possible(new /obj/item/clothing/gloves/white, WEAR_HANDS)

	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses, WEAR_EYES)
	H.equip_if_possible(new /obj/item/clipboard, WEAR_WAIST)

//*****************************************************************************************************/

/datum/equipment_preset/other/compression_suit
	name = "Mk50 Compression Suit"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_PMC
	skills = /datum/skills/pfc
	idtype = /obj/item/card/id/data

/datum/equipment_preset/other/compression_suit/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/compression, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/compression, WEAR_HEAD)
	var /obj/item/tank/jetpack/J = new /obj/item/tank/jetpack/oxygen(H)
	H.equip_to_slot_or_del(J, WEAR_BACK)
	J.toggle()
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath, WEAR_FACE)
	J.Topic(null, list("stat" = 1))
	spawn_merc_weapon(H)


//*****************************************************************************************************/

/datum/equipment_preset/other/pizza
	name = "Pizza"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list("English", "Russian", "Japanese") //Just in case they are delivering to UPP or CLF...
	idtype = /obj/item/card/id/pizza
	assignment = "Pizza Deliverer"
	rank = FACTION_PIZZA
	skills = /datum/skills/civilian
	faction = FACTION_PIZZA

/datum/equipment_preset/other/pizza/New()
	. = ..()
	access = get_freelancer_access()

/datum/equipment_preset/other/pizza/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE,FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male)] [pick(last_names)]"
	else
		random_name = "[pick(first_names_female)] [pick(last_names)]"
	H.change_real_name(H, random_name)
	H.age = rand(17,45)

/datum/equipment_preset/other/pizza/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pizza, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/red, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/red, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/margherita, WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/vegetable, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/mushroom, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/meat, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/thirteenloko, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)

/datum/equipment_preset/other/souto
	name = "Souto Man"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list("English", "Russian", "Japanese") //Just in case they are delivering to UPP or CLF...
	idtype = /obj/item/card/id/souto
	assignment = FACTION_SOUTO
	rank = "Souto Man"
	skills = /datum/skills/mercenary
	faction = FACTION_SOUTO

/datum/equipment_preset/other/souto/New()
	. = ..()
	access = get_freelancer_access()

/datum/equipment_preset/other/souto/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE,FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	H.change_real_name(H, "Carlos Souto Man Cubano")
	H.age = rand(17,45)

/datum/equipment_preset/other/souto/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/souto, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/souto, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/souto, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/souto, WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/fake_mustache, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/souto, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/souto, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/souto, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/souto, WEAR_FEET)
	var/obj/vehicle/souto/V = new
	V.forceMove(H.loc)
	V.buckle_mob(H, H)

//*****************************************************************************************************/

/datum/equipment_preset/other/zombie
	name = "Zombie"
	flags = EQUIPMENT_PRESET_EXTRA
	rank = FACTION_ZOMBIE
	languages = list("Zombie")
	skills = null //no restrictions
	faction = FACTION_ZOMBIE

//Overloading the function to be able to spawn gear first
/datum/equipment_preset/other/zombie/load_preset(mob/living/carbon/human/H, var/randomise = FALSE)
	if(randomise)
		load_name(H)
	load_skills(H) //skills are set before equipment because of skill restrictions on certain clothes.
	load_languages(H)
	load_gear(H)
	load_id(H)
	load_status(H)
	load_vanity(H)
	load_race(H)//Race is loaded last, otherwise we wouldn't be able to equip gear!
	H.regenerate_icons()

/datum/equipment_preset/other/zombie/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(H)
	var/random_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.change_real_name(H, random_name)
	H.age = rand(21,45)

/datum/equipment_preset/other/zombie/load_id(mob/living/carbon/human/H)
	H.job = "Zombie"
	H.faction = faction

/datum/equipment_preset/other/zombie/load_race(mob/living/carbon/human/H)
	H.set_species("Human") // Set back, so that we can get our claws again

	H.set_species("Zombie")

/datum/equipment_preset/other/zombie/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator
	name = "Gladiator"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/dogtag
	skills = /datum/skills/gladiator

	assignment = "Bestiarius"
	rank = FACTION_GLADIATOR
	faction = FACTION_GLADIATOR

/datum/equipment_preset/other/gladiator/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(H)
	var/random_name = capitalize(pick(H.gender == MALE ? first_names_male_gladiator : first_names_female_gladiator))
	H.change_real_name(H, random_name)
	H.age = rand(21,45)

/datum/equipment_preset/other/gladiator/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/gladiator, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/mercsword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(H)
	lantern.name = "Beacon of Holy Light"

	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_L_STORE)
	H.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator/champion
	name = "Gladiator Champion"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/gladiator/champion
	assignment = "Samnite"
	rank = "Samnite"

/datum/equipment_preset/other/gladiator/champion/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/gladiator, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/ert/security, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/mercsword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(H)
	lantern.name = "Beacon of Holy Light"

	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/red, WEAR_L_STORE)
	H.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator/leader
	name = "Gladiator Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/gladiator/champion/leader
	assignment = "Spartacus"
	rank = "Spartacus"

/datum/equipment_preset/other/gladiator/leader/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/gladiator, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/swat, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/mercsword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(H)
	lantern.name = "Beacon of Holy Light"

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/holy_hand_grenade, WEAR_L_STORE)
	H.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/xeno_cultist
	name = "Cultist - Xeno Cultist"
	faction = FACTION_XENOMORPH
	flags = EQUIPMENT_PRESET_EXTRA
	idtype = /obj/item/card/id/lanyard
	skills = /datum/skills/civilian/survivor

	assignment = "Cultist"
	rank = "Cultist"

/datum/equipment_preset/other/xeno_cultist/New()
	. = ..()
	access = get_all_civilian_accesses()

/datum/equipment_preset/other/xeno_cultist/load_race(mob/living/carbon/human/H, var/hivenumber = XENO_HIVE_NORMAL)
	. = ..()
	H.hivenumber = hivenumber

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

	if(hive)
		H.faction = hive.internal_faction

/datum/equipment_preset/other/xeno_cultist/load_gear(mob/living/carbon/human/H)
	var/backItem = /obj/item/storage/backpack/marine/satchel
	if (H.client && H.client.prefs && (H.client.prefs.backbag == 1))
		backItem = /obj/item/storage/backpack/marine

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new backItem(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/cultist_hoodie(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cultist_hood(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)

//*****************************************************************************************************/
/datum/equipment_preset/other/xeno_cultist/load_status(mob/living/carbon/human/H, var/hivenumber = XENO_HIVE_NORMAL)
	if(SSticker.mode && H.mind)
		SSticker.mode.xenomorphs += H.mind

	var/datum/hive_status/hive = GLOB.hive_datum[H.hivenumber]

	if(hive.leading_cult_sl == H)
		hive.leading_cult_sl = null

	GLOB.xeno_cultists += H

	var/list/huds_to_add = list(MOB_HUD_XENO_INFECTION, MOB_HUD_XENO_STATUS)

	for(var/hud_to_add in huds_to_add)
		var/datum/mob_hud/hud = huds[hud_to_add]
		hud.add_hud_to(H)

	var/list/actions_to_add = subtypesof(/datum/action/human_action/activable/cult)

	for(var/datum/action/human_action/activable/O in H.actions)
		O.remove_action(H)

	for(var/action_to_add in actions_to_add)
		var/datum/action/human_action/activable/cult/O = new action_to_add()
		O.give_action(H)

/datum/equipment_preset/other/xeno_cultist/leader
	name = "Cultist - Xeno Cultist Leader"
	uses_special_name = TRUE
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/cultist_leader

	assignment = "Cultist Leader"
	rank = "Cultist Leader"

/datum/equipment_preset/other/xeno_cultist/leader/load_gear(mob/living/carbon/human/H)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/cultist(H), WEAR_EYES)

/datum/equipment_preset/other/xeno_cultist/leader/load_status(mob/living/carbon/human/H)
	. = ..()

	var/datum/hive_status/hive = GLOB.hive_datum[H.hivenumber]
	hive.leading_cult_sl = H

	var/list/types = subtypesof(/datum/action/human_action/activable/cult_leader/)

	for(var/type in types)
		var/datum/action/human_action/activable/cult_leader/O = new type()
		O.give_action(H)
//*****************************************************************************************************/

/datum/equipment_preset/other/professor_dummy
	name = "DUMMY"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "DUMMY"
	rank = "DUMMY"
	idtype = /obj/item/card/id/dogtag
	uses_special_name = TRUE

/datum/equipment_preset/other/professor_dummy/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE, FEMALE)
	H.real_name = "Professor DUMMY the Medical Mannequin"
	H.name = H.real_name
	H.age = rand(1,5)
	var/datum/preferences/A = new
	A.randomize_appearance(H)


/datum/equipment_preset/other/professor_dummy/load_race(mob/living/carbon/human/H)
	. = ..()
	//Can't hug the dummy! Otherwise it's basically human...
	H.huggable = FALSE

/datum/equipment_preset/other/professor_dummy/load_gear(mob/living/carbon/human/H)
	var/obj/item/device/professor_dummy_tablet/tablet = new /obj/item/device/professor_dummy_tablet(H)
	tablet.link_mob(H)
	H.equip_to_slot_or_del(tablet, WEAR_R_HAND)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical, WEAR_BODY)

//*****************************************************************************************************/

/datum/equipment_preset/other/tank
	name = "Event Vehicle Crewman (CRMN)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/dogtag
	assignment = JOB_CREWMAN
	rank = JOB_CREWMAN
	paygrade = "E7"
	role_comm_title = "CRMN"
	minimum_age = 30
	skills = /datum/skills/tank_crew

	faction = FACTION_NEUTRAL

/datum/equipment_preset/other/tank/New()
	. = ..()
	access = get_antagonist_access()

/datum/equipment_preset/other/tank/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tanker(H), WEAR_HEAD)

	H.hud_set_squad()

	spawn_weapon(/obj/item/weapon/gun/smg/m39, /obj/item/ammo_magazine/smg/m39/extended, H, 0, 3)

/datum/equipment_preset/other/tank/load_status()
	return

//*****************************************************************************************************/
