/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
	TODO: Proper documentation
	icon_key is [species.race_key][g][husk][fat][hulk][skeleton][ethnicity]
*/
GLOBAL_LIST_EMPTY(human_icon_cache)
GLOBAL_LIST_EMPTY(tail_icon_cache)

/proc/overlay_image(icon, icon_state, color, flags)
	var/image/ret = image(icon,icon_state)
	var/mutable_appearance/MA = new(ret)
	MA.color = color
	MA.appearance_flags = flags
	ret.appearance = MA
	return ret

/*
	Global associative list for caching uniform masks.
	Each index is just 0 or 1 for not removed and removed (as in previously delimbed).
*/
GLOBAL_LIST_EMPTY(uniform_mask_cache)

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*

Another feature of this new system is that our lists are indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated! This is the main saving for this system.

In practice this means that:
	Everytime you do something minor like take a pen out of your pocket, we only update the in-hand overlay
	etc...


There are several things that need to be remembered:

> Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the relevant update_inv_* proc:
		update_inv_head()
		update_inv_wear_suit()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_w_uniform()
		update_inv_glasse()
		update_inv_l_hand()
		update_inv_r_hand()
		update_inv_belt()
		update_inv_wear_id()
		update_inv_ears()
		update_inv_s_store()
		update_inv_pockets()
		update_inv_back()
		update_inv_handcuffed()
		update_inv_wear_mask()

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	corgi etc. Instead, it'll just return without doing any work. So no harm in calling it for corgis and such.


> There are also these special cases:
		UpdateDamageIcon() //handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_body() //Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair() //Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)
		update_targeted() // Updates the target overlay when someone points a gun at you

> If you need to update all overlays you can use regenerate_icons(). it works exactly like update_clothing used to.


*/

/mob/living/carbon/human/apply_overlay(cache_index)
	var/image/images = overlays_standing[cache_index]

	if(!images)
		return

	SEND_SIGNAL(src, COMSIG_HUMAN_OVERLAY_APPLIED, cache_index, images)
	overlays += images

/mob/living/carbon/human/remove_overlay(cache_index)
	if(overlays_standing[cache_index])
		var/image/I = overlays_standing[cache_index]
		SEND_SIGNAL(src, COMSIG_HUMAN_OVERLAY_REMOVED, cache_index, I)
		overlays -= I
		overlays_standing[cache_index] = null

/mob/living/carbon/human/UpdateDamageIcon()
	for(var/obj/limb/O in limbs)
		if(!(O.status & LIMB_DESTROYED))
			O.update_icon()

/mob/proc/AddSleepingIcon()
	return

/mob/living/carbon/human/AddSleepingIcon()
	var/image/SL
	SL = new /image('icons/mob/hud/hud.dmi', "slept_icon")
	overlays += SL

/mob/proc/RemoveSleepingIcon()
	return

/mob/living/carbon/human/RemoveSleepingIcon()
	var/image/SL
	SL = new /image('icons/mob/hud/hud.dmi', "slept_icon")
	overlays -= SL

//BASE MOB SPRITE
/mob/living/carbon/human/proc/update_body()
	update_leg_status() // Not icon ops, but placed here due to lack of a non-icons update_body

	appearance_flags |= KEEP_TOGETHER // sanity

	update_damage_overlays()

	var/list/needs_update = list()
	for(var/obj/limb/part as anything in limbs)
		part.update_limb()

		var/old_key = icon_render_keys?[part.icon_name]
		icon_render_keys[part.icon_name] = part.get_limb_icon_key()
		if(icon_render_keys[part.icon_name] == old_key)
			continue

		needs_update += part

	var/list/new_limbs = list()
	for(var/obj/limb/part as anything in limbs)
		if(part in needs_update)
			var/bodypart_icon = part.get_limb_icon()
			new_limbs += bodypart_icon
			icon_render_image_cache[icon_render_keys[part.icon_name]] = bodypart_icon
		else
			new_limbs += icon_render_image_cache[icon_render_keys[part.icon_name]]

	remove_overlay(BODYPARTS_LAYER)
	overlays_standing[BODYPARTS_LAYER] = new_limbs
	apply_overlay(BODYPARTS_LAYER)

	if(species.flags & HAS_UNDERWEAR)
		//Underwear
		remove_overlay(UNDERSHIRT_LAYER)
		remove_overlay(UNDERWEAR_LAYER)

		var/datum/sprite_accessory/underwear/underwear_datum = gender == MALE ? GLOB.underwear_m[underwear] : GLOB.underwear_f[underwear]
		var/image/underwear_icon = underwear_datum.get_image(gender)
		underwear_icon.layer = -UNDERWEAR_LAYER
		overlays_standing[UNDERWEAR_LAYER] = underwear_icon
		apply_overlay(UNDERWEAR_LAYER)

		var/datum/sprite_accessory/underwear/undershirt_datum = gender == MALE ? GLOB.undershirt_m[undershirt] : GLOB.undershirt_f[undershirt]
		var/image/undershirt_icon = undershirt_datum.get_image(gender)
		undershirt_icon.layer = -UNDERSHIRT_LAYER
		overlays_standing[UNDERSHIRT_LAYER] = undershirt_icon
		apply_overlay(UNDERSHIRT_LAYER)

/// Recalculates and reapplies damage overlays to every limb
/mob/living/carbon/human/proc/update_damage_overlays()
	remove_overlay(DAMAGE_LAYER)

	var/list/damage_overlays = list()
	for(var/obj/limb/part as anything in limbs)
		if(part.status & LIMB_DESTROYED)
			continue

		damage_overlays += part.get_damage_overlays()

	overlays_standing[DAMAGE_LAYER] = damage_overlays

	apply_overlay(DAMAGE_LAYER)

/mob/living/carbon/human/proc/remove_underwear() // :flushed: - geeves
	remove_overlay(UNDERSHIRT_LAYER)
	remove_overlay(UNDERWEAR_LAYER)

//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair()
	remove_overlay(HAIR_GRADIENT_LAYER)
	remove_overlay(HAIR_LAYER)
	remove_overlay(FACIAL_LAYER)

	var/obj/limb/head/head_organ = get_limb("head")
	if(!head_organ || (head_organ.status & LIMB_DESTROYED))
		return

	if((head && (head.flags_inv_hide & HIDEALLHAIR)) || (wear_mask && (wear_mask.flags_inv_hide & HIDEALLHAIR)))
		return

	if(f_style && !(wear_mask && (wear_mask.flags_inv_hide & HIDELOWHAIR)))
		var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (species.name in facial_hair_style.species_allowed))
			var/image/facial_s = new/image("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			facial_s.layer = -FACIAL_LAYER
			if(facial_hair_style.do_coloration)
				facial_s.color = list(null, null, null, null, rgb(r_facial, g_facial, b_facial))
			overlays_standing[FACIAL_LAYER] = facial_s
			apply_overlay(FACIAL_LAYER)

	if(h_style && !(head && head.flags_inv_hide & HIDETOPHAIR))
		var/datum/sprite_accessory/hair_style = species.get_hairstyle(h_style)
		if(hair_style && (species.name in hair_style.species_allowed))
			var/image/hair_s = new/image("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			hair_s.layer = -HAIR_LAYER
			if(hair_style.do_coloration)
				hair_s.color = list(null, null, null, null, rgb(r_hair, g_hair, b_hair))

			if(grad_style)
				var/datum/sprite_accessory/hair_gradient_style = GLOB.hair_gradient_list[grad_style]
				if(hair_gradient_style?.icon_state && (species.name in hair_gradient_style.species_allowed))
					var/image/gradient_overlay = new/image("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
					var/icon/temp = icon(hair_gradient_style.icon, hair_gradient_style.icon_state)
					var/icon/temp_hair = icon(hair_style.icon, "[hair_style.icon_state]_s")
					temp_hair.Blend(temp, ICON_SUBTRACT)
					gradient_overlay.icon = temp_hair
					gradient_overlay.layer = -HAIR_GRADIENT_LAYER
					gradient_overlay.color = list(null, null, null, null, rgb(r_gradient, g_gradient, b_gradient))
					overlays_standing[HAIR_GRADIENT_LAYER] = gradient_overlay
					apply_overlay(HAIR_GRADIENT_LAYER)

			overlays_standing[HAIR_LAYER] = hair_s
			apply_overlay(HAIR_LAYER)

//Call when someone is gauzed or splinted, or when one of those items are removed
/mob/living/carbon/human/update_med_icon()
	remove_overlay(MEDICAL_LAYER)

	var/icon/standing = new /icon('icons/mob/humans/onmob/med_human.dmi', "blank")

	var/image/standing_image = image(icon = standing)

	// blend the individual damage states with our icons
	for(var/obj/limb/L in limbs)
		for(var/datum/wound/W in L.wounds)
			if(W.bandaged & WOUND_BANDAGED)
				if(!W.bandaged_icon)
					var/bandaged_icon_name = "gauze_[L.icon_name]"
					if(L.bandage_icon_amount > 1)
						bandaged_icon_name += "_[rand(1, L.bandage_icon_amount)]"
					W.bandaged_icon = new /icon('icons/mob/humans/onmob/med_human.dmi', "[bandaged_icon_name]")
				standing_image.overlays += W.bandaged_icon
		if(L.status & LIMB_SPLINTED)
			if(!L.splinted_icon)
				var/splinted_icon_name = "splint_[L.icon_name]"
				if(L.splint_icon_amount > 1)
					splinted_icon_name += "_[rand(1, L.splint_icon_amount)]"
				L.splinted_icon = new /icon('icons/mob/humans/onmob/med_human.dmi', "[splinted_icon_name]")
			standing_image.overlays += L.splinted_icon
		else
			L.splinted_icon = null

	if(standing_image)
		standing_image.layer = -MEDICAL_LAYER
		overlays_standing[MEDICAL_LAYER] = standing_image
		apply_overlay(MEDICAL_LAYER)



/**Handles headshot images. These render above hair and below hats/helmets. Must be given a headshot_state or it just removes the overlay.
Applied by gun suicide and high impact bullet executions, removed by rejuvenate, since such people are otherwise unrevivable.**/
/mob/living/carbon/human/proc/update_headshot_overlay(headshot_state)
	remove_overlay(HEADSHOT_LAYER)

	if(!headshot_state)
		return

	var/obj/limb/head/head_organ = get_limb("head")
	if(!head_organ || (head_organ.status & LIMB_DESTROYED))
		return

	var/image/headshot = new('icons/mob/humans/dam_human.dmi', headshot_state + "_bone")
	var/image/headshot_blood = new('icons/mob/humans/dam_human.dmi', headshot_state + "_blood")
	headshot_blood.color = species.blood_color
	headshot.overlays += headshot_blood

	headshot.appearance_flags = RESET_COLOR
	headshot.blend_mode = BLEND_INSET_OVERLAY
	headshot.layer = -HEADSHOT_LAYER
	overlays_standing[HEADSHOT_LAYER] = headshot
	apply_overlay(HEADSHOT_LAYER)



/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	if(monkeyizing)
		return
	update_inv_w_uniform()
	update_inv_wear_id()
	update_inv_gloves()
	update_inv_glasses()
	update_inv_ears()
	update_inv_shoes()
	update_inv_s_store()
	update_inv_wear_mask()
	update_inv_head()
	update_inv_belt()
	update_inv_back()
	update_inv_wear_suit()
	update_inv_r_hand()
	update_inv_l_hand()
	update_inv_handcuffed()
	update_inv_legcuffed()
	update_inv_pockets()
	update_fire()
	update_burst()
	update_hair()
	update_body()
	update_targeted()
	update_med_icon()
	UpdateDamageIcon()




/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform()
	remove_overlay(UNIFORM_LAYER)
	if(w_uniform)
		if(client && hud_used && hud_used.hud_shown && hud_used.inventory_shown && hud_used.ui_datum)
			client.add_to_screen(w_uniform)
			w_uniform.screen_loc = hud_used.ui_datum.hud_slot_offset(w_uniform, hud_used.ui_datum.ui_iclothing)

		if(!(wear_suit && wear_suit.flags_inv_hide & HIDEJUMPSUIT))
			var/image/I = w_uniform.get_mob_overlay(src, WEAR_BODY)
			I.layer = -UNIFORM_LAYER
			overlays_standing[UNIFORM_LAYER] = I
			apply_overlay(UNIFORM_LAYER)

	update_inv_wear_id()


/mob/living/carbon/human/update_inv_wear_id()
	remove_overlay(ID_LAYER)
	if(!wear_id)
		return
	if(client && hud_used && hud_used.hud_shown && hud_used.ui_datum)
		client.add_to_screen(wear_id)
		wear_id.screen_loc = hud_used.ui_datum.hud_slot_offset(wear_id, hud_used.ui_datum.ui_id)

	var/obj/item/card/id/card = get_idcard()
	if(!card)
		return
	if(!card.pinned_on_uniform || (w_uniform && w_uniform.displays_id && !(w_uniform.flags_jumpsuit & UNIFORM_JACKET_REMOVED)))
		var/image/id_overlay = card.get_mob_overlay(src, WEAR_ID)
		id_overlay.layer = -ID_LAYER
		overlays_standing[ID_LAYER] = id_overlay
		apply_overlay(ID_LAYER)

/mob/living/carbon/human/update_inv_gloves()
	remove_overlay(GLOVES_LAYER)
	var/image/I
	if(gloves)
		if(client && hud_used && hud_used.hud_shown && hud_used.inventory_shown && hud_used.ui_datum)
			client.add_to_screen(gloves)
			gloves.screen_loc = hud_used.ui_datum.hud_slot_offset(gloves, hud_used.ui_datum.ui_gloves)

		if(!(wear_suit && wear_suit.flags_inv_hide & HIDEGLOVES))
			I = gloves.get_mob_overlay(src, WEAR_HANDS)

	else if(hands_blood_color && species.blood_mask)
		I = overlay_image(species.blood_mask, "hands_blood", hands_blood_color, RESET_COLOR)

	if(!I)
		return
	I.layer = -GLOVES_LAYER
	overlays_standing[GLOVES_LAYER] = I
	apply_overlay(GLOVES_LAYER)

/mob/living/carbon/human/update_inv_glasses()
	remove_overlay(GLASSES_LAYER)
	if(glasses)
		if(client && hud_used &&  hud_used.hud_shown && hud_used.inventory_shown && hud_used.ui_datum)
			client.add_to_screen(glasses)
			glasses.screen_loc = hud_used.ui_datum.hud_slot_offset(glasses, hud_used.ui_datum.ui_glasses)

		var/image/I = glasses.get_mob_overlay(src, WEAR_EYES)
		I.layer = -GLASSES_LAYER
		overlays_standing[GLASSES_LAYER] = I
		apply_overlay(GLASSES_LAYER)



/mob/living/carbon/human/update_inv_ears()
	remove_overlay(EARS_LAYER)
	if(wear_l_ear || wear_r_ear)
		if(client && hud_used && hud_used.hud_shown && hud_used.inventory_shown && hud_used.ui_datum)
			if(wear_l_ear)
				client.add_to_screen(wear_l_ear)
			if(wear_r_ear)
				client.add_to_screen(wear_r_ear)
			wear_l_ear?.screen_loc = hud_used.ui_datum.hud_slot_offset(wear_l_ear, hud_used.ui_datum.ui_wear_l_ear)
			wear_r_ear?.screen_loc = hud_used.ui_datum.hud_slot_offset(wear_r_ear, hud_used.ui_datum.ui_wear_r_ear)

		var/image/standing_image = image('icons/mob/humans/onmob/med_human.dmi', icon_state = "blank", layer = -EARS_LAYER)

		standing_image.overlays +=  wear_l_ear?.get_mob_overlay(src, WEAR_L_EAR)
		standing_image.overlays +=  wear_r_ear?.get_mob_overlay(src, WEAR_R_EAR)

		overlays_standing[EARS_LAYER] = standing_image
		apply_overlay(EARS_LAYER)



/mob/living/carbon/human/update_inv_shoes()
	remove_overlay(SHOES_LAYER)
	var/image/I
	if(shoes)
		if(client && hud_used && hud_used.hud_shown && hud_used.inventory_shown && hud_used.ui_datum)
			client.add_to_screen(shoes)
			shoes.screen_loc = hud_used.ui_datum.hud_slot_offset(shoes, hud_used.ui_datum.ui_shoes)

		if(!((wear_suit && wear_suit.flags_inv_hide & HIDESHOES) || (w_uniform && w_uniform.flags_inv_hide & HIDESHOES)))
			I =  shoes.get_mob_overlay(src, WEAR_FEET)

	else if(feet_blood_color && species.blood_mask)
		I = overlay_image(species.blood_mask, "feet_blood", feet_blood_color, RESET_COLOR)
	if(!I)
		return
	I.layer = -SHOES_LAYER
	overlays_standing[SHOES_LAYER] = I
	apply_overlay(SHOES_LAYER)


/mob/living/carbon/human/update_inv_s_store()
	remove_overlay(SUIT_STORE_LAYER)
	if(s_store)
		if(client && hud_used && hud_used.hud_shown && hud_used.ui_datum)
			client.add_to_screen(s_store)
			s_store.screen_loc = hud_used.ui_datum.hud_slot_offset(s_store, hud_used.ui_datum.ui_sstore1)

		var/image/I = s_store.get_mob_overlay(src, WEAR_J_STORE)
		I.layer = -SUIT_STORE_LAYER
		overlays_standing[SUIT_STORE_LAYER] = I
		apply_overlay(SUIT_STORE_LAYER)


#define MAX_HEAD_GARB_ITEMS 5

/mob/living/carbon/human/update_inv_head()
	remove_overlay(HEAD_LAYER)
	remove_overlay(HEAD_SQUAD_LAYER)
	for(var/i in HEAD_GARB_LAYER to (HEAD_GARB_LAYER + MAX_HEAD_GARB_ITEMS - 1))
		remove_overlay(i)

	if(head)

		if(client && hud_used && hud_used.hud_shown && hud_used.inventory_shown && hud_used.ui_datum)
			client.add_to_screen(head)
			head.screen_loc = hud_used.ui_datum.hud_slot_offset(head, hud_used.ui_datum.ui_head)

		var/image/I = head.get_mob_overlay(src, WEAR_HEAD)
		I.layer = -HEAD_LAYER
		overlays_standing[HEAD_LAYER] = I
		apply_overlay(HEAD_LAYER)

		if(istype(head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/marine_helmet = head
			if(assigned_squad && marine_helmet.flags_marine_helmet & HELMET_SQUAD_OVERLAY)
				if(assigned_squad && assigned_squad.equipment_color && assigned_squad.use_stripe_overlay)
					var/leader = assigned_squad.squad_leader
					var/image/helmet_overlay = image(marine_helmet.helmet_overlay_icon, icon_state = "std-helmet")
					if(leader == src)
						helmet_overlay = image(marine_helmet.helmet_overlay_icon, icon_state = "sql-helmet")
					helmet_overlay.layer = -HEAD_SQUAD_LAYER
					helmet_overlay.alpha = assigned_squad.armor_alpha
					helmet_overlay.color = assigned_squad.equipment_color
					overlays_standing[HEAD_SQUAD_LAYER] = helmet_overlay
					apply_overlay(HEAD_SQUAD_LAYER)

			var/num_helmet_overlays = 0
			for(var/i in 1 to length(marine_helmet.helmet_overlays))
				// Add small numbers to the head garb layer so we don't have a layer conflict
				// the i-1 bit is to make it 0-based, not 1-based like BYOND wants
				overlays_standing[HEAD_GARB_LAYER + (i-1)] = image('icons/mob/humans/onmob/helmet_garb.dmi', src, marine_helmet.helmet_overlays[i])
				num_helmet_overlays++

			// null out the rest of the space allocated for helmet overlays
			// God I hate 1-based indexing
			for(var/i in num_helmet_overlays+1 to MAX_HEAD_GARB_ITEMS)
				overlays_standing[HEAD_GARB_LAYER + (i-1)] = null

			for(var/i in HEAD_GARB_LAYER to (HEAD_GARB_LAYER + MAX_HEAD_GARB_ITEMS - 1))
				apply_overlay(i)

#undef MAX_HEAD_GARB_ITEMS


/mob/living/carbon/human/update_inv_belt()
	remove_overlay(BELT_LAYER)
	if(!belt)
		return
	if(client && hud_used && hud_used.hud_shown && hud_used.ui_datum)
		client.add_to_screen(belt)
		belt.screen_loc = hud_used.ui_datum.hud_slot_offset(belt, hud_used.ui_datum.ui_belt)

	var/image/I = belt.get_mob_overlay(src, WEAR_WAIST)
	I.layer = -BELT_LAYER
	overlays_standing[BELT_LAYER] = I
	apply_overlay(BELT_LAYER)



/mob/living/carbon/human/update_inv_wear_suit()
	remove_overlay(SUIT_LAYER)
	remove_overlay(SUIT_SQUAD_LAYER)
	remove_overlay(SUIT_GARB_LAYER)

	if(wear_suit)
		if(client && hud_used && hud_used.hud_shown && hud_used.inventory_shown && hud_used.ui_datum)
			client.add_to_screen(wear_suit)
			wear_suit.screen_loc = hud_used.ui_datum.hud_slot_offset(wear_suit, hud_used.ui_datum.ui_oclothing)

		var/image/I = wear_suit.get_mob_overlay(src, WEAR_JACKET)
		I.layer = -SUIT_LAYER
		overlays_standing[SUIT_LAYER] = I
		apply_overlay(SUIT_LAYER)

		if(istype(wear_suit, /obj/item/clothing/suit/storage/marine))
			var/obj/item/clothing/suit/storage/marine/marine_armor = wear_suit
			if(marine_armor.flags_marine_armor & ARMOR_SQUAD_OVERLAY)
				if(assigned_squad && assigned_squad.equipment_color && assigned_squad.use_stripe_overlay)
					var/leader = assigned_squad.squad_leader
					var/image/squad_overlay = image(marine_armor.squad_overlay_icon, icon_state = "std-armor")
					if(leader == src)
						squad_overlay = image(marine_armor.squad_overlay_icon, icon_state = "sql-armor")
					squad_overlay.layer = -SUIT_SQUAD_LAYER
					squad_overlay.alpha = assigned_squad.armor_alpha
					squad_overlay.color = assigned_squad.equipment_color
					overlays_standing[SUIT_SQUAD_LAYER] = squad_overlay
					apply_overlay(SUIT_SQUAD_LAYER)

			if(length(marine_armor.armor_overlays))
				var/image/K
				var/image/IMG
				for(var/i in marine_armor.armor_overlays)
					K = marine_armor.armor_overlays[i]
					if(K)
						if(!IMG)
							IMG = image(K.icon,src,K.icon_state, "layer"= -SUIT_GARB_LAYER)
						else
							IMG.overlays += image(K.icon,src,K.icon_state, "layer"= -SUIT_GARB_LAYER)
				if(IMG)
					overlays_standing[SUIT_GARB_LAYER] = IMG
					apply_overlay(SUIT_GARB_LAYER)

		update_tail_showing()
	else
		update_tail_showing()
		update_inv_w_uniform()
		update_inv_shoes()
		update_inv_gloves()

	update_collar()



/mob/living/carbon/human/update_inv_pockets()
	if(!(client && hud_used && hud_used.hud_shown && hud_used.ui_datum))
		return

	if(l_store)
		client.add_to_screen(l_store)
		l_store.screen_loc = hud_used.ui_datum.hud_slot_offset(l_store, hud_used.ui_datum.ui_storage1)
	if(r_store)
		client.add_to_screen(r_store)
		r_store.screen_loc = hud_used.ui_datum.hud_slot_offset(r_store, hud_used.ui_datum.ui_storage2)


/mob/living/carbon/human/update_inv_wear_mask()
	remove_overlay(FACEMASK_LAYER)
	if(!wear_mask)
		return
	if(client && hud_used && hud_used.hud_shown && hud_used.inventory_shown && hud_used.ui_datum)
		client.add_to_screen(wear_mask)
		wear_mask.screen_loc = hud_used.ui_datum.hud_slot_offset(wear_mask, hud_used.ui_datum.ui_mask)

	if(!(head && head.flags_inv_hide & HIDEMASK))
		var/image/I = wear_mask.get_mob_overlay(src, WEAR_FACE)
		I.layer = -FACEMASK_LAYER
		overlays_standing[FACEMASK_LAYER] = I
		apply_overlay(FACEMASK_LAYER)

/mob/living/carbon/human/update_inv_back()
	remove_overlay(BACK_LAYER)
	if(!back)
		return
	if(client && hud_used && hud_used.hud_shown && hud_used.ui_datum)
		client.add_to_screen(back)
		back.screen_loc = hud_used.ui_datum.hud_slot_offset(back, hud_used.ui_datum.ui_back)

	var/image/I = back.get_mob_overlay(src, WEAR_BACK)
	I.layer = -BACK_LAYER

	if(dir == NORTH && (back.flags_item & ITEM_OVERRIDE_NORTHFACE))
		I.layer = -BACK_FRONT_LAYER
	overlays_standing[BACK_LAYER] = I
	apply_overlay(BACK_LAYER)


/mob/living/carbon/human/update_inv_handcuffed()
	remove_overlay(HANDCUFF_LAYER)
	if(!handcuffed)
		return
	var/image/I = handcuffed.get_mob_overlay(src, WEAR_HANDCUFFS)
	I.layer = -HANDCUFF_LAYER
	overlays_standing[HANDCUFF_LAYER] = I
	apply_overlay(HANDCUFF_LAYER)



/mob/living/carbon/human/update_inv_legcuffed()
	remove_overlay(LEGCUFF_LAYER)
	if(!legcuffed)
		return
	var/image/I = legcuffed.get_mob_overlay(src, WEAR_LEGCUFFS)
	I.layer = -LEGCUFF_LAYER
	overlays_standing[LEGCUFF_LAYER] = I
	apply_overlay(LEGCUFF_LAYER)


/mob/living/carbon/human/update_inv_r_hand()
	remove_overlay(R_HAND_LAYER)
	if(!r_hand)
		return
	if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD && hud_used.ui_datum)
		client.add_to_screen(r_hand)
		r_hand.screen_loc = hud_used.ui_datum.hud_slot_offset(r_hand, hud_used.ui_datum.ui_rhand)

	var/image/I = r_hand.get_mob_overlay(src, WEAR_R_HAND)
	I.layer = -R_HAND_LAYER
	overlays_standing[R_HAND_LAYER] = I
	apply_overlay(R_HAND_LAYER)



/mob/living/carbon/human/update_inv_l_hand()
	remove_overlay(L_HAND_LAYER)
	if(!l_hand)
		return
	if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD && hud_used.ui_datum)
		client.add_to_screen(l_hand)
		l_hand.screen_loc = hud_used.ui_datum.hud_slot_offset(l_hand, hud_used.ui_datum.ui_lhand)

	var/image/I = l_hand.get_mob_overlay(src, WEAR_L_HAND)
	I.layer = -L_HAND_LAYER
	overlays_standing[L_HAND_LAYER] = I
	apply_overlay(L_HAND_LAYER)



/mob/living/carbon/human/proc/update_tail_showing()
	remove_overlay(TAIL_LAYER)

	var/species_tail = species.get_tail(src)

	if(species_tail && !(wear_suit && wear_suit.flags_inv_hide & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_standing[TAIL_LAYER] = image(tail_s, icon_state = "[species_tail]_s", "layer" = -TAIL_LAYER)
		apply_overlay(TAIL_LAYER)


/mob/living/carbon/human/proc/get_tail_icon()
	var/icon_key = "[species.race_key][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/tail_icon = GLOB.tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		tail_icon = icon('icons/effects/species.dmi', "[species.get_tail(src)]")
		GLOB.tail_icon_cache[icon_key] = tail_icon

	return tail_icon


//Adds a collar overlay above the helmet layer if the suit has one
// Suit needs an identically named sprite in icons/mob/collar.dmi
/mob/living/carbon/human/proc/update_collar()
	remove_overlay(COLLAR_LAYER)
	if(!istype(wear_suit,/obj/item/clothing/suit))
		return
	var/obj/item/clothing/suit/S = wear_suit
	var/image/I = S.get_collar()
	if(I)
		I.layer = -COLLAR_LAYER
		overlays_standing[COLLAR_LAYER] = I
		apply_overlay(COLLAR_LAYER)

/mob/living/carbon/human/update_burst()
	remove_overlay(BURST_LAYER)
	var/image/standing
	switch(chestburst)
		if(1)
			standing = image("icon" = 'icons/mob/xenos/effects.dmi',"icon_state" = "burst_stand", "layer" = -BURST_LAYER)
		if(2)
			standing = image("icon" = 'icons/mob/xenos/effects.dmi',"icon_state" = "bursted_stand", "layer" = -BURST_LAYER)
		else
			return
	overlays_standing[BURST_LAYER] = standing
	apply_overlay(BURST_LAYER)


/mob/living/carbon/human/update_fire()
	remove_overlay(FIRE_LAYER)
	if(!on_fire)
		set_light_on(FALSE)
		return
	var/image/I
	switch(fire_stacks)
		if(1 to 14)
			I = image("icon"='icons/mob/humans/onmob/OnFire.dmi', "icon_state"="Standing_weak", "layer"= -FIRE_LAYER)
			set_light_range(2)
		if(15 to INFINITY)
			I = image("icon"='icons/mob/humans/onmob/OnFire.dmi', "icon_state"="Standing_medium", "layer"= -FIRE_LAYER)
			set_light_range(3)
		else
			return
	I.appearance_flags |= RESET_COLOR|RESET_ALPHA
	I.color = fire_reagent.burncolor
	set_light_color(fire_reagent.burncolor)
	set_light_on(TRUE)
	overlays_standing[FIRE_LAYER] = I
	apply_overlay(FIRE_LAYER)


/mob/living/carbon/human/proc/update_effects()
	remove_overlay(EFFECTS_LAYER)

	var/image/I
	for(var/datum/effects/E in effects_list)
		if(E.icon_path && E.mob_icon_state_path)
			if(!I)
				I = image("icon" = E.icon_path, "icon_state" = E.mob_icon_state_path, "layer"= -EFFECTS_LAYER)
			else
				I.overlays += image("icon" = E.icon_path, "icon_state" = E.mob_icon_state_path, "layer"= -EFFECTS_LAYER)
	if(!I)
		return
	overlays_standing[EFFECTS_LAYER] = I
	apply_overlay(EFFECTS_LAYER)


//Human Overlays Indexes/////////
#undef MUTANTRACE_LAYER
#undef UNIFORM_LAYER
#undef TAIL_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef EARS_LAYER
#undef SUIT_LAYER
#undef GLASSES_LAYER
#undef FACEMASK_LAYER
#undef BELT_LAYER
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef HEAD_LAYER
#undef COLLAR_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef TARGETED_LAYER
#undef FIRE_LAYER
#undef BURST_LAYER

/* To update the rooting graphic effect. Surely there's a better way... */
/mob/living/carbon/human/on_immobilized_trait_gain(datum/source)
	. = ..()
	update_xeno_hostile_hud()

/mob/living/carbon/human/on_immobilized_trait_loss(datum/source)
	. = ..()
	update_xeno_hostile_hud()

/mob/living/carbon/human/on_floored_trait_gain(datum/source)
	. = ..()
	update_xeno_hostile_hud()

/mob/living/carbon/human/on_floored_trait_loss(datum/source)
	. = ..()
	update_xeno_hostile_hud()
