/datum/custom_hud
	var/ui_style_icon = 'icons/mob/hud/cm_hud/cm_hud_marine_buttons.dmi'

	//Lower center, persistent menu
	var/ui_rhand = "hud:1:44,7:28"
	var/ui_lhand = "hud:2:44,7:28"
	var/ui_item_lhand = "hud:2:48,7:32"
	var/ui_item_rhand = "hud:1:49,7:32"

	//Inventory
	var/ui_shoes = "hud:1:64,7:-128"
	var/ui_iclothing = "hud:1:32,7:-64"
	var/ui_oclothing = "hud:1:64,7:-64"
	var/ui_gloves = "hud:1:96,7:-96"
	var/ui_glasses = "hud:1:96,7:-32"
	var/ui_mask = "hud:1:64,7:-32"
	var/ui_wear_l_ear = "hud:1:96,7:0"
	var/ui_wear_r_ear = "hud:1:32,7:0"
	var/ui_head = "hud:1:64,7:0"
	var/ui_back = "hud:1:32,7:-96"
	var/ui_idcard = "hud:1:32,7:-32"
	var/ui_belt = "hud:1:64,7:-96"
	var/ui_s_store = "hud:1:96,7:-64"
	var/ui_storage1 = "hud:1:32,7:-128"
	var/ui_storage2 = "hud:1:96,7:-128"

	//Lower right, persistent menu
	var/ui_dropbutton = "hud:1:0,6:3"
	var/ui_drop_throw = "hud:1:-2,6:26"
	var/ui_pull = "hud:1:13,4:36"
	var/ui_resist = "hud:1:9,7:36"
	var/ui_rest = "hud:1:9,6:55"
	var/ui_acti = "hud:2:-4,9:26"
	var/ui_movi = "hud:2:-14,11:19"
	var/ui_zonesel = "EAST-1:28,1:5"

	var/ui_gun_burst = "hud:5:-4,9:30"
	var/ui_gun_railtoggle = "hud:4:1,9:30"
	// var/ui_gun_eject = "EAST-3:-12,1:+5"
	var/ui_gun_attachment = "hud:5:-18,9:30"
	var/ui_gun_unique = "hud:5:9,9:30"

	//Frame related placements
	var/UI_FRAME_LOC = "EAST-3:0,14:15"

	//Status effects starting loc
	var/UI_STATUS_X = 1
	var/UI_STATUS_X_OFFSET = 4
	var/UI_STATUS_Y = 0
	var/UI_STATUS_Y_OFFSET = 26

	//Middle right (status indicators)
	var/UI_SL_LOCATOR_LOC = "hud:1:20,12:13"
	var/UI_OXYGEN_LOC = "hud:3:10,13:15"
	var/UI_HEALTH_LOC = "EAST-1:28,7:15"
	var/UI_TEMP_LOC = "hud:3:2,9:19"
	var/UI_NUTRITION_LOC = "hud:3:-6,13:15"

	//Surgery mode button
	var/ui_ammo_counter = "hud:3:64,8:1"

	//Surgery mode button
	var/ui_surgery_mode = "hud:1:-5,7:65"

	//Minimap button
	var/ui_minimap_button = "hud:3:60,7:-2"

	//Backhud
	var/ui_backhud = "hud:1,1"

	//Screen border
	var/ui_screen_border = "1,1"

/datum/custom_hud/proc/get_status_loc(placement)
	var/col = ((placement - 1)%(13)) + 1
	var/coord_col = "-[col-1]"
	var/coord_col_offset = "-[4+2*col]"

	var/row = floor((placement-1)/13)
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = 26
	return "EAST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"

///Offsets the slot's screen_loc by the item's hud_offset var. Uses the ui slot var as the arg: ui_belt, not WEAR_WAIST/"belt".
/datum/custom_hud/proc/hud_slot_offset(obj/item/A, ui_slot)
	var/coords = splittext(ui_slot, ",")
	var/coords_x = splittext(coords[1], ":")
	return "hud:[coords_x[1]]:[text2num(coords_x[2])+A.hud_offset],[coords[2]]"

/datum/custom_hud/old
	ui_style_icon = 'icons/mob/hud/human_old.dmi'

/datum/custom_hud/white
	ui_style_icon = 'icons/mob/hud/human_white.dmi'

/datum/custom_hud/orange
	ui_style_icon = 'icons/mob/hud/human_orange.dmi'

/datum/custom_hud/glass
	ui_style_icon = 'icons/mob/hud/human_glass.dmi'

/datum/custom_hud/red
	ui_style_icon = 'icons/mob/hud/human_red.dmi'

/datum/custom_hud/green
	ui_style_icon = 'icons/mob/hud/human_green.dmi'

/datum/custom_hud/bronze
	ui_style_icon = 'icons/mob/hud/human_bronze.dmi'

/datum/custom_hud/holographic
	ui_style_icon = 'icons/mob/hud/human_holo.dmi'

/datum/custom_hud/grey
	ui_style_icon = 'icons/mob/hud/human_grey.dmi'

/datum/custom_hud/dark
	ui_style_icon = 'icons/mob/hud/human_dark.dmi'

	UI_FRAME_LOC = "EAST-3:0,NORTH-1:15"
	UI_OXYGEN_LOC = "EAST-2:16,NORTH-1:15"
	UI_NUTRITION_LOC = "EAST-2:33,NORTH-1:15"
	UI_TEMP_LOC = "EAST-1:26,NORTH-0:-7"
	UI_HEALTH_LOC = "EAST-1:27,NORTH-0:-8"
	UI_SL_LOCATOR_LOC = "hud:1:20,12:13"
	UI_PULSE_LINE_LOC = "hud:3:20,13:6"

/datum/custom_hud/dark/get_status_loc(placement)
	var/col = (placement-1)
	var/coord_col = "-0"
	var/coord_col_offset = "-[24 * col + 2]"

	var/row = floor((placement-1)/6)
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = -8
	return "EAST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"

/datum/custom_hud/alien
	ui_style_icon = 'icons/mob/hud/alien_standard.dmi'

	var/ui_alien_nightvision = "hud:4:28,7:62"
	var/ui_queen_locator = "hud:4:30,5:62"
	var/ui_alienplasmadisplay = "hud:1:4,10:44"
	var/ui_mark_locator = "hud:4:29,6:60"
	var/ui_alien_resist = "hud:1:-4,7:35"
	var/ui_alien_pull = "hud:1:-4,6:6"
	var/ui_alien_swap = "hud:3:-4,8:17"
	var/ui_alien_intents = "hud:2:-4,9:26"
	var/ui_alien_throw = "hud:1:-4,6:36"
	var/ui_alien_drop = "hud:1:-4,5:50"
	var/ui_alien_walk = "hud:4:28,4:59"
	var/ui_alien_rest = "hud:1:-4,7:22"
	var/ui_alien_health_doll = "hud:2:-7,11:21"
	var/ui_alien_evo_display = "hud:2:-7,10:41"
