
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

/datum/equipment_preset/fun/pirate/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword/pirate(H), WEAR_L_HAND)

	H.equip_to_slot(new /obj/item/attachable/bayonet(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/fun/pirate/captain
	name = "Fun - Pirate Captain"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/SL
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/fun/pirate/captain/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/pirate(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/pirate(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword/pirate(H), WEAR_L_HAND)

	H.equip_to_slot(new /obj/item/attachable/bayonet(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/fun/clown
	name = "Fun - Clown"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/fun/clown/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/clown(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), WEAR_FACE)

	H.equip_to_slot(new /obj/item/toy/bikehorn(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

//*****************************************************************************************************/
/datum/equipment_preset/fun/dutch
	name = "Dutch's Dozen - Soldier"
	paygrade = "DTC"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_DUTCH

	skills = /datum/skills/mercenary

/datum/equipment_preset/fun/dutch/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_dutch)] [pick(last_names)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_dutch)] [pick(last_names)]"

	H.change_real_name(H, random_name)
	H.age = rand(25,35)
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/fun/dutch/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/dutch(H), WEAR_J_STORE)

	to_chat(H, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask in your leader's backpack serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures, and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs. You have a very wide variety of skills, put them to use!"))

/datum/equipment_preset/fun/dutch/minigun
	name = "Dutch's Dozen - Minigun"
	paygrade = "DTCM"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/mercenary

/datum/equipment_preset/fun/dutch/minigun/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun(H), WEAR_J_STORE)

	to_chat(H, SPAN_WARNING("You are a member of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail.  The Yautja mask in your leader's backpack serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

/datum/equipment_preset/fun/dutch/arnie
	name = "Dutch's Dozen - Arnold"
	paygrade = "ARN"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/dutch
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/fun/dutch/arnie/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	H.change_real_name(H, "Arnold 'Dutch' Schaefer")
	H.f_style = "5 O'clock Shadow"
	H.h_style = "Mulder"

	H.age = 38
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/fun/dutch/arnie/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/dutch(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/dutch/cap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/empgrenade/dutch(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/ap(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/dutch(H), WEAR_J_STORE)

	H.set_species("Human Hero") //Arnold is STRONG.

	to_chat(H, SPAN_WARNING("You are Dutch, the leader of the Dutch's Dozen! You are fully aware of anything and everything regarding the Yautja, down to every minute detail. The Yautja mask in your backpack serves to let the Yautja track you, or for you to place traps. The Yautja can detect their gear signatures,  and will track this mask as soon as you arrive. The EMP grenades in your backpack have a very wide area range. They will interrupt Predator cloak and consume their bracer charge. REMEMBER: Your objective is to hunt, kill and loot the Predators planetside, and NOT hunt Xenomorphs."))

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

/datum/equipment_preset/fun/hefa/load_skills(mob/living/carbon/human/H)
	..()
	H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_GRENADIER)

/datum/equipment_preset/fun/hefa/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	var/list/names = list(
		"Lancelot", "Gawain", "Geraint", "Percival", "Bors", "Lamorak", "Kay", "Gareth", "Bedivere", "Gaheris", "Galahad", "Tristan", "Palamedes",
		"Aban", "Abrioris", "Aglovale", "Agravain", "Aqiff", "Bagdemagus", "Baudwin", "Brastius", "Bredbeddle", "Breunor", "Caradoc", "Calogrenant",
		"Degore", "Daniel", "Dinadan", "Dornar", "Ector", "Elyan", "Galeshin", "Gingalain", "Griflet", "Lionel", "Lucan", "Mador", "Maleagant",
		"Mordred", "Morien", "Pelleas", "Pinel", "Sagramore", "Safir", "Segwarides", "Tor", "Ulfius", "Yvain", "Ywain"
	)

	var/new_name = pick(names) + " of the HEFA Order"
	H.change_real_name(H, new_name)
	H.f_style = "5 O'clock Shadow"

/datum/equipment_preset/fun/hefa/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/marine/M = new(H)
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)

	H.equip_to_slot_or_del(M, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist/hefa(H), WEAR_HEAD)
	var/jacket_success = H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3G/hefa(H), WEAR_JACKET)
	var/satchel_success = H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	var/waist_success = H.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large(H), WEAR_WAIST)
	var/pouch_r_success = H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive(H), WEAR_R_STORE)
	var/pouch_l_success = H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive(H), WEAR_L_STORE)
	var/gun_success = H.equip_to_slot_or_del(new /obj/item/weapon/gun/launcher/grenade/m92(H), WEAR_J_STORE)

	// Now pump /everything/ full of HEFAs

	// M92 launcher
	if(gun_success)
		var/obj/item/weapon/gun/launcher/grenade/m92/launcher = H.s_store
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
				new /obj/item/explosive/grenade/HE/frag(launcher.cylinder)
			launcher.fire_delay = FIRE_DELAY_TIER_4 //More HEFA per second, per second. Strictly speaking this is probably a nerf.

	// Satchel
	if(satchel_success)
		for(var/i = 1 to 7)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.back), WEAR_IN_BACK)

	// Belt
	if(waist_success)
		var/obj/item/storage/belt/grenade/large/belt = H.belt
		belt.name = "M42 HEFA rig Mk. XVII"
		for(var/i = 1 to belt.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.belt), WEAR_IN_BELT)

	// Armor/suit
	if(jacket_success)
		var/obj/item/clothing/suit/storage/marine/M3G/armor = H.wear_suit
		armor.name = "HEFA Knight armor"
		for(var/i = 1 to armor.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.wear_suit), WEAR_IN_JACKET)

	// Pouches
	if(pouch_r_success)
		var/obj/item/storage/pouch/explosive/pouch = H.r_store
		pouch.name = "HEFA pouch"
		for(var/i = 1 to pouch.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.r_store), WEAR_IN_R_STORE)
	if(pouch_l_success)
		var/obj/item/storage/pouch/explosive/pouch = H.l_store
		pouch.name = "HEFA pouch"
		for(var/i = 1 to pouch.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.l_store), WEAR_IN_L_STORE)

	// Webbing
	for(var/i = 1 to W.slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.back), WEAR_IN_ACCESSORY)

/datum/equipment_preset/fun/hefa/melee
	name = "HEFA Knight - Melee"

/datum/equipment_preset/fun/hefa/melee/load_gear(mob/living/carbon/human/H)
	var/obj/item/clothing/under/marine/M = new(H)
	M.name = "HEFA Knight uniform"
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)

	H.equip_to_slot_or_del(M, WEAR_BODY)
	var/shoes_success = H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist/hefa(H), WEAR_HEAD)
	var/jacket_success = H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/M3G/hefa(H), WEAR_JACKET)
	var/satchel_success = H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(H), WEAR_BACK)
	var/waist_success = H.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large(H), WEAR_WAIST)
	var/pouch_r_success = H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive(H), WEAR_R_STORE)
	var/pouch_l_success = H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/hefa(H), WEAR_R_HAND)

	if(shoes_success)
		var/obj/item/clothing/shoes/marine/shoes = H.shoes
		shoes.name = "HEFA Knight combat boots"

	// Now pump /everything/ full of HEFAs

	// Satchel
	if(satchel_success)
		var/obj/item/storage/backpack/marine/satchel = H.back
		satchel.name = "HEFA storage bag"
		for(var/i = 1 to 7)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.back), WEAR_IN_BACK)

	// Belt
	if(waist_success)
		var/obj/item/storage/belt/grenade/large/belt = H.belt
		belt.name = "M42 HEFA rig Mk. XVII"
		for(var/i = 1 to belt.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.belt), WEAR_IN_BELT)

	// Armor/suit
	if(jacket_success)
		var/obj/item/clothing/suit/storage/marine/M3G/armor = H.wear_suit
		armor.name = "HEFA Knight armor"
		for(var/i = 1 to armor.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.wear_suit), WEAR_IN_JACKET)

	// Pouches
	if(pouch_r_success)
		var/obj/item/storage/pouch/explosive/pouch = H.r_store
		pouch.name = "HEFA pouch"
		for(var/i = 1 to pouch.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.r_store), WEAR_IN_R_STORE)
	if(pouch_l_success)
		var/obj/item/storage/pouch/explosive/pouch = H.l_store
		pouch.name = "HEFA pouch"
		for(var/i = 1 to pouch.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.l_store), WEAR_IN_L_STORE)

	// Webbing
	for(var/i = 1 to W.slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/frag(H.back), WEAR_IN_ACCESSORY)

/datum/equipment_preset/fun/santa
	name = "Fun - Santa"
	paygrade = "O8"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/everything
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	assignment = "Santa"

	skills = null
	idtype = /obj/item/card/id/admiral

/datum/equipment_preset/fun/santa/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/fun/santa/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	H.change_real_name(H, "Santa")

	H.age = 270 //he is old
	H.r_hair = 0
	H.g_hair = 0
	H.b_hair = 0

/datum/equipment_preset/fun/santa/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/santabag(H), WEAR_BACK)
	//pack filled with gifts
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/cdrcom(H), WEAR_EAR)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pj/red(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/santa(H), WEAR_JACKET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), WEAR_L_STORE)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/santahat(H), WEAR_HEAD)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(H), WEAR_FEET)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/admiral/santa(H), WEAR_WAIST)

	H.set_species("Human Hero") //Santa is STRONG.

/datum/equipment_preset/upp/ivan
	name = "Fun - Ivan"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/everything
	assignment = "UPP Armsmaster"
	rank = "UPP Armsmaster"
	role_comm_title = null

/datum/equipment_preset/upp/ivan/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	H.change_real_name(H, "Ivan")
	H.f_style = "Shaved"
	H.h_style = "Shaved Head"
	H.ethnicity = "Scandinavian"
	H.r_hair = 165
	H.g_hair = 42
	H.b_hair = 42

/datum/equipment_preset/upp/ivan/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/ivan, WEAR_BACK)
	//back filled with random guns, it's awesome
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	//body + webbing
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/ivan, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/m60, WEAR_J_STORE)
	//webbing
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/m60, WEAR_IN_ACCESSORY)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/frt_kit/full, WEAR_R_STORE)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ivanberet, WEAR_HEAD)
	//limb
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/ivan, WEAR_WAIST)
	//belt filled with random magazines, it's cool

	H.set_species("Human Hero") //Ivan is STRONG.
