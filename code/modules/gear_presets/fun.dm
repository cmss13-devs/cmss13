
/datum/equipment_preset/fun
	name = "Fun"
	flags = EQUIPMENT_PRESET_STUB
	assignment = "Fun"

	skills = /datum/skills/civilian
	idtype = /obj/item/card/id

//*****************************************************************************************************/

/datum/equipment_preset/fun/pirate
	name = "Fun - Pirate"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_PIRATE

	skills = /datum/skills/pfc/crafty

/datum/equipment_preset/fun/pirate/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/energy/sword/pirate(new_human), WEAR_L_HAND)

	new_human.equip_to_slot(new /obj/item/attachable/bayonet(new_human), WEAR_L_STORE)
	new_human.equip_to_slot(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/fun/pirate/captain
	name = "Fun - Pirate Captain"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/SL
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/fun/pirate/captain/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/pirate(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/pirate(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/energy/sword/pirate(new_human), WEAR_L_HAND)

	new_human.equip_to_slot(new /obj/item/attachable/bayonet(new_human), WEAR_L_STORE)
	new_human.equip_to_slot(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/fun/clown
	name = "Fun - Clown"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/fun/clown/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/clown(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(new_human), WEAR_FACE)

	new_human.equip_to_slot(new /obj/item/toy/bikehorn(new_human), WEAR_L_STORE)
	new_human.equip_to_slot(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/fun/hefa
	name = "HEFA Knight"

	flags = EQUIPMENT_PRESET_EXTRA
	uses_special_name = TRUE
	faction = FACTION_HEFA
	faction_group = list(FACTION_HEFA, FACTION_MARINE)

	// Cooperate!
	idtype = /obj/item/card/id/gold
	assignment = "Shrapnelsworn"
	rank = "Brother of the Order"
	paygrade = "Ser"
	role_comm_title = "OHEFA"

	skills = /datum/skills/specialist

/datum/equipment_preset/fun/hefa/load_skills(mob/living/carbon/human/new_human)
	..()
	new_human.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_GRENADIER)

/datum/equipment_preset/fun/hefa/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = MALE
	var/list/names = list(
		"Lancelot", "Gawain", "Geraint", "Percival", "Bors", "Lamorak", "Kay", "Gareth", "Bedivere", "Gaheris", "Galahad", "Tristan", "Palamedes",
		"Aban", "Abrioris", "Aglovale", "Agravain", "Aqiff", "Bagdemagus", "Baudwin", "Brastius", "Bredbeddle", "Breunor", "Caradoc", "Calogrenant",
		"Degore", "Daniel", "Dinadan", "Dornar", "Ector", "Elyan", "Galeshin", "Gingalain", "Griflet", "Lionel", "Lucan", "Mador", "Maleagant",
		"Mordred", "Morien", "Pelleas", "Pinel", "Sagramore", "Safir", "Segwarides", "Tor", "Ulfius", "Yvain", "Ywain"
	)

	var/new_name = pick(names) + " of the HEFA Order"
	new_human.change_real_name(new_human, new_name)
	new_human.f_style = "5 O'clock Shadow"

/datum/equipment_preset/fun/hefa/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/M = new(new_human)
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)

	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist/hefa(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	var/jacket_success = new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3G/hefa(new_human), WEAR_JACKET)
	var/satchel_success = new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	var/waist_success = new_human.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large(new_human), WEAR_WAIST)
	var/pouch_r_success = new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive(new_human), WEAR_R_STORE)
	var/gun_success = new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/launcher/grenade/m92(new_human), WEAR_J_STORE)

	// Now pump /everything/ full of HEFAs

	// M92 launcher
	if(gun_success)
		var/obj/item/weapon/gun/launcher/grenade/m92/launcher = new_human.s_store
		launcher.name = "HEFA grenade launcher"
		launcher.internal_slots = 10 // big buff

		// give it a magharness
		var/obj/item/attachable/magnetic_harness/magharn = new(launcher)
		magharn.Attach(launcher)
		launcher.update_attachable(magharn.slot)

		// the M92 New() proc sleeps off into the background 1 second after it's called, so the nades aren't actually in at this point in execution
		spawn(5)
			// hefa only no stinky nades
			for(var/obj/item/explosive/grenade/G in launcher.cylinder)
				qdel(G)
			launcher.cylinder.storage_slots = launcher.internal_slots //need to adjust the internal storage as well.
			for(var/i = 1 to launcher.internal_slots)
				new /obj/item/explosive/grenade/high_explosive/frag(launcher.cylinder)
			launcher.set_fire_delay(FIRE_DELAY_TIER_4) //More HEFA per second, per second. Strictly speaking this is probably a nerf.

	// Satchel
	if(satchel_success)
		for(var/i in 1 to 7)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.back), WEAR_IN_BACK)

	// Belt
	if(waist_success)
		var/obj/item/storage/belt/grenade/large/belt = new_human.belt
		belt.name = "M42 HEFA rig Mk. XVII"
		for(var/i in 1 to belt.storage_slots)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.belt), WEAR_IN_BELT)

	// Armor/suit
	if(jacket_success)
		var/obj/item/clothing/suit/storage/marine/M3G/armor = new_human.wear_suit
		armor.name = "HEFA Knight armor"
		for(var/i in 1 to armor.storage_slots)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.wear_suit), WEAR_IN_JACKET)

	// Pouch
	if(pouch_r_success)
		var/obj/item/storage/pouch/explosive/pouch = new_human.r_store
		pouch.name = "HEFA pouch"
		for(var/i in 1 to pouch.storage_slots)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.r_store), WEAR_IN_R_STORE)

	// Webbing
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.back), WEAR_IN_ACCESSORY)

/datum/equipment_preset/fun/hefa/melee
	name = "HEFA Knight - Melee"

/datum/equipment_preset/fun/hefa/melee/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/M = new(new_human)
	M.name = "HEFA Knight uniform"
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)

	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	var/shoes_success = new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
	var/helmet_success = new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist/hefa(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	var/jacket_success = new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3G/hefa(new_human), WEAR_JACKET)
	var/satchel_success = new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	var/waist_success = new_human.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large(new_human), WEAR_WAIST)
	var/pouch_r_success = new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/sword/hefa(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/sword/hefa(new_human), WEAR_IN_BACK)

	if(shoes_success)
		var/obj/item/clothing/shoes/marine/knife/shoes = new_human.shoes
		shoes.name = "HEFA Knight combat boots"

	// Now pump /everything/ full of HEFAs

	// Satchel
	if(satchel_success)
		var/obj/item/storage/backpack/marine/satchel = new_human.back
		satchel.name = "HEFA storage bag"
		for(var/i in 1 to 7)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.back), WEAR_IN_BACK)

	// Belt
	if(waist_success)
		var/obj/item/storage/belt/grenade/large/belt = new_human.belt
		belt.name = "M42 HEFA rig Mk. XVII"
		for(var/i in 1 to belt.storage_slots)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.belt), WEAR_IN_BELT)

	// Armor/suit
	if(jacket_success)
		var/obj/item/clothing/suit/storage/marine/M3G/armor = new_human.wear_suit
		armor.name = "HEFA Knight armor"
		for(var/i in 1 to armor.storage_slots)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.wear_suit), WEAR_IN_JACKET)

	// Pouches
	if(pouch_r_success)
		var/obj/item/storage/pouch/explosive/pouch = new_human.r_store
		pouch.name = "HEFA pouch"
		for(var/i in 1 to pouch.storage_slots)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.r_store), WEAR_IN_R_STORE)

	// Webbing
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.back), WEAR_IN_ACCESSORY)

	// Helmet
	if(helmet_success)
		var/obj/item/clothing/head/helmet/marine/hefa_helmet = new_human.head
		for(var/i in 1 to hefa_helmet.pockets.storage_slots)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/frag(new_human.head), WEAR_IN_HELMET)

/datum/equipment_preset/fun/santa
	name = "Fun - Santa"
	paygrade = PAY_SHORT_CDNM
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/everything
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	assignment = "Santa"

	skills = null
	idtype = /obj/item/card/id/general

/datum/equipment_preset/fun/santa/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/fun/santa/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = MALE
	new_human.change_real_name(new_human, "Santa")

	new_human.age = 270 //he is old
	new_human.r_hair = 0
	new_human.g_hair = 0
	new_human.b_hair = 0

/datum/equipment_preset/fun/santa/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/santabag(new_human), WEAR_BACK)
	//pack filled with gifts
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(new_human), WEAR_L_EAR)
	//body
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pj/red(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/space/santa(new_human), WEAR_JACKET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/device/flash(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human), WEAR_L_STORE)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/santahat(new_human), WEAR_HEAD)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general/santa(new_human), WEAR_WAIST)

	new_human.set_species("Human Hero") //Santa is STRONG.
	ADD_TRAIT(new_human, TRAIT_SANTA, TRAIT_SOURCE_ADMIN)

/datum/equipment_preset/upp/ivan
	name = "Fun - Ivan"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrade = PAY_SHORT_UE6
	skills = /datum/skills/everything
	assignment = "UPP Armsmaster"
	rank = "UPP Armsmaster"
	role_comm_title = null

/datum/equipment_preset/upp/ivan/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = MALE
	new_human.change_real_name(new_human, "Ivan")
	new_human.f_style = "Shaved"
	new_human.h_style = "Shaved Head"
	new_human.skin_color = "pale3"
	new_human.r_hair = 165
	new_human.g_hair = 42
	new_human.b_hair = 42

/datum/equipment_preset/upp/ivan/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/ivan, WEAR_BACK)
	//back filled with random guns, it's awesome
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//body + webbing
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	UPP.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/jacket/ivan, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/m60, WEAR_J_STORE)
	//webbing
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full, WEAR_R_STORE)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/ivanberet, WEAR_HEAD)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/ivan, WEAR_WAIST)
	//belt filled with random magazines, it's cool

	new_human.set_species("Human Hero") //Ivan is STRONG.


/datum/equipment_preset/fun/van_bandolier
	name = "Fun - Big Game Hunter"
	paygrade = PAY_SHORT_CCMO
	uses_special_name = TRUE
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/everything
	assignment = "Huntsman"
	rank = "Huntsman"
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/fun/van_bandolier/New()
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/fun/van_bandolier/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = MALE
	new_human.change_real_name(new_human, "Van Bandolier")
	new_human.age = 55
	new_human.r_hair = 153 //Light brown hair.
	new_human.g_hair = 102
	new_human.b_hair = 51
	new_human.r_facial = 153
	new_human.g_facial = 102
	new_human.b_facial = 51
	new_human.h_style = "Mullet"
	new_human.f_style = "Full English"
	new_human.skin_color = "pale2"
	new_human.r_eyes = 102 //Brown eyes.
	new_human.g_eyes = 51
	new_human.b_eyes = 0

/datum/equipment_preset/fun/van_bandolier/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/double/twobore(new_human), WEAR_BACK)

	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(new_human), WEAR_L_EAR)

	//body
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/van_bandolier(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/van_bandolier(new_human), WEAR_JACKET)

	//suit storage
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/van_bandolier(new_human), WEAR_J_STORE)

	//suit pockets
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/civ(new_human.wear_suit), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/splint(new_human.wear_suit), WEAR_IN_JACKET)

	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human), WEAR_R_STORE)

	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/van_bandolier(new_human), WEAR_HEAD)

	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated/van_bandolier(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/van_bandolier(new_human), WEAR_FEET)

	//hands
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/twobore(new_human), WEAR_L_HAND)

	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/webley/full(new_human), WEAR_WAIST)

	new_human.set_species("Human Hero") //Van Bandolier is not easily subdued.
	//But he isn't completely unstoppable, either. Reenables slow, knockout, daze, stun and permanent (organ dam, IB etc.) damage.
	//Stuns and knockdowns are shorter but he's not completely immune.
	new_human.status_flags &= ~NO_PERMANENT_DAMAGE
	new_human.status_flags |= STATUS_FLAGS_DEBILITATE
	ADD_TRAIT(new_human, TRAIT_TWOBORE_TRAINING, TRAIT_SOURCE_ADMIN) //Means he can handle his gun and speak its hit lines.


/datum/equipment_preset/fun/monkey
	name = "Fun - Monkey"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MONKEY

	uses_special_name = TRUE

	skills = /datum/skills/pfc/crafty // about equivalent to a marine

	assignment = "Monkey"
	rank = "Monkey"
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/fun/monkey/load_race(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_species(SPECIES_MONKEY)

/datum/equipment_preset/fun/monkey/load_name(mob/living/carbon/human/new_human, randomise, client/mob_client)
	new_human.gender = pick(60;MALE,40;FEMALE)
	var/random_name = get_random_name(new_human)
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(1, 40)

/datum/equipment_preset/fun/monkey/proc/get_random_name(mob/living/carbon/human/new_human)
	return pick(GLOB.monkey_names)

/datum/equipment_preset/fun/monkey/marine
	name = "Fun - Monkey Marine"

	assignment = "Monkey Marine"
	rank = "Monkey Marine"
	paygrade = PAY_SHORT_ME2

/datum/equipment_preset/fun/monkey/marine/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/monkey(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)

/datum/equipment_preset/fun/monkey/soldier
	name = "Fun - Monkey Soldier"

	assignment = "Monkey Soldier"
	rank = "Monkey Soldier"
	paygrade = PAY_SHORT_UE1

/datum/equipment_preset/fun/monkey/soldier/get_random_name(mob/living/carbon/human/new_human)
	return new_human.gender == MALE ? pick(GLOB.first_names_male_upp) : pick(GLOB.first_names_female_upp)

/datum/equipment_preset/fun/monkey/soldier/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/monkey(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/rifleman(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp(new_human), WEAR_IN_JACKET)
