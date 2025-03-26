/datum/status_effect/stacking/rapid_claws
	id = "rapid_claws"
	consumed_on_threshold = FALSE
	tick_interval = 4 SECONDS
	alert_type = null
	should_delete_at_no_stacks = FALSE
	max_stacks = 3
	var/given_player_lifesteal = 0
	var/datum/weakref/last_hit_mob

/datum/status_effect/stacking/rapid_claws/on_apply()
	. = ..()
	stacks = 0
	RegisterSignal(owner, COMSIG_XENO_ALIEN_ATTACK, PROC_REF(add_stacks))
	RegisterSignal(owner, COMSIG_MOB_ALIEN_ATTACK, PROC_REF(add_stacks))
	if(owner.hud_used?.locate_leader)
		owner.hud_used.locate_leader.maptext = "<span class='maptext' style='color: white'>Slashes: <b>[stacks]</b>/<b>[max_stacks]</b></span>"
		owner.hud_used.locate_leader.maptext_width = 128
		owner.hud_used.locate_leader.maptext_x = -48
		owner.hud_used.locate_leader.maptext_y = 192

/datum/status_effect/stacking/rapid_claws/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_XENO_ALIEN_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ALIEN_ATTACK)
	if(owner.hud_used?.locate_leader)
		owner.hud_used.locate_leader.maptext = null

/datum/status_effect/stacking/rapid_claws/tick(seconds_between_ticks)
	stacks = 0
	if(owner.hud_used?.locate_leader)
		owner.hud_used.locate_leader.maptext = "<span class='maptext' style='color: white'>Slashes: <b>[stacks]</b>/<b>[max_stacks]</b></span>"

/datum/status_effect/stacking/rapid_claws/add_stacks(mob/living/carbon/xenomorph/source, mob/living/carbon/xenomorph/attacking, damage)
	if(!attacking) // sometimes it just doesn't
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.hive.is_ally(attacking))
		return // in case friendly-fire with slashes is somehow possible

	if(last_hit_mob)
		if(last_hit_mob.resolve() != attacking)
			stacks = 0
			last_hit_mob = WEAKREF(attacking)
	else
		last_hit_mob = WEAKREF(attacking)

	tick_interval = world.time + initial(tick_interval) //refreshing the timer
	stacks++

	if(xeno.hud_used?.locate_leader)
		xeno.hud_used.locate_leader.maptext = "<span class='maptext' style='color: #FFA500'>Slashes: <b>[stacks]</b>/<b>[max_stacks]</b></span>"

	if(stacks >= max_stacks)
		playsound(xeno.loc, "alien_roar", 25, FALSE)
		addtimer(CALLBACK(src, PROC_REF(additional_slash), attacking), 0.3 SECONDS)
		stacks = 0

/datum/status_effect/stacking/rapid_claws/proc/additional_slash(mob/living/carbon/xenomorph/attacking)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.a_intent_change(INTENT_HARM)
	attacking.attack_alien(owner) // pretty confusing, but its actually us attacking the target
	owner.next_move -= 0.3 SECONDS // redeeming cd from additional slash
	stacks = 0
	if(owner.hud_used?.locate_leader)
		// showing a 3/3 count for a brief moment
		owner.hud_used.locate_leader.maptext = "<span class='maptext' style='color: red'>Slashes: <b>[stacks]</b>/<b>[max_stacks]</b></span>"
