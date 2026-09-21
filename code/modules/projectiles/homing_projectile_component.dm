/datum/component/homing_projectile
	dupe_mode = COMPONENT_DUPE_HIGHLANDER
	var/atom/homing_target

/datum/component/homing_projectile/Initialize(atom/homing_target, mob/shooter)
	if(!istype(parent, /obj/projectile))
		return COMPONENT_INCOMPATIBLE

	if(isliving(homing_target))
		var/mob/living/living_target = homing_target
		if(living_target.is_dead())
			return COMPONENT_INCOMPATIBLE

	if(shooter && ishuman(homing_target))  // Don't track friendlies
		var/mob/living/carbon/human/human_target = homing_target
		var/obj/projectile/projectile = parent
		if(SEND_SIGNAL(parent, COMSIG_BULLET_CHECK_MOB_SKIPPING, human_target) & COMPONENT_SKIP_MOB\
			|| projectile.runtime_iff_group && human_target.get_target_lock(projectile.runtime_iff_group)\
		)
			return COMPONENT_INCOMPATIBLE

	src.homing_target = homing_target

/datum/component/homing_projectile/RegisterWithParent()
	RegisterSignal(parent, COMSIG_BULLET_STEP, PROC_REF(step_retarget))
	RegisterSignal(parent, COMSIG_BULLET_TERMINAL, PROC_REF(terminal_retarget))

/datum/component/homing_projectile/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_BULLET_STEP, COMSIG_BULLET_TERMINAL))
	homing_target = null

/datum/component/homing_projectile/Destroy()
	homing_target = null
	return ..()

// Continuously re-aims toward the target's live position every tick of flight
/datum/component/homing_projectile/proc/step_retarget()
	SIGNAL_HANDLER
	if(QDELETED(homing_target))
		return
	var/obj/projectile/projectile = parent
	var/turf/homing_turf = get_turf(homing_target)
	if(!homing_turf || homing_turf == get_turf(projectile))
		return
	projectile.retarget(homing_turf, keep_angle = FALSE)

/datum/component/homing_projectile/proc/terminal_retarget()
	SIGNAL_HANDLER
	var/obj/projectile/projectile = parent
	var/turf/homing_turf = get_turf(homing_target)
	projectile.speed *= 2 // Double speed to ensure hitting next tick despite eventual movement
	projectile.retarget(homing_turf, keep_angle = FALSE)
	qdel(src)
