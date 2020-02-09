//The mob should have a gender you want before running this proc. Will run fine without H
datum/preferences/proc/randomize_appearance(var/mob/living/carbon/human/H)
	if(H)
		if(H.gender == MALE)
			gender = MALE
		else
			gender = FEMALE

	ethnicity = random_ethnicity()
	body_type = random_body_type()

	h_style = random_hair_style(gender, species)
	f_style = random_facial_hair_style(gender, species)
	randomize_hair_color("hair")
	randomize_hair_color("facial")
	randomize_eyes_color()
	randomize_skin_color()
	underwear = rand(1,underwear_m.len)
	undershirt = rand(1,undershirt_t.len)
	backbag = 2
	age = rand(AGE_MIN,AGE_MAX)
	if(H)
		copy_appearance_to(H,1)

datum/preferences/proc/randomize_hair_color(var/target = "hair")
	if(prob (75) && target == "facial") // Chance to inherit hair color
		r_facial = r_hair
		g_facial = g_hair
		b_facial = b_hair
		return

	var/red
	var/green
	var/blue

	var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
	switch(col)
		if("blonde")
			red = 255
			green = 255
			blue = 0
		if("black")
			red = 0
			green = 0
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 51
		if("copper")
			red = 255
			green = 153
			blue = 0
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("wheat")
			red = 255
			green = 255
			blue = 153
		if("old")
			red = rand (100, 255)
			green = red
			blue = red
		if("punk")
			red = rand (0, 255)
			green = rand (0, 255)
			blue = rand (0, 255)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	switch(target)
		if("hair")
			r_hair = red
			g_hair = green
			b_hair = blue
		if("facial")
			r_facial = red
			g_facial = green
			b_facial = blue

datum/preferences/proc/randomize_eyes_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue



datum/preferences/proc/randomize_skin_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_skin = red
	g_skin = green
	b_skin = blue

var/global/list/preference_overlay_cache = list()

datum/preferences/proc/update_preview_icon()		//seriously. This is horrendous.
	if(updating_icon)
		return
	updating_icon = 1
	qdel(preview_icon_front)
	qdel(preview_icon_side)
	qdel(preview_icon)

	var/g = "m"
	if(gender == FEMALE)	g = "f"

	var/icon/icobase
	var/datum/species/current_species = all_species[species]

	if(current_species)
		icobase = current_species.icobase
	else
		icobase = 'icons/mob/humans/species/r_human.dmi'

	var/datum/ethnicity/E = ethnicities_list[ethnicity]
	var/datum/body_type/B = body_types_list[body_type]

	var/e_icon
	var/b_icon

	if (!E)
		e_icon = "western"
	else
		e_icon = E.icon_name

	if (!B)
		b_icon = "mesomorphic"
	else
		b_icon = B.icon_name

	preview_icon = new /icon(icobase, get_limb_icon_name(current_species, b_icon, gender, "torso", e_icon))

	var/pref_name = "BODY_[current_species.name]_[b_icon]_[e_icon]_[gender]"

	if(!preference_overlay_cache[pref_name])
		var/icon/body_icon = new /icon(icobase, get_limb_icon_name(current_species, b_icon, gender, "torso", e_icon))
		body_icon.Blend(new /icon(icobase, get_limb_icon_name(current_species, b_icon, gender, "groin", e_icon)), ICON_OVERLAY)
		body_icon.Blend(new /icon(icobase, get_limb_icon_name(current_species, b_icon, gender, "head", e_icon)), ICON_OVERLAY)

		for(var/name in list("r_arm","r_hand","r_leg","r_foot","l_leg","l_foot","l_arm","l_hand"))
			var/icon/temp = new /icon(icobase, get_limb_icon_name(current_species, b_icon, gender, "[name]", e_icon))
			body_icon.Blend(temp, ICON_OVERLAY)
		preference_overlay_cache[pref_name] = body_icon
		preview_icon.Blend(body_icon, ICON_OVERLAY)
	else
		preview_icon.Blend(preference_overlay_cache[pref_name], ICON_OVERLAY)

	var/eyes_name = "EYES_[h_style]_[(r_hair%32)]_[(g_hair%32)]_[(b_hair%32)]_[f_style]_[(r_facial%32)]_[(g_facial%32)]_[(b_facial%32)]"

	if(!preference_overlay_cache[eyes_name])
		var/icon/eyes_s = new/icon("icon" = 'icons/mob/humans/onmob/human_face.dmi', "icon_state" = current_species ? current_species.eyes : "eyes_s")
		eyes_s.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)

		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		if(hair_style)
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			eyes_s.Blend(hair_s, ICON_OVERLAY)

		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style)
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
			eyes_s.Blend(facial_s, ICON_OVERLAY)
		
		preference_overlay_cache[eyes_name] = eyes_s	
		preview_icon.Blend(eyes_s, ICON_OVERLAY)
	else
		preview_icon.Blend(preference_overlay_cache[eyes_name], ICON_OVERLAY)

	var/icon/underwear_s = null
	if(underwear > 0 && underwear < 5 && current_species.flags & HAS_UNDERWEAR)
		underwear_s = new/icon("icon" = 'icons/mob/humans/human.dmi', "icon_state" = "cryo[underwear]_[g]_s")

	var/icon/undershirt_s = null
	if(undershirt > 0 && undershirt < 5 && current_species.flags & HAS_UNDERWEAR)
		undershirt_s = new/icon("icon" = 'icons/mob/humans/human.dmi', "icon_state" = "cryoshirt[undershirt]_s")

	var/icon/clothes_s = null
	if(job_marines_low & ROLE_MARINE_STANDARD)
		if(preference_overlay_cache["ROLE_MARINE_STANDARD"])
			clothes_s = preference_overlay_cache["ROLE_MARINE_STANDARD"]
		else
			clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_jumpsuit")
			clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "bgloves"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "lamp-off"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "2"), ICON_OVERLAY)
			clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "helmet"), ICON_OVERLAY)
			clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "marinebelt"), ICON_OVERLAY)
			preference_overlay_cache["ROLE_MARINE_STANDARD"] = clothes_s

	else if(job_marines_high)//I hate how this looks, but there's no reason to go through this switch if it's empty
		switch(job_marines_high)
			if(ROLE_MARINE_STANDARD)
				if(preference_overlay_cache["ROLE_MARINE_STANDARD"])
					clothes_s = preference_overlay_cache["ROLE_MARINE_STANDARD"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "lamp-off"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "2"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "marinebelt"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_MARINE_STANDARD"] = clothes_s
			if(ROLE_MARINE_ENGINEER)
				if(preference_overlay_cache["ROLE_MARINE_ENGINEER"])
					clothes_s = preference_overlay_cache["ROLE_MARINE_ENGINEER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_engineer")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lightbrowngloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "lamp-off"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "6"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "meson"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "utility"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinepack_techi"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_MARINE_ENGINEER"] = clothes_s
				
			if(ROLE_MARINE_LEADER)
				if(preference_overlay_cache["ROLE_MARINE_LEADER"])
					clothes_s = preference_overlay_cache["ROLE_MARINE_LEADER"]
				else					
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "lamp-off"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "7"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "marinebelt"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_MARINE_LEADER"] = clothes_s

			if(ROLE_MARINE_MEDIC)
				if(preference_overlay_cache["ROLE_MARINE_MEDIC"])
					clothes_s = preference_overlay_cache["ROLE_MARINE_MEDIC"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_medic")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "lamp-off"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "1"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "healthhud"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinepack_medic"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "medicbag"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_MARINE_MEDIC"] = clothes_s
				
			if(ROLE_MARINE_SPECIALIST)
				if(preference_overlay_cache["ROLE_MARINE_SPECIALIST"])
					clothes_s = preference_overlay_cache["ROLE_MARINE_SPECIALIST"]
				else					
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "lamp-off"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "2"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "spec"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinepack"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "marinebelt"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_MARINE_SPECIALIST"] = clothes_s

			if(ROLE_MARINE_SMARTGUN)
				if(preference_overlay_cache["ROLE_MARINE_SMARTGUN"])
					clothes_s = preference_overlay_cache["ROLE_MARINE_SMARTGUN"]
				else					
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "lamp-off"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "8"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "m56_goggles"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "powerpack"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "marinebelt"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_MARINE_SMARTGUN"] = clothes_s

	else if(job_command_high)
		switch(job_command_high)
			if(ROLE_COMMANDING_OFFICER)
				if(preference_overlay_cache["ROLE_COMMANDING_OFFICER"])
					clothes_s = preference_overlay_cache["ROLE_COMMANDING_OFFICER"]
				else					
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "CO_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "laceups"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "egloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_0.dmi', "centcomcaptain"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "m4a3_holster_g"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_COMMANDING_OFFICER"] = clothes_s

			if(ROLE_BRIDGE_OFFICER)
				if(preference_overlay_cache["ROLE_BRIDGE_OFFICER"])
					clothes_s = preference_overlay_cache["ROLE_BRIDGE_OFFICER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "BO_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "rocap"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "m4a3_holster_g"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_BRIDGE_OFFICER"] = clothes_s


			if(ROLE_EXECUTIVE_OFFICER)
				if(preference_overlay_cache["ROLE_EXECUTIVE_OFFICER"])
					clothes_s = preference_overlay_cache["ROLE_EXECUTIVE_OFFICER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "XO_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "cap"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "m44_holster_g"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_EXECUTIVE_OFFICER"] = clothes_s

			if(ROLE_PILOT_OFFICER)
				if(preference_overlay_cache["ROLE_PILOT_OFFICER"])
					clothes_s = preference_overlay_cache["ROLE_PILOT_OFFICER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "pilot_flightsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lightbrowngloves"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "pilot"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "sun"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "helmetp"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "m4a3_holster"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_PILOT_OFFICER"] = clothes_s
					
			if(ROLE_CORPORATE_LIAISON)
				if(preference_overlay_cache["ROLE_CORPORATE_LIAISON"])
					clothes_s = preference_overlay_cache["ROLE_CORPORATE_LIAISON"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "liaison_regular")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "laceups"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "satchel"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_CORPORATE_LIAISON"] = clothes_s
				
			if(ROLE_SYNTHETIC)
				if(preference_overlay_cache["ROLE_SYNTHETIC"])
					clothes_s = preference_overlay_cache["ROLE_SYNTHETIC"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "E_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "laceups"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_SYNTHETIC"] = clothes_s
					
			if(ROLE_MILITARY_POLICE)
				if(preference_overlay_cache["ROLE_MILITARY_POLICE"])
					clothes_s = preference_overlay_cache["ROLE_MILITARY_POLICE"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "MP_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "mp"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "beretred"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "sunhud"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "securitypack"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "security"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_MILITARY_POLICE"] = clothes_s
				
			if(ROLE_CHIEF_MP)
				if(preference_overlay_cache["ROLE_CHIEF_MP"])
					clothes_s = preference_overlay_cache["ROLE_CHIEF_MP"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "WO_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "warrant_officer"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "beretwo"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "sunhud"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "securitypack"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "security"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_CHIEF_MP"] = clothes_s
				
			if(ROLE_CREWMAN)
				if(preference_overlay_cache["ROLE_CREWMAN"])
					clothes_s = preference_overlay_cache["ROLE_CREWMAN"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_tanker")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lightbrowngloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "tanker"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "tanker_helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "m4a3_holster"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_CREWMAN"] = clothes_s
					
			if(ROLE_INTEL_OFFICER)
				if(preference_overlay_cache["ROLE_INTEL_OFFICER"])
					clothes_s = preference_overlay_cache["ROLE_INTEL_OFFICER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "BO_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "rocap"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "m4a3_holster_g"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_1.dmi', "officer"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_INTEL_OFFICER"] = clothes_s

			if(ROLE_SEA)
				if(preference_overlay_cache["ROLE_SEA"])
					clothes_s = preference_overlay_cache["ROLE_SEA"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "BO_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "drillhat"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "m4a3_holster_g"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_SEA"] = clothes_s

	else if(job_engi_high)
		switch(job_engi_high)
			if(ROLE_CHIEF_ENGINEER)
				if(preference_overlay_cache["ROLE_CHIEF_ENGINEER"])
					clothes_s = preference_overlay_cache["ROLE_CHIEF_ENGINEER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "EC_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lightbrowngloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "utility"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_CHIEF_ENGINEER"] = clothes_s
				
			if(ROLE_MAINTENANCE_TECH)
				if(preference_overlay_cache["ROLE_MAINTENANCE_TECH"])
					clothes_s = preference_overlay_cache["ROLE_MAINTENANCE_TECH"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "E_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lightbrowngloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "utility"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_MAINTENANCE_TECH"] = clothes_s
				
			if(ROLE_REQUISITION_OFFICER)
				if(preference_overlay_cache["ROLE_REQUISITION_OFFICER"])
					clothes_s = preference_overlay_cache["ROLE_REQUISITION_OFFICER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "RO_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lightbrowngloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "cargocap"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "m44_holster_g"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_REQUISITION_OFFICER"] = clothes_s
				
			if(ROLE_REQUISITION_TECH)
				if(preference_overlay_cache["ROLE_REQUISITION_TECH"])
					clothes_s = preference_overlay_cache["ROLE_REQUISITION_TECH"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "cargotech")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lightbrowngloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_1.dmi', "band2"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "utility"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_REQUISITION_TECH"] = clothes_s
				
	else if(job_medsci_high)
		switch(job_medsci_high)
			if(ROLE_CHIEF_MEDICAL_OFFICER)
				if(preference_overlay_cache["ROLE_CHIEF_MEDICAL_OFFICER"])
					clothes_s = preference_overlay_cache["ROLE_CHIEF_MEDICAL_OFFICER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "cmo")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "laceups"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_0.dmi', "labcoatg"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "healthhud"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "electronic"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_CHIEF_MEDICAL_OFFICER"] = clothes_s
				
			if(ROLE_CIVILIAN_DOCTOR)
				if(preference_overlay_cache["ROLE_CIVILIAN_DOCTOR"])
					clothes_s = preference_overlay_cache["ROLE_CIVILIAN_DOCTOR"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "scrubsgreen")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_0.dmi', "labcoat_open"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "healthhud"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/head_0.dmi', "surgcap_green"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "electronic"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_CIVILIAN_DOCTOR"] = clothes_s

				
			if(ROLE_CIVILIAN_RESEARCHER)
				if(preference_overlay_cache["ROLE_CIVILIAN_RESEARCHER"])
					clothes_s = preference_overlay_cache["ROLE_CIVILIAN_RESEARCHER"]
				else
					clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "research_jumpsuit")
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "laceups"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/hands.dmi', "lgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/suit_0.dmi', "labcoat_open"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/ears.dmi', "headset"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/eyes.dmi', "healthhud"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/back.dmi', "marinesatch"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/humans/onmob/belt.dmi', "electronic"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mob.dmi', "card-id"), ICON_OVERLAY)
					preference_overlay_cache["ROLE_CIVILIAN_RESEARCHER"] = clothes_s

	if(underwear_s && !clothes_s)
		preview_icon.Blend(underwear_s, ICON_OVERLAY)
	if(undershirt_s && !clothes_s)
		preview_icon.Blend(undershirt_s, ICON_OVERLAY)
	if(clothes_s)
		preview_icon.Blend(clothes_s, ICON_OVERLAY)
	preview_icon_front = new(preview_icon, dir = SOUTH)
	preview_icon_side = new(preview_icon, dir = WEST)

	qdel(underwear_s)
	qdel(undershirt_s)
	updating_icon = 0
