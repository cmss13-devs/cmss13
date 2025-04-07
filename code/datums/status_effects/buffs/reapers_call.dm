/datum/status_effect/reapers_call
	id = "reapers_call"
	status_type = STATUS_EFFECT_REFRESH
	duration = MOBA_REAPER_BOON_DURATION
	alert_type = null
	var/execute_threshold = MOBA_REAPER_BOON_EXECUTE_THRESHOLD

/datum/status_effect/reapers_call/on_creation(mob/living/new_owner, execute_threshold = MOBA_REAPER_BOON_EXECUTE_THRESHOLD)
	src.execute_threshold = execute_threshold
	return ..()

/datum/status_effect/reapers_call/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_XENO_ALIEN_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_ATOM_FIRED_PROJECTILE_HIT, PROC_REF(on_projectile_hit))
	RegisterSignal(owner, COMSIG_XENO_PHYSICAL_ABILITY_HIT, PROC_REF(on_ability_hit))

/datum/status_effect/reapers_call/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_XENO_ALIEN_ATTACK, COMSIG_ATOM_FIRED_PROJECTILE_HIT, COMSIG_XENO_PHYSICAL_ABILITY_HIT))

/datum/status_effect/reapers_call/proc/on_attack(datum/source, mob/living/carbon/xenomorph/attacking, damage)
	SIGNAL_HANDLER

	if(!HAS_TRAIT(attacking, TRAIT_MOBA_PARTICIPANT))
		return

	check_execute(attacking)

/datum/status_effect/reapers_call/proc/on_projectile_hit(datum/source, mob/living/carbon/xenomorph/attacking, obj/projectile/shot)
	SIGNAL_HANDLER

	if(!HAS_TRAIT(attacking, TRAIT_MOBA_PARTICIPANT))
		return

	check_execute(attacking)

/datum/status_effect/reapers_call/proc/on_ability_hit(datum/source, mob/living/carbon/xenomorph/attacking)
	SIGNAL_HANDLER

	if(!HAS_TRAIT(attacking, TRAIT_MOBA_PARTICIPANT))
		return

	check_execute(attacking)

/datum/status_effect/reapers_call/proc/check_execute(mob/living/carbon/xenomorph/xeno)
	if(QDELETED(xeno) || (xeno.stat == DEAD) || (HAS_TRAIT(xeno, TRAIT_MOBA_REAPER_BOON_EXECUTING)))
		return

	if(xeno.health <= (xeno.getMaxHealth() * execute_threshold))
		var/obj/effect/reapers_call/call_effect = new(null, xeno, owner)
		call_effect.to_execute.vis_contents += call_effect
		ADD_TRAIT(xeno, TRAIT_MOBA_REAPER_BOON_EXECUTING, TRAIT_SOURCE_INHERENT)

/obj/effect/reapers_call
	icon = 'icons/mob/xenos/castes/moba/elder_dragon.dmi'
	icon_state = "reaper_effect"
	alpha = 0
	mouse_opacity = FALSE
	layer = FLOAT_LAYER
	var/mob/living/carbon/xenomorph/to_execute
	var/mob/living/carbon/xenomorph/executor

/obj/effect/reapers_call/Initialize(mapload, mob/living/carbon/xenomorph/to_execute, mob/living/carbon/xenomorph/executor)
	. = ..()
	src.to_execute = to_execute
	src.executor = executor
	if(to_execute.icon_size == 48)
		pixel_x = -24
	else if(to_execute.icon_size == 64)
		pixel_x = -16
		pixel_y = 16
	animate(src, 0.6 SECONDS, alpha = 255)
	addtimer(CALLBACK(src, PROC_REF(execute)), 0.7 SECONDS)

/obj/effect/reapers_call/Destroy(force)
	to_execute.vis_contents -= src
	to_execute = null
	executor = null
	return ..()

/obj/effect/reapers_call/proc/execute()
	playsound(to_execute, 'sound/effects/reapers_call.ogg', 65, TRUE)
	to_execute.death(create_cause_data("reaper's call execution", executor))
	to_execute.add_filter("reapers_call_execute", 10, list("type" = "radial_blur", 0.4))
	animate(to_execute.get_filter("reapers_call_execute"), 0.3 SECONDS, size = 0.01)
	animate(src, 0.4 SECONDS, alpha = 0)
	QDEL_IN(src, 0.5 SECONDS)

