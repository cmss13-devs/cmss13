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
		switch(SSmapping.configs[GROUND_MAP].camouflage_type)
			if("classic")
				selected_icon_state = "c_" + selected_icon_state
			if("jungle")
				selected_icon_state = "j_" + selected_icon_state
			if("desert")
				selected_icon_state = "d_" + selected_icon_state
			if("snow")
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
	name = "Undershirt (Tan)"
	icon_state = "t_undershirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/undershirt/black
	name = "Undershirt (Black)"
	icon_state = "b_undershirt"

/datum/sprite_accessory/undershirt/undershirt/sleeveless
	name = "Undershirt (Tan, Sleeveless)"
	icon_state = "t_undershirt_sleeveless"

/datum/sprite_accessory/undershirt/undershirt/sleeveless/black
	name = "Undershirt (Black, Sleeveless)"
	icon_state = "b_undershirt_sleeveless"

/datum/sprite_accessory/undershirt/undershirt/rolled
	name = "Undershirt (Tan, Rolled)"
	icon_state = "t_rolled_undershirt"

/datum/sprite_accessory/undershirt/undershirt/rolled_sleeveless
	name = "Undershirt (Tan, Rolled Sleeveless)"
	icon_state = "t_rolled_undershirt_sleeveless"

/datum/sprite_accessory/undershirt/undershirt/long
	name = "Undershirt (Tan, Long Sleeved)"
	icon_state = "t_long_undershirt"

/datum/sprite_accessory/undershirt/undershirt/long/black
	name = "Undershirt (Black, Long Sleeved)"
	icon_state = "b_long_undershirt"

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

/datum/sprite_accessory/undershirt/strapless_bra
	name = "Strapless Bra"
	icon_state = "strapless"
	gender = FEMALE
	camo_conforming = TRUE
