// devolve a xeno - lots of old, vaguely shitty code here
/datum/action/xeno_action/onclick/deevolve/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(!X.observed_xeno)
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to de-evolve."))
		return

	var/mob/living/carbon/Xenomorph/T = X.observed_xeno
	if(!X.check_plasma(plasma_cost)) return

	if(T.hivenumber != X.hivenumber)
		to_chat(X, SPAN_XENOWARNING("[T] doesn't belong to your hive!"))
		return

	if(T.is_ventcrawling)
		to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved here."))
		return

	if(!isturf(T.loc))
		to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved here."))
		return

	if(T.health <= 0)
		to_chat(X, SPAN_XENOWARNING("[T] is too weak to be deevolved."))
		return

	if(!T.caste.deevolves_to)
		to_chat(X, SPAN_XENOWARNING("[T] can't be deevolved."))
		return

	var/newcaste = T.caste.deevolves_to
	if(newcaste == "Larva")
		to_chat(X, SPAN_XENOWARNING("You cannot deevolve xenomorphs to larva."))
		return

	if (X.observed_xeno != T)
		return

	var/confirm = alert(X, "Are you sure you want to deevolve [T] from [T.caste.caste_name] to [newcaste]?", , "Yes", "No")
	if(confirm == "No")
		return

	var/reason = stripped_input(X, "Provide a reason for deevolving this xenomorph, [T]")
	if(isnull(reason))
		to_chat(X, SPAN_XENOWARNING("You must provide a reason for deevolving [T]."))
		return

	if (!check_and_use_plasma_owner())
		return

	to_chat(T, SPAN_XENOWARNING("The queen is deevolving you for the following reason: [reason]"))

	var/xeno_type

	switch(newcaste)
		if("Runner")
			xeno_type = /mob/living/carbon/Xenomorph/Runner
		if("Drone")
			xeno_type = /mob/living/carbon/Xenomorph/Drone
		if("Sentinel")
			xeno_type = /mob/living/carbon/Xenomorph/Sentinel
		if("Spitter")
			xeno_type = /mob/living/carbon/Xenomorph/Spitter
		if("Lurker")
			xeno_type = /mob/living/carbon/Xenomorph/Lurker
		if("Warrior")
			xeno_type = /mob/living/carbon/Xenomorph/Warrior
		if("Defender")
			xeno_type = /mob/living/carbon/Xenomorph/Defender
		if("Burrower")
			xeno_type = /mob/living/carbon/Xenomorph/Burrower

	//From there, the new xeno exists, hopefully
	var/mob/living/carbon/Xenomorph/new_xeno = new xeno_type(get_turf(T), T)

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(X, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		if(new_xeno)
			qdel(new_xeno)
		return

	if(T.mind)
		T.mind.transfer_to(new_xeno)
	else
		new_xeno.key = T.key
		if(new_xeno.client)
			new_xeno.client.change_view(world_view_size)
			new_xeno.client.pixel_x = 0
			new_xeno.client.pixel_y = 0

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()

	// If the player has self-deevolved before, don't allow them to do it again
	if(!(/mob/living/carbon/Xenomorph/verb/Deevolve in T.verbs))
		remove_verb(new_xeno, /mob/living/carbon/Xenomorph/verb/Deevolve)

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_name] emerges from the husk of \the [T]."), \
	SPAN_XENODANGER("[X] makes you regress into your previous form."))

	if(X.hive.living_xeno_queen && X.hive.living_xeno_queen.observed_xeno == T)
		X.hive.living_xeno_queen.overwatch(new_xeno)

	message_staff("[key_name_admin(X)] has deevolved [key_name_admin(T)]. Reason: [reason]")
	log_admin("[key_name_admin(X)] has deevolved [key_name_admin(T)]. Reason: [reason]")
	qdel(T)
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


/datum/action/xeno_action/onclick/grow_ovipositor/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	var/turf/current_turf = get_turf(X)
	if(!current_turf || !istype(current_turf))
		return

	if(X.ovipositor_cooldown > world.time)
		to_chat(X, SPAN_XENOWARNING("You're still recovering from detaching your old ovipositor. Wait [round((X.ovipositor_cooldown-world.time)*0.1)] seconds"))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(X, SPAN_XENOWARNING("You need to be on resin to grow an ovipositor."))
		return

	if(interior_manager && interior_manager.interior_z == X.z)
		to_chat(X, SPAN_XENOWARNING("It's too tight in here to grow an ovipositor."))
		return

	if(alien_weeds.linked_hive.hivenumber != X.hivenumber)
		to_chat(X, SPAN_XENOWARNING("These weeds don't belong to your hive! You can't grow an ovipositor here."))
		return

	if(!X.check_alien_construction(current_turf))
		return

	if(X.action_busy)
		return

	if(X.check_plasma(plasma_cost))
		X.visible_message(SPAN_XENOWARNING("\The [X] starts to grow an ovipositor."), \
		SPAN_XENOWARNING("You start to grow an ovipositor...(takes 20 seconds, hold still)"))
		if(!do_after(X, 200, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, numticks = 20) && X.check_plasma(plasma_cost))
			return
		if(!X.check_state()) return
		if(!locate(/obj/effect/alien/weeds) in current_turf)
			return
		X.use_plasma(plasma_cost)
		X.visible_message(SPAN_XENOWARNING("\The [X] has grown an ovipositor!"), \
		SPAN_XENOWARNING("You have grown an ovipositor!"))
		X.mount_ovipositor()


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
			var/mob/living/carbon/Xenomorph/selected_xeno = input(X, "Target", "Watch which xenomorph leader?") as null|anything in possible_xenos
			if(!selected_xeno || selected_xeno.hive_pos == NORMAL_XENO || selected_xeno == X.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z != X.z || !X.check_state())
				return
			X.overwatch(selected_xeno)
		else if(possible_xenos.len)
			X.overwatch(possible_xenos[1])
		else
			to_chat(X, SPAN_XENOWARNING("There are no Xenomorph leaders. Overwatch a Xenomorph to make it a leader."))


/datum/action/xeno_action/activable/queen_heal/use_ability(atom/A)
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
		if(!X.match_hivemind(Xa))
			continue

		if(Xa.on_fire)
			continue

		if(Xa == X)
			continue

		if(Xa.stat == DEAD || QDELETED(Xa))
			continue

		if(!Xa.caste.can_be_queen_healed)
			continue

		if(Xa.health < Xa.maxHealth)
			Xa.gain_health(75)
		new /datum/effects/heal_over_time(Xa, Xa.maxHealth * 0.4, 2 SECONDS, 2)
		Xa.flick_heal_overlay(SECONDS_3, "#D9F500")	//it's already hard enough to gauge health without hp overlays!

	apply_cooldown()
	to_chat(X, SPAN_XENONOTICE("You channel your plasma to heal your sisters' wounds around this area."))

/datum/action/xeno_action/onclick/banish/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno

		if(T.banished)
			to_chat(X, SPAN_XENOWARNING("This xenomorph is already banished!"))
			return

		if(T.hivenumber != X.hivenumber)
			to_chat(X, SPAN_XENOWARNING("This xenomorph doesn't belong to your hive!"))
			return

		// No banishing critted xenos
		if(T.health < 0)
			to_chat(X, SPAN_XENOWARNING("What's the point? They're already about to die."))
			return

		var/confirm = alert(X, "Are you sure you want to banish [T] from the hive? This should only be done with good reason.", , "Yes", "No")
		if(confirm == "No")
			return

		var/reason = stripped_input(X, "Provide a reason for banishing [T]. This will be announced to the entire hive!")
		if(isnull(reason))
			to_chat(X, SPAN_XENOWARNING("You must provide a reason for banishing [T]."))
			return

		if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != T || T.health < 0)
			return

		// Let everyone know they were banished
		xeno_announcement("By [X]'s will, [T] has been banished from the hive!\n\n[reason]", X.hivenumber, title=SPAN_ANNOUNCEMENT_HEADER_BLUE("Banishment"))
		to_chat(T, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [X] has banished you from the hive! Other xenomorphs may now attack you freely, but your link to the hivemind remains, preventing you from harming other sisters.")))

		T.banished = TRUE
		T.hud_update_banished()

		message_staff("[key_name_admin(X)] has banished [key_name_admin(T)]. Reason: [reason]")

	else
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to banish."))

// Readmission = un-banish

/datum/action/xeno_action/onclick/readmit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno

		if(!T.banished)
			to_chat(X, SPAN_XENOWARNING("This xenomorph isn't banished!"))
			return

		var/confirm = alert(X, "Are you sure you want to readmit [T] into the hive?", , "Yes", "No")
		if(confirm == "No")
			return

		if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != T)
			return

		to_chat(T, FONT_SIZE_LARGE(SPAN_XENOWARNING("The [X] has readmitted you into the hive.")))
		T.banished = FALSE
		T.hud_update_banished()
	else
		to_chat(X, SPAN_WARNING("You must overwatch the xeno you want to readmit."))


/datum/action/xeno_action/onclick/eye/use_ability(atom/A)
	. = ..()
	if(!owner)
		return

	new /mob/hologram/queen(owner.loc, owner)
	qdel(src)

/datum/action/xeno_action/activable/secrete_resin/ovipositor/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X)
		return FALSE

	// Account for the do_after in the resin building proc when checking cooldown
	var/datum/resin_construction/RC = X.resin_build_order[X.selected_resin]
	var/total_build_time = RC.build_time*X.caste.build_time_mult
	return (world.time >= last_use + (total_build_time + cooldown))

/datum/action/xeno_action/activable/secrete_resin/ovipositor/use_ability(atom/A)
	if(!action_cooldown_check())
		return

	var/mob/living/carbon/Xenomorph/X = owner
	if(!X)
		return

	var/turf/T = get_turf(A)
	if(!T)
		return

	if(!..())
		return

	last_use = world.time

	var/datum/resin_construction/RC = X.resin_build_order[X.selected_resin]
	T.visible_message(SPAN_XENONOTICE("The weeds begin pulsating wildly and secrete resin in the shape of \a [RC.construction_name]!"), null, 5)
	to_chat(owner, SPAN_XENONOTICE("You focus your plasma into the weeds below you and force the weeds to secrete resin in the shape of \a [RC.construction_name]."))
	playsound(T, "alien_resin_build", 25)

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

	if(!T || !T.is_weedable() || T.density)
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
		var/obj/effect/alien/weeds/W = locate() in get_step(T, direction)
		if(W && W.hivenumber == X.hivenumber && W.parent && !W.hibernate && !LinkBlocked(W, get_turf(W), T))
			node = W.parent
			break

	if(!node)
		to_chat(X, SPAN_XENOWARNING("You can only plant weeds near weeds with a connected node!"))
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
