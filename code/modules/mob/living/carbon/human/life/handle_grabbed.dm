

/mob/living/carbon/proc/handle_grabbed()
	if(!pulledby)
		return
	if(pulledby.grab_level >= GRAB_AGGRESSIVE)
		drop_held_items()

	if(pulledby.grab_level >= GRAB_CHOKE)
		apply_damage(3, OXY)
		apply_stamina_damage(5)

		log_attack("[key_name(pulledby)] choked [key_name(src)] at [get_area_name(src)]")
		attack_log += text("\[[time_stamp()]\] <font color='orange'>was choked by [key_name(pulledby)]</font>")
		pulledby.attack_log += text("\[[time_stamp()]\] <font color='red'>choked [key_name(src)]</font>")
