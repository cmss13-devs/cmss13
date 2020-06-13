

/mob/living/carbon/proc/handle_grabbed()
	if(!pulledby)
		return
	if(pulledby.grab_level >= GRAB_AGGRESSIVE)
		drop_held_items()

	if(pulledby.grab_level >= GRAB_NECK)
		apply_damage(3, OXY)

	if(pulledby.grab_level >= GRAB_KILL)
		apply_damage(3, OXY)

