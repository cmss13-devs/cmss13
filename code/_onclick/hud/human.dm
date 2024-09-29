/datum/hud/human
	var/list/gear = list()

/datum/hud/human/New(mob/living/carbon/human/owner, datum/custom_hud/hud_type, ui_color = "#ffffff", ui_alpha = 255)
	..()
	ui_datum = hud_type
	if(!istype(ui_datum))
		ui_datum = GLOB.custom_huds_list[HUD_MIDNIGHT]

	gear = list(
		"i_clothing" =   list("loc" = ui_datum.ui_iclothing, "slot" = WEAR_BODY, "state" = "center", "toggle" = 1, "dir" = SOUTH),
		"o_clothing" =   list("loc" = ui_datum.ui_oclothing, "slot" = WEAR_JACKET, "state" = "equip",  "toggle" = 1),
		"mask" =  list("loc" = ui_datum.ui_mask,   "slot" = WEAR_FACE, "state" = "mask", "toggle" = 1),
		"gloves" =    list("loc" = ui_datum.ui_gloves, "slot" = WEAR_HANDS, "state" = "gloves", "toggle" = 1),
		"eyes" =  list("loc" = ui_datum.ui_glasses,   "slot" = WEAR_EYES, "state" = "glasses","toggle" = 1),
		"wear_l_ear" =   list("loc" = ui_datum.ui_wear_l_ear,  "slot" = WEAR_L_EAR, "state" = "ears",   "toggle" = 1),
		"wear_r_ear" =   list("loc" = ui_datum.ui_wear_r_ear,  "slot" = WEAR_R_EAR, "state" = "ears",   "toggle" = 1),
		"head" =  list("loc" = ui_datum.ui_head,   "slot" = WEAR_HEAD, "state" = "hair",   "toggle" = 1),
		"shoes" = list("loc" = ui_datum.ui_shoes,  "slot" = WEAR_FEET, "state" = "shoes",  "toggle" = 1),
		"suit storage" = list("loc" = ui_datum.ui_sstore1,   "slot" = WEAR_J_STORE, "state" = "suit_storage"),
		"back" =  list("loc" = ui_datum.ui_back,   "slot" = WEAR_BACK, "state" = "back"),
		"id" =    list("loc" = ui_datum.ui_id, "slot" = WEAR_ID, "state" = "id"),
		"storage1" =  list("loc" = ui_datum.ui_storage1,  "slot" = WEAR_L_STORE, "state" = "pocket"),
		"storage2" =  list("loc" = ui_datum.ui_storage2,  "slot" = WEAR_R_STORE, "state" = "pocket"),
		"belt" =  list("loc" = ui_datum.ui_belt,   "slot" = WEAR_WAIST, "state" = "belt")
		)
	if(iszombie(owner))
		gear = list()

	for(var/slot in gear)
		equip_slots |= gear[slot]["slot"]

	equip_slots |= WEAR_L_HAND
	equip_slots |= WEAR_R_HAND
	equip_slots |= WEAR_HANDCUFFS

	if(WEAR_BACK in equip_slots)
		equip_slots |= WEAR_IN_BACK
		equip_slots |= WEAR_IN_SCABBARD

	equip_slots |= WEAR_LEGCUFFS

	if(WEAR_WAIST in equip_slots)
		equip_slots |= WEAR_IN_BELT

	if(WEAR_J_STORE in equip_slots)
		equip_slots |= WEAR_IN_J_STORE

	if(WEAR_L_STORE in equip_slots)
		equip_slots |= WEAR_IN_L_STORE

	if(WEAR_R_STORE in equip_slots)
		equip_slots |= WEAR_IN_R_STORE

	if(WEAR_BODY in equip_slots)
		equip_slots |= WEAR_ACCESSORY
		equip_slots |= WEAR_IN_ACCESSORY

	if(WEAR_JACKET in equip_slots)
		equip_slots |= WEAR_IN_JACKET

	if(WEAR_HEAD in equip_slots)
		equip_slots |= WEAR_IN_HELMET

	if(WEAR_FEET in equip_slots)
		equip_slots |= WEAR_IN_SHOES

	// Draw the various inventory equipment slots.
	draw_inventory_slots(gear, ui_datum, ui_alpha, ui_color)
	draw_toggle_inv(ui_datum, ui_alpha, ui_color)

	//Drawing frame HUD for specific HYD styles
	ui_datum.special_behaviour(src, ui_alpha, ui_color)

	// Draw the attack intent dialogue.
	draw_act_intent(ui_datum, ui_alpha)
	draw_mov_intent(ui_datum, ui_alpha, ui_color)
	draw_resist(ui_datum, ui_alpha, ui_color)
	if(!iszombie(owner))
		draw_drop(ui_datum, ui_alpha, ui_color)
		draw_throw(ui_datum, ui_alpha, ui_color)
	draw_pull(ui_datum)
	draw_right_hand(ui_datum, ui_alpha, ui_color)
	draw_left_hand(ui_datum, ui_alpha, ui_color)
	draw_swaphand("hand1", ui_datum.ui_swaphand1, ui_datum, ui_alpha, ui_color)
	draw_swaphand("hand2", ui_datum.ui_swaphand2, ui_datum, ui_alpha, ui_color)
	draw_hand_equip(ui_datum, ui_alpha, ui_color)
	//warnings
	draw_oxygen(ui_datum)
	draw_healths(ui_datum)
	draw_bodytemp(ui_datum)

	draw_status_effects(ui_datum)

	if(!iszombie(owner))
		draw_nutrition(ui_datum)
	draw_locator_spot(ui_datum)
	draw_zone_sel(ui_datum, ui_alpha, ui_color)
	draw_gun_related(ui_datum, ui_alpha)


/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.add_to_screen(hud_used.hotkeybuttons)
		hud_used.hotkey_ui_hidden = 0
	else
		client.remove_from_screen(hud_used.hotkeybuttons)
		hud_used.hotkey_ui_hidden = TRUE

/datum/hud/human/hidden_inventory_update(mob/viewer)
	if(!mymob || !ui_datum)
		return
	var/mob/living/carbon/human/H = mymob
	var/mob/screenmob = viewer || H

	if(!screenmob?.client)
		return

	if(!length(gear))
		inventory_shown = FALSE
		return //species without inv slots don't show items.

	if(H.hud_used.inventory_shown && H.hud_used.hud_shown)
		if(H.shoes)
			H.shoes.screen_loc = ui_datum.ui_shoes
			screenmob.client.add_to_screen(H.shoes)
		if(H.gloves)
			H.gloves.screen_loc = ui_datum.ui_gloves
			screenmob.client.add_to_screen(H.gloves)
		if(H.wear_l_ear)
			H.wear_l_ear.screen_loc = ui_datum.ui_wear_l_ear
			screenmob.client.add_to_screen(H.wear_l_ear)
		if(H.wear_r_ear)
			H.wear_r_ear.screen_loc = ui_datum.ui_wear_r_ear
			screenmob.client.add_to_screen(H.wear_r_ear)
		if(H.glasses)
			H.glasses.screen_loc = ui_datum.ui_glasses
			screenmob.client.add_to_screen(H.glasses)
		if(H.w_uniform)
			H.w_uniform.screen_loc = ui_datum.ui_iclothing
			screenmob.client.add_to_screen(H.w_uniform)
		if(H.wear_suit)
			H.wear_suit.screen_loc = ui_datum.ui_oclothing
			screenmob.client.add_to_screen(H.wear_suit)
		if(H.wear_mask)
			H.wear_mask.screen_loc = ui_datum.ui_mask
			screenmob.client.add_to_screen(H.wear_mask)
		if(H.head)
			H.head.screen_loc = ui_datum.ui_head
			screenmob.client.add_to_screen(H.head)
	else
		if(H.shoes)
			screenmob.client.remove_from_screen(H.shoes)
		if(H.gloves)
			screenmob.client.remove_from_screen(H.gloves)
		if(H.wear_r_ear)
			screenmob.client.remove_from_screen(H.wear_r_ear)
		if(H.wear_l_ear)
			screenmob.client.remove_from_screen(H.wear_l_ear)
		if(H.glasses)
			screenmob.client.remove_from_screen(H.glasses)
		if(H.w_uniform)
			screenmob.client.remove_from_screen(H.w_uniform)
		if(H.wear_suit)
			screenmob.client.remove_from_screen(H.wear_suit)
		if(H.wear_mask)
			screenmob.client.remove_from_screen(H.wear_mask)
		if(H.head)
			screenmob.client.remove_from_screen(H.head)

	if(screenmob == mymob)
		for(var/M in mymob.observers)
			hidden_inventory_update(M)

/datum/hud/human/persistent_inventory_update(mob/viewer)
	if(!mymob)
		return

	. = ..()

	var/mob/living/carbon/human/H = mymob
	var/mob/screenmob = viewer || H

	if(!screenmob?.client)
		return

	if(H.hud_used)
		if(H.hud_used.hud_shown)
			if(H.s_store)
				H.s_store.screen_loc = ui_datum.hud_slot_offset(H.s_store, ui_datum.ui_sstore1)
				screenmob.client.add_to_screen(H.s_store)
			if(H.wear_id)
				H.wear_id.screen_loc = ui_datum.hud_slot_offset(H.wear_id, ui_datum.ui_id)
				screenmob.client.add_to_screen(H.wear_id)
			if(H.belt)
				H.belt.screen_loc = ui_datum.hud_slot_offset(H.belt, ui_datum.ui_belt)
				screenmob.client.add_to_screen(H.belt)
			if(H.back)
				H.back.screen_loc = ui_datum.hud_slot_offset(H.back, ui_datum.ui_back)
				screenmob.client.add_to_screen(H.back)
			if(H.l_store)
				H.l_store.screen_loc = ui_datum.hud_slot_offset(H.l_store, ui_datum.ui_storage1)
				screenmob.client.add_to_screen(H.l_store)
			if(H.r_store)
				H.r_store.screen_loc = ui_datum.hud_slot_offset(H.r_store, ui_datum.ui_storage2)
				screenmob.client.add_to_screen(H.r_store)
		else
			if(H.s_store)
				screenmob.client.remove_from_screen(H.s_store)
			if(H.wear_id)
				screenmob.client.remove_from_screen(H.wear_id)
			if(H.belt)
				screenmob.client.remove_from_screen(H.belt)
			if(H.back)
				screenmob.client.remove_from_screen(H.back)
			if(H.l_store)
				screenmob.client.remove_from_screen(H.l_store)
			if(H.r_store)
				screenmob.client.remove_from_screen(H.r_store)

	if(hud_version != HUD_STYLE_NOHUD)
		if(H.r_hand)
			H.r_hand.screen_loc = ui_datum.hud_slot_offset(H.r_hand, ui_datum.ui_rhand)
			screenmob.client.add_to_screen(H.r_hand)
		if(H.l_hand)
			H.l_hand.screen_loc = ui_datum.hud_slot_offset(H.l_hand, ui_datum.ui_lhand)
			screenmob.client.add_to_screen(H.l_hand)
	else
		if(H.r_hand)
			H.r_hand.screen_loc = null
		if(H.l_hand)
			H.l_hand.screen_loc = null

	if(screenmob == mymob)
		for(var/M in mymob.observers)
			persistent_inventory_update(M)

/datum/hud/human/proc/draw_inventory_slots(gear, datum/custom_hud/ui_datum, ui_alpha, ui_color)
	for(var/gear_slot in gear)
		var/atom/movable/screen/inventory/inv_box = new /atom/movable/screen/inventory()
		inv_box.icon = ui_datum.ui_style_icon
		inv_box.layer = HUD_LAYER
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data =  gear[gear_slot]
		inv_box.name = gear_slot
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =  slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]

		if(slot_data["dir"])
			inv_box.setDir(slot_data["dir"])

		if(slot_data["toggle"])
			toggleable_inventory += inv_box
		else
			static_inventory += inv_box

/datum/hud/human/proc/draw_toggle_inv(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	var/atom/movable/screen/using = new /atom/movable/screen/toggle_inv()
	using.icon = ui_datum.ui_style_icon
	using.screen_loc = ui_datum.ui_inventory
	if(ui_color)
		using.color = ui_color
	if(ui_alpha)
		using.alpha = ui_alpha
	static_inventory += using

/datum/hud/human/proc/draw_hand_equip(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	var/atom/movable/screen/equip/equip_button = new()
	equip_button.icon = ui_datum.ui_style_icon
	equip_button.screen_loc = ui_datum.ui_equip
	if(ui_color)
		equip_button.color = ui_color
	if(ui_alpha)
		equip_button.alpha = ui_alpha
	static_inventory += equip_button

/datum/hud/human/proc/draw_oxygen(datum/custom_hud/ui_datum)
	oxygen_icon = new /atom/movable/screen/oxygen()
	oxygen_icon.icon = ui_datum.ui_style_icon
	oxygen_icon.screen_loc = ui_datum.UI_OXYGEN_LOC
	infodisplay += oxygen_icon

/datum/hud/human/proc/draw_bodytemp(datum/custom_hud/ui_datum)
	bodytemp_icon = new /atom/movable/screen/bodytemp()
	bodytemp_icon.icon = ui_datum.ui_style_icon
	bodytemp_icon.screen_loc = ui_datum.UI_TEMP_LOC
	infodisplay += bodytemp_icon

/datum/hud/human/proc/draw_nutrition(datum/custom_hud/ui_datum)
	nutrition_icon = new /atom/movable/screen()
	nutrition_icon.icon = ui_datum.ui_style_icon
	nutrition_icon.icon_state = "nutrition0"
	nutrition_icon.name = "nutrition"
	nutrition_icon.screen_loc = ui_datum.UI_NUTRITION_LOC
	infodisplay += nutrition_icon

/datum/hud/human/proc/draw_locator_spot(datum/custom_hud/ui_datum)
	locate_leader = new /atom/movable/screen/squad_leader_locator()
	locate_leader.icon = ui_datum.ui_style_icon
	locate_leader.screen_loc = ui_datum.UI_SL_LOCATOR_LOC
	infodisplay += locate_leader

/datum/hud/human/proc/draw_gun_related(datum/custom_hud/ui_datum, ui_alpha)
	use_attachment = new /atom/movable/screen/gun/attachment()
	use_attachment.icon = ui_datum.ui_style_icon
	use_attachment.screen_loc = ui_datum.ui_gun_attachment
	static_inventory += use_attachment

	toggle_raillight = new /atom/movable/screen/gun/rail_light()
	toggle_raillight.icon = ui_datum.ui_style_icon
	toggle_raillight.screen_loc = ui_datum.ui_gun_railtoggle
	static_inventory += toggle_raillight

	eject_mag = new /atom/movable/screen/gun/eject_magazine()
	eject_mag.icon = ui_datum.ui_style_icon
	eject_mag.screen_loc = ui_datum.ui_gun_eject
	static_inventory += eject_mag

	toggle_burst = new /atom/movable/screen/gun/toggle_firemode()
	toggle_burst.icon = ui_datum.ui_style_icon
	toggle_burst.screen_loc = ui_datum.ui_gun_burst
	static_inventory += toggle_burst

	unique_action = new /atom/movable/screen/gun/unique_action()
	unique_action.icon = ui_datum.ui_style_icon
	unique_action.screen_loc = ui_datum.ui_gun_unique
	static_inventory += unique_action

/datum/hud/human/proc/draw_status_effects(datum/custom_hud/ui_datum)
	slowed_icon = new /atom/movable/screen()
	slowed_icon.icon = ui_datum.ui_style_icon
	slowed_icon.icon_state = "status_0"
	infodisplay += slowed_icon

	bleeding_icon = new /atom/movable/screen()
	bleeding_icon.icon = ui_datum.ui_style_icon
	bleeding_icon.icon_state = "status_0"
	infodisplay += bleeding_icon

	shrapnel_icon = new /atom/movable/screen()
	shrapnel_icon.icon = ui_datum.ui_style_icon
	shrapnel_icon.icon_state = "status_0"
	infodisplay += shrapnel_icon

	tethering_icon = new /atom/movable/screen()
	tethering_icon.icon = ui_datum.ui_style_icon
	tethering_icon.icon_state = "status_0"
	infodisplay += tethering_icon

	tethered_icon = new /atom/movable/screen()
	tethered_icon.icon = ui_datum.ui_style_icon
	tethered_icon.icon_state = "status_0"
	infodisplay += tethered_icon

	transfusion_icon = new /atom/movable/screen()
	transfusion_icon.icon = ui_datum.ui_style_icon
	transfusion_icon.icon_state = "status_0"
	infodisplay += transfusion_icon

/mob/living/carbon/human/create_hud()
	if(client && client.prefs && !hud_used)
		var/ui_datum = GLOB.custom_huds_list[client.prefs.UI_style]
		var/ui_color = client.prefs.UI_style_color
		var/ui_alpha = client.prefs.UI_style_alpha
		hud_used = new /datum/hud/human(src, ui_datum, ui_color, ui_alpha)
	else
		hud_used = new /datum/hud/human(src)
