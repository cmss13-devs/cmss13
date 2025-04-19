/datum/xeno_ai_movement/crusher

/datum/xeno_ai_movement/crusher/New(mob/living/carbon/xenomorph/parent)
	. = ..()

	RegisterSignal(parent, COMSIG_XENO_STOPPED_CHARGING, PROC_REF(stop_charging))

#define MAX_CHARGE_DISTANCE 30

/datum/xeno_ai_movement/crusher/ai_move_target(delta_time)
	var/mob/living/carbon/xenomorph/moving_xeno = parent

	if(moving_xeno.throwing)
		return ..()

	var/datum/action/xeno_action/onclick/charger_charge/charge_action = locate() in moving_xeno.actions

	if(!charge_action)
		return ..()

	if(!charge_action.charge_dir)
		return ..()

	if(charge_action.steps_taken > MAX_CHARGE_DISTANCE)
		stop_charging()
		return ..()

	if(!moving_xeno.can_move_and_apply_move_delay())
		return TRUE

	var/turf/next_turf = get_step(moving_xeno, charge_action.charge_dir)
	if(!moving_xeno.Move(next_turf, charge_action.charge_dir))
		stop_charging()

	return TRUE

#undef MAX_CHARGE_DISTANCE

/datum/xeno_ai_movement/crusher/proc/stop_charging()
	SIGNAL_HANDLER

	var/datum/action/xeno_action/onclick/charger_charge/charge_action = locate() in parent.actions

	if(!charge_action)
		return

	if(!charge_action.activated)
		return

	INVOKE_ASYNC(charge_action, TYPE_PROC_REF(/datum/action/xeno_action/onclick/charger_charge, use_ability_wrapper))
	COOLDOWN_RESET(parent, forced_retarget_cooldown)
