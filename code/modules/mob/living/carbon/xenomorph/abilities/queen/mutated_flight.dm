/datum/action/xeno_action/activable/flight
	name = "Flight"
	action_icon_state = "flight"
	plasma_cost = 200
	xeno_cooldown = 1 MINUTES
	var/max_distance = 5
	var/speed = 5

/datum/action/xeno_action/activable/flight/can_use_action()
	. = ..()
	if(!.)
		return FALSE

/datum/action/xeno_action/activable/flight/use_ability(atom/target)
	if(!..())
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	if(isstorage(target.loc) || xeno.contains(target) || istype(target, /atom/movable/screen)) return FALSE

	if(!xeno.check_plasma(plasma_cost))
		to_chat(owner, SPAN_XENOWARNING("You have insufficient plasma to do this."))
		return FALSE
	if(target.z != xeno.z)
		to_chat(owner, SPAN_XENOWARNING("Not even you can fly that far!"))
		return FALSE
	apply_cooldown()

	use_plasma_owner()
	playsound(owner, 'sound/effects/wingflap.ogg')
	owner.visible_message(SPAN_DANGER("\The [src] spreads their wings and leaps into the air!"), \
		SPAN_DANGER("You spread your wings and leap into the air!"), null, 5, CHAT_TYPE_XENO_COMBAT)

	var/turf/t_turf = get_turf(target)
	var/obj/effect/warning/hover/warning = new(t_turf)
	calculate_warning_turf(warning, owner, t_turf)

	//has sleep

	RegisterSignal(owner, COMSIG_CLIENT_MOB_MOVE, PROC_REF(disable_flying_movement))
	owner.throw_atom(t_turf, max_distance, speed, launch_type = HIGH_LAUNCH)
	UnregisterSignal(owner, COMSIG_CLIENT_MOB_MOVE)
	qdel(warning)

/datum/action/xeno_action/activable/flight/proc/disable_flying_movement(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	return COMPONENT_OVERRIDE_MOVE

/datum/action/xeno_action/activable/flight/proc/calculate_warning_turf(obj/effect/warning/warning, mob/living/user, turf/t_turf)
	var/t_dist = get_dist(user, t_turf)
	if(!(t_dist > max_distance))
		return
	var/list/turf/path = getline2(user, t_turf, FALSE)
	warning.forceMove(path[max_distance])
