/datum/hud/human
	var/list/gear = list()

/datum/hud/human/New(var/mob/living/carbon/human/owner, var/datum/custom_hud/hud_type, var/ui_color = "#ffffff", var/ui_alpha = 255)
	..()
	ui_datum = hud_type
	if(!istype(ui_datum))
		ui_datum = custom_huds_list["midnight"]

	gear = list(
		"i_clothing" =   list("loc" = ui_datum.ui_iclothing, "slot" = WEAR_BODY, 		"state" = "center", "toggle" = 1, "dir" = SOUTH),
		"o_clothing" =   list("loc" = ui_datum.ui_oclothing, "slot" = WEAR_JACKET, 		"state" = "equip",  "toggle" = 1),
		"mask" =         list("loc" = ui_datum.ui_mask,      "slot" = WEAR_FACE, 		"state" = "mask",  "toggle" = 1),
		"gloves" =       list("loc" = ui_datum.ui_gloves,    "slot" = WEAR_HANDS,    	"state" = "gloves", "toggle" = 1),
		"eyes" =         list("loc" = ui_datum.ui_glasses,   "slot" = WEAR_EYES,   		"state" = "glasses","toggle" = 1),
		"wear_ear" =     list("loc" = ui_datum.ui_wear_ear,  "slot" = WEAR_EAR,     		"state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_datum.ui_head,      "slot" = WEAR_HEAD,      	"state" = "hair",   "toggle" = 1),
		"shoes" =        list("loc" = ui_datum.ui_shoes,     "slot" = WEAR_FEET,     	"state" = "shoes",  "toggle" = 1),
		"suit storage" = list("loc" = ui_datum.ui_sstore1,   "slot" = WEAR_J_STORE,   	"state" = "suit_storage"),
		"back" =         list("loc" = ui_datum.ui_back,      "slot" = WEAR_BACK,      	"state" = "back"),
		"id" =           list("loc" = ui_datum.ui_id,        "slot" = WEAR_ID,   		"state" = "id"),
		"storage1" =     list("loc" = ui_datum.ui_storage1,  "slot" = WEAR_L_STORE,   	"state" = "pocket"),
		"storage2" =     list("loc" = ui_datum.ui_storage2,  "slot" = WEAR_R_STORE,   	"state" = "pocket"),
		"belt" =         list("loc" = ui_datum.ui_belt,      "slot" = WEAR_WAIST,      	"state" = "belt")
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

	if(WEAR_FEET in equip_slots)
		equip_slots |= WEAR_IN_SHOES

	// Draw the various inventory equipment slots.
	draw_inventory_slots(gear, ui_datum, ui_alpha, ui_color)
	draw_toggle_inv(ui_datum, ui_alpha, ui_color)

	//Drawing frame HUD for specific HYD styles
	ui_datum.special_behaviour(src, ui_alpha, ui_color)

	// Draw the attack intent dialogue.
	draw_act_intent(ui_datum, ui_alpha)
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
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1

/datum/hud/human/hidden_inventory_update()
	if(!mymob || !ui_datum) 
		return
	var/mob/living/carbon/human/H = mymob
	if(!gear.len)
		inventory_shown = FALSE
		return //species without inv slots don't show items.
		
	if(inventory_shown && hud_shown)
		if(H.shoes)
			H.shoes.screen_loc = ui_datum.ui_shoes
			H.client.screen += H.shoes
		if(H.gloves)
			H.gloves.screen_loc = ui_datum.ui_gloves
			H.client.screen += H.gloves
		if(H.wear_ear)
			H.wear_ear.screen_loc = ui_datum.ui_wear_ear
			H.client.screen += H.wear_ear
		if(H.glasses)
			H.glasses.screen_loc = ui_datum.ui_glasses
			H.client.screen += H.glasses
		if(H.w_uniform)
			H.w_uniform.screen_loc = ui_datum.ui_iclothing
			H.client.screen += H.w_uniform
		if(H.wear_suit)
			H.wear_suit.screen_loc = ui_datum.ui_oclothing
			H.client.screen += H.wear_suit
		if(H.wear_mask)
			H.wear_mask.screen_loc = ui_datum.ui_mask
			H.client.screen += H.wear_mask
		if(H.head)
			H.head.screen_loc = ui_datum.ui_head
			H.client.screen += H.head
	else
		if(H.shoes)
			H.shoes.screen_loc = null
		if(H.gloves)
			H.gloves.screen_loc = null
		if(H.wear_ear)
			H.wear_ear.screen_loc = null
		if(H.glasses)
			H.glasses.screen_loc = null
		if(H.w_uniform)
			H.w_uniform.screen_loc = null
		if(H.wear_suit)
			H.wear_suit.screen_loc = null
		if(H.wear_mask)
			H.wear_mask.screen_loc = null
		if(H.head)
			H.head.screen_loc = null

/datum/hud/human/persistant_inventory_update()
	if(!mymob || !ui_datum) 
		return

	var/mob/living/carbon/human/H = mymob
	if(hud_shown)
		if(!gear.len) //species without inv slots don't show items.
			return

		if(H.s_store)
			H.s_store.screen_loc = ui_datum.ui_sstore1
			H.client.screen += H.s_store
		if(H.wear_id)
			H.wear_id.screen_loc = ui_datum.ui_id
			H.client.screen += H.wear_id
		if(H.belt)
			H.belt.screen_loc = ui_datum.ui_belt
			H.client.screen += H.belt
		if(H.back)
			H.back.screen_loc = ui_datum.ui_back
			H.client.screen += H.back
		if(H.l_store)
			H.l_store.screen_loc = ui_datum.ui_storage1
			H.client.screen += H.l_store
		if(H.r_store)
			H.r_store.screen_loc = ui_datum.ui_storage2
			H.client.screen += H.r_store
	else
		if(H.s_store)
			H.s_store.screen_loc = null
		if(H.wear_id)
			H.wear_id.screen_loc = null
		if(H.belt)
			H.belt.screen_loc = null
		if(H.back)
			H.back.screen_loc = null
		if(H.l_store)
			H.l_store.screen_loc = null
		if(H.r_store)
			H.r_store.screen_loc = null

	if(hud_version != HUD_STYLE_NOHUD)
		if(H.r_hand)
			H.r_hand.screen_loc = ui_datum.ui_rhand
			H.client.screen += H.r_hand
		if(H.l_hand)
			H.l_hand.screen_loc = ui_datum.ui_lhand
			H.client.screen += H.l_hand
	else
		if(H.r_hand)
			H.r_hand.screen_loc = null
		if(H.l_hand)
			H.l_hand.screen_loc = null

/datum/hud/human/proc/draw_inventory_slots(var/gear, var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	for(var/gear_slot in gear)
		var/obj/screen/inventory/inv_box = new /obj/screen/inventory()
		inv_box.icon = ui_datum.ui_style_icon
		inv_box.layer = HUD_LAYER
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data =  gear[gear_slot]
		inv_box.name =        gear_slot
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =     slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]

		if(slot_data["dir"])
			inv_box.dir = slot_data["dir"]

		if(slot_data["toggle"])
			toggleable_inventory += inv_box
		else
			static_inventory += inv_box

/datum/hud/human/proc/draw_toggle_inv(var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	var/obj/screen/using = new /obj/screen/toggle_inv()
	using.icon = ui_datum.ui_style_icon
	using.screen_loc = ui_datum.ui_inventory
	if(ui_color)
		using.color = ui_color
	if(ui_alpha)
		using.alpha = ui_alpha
	static_inventory += using

/datum/hud/human/proc/draw_hand_equip(var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	var/obj/screen/using = new /obj/screen()
	using.name = "equip"
	using.icon = ui_datum.ui_style_icon
	using.icon_state = "act_equip"
	using.screen_loc = ui_datum.ui_equip
	using.layer = ABOVE_HUD_LAYER
	if(ui_color)
		using.color = ui_color
	if(ui_alpha)
		using.alpha = ui_alpha
	static_inventory += using

/datum/hud/human/proc/draw_oxygen(var/datum/custom_hud/ui_datum)
	oxygen_icon = new /obj/screen/oxygen()
	oxygen_icon.icon = ui_datum.ui_style_icon
	oxygen_icon.screen_loc = ui_datum.UI_OXYGEN_LOC
	infodisplay += oxygen_icon

/datum/hud/human/proc/draw_bodytemp(var/datum/custom_hud/ui_datum)
	bodytemp_icon = new /obj/screen/bodytemp()
	bodytemp_icon.icon = ui_datum.ui_style_icon
	bodytemp_icon.screen_loc = ui_datum.UI_TEMP_LOC
	infodisplay += bodytemp_icon

/datum/hud/human/proc/draw_nutrition(var/datum/custom_hud/ui_datum)
	nutrition_icon = new /obj/screen()
	nutrition_icon.icon = ui_datum.ui_style_icon
	nutrition_icon.icon_state = "nutrition0"
	nutrition_icon.name = "nutrition"
	nutrition_icon.screen_loc = ui_datum.UI_NUTRITION_LOC
	infodisplay += nutrition_icon

/datum/hud/human/proc/draw_locator_spot(var/datum/custom_hud/ui_datum)
	locate_leader = new /obj/screen/squad_leader_locator()
	locate_leader.icon = ui_datum.ui_style_icon
	locate_leader.screen_loc = ui_datum.UI_SL_LOCATOR_LOC
	infodisplay += locate_leader

/datum/hud/human/proc/draw_gun_related(var/datum/custom_hud/ui_datum, var/ui_alpha)
	use_attachment = new /obj/screen()
	use_attachment.icon = ui_datum.ui_style_icon
	use_attachment.icon_state = "gun_attach"
	use_attachment.name = "Activate weapon attachment"
	use_attachment.screen_loc = ui_datum.ui_gun_attachment
	static_inventory += use_attachment

	toggle_raillight = new /obj/screen()
	toggle_raillight.icon = ui_datum.ui_style_icon
	toggle_raillight.icon_state = "gun_raillight"
	toggle_raillight.name = "Toggle Rail Flashlight"
	toggle_raillight.screen_loc = ui_datum.ui_gun_railtoggle
	static_inventory += toggle_raillight

	eject_mag = new /obj/screen()
	eject_mag.icon = ui_datum.ui_style_icon
	eject_mag.icon_state = "gun_loaded"
	eject_mag.name = "Eject magazine"
	eject_mag.screen_loc = ui_datum.ui_gun_eject
	static_inventory += eject_mag

	toggle_burst = new /obj/screen()
	toggle_burst.icon = ui_datum.ui_style_icon
	toggle_burst.icon_state = "gun_burst"
	toggle_burst.name = "Toggle burst fire"
	toggle_burst.screen_loc = ui_datum.ui_gun_burst
	static_inventory += toggle_burst

	unique_action = new /obj/screen()
	unique_action.icon = ui_datum.ui_style_icon
	unique_action.icon_state = "gun_unique"
	unique_action.name = "Use unique action"
	unique_action.screen_loc = ui_datum.ui_gun_unique
	static_inventory += unique_action

	//Handle the gun settings buttons
	gun_setting_icon = new /obj/screen/gun/mode()
	gun_setting_icon.alpha = ui_alpha
	gun_setting_icon.screen_loc = ui_datum.ui_gun_select
	gun_setting_icon.update_icon(mymob)
	static_inventory += gun_setting_icon

	gun_item_use_icon = new /obj/screen/gun/item()
	gun_item_use_icon.alpha = ui_alpha
	gun_item_use_icon.screen_loc = ui_datum.ui_gun1
	gun_item_use_icon.update_icon(mymob)
	static_inventory += gun_item_use_icon

	gun_move_icon = new /obj/screen/gun/move()
	gun_move_icon.alpha = ui_alpha
	gun_move_icon.screen_loc = ui_datum.ui_gun2
	gun_move_icon.update_icon(mymob)
	static_inventory += gun_move_icon

	gun_run_icon = new /obj/screen/gun/run()
	gun_run_icon.alpha = ui_alpha
	gun_run_icon.screen_loc = ui_datum.ui_gun3
	gun_run_icon.update_icon(mymob)
	static_inventory += gun_run_icon

/datum/hud/human/proc/draw_status_effects(var/datum/custom_hud/ui_datum)
	slowed_icon = new /obj/screen()
	slowed_icon.icon = ui_datum.ui_style_icon
	slowed_icon.icon_state = "status_0"
	infodisplay += slowed_icon

	bleeding_icon = new /obj/screen()
	bleeding_icon.icon = ui_datum.ui_style_icon
	bleeding_icon.icon_state = "status_0"
	infodisplay += bleeding_icon

	shrapnel_icon = new /obj/screen()
	shrapnel_icon.icon = ui_datum.ui_style_icon
	shrapnel_icon.icon_state = "status_0"
	infodisplay += shrapnel_icon


/mob/living/carbon/human/create_hud()
	if(client && client.prefs && !hud_used)
		var/ui_datum = custom_huds_list[client.prefs.UI_style]
		var/ui_color = client.prefs.UI_style_color
		var/ui_alpha = client.prefs.UI_style_alpha
		hud_used = new /datum/hud/human(src, ui_datum, ui_color, ui_alpha)
	else
		hud_used = new /datum/hud/human(src)