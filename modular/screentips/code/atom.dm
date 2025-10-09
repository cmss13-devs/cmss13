/// Fired whenever this atom is the most recent to be hovered over in the tick.
/// Preferred over MouseEntered if you do not need information such as the position of the mouse.
/// Especially because this is deferred over a tick, do not trust that `client` is not null.
/atom/proc/on_mouse_enter(client/client)
	SHOULD_NOT_SLEEP(TRUE)

	var/mob/user = client?.mob
	if (isnull(user))
		return

	// Screentips
	var/datum/hud/active_hud = user.hud_used
	if(!active_hud)
		return

	var/screentips_enabled = active_hud.screentips_enabled
	if(screentips_enabled == FALSE || flags_atom & NO_SCREENTIPS)
		active_hud.screentip_text.maptext = ""
		return

	var/extra_lines = 0
	var/extra_context = ""
	var/used_name = declent_ru(NOMINATIVE)

	//We inline a MAPTEXT() here, because there's no good way to statically add to a string like this
	var/new_maptext = "<span class='context' style='text-align: center; color: [active_hud.screentip_color]'>[used_name][extra_context]</span>"

	if (length_char(used_name) * 10 > active_hud.screentip_text.maptext_width)
		INVOKE_ASYNC(src, PROC_REF(set_hover_maptext), client, active_hud, new_maptext)
		return

	active_hud.screentip_text.maptext = new_maptext
	active_hud.screentip_text.maptext_y = -20 - (extra_lines > 0 ? 11 + 9 * (extra_lines - 1): 0)

/atom/proc/set_hover_maptext(client/client, datum/hud/active_hud, new_maptext)
	var/map_height
	WXH_TO_HEIGHT_2(client.MeasureText(new_maptext, null, active_hud.screentip_text.maptext_width), map_height)
	active_hud.screentip_text.maptext = new_maptext
	active_hud.screentip_text.maptext_y = -4 - map_height
