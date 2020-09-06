

/mob/living/carbon/proc/handle_grabbed()
	if(!pulledby)
		return
	if(pulledby.grab_level >= GRAB_AGGRESSIVE)
		drop_held_items()

	if(pulledby.grab_level >= GRAB_CHOKE)
		apply_damage(3, OXY)
		apply_stamina_damage(5)
