GLOBAL_LIST_INIT_TYPED(undershirt_m, /datum/sprite_accessory/undershirt, setup_undershirt(MALE))
GLOBAL_LIST_INIT_TYPED(undershirt_f, /datum/sprite_accessory/undershirt, setup_undershirt(FEMALE))

/proc/setup_undershirt(restricted_gender)
	var/list/undershirt_list = list()
	for(var/undershirt_type in subtypesof(/datum/sprite_accessory/undershirt))
		var/datum/sprite_accessory/undershirt/undershirt_datum = new undershirt_type
		if(restricted_gender && undershirt_datum.gender != restricted_gender && (undershirt_datum.gender == MALE || undershirt_datum.gender == FEMALE))
			continue
		if(undershirt_datum.camo_conforming)
			undershirt_list["[undershirt_datum.name] (Camo Conforming)"] = undershirt_datum
			var/datum/sprite_accessory/undershirt/classic_datum = new undershirt_type
			classic_datum.generate_non_conforming("c")
			undershirt_list[classic_datum.name] = classic_datum
			var/datum/sprite_accessory/undershirt/jungle_datum = new undershirt_type
			jungle_datum.generate_non_conforming("j")
			undershirt_list[jungle_datum.name] = jungle_datum
			var/datum/sprite_accessory/undershirt/desert_datum = new undershirt_type
			desert_datum.generate_non_conforming("d")
			undershirt_list[desert_datum.name] = desert_datum
			var/datum/sprite_accessory/undershirt/snow_datum = new undershirt_type
			snow_datum.generate_non_conforming("s")
			undershirt_list[snow_datum.name] = snow_datum
		else
			undershirt_list[undershirt_datum.name] = undershirt_datum
	return undershirt_list

/datum/sprite_accessory/undershirt
	icon = 'icons/mob/humans/undershirt.dmi'
	var/camo_conforming = FALSE

/datum/sprite_accessory/undershirt/proc/get_image(mob_gender)
	var/selected_icon_state = icon_state
	if(camo_conforming)
		switch(SSmapping.configs[GROUND_MAP].map_name) // maploader TODO: json
			if(MAP_PRISON_STATION, MAP_PRISON_STATION_V3, MAP_LV522_CHANCES_CLAIM)
				selected_icon_state = "c_" + selected_icon_state
			if(MAP_LV_624, MAP_RUNTIME, MAP_NEW_VARADERO)
				selected_icon_state = "j_" + selected_icon_state
			if(MAP_WHISKEY_OUTPOST, MAP_DESERT_DAM, MAP_BIG_RED, MAP_KUTJEVO)
				selected_icon_state = "d_" + selected_icon_state
			if(MAP_CORSAT, MAP_SOROKYNE_STRATA, MAP_ICE_COLONY, MAP_ICE_COLONY_V3)
				selected_icon_state = "s_" + selected_icon_state
	if(gender == PLURAL)
		selected_icon_state += mob_gender == MALE ? "_m" : "_f"
	return image(icon, selected_icon_state)

/datum/sprite_accessory/undershirt/proc/generate_non_conforming(camo_key)
	camo_conforming = FALSE
	icon_state = "[camo_key]_[icon_state]"
	switch(camo_key)
		if("c")
			name += " (Classic)"
		if("j")
			name += " (Jungle)"
		if("d")
			name += " (Desert)"
		if("s")
			name += " (Snow)"

// Plural
/datum/sprite_accessory/undershirt/undershirt
	name = "Undershirt"
	icon_state = "undershirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/undershirt/sleeveless
	name = "Undershirt (Sleeveless)"
	icon_state = "undershirt_sleeveless"

/datum/sprite_accessory/undershirt/undershirt/rolled
	name = "Undershirt (Rolled)"
	icon_state = "rolled_undershirt"

/datum/sprite_accessory/undershirt/undershirt/rolled_sleeveless
	name = "Undershirt (Rolled Sleeveless)"
	icon_state = "rolled_undershirt_sleeveless"

// Male
/datum/sprite_accessory/undershirt/none
	name = "None"
	icon_state = "none"
	gender = MALE

// Female
/datum/sprite_accessory/undershirt/bra
	name = "Bra"
	icon_state = "classic"
	gender = FEMALE
	camo_conforming = TRUE

/datum/sprite_accessory/undershirt/sports_bra
	name = "Sports Bra"
	icon_state = "sports"
	gender = FEMALE
	camo_conforming = TRUE

/datum/sprite_accessory/undershirt/halter_top
	name = "Haltertop"
	icon_state = "halter"
	gender = FEMALE
	camo_conforming = TRUE

/datum/sprite_accessory/undershirt/strapless_bra
	name = "Strapless Bra"
	icon_state = "strapless"
	gender = FEMALE
	camo_conforming = TRUE
