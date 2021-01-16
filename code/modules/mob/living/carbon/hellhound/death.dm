
/mob/living/carbon/hellhound/death(var/cause, var/gibbed)
	emote("roar")
	GLOB.hellhound_list -= src
	SSmob.living_misc_mobs -= src
	..(cause, gibbed, "lets out a horrible roar as it collapses and stops moving...")
