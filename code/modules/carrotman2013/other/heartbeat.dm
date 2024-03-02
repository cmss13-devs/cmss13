//heart sounds
#define SOUND_CHANNEL_HEART 724

/mob/living/carbon/proc/heartbeating()
	if(heartpouncecooldown > world.time)
		return
	if(heartbeatingcooldown > world.time)
		return
	else if(heartbeatingcooldown < world.time)
		playsound_client(src, 'code/modules/carrotman2013/sounds/heartbeat/heartbeat.ogg',vol=40,channel=SOUND_CHANNEL_HEART)
		heartbeatingcooldown = world.time + 515

/mob/living/carbon/proc/heartpounce()
	if(heartbeatingcooldown > world.time)
		return
	if(heartpouncecooldown > world.time)
		return
	else if(heartpouncecooldown < world.time)
		playsound_client(src, 'sound/effects/Heart Beat Short.ogg',vol=90,channel=SOUND_CHANNEL_HEART)
		heartpouncecooldown = world.time + 15
