
//Burrower Abilities
/mob/living/carbon/xenomorph/proc/burrow()
	if(!check_state())
		return

	if(used_burrow || tunnel || is_ventcrawling || action_busy)
		return

	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return

	var/area/current_area = get_area(current_turf)
	if(current_area.flags_area & AREA_NOTUNNEL)
		to_chat(src, SPAN_XENOWARNING("There's no way to burrow here."))
		return

	if(istype(current_turf, /turf/open/floor/almayer/research/containment) || istype(current_turf, /turf/closed/wall/almayer/research/containment))
		to_chat(src, SPAN_XENOWARNING("We can't escape this cell!"))
		return

	if(clone) //Prevents burrowing on stairs
		to_chat(src, SPAN_XENOWARNING("We can't burrow here!"))
		return

	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]

	used_burrow = TRUE

	to_chat(src, SPAN_XENOWARNING("We begin burrowing ourselves into the ground."))
	if(!do_after(src, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
		return
	// TODO Make immune to all damage here.
	to_chat(src, SPAN_XENOWARNING("We burrow ourselves into the ground."))
	invisibility = 101
	anchored = TRUE
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		RegisterSignal(src, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_immune))
		RegisterSignal(src, list(
				COMSIG_LIVING_FLAMER_CROSSED,
				COMSIG_LIVING_FLAMER_FLAMED,
		), PROC_REF(flamer_crossed_immune))
	add_traits(list(TRAIT_ABILITY_BURROWED, TRAIT_UNDENSE, TRAIT_IMMOBILIZED), TRAIT_SOURCE_ABILITY("Burrow"))
	playsound(src.loc, 'sound/effects/burrowing_b.ogg', 25)
	update_icons()
	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
	burrow_timer = world.time + 90 // How long we can be burrowed
	process_burrow()

/mob/living/carbon/xenomorph/proc/process_burrow()
	if(!HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return
	if(world.time > burrow_timer && !tunnel)
		burrow_off()
	if(observed_xeno)
		overwatch(observed_xeno, TRUE)
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		addtimer(CALLBACK(src, PROC_REF(process_burrow)), 1 SECONDS)

/mob/living/carbon/xenomorph/proc/burrow_off()
	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]
	to_chat(src, SPAN_NOTICE("You resurface."))
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		UnregisterSignal(src, list(
				COMSIG_LIVING_PREIGNITION,
				COMSIG_LIVING_FLAMER_CROSSED,
				COMSIG_LIVING_FLAMER_FLAMED,
		))
	remove_traits(list(TRAIT_ABILITY_BURROWED, TRAIT_UNDENSE, TRAIT_IMMOBILIZED), TRAIT_SOURCE_ABILITY("Burrow"))
	invisibility = FALSE
	anchored = FALSE
	playsound(loc, 'sound/effects/burrowoff.ogg', 25)
	for(var/mob/living/carbon/mob in loc)
		if(!can_not_harm(mob))
			mob.apply_effect(2, WEAKEN)

	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
	update_icons()

/mob/living/carbon/xenomorph/proc/do_burrow_cooldown()
	used_burrow = FALSE
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_NOTICE("We can now surface."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()


/mob/living/carbon/xenomorph/proc/tunnel(turf/T)
	if(!check_state())
		return

	if(!HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_NOTICE("We must be burrowed to do this."))
		return

	if(tunnel)
		tunnel = FALSE
		to_chat(src, SPAN_NOTICE("We stop tunneling."))
		used_tunnel = TRUE
		addtimer(CALLBACK(src, PROC_REF(do_tunnel_cooldown)), (caste ? caste.tunnel_cooldown : 5 SECONDS))
		return

	if(used_tunnel)
		to_chat(src, SPAN_NOTICE("We must wait some time to do this."))
		return

	if(!T)
		to_chat(src, SPAN_NOTICE("We can't tunnel there!"))
		return

	if(T.density)
		to_chat(src, SPAN_XENOWARNING("We can't tunnel into a solid wall!"))
		return

	if(istype(T, /turf/open/space))
		to_chat(src, SPAN_XENOWARNING("We make tunnels, not wormholes!"))
		return

	if(clone) //Prevents tunnels in Z transition areas
		to_chat(src, SPAN_XENOWARNING("We make tunnels, not wormholes!"))
		return

	var/area/A = get_area(T)
	if(A.flags_area & AREA_NOTUNNEL || get_dist(src, T) > 15)
		to_chat(src, SPAN_XENOWARNING("There's no way to tunnel over there."))
		return

	for(var/obj/O in T.contents)
		if(O.density)
			if(O.flags_atom & ON_BORDER)
				continue
			to_chat(src, SPAN_WARNING("There's something solid there to stop us from emerging."))
			return

	if(!T || T.density)
		to_chat(src, SPAN_NOTICE("We cannot tunnel to there!"))
	tunnel = TRUE
	to_chat(src, SPAN_NOTICE("We start tunneling!"))
	tunnel_timer = (get_dist(src, T)*10) + world.time
	process_tunnel(T)


/mob/living/carbon/xenomorph/proc/process_tunnel(turf/T)
	if(!tunnel)
		return

	if(world.time > tunnel_timer)
		tunnel = FALSE
		do_tunnel(T)
	if(tunnel && T)
		addtimer(CALLBACK(src, PROC_REF(process_tunnel), T), 1 SECONDS)

/mob/living/carbon/xenomorph/proc/do_tunnel(turf/T)
	to_chat(src, SPAN_NOTICE("We tunnel to the destination."))
	anchored = FALSE
	forceMove(T)
	burrow_off()

/mob/living/carbon/xenomorph/proc/do_tunnel_cooldown()
	used_tunnel = FALSE
	to_chat(src, SPAN_NOTICE("We can now tunnel while burrowed."))
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
	new_name = replace_non_alphanumeric_plus(new_name)
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
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED) || is_ventcrawling)
		to_chat(src, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if(!check_state())
		return

	if(used_tremor)
		to_chat(src, SPAN_XENOWARNING("We aren't ready to cause more tremors yet!"))
		return

	if(!check_plasma(100)) return

	use_plasma(100)
	playsound(loc, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	visible_message(SPAN_XENODANGER("[src] digs itself into the ground and shakes the earth itself, causing violent tremors!"), \
	SPAN_XENODANGER("We dig into the ground and shake it around, causing violent tremors!"))
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
		to_chat(src, SPAN_NOTICE("We gather enough strength to cause tremors again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

// Sapper Powers
/datum/action/xeno_action/onclick/demolish/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/sapper = owner

	if (!action_cooldown_check())
		return

	if (!sapper.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	sapper.visible_message(SPAN_XENOWARNING("[sapper] bulks up and enters a destructive frenzy!"), SPAN_XENOHIGHDANGER("We bulk our muscles and enter a destructive frenzy!"))
	sapper.add_filter("sapper_demolish", 1, list("type" = "outline", "color" = "#ff6600", "size" = 1))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, PROC_REF(no_demolish)), 15 SECONDS)

	sapper.claw_type = CLAW_TYPE_VERY_SHARP
	sapper.attack_speed_modifier -= 3
	sapper.small_explosives_stun = FALSE

	return ..()

/datum/action/xeno_action/onclick/demolish/proc/no_demolish()
	var/mob/living/carbon/xenomorph/sapper = owner

	to_chat(sapper, SPAN_XENONOTICE("We calm down as our muscles shrink back to normal."))
	sapper.remove_filter("sapper_demolish")
	button.icon_state = "template"

	sapper.claw_type = CLAW_TYPE_SHARP
	sapper.attack_speed_modifier += 3
	sapper.small_explosives_stun = TRUE

	apply_cooldown()

/datum/action/xeno_action/activable/tail_axe/use_ability(atom/targeted_atom)

	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/hit_target = targeted_atom
	var/distance = get_dist(xeno, hit_target)

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(distance > 2)
		return

	var/list/turf/path = get_line(xeno, targeted_atom, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
			return
		var/atom/barrier = path_turf.handle_barriers(A = xeno , pass_flags = (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
			return
		for(var/obj/structure/current_structure in path_turf)
			if(istype(current_structure, /obj/structure/window/framed))
				var/obj/structure/window/framed/target_window = current_structure
				if(target_window.unslashable)
					return
				playsound(get_turf(target_window),"windowshatter", 50, TRUE)
				target_window.shatter_window(TRUE)
				xeno.visible_message(SPAN_XENOWARNING("\The [xeno] smashes the window with their tail!"), SPAN_XENOWARNING("We smash the window with our tail!"))
				apply_cooldown(cooldown_modifier = 0.2)
				return
			if(current_structure.density && !current_structure.throwpass)
				to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
				return
	// find a target in the target turf
	if(!iscarbon(targeted_atom) || hit_target.stat == DEAD)
		for(var/mob/living/carbon/carbonara in get_turf(targeted_atom))
			hit_target = carbonara
			if(!xeno.can_not_harm(hit_target) && hit_target.stat != DEAD)
				break

	if(iscarbon(hit_target) && !xeno.can_not_harm(hit_target) && hit_target.stat != DEAD)
		if(targeted_atom == hit_target) //reward for a direct hit
			to_chat(xeno, SPAN_XENOHIGHDANGER("We directly strike [hit_target] with our tail, throwing it back with the force of the hit!"))
			if(hit_target.mob_size < MOB_SIZE_BIG)
				step_away(hit_target, xeno)
		else
			to_chat(xeno, SPAN_XENODANGER("We attack [hit_target] with our tail!"))
	else
		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] swings their tail through the air!"), SPAN_XENOWARNING("We swing our tail through the air!"))
		apply_cooldown(cooldown_modifier = 0.2)
		playsound(xeno, 'sound/effects/alien_tail_swipe1.ogg', 50, TRUE)
		return

	// FX
	var/stab_direction

	stab_direction = turn(xeno.dir, pick(90, -90))
	playsound(hit_target,'sound/weapons/alien_tail_attack.ogg', 50, TRUE)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = xeno.dir

	xeno.setDir(stab_direction)
	xeno.flick_attack_overlay(hit_target, "slash")
	xeno.animation_attack_on(hit_target)

	var/new_dir = xeno.dir
	addtimer(CALLBACK(src, PROC_REF(reset_direction), xeno, last_dir, new_dir), 0.5 SECONDS)

	hit_target.apply_armoured_damage(get_xeno_damage_slash(hit_target, xeno.caste.melee_damage_upper), ARMOR_MELEE, BRUTE, "chest")

	shake_camera(hit_target, 2, 1)
	if(hit_target.mob_size < MOB_SIZE_BIG)
		hit_target.apply_effect(0.5, WEAKEN)
	else
		hit_target.apply_effect(0.5, SLOW)

	hit_target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	log_attack("[key_name(xeno)] attacked [key_name(hit_target)] with Tail Axe")

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/tail_axe/proc/reset_direction(mob/living/carbon/xenomorph/xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == xeno.dir)
		xeno.setDir(last_dir)
