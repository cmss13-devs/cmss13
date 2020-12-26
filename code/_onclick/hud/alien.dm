/datum/hud/alien
	var/datum/custom_hud/alien/ui_alien_datum

/datum/hud/alien/New(mob/living/carbon/Xenomorph/owner)
	..()
	ui_alien_datum = custom_huds_list["alien"]

	draw_act_intent(ui_alien_datum)
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
	draw_nightvision(ui_alien_datum)
	draw_plasma_display(ui_alien_datum)
	draw_armor_display(ui_alien_datum)
	draw_locate_queen(ui_alien_datum)

/datum/hud/alien/proc/draw_nightvision(var/datum/custom_hud/alien/ui_alien_datum)
	var/obj/screen/using = new /obj/screen/xenonightvision()
	using.icon = ui_alien_datum.ui_style_icon
	using.screen_loc = ui_alien_datum.ui_alien_nightvision
	infodisplay += using
	add_verb(mymob, /datum/action/xeno_action/verb/verb_night_vision)

/datum/hud/alien/proc/draw_plasma_display(var/datum/custom_hud/alien/ui_alien_datum)
	alien_plasma_display = new /obj/screen()
	alien_plasma_display.icon = ui_alien_datum.ui_style_icon
	alien_plasma_display.icon_state = "power_display2"
	alien_plasma_display.name = "plasma stored"
	alien_plasma_display.screen_loc = ui_alien_datum.ui_alienplasmadisplay
	infodisplay += alien_plasma_display

/datum/hud/alien/proc/draw_armor_display(var/datum/custom_hud/alien/ui_alien_datum)
	alien_armor_display = new /obj/screen()
	alien_armor_display.icon = ui_alien_datum.ui_style_icon
	alien_armor_display.icon_state = "armor_100"
	alien_armor_display.name = "armor integrity"
	alien_armor_display.screen_loc = ui_alien_datum.ui_alienarmordisplay
	infodisplay += alien_armor_display

/datum/hud/alien/proc/draw_locate_queen(var/datum/custom_hud/alien/ui_alien_datum)
	locate_leader = new /obj/screen/queen_locator()
	locate_leader.icon = ui_alien_datum.ui_style_icon
	locate_leader.screen_loc = ui_alien_datum.ui_queen_locator
	infodisplay += locate_leader

/datum/hud/alien/persistant_inventory_update()
	if(!mymob || !ui_alien_datum)
		return
	var/mob/living/carbon/Xenomorph/H = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		if(H.r_hand)
			H.r_hand.screen_loc = ui_alien_datum.ui_rhand
			H.client.screen += H.r_hand
		if(H.l_hand)
			H.l_hand.screen_loc = ui_alien_datum.ui_lhand
			H.client.screen += H.l_hand
	else
		if(H.r_hand)
			H.r_hand.screen_loc = null
		if(H.l_hand)
			H.l_hand.screen_loc = null


/mob/living/carbon/Xenomorph/create_hud()
	if(!hud_used)
		hud_used = new /datum/hud/alien(src)


/datum/hud/larva/New(mob/living/carbon/Xenomorph/Larva/owner)
	..()
	var/datum/custom_hud/alien/ui_alien_datum = custom_huds_list["alien"]

	draw_healths(ui_alien_datum)

	var/obj/screen/using = new /obj/screen/xenonightvision()
	using.icon = ui_alien_datum.ui_style_icon
	using.screen_loc = ui_alien_datum.ui_alien_nightvision
	infodisplay += using

	locate_leader = new /obj/screen/queen_locator()
	locate_leader.icon = ui_alien_datum.ui_style_icon
	locate_leader.screen_loc = ui_alien_datum.ui_queen_locator
	infodisplay += locate_leader


/mob/living/carbon/Xenomorph/Larva/create_hud()
	if(!hud_used)
		hud_used = new /datum/hud/larva(src)
