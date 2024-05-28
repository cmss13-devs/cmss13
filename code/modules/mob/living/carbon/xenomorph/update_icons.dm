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

	var/mutation_caste_state = "[get_strain_icon()] [caste.caste_type]"
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

	var/mutation_caste_state = "[get_strain_icon()] [caste.caste_type]"
	if(stat == DEAD)
		icon_state = "[mutation_caste_state] Dead"
		if(!(icon_state in icon_states(icon_xeno)))
			icon_state = "Normal [caste.caste_type] Dead"
	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
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
	update_icons()

/* CRUTCH ZONE - Update icons when relevant status happen - Ideally do this properly and for everything, then kill update_icons() someday */
// set_body_position is needed on addition of floored start/stop because we can be switching between resting and knockeddown
/mob/living/carbon/xenomorph/set_body_position(new_value)
	. = ..()
	if(. != new_value)
		update_icons() // Snowflake handler for xeno resting icons
		update_wounds()

/mob/living/carbon/xenomorph/on_floored_start()
	. = ..()
	update_icons()
	update_wounds()
/mob/living/carbon/xenomorph/on_floored_end()
	. = ..()
	update_icons()
	update_wounds()
/mob/living/carbon/xenomorph/on_incapacitated_trait_gain()
	. = ..()
	update_icons()
	update_wounds()
/mob/living/carbon/xenomorph/on_incapacitated_trait_loss()
	. = ..()
	update_icons()
	update_wounds()
/mob/living/carbon/xenomorph/on_knockedout_trait_gain()
	. = ..()
	update_icons()
	update_wounds()
/mob/living/carbon/xenomorph/on_knockedout_trait_loss()
	. = ..()
	update_icons()
	update_wounds()

/* ^^^^^^^^^^^^^^ End Icon updates */

/mob/living/carbon/xenomorph/update_inv_pockets()
	var/datum/custom_hud/alien/ui_datum = GLOB.custom_huds_list[HUD_ALIEN]
	if(l_store)
		if(client && hud_used && hud_used.hud_shown)
			client.add_to_screen(l_store)
			l_store.screen_loc = ui_datum.hud_slot_offset(l_store, ui_datum.ui_storage1)
	if(r_store)
		if(client && hud_used && hud_used.hud_shown)
			client.add_to_screen(r_store)
			r_store.screen_loc = ui_datum.hud_slot_offset(r_store, ui_datum.ui_storage2)

/mob/living/carbon/xenomorph/update_inv_r_hand()
	remove_overlay(X_R_HAND_LAYER)
	if(r_hand)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			var/datum/custom_hud/alien/ui_datum = GLOB.custom_huds_list[HUD_ALIEN]
			client.add_to_screen(r_hand)
			r_hand.screen_loc = ui_datum.hud_slot_offset(r_hand, ui_datum.ui_rhand)
		var/t_state = r_hand.item_state
		if(!t_state)
			t_state = r_hand.icon_state
		/*Move inhand image to the center of the sprite. Strictly speaking this should probably be like monkey get_offset_overlay_image() and tailor item icon
		positions to the hands of the xeno, but outside of special occasions xenos can't really pick items up and this tends to look better than human default.*/
		var/image/inhand_image = r_hand.get_mob_overlay(src, WEAR_R_HAND)
		inhand_image.pixel_x = xeno_inhand_item_offset
		overlays_standing[X_R_HAND_LAYER] = inhand_image

		apply_overlay(X_R_HAND_LAYER)

/mob/living/carbon/xenomorph/update_inv_l_hand()
	remove_overlay(X_L_HAND_LAYER)
	if(l_hand)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			var/datum/custom_hud/alien/ui_datum = GLOB.custom_huds_list[HUD_ALIEN]
			client.add_to_screen(l_hand)
			l_hand.screen_loc = ui_datum.hud_slot_offset(l_hand, ui_datum.ui_lhand)
		var/t_state = l_hand.item_state
		if(!t_state)
			t_state = l_hand.icon_state

		/*Move inhand image overlay to the center of the sprite. Strictly speaking this should probably be like monkey get_offset_overlay_image() and tailor item icon
		positions to the hands of the xeno, but outside of special occasions xenos can't really pick items up and this tends to look better than human default.*/
		var/image/inhand_image = l_hand.get_mob_overlay(src, WEAR_L_HAND)
		inhand_image.pixel_x = xeno_inhand_item_offset
		overlays_standing[X_L_HAND_LAYER] = inhand_image

		apply_overlay(X_L_HAND_LAYER)

/mob/living/carbon/xenomorph/update_inv_back()
	if(!backpack_icon_holder)
		return // Xenos will only have a vis_obj if they've been equipped with a pack before

	var/obj/item/storage/backpack/backpack = back
	if(!backpack?.xeno_icon_state)
		backpack_icon_holder.icon_state = "none"
		return

	var/state_modifier = ""
	if(stat == DEAD)
		state_modifier = " Dead"
	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			state_modifier = " Sleeping"
		else
			state_modifier = " Knocked Down"
	else if(handle_special_state())
		state_modifier = handle_special_backpack_states()

	backpack_icon_holder.icon_state = backpack.xeno_icon_state + state_modifier

	backpack_icon_holder.layer = -X_BACK_LAYER
	if(dir == NORTH && (back.flags_item & ITEM_OVERRIDE_NORTHFACE))
		backpack_icon_holder.layer = -X_BACK_FRONT_LAYER

/mob/living/carbon/xenomorph/update_inv_legcuffed()
	remove_overlay(X_LEGCUFF_LAYER)
	if(legcuffed)
		overlays_standing[X_LEGCUFF_LAYER] = image("icon" = 'icons/mob/xenos/effects.dmi', "icon_state" = "legcuff", "layer" =-X_LEGCUFF_LAYER)
		apply_overlay(X_LEGCUFF_LAYER)

/mob/living/carbon/xenomorph/proc/create_shriekwave(shriekwaves_left)
	var/offset_y = 8
	if(mob_size == MOB_SIZE_XENO)
		offset_y = 24
	if(mob_size == MOB_SIZE_IMMOBILE)
		offset_y = 28

	//the shockwave center is updated eachtime shockwave is called and offset relative to the mob_size.
	//due to the speed of the shockwaves, it isn't required to be tied to the exact mob movements
	var/epicenter = loc //center of the shockwave, set at the center of the tile that the mob is currently standing on
	var/easing = QUAD_EASING | EASE_OUT
	var/stage1_radius = rand(11, 12)
	var/stage2_radius = rand(9, 11)
	var/stage3_radius = rand(8, 10)
	var/stage4_radius = 7.5

	//shockwaves are iterated, counting down once per shriekwave, with the total amount being determined on the respective xeno ability tile
	if(shriekwaves_left > 12)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, stage1_radius, 0.5, easing, offset_y)
		addtimer(CALLBACK(src, PROC_REF(create_shriekwave), shriekwaves_left), 2)
		return
	if(shriekwaves_left > 8)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, stage2_radius, 0.5, easing, offset_y)
		addtimer(CALLBACK(src, PROC_REF(create_shriekwave), shriekwaves_left), 3)
		return
	if(shriekwaves_left > 4)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, stage3_radius, 0.5, easing, offset_y)
		addtimer(CALLBACK(src, PROC_REF(create_shriekwave), shriekwaves_left), 3)
		return
	if(shriekwaves_left > 1)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, stage4_radius, 0.5, easing, offset_y)
		addtimer(CALLBACK(src, PROC_REF(create_shriekwave), shriekwaves_left), 3)
		return
	if(shriekwaves_left == 1)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, 10.5, 0.6, easing, offset_y)

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
			if((!initial(pixel_y) || body_position != LYING_DOWN)) // what's that pixel_y doing here???
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
	if(!wound_icon_holder)
		return

	var/health_threshold
	health_threshold = max(ceil((health * 4) / (maxHealth)), 0) //From 0 to 4, in 25% chunks
	if(health > HEALTH_THRESHOLD_DEAD)
		if(health_threshold > 3)
			wound_icon_holder.icon_state = "none"
		else if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				wound_icon_holder.icon_state = "[caste.caste_type]_rest_[health_threshold]"
			else
				wound_icon_holder.icon_state = "[caste.caste_type]_downed_[health_threshold]"
		else if(!handle_special_state())
			wound_icon_holder.icon_state = "[caste.caste_type]_walk_[health_threshold]"
		else
			wound_icon_holder.icon_state = handle_special_wound_states(health_threshold)

///Used to display the xeno wounds/backpacks without rapidly switching overlays
/atom/movable/vis_obj
	vis_flags = VIS_INHERIT_ID|VIS_INHERIT_DIR|VIS_INHERIT_LAYER|VIS_INHERIT_PLANE
	appearance_flags = RESET_COLOR

/atom/movable/vis_obj/xeno_wounds
	icon = 'icons/mob/xenos/wounds.dmi'

/atom/movable/vis_obj/xeno_pack/Initialize(mapload, mob/living/carbon/source)
	. = ..()
	if(source)
		icon = GLOB.default_xeno_onmob_icons[source.type]

//Xeno Overlays Indexes//////////
#undef X_BACK_LAYER
#undef X_BACK_FRONT_LAYER
#undef X_HEAD_LAYER
#undef X_SUIT_LAYER
#undef X_L_HAND_LAYER
#undef X_R_HAND_LAYER
#undef X_LEGCUFF_LAYER
#undef X_FIRE_LAYER
