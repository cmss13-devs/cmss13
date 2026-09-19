/datum/hud/alien
	var/datum/custom_hud/alien/ui_alien_datum

/datum/hud/alien/New(mob/living/carbon/xenomorph/owner)
	..()
	ui_alien_datum = GLOB.custom_huds_list[HUD_ALIEN]

	draw_act_intent(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi', ui_loc = "hud:2:-4,9:26")
	draw_mov_intent(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi', ui_loc = "hud:4:28,4:59")
	draw_drop(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi', ui_loc = "hud:1:-4,5:50")
	draw_right_hand(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_hands.dmi', ui_loc = "hud:2:12,7:28")
	draw_left_hand(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_hands.dmi', ui_loc = "hud:2:44,7:28")
	draw_swaphand("swap", "hud:3:-4,8:17", ui_alien_datum, 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi')
	draw_alien_resist(ui_alien_datum)
	draw_pull(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi', ui_loc = "hud:1:-4,6:6")
	draw_throw(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi', ui_loc = "hud:1:-4,6:36")
	draw_zone_sel(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_zone_sel_xeno.dmi', ui_loc = "hud:4:-3,11:21")
	draw_healths(ui_alien_datum, ui_icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi', ui_loc = "hud:1:4,11:42")
	draw_alien_nightvision(ui_alien_datum)
	draw_alien_plasma_display(ui_alien_datum)
	draw_alien_locate_queen(ui_alien_datum)
	draw_alien_locate_mark(ui_alien_datum)
	draw_alien_backhud(ui_alien_datum)
	draw_alien_rest(ui_alien_datum)
	draw_alien_evo_display(ui_alien_datum)
	draw_alien_health_doll(ui_alien_datum)
	draw_screen_border(ui_alien_datum)

/datum/hud/proc/draw_alien_backhud(datum/custom_hud/alien/ui_alien_datum)
	alien_backhud = new /atom/movable/screen/backhud/xeno()
	alien_backhud.icon = 'icons/mob/hud/cm_hud/cmhud_xeno_background.dmi'
	alien_backhud.screen_loc = ui_alien_datum.ui_backhud
	infodisplay += alien_backhud

/datum/hud/proc/draw_alien_resist(datum/custom_hud/alien/ui_alien_datum)
	var/atom/movable/screen/using = new /atom/movable/screen/resist()
	using.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi'
	using.screen_loc = ui_alien_datum.ui_alien_resist
	hotkeybuttons += using

/datum/hud/proc/draw_alien_rest(datum/custom_hud/alien/ui_alien_datum)
	var/atom/movable/screen/using = new /atom/movable/screen/rest()
	using.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi'
	using.screen_loc = ui_alien_datum.ui_alien_rest
	hotkeybuttons += using

/datum/hud/proc/draw_alien_health_doll(datum/custom_hud/alien/ui_alien_datum)
	alien_health_doll = new /atom/movable/screen/healths/xeno()
	alien_health_doll.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_health_doll.dmi'
	alien_health_doll.screen_loc = ui_alien_datum.ui_alien_health_doll
	infodisplay += alien_health_doll

/datum/hud/proc/draw_alien_nightvision(datum/custom_hud/alien/ui_alien_datum)
	var/atom/movable/screen/using = new /atom/movable/screen/xenonightvision()
	using.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi'
	using.screen_loc = ui_alien_datum.ui_alien_nightvision
	infodisplay += using
	add_verb(mymob, /datum/action/xeno_action/verb/verb_night_vision)

/datum/hud/proc/draw_alien_plasma_display(datum/custom_hud/alien/ui_alien_datum)
	alien_plasma_display = new /atom/movable/screen()
	alien_plasma_display.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi'
	alien_plasma_display.icon_state = "power_display2"
	alien_plasma_display.name = "plasma stored"
	alien_plasma_display.screen_loc = ui_alien_datum.ui_alienplasmadisplay
	infodisplay += alien_plasma_display

/datum/hud/proc/draw_alien_evo_display(datum/custom_hud/alien/ui_alien_datum)
	alien_evo_display = new /atom/movable/screen/xenoevo()
	alien_evo_display.icon = 'icons/mob/hud/cm_hud/cmhud_xeno_evolution.dmi'
	alien_evo_display.icon_state = "evo_0"
	alien_evo_display.name = "evolution progress"
	alien_evo_display.screen_loc = ui_alien_datum.ui_alien_evo_display
	infodisplay += alien_evo_display

/datum/hud/proc/draw_alien_locate_queen(datum/custom_hud/alien/ui_alien_datum)
	locate_leader = new /atom/movable/screen/queen_locator()
	locate_leader.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi'
	locate_leader.screen_loc = ui_alien_datum.ui_queen_locator
	infodisplay += locate_leader

/datum/hud/proc/draw_alien_locate_mark(datum/custom_hud/alien/ui_alien_datum)
	locate_marker = new /atom/movable/screen/mark_locator()
	locate_marker.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi'
	locate_marker.screen_loc = ui_alien_datum.ui_mark_locator
	infodisplay += locate_marker

/datum/hud/alien/persistent_inventory_update()
	if(!mymob || !ui_alien_datum)
		return
	var/mob/living/carbon/xenomorph/H = mymob
	if(H.r_hand)
		H.client.add_to_screen(H.r_hand)
		H.r_hand.screen_loc = ui_alien_datum.hud_slot_offset(H.r_hand, ui_alien_datum.ui_rhand)
		H.r_hand.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi'
	if(H.l_hand)
		H.client.add_to_screen(H.l_hand)
		H.l_hand.screen_loc = ui_alien_datum.hud_slot_offset(H.l_hand, ui_alien_datum.ui_lhand)
		H.l_hand.icon = 'icons/mob/hud/cm_hud/cm_hud_xeno_buttons.dmi'


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
