//ported from TGMC 04/07/21

///Footstep component. Plays footsteps at parents location when it is appropriate.
/datum/component/footstep
	dupe_mode = COMPONENT_DUPE_HIGHLANDER
	///how many steps before the footstep sound is played
	var/steps = 0
	///volume of soundfile see playsound()
	var/volume
	///range of soundfile see playsound()
	var/range
	///falloff of soundfile see playsound()
	var/falloff
	///This can be a list OR a soundfile OR null. Determines whatever sound gets played.
	var/footstep_sounds

/datum/component/footstep/Initialize(steps_ = 2, volume_ = 50, range_ = null, falloff_ = 1, footstep_sounds_ = "alien_footstep_large")
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	steps = steps_
	volume = volume_
	range = range_
	falloff = falloff_
	footstep_sounds = footstep_sounds_

	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), PROC_REF(play_simplestep))

/datum/component/footstep/proc/prepare_step()
	var/turf/open/T = get_turf(parent)
	if(!istype(T))
		return

	var/mob/living/LM = parent
	if(LM.buckled || LM.lying || LM.throwing || LM.is_ventcrawling)
		return

	if(LM.life_steps_total % steps)
		return

	return T

/datum/component/footstep/proc/play_simplestep()
	SIGNAL_HANDLER
	var/turf/open/T = prepare_step()
	if(!T)
		return
	if(isfile(footstep_sounds) || istext(footstep_sounds))
		playsound(T, footstep_sounds, volume, rand(20000, 25000), range, falloff = falloff)
