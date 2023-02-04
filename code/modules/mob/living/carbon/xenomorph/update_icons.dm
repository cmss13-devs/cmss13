//Straight up copied from old Bay
//Abby

//Xeno Overlays Indexes//////////
#define X_BACK_LAYER 10
#define X_HEAD_LAYER 9
#define X_SUIT_LAYER 8
#define X_L_HAND_LAYER 7
#define X_R_HAND_LAYER 6
#define X_BACK_FRONT_LAYER 5
#define X_RESOURCE_LAYER 4
#define X_TARGETED_LAYER 3
#define X_LEGCUFF_LAYER 2
#define X_FIRE_LAYER 1
#define X_TOTAL_LAYERS 10
/////////////////////////////////


/mob/living/carbon/xenomorph/apply_overlay(cache_index)
	var/image/I = overlays_standing[cache_index]
	if(I)
		I.appearance_flags |= RESET_COLOR
		overlays += I

/mob/living/carbon/xenomorph/remove_overlay(cache_index)
	if(overlays_standing[cache_index])
		overlays -= overlays_standing[cache_index]
		overlays_standing[cache_index] = null

/mob/living/carbon/xenomorph/proc/update_icon_source()
	if(HAS_TRAIT(src, TRAIT_XENONID))
		icon = icon_xenonid
		if(isqueen(src))
			var/mob/living/carbon/xenomorph/queen/Q = src
			Q.queen_standing_icon = icon_xenonid
			Q.queen_ovipositor_icon = 'icons/mob/xenonids/ovipositor.dmi'
	else
		icon = icon_xeno
		if(isqueen(src))
			var/mob/living/carbon/xenomorph/queen/Q = src
			Q.queen_standing_icon = icon_xeno
			Q.queen_ovipositor_icon = 'icons/mob/xenos/ovipositor.dmi'

	var/mutation_caste_state = "[mutation_type] [caste.caste_type]"
	if(!walking_state_cache[mutation_caste_state])
		var/cache_walking_state = FALSE
		for(var/state in icon_states(icon))
			if(findtext(state, "Walking"))
				cache_walking_state = TRUE
				break
		walking_state_cache[mutation_caste_state] = cache_walking_state
	has_walking_icon_state = walking_state_cache[mutation_caste_state]
	update_icons()

/mob/living/carbon/xenomorph/update_icons()
	if(!caste)
		return

	//These also depend on the xeno's stance, so we must update them
	update_fire()
	update_wounds()
	update_inv_back()

	if(behavior_delegate?.on_update_icons())
		return

	var/mutation_caste_state = "[mutation_icon_state || mutation_type] [caste.caste_type]"
	if(stat == DEAD)
		icon_state = "[mutation_caste_state] Dead"
		if(!(icon_state in icon_states(icon_xeno)))
			icon_state = "Normal [caste.caste_type] Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[mutation_caste_state] Sleeping"
			if(!(icon_state in icon_states(icon_xeno)))
				icon_state = "Normal [caste.caste_type] Sleeping"
		else
			icon_state = "[mutation_caste_state] Knocked Down"
			if(!(icon_state in icon_states(icon_xeno)))
				icon_state = "Normal [caste.caste_type] Knocked Down"
	else
		var/movement_state = m_intent != MOVE_INTENT_RUN && has_walking_icon_state ? "Walking" : "Running"
		icon_state = "[mutation_caste_state] [movement_state]"
		if(!(icon_state in icon_states(icon_xeno)))
			icon_state = "Normal [caste.caste_type] [movement_state]"


/mob/living/carbon/xenomorph/regenerate_icons()
	..()
	update_inv_r_hand()
	update_inv_l_hand()
	update_inv_back()
	update_inv_resource()
	update_icons()

/mob/living/carbon/xenomorph/update_inv_pockets()
	var/datum/custom_hud/alien/ui_datum = GLOB.custom_huds_list[HUD_ALIEN]
	if(l_store)
		if(client && hud_used && hud_used.hud_shown)
			client.screen += l_store
			l_store.screen_loc = ui_datum.hud_slot_offset(l_store, ui_datum.ui_storage1)
	if(r_store)
		if(client && hud_used && hud_used.hud_shown)
			client.screen += r_store
			r_store.screen_loc = ui_datum.hud_slot_offset(r_store, ui_datum.ui_storage2)

/mob/living/carbon/xenomorph/update_inv_r_hand()
	remove_overlay(X_R_HAND_LAYER)
	if(r_hand)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			var/datum/custom_hud/alien/ui_datum = GLOB.custom_huds_list[HUD_ALIEN]
			client.screen += r_hand
			r_hand.screen_loc = ui_datum.hud_slot_offset(r_hand, ui_datum.ui_rhand)
		var/t_state = r_hand.item_state
		if(!t_state)
			t_state = r_hand.icon_state
		overlays_standing[X_R_HAND_LAYER] = r_hand.get_mob_overlay(src, WEAR_R_HAND)
		apply_overlay(X_R_HAND_LAYER)

/mob/living/carbon/xenomorph/update_inv_l_hand()
	remove_overlay(X_L_HAND_LAYER)
	if(l_hand)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			var/datum/custom_hud/alien/ui_datum = GLOB.custom_huds_list[HUD_ALIEN]
			client.screen += l_hand
			l_hand.screen_loc = ui_datum.hud_slot_offset(l_hand, ui_datum.ui_lhand)
		var/t_state = l_hand.item_state
		if(!t_state)
			t_state = l_hand.icon_state
		overlays_standing[X_L_HAND_LAYER] = l_hand.get_mob_overlay(src, WEAR_L_HAND)
		apply_overlay(X_L_HAND_LAYER)

/mob/living/carbon/xenomorph/update_inv_back()
	if(!backpack_icon_carrier)
		return // Xenos will only have a vis_obj if they've been equipped with a pack before

	var/obj/item/storage/backpack/backpack = back
	if(!backpack?.xeno_icon_state)
		backpack_icon_carrier.icon_state = "none"
		return

	var/state_modifier = ""
	if(stat == DEAD)
		state_modifier = " Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			state_modifier = " Sleeping"
		else
			state_modifier = " Knocked Down"
	else if(handle_special_state())
		state_modifier = handle_special_backpack_states()

	backpack_icon_carrier.icon_state = backpack.xeno_icon_state + state_modifier

	backpack_icon_carrier.layer = -X_BACK_LAYER
	if(dir == NORTH && (back.flags_item & ITEM_OVERRIDE_NORTHFACE))
		backpack_icon_carrier.layer = -X_BACK_FRONT_LAYER

/mob/living/carbon/xenomorph/proc/update_inv_resource()
	remove_overlay(X_RESOURCE_LAYER)
	if(crystal_stored)
		overlays_standing[X_RESOURCE_LAYER] = image("icon" = icon, "icon_state" = "[caste_type]_resources", "layer" =-X_RESOURCE_LAYER)
		apply_overlay(X_RESOURCE_LAYER)

//Call when target overlay should be added/removed
/mob/living/carbon/xenomorph/update_targeted()
	remove_overlay(X_TARGETED_LAYER)
	if(targeted_by && target_locked)
		overlays_standing[X_TARGETED_LAYER] = image("icon" = target_locked, "layer" =-X_TARGETED_LAYER)
	else if(!targeted_by && target_locked)
		QDEL_NULL(target_locked)
	if(!targeted_by || src.stat == DEAD)
		overlays_standing[X_TARGETED_LAYER] = null
	apply_overlay(X_TARGETED_LAYER)

/mob/living/carbon/xenomorph/update_inv_legcuffed()
	remove_overlay(X_LEGCUFF_LAYER)
	if(legcuffed)
		overlays_standing[X_LEGCUFF_LAYER] = image("icon" = 'icons/mob/xenos/effects.dmi', "icon_state" = "legcuff", "layer" =-X_LEGCUFF_LAYER)
		apply_overlay(X_LEGCUFF_LAYER)

/mob/living/carbon/xenomorph/proc/create_shriekwave(color = null)
	var/image/screech_image

	var/offset_x = 0
	var/offset_y = 0
	if(mob_size <= MOB_SIZE_XENO)
		offset_x = -7
		offset_y = -10

	if (color)
		screech_image = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "shriek_waves_greyscale") // For Praetorian screech
		screech_image.color = color
	else
		screech_image = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "shriek_waves") //Ehh, suit layer's not being used.

	screech_image.pixel_x = offset_x
	screech_image.pixel_y = offset_y

	screech_image.appearance_flags |= RESET_COLOR

	remove_suit_layer()

	overlays_standing[X_SUIT_LAYER] = screech_image
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_overlay), X_SUIT_LAYER), 30)

/mob/living/carbon/xenomorph/proc/create_stomp()
	remove_suit_layer()

	overlays_standing[X_SUIT_LAYER] = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "stomp") //Ehh, suit layer's not being used.
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_overlay), X_SUIT_LAYER), 12)

/mob/living/carbon/xenomorph/proc/create_empower()
	remove_suit_layer()

	overlays_standing[X_SUIT_LAYER] = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "empower")
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_overlay), X_SUIT_LAYER), 20)

/mob/living/carbon/xenomorph/proc/create_custom_empower(icolor, ialpha = 255, small_xeno = FALSE)
	remove_suit_layer()

	var/image/empower_image = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "empower_custom")
	empower_image.color = icolor
	empower_image.alpha = ialpha
	if(small_xeno == TRUE) // 48x48
		empower_image.pixel_x = -8
		empower_image.pixel_y = -8

	overlays_standing[X_SUIT_LAYER] = empower_image
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_overlay), X_SUIT_LAYER), 2 SECONDS)

/mob/living/carbon/xenomorph/proc/create_shield(duration = 10)
	remove_suit_layer()

	overlays_standing[X_SUIT_LAYER] = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "shield2")
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_overlay), X_SUIT_LAYER), duration)

/mob/living/carbon/xenomorph/proc/remove_suit_layer()
	remove_overlay(X_SUIT_LAYER)

/mob/living/carbon/xenomorph/update_fire()
	remove_overlay(X_FIRE_LAYER)
	if(on_fire && fire_reagent)
		var/image/I
		if(mob_size >= MOB_SIZE_BIG)
			if((!initial(pixel_y) || lying) && !resting && !sleeping)
				I = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state"="alien_fire", "layer"=-X_FIRE_LAYER)
			else
				I = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state"="alien_fire_lying", "layer"=-X_FIRE_LAYER)
		else
			I = image("icon" = 'icons/mob/xenos/effects.dmi', "icon_state"="alien_fire", "layer"=-X_FIRE_LAYER)

		I.appearance_flags |= RESET_COLOR|RESET_ALPHA
		I.color = fire_reagent.burncolor
		overlays_standing[X_FIRE_LAYER] = I
		apply_overlay(X_FIRE_LAYER)

/mob/living/carbon/xenomorph/proc/create_crusher_shield()
	remove_overlay(X_HEAD_LAYER)

	var/image/shield = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "empower")
	shield.color = rgb(87, 73, 144)
	overlays_standing[X_HEAD_LAYER] = shield
	apply_overlay(X_HEAD_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_overlay), X_HEAD_LAYER), 20)

/mob/living/carbon/xenomorph/proc/handle_special_state()
	return FALSE

/mob/living/carbon/xenomorph/proc/handle_special_wound_states()
	return FALSE

/mob/living/carbon/xenomorph/proc/handle_special_backpack_states()
	return ""

// Shamelessly inspired from the equivalent proc on TGCM
/mob/living/carbon/xenomorph/proc/update_wounds()
	if(!wound_icon_carrier)
		return

	var/health_threshold
	wound_icon_carrier.layer = layer + 0.01
	health_threshold = max(CEILING((health * 4) / (maxHealth), 1), 0) //From 0 to 4, in 25% chunks
	if(health > HEALTH_THRESHOLD_DEAD)
		if(health_threshold > 3)
			wound_icon_carrier.icon_state = "none"
		else if(lying)
			if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
				wound_icon_carrier.icon_state = "[caste.caste_type]_rest_[health_threshold]"
			else
				wound_icon_carrier.icon_state = "[caste.caste_type]_downed_[health_threshold]"
		else if(!handle_special_state())
			wound_icon_carrier.icon_state = "[caste.caste_type]_walk_[health_threshold]"
		else
			wound_icon_carrier.icon_state = handle_special_wound_states(health_threshold)


///Used to display the xeno wounds/backpacks without rapidly switching overlays
/atom/movable/vis_obj
	vis_flags = VIS_INHERIT_ID|VIS_INHERIT_DIR
	appearance_flags = RESET_COLOR

/atom/movable/vis_obj/xeno_wounds
	icon = 'icons/mob/xenos/wounds.dmi'

/atom/movable/vis_obj/xeno_pack/Initialize(mapload, mob/living/carbon/source)
	. = ..()
	if(source)
		icon = default_xeno_onmob_icons[source.type]

//Xeno Overlays Indexes//////////
#undef X_BACK_LAYER
#undef X_BACK_FRONT_LAYER
#undef X_HEAD_LAYER
#undef X_SUIT_LAYER
#undef X_L_HAND_LAYER
#undef X_R_HAND_LAYER
#undef X_LEGCUFF_LAYER
#undef X_FIRE_LAYER
