/mob/living/carbon
	gender = MALE
	var/list/stomach_contents = list()

	var/life_tick = 0      // The amount of life ticks that have processed on this mob.

	var/obj/item/handcuffs/handcuffed = null //Whether or not the mob is handcuffed

	var/overeat_cooldown = 0

	//Active emote/pose
	var/pose = null

	var/pulse = PULSE_NORM	//current pulse level
	var/butchery_progress = 0
	var/list/internal_organs = list()
	var/huggable = TRUE //can apply Facehuggers (still checks proc/can_hug())
	var/surgical_difficulty = SKILL_SURGERY_TRAINED //The level of surgical skill required to operate on this mob.

	//blood.dm
	blood_volume = BLOOD_VOLUME_NORMAL

	var/hivenumber