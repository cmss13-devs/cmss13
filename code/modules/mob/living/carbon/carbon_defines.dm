/mob/living/carbon
	gender = MALE
	var/list/stomach_contents = list()

	var/life_tick = 0      // The amount of life ticks that have processed on this mob.
	var/analgesic = 0 // when this is set, the mob isn't affected by shock or pain
					  // life should decrease this by 1 every tick

	var/obj/item/handcuffs/handcuffed = null //Whether or not the mob is handcuffed
	//Active emote/pose
	var/pose = null

	var/pulse = PULSE_NORM	//current pulse level
	var/butchery_progress = 0
	var/list/internal_organs = list()
	//blood.dm
	blood_volume = BLOOD_VOLUME_NORMAL