
//Burrower Abilities
/mob/living/carbon/Xenomorph/proc/burrow()
	if(!check_state())
		return

	if(used_burrow || tunnel || is_ventcrawling || action_busy)
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	if(istype(T, /turf/open/floor/almayer/research/containment))
		to_chat(src, SPAN_XENOWARNING("You can't escape this cell!"))
		return

	if(clone) //Prevents burrowing on stairs
		to_chat(src, SPAN_XENOWARNING("You can't burrow here!"))
		return

	used_burrow = TRUE

	if(!burrow)
		to_chat(src, SPAN_XENOWARNING("You begin burrowing yourself into the ground."))
		if(!do_after(src, 15, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			add_timer(CALLBACK(src, /mob/living/carbon/Xenomorph/proc/do_burrow_cooldown), (caste ? caste.burrow_cooldown : SECONDS_5))
			return
		// TODO Make immune to all damage here.
		to_chat(src, SPAN_XENOWARNING("You burrow yourself into the ground."))
		burrow = TRUE
		frozen = TRUE
		invisibility = 101
		anchored = TRUE
		density = FALSE
		update_canmove()
		update_icons()
		add_timer(CALLBACK(src, /mob/living/carbon/Xenomorph/proc/do_burrow_cooldown), (caste ? caste.burrow_cooldown : SECONDS_5))
		burrow_timer = world.time + 90		// How long we can be burrowed
		process_burrow()
		return

	burrow_off()

/mob/living/carbon/Xenomorph/proc/process_burrow()
	if(!burrow)
		return
	if(world.time > burrow_timer && !tunnel)
		burrow = FALSE
		burrow_off()
	if(observed_xeno)
		overwatch(observed_xeno, TRUE)
	if(burrow)
		add_timer(CALLBACK(src, /mob/living/carbon/Xenomorph/proc/process_burrow), SECONDS_1)

/mob/living/carbon/Xenomorph/proc/burrow_off()

	to_chat(src, SPAN_NOTICE("You resurface."))
	frozen = FALSE
	invisibility = FALSE
	anchored = FALSE
	density = TRUE
	for(var/mob/living/carbon/human/H in loc)
		H.KnockDown(2)
	add_timer(CALLBACK(src, /mob/living/carbon/Xenomorph/proc/do_burrow_cooldown), (caste ? caste.burrow_cooldown : SECONDS_5))
	update_canmove()
	update_icons()

/mob/living/carbon/Xenomorph/proc/do_burrow_cooldown()
	used_burrow = FALSE
	to_chat(src, SPAN_NOTICE("You can now surface."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()


/mob/living/carbon/Xenomorph/proc/tunnel(var/turf/T)
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

	if(clone) //Prevents tunnels in Z transition areas
		to_chat(src, SPAN_XENOWARNING("You make tunnels, not wormholes!"))
		return

	var/area/A = get_area(T)
	if(A.flags_atom & AREA_NOTUNNEL)
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
		add_timer(CALLBACK(src, /mob/living/carbon/Xenomorph/proc/do_tunnel_cooldown), (caste ? caste.tunnel_cooldown : SECONDS_5))
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
		add_timer(CALLBACK(src, /mob/living/carbon/Xenomorph/proc/process_tunnel, T), SECONDS_1)

/mob/living/carbon/Xenomorph/proc/do_tunnel(var/turf/T)
	to_chat(src, SPAN_NOTICE("You tunnel to your destination."))
	anchored = FALSE
	frozen = FALSE
	update_canmove()
	forceMove(T)
	burrow = FALSE
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

	var/new_name = copytext(sanitize(input("Change the description of the tunnel:", "Tunnel Description") as text|null), 1, MAX_MESSAGE_LEN)
	if(new_name)
		new_name = "[new_name] ([get_area_name(T)])"
		log_admin("[key_name(src)] has renamed the tunnel \"[T.tunnel_desc]\" as \"[new_name]\".")
		msg_admin_niche("[src]/([key_name(src)]) has renamed the tunnel \"[T.tunnel_desc]\" as \"[new_name]\".")
		T.tunnel_desc = "[new_name]"
	return

