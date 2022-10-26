/// Displays targeting dot before enqueuing an actual ordnance effect
/datum/component/cas_timed_fuse
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Effect to enqueue
	var/datum/cas_effect/target_effect
	/// Warning atom-effect type
	var/warn_effect
	/// Delay between warning effect and main effect
	var/delay

/datum/component/cas_timed_fuse/Initialize(datum/cas_effect/target_effect, warn_effect = /obj/effect/overlay/temp/blinking_laser, delay = 1 SECONDS)
	if(!istype(parent, /datum/cas_firing_solution))
		return COMPONENT_INCOMPATIBLE
	src.target_effect = target_effect
	src.warn_effect = warn_effect
	src.delay = delay
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_IMPACT, .proc/impact)

/datum/component/cas_timed_fuse/proc/impact(source, atom/target)
	SIGNAL_HANDLER
	if(warn_effect)
		new warn_effect(target)
	target_effect.arm(parent)
	addtimer(CALLBACK(target_effect, /datum/cas_effect.proc/fire), delay)
