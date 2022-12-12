//Straight up copied from old Bay
//Abby

//Xeno Overlays Indexes//////////
#define X_HEAD_LAYER			8
#define X_SUIT_LAYER			7
#define X_L_HAND_LAYER			6
#define X_R_HAND_LAYER			5
#define X_RESOURCE_LAYER		4
#define X_TARGETED_LAYER		3
#define X_LEGCUFF_LAYER			2
#define X_FIRE_LAYER			1
#define X_TOTAL_LAYERS			8
/////////////////////////////////


/mob/living/carbon/Xenomorph/apply_overlay(cache_index)
	var/image/I = overlays_standing[cache_index]
	if(I)
		I.appearance_flags |= RESET_COLOR
		overlays += I

/mob/living/carbon/Xenomorph/remove_overlay(cache_index)
	if(overlays_standing[cache_index])
		overlays -= overlays_standing[cache_index]
		overlays_standing[cache_index] = null

/mob/living/carbon/Xenomorph/proc/update_icon_source()
	if(HAS_TRAIT(src, TRAIT_XENONID))
		icon = icon_xenonid
		if(isXenoQueen(src))
			var/mob/living/carbon/Xenomorph/Queen/Q = src
			Q.queen_standing_icon = icon_xenonid
			Q.queen_ovipositor_icon = 'icons/mob/xenonids/ovipositor.dmi'
	else
		icon = icon_xeno
		if(isXenoQueen(src))
			var/mob/living/carbon/Xenomorph/Queen/Q = src
			Q.queen_standing_icon = icon_xeno
			Q.queen_ovipositor_icon = get_icon_from_source(CONFIG_GET(string/alien_queen_ovipositor))

	update_icons()

/mob/living/carbon/Xenomorph/update_icons()
	if(!caste)
		return

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
	update_wounds()

	if(behavior_delegate?.on_update_icons())
		return

	if(stat == DEAD)
		icon_state = "[mutation_type] [caste.caste_type] Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[mutation_type] [caste.caste_type] Sleeping"
		else
			icon_state = "[mutation_type] [caste.caste_type] Knocked Down"
	else
		icon_state = "[mutation_type] [caste.caste_type] Running"

/mob/living/carbon/Xenomorph/regenerate_icons()
	..()
	update_inv_r_hand()
	update_inv_l_hand()
	update_inv_resource()
	update_icons()


/mob/living/carbon/Xenomorph/update_inv_pockets()
	var/datum/custom_hud/alien/ui_datum = GLOB.custom_huds_list[HUD_ALIEN]
	if(l_store)
		if(client && hud_used && hud_used.hud_shown)
			client.screen += l_store
			l_store.screen_loc = ui_datum.hud_slot_offset(l_store, ui_datum.ui_storage1)
	if(r_store)
		if(client && hud_used && hud_used.hud_shown)
			client.screen += r_store
			r_store.screen_loc = ui_datum.hud_slot_offset(r_store, ui_datum.ui_storage2)

/mob/living/carbon/Xenomorph/update_inv_r_hand()
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

/mob/living/carbon/Xenomorph/update_inv_l_hand()
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

/mob/living/carbon/Xenomorph/proc/update_inv_resource()
	remove_overlay(X_RESOURCE_LAYER)
	if(crystal_stored)
		overlays_standing[X_RESOURCE_LAYER] = image("icon" = icon, "icon_state" = "[caste_type]_resources", "layer" =-X_RESOURCE_LAYER)
		apply_overlay(X_RESOURCE_LAYER)

//Call when target overlay should be added/removed
/mob/living/carbon/Xenomorph/update_targeted()
	remove_overlay(X_TARGETED_LAYER)
	if(targeted_by && target_locked)
		overlays_standing[X_TARGETED_LAYER]	= image("icon" = target_locked, "layer" =-X_TARGETED_LAYER)
	else if(!targeted_by && target_locked)
		QDEL_NULL(target_locked)
	if(!targeted_by || src.stat == DEAD)
		overlays_standing[X_TARGETED_LAYER]	= null
	apply_overlay(X_TARGETED_LAYER)

/mob/living/carbon/Xenomorph/update_inv_legcuffed()
	remove_overlay(X_LEGCUFF_LAYER)
	if(legcuffed)
		overlays_standing[X_LEGCUFF_LAYER]	= image("icon" = 'icons/mob/hostiles/Effects.dmi', "icon_state" = "legcuff", "layer" =-X_LEGCUFF_LAYER)
		apply_overlay(X_LEGCUFF_LAYER)

/mob/living/carbon/Xenomorph/proc/create_shriekwave(var/color = null)
	var/image/screech_image

	var/offset_x = 0
	var/offset_y = 0
	if(mob_size <= MOB_SIZE_XENO)
		offset_x = -7
		offset_y = -10

	if (color)
		screech_image = image("icon"='icons/mob/hostiles/overlay_effects64x64.dmi', "icon_state" = "shriek_waves_greyscale") // For Praetorian screech
		screech_image.color = color
	else
		screech_image = image("icon"='icons/mob/hostiles/overlay_effects64x64.dmi', "icon_state" = "shriek_waves") //Ehh, suit layer's not being used.

	screech_image.pixel_x = offset_x
	screech_image.pixel_y = offset_y

	screech_image.appearance_flags |= RESET_COLOR

	remove_suit_layer()

	overlays_standing[X_SUIT_LAYER] = screech_image
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, .proc/remove_overlay, X_SUIT_LAYER), 30)

/mob/living/carbon/Xenomorph/proc/create_stomp()
	remove_suit_layer()

	overlays_standing[X_SUIT_LAYER] = image("icon"='icons/mob/hostiles/overlay_effects64x64.dmi', "icon_state" = "stomp") //Ehh, suit layer's not being used.
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, .proc/remove_overlay, X_SUIT_LAYER), 12)

/mob/living/carbon/Xenomorph/proc/create_empower()
	remove_suit_layer()

	overlays_standing[X_SUIT_LAYER] = image("icon"='icons/mob/hostiles/overlay_effects64x64.dmi', "icon_state" = "empower")
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, .proc/remove_overlay, X_SUIT_LAYER), 20)

/mob/living/carbon/Xenomorph/proc/create_shield(var/duration = 10)
	remove_suit_layer()

	overlays_standing[X_SUIT_LAYER] = image("icon"='icons/mob/hostiles/overlay_effects64x64.dmi', "icon_state" = "shield2")
	apply_overlay(X_SUIT_LAYER)
	addtimer(CALLBACK(src, .proc/remove_overlay, X_SUIT_LAYER), duration)

/mob/living/carbon/Xenomorph/proc/remove_suit_layer()
	remove_overlay(X_SUIT_LAYER)

/mob/living/carbon/Xenomorph/update_fire()
	remove_overlay(X_FIRE_LAYER)
	if(on_fire && fire_reagent)
		var/image/I
		if(mob_size >= MOB_SIZE_BIG)
			if((!initial(pixel_y) || lying) && !resting && !sleeping)
				I = image("icon"='icons/mob/hostiles/overlay_effects64x64.dmi', "icon_state"="alien_fire", "layer"=-X_FIRE_LAYER)
			else
				I = image("icon"='icons/mob/hostiles/overlay_effects64x64.dmi', "icon_state"="alien_fire_lying", "layer"=-X_FIRE_LAYER)
		else
			I = image("icon" = 'icons/mob/hostiles/Effects.dmi', "icon_state"="alien_fire", "layer"=-X_FIRE_LAYER)

		I.appearance_flags |= RESET_COLOR|RESET_ALPHA
		I.color = fire_reagent.burncolor
		overlays_standing[X_FIRE_LAYER] = I
		apply_overlay(X_FIRE_LAYER)

/mob/living/carbon/Xenomorph/proc/create_crusher_shield()
	remove_overlay(X_HEAD_LAYER)

	var/image/shield = image("icon"='icons/mob/hostiles/overlay_effects64x64.dmi', "icon_state" = "empower")
	shield.color = rgb(87, 73, 144)
	overlays_standing[X_HEAD_LAYER] = shield
	apply_overlay(X_HEAD_LAYER)
	addtimer(CALLBACK(src, .proc/remove_overlay, X_HEAD_LAYER), 20)

/mob/living/carbon/Xenomorph/proc/handle_special_state()
	return FALSE

/mob/living/carbon/Xenomorph/proc/handle_special_wound_states()
	return FALSE

// Shamelessly inspired from the equivalent proc on TGCM
/mob/living/carbon/Xenomorph/proc/update_wounds()
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


///Used to display the xeno wounds without rapidly switching overlays
/atom/movable/vis_obj/xeno_wounds
	icon = 'icons/mob/hostiles/wounds.dmi'
	var/mob/living/carbon/Xenomorph/wound_owner
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT


/atom/movable/vis_obj/xeno_wounds/Initialize(mapload, mob/living/carbon/Xenomorph/owner)
	. = ..()
	if(owner)
		wound_owner = owner
		RegisterSignal(owner, COMSIG_ATOM_DIR_CHANGE, .proc/on_dir_change)

/atom/movable/vis_obj/xeno_wounds/Destroy()
	if(wound_owner)
		UnregisterSignal(wound_owner, COMSIG_ATOM_DIR_CHANGE)
		wound_owner = null
	return ..()

/atom/movable/vis_obj/xeno_wounds/proc/on_dir_change(mob/living/carbon/Xenomorph/source, olddir, newdir)
	SIGNAL_HANDLER
	dir = newdir

//Xeno Overlays Indexes//////////
#undef X_HEAD_LAYER
#undef X_SUIT_LAYER
#undef X_L_HAND_LAYER
#undef X_R_HAND_LAYER
#undef X_LEGCUFF_LAYER
#undef X_FIRE_LAYER
