var/datum/subsystem/spacial_sound/SSspacial_sound

/datum/sound_coord //This datum's purpose is to  
	var/map_x	//Map coordinates indicating the position of this sound
	var/map_y
	var/map_z
	var/channel //the channel in which the sound is playing. It should be the same channel for everyone
	var/range 
	var/duration //after this time mark the sound will (theoretically) have ended
	var/time_of_creation

/datum/subsystem/spacial_sound
	name          = "Spacial Sound"
	wait          = 1 SECONDS
	priority      = SS_PRIORITY_SPACIAL_SOUNDS
	var/list/sound_coords = list()
	var/list/currentrun = list()

/datum/subsystem/spacial_sound/New()
	NEW_SS_GLOBAL(SSspacial_sound)
	
/datum/subsystem/spacial_sound/fire(resumed = FALSE)
	if(!resumed)
		currentrun = sound_coords.Copy()
	
	while(currentrun.len)
		var/datum/sound_coord/S = currentrun[currentrun.len]
		currentrun.len--
		if(world.time - S.time_of_creation >= S.duration)
			sound_coords.Remove(S)
			qdel(S)
		
		if(MC_TICK_CHECK)
			return

/datum/subsystem/spacial_sound/proc/add_spacial_sound(sound/S, atom/origin, range, duration)
	var/datum/sound_coord/C = new()
	var/turf/T = get_turf(origin)
	C.map_x = T.x
	C.map_y	= T.y
	C.map_z = T.z
	C.channel = S.channel
	C.duration = duration
	C.range = range
	C.time_of_creation = world.time
	sound_coords += C
