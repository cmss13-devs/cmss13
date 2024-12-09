
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
	alpha = 100
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
	alpha = initial(alpha)
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


/datum/action/xeno_action/onclick/tremor/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/burrower_tremor = owner

	if (HAS_TRAIT(burrower_tremor, TRAIT_ABILITY_BURROWED))
		to_chat(burrower_tremor, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if (burrower_tremor.is_ventcrawling)
		to_chat(burrower_tremor, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if (!action_cooldown_check())
		return

	if (!burrower_tremor.check_state())
		return
	if (!check_and_use_plasma_owner())
		return

	playsound(burrower_tremor, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	to_chat(burrower_tremor, SPAN_XENOWARNING("We dig ourselves into the ground and cause tremors."))
	burrower_tremor.create_stomp()


	for(var/mob/living/carbon/carbon_target in range(7, burrower_tremor))
		to_chat(carbon_target, SPAN_WARNING("You struggle to remain on your feet as the ground shakes beneath your feet!"))
		shake_camera(carbon_target, 2, 3)
		if(get_dist(burrower_tremor, carbon_target) <= 3 && !burrower_tremor.can_not_harm(carbon_target))
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
	apply_cooldown()
	return ..()

// Resin Shark Powers
/datum/action/xeno_action/activable/sweep/use_ability(atom/targeted_atom) //sweep ability
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return
	if (!xeno.check_state())
		return
	if (!action_cooldown_check())
		return
	if (xeno.submerge)
		to_chat(xeno, SPAN_XENOWARNING("We cannot use that while submerged."))
		return
	xeno.spin_circle()
	xeno.visible_message(SPAN_DANGER("[xeno] whips its tail in a wide area in front of it!"), \
	SPAN_XENOWARNING("We whip our tail forward!"))
	playsound(xeno, 'sound/effects/alien_tail_swipe2.ogg', 30)
	apply_cooldown()

	//effect vars
	var/stun_duration = 0.25
	var/daze_duration = 0

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 1x3 area of turfs
	var/turf/root = get_turf(xeno)
	var/facing = get_dir(xeno, targeted_atom)
	var/turf/infront = get_step(root, facing)
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))

	temp_turfs += infront
	if (!(!infront || infront.density))
		temp_turfs += infront_left
	if (!(!infront || infront.density))
		temp_turfs += infront_right

	for (var/turf/current_turfs in temp_turfs)

		if (!istype(current_turfs))
			continue

		if (current_turfs.density)
			continue

		target_turfs += current_turfs
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/white(current_turfs, 2)

	for (var/turf/current_turfs in target_turfs)
		for (var/mob/living/carbon/target in current_turfs)
			if (target.stat == DEAD)
				continue

			if (!isxeno_human(target) || xeno.can_not_harm(target))
				continue

			xeno.visible_message(SPAN_DANGER("[xeno] knocks [target] down!"), \
			SPAN_XENOWARNING("We topple [target]!"))
			xeno.flick_attack_overlay(target, "tackle")
			target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
			log_attack("[key_name(xeno)] attacked [key_name(target)] with Sweep")
			target.apply_effect(stun_duration, WEAKEN)
			target.apply_effect(daze_duration, DAZE)
			playsound(get_turf(target), 'sound/weapons/alien_knockdown.ogg', 30, TRUE)
			xeno.animation_attack_on(target)

	xeno.emote("roar")
	return ..()

/datum/action/xeno_action/onclick/submerge/use_ability(atom/target) //submerge, sprite and state change

	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!xeno.submerge)
		to_chat(xeno, SPAN_XENOWARNING("We start burrowing into the ground."))
		if(!do_after(xeno, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return
		to_chat(xeno, SPAN_XENOWARNING("We burrow into the ground."))
		playsound(xeno, 'sound/effects/burrowing_b.ogg', 25)
		//xeno.ability_speed_modifier +=SSS0
		//xeno.armor_deflection_buff +=
		xeno.add_temp_pass_flags(PASS_MOB_THRU)
		xeno.mob_size = MOB_SIZE_BIG //knockback immune
		button.icon_state = "template_active"

	else
		to_chat(xeno, SPAN_XENOWARNING("We resurface."))
		playsound(xeno, 'sound/effects/burrowoff.ogg', 25)
		//xeno.ability_speed_modifier -=
		//xeno.armor_deflection_buff -=
		xeno.remove_temp_pass_flags(PASS_MOB_THRU)
		xeno.mob_size = MOB_SIZE_XENO //no longer knockback immune
		button.icon_state = "template"

	xeno.submerge = !xeno.submerge
	xeno.update_icons()
	apply_cooldown()
	return ..()


/*
for(var/mob/living/carbon/human/Mob in Xeno.loc)
		if(Mob.body_position == LYING_DOWN && Mob.stat != DEAD)
			Xeno.visible_message(SPAN_DANGER("[Xeno] runs [Mob] over!"),
				SPAN_DANGER("We run [Mob] over!")
			)
			var/ram_dir = pick(get_perpen_dir(Xeno.dir))
			var/dist = 1
			if(momentum == max_momentum)
				dist = momentum * 0.25
			step(Mob, ram_dir, dist)
			Mob.take_overall_armored_damage(momentum * 6)
			INVOKE_ASYNC(Mob, TYPE_PROC_REF(/mob/living/carbon/human, emote),"pain")
			shake_camera(Mob, 7,3)
			animation_flash_color(Mob)
Cannibalize for contact damage*/


/*
//datum/action/xeno_action/onclick/snare/use_ability(atom/A) // need to change this to drop a trap onto weeds

	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check())
		return
	if(!xeno.check_state())
		return

	var/turf/turf = xeno.loc

	if(!istype(turf))
		to_chat(xeno, SPAN_WARNING("We can't do that here."))
		return

	if(turf.density)
		to_chat(xeno, SPAN_WARNING("We can't do that here."))
		return

	var/is_weedable = turf.is_weedable()
	if(!is_weedable)
		to_chat(xeno, SPAN_WARNING("Bad place for a garden!"))
		return
	//if(!plant_on_semiweedable && is_weedable < FULLY_WEEDABLE)
	//.	to_chat(xeno, SPAN_WARNING("Bad place for a garden!"))
	//	return

	var/obj/effect/alien/weeds/node/node = locate() in turf
	if(node && node.weed_strength >= xeno.weed_level)
		to_chat(xeno, SPAN_WARNING("There's a pod here already!"))
		return

	var/obj/effect/alien/resin/trap/resin_trap = locate() in turf
	if(resin_trap)
		to_chat(xeno, SPAN_WARNING("We can't weed on top of a trap!"))
		return

	var/obj/effect/alien/weeds/weed = node || locate() in turf
	if(weed && weed.weed_strength >= WEED_LEVEL_HIVE)
		to_chat(xeno, SPAN_WARNING("These weeds are too strong to plant a node on!"))
		return

	for(var/obj/structure/struct in turf)
		if(struct.density && !(struct.flags_atom & ON_BORDER)) // Not sure exactly if we need to test against ON_BORDER though
			to_chat(xeno, SPAN_WARNING("We can't do that here."))
			return

	var/area/area = get_area(turf)
	if(isnull(area) || !(area.is_resin_allowed))
		if(area.flags_area & AREA_UNWEEDABLE)
			to_chat(xeno, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(xeno, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	if(!check_and_use_plasma_owner())
		return

	var/list/to_convert
	if(node)
		to_convert = node.children.Copy()

	xeno.visible_message(SPAN_XENONOTICE("\The [xeno] regurgitates a pulsating node and plants it on the ground!"), \
	SPAN_XENONOTICE("We regurgitate a pulsating node and plant it on the ground!"), null, 5)
	var/obj/effect/alien/weeds/node/new_node = new node_type(xeno.loc, src, xeno)

	if(to_convert)
		for(var/cur_weed in to_convert)
			var/turf/target_turf = get_turf(cur_weed)
			if(target_turf && !target_turf.density)
				new /obj/effect/alien/weeds(target_turf, new_node)
			qdel(cur_weed)

	playsound(xeno.loc, "alien_resin_build", 25)
	apply_cooldown()
	SEND_SIGNAL(xeno, COMSIG_XENO_PLANT_RESIN_NODE)
	return ..()
*/
/datum/action/xeno_action/activable/chomp/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (xeno.submerge)
		to_chat(xeno, SPAN_XENOWARNING("We cannot use that while submerged."))
		return

	if (!isxeno_human(target_atom) || xeno.can_not_harm(target_atom))
		to_chat(xeno, SPAN_XENODANGER("We must target a hostile!"))
		return

	if (!xeno.Adjacent(target_atom))
		to_chat(xeno, SPAN_XENODANGER("We must be adjacent to [target_atom]!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (target_carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
		return

	xeno.face_atom(target_atom)

	xeno.visible_message(SPAN_DANGER("\The [xeno] tears a chunk out of [target_atom]!"), \
					SPAN_DANGER("We tear a chunk out of [target_atom]!"))

	xeno.animation_attack_on(target_atom)
	xeno.flick_attack_overlay(target_atom, "bite")
	target_carbon.handle_blood_splatter(get_dir(xeno.loc, target_carbon.loc))
	target_carbon.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	log_attack("[key_name(xeno)] attacked [key_name(target_carbon)] with Sweep")
	target_carbon.apply_armoured_damage(35, ARMOR_MELEE, BRUTE, "chest", 10)
	playsound(target_carbon, 'sound/weapons/alien_bite2.ogg', 30, TRUE)
	return ..()

//datum/action/xeno_action/onclick/burrow_deep/use_ability(atom/target)
//datum/action/xeno_action/onclick/ripples/use_ability(atom/target)
/*
essentially you want to get list of all humans within 7 tiles and then start with closest for loop, and going up
assemble the in range list before the for loops, start with the closest for loop looping over the list, after you send the message to the player, remove them from the list
*/
