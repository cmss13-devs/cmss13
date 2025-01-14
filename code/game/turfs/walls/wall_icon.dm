#define BULLETHOLE_STATES 10 //How many variations of bullethole patterns there are
//Formulas. These don't need to be defines, but helpful green. Should likely reuse these for a base 8 icon system.
#define cur_increment(v) round((v-1)/8)+1

/turf/closed/wall/update_overlays()
	. = ..()
	if(!.)
		return

	if(!damage_overlays[1]) //list hasn't been populated
		generate_damage_overlays()

	add_cleanable_overlays()

	//smooth wall stuff
	if(!special_icon)
		icon_state = "blank"
		var/image/I

		flags_atom |= HTML_USE_INITAL_ICON

		if(!density)
			I = image(icon, "[walltype]fwall_open")
			overlays += I
			return

	if(damage)
		var/current_dmg_overlay = round(damage / damage_cap * damage_overlays.len) + 1
		if(current_dmg_overlay > damage_overlays.len)
			current_dmg_overlay = damage_overlays.len

		damage_overlay = current_dmg_overlay
		overlays += damage_overlays[damage_overlay]

		if(current_bulletholes)
			if(!bullet_overlay)
				var/bullethole_state = rand(1, BULLETHOLE_STATES)
				bullet_overlay = image('icons/effects/bulletholes.dmi', src, "bhole_[bullethole_state]_2")
			overlays += bullet_overlay

#undef BULLETHOLE_STATES
#undef cur_increment

/turf/closed/wall/proc/generate_damage_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.appearance_flags = NO_CLIENT_COLOR
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

/turf/closed/wall/get_base_icon()
	return walltype
