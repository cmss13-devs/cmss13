/datum/equipment_preset/yautja
	name = "Yautja"
	idtype = null //No IDs for Yautja!
	languages = list(LANGUAGE_YAUTJA)
	job_title = "Predator"
	faction = FACTION_YAUTJA
	faction_group = FACTION_LIST_YAUTJA
	uses_special_name = TRUE
	skills = /datum/skills/yautja/warrior

	minimap_icon = "predator"

	var/default_cape_type = "None"
	var/clan_rank

/datum/equipment_preset/yautja/load_race(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_species(SPECIES_YAUTJA)
	new_human.skin_color = pick(PRED_SKIN_COLOR)
	new_human.bubble_icon = "pred"
	new_human.body_type = "pred" //can be removed in future for body types
	if(!mob_client)
		mob_client = new_human.client
	if(mob_client?.prefs)
		new_human.h_style = mob_client.prefs.predator_h_style
		new_human.skin_color = mob_client.prefs.predator_skin_color

/datum/equipment_preset/yautja/load_id(mob/living/carbon/human/new_human)
	new_human.job = job_title
	new_human.faction = faction
	new_human.faction_group = faction_group

/datum/equipment_preset/yautja/load_vanity(mob/living/carbon/human/new_human)
	return //No vanity items for Yautja!

/datum/equipment_preset/yautja/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_VERYLOW //Eat before you hunt.

/datum/equipment_preset/yautja/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	var/caster_material = "ebony"
	var/bracer_material = "ebony"
	var/translator_type = PRED_TECH_MODERN
	var/invisibility_sound = PRED_TECH_MODERN

	if(!mob_client)
		mob_client = new_human.client
	if(mob_client?.prefs)
		caster_material = mob_client.prefs.predator_caster_material
		bracer_material = mob_client.prefs.predator_bracer_material
		translator_type = mob_client.prefs.predator_translator_type
		invisibility_sound = mob_client.prefs.predator_invisibility_sound

	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yautja/hunter(new_human, translator_type, invisibility_sound, caster_material, clan_rank, bracer_material), WEAR_HANDS)

	if(new_human.client?.check_whitelist_status(WHITELIST_YAUTJA_COUNCIL))
		new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja/overseer(new_human), WEAR_L_EAR)
	else
		new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(new_human), WEAR_L_EAR)


/datum/equipment_preset/yautja/load_name(mob/living/carbon/human/new_human, randomise)
	var/final_name = capitalize(pick(GLOB.pred_names)) + " " + capitalize(pick(GLOB.pred_last_names))
	new_human.gender = pick_weight(list(MALE = 80, FEMALE = 20))// Female Hunters are rare
	new_human.age = rand(100,150)
	new_human.flavor_text = ""
	new_human.flavor_texts["general"] = new_human.flavor_text

	if(new_human.client && new_human.client.prefs)
		new_human.gender = new_human.client.prefs.predator_gender
		new_human.age = new_human.client.prefs.predator_age
		final_name = new_human.client.prefs.predator_name
		new_human.flavor_text = new_human.client.prefs.predator_flavor_text
		new_human.flavor_texts["general"] = new_human.flavor_text
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "[capitalize(pick(GLOB.pred_names))] [capitalize(pick(GLOB.pred_last_names))]"
	new_human.change_real_name(new_human, final_name)

/datum/equipment_preset/yautja/youngblood //normal WL youngblood rank
	name = "Yautja Young"
	minimap_icon = "predator_young"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	clan_rank = CLAN_RANK_UNBLOODED_INT

/datum/equipment_preset/yautja/youngblood/load_name(mob/living/carbon/human/new_human, randomise)
	. = ..()
	var/new_name = "Young [new_human.real_name]"
	new_human.change_real_name(new_human, new_name)

//BLOODED
/datum/equipment_preset/yautja/blooded
	name = "Yautja Blooded"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	default_cape_type = PRED_YAUTJA_QUARTER_CAPE
	clan_rank = CLAN_RANK_BLOODED_INT

// ELITE
/datum/equipment_preset/yautja/elite
	name = "Yautja Elite"
	minimap_icon = "predator_elite"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	default_cape_type = PRED_YAUTJA_HALF_CAPE
	clan_rank = CLAN_RANK_ELITE_INT

/datum/equipment_preset/yautja/elite/load_name(mob/living/carbon/human/new_human, randomise)
	. = ..()
	var/new_name = "Elite [new_human.real_name]"
	new_human.change_real_name(new_human, new_name)

// ELDER
/datum/equipment_preset/yautja/elder
	name = "Yautja Elder"
	minimap_icon = "predator_elder"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	default_cape_type = PRED_YAUTJA_THIRD_CAPE
	clan_rank = CLAN_RANK_ELDER_INT

/datum/equipment_preset/yautja/elder/load_name(mob/living/carbon/human/new_human, randomise)
	. = ..()
	var/new_name = "Elder [new_human.real_name]"
	new_human.change_real_name(new_human, new_name)

// CLAN LEADER
/datum/equipment_preset/yautja/leader
	name = "Yautja Leader"
	minimap_icon = "predator_leader"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	default_cape_type = PRED_YAUTJA_CAPE
	clan_rank = CLAN_RANK_LEADER_INT

/datum/equipment_preset/yautja/leader/load_name(mob/living/carbon/human/new_human, randomise)
	. = ..()
	var/new_name = "Clan Leader [new_human.real_name]"
	new_human.change_real_name(new_human, new_name)

// ANCIENT
/datum/equipment_preset/yautja/ancient
	name = "Yautja Ancient"
	minimap_icon = "predator_ancient"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	default_cape_type = PRED_YAUTJA_PONCHO
	clan_rank = CLAN_RANK_ADMIN_INT

/datum/equipment_preset/yautja/ancient/load_name(mob/living/carbon/human/new_human, randomise)
	. = ..()
	var/new_name = "Ancient [new_human.real_name]"
	new_human.change_real_name(new_human, new_name)

/datum/equipment_preset/yautja/non_wl //For hunting grounds ONLY
	name = "Yautja Young (non-WL)"
	minimap_icon = "predator_young"
	job_title = "Young Blood"
	faction = FACTION_YAUTJA_YOUNG
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/non_wl/load_name(mob/living/carbon/human/new_human, randomise)
	. = ..()
	var/new_name = "Young [new_human.real_name]"
	new_human.change_real_name(new_human, new_name)

/datum/equipment_preset/yautja/non_wl_leader //The "leader" of the group if a WL player is not on
	name = "Yautja Youngblood pack leader (non-WL)"
	minimap_icon = "predator_young"
	job_title = "Young Blood"
	faction = FACTION_YAUTJA_YOUNG
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/non_wl_leader/load_name(mob/living/carbon/human/new_human, randomise)
	. = ..()
	var/new_name = "Pack Leader [new_human.real_name]" //fluff rank blooded outrank them
	new_human.change_real_name(new_human, new_name)

/datum/equipment_preset/yautja/equipped
	name = "Yautja Hunter (Equipped)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	clan_rank = CLAN_RANK_BLOODED_INT

/datum/equipment_preset/yautja/equipped/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_MAX

/datum/equipment_preset/yautja/equipped/load_gear(mob/living/carbon/human/new_human)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja/hunter(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja/hunter(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/bracer_attachments/wristblades(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/bracer_attachments/wristblades(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja/hunter/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/medicomp/full(new_human), WEAR_R_STORE)
	switch(rand(1, 100))
		if(1 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/yautja/sword(new_human), WEAR_BACK)
		if(11 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/yautja/chain(new_human), WEAR_J_STORE)
		if(21 to 30)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/yautja/scythe(new_human), WEAR_BACK)
		if(31 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/yautja/scythe/alt(new_human), WEAR_BACK)
		if(41 to 60)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/yautja/chained/combistick(new_human), WEAR_BACK)
		if(61 to 80)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/yautja/glaive(new_human), WEAR_BACK)
		if(81 to 100)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/yautja/glaive/alt(new_human), WEAR_BACK)

/datum/equipment_preset/yautja/emissary
	name = "Yautja Emissary (Pre-Equipped)"
	idtype = /obj/item/card/id/dogtag // oh yeah
	assignment = "Yautja Emissary"
	job_title = "Yautja Emissary"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_YAUTJA // needs to be changed to bad blood once they're in the game
	faction_group = FACTION_LIST_YAUTJA // ditto

	minimap_icon = "predator" // ditto

/datum/equipment_preset/yautja/emissary/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_MAX

/datum/equipment_preset/yautja/emissary/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	var/caster_material = "ebony"
	var/bracer_material = "ebony"
	var/translator_type = PRED_TECH_MODERN
	var/invisibility_sound = PRED_TECH_MODERN

	if(!mob_client)
		mob_client = new_human.client
	if(mob_client?.prefs)
		caster_material = mob_client.prefs.predator_caster_material
		bracer_material = mob_client.prefs.predator_bracer_material
		translator_type = mob_client.prefs.predator_translator_type
		invisibility_sound = mob_client.prefs.predator_invisibility_sound

	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yautja/hunter(new_human, translator_type, invisibility_sound, caster_material, clan_rank, bracer_material), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja/hunter/emissary(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja/hunter/emissary/camo_conforming(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja/hunter/knife/emissary/camo_conforming(new_human), WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/lmg/tactical(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(new_human), WEAR_WAIST)

	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/mre_food/clf/meatpie(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/incendiary(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/bracer_attachments/wristblades(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/bracer_attachments/shield(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BELT)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/medicomp/full(new_human), WEAR_L_STORE)
