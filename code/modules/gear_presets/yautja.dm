/datum/equipment_preset/yautja
	name = "Yautja"
	idtype = null //No IDs for Yautja!
	languages = list(LANGUAGE_YAUTJA)
	rank = "Predator"
	faction = FACTION_YAUTJA
	faction_group = FACTION_LIST_YAUTJA
	uses_special_name = TRUE
	skills = /datum/skills/yautja/warrior

	minimap_icon = "predator"

	var/default_cape_type = "None"
	var/clan_rank

/datum/equipment_preset/yautja/load_race(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_species(SPECIES_YAUTJA)
	new_human.skin_color = "tan"
	new_human.body_type = "pred" //can be removed in future for body types
	if(!mob_client)
		mob_client = new_human.client
	if(mob_client?.prefs)
		new_human.h_style = mob_client.prefs.predator_h_style
		new_human.skin_color = mob_client.prefs.predator_skin_color

/datum/equipment_preset/yautja/load_id(mob/living/carbon/human/new_human)
	new_human.job = rank
	new_human.faction = faction
	new_human.faction_group = faction_group

/datum/equipment_preset/yautja/load_vanity(mob/living/carbon/human/new_human)
	return //No vanity items for Yautja!

/datum/equipment_preset/yautja/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	var/caster_material = "ebony"
	var/translator_type = "Modern"

	if(!mob_client)
		mob_client = new_human.client
	if(mob_client?.prefs)
		caster_material = mob_client.prefs.predator_caster_material
		translator_type = mob_client.prefs.predator_translator_type

	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yautja/hunter(new_human, translator_type, caster_material, clan_rank), WEAR_HANDS)

/datum/equipment_preset/yautja/load_name(mob/living/carbon/human/new_human, randomise)
	var/final_name = "Le'pro"
	new_human.gender = MALE
	new_human.age = 100
	new_human.flavor_text = ""
	new_human.flavor_texts["general"] = new_human.flavor_text

	if(new_human.client && new_human.client.prefs)
		new_human.gender = new_human.client.prefs.predator_gender
		new_human.age = new_human.client.prefs.predator_age
		final_name = new_human.client.prefs.predator_name
		new_human.flavor_text = new_human.client.prefs.predator_flavor_text
		new_human.flavor_texts["general"] = new_human.flavor_text
		if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
			final_name = "Le'pro"
	new_human.change_real_name(new_human, final_name)

// YOUNG BLOOD
/datum/equipment_preset/yautja/youngblood
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

/datum/equipment_preset/yautja/blooded/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(new_human), WEAR_L_EAR)
	return ..()


// ELITE
/datum/equipment_preset/yautja/elite
	name = "Yautja Elite"
	minimap_icon = "predator_elite"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	default_cape_type = PRED_YAUTJA_HALF_CAPE
	clan_rank = CLAN_RANK_ELITE_INT

/datum/equipment_preset/yautja/elite/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(new_human), WEAR_L_EAR)
	return ..()

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

/datum/equipment_preset/yautja/elder/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja/elder(new_human), WEAR_L_EAR)
	return ..()

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

/datum/equipment_preset/yautja/leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja/elder(new_human), WEAR_L_EAR)
	return ..()

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

/datum/equipment_preset/yautja/ancient/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja/elder(new_human), WEAR_L_EAR)
	return ..()
