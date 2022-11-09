/datum/hud/robot
	var/datum/custom_hud/robot/ui_robot_datum

/datum/hud/robot/New(mob/living/silicon/robot/owner)
	..()
	var/atom/movable/screen/using

	ui_robot_datum = GLOB.custom_huds_list[HUD_ROBOT]

//Radio
	using = new /atom/movable/screen()
	using.name = "radio"
	using.setDir(SOUTHWEST)
	using.icon = ui_robot_datum.ui_style_icon
	using.icon_state = "radio"
	using.screen_loc = ui_robot_datum.ui_movi
	using.layer = ABOVE_HUD_LAYER
	using.plane = ABOVE_HUD_PLANE
	static_inventory += using

//Module select

	using = new /atom/movable/screen()
	using.name = "module1"
	using.setDir(SOUTHWEST)
	using.icon = ui_robot_datum.ui_style_icon
	using.icon_state = "inv1"
	using.screen_loc = ui_robot_datum.ui_inv1
	using.layer = ABOVE_HUD_LAYER
	using.plane = ABOVE_HUD_PLANE
	owner.inv1 = using
	static_inventory += using

	using = new /atom/movable/screen()
	using.name = "module2"
	using.setDir(SOUTHWEST)
	using.icon = ui_robot_datum.ui_style_icon
	using.icon_state = "inv2"
	using.screen_loc = ui_robot_datum.ui_inv2
	using.layer = ABOVE_HUD_LAYER
	using.plane = ABOVE_HUD_PLANE
	owner.inv2 = using
	static_inventory += using

	using = new /atom/movable/screen()
	using.name = "module3"
	using.setDir(SOUTHWEST)
	using.icon = ui_robot_datum.ui_style_icon
	using.icon_state = "inv3"
	using.screen_loc = ui_robot_datum.ui_inv3
	using.layer = ABOVE_HUD_LAYER
	using.plane = ABOVE_HUD_PLANE
	owner.inv3 = using
	static_inventory += using

//End of module select

//Intent
	using = new /atom/movable/screen/act_intent()
	using.icon = ui_robot_datum.ui_style_icon
	using.icon_state = "intent_"+ intent_text(owner.a_intent)
	static_inventory += using
	action_intent = using

//Cell
	owner.cells = new /atom/movable/screen()
	owner.cells.icon = ui_robot_datum.ui_style_icon
	owner.cells.icon_state = "charge-empty"
	owner.cells.name = "cell"
	owner.cells.screen_loc = ui_robot_datum.ui_toxin
	infodisplay += owner.cells

//Health
	healths = new /atom/movable/screen/healths()
	healths.icon = ui_robot_datum.ui_style_icon
	healths.screen_loc = ui_robot_datum.ui_borg_health
	infodisplay += healths

//Installed Module
	owner.hands = new /atom/movable/screen()
	owner.hands.icon = ui_robot_datum.ui_style_icon
	owner.hands.icon_state = "nomod"
	owner.hands.name = "module"
	owner.hands.screen_loc = ui_robot_datum.ui_borg_module
	static_inventory += owner.hands

//Module Panel
	using = new /atom/movable/screen()
	using.name = "panel"
	using.icon = ui_robot_datum.ui_style_icon
	using.icon_state = "panel"
	using.screen_loc = ui_robot_datum.ui_borg_panel
	using.layer = HUD_LAYER
	static_inventory += using

//Store
	module_store_icon = new /atom/movable/screen()
	module_store_icon.icon = ui_robot_datum.ui_style_icon
	module_store_icon.icon_state = "store"
	module_store_icon.name = "store"
	module_store_icon.screen_loc = ui_robot_datum.ui_borg_store
	static_inventory += module_store_icon

//Temp
	bodytemp_icon = new /atom/movable/screen/bodytemp()
	bodytemp_icon.screen_loc = ui_robot_datum.ui_borg_temp
	infodisplay += bodytemp_icon

	oxygen_icon = new /atom/movable/screen/oxygen()
	oxygen_icon.icon = ui_robot_datum.ui_style_icon
	oxygen_icon.screen_loc = ui_robot_datum.UI_OXYGEN_LOC
	infodisplay += oxygen_icon

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = ui_robot_datum.ui_style_icon
	pull_icon.screen_loc = ui_robot_datum.ui_borg_pull
	static_inventory += pull_icon

	zone_sel = new /atom/movable/screen/zone_sel/robot()
	zone_sel.screen_loc = ui_robot_datum.ui_zonesel
	zone_sel.update_icon(owner)
	static_inventory += zone_sel

	//Handle the gun settings buttons
	gun_setting_icon = new /atom/movable/screen/gun/mode()
	gun_setting_icon.screen_loc = ui_robot_datum.ui_gun_select
	gun_setting_icon.update_icon(owner)
	static_inventory += gun_setting_icon

	gun_item_use_icon = new /atom/movable/screen/gun/item()
	gun_item_use_icon.screen_loc = ui_robot_datum.ui_gun1
	gun_item_use_icon.update_icon(owner)
	static_inventory += gun_item_use_icon

	gun_move_icon = new /atom/movable/screen/gun/move()
	gun_move_icon.screen_loc = ui_robot_datum.ui_gun2
	gun_move_icon.update_icon(owner)
	static_inventory +=	gun_move_icon

	gun_run_icon = new /atom/movable/screen/gun/run()
	gun_run_icon.screen_loc = ui_robot_datum.ui_gun3
	gun_run_icon.update_icon(owner)
	static_inventory +=	gun_run_icon



/mob/living/silicon/robot/create_hud()
	if(!hud_used)
		hud_used = new /datum/hud/robot(src)



/datum/hud/robot/persistent_inventory_update()
	if(!mymob || !ui_robot_datum)
		return
	var/mob/living/silicon/robot/R = mymob
	if(hud_shown)
		if(R.module_state_1)
			R.module_state_1.screen_loc = ui_robot_datum.ui_inv1
			R.client.screen += R.module_state_1
		if(R.module_state_2)
			R.module_state_2.screen_loc = ui_robot_datum.ui_inv2
			R.client.screen += R.module_state_2
		if(R.module_state_3)
			R.module_state_3.screen_loc = ui_robot_datum.ui_inv3
			R.client.screen += R.module_state_3
	else
		if(R.module_state_1)
			R.module_state_1.screen_loc = null
		if(R.module_state_2)
			R.module_state_2.screen_loc = null
		if(R.module_state_3)
			R.module_state_3.screen_loc = null

