
//Burrower Abilities
/mob/living/carbon/Xenomorph/proc/burrow()
	if(!check_state())
		return

	if(used_burrow || tunnel || is_ventcrawling || action_busy)
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	if(istype(T, /turf/open/floor/almayer/research/containment) || istype(T, /turf/closed/wall/almayer/research/containment))
		to_chat(src, SPAN_XENOWARNING("You can't escape this cell!"))
		return

	if(clone) //Prevents burrowing on stairs
		to_chat(src, SPAN_XENOWARNING("You can't burrow here!"))
		return

	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]

	used_burrow = TRUE

	if(mutation_type == BURROWER_IMPALER) //Impaler Burrower specific
		if(burrow)
			burrow_off()
			return
		if(fortify)
			to_chat(src, SPAN_XENOWARNING("You can't do this in this stance!"))
			used_burrow = FALSE
			return
		var/obj/effect/alien/weeds/weeds = locate() in T
		if(!weeds || !src.ally_of_hivenumber(weeds.hivenumber))
			to_chat(src, SPAN_XENOWARNING("You need to burrow on weeds!"))
			used_burrow = FALSE
			return
		to_chat(src, SPAN_XENOWARNING("You begin burrowing yourself into the weeds."))
		if(!do_after(src, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			addtimer(CALLBACK(src, .proc/do_burrow_cooldown), (caste ? caste.burrow_cooldown : 5 SECONDS))
			used_burrow = FALSE
			return
		burrow = TRUE
		wound_icon_carrier.alpha = 0
		density = FALSE
		add_temp_pass_flags(PASS_MOB_THRU|PASS_BUILDING|PASS_UNDER|PASS_BURROWED)
		RegisterSignal(src, COMSIG_LIVING_PREIGNITION, .proc/fire_immune)
		RegisterSignal(src, list(
			COMSIG_LIVING_FLAMER_CROSSED,
			COMSIG_LIVING_FLAMER_FLAMED,
		), .proc/flamer_crossed_immune)
		ADD_TRAIT(src, TRAIT_ABILITY_BURROWED, TRAIT_SOURCE_ABILITY("Burrow"))
		mob_size = MOB_SIZE_BIG
		playsound(src.loc, 'sound/effects/burrowing_s.ogg', 25)
		update_icons()
		addtimer(CALLBACK(src, .proc/do_burrow_cooldown), (caste ? caste.burrow_cooldown : 5 SECONDS))
		process_burrow_impaler()
		return

	to_chat(src, SPAN_XENOWARNING("You begin burrowing yourself into the ground."))
	if(!do_after(src, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		addtimer(CALLBACK(src, .proc/do_burrow_cooldown), (caste ? caste.burrow_cooldown : 5 SECONDS))
		return
	// TODO Make immune to all damage here.
	to_chat(src, SPAN_XENOWARNING("You burrow yourself into the ground."))
	burrow = TRUE
	frozen = TRUE
	invisibility = 101
	anchored = TRUE
	density = FALSE
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		RegisterSignal(src, COMSIG_LIVING_PREIGNITION, .proc/fire_immune)
		RegisterSignal(src, list(
			COMSIG_LIVING_FLAMER_CROSSED,
			COMSIG_LIVING_FLAMER_FLAMED,
		), .proc/flamer_crossed_immune)
	ADD_TRAIT(src, TRAIT_ABILITY_BURROWED, TRAIT_SOURCE_ABILITY("Burrow"))
	playsound(src.loc, 'sound/effects/burrowing_b.ogg', 25)
	update_canmove()
	update_icons()
	addtimer(CALLBACK(src, .proc/do_burrow_cooldown), (caste ? caste.burrow_cooldown : 5 SECONDS))
	burrow_timer = world.time + 90		// How long we can be burrowed
	process_burrow()

/mob/living/carbon/Xenomorph/proc/process_burrow()
	if(!burrow)
		return
	if(world.time > burrow_timer && !tunnel)
		burrow_off()
	if(observed_xeno)
		overwatch(observed_xeno, TRUE)
	if(burrow)
		addtimer(CALLBACK(src, .proc/process_burrow), 1 SECONDS)

/mob/living/carbon/Xenomorph/proc/process_burrow_impaler(var/turf/T = get_turf(src))
	var/obj/effect/alien/weeds/weeds = locate() in T
	if(!burrow)
		return
	if((!weeds || !src.ally_of_hivenumber(weeds.hivenumber)) || (src.stat == UNCONSCIOUS && src.health < 0) || (src.stat == DEAD))
		burrow_off()
	if(burrow)
		addtimer(CALLBACK(src, .proc/process_burrow_impaler), 0.5 SECONDS)

/mob/living/carbon/Xenomorph/proc/burrow_off()
	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]
	to_chat(src, SPAN_NOTICE("You resurface."))
	burrow = FALSE
	if(mutation_type == BURROWER_IMPALER)
		remove_temp_pass_flags(PASS_MOB_THRU|PASS_BUILDING|PASS_UNDER|PASS_BURROWED)
		mob_size = MOB_SIZE_XENO
		wound_icon_carrier.alpha = 255
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		UnregisterSignal(src, list(
			COMSIG_LIVING_PREIGNITION,
			COMSIG_LIVING_FLAMER_CROSSED,
			COMSIG_LIVING_FLAMER_FLAMED,
		))
	REMOVE_TRAIT(src, TRAIT_ABILITY_BURROWED, TRAIT_SOURCE_ABILITY("Burrow"))
	frozen = FALSE
	invisibility = FALSE
	anchored = FALSE
	density = TRUE
	playsound(src.loc, 'sound/effects/burrowoff.ogg', 25)
	for(var/mob/living/carbon/C in loc)
		if(!can_not_harm(C))
			C.apply_effect(2, WEAKEN)
	addtimer(CALLBACK(src, .proc/do_burrow_cooldown), (caste ? caste.burrow_cooldown : 5 SECONDS))
	update_canmove()
	update_icons()

/mob/living/carbon/Xenomorph/proc/do_burrow_cooldown()
	used_burrow = FALSE
	if(burrow)
		to_chat(src, SPAN_NOTICE("You can now surface."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()


/mob/living/carbon/Xenomorph/proc/tunnel(var/turf/T)
	if(!check_state())
		return

	if(!burrow)
		to_chat(src, SPAN_NOTICE("You must be burrowed to do this."))
		return

	if(used_tunnel)
		to_chat(src, SPAN_NOTICE("You must wait some time to do this."))
		return

	if(!T)
		to_chat(src, SPAN_NOTICE("You can't tunnel there!"))
		return

	if(T.density)
		to_chat(src, SPAN_XENOWARNING("You can't tunnel into a solid wall!"))
		return

	if(istype(T, /turf/open/space))
		to_chat(src, SPAN_XENOWARNING("You make tunnels, not wormholes!"))
		return

	if(clone) //Prevents tunnels in Z transition areas
		to_chat(src, SPAN_XENOWARNING("You make tunnels, not wormholes!"))
		return

	var/area/A = get_area(T)
	if(A.flags_area & AREA_NOTUNNEL)
		to_chat(src, SPAN_XENOWARNING("There's no way to tunnel over there."))
		return

	for(var/obj/O in T.contents)
		if(O.density)
			if(O.flags_atom & ON_BORDER)
				continue
			to_chat(src, SPAN_WARNING("There's something solid there to stop you emerging."))
			return

	if(tunnel)
		tunnel = FALSE
		to_chat(src, SPAN_NOTICE("You stop tunneling."))
		used_tunnel = TRUE
		addtimer(CALLBACK(src, .proc/do_tunnel_cooldown), (caste ? caste.tunnel_cooldown : 5 SECONDS))
		return

	if(!T || T.density)
		to_chat(src, SPAN_NOTICE("You cannot tunnel to there!"))
	tunnel = TRUE
	to_chat(src, SPAN_NOTICE("You start tunneling!"))
	tunnel_timer = (get_dist(src, T)*10) + world.time
	process_tunnel(T)


/mob/living/carbon/Xenomorph/proc/process_tunnel(var/turf/T)
	if(world.time > tunnel_timer)
		tunnel = FALSE
		do_tunnel(T)
	if(tunnel && T)
		addtimer(CALLBACK(src, .proc/process_tunnel, T), 1 SECONDS)

/mob/living/carbon/Xenomorph/proc/do_tunnel(var/turf/T)
	to_chat(src, SPAN_NOTICE("You tunnel to your destination."))
	anchored = FALSE
	unfreeze()
	forceMove(T)
	UnregisterSignal(src, COMSIG_LIVING_FLAMER_FLAMED)
	burrow_off()

/mob/living/carbon/Xenomorph/proc/do_tunnel_cooldown()
	used_tunnel = FALSE
	to_chat(src, SPAN_NOTICE("You can now tunnel while burrowed."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()

/mob/living/carbon/Xenomorph/proc/rename_tunnel(var/obj/structure/tunnel/T in oview(1))
	set name = "Rename Tunnel"
	set desc = "Rename the tunnel."
	set category = null

	if(!istype(T))
		return

	var/new_name = strip_html(input("Change the description of the tunnel:", "Tunnel Description") as text|null)
	if(new_name)
		new_name = "[new_name] ([get_area_name(T)])"
		log_admin("[key_name(src)] has renamed the tunnel \"[T.tunnel_desc]\" as \"[new_name]\".")
		msg_admin_niche("[src]/([key_name(src)]) has renamed the tunnel \"[T.tunnel_desc]\" as \"[new_name]\".")
		T.tunnel_desc = "[new_name]"
	return

/datum/action/xeno_action/onclick/tremor/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/xeno = owner
	return !xeno.used_tremor

/mob/living/carbon/Xenomorph/proc/tremor() //More support focused version of crusher earthquakes.
	if(burrow || is_ventcrawling)
		to_chat(src, SPAN_XENOWARNING("You must be above ground to do this."))
		return

	if(!check_state())
		return

	if(used_tremor)
		to_chat(src, SPAN_XENOWARNING("Your aren't ready to cause more tremors yet!"))
		return

	if(!check_plasma(100)) return

	use_plasma(100)
	playsound(loc, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	visible_message(SPAN_XENODANGER("[src] digs itself into the ground and shakes the earth itself, causing violent tremors!"), \
	SPAN_XENODANGER("You dig into the ground and shake it around, causing violent tremors!"))
	create_stomp() //Adds the visual effect. Wom wom wom
	used_tremor = 1

	for(var/mob/living/carbon/carbon_target in range(7, loc))
		to_chat(carbon_target, SPAN_WARNING("You struggle to remain on your feet as the ground shakes beneath your feet!"))
		shake_camera(carbon_target, 2, 3)
		if(get_dist(loc, carbon_target) <= 3 && !src.can_not_harm(carbon_target))
			if(carbon_target.mob_size >= MOB_SIZE_BIG)
				carbon_target.apply_effect(1, SLOW)
			else
				carbon_target.apply_effect(1, WEAKEN)
			to_chat(carbon_target, SPAN_WARNING("The violent tremors make you lose your footing!"))

	spawn(caste.tremor_cooldown)
		used_tremor = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to cause tremors again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

//Impaler Burrower Abilities
/datum/action/xeno_action/activable/burrowed_spikes/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!istype(X))
		return

	if(!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !X.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	var/distance = max_distance
	var/damage = base_damage
	if(X.fortify)
		distance += reinforced_range_bonus
		damage += reinforced_damage_bonus

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(X, A)
	var/turf/T = X.loc
	var/turf/temp = X.loc
	var/list/telegraph_atom_list = list()

	for (var/x in 0 to distance)
		temp = get_step(T, facing)
		if(facing in diagonals) // check if it goes through corners
			var/reverse_face = reverse_dir[facing]
			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(S.opacity || (istype(S, /obj/structure/barricade) && S.density))
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp

		if (T in target_turfs)
			break

		facing = get_dir(T, A)
		target_turfs += T
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/brown(T, 0.25 SECONDS)

	// Extract our 'optimal' turf, if it exists
	if (target_turfs.len >= 2)
		X.animation_attack_on(target_turfs[target_turfs.len], 15)

	playsound(X.loc, 'sound/effects/burrower_attack.ogg', 40)
	X.visible_message(SPAN_XENODANGER("[X] shoots spikes though the ground in front of it!"), SPAN_XENODANGER("You shoot your spikes though the ground in front of you!"))

	// Loop through our turfs, finding any humans there and dealing damage to them
	INVOKE_ASYNC(src, .proc/handle_damage, X, target_turfs, telegraph_atom_list, damage)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/burrowed_spikes/proc/handle_damage(var/mob/living/carbon/Xenomorph/X, target_turfs, telegraph_atom_list, damage)
	for (var/turf/target_turf in target_turfs)
		telegraph_atom_list += new /obj/effect/xenomorph/ground_spike(target_turf, X)
		for (var/mob/living/carbon/C in target_turf)
			if (C.stat == DEAD || HAS_TRAIT(C, TRAIT_NESTED))
				continue

			if(X.can_not_harm(C))
				continue
			X.flick_attack_overlay(C, "slash")
			C.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			to_chat(C, SPAN_WARNING("You are stabbed with a spike from below!"))
			playsound(get_turf(C), "alien_bite", 50, TRUE)
		for(var/obj/structure/S in target_turf)
			if(istype(S, /obj/structure/window/framed))
				var/obj/structure/window/framed/W = S
				if(!W.unslashable)
					W.shatter_window(TRUE)
					playsound(target_turf, "windowshatter", 50, TRUE)
		sleep(chain_separation_delay)


/datum/action/xeno_action/activable/sunken_tail/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!istype(X))
		return

	if(!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !X.check_state() || X.action_busy)
		return

	if(X.burrow)
		to_chat(X, SPAN_XENOWARNING("You can't do this while burrowed!"))
		return

	var/distance = max_distance
	var/damage = base_damage
	var/reinforced_modified = FALSE
	if(X.fortify)
		distance += reinforced_range_bonus
		damage += reinforced_damage_bonus
		reinforced_modified = TRUE

	if(get_dist(A, X) > distance)
		to_chat(X, SPAN_XENOWARNING("[A] is too far away!"))
		return

	if(!check_clear_path_to_target(X, A, FALSE))
		to_chat(X, SPAN_XENOWARNING("Something is blocking our path to [A]!"))
		return

	if(!check_plasma_owner())
		return

	var/turf/target = get_turf(A)
	var/list/telegraph_atom_list = list()

	telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(target, windup_delay)
	if(!do_after(X, windup_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		apply_cooldown_override(5 SECONDS)
		for(var/obj/effect/tele in telegraph_atom_list)
			qdel(tele)
		return
	use_plasma_owner()
	playsound(X.loc, 'sound/effects/burrower_attack1.ogg', 40)
	X.visible_message(SPAN_XENOWARNING("The [X] stabs its tail in the ground toward [A]!"), SPAN_XENOWARNING("You stab your tail into the ground toward [A]!"))
	INVOKE_ASYNC(src, .proc/handle_damage, X, target, damage)
	if(reinforced_modified)
		recursive_spread(target, reinforced_spread_range, reinforced_spread_range, damage, target)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/sunken_tail/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X) return
	if(X.burrow) return FALSE
	return ..()

/datum/action/xeno_action/activable/sunken_tail/proc/handle_damage(var/mob/living/carbon/Xenomorph/X, target_turfs, damage, var/spike_circle = FALSE)
	new /obj/effect/xenomorph/ground_spike(target_turfs, X)
	for (var/mob/living/carbon/C in target_turfs)
		if (C.stat == DEAD || HAS_TRAIT(C, TRAIT_NESTED))
			continue

		if(X.can_not_harm(C))
			continue
		X.flick_attack_overlay(C, "slash")
		C.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
		if(spike_circle)
			to_chat(C, SPAN_WARNING("You are stabbed with a spike from below!"))
		else
			to_chat(C, SPAN_WARNING("You are stabbed with a tail from below!"))
		playsound(get_turf(C), "alien_bite", 50, TRUE)
	for(var/obj/structure/S in target_turfs)
		if(istype(S, /obj/structure/window/framed))
			var/obj/structure/window/framed/W = S
			if(!W.unslashable)
				W.shatter_window(TRUE)
				playsound(target_turfs, "windowshatter", 50, TRUE)

/datum/action/xeno_action/activable/sunken_tail/proc/recursive_spread(turf/T, dist_left, orig_depth, damage, turf/original_turf)
	if(!istype(T))
		return
	else if(!dist_left)
		return
	else if(istype(T, /turf/closed) || istype(T, /turf/open/space))
		return

	if(T != original_turf)
		addtimer(CALLBACK(src, .proc/warning_circle, T, owner), ((windup_delay/2)*(orig_depth - dist_left)))
		addtimer(CALLBACK(src, .proc/handle_damage, owner, T, (damage - reinforced_damage_bonus), TRUE), (((windup_delay/2)*(orig_depth - dist_left))+5))

	for(var/dirn in alldirs)
		recursive_spread(get_step(T, dirn), dist_left - 1, orig_depth, damage)

/datum/action/xeno_action/activable/sunken_tail/proc/warning_circle(turf/T, mob/living/carbon/Xenomorph/X)
	if(!istype(T))
		return

	new /obj/effect/xenomorph/xeno_telegraph/red(T, (windup_delay/2))

/datum/action/xeno_action/onclick/ensconce/use_ability()
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state()|| xeno.action_busy)
		return

	if(xeno.burrow)
		to_chat(xeno, SPAN_XENOWARNING("You can't do this while burrowed!"))
		return

	var/turf/T = get_turf(xeno)
	var/obj/effect/alien/weeds/weeds = locate() in T
	if(!weeds || !xeno.ally_of_hivenumber(weeds.hivenumber))
		to_chat(xeno, SPAN_XENOWARNING("You need to do this on weeds!"))
		return

	var/mob/living/carbon/Xenomorph/Burrower/burrowerfortified = locate() in T
	if(burrowerfortified != xeno)
		if(burrowerfortified.fortify)
			to_chat(xeno, SPAN_XENOWARNING("There is already another sister burrowed here!"))
			return

	if(!check_plasma_owner())
		return

	apply_cooldown()
	if(!do_after(xeno, windup_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		return

	if(burrowerfortified != xeno)
		if(burrowerfortified.fortify)
			to_chat(xeno, SPAN_XENOWARNING("There is already another sister burrowed here!"))
			return

	use_plasma_owner()

	playsound(T, 'sound/effects/burrowing_b.ogg', 25)

	if(!xeno.fortify)
		RegisterSignal(owner, COMSIG_MOB_DEATH, .proc/death_check)
		fortify_switch(xeno, TRUE)
		if(xeno.selected_ability != src)
			button.icon_state = "template_active"
	else
		UnregisterSignal(owner, COMSIG_MOB_DEATH)
		fortify_switch(xeno, FALSE)
		if(xeno.selected_ability != src)
			button.icon_state = "template"

	..()
	return

/datum/action/xeno_action/onclick/ensconce/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X) return
	if(X.burrow) return FALSE
	return ..()

/datum/action/xeno_action/onclick/ensconce/proc/fortify_switch(var/mob/living/carbon/Xenomorph/X, var/fortify_state)
	if(X.fortify == fortify_state)
		return

	if(fortify_state)
		X.update_icons()
		to_chat(X, SPAN_XENOWARNING("You dig in halfway into the weeds."))
		X.armor_deflection_buff += 25
		X.armor_explosive_buff += 50
		X.frozen = TRUE
		X.anchored = TRUE
		X.density = FALSE
		X.small_explosives_stun = FALSE
		X.client?.change_view(reinforced_vision_range, X)
		X.update_canmove()
		X.mob_size = MOB_SIZE_IMMOBILE //knockback immune
		X.mob_flags &= ~SQUEEZE_UNDER_VEHICLES
		X.fortify = TRUE
		process_ensconce(X)
	else
		X.update_icons()
		to_chat(X, SPAN_XENOWARNING("You resume your normal stance."))
		X.frozen = FALSE
		X.anchored = FALSE
		X.density = TRUE
		X.armor_deflection_buff -= 25
		X.armor_explosive_buff -= 50
		X.small_explosives_stun = TRUE
		X.client?.change_view(7, X)
		X.mob_size = MOB_SIZE_XENO //no longer knockback immune
		X.mob_flags |= SQUEEZE_UNDER_VEHICLES
		X.update_canmove()
		X.fortify = FALSE

/datum/action/xeno_action/onclick/ensconce/proc/death_check()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	fortify_switch(owner, FALSE)

/datum/action/xeno_action/onclick/ensconce/proc/process_ensconce(var/mob/living/carbon/Xenomorph/xeno)
	var/turf/T = get_turf(xeno)
	var/obj/effect/alien/weeds/weeds = locate() in T
	if(!xeno.fortify)
		return
	if(!weeds || !xeno.ally_of_hivenumber(weeds.hivenumber) || (xeno.stat == UNCONSCIOUS && xeno.health < 0))
		fortify_switch(xeno, FALSE)
		UnregisterSignal(xeno, COMSIG_MOB_DEATH)
	if(xeno.fortify)
		addtimer(CALLBACK(src, .proc/process_ensconce, xeno), 1 SECONDS)
