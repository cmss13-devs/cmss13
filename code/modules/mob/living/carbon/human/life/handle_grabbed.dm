

/mob/living/carbon/proc/handle_grabbed()
	if(!pulledby)
		return
	if(pulledby.grab_level >= GRAB_AGGRESSIVE)
		drop_held_items()

	if(pulledby.grab_level >= GRAB_NECK)
		losebreath = min(losebreath + 2, 3)

	if(pulledby.grab_level >= GRAB_KILL)
		apply_damage(3, OXY)

