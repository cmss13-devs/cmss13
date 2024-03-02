/datum/hud/human/yautja/draw_oxygen(datum/custom_hud/ui_datum)
	pred_power_icon = new /atom/movable/screen/yautja_power()
	pred_power_icon.icon = 'icons/mob/hud/hud_yautja.dmi'
	pred_power_icon.icon_state = "powerbar100"
	pred_power_icon.name = "bracer power stored"
	pred_power_icon.screen_loc = ui_predator_power
	infodisplay += pred_power_icon


/mob/living/carbon/human/yautja/create_hud()
	if(client && !hud_used)
		var/ui_datum = GLOB.custom_huds_list[client.prefs.UI_style]
		var/ui_color = client.prefs.UI_style_color
		var/ui_alpha = client.prefs.UI_style_alpha
		hud_used = new /datum/hud/human/yautja(src, ui_datum, ui_color, ui_alpha)
	else
		hud_used = new /datum/hud/human/yautja(src)


/atom/movable/screen/yautja_power/clicked(mob/living/carbon/human/user, mods)
	. = ..()
	if(!istype(user))
		return

	var/obj/item/clothing/gloves/yautja/hunter/bracers = user.gloves
	if(!istype(bracers))
		return

	to_chat(user, SPAN_DANGER("[bracers] currently have <b>[bracers.charge]/[bracers.charge_max]</b> charge."))
