/**
 * Represents an intended firing solution for CAS weaponry
 * This comprises of what's being shot, what at, and how
 * The firing solution handles both pre-fire, flight, and
 * impact, but delegates the greater part to components
 */

/datum/cas_firing_solution
	/// User-friendly name of firing instance
	var/name = "Abstract Firing Solution"
	/// Intended target
	var/atom/target
	/// Electronic signature target
	var/datum/cas_signal/signal_target
	/// Entity credited for firing this
	var/mob/source_mob
	/// Firing direction, or NONE if non applicable
	var/dir = NONE
	/// Type of firing solution: CAS_MODE_FM | CAS_MODE_DIRECT
	var/mode = NONE
	/// Firing status: IDLE, FIRED, IMPACT
	var/status = CAS_FIRING_IDLE

/datum/cas_firing_solution/Destroy()
	target = null
	signal_target = null
	source_mob = null
	STOP_PROCESSING(SScasp, src)
	return ..()

/datum/cas_firing_solution/process(delta_time)
	if(status <= CAS_FIRING_IDLE)
		return

	var/ret = SEND_SIGNAL(src, COMSIG_CAS_SOLUTION_PROCESS, delta_time)

	// An impacted projectile just waits until all its components resolve
	if(status == CAS_FIRING_IMPACT)
		if(ret & COMPONENT_CAS_SOLUTION_PROCESSING)
			return
		qdel(src)
		return PROCESS_KILL

	// Interception occurs first, disabling us entirely
	if(ret & COMPONENT_CAS_SOLUTION_INTERCEPT)
		status = CAS_FIRING_IMPACT
		SEND_SIGNAL(src, COMSIG_CAS_SOLUTION_INTERCEPTED, target)
		return

	// An impact request during processing sets projectile to terminal
	if(ret & COMPONENT_CAS_SOLUTION_IMPACT)
		status = CAS_FIRING_TERMINAL
	if(status != CAS_FIRING_TERMINAL)
		return

	// Terminal validation may hold the actual impact or cause a miss
	var/validate = SEND_SIGNAL(src, COMSIG_CAS_SOLUTION_TERMINAL, target)
	if(validate & COMPONENT_CAS_SOLUTION_MISS)
		SEND_SIGNAL(src, COMSIG_CAS_SOLUTION_MISSED, target)
		status = CAS_FIRING_IMPACT
		return
	if(validate & COMPONENT_CAS_SOLUTION_HOLD)
		return

	// Enter impact mode, this is final
	status = CAS_FIRING_IMPACT
	SEND_SIGNAL(src, COMSIG_CAS_SOLUTION_IMPACT, target)

/datum/cas_firing_solution/proc/fire(atom/target, datum/cas_signal/signal_target)
	if(status != CAS_FIRING_IDLE)
		return FALSE
	if(target)
		src.target = target
	if(signal_target)
		src.signal_target = signal_target
	if(!target && !signal_target)
		return FALSE
	RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/target_lost)
	RegisterSignal(signal_target, COMSIG_PARENT_QDELETING, .proc/signal_lost)
	. = TRUE
	status = CAS_FIRING_FIRED
	START_PROCESSING(SScasp, src)

/datum/cas_firing_solution/proc/retarget(atom/target)
	SHOULD_NOT_SLEEP(TRUE)
	UnregisterSignal(src.target, COMSIG_PARENT_QDELETING)
	src.target = target
	RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/target_lost)
	SEND_SIGNAL(src, COMSIG_CAS_SOLUTION_RETARGETED)

/datum/cas_firing_solution/proc/target_lost()
	SIGNAL_HANDLER
	var/old_target = src.target
	src.target = null
	SEND_SIGNAL(src, COMSIG_CAS_SOLUTION_RETARGET, old_target)

/datum/cas_firing_solution/proc/signal_lost()
	SIGNAL_HANDLER
	src.signal_target = null
