/datum/hud/alien
	var/datum/custom_hud/alien/ui_alien_datum

/datum/hud/alien/New(mob/living/carbon/xenomorph/owner)
	..()
	ui_alien_datum = GLOB.custom_huds_list[HUD_ALIEN]

	draw_act_intent(ui_alien_datum)
	draw_mov_intent(ui_alien_datum)
	draw_drop(ui_alien_datum)
	draw_right_hand(ui_alien_datum)
	draw_left_hand(ui_alien_datum)
	draw_swaphand("hand1", ui_alien_datum.ui_swaphand1, ui_alien_datum)
	draw_swaphand("hand2", ui_alien_datum.ui_swaphand2, ui_alien_datum)
	draw_resist(ui_alien_datum)
	draw_pull(ui_alien_datum)
	draw_throw(ui_alien_datum)
	draw_zone_sel(ui_alien_datum)
	draw_healths(ui_alien_datum)
	draw_alien_nightvision(ui_alien_datum)
	draw_alien_plasma_display(ui_alien_datum)
	draw_alien_locate_queen(ui_alien_datum)
	draw_alien_locate_mark(ui_alien_datum)

/datum/hud/proc/draw_alien_nightvision(datum/custom_hud/alien/ui_alien_datum)
	var/atom/movable/screen/using = new /atom/movable/screen/xenonightvision()
	using.icon = ui_alien_datum.ui_style_icon
	using.screen_loc = ui_alien_datum.ui_alien_nightvision
	infodisplay += using
	add_verb(mymob, /datum/action/xeno_action/verb/verb_night_vision)

/datum/hud/proc/draw_alien_plasma_display(datum/custom_hud/alien/ui_alien_datum)
	alien_plasma_display = new /atom/movable/screen()
	alien_plasma_display.icon = ui_alien_datum.ui_style_icon
	alien_plasma_display.icon_state = "power_display2"
	alien_plasma_display.name = "plasma stored"
	alien_plasma_display.screen_loc = ui_alien_datum.ui_alienplasmadisplay
	infodisplay += alien_plasma_display

/datum/hud/proc/draw_alien_locate_queen(datum/custom_hud/alien/ui_alien_datum)
	locate_leader = new /atom/movable/screen/queen_locator()
	locate_leader.icon = ui_alien_datum.ui_style_icon
	locate_leader.screen_loc = ui_alien_datum.ui_queen_locator
	infodisplay += locate_leader

/datum/hud/proc/draw_alien_locate_mark(datum/custom_hud/alien/ui_alien_datum)
	locate_marker = new /atom/movable/screen/mark_locator()
	locate_marker.icon = ui_alien_datum.ui_style_icon
	locate_marker.screen_loc = ui_alien_datum.ui_mark_locator
	infodisplay += locate_marker

/datum/hud/alien/persistent_inventory_update()
	if(!mymob || !ui_alien_datum)
		return
	var/mob/living/carbon/xenomorph/H = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		if(H.r_hand)
			H.client.add_to_screen(H.r_hand)
			H.r_hand.screen_loc = ui_alien_datum.hud_slot_offset(H.r_hand, ui_alien_datum.ui_rhand)
		if(H.l_hand)
			H.client.add_to_screen(H.l_hand)
			H.l_hand.screen_loc = ui_alien_datum.hud_slot_offset(H.l_hand, ui_alien_datum.ui_lhand)
	else
		if(H.r_hand)
			H.r_hand.screen_loc = null
		if(H.l_hand)
			H.l_hand.screen_loc = null


/mob/living/carbon/xenomorph/create_hud()
	if(!hud_used)
		hud_used = new /datum/hud/alien(src)


/datum/hud/larva/New(mob/living/carbon/xenomorph/larva/owner)
	..()
	var/datum/custom_hud/alien/ui_alien_datum = GLOB.custom_huds_list[HUD_ALIEN]

	draw_mov_intent(ui_alien_datum)
	draw_healths(ui_alien_datum)
	draw_alien_nightvision(ui_alien_datum)
	draw_alien_locate_queen(ui_alien_datum)
	draw_alien_locate_mark(ui_alien_datum)

/mob/living/carbon/xenomorph/larva/create_hud()
	if(!hud_used)
		hud_used = new /datum/hud/larva(src)
