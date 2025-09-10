/// Equipment Presets for Hunter Games mode

GLOBAL_LIST_EMPTY(spawned_contestants)

/datum/job/hunter_games
	title = "Hunted Survivor"
	disp_title = JOB_HUNTER_GAMES
	// For the roundstart precount, then gets further limited by set_spawn_positions.
	total_positions = 999 // however many people are online.
	spawn_positions = 999
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_CUSTOM_SPAWN
	late_joinable = FALSE

	gear_preset = /datum/equipment_preset/hunter_games/civilian

	/// How many contestants have been spawned total
	var/static/total_spawned = 0


/datum/job/hunter_games/spawn_in_player(mob/new_player/new_player)
	. = ..()
	total_spawned++
	GLOB.spawned_contestants += new_player


/datum/equipment_preset/hunter_games
	name = "Hunter Games - Hunted Survivor"
	assignment = JOB_HUNTER_GAMES
	job_title = JOB_HUNTER_GAMES
	paygrades = list(PAY_SHORT_CIV)

	skills = /datum/skills/hunter_games

	minimap_icon = "surv"
	minimap_background = "cultist"

	faction = null // No factions for these guys, every man for himself
	faction_group = null

	flags = EQUIPMENT_PRESET_STUB

// Give contestants global access to the colony; all the doors being locked isn't a very interesting challenge.
/datum/equipment_preset/hunter_games/New()
	. = ..()

	access = get_access(ACCESS_LIST_GLOBAL)

// Contestants get a random language; we tower of babel in this mf.
/datum/equipment_preset/hunter_games/load_languages(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_languages(list(pick(ALL_HUMAN_LANGUAGES)))

/datum/equipment_preset/hunter_games/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	return // We don't want people spawning in guns, food, knives, and other advantages here.

///datum/equipment_preset/proc/load_traits(mob/living/carbon/human/new_human, client/mob_client)
//	return
// May be needed to prevent overriding the language randomization with trait languages?



/datum/equipment_preset/hunter_games/civilian
	name = "Hunter Games - Hunted Survivor - Civilian"
	assignment = JOB_HUNTER_GAMES
	job_title = JOB_HUNTER_GAMES
	origin_override = ORIGIN_CIVILIAN

	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/hunter_games/civilian/load_gear(mob/living/carbon/human/new_human)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)

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

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/hunter_games/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/on(new_human), WEAR_R_STORE)
	// I noticed players would kinda just stand there not realizing the game had even loaded without a pre-existing light, so now it spawns a lit one in their pocket.
