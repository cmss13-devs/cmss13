// devolve a xeno - lots of old, vaguely shitty code here
/datum/action/xeno_action/onclick/deevolve/use_ability(atom/Atom)
	var/mob/living/carbon/Xenomorph/Queen/user_xeno = owner
	if(!user_xeno.check_state())
		return
	if(!user_xeno.observed_xeno)
		to_chat(user_xeno, SPAN_WARNING("You must overwatch the xeno you want to de-evolve."))
		return

	var/mob/living/carbon/Xenomorph/target_xeno = user_xeno.observed_xeno
	if(!user_xeno.check_plasma(plasma_cost))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] doesn't belong to your hive!"))
		return

	if(target_xeno.is_ventcrawling)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved here."))
		return

	if(!isturf(target_xeno.loc))
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved here."))
		return

	if(target_xeno.health <= 0)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] is too weak to be deevolved."))
		return

	if(length(target_xeno.caste.deevolves_to) < 1)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] can't be deevolved."))
		return

	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno] is banished and can't be deevolved."))
		return


	var/newcaste

	if(length(target_xeno.caste.deevolves_to) == 1)
		newcaste = target_xeno.caste.deevolves_to[1]
	else if(length(target_xeno.caste.deevolves_to) > 1)
		newcaste = tgui_input_list(user_xeno, "Choose a caste you want to de-evolve [target_xeno] to.", "De-evolve", target_xeno.caste.deevolves_to, theme="hive_status")

	if(!newcaste)
		return

	if(newcaste == "Larva")
		to_chat(user_xeno, SPAN_XENOWARNING("You cannot deevolve xenomorphs to larva."))
		return

	if (user_xeno.observed_xeno != target_xeno)
		return

	var/confirm = alert(user_xeno, "Are you sure you want to deevolve [target_xeno] from [target_xeno.caste.caste_type] to [newcaste]?", , "Yes", "No")
	if(confirm == "No")
		return

	var/reason = stripped_input(user_xeno, "Provide a reason for deevolving this xenomorph, [target_xeno]")
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("You must provide a reason for deevolving [target_xeno]."))
		return

	if (!check_and_use_plasma_owner(plasma_cost))
		return

	to_chat(target_xeno, SPAN_XENOWARNING("The queen is deevolving you for the following reason: [reason]"))

	var/xeno_type
	var/level_to_switch_to = target_xeno.get_vision_level()
	switch(newcaste)
		if(XENO_CASTE_RUNNER)
			xeno_type = /mob/living/carbon/Xenomorph/Runner
		if(XENO_CASTE_DRONE)
			xeno_type = /mob/living/carbon/Xenomorph/Drone
		if(XENO_CASTE_SENTINEL)
			xeno_type = /mob/living/carbon/Xenomorph/Sentinel
		if(XENO_CASTE_SPITTER)
			xeno_type = /mob/living/carbon/Xenomorph/Spitter
		if(XENO_CASTE_LURKER)
			xeno_type = /mob/living/carbon/Xenomorph/Lurker
		if(XENO_CASTE_WARRIOR)
			xeno_type = /mob/living/carbon/Xenomorph/Warrior
		if(XENO_CASTE_DEFENDER)
			xeno_type = /mob/living/carbon/Xenomorph/Defender
		if(XENO_CASTE_BURROWER)
			xeno_type = /mob/living/carbon/Xenomorph/Burrower

	//From there, the new xeno exists, hopefully
	var/mob/living/carbon/Xenomorph/new_xeno = new xeno_type(get_turf(target_xeno), target_xeno)

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(user_xeno, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		if(new_xeno)
			qdel(new_xeno)
		return

	if(target_xeno.mind)
		target_xeno.mind.transfer_to(new_xeno)
	else
		new_xeno.key = target_xeno.key
		if(new_xeno.client)
			new_xeno.client.change_view(world_view_size)
			new_xeno.client.pixel_x = 0
			new_xeno.client.pixel_y = 0

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()
	if(new_xeno.client)
		new_xeno.set_lighting_alpha(level_to_switch_to)
	// If the player has self-deevolved before, don't allow them to do it again
	if(!(/mob/living/carbon/Xenomorph/verb/Deevolve in target_xeno.verbs))
		remove_verb(new_xeno, /mob/living/carbon/Xenomorph/verb/Deevolve)

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_type] emerges from the husk of \the [target_xeno]."), \
	SPAN_XENODANGER("[user_xeno] makes you regress into your previous form."))

	if(user_xeno.hive.living_xeno_queen && user_xeno.hive.living_xeno_queen.observed_xeno == target_xeno)
		user_xeno.hive.living_xeno_queen.overwatch(new_xeno)

	message_staff("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")
	log_admin("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")

	target_xeno.transfer_observers_to(new_xeno)

	if(round_statistics && !new_xeno.statistic_exempt)
		round_statistics.track_new_participant(target_xeno.faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.stop_tracking(target_xeno)
	SSround_recording.recorder.track_player(new_xeno)
	qdel(target_xeno)
	..()
	return

/datum/action/xeno_action/onclick/remove_eggsac/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(X.action_busy) return
	var/answer = alert(X, "Are you sure you want to remove your ovipositor? (5min cooldown to grow a new one)", , "Yes", "No")
	if(answer != "Yes")
		return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.visible_message(SPAN_XENOWARNING("\The [X] starts detaching itself from its ovipositor!"), \
		SPAN_XENOWARNING("You start detaching yourself from your ovipositor."))
	if(!do_after(X, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 10)) return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.dismount_ovipositor()


/datum/action/xeno_action/onclick/grow_ovipositor/use_ability(atom/Atom)
	var/mob/living/carbon/Xenomorph/Queen/xeno = owner
	if(!xeno.check_state())
		return

	var/turf/current_turf = get_turf(xeno)
	if(!current_turf || !istype(current_turf))
		return

	if(!action_cooldown_check())
		to_chat(xeno, SPAN_XENOWARNING("You're still recovering from detaching your old ovipositor. Wait [DisplayTimeText(timeleft(cooldown_timer_id))]."))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(xeno, SPAN_XENOWARNING("You need to be on resin to grow an ovipositor."))
		return

	if(GLOB.interior_manager.interior_z == xeno.z)
		to_chat(xeno, SPAN_XENOWARNING("It's too tight in here to grow an ovipositor."))
		return

	if(alien_weeds.linked_hive.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_XENOWARNING("These weeds don't belong to your hive! You can't grow an ovipositor here."))
		return

	if(!xeno.check_alien_construction(current_turf))
		return

	if(xeno.action_busy)
		return

	if(!xeno.check_plasma(plasma_cost))
		return

	xeno.visible_message(SPAN_XENOWARNING("\The [xeno] starts to grow an ovipositor."), \
	SPAN_XENOWARNING("You start to grow an ovipositor...(takes 20 seconds, hold still)"))
	if(!do_after(xeno, 200, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, numticks = 20) && xeno.check_plasma(plasma_cost))
		return
	if(!xeno.check_state()) return
	if(!locate(/obj/effect/alien/weeds) in current_turf)
		return
	xeno.use_plasma(plasma_cost)
	xeno.visible_message(SPAN_XENOWARNING("\The [xeno] has grown an ovipositor!"), \
	SPAN_XENOWARNING("You have grown an ovipositor!"))
	xeno.mount_ovipositor()


/datum/action/xeno_action/onclick/set_xeno_lead/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return
	var/datum/hive_status/hive = X.hive
	if(X.observed_xeno)
		if(!hive.open_xeno_leader_positions.len && X.observed_xeno.hive_pos == NORMAL_XENO)
			to_chat(X, SPAN_XENOWARNING("You currently have [hive.xeno_leader_list.len] promoted leaders. You may not maintain additional leaders until your power grows."))
			return
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno
		if(T == X)
			to_chat(X, SPAN_XENOWARNING("You cannot add yourself as a leader!"))
			return
		apply_cooldown()
		if(T.hive_pos == NORMAL_XENO)
			if(!hive.add_hive_leader(T))
				to_chat(X, SPAN_XENOWARNING("Unable to add the leader."))
				return
			to_chat(X, SPAN_XENONOTICE("You've selected [T] as a Hive Leader."))
			to_chat(T, SPAN_XENOANNOUNCE("[X] has selected you as a Hive Leader. The other Xenomorphs must listen to you. You will also act as a beacon for the Queen's pheromones."))
		else
			hive.remove_hive_leader(T)
			to_chat(X, SPAN_XENONOTICE("You've demoted [T] from Hive Leader."))
			to_chat(T, SPAN_XENOANNOUNCE("[X] has demoted you from Hive Leader. Your leadership rights and abilities have waned."))
	else
		var/list/possible_xenos = list()
		for(var/mob/living/carbon/Xenomorph/T in hive.xeno_leader_list)
			possible_xenos += T

		if(possible_xenos.len > 1)
			var/mob/living/carbon/Xenomorph/selected_xeno = tgui_input_list(X, "Target", "Watch which leader?", possible_xenos, theme="hive_status")
			if(!selected_xeno || selected_xeno.hive_pos == NORMAL_XENO || selected_xeno == X.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z != X.z || !X.check_state())
				return
			X.overwatch(selected_xeno)
		else if(possible_xenos.len)
			X.overwatch(possible_xenos[1])
		else
			to_chat(X, SPAN_XENOWARNING("There are no Xenomorph leaders. Overwatch a Xenomorph to make it a leader."))


/datum/action/xeno_action/activable/queen_heal/use_ability(atom/A, verbose)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/T = get_turf(A)
	if(!T)
		to_chat(X, SPAN_WARNING("You must select a valid turf to heal around."))
		return

	if(X.loc.z != T.loc.z)
		to_chat(X, SPAN_XENOWARNING("You are too far away to do this here."))
		return

	if(!check_and_use_plasma_owner())
		return

	for(var/mob/living/carbon/Xenomorph/Xa in range(4, T))
		if(!X.can_not_harm(Xa))
			continue

		if(SEND_SIGNAL(Xa, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			if(verbose)
				to_chat(X, SPAN_XENOMINORWARNING("You cannot heal [Xa]!"))
			continue

		if(Xa == X)
			continue

		if(Xa.stat == DEAD || QDELETED(Xa))
			continue

		if(!Xa.caste.can_be_queen_healed)
			continue

		new /datum/effects/heal_over_time(Xa, Xa.maxHealth * 0.3, 2 SECONDS, 2)
		Xa.flick_heal_overlay(3 SECONDS, "#D9F500")	//it's already hard enough to gauge health without hp overlays!

	apply_cooldown()
	to_chat(X, SPAN_XENONOTICE("You channel your plasma to heal your sisters' wounds around this area."))

/datum/action/xeno_action/onclick/banish/use_ability(atom/Atom)
	var/mob/living/carbon/Xenomorph/Queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost))
		return

	var/choice = tgui_input_list(user_xeno, "Choose a xenomorph to banish:", "Banish", user_xeno.hive.totalXenos, theme="hive_status")

	if(!choice)
		return

	var/mob/living/carbon/Xenomorph/target_xeno

	for(var/mob/living/carbon/Xenomorph/xeno in user_xeno.hive.totalXenos)
		if(html_encode(xeno.name) == html_encode(choice))
			target_xeno = xeno
			break

	if(target_xeno == user_xeno)
		to_chat(user_xeno, SPAN_XENOWARNING("You cannot banish yourself."))
		return

	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph is already banished!"))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph doesn't belong to your hive!"))
		return

	// No banishing critted xenos
	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("What's the point? They're already about to die."))
		return

	var/confirm = alert(user_xeno, "Are you sure you want to banish [target_xeno] from the hive? This should only be done with good reason. (Note this prevents them from rejoining the hive after dying for 30 minutes as well unless readmitted)", , "Yes", "No")
	if(confirm == "No")
		return

	var/reason = stripped_input(user_xeno, "Provide a reason for banishing [target_xeno]. This will be announced to the entire hive!")
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("You must provide a reason for banishing [target_xeno]."))
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost) || target_xeno.health < 0)
		return

	// Let everyone know they were banished
	xeno_announcement("By [user_xeno]'s will, [target_xeno] has been banished from the hive!\n\n[reason]", user_xeno.hivenumber, title=SPAN_ANNOUNCEMENT_HEADER_BLUE("Banishment"))
	to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [user_xeno] has banished you from the hive! Other xenomorphs may now attack you freely, but your link to the hivemind remains, preventing you from harming other sisters.")))

	target_xeno.banished = TRUE
	target_xeno.hud_update_banished()
	target_xeno.lock_evolve = TRUE
	user_xeno.hive.banished_ckeys[target_xeno.name] = target_xeno.ckey
	addtimer(CALLBACK(src, .proc/remove_banish, user_xeno.hive, target_xeno.name), 30 MINUTES)

	message_staff("[key_name_admin(user_xeno)] has banished [key_name_admin(target_xeno)]. Reason: [reason]")

/datum/action/xeno_action/onclick/banish/proc/remove_banish(var/datum/hive_status/hive, var/name)
	hive.banished_ckeys.Remove(name)


// Readmission = un-banish

/datum/action/xeno_action/onclick/readmit/use_ability(atom/Atom)
	var/mob/living/carbon/Xenomorph/Queen/user_xeno = owner
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost))
		return

	var/choice = tgui_input_list(user_xeno, "Choose a xenomorph to readmit:", "Re-admit", user_xeno.hive.banished_ckeys, theme="hive_status")

	if(!choice)
		return

	var/banished_ckey
	var/banished_name

	for(var/mob_name in user_xeno.hive.banished_ckeys)
		if(user_xeno.hive.banished_ckeys[mob_name] == user_xeno.hive.banished_ckeys[choice])
			banished_ckey = user_xeno.hive.banished_ckeys[mob_name]
			banished_name = mob_name
			break

	var/banished_living = FALSE
	var/mob/living/carbon/Xenomorph/target_xeno

	for(var/mob/living/carbon/Xenomorph/xeno in user_xeno.hive.totalXenos)
		if(xeno.ckey == banished_ckey)
			target_xeno = xeno
			banished_living = TRUE
			break

	if(banished_living)
		if(!target_xeno.banished)
			to_chat(user_xeno, SPAN_XENOWARNING("This xenomorph isn't banished!"))
			return

		var/confirm = alert(user_xeno, "Are you sure you want to readmit [target_xeno] into the hive?", , "Yes", "No")
		if(confirm == "No")
			return

		if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost))
			return

		to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [user_xeno] has readmitted you into the hive.")))
		target_xeno.banished = FALSE
		target_xeno.hud_update_banished()
		target_xeno.lock_evolve = FALSE

	user_xeno.hive.banished_ckeys.Remove(banished_name)

/datum/action/xeno_action/activable/secrete_resin/remote/queen/use_ability(atom/A)
	. = ..()
	if(!.)
		return

	if(!boosted)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	var/datum/hive_status/HS = X.hive
	if(!HS || !HS.hive_location)
		return
	// 5 screen radius
	if(get_dist(A, HS.hive_location) > 35)
		// Apply the normal cooldown if not building near the hive
		apply_cooldown_override(initial(xeno_cooldown))

/datum/action/xeno_action/onclick/eye
	name = "Enter Eye Form"
	action_icon_state = "queen_eye"
	plasma_cost = 0

/datum/action/xeno_action/onclick/eye/use_ability(atom/A)
	. = ..()
	if(!owner)
		return

	new /mob/hologram/queen(owner.loc, owner)
	qdel(src)

/datum/action/xeno_action/activable/expand_weeds
	var/list/recently_built_turfs

/datum/action/xeno_action/activable/expand_weeds/New(Target, override_icon_state)
	. = ..()
	recently_built_turfs = list()

/datum/action/xeno_action/activable/expand_weeds/Destroy()
	recently_built_turfs = null
	return ..()

/datum/action/xeno_action/activable/expand_weeds/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/T = get_turf(A)

	if(!T || T.is_weedable() < FULLY_WEEDABLE || T.density || (T.z != X.z))
		to_chat(X, SPAN_XENOWARNING("You can't do that here."))
		return

	var/area/AR = get_area(T)
	if(!AR.is_resin_allowed)
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	var/obj/effect/alien/weeds/located_weeds = locate() in T
	if(located_weeds)
		if(istype(located_weeds, /obj/effect/alien/weeds/node))
			return

		if(located_weeds.weed_strength > X.weed_level)
			to_chat(X, SPAN_XENOWARNING("There's stronger weeds here already!"))
			return

		if (!check_and_use_plasma_owner(node_plant_plasma_cost))
			return

		to_chat(X, SPAN_XENONOTICE("You plant a node at [T]."))
		new /obj/effect/alien/weeds/node(T, null, X)
		playsound(T, "alien_resin_build", 35)
		apply_cooldown_override(node_plant_cooldown)
		return

	var/obj/effect/alien/weeds/node/node
	for(var/direction in cardinal)
		var/turf/weed_turf = get_step(T, direction)
		var/obj/effect/alien/weeds/W = locate() in weed_turf
		if(W && W.hivenumber == X.hivenumber && W.parent && !W.hibernate && !LinkBlocked(W, weed_turf, T))
			node = W.parent
			break

	if(!node)
		to_chat(X, SPAN_XENOWARNING("You can only plant weeds near weeds with a connected node!"))
		return

	if(node.weed_strength >= WEED_LEVEL_HIVE)
		to_chat(X, SPAN_XENOWARNING("You cannot expand hive weeds!"))
		return

	if(T in recently_built_turfs)
		to_chat(X, SPAN_XENOWARNING("You've recently built here already!"))
		return

	if (!check_and_use_plasma_owner())
		return

	new /obj/effect/alien/weeds(T, node)
	playsound(T, "alien_resin_build", 35)

	recently_built_turfs += T
	addtimer(CALLBACK(src, .proc/reset_turf_cooldown, T), turf_build_cooldown)

	to_chat(X, SPAN_XENONOTICE("You plant weeds at [T]."))
	apply_cooldown()

/datum/action/xeno_action/activable/expand_weeds/proc/reset_turf_cooldown(var/turf/T)
	recently_built_turfs -= T

/datum/action/xeno_action/activable/place_queen_beacon/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/Q = owner
	if(!Q.check_state())
		return FALSE

	if(Q.action_busy)
		return FALSE

	var/turf/T = get_turf(A)
	if(!check_turf(Q, T))
		return FALSE
	if(!do_after(Q, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		return FALSE
	if(!check_turf(Q, T))
		return FALSE

	for(var/i in transported_xenos)
		UnregisterSignal(i, COMSIG_MOVABLE_PRE_MOVE)

	to_chat(Q, SPAN_XENONOTICE("You rally the hive to the queen beacon!"))
	LAZYCLEARLIST(transported_xenos)
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, .proc/tunnel_xeno)
	for(var/xeno in hive.totalXenos)
		if(xeno == Q)
			continue
		tunnel_xeno(src, xeno)

	addtimer(CALLBACK(src, .proc/transport_xenos, T), 3 SECONDS)
	return TRUE

/datum/action/xeno_action/activable/place_queen_beacon/proc/tunnel_xeno(datum/source, mob/living/carbon/Xenomorph/X)
	SIGNAL_HANDLER
	if(X.z == owner.z)
		to_chat(X, SPAN_XENONOTICE("You begin tunneling towards the queen beacon!"))
		RegisterSignal(X, COMSIG_MOVABLE_PRE_MOVE, .proc/cancel_movement)
		LAZYADD(transported_xenos, X)

/datum/action/xeno_action/activable/place_queen_beacon/proc/transport_xenos(turf/target)
	UnregisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN)
	for(var/xeno in transported_xenos)
		var/mob/living/carbon/Xenomorph/X = xeno
		to_chat(X, SPAN_XENONOTICE("You tunnel to the queen beacon!"))
		UnregisterSignal(X, COMSIG_MOVABLE_PRE_MOVE)
		if(target)
			X.forceMove(target)

/datum/action/xeno_action/activable/place_queen_beacon/proc/cancel_movement()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_MOVE

/datum/action/xeno_action/activable/place_queen_beacon/proc/check_turf(mob/living/carbon/Xenomorph/Queen/Q, turf/T)
	if(!T || T.density)
		to_chat(Q, SPAN_XENOWARNING("You can't place a queen beacon here."))
		return FALSE

	if(T.z != Q.z)
		to_chat(Q, SPAN_XENOWARNING("That's too far away!"))
		return FALSE

	var/obj/effect/alien/weeds/located_weeds = locate() in T
	if(!located_weeds)
		to_chat(Q, SPAN_XENOWARNING("You need to place the queen beacon on weeds."))
		return FALSE

	return TRUE


/datum/action/xeno_action/activable/blockade/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/Q = owner
	if(!Q.check_state())
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if(Q.action_busy)
		return FALSE

	var/width = initial(pillar_type.width)
	var/height = initial(pillar_type.height)

	var/turf/T = get_turf(A)
	if(T.density)
		to_chat(Q, SPAN_XENOWARNING("You can only construct this blockade in open areas!"))
		return FALSE

	if(T.z != owner.z)
		to_chat(Q, SPAN_XENOWARNING("That's too far away!"))
		return FALSE

	if(!T.weeds)
		to_chat(Q, SPAN_XENOWARNING("You can only construct this blockade on weeds!"))
		return FALSE

	if(!Q.check_plasma(plasma_cost))
		return

	var/list/alerts = list()
	for(var/i in RANGE_TURFS(Floor(width/2), T))
		alerts += new /obj/effect/warning/alien(i)

	if(!do_after(Q, time_taken, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		QDEL_NULL_LIST(alerts)
		return FALSE
	QDEL_NULL_LIST(alerts)

	if(!check_turf(Q, T))
		return FALSE

	if(!check_and_use_plasma_owner())
		return

	var/turf/new_turf = locate(max(T.x - Floor(width/2), 1), max(T.y - Floor(height/2), 1), T.z)
	to_chat(Q, SPAN_XENONOTICE("You raise a blockade!"))
	var/obj/effect/alien/resin/resin_pillar/RP = new pillar_type(new_turf)
	RP.start_decay(brittle_time, decay_time)

	return TRUE

/datum/action/xeno_action/activable/blockade/proc/check_turf(mob/living/carbon/Xenomorph/Queen/Q, turf/T)
	if(T.density)
		to_chat(Q, SPAN_XENOWARNING("You can't place a blockade here."))
		return FALSE

	return TRUE

/mob/living/carbon/Xenomorph/proc/xeno_tacmap()
	set name = "View Xeno Tacmap"
	set desc = "This opens a tactical map, where you can see where every xenomorph is."
	set category = "Alien"

	var/icon/O = overlay_tacmap(TACMAP_XENO, TACMAP_BASE_OPEN, hivenumber)
	if(O)
		src << browse_rsc(O, "marine_minimap.png")
		show_browser(src, "<img src=marine_minimap.png>", "Xeno Tacmap", "marineminimap", "size=[(map_sizes[1]*2)+50]x[(map_sizes[2]*2)+50]", closeref = src)
