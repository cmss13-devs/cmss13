
//Burrower Abilities
/mob/living/carbon/xenomorph/proc/burrow()
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
		if(!weeds || !ally_of_hivenumber(weeds.hivenumber))
			to_chat(src, SPAN_XENOWARNING("You need to burrow on weeds!"))
			used_burrow = FALSE
			return
		to_chat(src, SPAN_XENOWARNING("You begin burrowing yourself into the weeds."))
		if(!do_after(src, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
			used_burrow = FALSE
			return
		burrow = TRUE
		wound_icon_carrier.alpha = 0
		density = FALSE
		add_temp_pass_flags(PASS_MOB_THRU|PASS_BUILDING|PASS_UNDER|PASS_BURROWED)
		RegisterSignal(src, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_immune))
		RegisterSignal(src, list(
			COMSIG_LIVING_FLAMER_CROSSED,
			COMSIG_LIVING_FLAMER_FLAMED,
		), PROC_REF(flamer_crossed_immune))
		ADD_TRAIT(src, TRAIT_ABILITY_BURROWED, TRAIT_SOURCE_ABILITY("Burrow"))
		mob_size = MOB_SIZE_BIG
		playsound(loc, 'sound/effects/burrowing_s.ogg', 25)
		update_icons()
		addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
		process_burrow_impaler()
		return

	to_chat(src, SPAN_XENOWARNING("You begin burrowing yourself into the ground."))
	if(!do_after(src, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
		return
	// TODO Make immune to all damage here.
	to_chat(src, SPAN_XENOWARNING("You burrow yourself into the ground."))
	burrow = TRUE
	frozen = TRUE
	invisibility = 101
	anchored = TRUE
	density = FALSE
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		RegisterSignal(src, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_immune))
		RegisterSignal(src, list(
			COMSIG_LIVING_FLAMER_CROSSED,
			COMSIG_LIVING_FLAMER_FLAMED,
		), PROC_REF(flamer_crossed_immune))
	ADD_TRAIT(src, TRAIT_ABILITY_BURROWED, TRAIT_SOURCE_ABILITY("Burrow"))
	playsound(src.loc, 'sound/effects/burrowing_b.ogg', 25)
	update_canmove()
	update_icons()
	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
	burrow_timer = world.time + 90 // How long we can be burrowed
	process_burrow()

/mob/living/carbon/xenomorph/proc/process_burrow()
	if(!burrow)
		return
	if(world.time > burrow_timer && !tunnel)
		burrow_off()
	if(observed_xeno)
		overwatch(observed_xeno, TRUE)
	if(burrow)
		addtimer(CALLBACK(src, PROC_REF(process_burrow)), 1 SECONDS)

/mob/living/carbon/xenomorph/proc/process_burrow_impaler(turf/turf = get_turf(src))
	var/obj/effect/alien/weeds/weeds = locate() in turf
	if(!burrow)
		return
	if((!weeds || !ally_of_hivenumber(weeds.hivenumber)) || (stat == UNCONSCIOUS && health < 0) || (stat == DEAD))
		burrow_off()
	if(burrow)
		addtimer(CALLBACK(src, PROC_REF(process_burrow_impaler)), 0.5 SECONDS)

/mob/living/carbon/xenomorph/proc/burrow_off()
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
	playsound(loc, 'sound/effects/burrowoff.ogg', 25)
	for(var/mob/living/carbon/mob in loc)
		if(!can_not_harm(mob))
			mob.apply_effect(2, WEAKEN)

	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
	update_canmove()
	update_icons()

/mob/living/carbon/xenomorph/proc/do_burrow_cooldown()
	used_burrow = FALSE
	if(burrow)
		to_chat(src, SPAN_NOTICE("You can now surface."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()


/mob/living/carbon/xenomorph/proc/tunnel(turf/T)
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
		addtimer(CALLBACK(src, PROC_REF(do_tunnel_cooldown)), (caste ? caste.tunnel_cooldown : 5 SECONDS))
		return

	if(!T || T.density)
		to_chat(src, SPAN_NOTICE("You cannot tunnel to there!"))
	tunnel = TRUE
	to_chat(src, SPAN_NOTICE("You start tunneling!"))
	tunnel_timer = (get_dist(src, T)*10) + world.time
	process_tunnel(T)


/mob/living/carbon/xenomorph/proc/process_tunnel(turf/T)
	if(world.time > tunnel_timer)
		tunnel = FALSE
		do_tunnel(T)
	if(tunnel && T)
		addtimer(CALLBACK(src, PROC_REF(process_tunnel), T), 1 SECONDS)

/mob/living/carbon/xenomorph/proc/do_tunnel(turf/T)
	to_chat(src, SPAN_NOTICE("You tunnel to your destination."))
	anchored = FALSE
	unfreeze()
	forceMove(T)
	UnregisterSignal(src, COMSIG_LIVING_FLAMER_FLAMED)
	burrow_off()

/mob/living/carbon/xenomorph/proc/do_tunnel_cooldown()
	used_tunnel = FALSE
	to_chat(src, SPAN_NOTICE("You can now tunnel while burrowed."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()

/mob/living/carbon/xenomorph/proc/rename_tunnel(obj/structure/tunnel/T in oview(1))
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
	var/mob/living/carbon/xenomorph/xeno = owner
	return !xeno.used_tremor

/mob/living/carbon/xenomorph/proc/tremor() //More support focused version of crusher earthquakes.
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
/datum/action/xeno_action/activable/burrowed_spikes/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!atom || atom.layer >= FLY_LAYER || !xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	var/distance = max_distance
	var/damage = base_damage
	if(xeno.fortify)
		distance += reinforced_range_bonus
		damage += reinforced_damage_bonus

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(xeno, atom)
	var/turf/turf = xeno.loc
	var/turf/temp = xeno.loc
	var/list/telegraph_atom_list = list()

	for (var/x in 0 to distance)
		temp = get_step(turf, facing)
		if(facing in diagonals) // check if it goes through corners
			var/reverse_face = reverse_dir[facing]
			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/target_structure in temp)
			if(target_structure.opacity || (istype(target_structure, /obj/structure/barricade) && target_structure.density))
				blocked = TRUE
				break
		if(blocked)
			break

		turf = temp

		if (turf in target_turfs)
			break

		facing = get_dir(turf, atom)
		target_turfs += turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/brown(turf, 0.25 SECONDS)

	// Extract our 'optimal' turf, if it exists
	if (len(target_turfs) >= 2)
		xeno.animation_attack_on(target_turfs[target_turfs.len], 15)

	playsound(xeno.loc, 'sound/effects/burrower_attack.ogg', 40)
	xeno.visible_message(SPAN_XENODANGER("[xeno] shoots spikes though the ground in front of it!"), SPAN_XENODANGER("You shoot your spikes though the ground in front of you!"))

	// Loop through our turfs, finding any humans there and dealing damage to them
	INVOKE_ASYNC(src, PROC_REF(handle_damage), xeno, target_turfs, telegraph_atom_list, damage)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/burrowed_spikes/proc/handle_damage(mob/living/carbon/xenomorph/xeno, target_turfs, telegraph_atom_list, damage)
	for (var/turf/target_turf in target_turfs)
		telegraph_atom_list += new /obj/effect/xenomorph/ground_spike(target_turf, xeno)
		for (var/mob/living/carbon/targeted_carbon in target_turf)
			if (targeted_carbon.stat == DEAD || HAS_TRAIT(targeted_carbon, TRAIT_NESTED))
				continue

			if(xeno.can_not_harm(targeted_carbon))
				continue
			xeno.flick_attack_overlay(targeted_carbon, "slash")
			targeted_carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			to_chat(targeted_carbon, SPAN_WARNING("You are stabbed with a spike from below!"))
			playsound(get_turf(targeted_carbon), "alien_bite", 50, TRUE)
		for(var/obj/structure/window/framed/target_window in target_turf)
			if(!target_window.unslashable)
				target_window.shatter_window(TRUE)
				playsound(target_turf, "windowshatter", 50, TRUE)
		sleep(chain_separation_delay)


/datum/action/xeno_action/activable/sunken_tail/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!atom || atom.layer >= FLY_LAYER || !xeno.check_state() || xeno.action_busy)
		return

	if(xeno.burrow)
		to_chat(xeno, SPAN_XENOWARNING("You can't do this while burrowed!"))
		return

	var/distance = max_distance
	var/damage = base_damage
	var/reinforced_modified = FALSE
	if(xeno.fortify)
		distance += reinforced_range_bonus
		damage += reinforced_damage_bonus
		reinforced_modified = TRUE

	if(get_dist(atom, xeno) > distance)
		to_chat(xeno, SPAN_XENOWARNING("[atom] is too far away!"))
		return

	if(!check_clear_path_to_target(xeno, atom, FALSE))
		to_chat(xeno, SPAN_XENOWARNING("Something is blocking our path to [atom]!"))
		return

	if(!check_plasma_owner())
		return

	var/turf/target = get_turf(atom)
	var/list/telegraph_atom_list = list()

	telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(target, windup_delay)
	if(!do_after(xeno, windup_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		apply_cooldown_override(5 SECONDS)
		for(var/obj/effect/tele in telegraph_atom_list)
			qdel(tele)
		return
	use_plasma_owner()
	playsound(xeno.loc, 'sound/effects/burrower_attack1.ogg', 40)
	xeno.visible_message(SPAN_XENOWARNING("The [xeno] stabs its tail in the ground toward [atom]!"), SPAN_XENOWARNING("You stab your tail into the ground toward [atom]!"))
	INVOKE_ASYNC(src, PROC_REF(handle_damage), xeno, target, damage)
	if(reinforced_modified)
		recursive_spread(target, reinforced_spread_range, reinforced_spread_range, damage, target)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/sunken_tail/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno)
		return
	if(xeno.burrow)
		return FALSE
	return ..()

/datum/action/xeno_action/activable/sunken_tail/proc/handle_damage(mob/living/carbon/xenomorph/xeno, target_turfs, damage, spike_circle = FALSE)
	new /obj/effect/xenomorph/ground_spike(target_turfs, xeno)
	for (var/mob/living/carbon/targeted_carbon in target_turfs)
		if (targeted_carbon.stat == DEAD || HAS_TRAIT(targeted_carbon, TRAIT_NESTED))
			continue

		if(xeno.can_not_harm(targeted_carbon))
			continue
		xeno.flick_attack_overlay(targeted_carbon, "slash")
		targeted_carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
		if(spike_circle)
			to_chat(targeted_carbon, SPAN_WARNING("You are stabbed with a spike from below!"))
		else
			to_chat(targeted_carbon, SPAN_WARNING("You are stabbed with a tail from below!"))
		playsound(get_turf(targeted_carbon), "alien_bite", 50, TRUE)
	for(var/obj/structure/window/framed/target_window in target_turfs)
		if(!target_window.unslashable)
			target_window.shatter_window(TRUE)
			playsound(target_turfs, "windowshatter", 50, TRUE)

/datum/action/xeno_action/activable/sunken_tail/proc/recursive_spread(turf/turf, dist_left, orig_depth, damage, turf/original_turf)
	if(!istype(turf))
		return
	if(!dist_left)
		return
	if(istype(turf, /turf/closed) || istype(turf, /turf/open/space))
		return

	if(turf != original_turf)
		addtimer(CALLBACK(src, PROC_REF(warning_circle), turf, owner), ((windup_delay/2)*(orig_depth - dist_left)))
		addtimer(CALLBACK(src, PROC_REF(handle_damage), owner, turf, (damage - reinforced_damage_bonus), TRUE), (((windup_delay/2)*(orig_depth - dist_left))+5))

	for(var/dirn in alldirs)
		recursive_spread(get_step(turf, dirn), dist_left - 1, orig_depth, damage)

/datum/action/xeno_action/activable/sunken_tail/proc/warning_circle(turf/turf, mob/living/carbon/xenomorph/xeno)
	if(!istype(turf))
		return

	new /obj/effect/xenomorph/xeno_telegraph/red(turf, (windup_delay/2))

/datum/action/xeno_action/onclick/ensconce/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state()|| xeno.action_busy)
		return

	if(xeno.burrow)
		to_chat(xeno, SPAN_XENOWARNING("You can't do this while burrowed!"))
		return

	var/turf/turf = get_turf(xeno)
	var/obj/effect/alien/weeds/weeds = locate() in turf
	if(!weeds || !xeno.ally_of_hivenumber(weeds.hivenumber))
		to_chat(xeno, SPAN_XENOWARNING("You need to do this on weeds!"))
		return

	var/mob/living/carbon/xenomorph/burrower/burrowerfortified = locate() in turf
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

	playsound(turf, 'sound/effects/burrowing_b.ogg', 25)

	if(!xeno.fortify)
		RegisterSignal(owner, COMSIG_MOB_DEATH, PROC_REF(death_check))
		fortify_switch(xeno, TRUE)
		if(xeno.selected_ability != src)
			button.icon_state = "template_active"
	else
		UnregisterSignal(owner, COMSIG_MOB_DEATH)
		fortify_switch(xeno, FALSE)
		if(xeno.selected_ability != src)
			button.icon_state = "template"

	return ..()

/datum/action/xeno_action/onclick/ensconce/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno)
		return
	if(xeno.burrow)
		return FALSE
	return ..()

/datum/action/xeno_action/onclick/ensconce/proc/fortify_switch(mob/living/carbon/xenomorph/xeno, fortify_state)
	if(xeno.fortify == fortify_state)
		return

	if(fortify_state)
		xeno.update_icons()
		to_chat(xeno, SPAN_XENOWARNING("You dig in halfway into the weeds."))
		xeno.armor_deflection_buff += 25
		xeno.armor_explosive_buff += 50
		xeno.frozen = TRUE
		xeno.anchored = TRUE
		xeno.density = FALSE
		xeno.small_explosives_stun = FALSE
		xeno.client?.change_view(reinforced_vision_range, xeno)
		xeno.update_canmove()
		xeno.mob_size = MOB_SIZE_IMMOBILE //knockback immune
		xeno.mob_flags &= ~SQUEEZE_UNDER_VEHICLES
		xeno.fortify = TRUE
		process_ensconce(xeno)
	else
		xeno.update_icons()
		to_chat(xeno, SPAN_XENOWARNING("You resume your normal stance."))
		xeno.frozen = FALSE
		xeno.anchored = FALSE
		xeno.density = TRUE
		xeno.armor_deflection_buff -= 25
		xeno.armor_explosive_buff -= 50
		xeno.small_explosives_stun = TRUE
		xeno.client?.change_view(7, xeno)
		xeno.mob_size = MOB_SIZE_XENO //no longer knockback immune
		xeno.mob_flags |= SQUEEZE_UNDER_VEHICLES
		xeno.update_canmove()
		xeno.fortify = FALSE

/datum/action/xeno_action/onclick/ensconce/proc/death_check()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	fortify_switch(owner, FALSE)

/datum/action/xeno_action/onclick/ensconce/proc/process_ensconce(mob/living/carbon/xenomorph/xeno)
	var/turf/turf = get_turf(xeno)
	var/obj/effect/alien/weeds/weeds = locate() in turf
	if(!xeno.fortify)
		return
	if(!weeds || !xeno.ally_of_hivenumber(weeds.hivenumber) || (xeno.stat == UNCONSCIOUS && xeno.health < 0))
		fortify_switch(xeno, FALSE)
		UnregisterSignal(xeno, COMSIG_MOB_DEATH)
	if(xeno.fortify)
		addtimer(CALLBACK(src, PROC_REF(process_ensconce), xeno), 1 SECONDS)
