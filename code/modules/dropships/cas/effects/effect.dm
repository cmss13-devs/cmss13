/// Generic effect to be scheduled for processing, eg. weapon hits or visual effects
/datum/cas_effect
	var/name = "Unnamed CAS Effect"

/datum/cas_effect/proc/fire()
	START_PROCESSING(SScasp, src)
