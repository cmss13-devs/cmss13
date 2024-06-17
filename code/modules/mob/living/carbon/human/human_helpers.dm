

/mob/living/carbon/human/IsAdvancedToolUser()
	return species.has_fine_manipulation

/proc/get_gender_name(gender)
	var/g = "m"
	if (gender == FEMALE)
		g = "f"
	return g

/proc/get_limb_icon_name(datum/species/S, body_size, body_type, gender, limb_name, skin_color)
	if(S.uses_skin_color)
		if(S.special_body_types)
			switch(limb_name)
				if("torso")
					return "[skin_color]_torso_[body_size]_[body_type]"
				if("chest")
					return "[skin_color]_torso_[body_size]_[body_type]"
				if("head")
					return "[skin_color]_[limb_name]"
				if("groin")
					return "[skin_color]_[limb_name]_[body_size]"

		if(!S.special_body_types)
			switch(limb_name)
				if("torso")
					return "[skin_color]_torso_[body_type]_[get_gender_name(gender)]"
				if("chest")
					return "[skin_color]_torso_[body_type]_[get_gender_name(gender)]"
				if("head")
					return "[skin_color]_[limb_name]_[get_gender_name(gender)]"
				if("groin")
					return "[skin_color]_[limb_name]_[body_type]_[get_gender_name(gender)]"

		switch(limb_name)
			if("synthetic head")
				return "head_[get_gender_name(gender)]"
			if("r_arm")
				return "[skin_color]_right_arm"
			if("right arm")
				return "[skin_color]_right_arm"
			if("l_arm")
				return "[skin_color]_left_arm"
			if("left arm")
				return "[skin_color]_left_arm"
			if("r_leg")
				return "[skin_color]_right_leg"
			if("right leg")
				return "[skin_color]_right_leg"
			if("l_leg")
				return "[skin_color]_left_leg"
			if("left leg")
				return "[skin_color]_left_leg"
			if("r_hand")
				return "[skin_color]_right_hand"
			if("right hand")
				return "[skin_color]_right_hand"
			if("l_hand")
				return "[skin_color]_left_hand"
			if("left hand")
				return "[skin_color]_left_hand"
			if("r_foot")
				return "[skin_color]_right_foot"
			if("right foot")
				return "[skin_color]_right_foot"
			if("l_foot")
				return "[skin_color]_left_foot"
			if("left foot")
				return "[skin_color]_left_foot"

			else
				message_admins("DEBUG: Something called get_limb_icon_name() incorrectly, they use the name [limb_name]")
				return null
	else
		switch(limb_name)
			if ("torso")
				return "[limb_name]_[get_gender_name(gender)]"

			if ("chest")
				return "[limb_name]_[get_gender_name(gender)]"

			if ("head")
				return "[limb_name]_[get_gender_name(gender)]"

			if ("groin")
				return "[limb_name]_[get_gender_name(gender)]"

			if("synthetic head")
				return "head_[get_gender_name(gender)]"

			if ("r_arm")
				return "[limb_name]"

			if ("right arm")
				return "r_arm"

			if ("l_arm")
				return "[limb_name]"

			if ("left arm")
				return "l_arm"

			if ("r_leg")
				return "[limb_name]"

			if ("right leg")
				return "r_leg"

			if ("l_leg")
				return "[limb_name]"

			if ("left leg")
				return "l_leg"

			if ("r_hand")
				return "[limb_name]"

			if ("right hand")
				return "r_hand"

			if ("l_hand")
				return "[limb_name]"

			if ("left hand")
				return "l_hand"

			if ("r_foot")
				return "[limb_name]"

			if ("right foot")
				return "r_foot"

			if ("l_foot")
				return "[limb_name]"

			if ("left foot")
				return "l_foot"
			else
				message_admins("DEBUG: Something called get_limb_icon_name() incorrectly, they use the name [limb_name]")
				return null

/mob/living/carbon/human/proc/set_limb_icons()
	var/datum/skin_color/set_skin_color = GLOB.skin_color_list[skin_color]
	var/datum/body_size/set_body_size = GLOB.body_size_list[body_size]
	var/datum/body_type/set_body_type = GLOB.body_type_list[body_type]

	var/skin_color_icon
	var/body_size_icon
	var/body_type_icon

	if(!set_skin_color)
		skin_color_icon = "pale2"
	else
		skin_color_icon = set_skin_color.icon_name

	if(!set_body_size)
		body_size_icon = "avg"
	else
		body_size_icon = set_body_size.icon_name


	if(!set_body_type)
		body_type_icon = "lean"
	else
		body_type_icon = set_body_type.icon_name

	if(isspeciesyautja(src))
		skin_color_icon = skin_color
		body_size_icon = body_size
		body_type_icon = body_type

	for(var/obj/limb/L as anything in limbs)
		L.icon_name = get_limb_icon_name(species, body_size_icon, body_type_icon, gender, L.display_name, skin_color_icon)

/mob/living/carbon/human/can_inject(mob/user, error_msg, target_zone)
	if(species?.flags & IS_SYNTHETIC)
		if(user && error_msg)
			to_chat(user, SPAN_WARNING("[src] has no flesh to inject."))
		return FALSE
	. = TRUE
	if(!user)
		target_zone = pick("chest","chest","chest","left leg","right leg","left arm", "right arm", "head")
	else if(!target_zone)
		target_zone = user.zone_selected

	switch(target_zone)
		if("head")
			if(head && head.flags_inventory & NOPRESSUREDMAGE)
				. = 0
		else
			if(wear_suit && wear_suit.flags_inventory & NOPRESSUREDMAGE)
				. = 0
	if(!. && error_msg && user)
		// Might need re-wording.
		to_chat(user, SPAN_WARNING("There is no exposed flesh or thin material [target_zone == "head" ? "on their head" : "on their body"] to inject into."))


/mob/living/carbon/human/has_brain()
	var/datum/internal_organ/brain = LAZYACCESS(internal_organs_by_name, "brain")
	if(istype(brain))
		return TRUE
	return FALSE

/mob/living/carbon/human/has_eyes()
	var/datum/internal_organ/eyes = LAZYACCESS(internal_organs_by_name, "eyes")
	if(istype(eyes) && !eyes.cut_away)
		return TRUE
	return FALSE


/mob/living/carbon/human/is_mob_restrained(check_grab = TRUE)
	if(check_grab && pulledby && pulledby.grab_level >= GRAB_AGGRESSIVE)
		return TRUE
	if (handcuffed)
		return TRUE
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return TRUE

	if (HAS_TRAIT(src, TRAIT_NESTED))
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/disable_special_flags()
	status_flags |= CANPUSH
	anchored = FALSE

/mob/living/carbon/human/proc/disable_special_items()
	set waitfor = FALSE // Scout decloak animation uses sleep(), which is problematic for taser gun

	if(istype(back, /obj/item/storage/backpack/marine/satchel/scout_cloak))
		var/obj/item/storage/backpack/marine/satchel/scout_cloak/SC = back
		if(SC.camo_active)
			SC.deactivate_camouflage(src)
			return
	var/list/cont = contents_recursive()
	for(var/i in cont)
		if(istype(i, /obj/item/device/assembly/prox_sensor))
			var/obj/item/device/assembly/prox_sensor/prox = i
			if(prox.scanning)
				prox.toggle_scan()
		if(istype(i, /obj/item/device/motiondetector))
			var/obj/item/device/motiondetector/md = i
			md.toggle_active(src, old_active = TRUE, forced = TRUE)
		if(istype(i, /obj/item/weapon/gun/smartgun))
			var/obj/item/weapon/gun/smartgun/sg = i
			if(sg.motion_detector)
				sg.motion_detector = FALSE
				var/datum/action/item_action/smartgun/toggle_motion_detector/TMD = locate(/datum/action/item_action/smartgun/toggle_motion_detector) in sg.actions
				TMD.update_icon()
				sg.motion_detector()
		if(istype(i, /obj/item/clothing/suit/storage/marine/medium/rto/intel))
			var/obj/item/clothing/suit/storage/marine/medium/rto/intel/xm4 = i
			if(xm4.motion_detector)
				xm4.motion_detector = FALSE
				var/datum/action/item_action/intel/toggle_motion_detector/TMD = locate(/datum/action/item_action/intel/toggle_motion_detector) in xm4.actions
				TMD.update_icon()
				xm4.motion_detector()

/mob/living/carbon/human/proc/disable_headsets()
	//Disable all radios to reduce radio spam for dead people
	var/list/cont = contents_recursive()
	for(var/obj/item/device/radio/headset/h in cont)
		h.on = FALSE

/mob/living/carbon/human/proc/disable_lights(armor = 1, guns = 1, flares = 1, misc = 1)
	var/light_off = 0
	var/goes_out = 0
	if(armor)
		if(istype(wear_suit, /obj/item/clothing/suit/storage/marine))
			if(wear_suit.turn_light(src, toggle_on = FALSE))
				light_off++
		for(var/obj/item/clothing/head/helmet/marine/H in contents)
			for(var/obj/item/attachable/flashlight/FL in H.pockets)
				if(FL.activate_attachment(H, src, TRUE))
					light_off++
		for(var/obj/item/clothing/head/hardhat/headlamp in contents)
			if(headlamp.turn_light(src, toggle_on = FALSE))
				light_off++
	if(guns)
		for(var/obj/item/weapon/gun/G in contents)
			if(G.turn_off_light(src))
				light_off++
	if(flares)
		for(var/obj/item/device/flashlight/flare/F in contents)
			if(F.on) goes_out++
			F.turn_off(src)
	if(misc)
		for(var/obj/item/device/flashlight/L in contents)
			if(istype(L, /obj/item/device/flashlight/flare)) continue
			if(L.turn_off_light(src))
				light_off++
		for(var/obj/item/tool/weldingtool/W in contents)
			if(W.isOn())
				W.toggle()
				goes_out++
		for(var/obj/item/tool/match/M in contents)
			M.burn_out(src)
		for(var/obj/item/tool/lighter/Z in contents)
			if(Z.turn_off(src))
				goes_out++
	if(goes_out && light_off)
		to_chat(src, SPAN_NOTICE("Your sources of light short and fizzle out."))
	else if(goes_out)
		if(goes_out > 1)
			to_chat(src, SPAN_NOTICE("Your sources of light fizzle out."))
		else
			to_chat(src, SPAN_NOTICE("Your source of light fizzles out."))
	else if(light_off)
		if(light_off > 1)
			to_chat(src, SPAN_NOTICE("Your sources of light short out."))
		else
			to_chat(src, SPAN_NOTICE("Your source of light shorts out."))


/mob/living/carbon/human/a_intent_change(intent as num)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_INTENT_EYES) && (src.stat != DEAD)) //1st gen synths change eye color based on intent. But not when they're dead.
		switch(a_intent)
			if(INTENT_HELP) //Green, defalt
				r_eyes = 0
				g_eyes = 255
				b_eyes = 0
			if(INTENT_DISARM) //Blue
				r_eyes = 0
				g_eyes = 0
				b_eyes = 255
			if(INTENT_GRAB) //Orange, since yellow doesn't show at all!
				r_eyes = 248
				g_eyes = 243
				b_eyes = 43
			if(INTENT_HARM) //RED!
				r_eyes = 255
				g_eyes = 0
				b_eyes = 0
		update_body()

/mob/living/carbon/human/proc/is_bleeding()
	for(var/datum/effects/bleeding/external/B in effects_list)
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/is_bleeding_internal()
	for(var/datum/effects/bleeding/internal/B in effects_list)
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/get_broken_limbs()
	var/list/BL = list()
	for(var/obj/limb/L in limbs)
		if(L.status & LIMB_BROKEN)
			BL += L.display_name
	return BL

/mob/living/carbon/human/proc/has_broken_limbs()
	for(var/obj/limb/L in limbs)
		if(L.status & LIMB_BROKEN)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/has_splinted_limbs()
	for(var/obj/limb/L in limbs)
		if(L.status & LIMB_SPLINTED)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/has_foreign_object()
	for(var/obj/limb/L in limbs)
		if(L.implants && L.implants.len > 0)
			return TRUE
	for(var/obj/item/alien_embryo/A in contents)
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_tethering()
	for (var/datum/effects/tethering/TR in effects_list)
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_tethered()
	for (var/datum/effects/tethered/TD in effects_list)
		return TRUE
	return FALSE

/mob/living/carbon/human/get_role_name()
	return get_actual_job_name(src)

/mob/living/carbon/human/check_fire_intensity_resistance()
	return clothing_fire_intensity_resistance()

/mob/living/carbon/human/proc/clothing_fire_intensity_resistance()
	var/fire_intensity_resistance

	if(head && head.fire_intensity_resistance)
		fire_intensity_resistance += head.fire_intensity_resistance

	if(wear_suit && wear_suit.fire_intensity_resistance)
		fire_intensity_resistance += wear_suit.fire_intensity_resistance

	if(shoes && shoes.fire_intensity_resistance)
		fire_intensity_resistance += shoes.fire_intensity_resistance

	return fire_intensity_resistance

/mob/living/carbon/human/proc/get_type_in_ears(item_type)
	if(istype(wear_l_ear, item_type))
		return wear_l_ear
	if(istype(wear_r_ear, item_type))
		return wear_r_ear

/mob/living/carbon/human/proc/has_item_in_ears(item)
	return (item == wear_l_ear) || (item == wear_r_ear)

/mob/living/carbon/human/can_be_pulled_by(mob/M)
	var/ignores_stripdrag_flag = FALSE
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		ignores_stripdrag_flag = H.species.ignores_stripdrag_flag
	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY) && !ignores_stripdrag_flag && (stat == DEAD || health < HEALTH_THRESHOLD_CRIT) && !get_target_lock(M.faction_group))
		to_chat(M, SPAN_WARNING("You can't pull a crit or dead member of another faction!"))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/get_brute_mod()
	if(LAZYLEN(brute_mod_override))
		var/lowest_brute_mod = INFINITY
		for(var/thing in brute_mod_override)
			var/brute_mod = brute_mod_override[thing]
			if(brute_mod < lowest_brute_mod)
				lowest_brute_mod = brute_mod
		return lowest_brute_mod
	return species?.brute_mod

/mob/living/carbon/human/proc/get_burn_mod()
	if(LAZYLEN(burn_mod_override))
		var/lowest_burn_mod = INFINITY
		for(var/thing in burn_mod_override)
			var/burn_mod = burn_mod_override[thing]
			if(burn_mod < lowest_burn_mod)
				lowest_burn_mod = burn_mod
		return lowest_burn_mod
	return species?.burn_mod

/mob/living/carbon/human/proc/show_hud_tracker()
	if(hud_used && !hud_used.locate_leader.alpha)
		hud_used.locate_leader.alpha = 255
		hud_used.locate_leader.mouse_opacity = MOUSE_OPACITY_ICON

/mob/living/carbon/human/proc/hide_hud_tracker()
	if(hud_used && hud_used.locate_leader.alpha)
		hud_used.locate_leader.alpha = 0
		hud_used.locate_leader.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/mob/living/carbon/human/handle_blood_splatter(splatter_dir)
	species.handle_blood_splatter(src, splatter_dir)

/mob/living/carbon/human/alter_ghost(mob/dead/observer/ghost)
	ghost.vis_contents = vis_contents

/mob/living/carbon/human/get_orbit_size()
	return langchat_height

/mob/living/carbon/human/proc/update_minimap_icon()
	var/obj/item/device/radio/headset/headset
	if(istype(wear_l_ear, /obj/item/device/radio/headset))
		headset = wear_l_ear
	else if(istype(wear_r_ear, /obj/item/device/radio/headset))
		headset = wear_r_ear
	if(headset)
		headset.update_minimap_icon()
