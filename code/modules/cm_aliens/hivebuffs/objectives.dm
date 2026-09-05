/obj/effect/landmark/xeno_objective_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_objective_landmarks += src
	if(mapload)
		addtimer(CALLBACK(src, PROC_REF(announce_incoming)), rand(2 MINUTES, 3 MINUTES))


/obj/effect/landmark/xeno_objective_spawn/Destroy()
	GLOB.xeno_objective_landmarks -= src
	return ..()


/obj/effect/landmark/xeno_objective_spawn/proc/announce_incoming()
	if(!length(GLOB.xeno_objective_landmarks))
		return

	var/obj/effect/landmark/xeno_objective_spawn/chosen = pick(GLOB.xeno_objective_landmarks)

	for(var/obj/effect/landmark/xeno_objective_spawn/other_landmark in GLOB.xeno_objective_landmarks)
		if(other_landmark != chosen)
			GLOB.xeno_objective_landmarks -= other_landmark
			qdel(other_landmark)

	var/area/objective_area = get_area(chosen)
	xeno_announcement(SPAN_XENOANNOUNCE("The weeds have given us a boon at [objective_area]. Move forward and claim it now.."), XENO_HIVE_NORMAL, XENO_GENERAL_ANNOUNCE)

	addtimer(CALLBACK(chosen, PROC_REF(spawn_objective)), 1 MINUTES)

/obj/effect/landmark/xeno_objective_spawn/proc/spawn_objective()
	for(var/turf/closed/wall/resin/resin_turf in range(2, src))
		resin_turf.ScrapeAway() // Theres no way this is the only way to do this. it sucks.

	new /obj/effect/alien/resin/xeno_objective(loc)
	GLOB.xeno_objective_landmarks -= src
	qdel(src)

// REWARDS, i put it here because i dont want to bloat the main files
/datum/action/xeno_action/activable/build_tunnel/queen
	name = "Dig Royal Tunnel"
	action_icon_state = "build_tunnel"
	plasma_cost = 0
	xeno_cooldown = 0
	action_type = XENO_ACTION_CLICK





/datum/action/xeno_action/activable/build_tunnel/queen/use_ability(atom/target_atom, mods)
	var/mob/living/carbon/xenomorph/queen/queen = owner

	. = ..()
	if(!istype(queen))
		return

	if(!queen.ovipositor)
		to_chat(queen, SPAN_XENOWARNING("We must be seated upon our ovipositor to do this."))
		return

	var/datum/hive_status/hive = queen.hive
	if(hive?.tunnel_used)
		to_chat(queen, SPAN_XENOWARNING("We already put down a tunnel."))
		return

	if(mods && mods[CLICK_CATCHER])
		return

	var/turf/target_turf = get_turf(target_atom)
	if(!target_turf)
		return

	var/area/target_area = get_area(target_turf)
	if(!target_turf.can_dig_xeno_tunnel() || !is_ground_level(target_turf.z) || target_area.flags_area & AREA_NOTUNNEL)
		to_chat(queen, SPAN_XENOWARNING("We cannot carve through that kind of floor."))
		return

	if(locate(/obj/structure/tunnel) in target_turf)
		to_chat(queen, SPAN_XENOWARNING("There already is a tunnel there."))
		return

	if(isnull(target_area) || !target_area.is_resin_allowed)
		to_chat(queen, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
		return

	if(!do_after(queen, 10 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(queen, SPAN_WARNING("Our tunnel caves in as we stop plasing it."))
		return

	if(hive.tunnel_used)
		return


	to_chat(queen, SPAN_XENOWARNING("We start building a tunnel"))
	new /obj/structure/tunnel(target_turf, queen.hivenumber)
	hive.tunnel_used = TRUE
	remove_action(queen, /datum/action/xeno_action/activable/build_tunnel/queen)

	xeno_message(SPAN_XENOANNOUNCE("The Queen has carved a royal tunnel at [get_area_name(target_turf)]."), 3, queen.hivenumber)

	return TRUE

/obj/effect/xenomorph/queen_bombard
	name = "???"
	desc = ""
	icon_state = "boiler_bombard"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/damage = 20
	var/time_before_smoke = 2.5 SECONDS
	var/time_before_damage = 1.5 SECONDS
	var/smoke_duration = 9
	var/smoke_type = /obj/effect/particle_effect/smoke/xeno_burn

	var/mob/living/carbon/xenomorph/source_xeno = null

/obj/effect/xenomorph/queen_bombard/New(loc, source_xeno = null)
	if(isxeno(source_xeno))
		src.source_xeno = source_xeno

	if(isturf(loc))
		var/turf/bombard_turf = loc
		if(!bombard_turf.density)
			..(loc)
		else
			qdel(src)
			return
	else
		qdel(src)
		return

	addtimer(CALLBACK(src, PROC_REF(damage_mobs)), time_before_damage)
	addtimer(CALLBACK(src, PROC_REF(make_smoke)), time_before_smoke)

/obj/effect/xenomorph/queen_bombard/proc/damage_mobs()
	if(!istype(src) || !isturf(loc))
		qdel(src)
		return

	for(var/mob/living/carbon/victim in loc)
		if(isxeno(victim))
			if(!source_xeno)
				continue
			var/mob/living/carbon/xenomorph/hit_xeno = victim
			if(source_xeno.can_not_harm(hit_xeno))
				continue

		if(!victim.stat)
			if(source_xeno?.can_not_harm(victim))
				continue
			victim.apply_armoured_damage(damage, ARMOR_BIO, BURN)
			animation_flash_color(victim)
			to_chat(victim, SPAN_XENODANGER("You are scalded by acid as a massive glob explodes nearby!"))

	icon_state = "boiler_bombard"

/obj/effect/xenomorph/queen_bombard/proc/make_smoke()
	var/obj/effect/particle_effect/smoke/gas = new smoke_type(loc, 1, create_cause_data(initial(source_xeno?.caste_type), source_xeno))
	gas.time_to_live = smoke_duration
	gas.spread_speed = smoke_duration + 5 // No spreading

	qdel(src)

/datum/action/xeno_action/activable/bombard
	name = "Bombard"
	action_icon_state = "bombard"
	plasma_cost = 75
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 230

	var/effect_range = 3
	var/effect_type = /obj/effect/xenomorph/queen_bombard
	var/activation_delay = 1.5 SECONDS
	var/range = 15
	var/interrupt_flags = INTERRUPT_ALL|BEHAVIOR_IMMOBILE

/datum/action/xeno_action/activable/bombard/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/bombarding_xeno = owner

	if(!istype(bombarding_xeno) || !bombarding_xeno.check_state() || !action_cooldown_check() || bombarding_xeno.action_busy)
		return FALSE

	var/turf/target_turf = get_turf(target_atom)

	if(isnull(target_turf) || istype(target_turf, /turf/closed) || !target_turf.can_bombard(owner))
		to_chat(bombarding_xeno, SPAN_XENODANGER("We can't bombard that!"))
		return FALSE

	if(!check_plasma_owner())
		return FALSE


	var/atom/bombard_source = get_bombard_source()
	if(!bombarding_xeno.can_bombard_turf(target_turf, range, bombard_source))
		return FALSE

	bombarding_xeno.visible_message(SPAN_XENODANGER("[bombarding_xeno] digs itself into place!"), SPAN_XENODANGER("We dig ourselves into place!"))
	if(!do_after(bombarding_xeno, activation_delay, interrupt_flags, BUSY_ICON_HOSTILE))
		to_chat(bombarding_xeno, SPAN_XENODANGER("We decide to cancel our bombard."))
		return FALSE

	if(!bombarding_xeno.can_bombard_turf(target_turf, range, bombard_source))
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	apply_cooldown()

	bombarding_xeno.visible_message(SPAN_XENODANGER("[bombarding_xeno] launches a massive ball of acid at [target_atom]!"), SPAN_XENODANGER("We launch a massive ball of acid at [target_atom]!"))
	playsound(get_turf(bombarding_xeno), 'sound/effects/blobattack.ogg', 25, 1)

	recursive_spread(target_turf, effect_range, effect_range)

	return ..()

/datum/action/xeno_action/activable/bombard/proc/recursive_spread(turf/spread_turf, dist_left, orig_depth)
	if(!istype(spread_turf))
		return
	else if(dist_left == 0)
		return
	else if(istype(spread_turf, /turf/closed) || istype(spread_turf, /turf/open/space))
		return
	else if(!spread_turf.can_bombard(owner))
		return

	addtimer(CALLBACK(src, PROC_REF(new_effect), spread_turf, owner), 2*(orig_depth - dist_left))

	for(var/mob/living/warned_mob in spread_turf)
		to_chat(warned_mob, SPAN_XENOHIGHDANGER("You see a massive ball of acid flying towards you!"))

	for(var/spread_dir in GLOB.alldirs)
		recursive_spread(get_step(spread_turf, spread_dir), dist_left - 1, orig_depth)

/datum/action/xeno_action/activable/bombard/proc/new_effect(turf/effect_turf, mob/living/carbon/xenomorph/spawning_xeno)
	if(!istype(effect_turf))
		return

	for(var/obj/effect/xenomorph/queen_bombard/existing in effect_turf)
		return

	new effect_type(effect_turf, spawning_xeno)

/datum/action/xeno_action/activable/bombard/proc/get_bombard_source()
	return owner

/turf/proc/can_bombard(mob/bombarder)
	if(!can_be_dissolved() && density)
		return FALSE

	for(var/atom/blocker in src)
		if(istype(blocker, /obj/structure/machinery))
			continue
		if(ismob(blocker))
			continue

		if(blocker && blocker.unacidable && blocker.density && !(blocker.flags_atom & ON_BORDER))
			return FALSE

	return TRUE

/mob/living/carbon/xenomorph/proc/can_bombard_turf(atom/target, range = 5, atom/bombard_source)
	if(!bombard_source || !isturf(bombard_source.loc))
		to_chat(src, SPAN_XENODANGER("That target is obstructed!"))
		return FALSE

	var/turf/current = bombard_source.loc
	var/turf/target_turf = get_turf(target)

	if(!target_turf || current.z != target_turf.z)
		to_chat(src, SPAN_XENODANGER("That is too far away!"))
		return FALSE

	if(get_dist_sqrd(current, target_turf) > (range*range))
		to_chat(src, SPAN_XENODANGER("That is too far away!"))
		return FALSE

	. = TRUE
	var/steps_taken = 0
	while(current != target_turf)
		steps_taken++
		if(steps_taken > range + 1)
			to_chat(src, SPAN_XENODANGER("That target is obstructed!"))
			return FALSE

		if(!current)
			return FALSE
		if(!current.can_bombard(src))
			. = FALSE
		if(current.opacity)
			. = FALSE
		if(.)
			for(var/atom/blocker in current)
				if(blocker.opacity)
					. = FALSE
					break
		if(!.)
			to_chat(src, SPAN_XENODANGER("That target is obstructed!"))
			return FALSE

		current = get_step_towards(current, target_turf)

/datum/action/xeno_action/activable/bombard/queen
	name = "Royal Bombard"
	plasma_cost = 200
	xeno_cooldown = 60 SECONDS
	range = 20
	ability_primacy = XENO_PRIMARY_ACTION_5
	interrupt_flags = INTERRUPT_ALL

/datum/action/xeno_action/activable/bombard/queen/get_bombard_source()
	for(var/mob/hologram/queen/eye in GLOB.hologram_list)
		if(eye.linked_mob == owner)
			return eye
	return owner

/datum/action/xeno_action/activable/bombard/queen/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/queen/queen = owner
	if(!istype(queen))
		return FALSE

	if(!queen.ovipositor)
		to_chat(queen, SPAN_XENOWARNING("We must be seated upon our ovipositor to bombard."))
		return FALSE

	return ..()
