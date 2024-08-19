/datum/custom_hud
	var/ui_style_icon = 'icons/mob/hud/human_midnight.dmi'
	var/ui_frame_icon = 'icons/mob/hud/human_dark_frame.dmi'

	//Lower left, persistent menu
	var/ui_inventory = "WEST:6,1:5"

	//Lower center, persistent menu
	var/ui_sstore1 = "WEST+2:10,1:5"
	var/ui_id = "WEST+3:12,1:5"
	var/ui_belt = "WEST+4:14,1:5"
	var/ui_back = "WEST+5:14,1:5"
	var/ui_rhand = "WEST+6:16,1:5"
	var/ui_lhand = "WEST+7:16,1:5"
	var/ui_equip = "WEST+6:16,2:5"
	var/ui_swaphand1 = "WEST+6:16,2:5"
	var/ui_swaphand2 = "WEST+7:16,2:5"
	var/ui_storage1 = "WEST+8:18,1:5"
	var/ui_storage2 = "WEST+9:20,1:5"

	//Lower right, persistent menu
	var/ui_dropbutton = "EAST-4:22,1:5"
	var/ui_drop_throw = "EAST-1:28,2:7"
	var/ui_pull = "EAST-2:26,2:7"
	var/ui_resist = "EAST-2:26,2:7"
	var/ui_acti = "EAST-2:26,1:5"
	var/ui_movi = "EAST-3:24,1:5"
	var/ui_zonesel = "EAST-1:28,1:5"

	//Gun buttons
	var/ui_gun1 = "EAST-2:26,3:7"
	var/ui_gun2 = "EAST-1:28, 4:7"
	var/ui_gun3 = "EAST-2:26,4:7"
	var/ui_gun_select = "EAST-1:28,3:7"

	var/ui_gun_burst = "EAST-3:-8,1:+5"
	var/ui_gun_railtoggle = "EAST-3:-21,1:+13"
	var/ui_gun_eject = "EAST-3:-12,1:+5"
	var/ui_gun_attachment = "EAST-3:-10,1:+5"
	var/ui_gun_unique = "EAST-3:-4,1:+2"

	//Frame related placements
	var/UI_FRAME_LOC = "EAST-3:0,14:15"

	//Status effects starting loc
	var/UI_STATUS_X = 1
	var/UI_STATUS_X_OFFSET = 4
	var/UI_STATUS_Y = 0
	var/UI_STATUS_Y_OFFSET = 26

	//Middle right (status indicators)
	var/UI_SL_LOCATOR_LOC = "EAST-1:28,9:18"
	var/UI_OXYGEN_LOC = "EAST-1:28,8:17"
	var/UI_HEALTH_LOC = "EAST-1:28,7:15"
	var/UI_TEMP_LOC = "EAST-1:28,6:13"
	var/UI_NUTRITION_LOC = "EAST-1:28,5:11"

	//Pop-up inventory
	var/ui_shoes = "WEST+1:8,1:5"
	var/ui_iclothing = "WEST:6,2:7"
	var/ui_oclothing = "WEST+1:8,2:7"
	var/ui_gloves = "WEST+2:10,2:7"
	var/ui_glasses = "WEST:6,3:9"
	var/ui_mask = "WEST+1:8,3:9"
	var/ui_wear_l_ear = "WEST+2:10,3:9"
	var/ui_wear_r_ear = "WEST+2:10,4:11"
	var/ui_head = "WEST+1:8,4:11"

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
	return "[coords_x[1]]:[text2num(coords_x[2])+A.hud_offset],[coords[2]]"

/datum/custom_hud/proc/special_behaviour(datum/hud/element, ui_alpha = 255, ui_color = "#ffffff")
	return

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
	UI_SL_LOCATOR_LOC = "EAST-1:27,12:22"

/datum/custom_hud/dark/get_status_loc(placement)
	var/col = (placement-1)
	var/coord_col = "-0"
	var/coord_col_offset = "-[24 * col + 2]"

	var/row = floor((placement-1)/6)
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = -8
	return "EAST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"

/datum/custom_hud/dark/special_behaviour(datum/hud/element, ui_alpha = 255, ui_color = "#ffffff")
	element.frame_hud = new /atom/movable/screen()
	element.frame_hud.icon = ui_frame_icon
	element.frame_hud.icon_state = "dark"
	element.frame_hud.screen_loc = UI_FRAME_LOC
	element.frame_hud.layer = ABOVE_HUD_LAYER
	element.frame_hud.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	element.frame_hud.alpha = ui_alpha
	element.frame_hud.color = ui_color
	element.static_inventory += element.frame_hud

	element.pulse_line = new /atom/movable/screen()
	element.pulse_line.icon = ui_frame_icon
	element.pulse_line.icon_state = "pulse_good"
	element.pulse_line.screen_loc = UI_FRAME_LOC
	element.pulse_line.layer = ABOVE_HUD_LAYER
	element.pulse_line.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	element.static_inventory += element.pulse_line

/datum/custom_hud/alien
	ui_style_icon = 'icons/mob/hud/alien_standard.dmi'

	ui_resist = "WEST+9:20,1:5"
	UI_HEALTH_LOC = "EAST-1:28,7:13"

	var/ui_alien_nightvision = "EAST-1:28,9:13"
	var/ui_queen_locator = "EAST-1:28,8:13"
	var/ui_alienplasmadisplay = "EAST-1:28,6:13"
	var/ui_alienarmordisplay = "EAST-1:28,5:13"
	var/ui_mark_locator = "EAST-1:28,10:13"

/datum/custom_hud/robot
	ui_style_icon = 'icons/mob/hud/screen1_robot.dmi'

	var/ui_inv1 = "WEST+5:16,1:5"
	var/ui_inv2 = "WEST+6:16,1:5"
	var/ui_inv3 = "WEST+7:16,1:5"
	var/ui_borg_store = "WEST+8:16,1:5"

	var/ui_borg_pull = "EAST-3:24,2:7"
	var/ui_borg_module = "EAST-2:26,2:7"
	var/ui_borg_panel = "EAST-1:28,2:7"

	var/ui_toxin = "EAST-1:28,13:27"
	var/ui_borg_health = "EAST-1:28,6:13"
	var/ui_borg_temp = "EAST-1:28,10:21"
