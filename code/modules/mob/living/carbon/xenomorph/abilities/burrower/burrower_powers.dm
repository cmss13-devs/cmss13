
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

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/build_tunnel/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xenomorph = owner
	if(!xenomorph.check_state())
		return

	if(xenomorph.action_busy)
		to_chat(xenomorph, SPAN_XENOWARNING("We should finish up what we're doing before digging."))
		return

	var/turf/turf = xenomorph.loc
	if(!istype(turf)) //logic
		to_chat(xenomorph, SPAN_XENOWARNING("We can't do that from there."))
		return

	if(!turf.can_dig_xeno_tunnel() || !is_ground_level(turf.z))
		to_chat(xenomorph, SPAN_XENOWARNING("We scrape around, but we can't seem to dig through that kind of floor."))
		return

	if(locate(/obj/structure/tunnel) in xenomorph.loc)
		to_chat(xenomorph, SPAN_XENOWARNING("There already is a tunnel here."))
		return

	if(locate(/obj/structure/machinery/sentry_holder/landing_zone) in xenomorph.loc)
		to_chat(xenomorph, SPAN_XENOWARNING("We can't dig a tunnel with this object in the way."))
		return

	if(xenomorph.tunnel_delay)
		to_chat(xenomorph, SPAN_XENOWARNING("We are not ready to dig a tunnel again."))
		return

	if(xenomorph.get_active_hand())
		to_chat(xenomorph, SPAN_XENOWARNING("We need an empty claw for this!"))
		return

	if(!xenomorph.check_plasma(plasma_cost))
		return

	var/area/AR = get_area(turf)

	if(isnull(AR) || !(AR.is_resin_allowed))
		if(!AR || AR.flags_area & AREA_UNWEEDABLE)
			to_chat(xenomorph, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(xenomorph, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	xenomorph.visible_message(SPAN_XENONOTICE("[xenomorph] begins digging out a tunnel entrance."), \
	SPAN_XENONOTICE("We begin digging out a tunnel entrance."), null, 5)
	if(!do_after(xenomorph, 10 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(xenomorph, SPAN_WARNING("Our tunnel caves in as we stop digging it."))
		return
	if(!xenomorph.check_plasma(plasma_cost))
		return
	xenomorph.visible_message(SPAN_XENONOTICE("\The [xenomorph] digs out a tunnel entrance."), \
	SPAN_XENONOTICE("We dig out an entrance to the tunnel network."), null, 5)

	var/obj/structure/tunnel/tunnelobj = new(turf, xenomorph.hivenumber)
	xenomorph.tunnel_delay = 1
	addtimer(CALLBACK(src, PROC_REF(cooldown_end)), 4 MINUTES)
	var/msg = strip_html(input("Add a description to the tunnel:", "Tunnel Description") as text|null)
	msg = replace_non_alphanumeric_plus(msg)
	var/description
	if(msg)
		description = msg
		msg = "[msg] ([get_area_name(tunnelobj)])"
		log_admin("[key_name(xenomorph)] has named a new tunnel \"[msg]\".")
		msg_admin_niche("[xenomorph]/([key_name(xenomorph)]) has named a new tunnel \"[msg]\".")
		tunnelobj.tunnel_desc = "[msg]"

	if(xenomorph.hive.living_xeno_queen || xenomorph.hive.allow_no_queen_actions)
		for(var/mob/living/carbon/xenomorph/target_for_message as anything in xenomorph.hive.totalXenos)
			var/overwatch_target = XENO_OVERWATCH_TARGET_HREF
			var/overwatch_src = XENO_OVERWATCH_SRC_HREF
			to_chat(target_for_message, SPAN_XENOANNOUNCE("Hive: A new tunnel[description ? " ([description])" : ""] has been created by [xenomorph] (<a href='byond://?src=\ref[target_for_message];[overwatch_target]=\ref[xenomorph];[overwatch_src]=\ref[target_for_message]'>watch</a>) at <b>[get_area_name(tunnelobj)]</b>."))

	xenomorph.use_plasma(plasma_cost)
	to_chat(xenomorph, SPAN_NOTICE("We will be ready to dig a new tunnel in 4 minutes."))
	playsound(xenomorph.loc, 'sound/weapons/pierce.ogg', 25, 1)
	apply_cooldown()

	return ..()


/datum/action/xeno_action/onclick/build_tunnel/proc/cooldown_end()
	var/mob/living/carbon/xenomorph/xenomorph = owner
	to_chat(xenomorph, SPAN_NOTICE("We are ready to dig a tunnel again."))
	xenomorph.tunnel_delay = 0
