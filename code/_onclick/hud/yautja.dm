/datum/hud/human/yautja/draw_locator_spot(datum/custom_hud/ui_datum)
	pred_power_icon = new /atom/movable/screen()
	pred_power_icon.icon = 'icons/mob/hud/hud_yautja.dmi'
	pred_power_icon.icon_state = "powerbar10"
	pred_power_icon.name = "bracer power stored"
	pred_power_icon.screen_loc = ui_predator_power
	infodisplay += pred_power_icon

/mob/living/carbon/human/yautja
	skin_color = "tan"
	body_type = "pred"

/mob/living/carbon/human/yautja/create_hud()
	if(client && !hud_used)
		var/ui_datum = GLOB.custom_huds_list[client.prefs.UI_style]
		var/ui_color = client.prefs.UI_style_color
		var/ui_alpha = client.prefs.UI_style_alpha
		hud_used = new /datum/hud/human/yautja(src, ui_datum, ui_color, ui_alpha)
	else
		hud_used = new /datum/hud/human/yautja(src)
