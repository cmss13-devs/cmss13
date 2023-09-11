/datum/action/xeno_action/onclick/build_lessers_burrow
	name = "Dig Lesser's burrow (200)"
	action_icon_state = "build_tunnel"
	plasma_cost = 200
	// macro_path = /datum/action/xeno_action/verb/verb_dig_tunnel
	action_type = XENO_ACTION_ACTIVATE //doesn't really need a macro

/datum/action/xeno_action/onclick/build_lessers_burrow/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/xenomorph/X = owner
	if(!istype(X))
		return FALSE
	if(X.tunnel_delay)
		return FALSE
	return ..()

/datum/action/xeno_action/onclick/build_lessers_burrow/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state())
		return

	if(X.action_busy)
		to_chat(X, SPAN_XENOWARNING("You should finish up what you're doing before digging."))
		return

	var/turf/T = X.loc
	if(!istype(T)) //logic
		to_chat(X, SPAN_XENOWARNING("You can't do that from there."))
		return

	if(SSticker?.mode?.hardcore)
		to_chat(X, SPAN_XENOWARNING("A certain presence is preventing you from digging tunnels here."))
		return

	if(!T.can_dig_xeno_tunnel() || !is_ground_level(T.z))
		to_chat(X, SPAN_XENOWARNING("You scrape around, but you can't seem to dig through that kind of floor."))
		return

	if(locate(/obj/structure/tunnel) in X.loc || locate(/obj/structure/lessers_burrow) in X.loc)
		to_chat(X, SPAN_XENOWARNING("There already is a tunnel here."))
		return

	if(X.tunnel_delay)
		to_chat(X, SPAN_XENOWARNING("You are not ready to dig a tunnel again."))
		return

	if(X.get_active_hand())
		to_chat(X, SPAN_XENOWARNING("You need an empty claw for this!"))
		return

	if(locate(/obj/structure/lessers_burrow) in range(16, X))
		to_chat(X, SPAN_XENOWARNING("There already is a tunnel in range."))
		return

	if(!X.check_plasma(plasma_cost))
		return

	var/area/AR = get_area(T)

	if(isnull(AR) || !(AR.is_resin_allowed))
		if(AR.flags_area & AREA_UNWEEDABLE)
			to_chat(X, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	X.visible_message(SPAN_XENONOTICE("[X] begins digging out a burrow."), \
	SPAN_XENONOTICE("You begin digging out a burrow."), null, 5)
	if(!do_after(X, 100, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(X, SPAN_WARNING("Your tunnel caves in as you stop digging it."))
		return
	if(!X.check_plasma(plasma_cost))
		return
	X.visible_message(SPAN_XENONOTICE("\The [X] digs out a burrow."), \
	SPAN_XENONOTICE("You dig out an entrance to the tunnel network."), null, 5)

	var/obj/structure/lessers_burrow/tunnelobj = new(T, X.hivenumber)
	X.tunnel_delay = 1
	addtimer(CALLBACK(src, PROC_REF(cooldown_end)), 30 SECONDS)
	log_admin("[key_name(X)] has dug out xenobots burrow.")
	msg_admin_niche("[X]/([key_name(X)]) has dug out xenobots burrow.")

	if(X.hive.living_xeno_queen || X.hive.allow_no_queen_actions)
		for(var/mob/living/carbon/xenomorph/target_for_message as anything in X.hive.totalXenos)
			var/overwatch_target = XENO_OVERWATCH_TARGET_HREF
			var/overwatch_src = XENO_OVERWATCH_SRC_HREF
			to_chat(target_for_message, SPAN_XENOANNOUNCE("Hive: A new burrow has been created by [X] (<a href='byond://?src=\ref[target_for_message];[overwatch_target]=\ref[X];[overwatch_src]=\ref[target_for_message]'>watch</a>) at <b>[get_area_name(tunnelobj)]</b>."))

	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("You will be ready to dig a new tunnel or burrow in 30 seconds."))
	playsound(X.loc, 'sound/weapons/pierce.ogg', 25, 1)

	return ..()

/datum/action/xeno_action/onclick/build_lessers_burrow/proc/cooldown_end()
	var/mob/living/carbon/xenomorph/X = owner
	to_chat(X, SPAN_NOTICE("You are ready to dig a tunnel again."))
	X.tunnel_delay = 0
