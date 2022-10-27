/// Displays targeting dot holding impact
/datum/component/cas_warning_dot
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/delay
	var/effect_type
	var/active = FALSE
	var/atom/movable/effect

/datum/component/cas_warning_dot/Initialize(delay = 1 SECONDS, effect_type = /obj/effect/overlay/temp/blinking_laser)
	src.delay = delay
	src.effect_type = effect_type
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_TERMINAL, .proc/check)
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_PROCESS,  .proc/tick)
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_RETARGETED, .proc/move)

/datum/component/cas_warning_dot/proc/check(source, atom/target)
	SIGNAL_HANDLER
	if(!active)
		var/turf/T = get_turf(target)
		effect = new effect_type(T)
		RegisterSignal(effect, COMSIG_PARENT_QDELETING, .proc/cleanup)
		active = TRUE
	if(delay <= 0)
		qdel(src)
		return
	return COMPONENT_CAS_SOLUTION_HOLD

/datum/component/cas_warning_dot/proc/tick(source, delta_time)
	SIGNAL_HANDLER
	if(delay > 0 && active)
		delay -= delta_time * 10

/datum/component/cas_warning_dot/proc/move(source, atom/target)
	SIGNAL_HANDLER
	if(effect)
		effect.forceMove(get_turf(target))

/datum/component/cas_warning_dot/proc/cleanup()
	SIGNAL_HANDLER
	effect = null
