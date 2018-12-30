
/datum/equipment_preset/other
	name = "Other"

/datum/equipment_preset/other/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))

/*****************************************************************************************************/

/datum/equipment_preset/other/freelancer
	name = "Freelancer"

/datum/equipment_preset/other/freelancer/load_name(mob/living/carbon/human/H)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance_for(H)
	var/list/first_names_mcol = list("Alan","Jack","Bil","Jonathan","John","Shiro","Gareth","Clark","Sam", "Lionel", "Aaron", "Charlie", "Scott", "Winston", "Aidan", "Ellis", "Mason", "Wesley", "Nicholas", "Calvin", "Nishikawa", "Hiroto", "Chiba", "Ouchi", "Furuse", "Takagi", "Oba", "Kishimoto")
	var/list/first_names_fcol = list("Emma", "Adelynn", "Mary", "Halie", "Chelsea", "Lexie", "Arya", "Alicia", "Selah", "Amber", "Heather", "Myra", "Heidi", "Charlotte", "Ashley", "Raven", "Tori", "Anne", "Madison", "Oliva", "Lydia", "Tia", "Riko", "Ari", "Machida", "Ueki", "Mihara", "Noda")
	var/list/last_names_col = list("Hawkins","Rickshaw","Elliot","Billard","Cooper","Fox", "Barlow", "Barrows", "Stewart", "Morgan", "Green", "Stone", "Titan", "Crowe", "Krantz", "Pathillo", "Driggers", "Burr", "Hunt", "Yuko", "Gesshin", "Takanibu", "Tetsuzan", "Tomomi", "Bokkai", "Takesi")
	if(H.gender == MALE)
		H.real_name = "[pick(first_names_mcol)] [pick(last_names_col)]"
		H.f_style = "5 O'clock Shadow"
	else
		H.real_name = "[pick(first_names_fcol)] [pick(last_names_col)]"
	H.age = rand(20,45)
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35

/*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/standard
	name = "Freelancer (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/freelancer/standard/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.assignment = "Freelancer"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_all_accesses()
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "FREELANCERS"

/datum/equipment_preset/other/freelancer/standard/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc)

/datum/equipment_preset/other/freelancer/standard/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general(H), WEAR_R_STORE)

	spawn_merc_gun(H)
	spawn_rebel_gun(H,1)

/*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/medic
	name = "Freelancer (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/freelancer/medic/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.assignment = "Freelancer Medic"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_all_accesses()
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "FREELANCERS"

/datum/equipment_preset/other/freelancer/medic/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/combat_medic)

/datum/equipment_preset/other/freelancer/medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

	spawn_merc_gun(H)

/*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/leader
	name = "Freelancer (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/freelancer/leader/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = list()
	W.assignment = "Freelancer Warlord"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_all_accesses()
	if(H.mind)
		H.mind.role_comm_title = "Lead"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "FREELANCERS"

/datum/equipment_preset/other/freelancer/leader/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/SL)

/datum/equipment_preset/other/freelancer/leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/freelancer(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer/beret(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

	spawn_merc_gun(H)
	spawn_merc_gun(H,1)

/datum/equipment_preset/other/freelancer/leader/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English", "Russian", "Tradeband", "Sainja"))

/*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_heavy
	name = "Mercenary (Heavy)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mercenary_heavy/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Mercenary"
	W.rank = "Mercenary Enforcer"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "MERCENARIES"

/datum/equipment_preset/other/mercenary_heavy/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/mercenary)

/datum/equipment_preset/other/mercenary_heavy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)

	spawn_merc_gun(H)
	spawn_merc_gun(H,1)

/*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_miner
	name = "Mercenary (Miner)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mercenary_miner/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Mercenary"
	W.rank = "Mercenary Worker"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "MERCENARIES"

/datum/equipment_preset/other/mercenary_miner/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/mercenary)

/datum/equipment_preset/other/mercenary_miner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/other/mercenary_engineer
	name = "Mercenary (Engineer)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mercenary_engineer/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Mercenary"
	W.rank = "Mercenary Engineer"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "MERCENARIES"

/datum/equipment_preset/other/mercenary_engineer/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/mercenary)

/datum/equipment_preset/other/mercenary_engineer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/engineer(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/engineer(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/engineer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/other/business_person
	name = "Business Person"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/business_person/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access = get_all_centcom_access()
	W.assignment = "Corporate Representative"
	W.registered_name = H.real_name
	H.equip_if_possible(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"

/datum/equipment_preset/other/business_person/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/civilian)

/datum/equipment_preset/other/business_person/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_if_possible(new /obj/item/clothing/under/lawyer/bluesuit(H), WEAR_BODY)
	H.equip_if_possible(new /obj/item/clothing/shoes/centcom(H), WEAR_FEET)
	H.equip_if_possible(new /obj/item/clothing/gloves/white(H), WEAR_HANDS)

	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(H), WEAR_EYES)
	H.equip_if_possible(new /obj/item/clipboard(H), WEAR_WAIST)

/*****************************************************************************************************/

/datum/equipment_preset/other/compression_suit
	name = "Mk50 Compression Suit"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/compression_suit/load_id(mob/living/carbon/human/H)
	. = ..()

/datum/equipment_preset/other/compression_suit/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc)

/datum/equipment_preset/other/compression_suit/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots(H), WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/compression(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/compression(H), WEAR_HEAD)
	var /obj/item/tank/jetpack/J = new /obj/item/tank/jetpack/oxygen(H)
	H.equip_to_slot_or_del(J, WEAR_BACK)
	J.toggle()
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), WEAR_FACE)
	J.Topic(null, list("stat" = 1))
	spawn_merc_gun(H)


/*****************************************************************************************************/

/datum/equipment_preset/other/pizza
	name = "Pizza"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/pizza/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English", "Russian", "Tradeband")) //Just in case they are delivering to UPP or CLF...

/datum/equipment_preset/other/pizza/load_name(mob/living/carbon/human/H)
	H.gender = pick(MALE,FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance_for(H)
	if(H.gender == MALE)
		H.real_name = "[pick(first_names_male)] [pick(last_names)]"
	else
		H.real_name = "[pick(first_names_female)] [pick(last_names)]"
	H.name = H.real_name
	H.age = rand(17,45)

/datum/equipment_preset/other/pizza/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "Pizza Deliverer"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_freelancer_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "Pizza"

/datum/equipment_preset/other/pizza/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/civilian)

/datum/equipment_preset/other/pizza/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pizza(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/red(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/margherita(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/vegetable(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/mushroom(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/meat(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/thirteenloko(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout(H.back), WEAR_IN_BACK)



/*****************************************************************************************************/

/datum/equipment_preset/other/zombie
	name = "Zombie"
	flags = EQUIPMENT_PRESET_EXTRA

//Overloading the function to be able to spawn gear first
/datum/equipment_preset/other/zombie/load_preset(mob/living/carbon/human/H, var/randomise = FALSE)
	if(randomise)
		load_name(H)
	load_skills(H) //skills are set before equipment because of skill restrictions on certain clothes.
	load_languages(H)
	load_gear(H)
	load_id(H)
	load_status(H)
	load_race(H)//Race is loaded last, otherwise we wouldn't be able to equip gear!

/datum/equipment_preset/other/zombie/load_languages(mob/living/carbon/human/H)
	H.set_languages("Zombie")

/datum/equipment_preset/other/zombie/load_name(mob/living/carbon/human/H)
	H.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance_for(H)
	H.real_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.name = H.real_name
	H.age = rand(21,45)

/datum/equipment_preset/other/zombie/load_id(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Zombie"
		H.mind.special_role = "MODE"

/datum/equipment_preset/other/zombie/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.cm_skills = null //no restriction

/datum/equipment_preset/other/zombie/load_race(mob/living/carbon/human/H)
	H.set_species("Zombie")
	H.contract_disease(new /datum/disease/black_goo)
	for(var/datum/disease/black_goo/BG in H.viruses)
		BG.stage = 5

/datum/equipment_preset/other/zombie/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)