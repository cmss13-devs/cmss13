#define DELETE_TIME 1800

/mob/living/carbon/xenomorph/death(cause, gibbed)
	var/msg = "lets out a waning guttural screech, green blood bubbling from its maw."
	. = ..(cause, gibbed, msg)
	if(!.)
		return //If they're already dead, it will return.

	GLOB.living_xeno_list -= src

	if(is_zoomed)
		zoom_out()

	if(SSticker?.mode?.hardcore)
		ghostize()

	set_light_range(0)

	if(pulledby)
		pulledby.stop_pulling()

	if(!gibbed)
		if(hud_used && hud_used.healths)
			hud_used.healths.icon_state = "health_dead"
		if(hud_used && hud_used.alien_plasma_display)
			hud_used.alien_plasma_display.icon_state = "power_display_empty"
		update_icons()

	if(!should_block_game_interaction(src)) //so xeno players don't get death messages from admin tests
		if(isqueen(src))
			var/mob/living/carbon/xenomorph/queen/XQ = src
			playsound(loc, 'sound/voice/alien_queen_died.ogg', 75, 0)
			if(XQ.observed_xeno)
				XQ.overwatch(XQ.observed_xeno, TRUE)
			if(XQ.ovipositor)
				XQ.dismount_ovipositor(TRUE)

			if(GLOB.hive_datum[hivenumber].stored_larva)
				GLOB.hive_datum[hivenumber].stored_larva = floor(GLOB.hive_datum[hivenumber].stored_larva * 0.5) //Lose half on dead queen

				var/list/players_with_xeno_pref = get_alien_candidates(GLOB.hive_datum[hivenumber])
				if(players_with_xeno_pref && istype(GLOB.hive_datum[hivenumber].hive_location, /obj/effect/alien/resin/special/pylon/core))
					var/turf/larva_spawn = get_turf(GLOB.hive_datum[hivenumber].hive_location)
					var/count = 0
					while(GLOB.hive_datum[hivenumber].stored_larva > 0 && count < length(players_with_xeno_pref)) // still some left
						var/mob/xeno_candidate = players_with_xeno_pref[++count]
						var/mob/living/carbon/xenomorph/larva/new_xeno = new /mob/living/carbon/xenomorph/larva(larva_spawn)
						new_xeno.set_hive_and_update(hivenumber)

						new_xeno.generate_name()
						if(!SSticker.mode.transfer_xeno(xeno_candidate, new_xeno))
							qdel(new_xeno)
							break

						new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly burrows out of the ground!"),
						SPAN_XENODANGER("You burrow out of the ground after feeling an immense tremor through the hive, which quickly fades into complete silence..."))

						GLOB.hive_datum[hivenumber].stored_larva--
						GLOB.hive_datum[hivenumber].hive_ui.update_burrowed_larva()
					if(count)
						message_alien_candidates(players_with_xeno_pref, dequeued = count)

			if(hive && hive.living_xeno_queen == src)
				notify_ghosts(header = "Queen Death", message = "The Queen has been slain!", source = src, action = NOTIFY_ORBIT)
				xeno_message(SPAN_XENOANNOUNCE("A sudden tremor ripples through the hive... the Queen has been slain! Vengeance!"),3, hivenumber)
				hive.slashing_allowed = XENO_SLASH_ALLOWED
				hive.set_living_xeno_queen(null)
				//on the off chance there was somehow two queen alive
				for(var/mob/living/carbon/xenomorph/queen/Q in GLOB.living_xeno_list)
					if(!QDELETED(Q) && Q != src && Q.hivenumber == hivenumber)
						hive.set_living_xeno_queen(Q)
						break
				hive.on_queen_death()
				hive.handle_xeno_leader_pheromones()
				if(SSticker.mode)
					INVOKE_ASYNC(SSticker.mode, TYPE_PROC_REF(/datum/game_mode, check_queen_status), hivenumber)
					LAZYADD(SSticker.mode.dead_queens, "<br>[!isnull(full_designation) ? full_designation : "?"] was [src] [SPAN_BOLDNOTICE("(DIED)")]")

		else if(ispredalien(src))
			playsound(loc,'sound/voice/predalien_death.ogg', 25, TRUE)
		else if(isfacehugger(src))
			playsound(loc, 'sound/voice/alien_facehugger_dies.ogg', 25, TRUE)
		else
			playsound(loc, prob(50) == 1 ? 'sound/voice/alien_death.ogg' : 'sound/voice/alien_death2.ogg', 25, 1)
		var/area/A = get_area(src)
		if(hive && hive.living_xeno_queen)
			if(!HAS_TRAIT(src, TRAIT_TEMPORARILY_MUTED))
				xeno_message("Hive: [src] has <b>died</b>[A? " at [sanitize_area(A.name)]":""]! [banished ? "They were banished from the hive." : ""]", death_fontsize, hivenumber)

	if(hive && IS_XENO_LEADER(src)) //Strip them from the Xeno leader list, if they are indexed in here
		hive.remove_hive_leader(src)
		if(hive.living_xeno_queen)
			to_chat(hive.living_xeno_queen, SPAN_XENONOTICE("A leader has fallen!")) //alert queens so they can choose another leader

	hud_update() //updates the overwatch hud to remove the upgrade chevrons, gold star, etc
	SSminimaps.remove_marker(src)

	if(behavior_delegate)
		behavior_delegate.handle_death(src)

	for(var/atom/movable/A in stomach_contents)
		stomach_contents.Remove(A)
		A.acid_damage = 0 //Reset the acid damage
		A.forceMove(loc)

	// Banished xeno provide a burrowed larva on death to compensate
	if(banished && refunds_larva_if_banished)
		GLOB.hive_datum[hivenumber].stored_larva++
		GLOB.hive_datum[hivenumber].hive_ui.update_burrowed_larva()

	if(hardcore)
		QDEL_IN(src, 3 SECONDS)
	else if(!gibbed)
		AddComponent(/datum/component/weed_food)

	if(hive)
		hive.remove_xeno(src)
		// Finding the last xeno for anti-delay.
		if(SSticker.mode && SSticker.current_state != GAME_STATE_FINISHED)
			if((GLOB.last_ares_callout + 2 MINUTES) > world.time)
				return
			if(hive.hivenumber == XENO_HIVE_NORMAL && (LAZYLEN(hive.totalXenos) == 1))
				var/mob/living/carbon/xenomorph/X = LAZYACCESS(hive.totalXenos, 1)
				GLOB.last_ares_callout = world.time
				// Tell the marines where the last one is.
				var/name = "[MAIN_AI_SYSTEM] Bioscan Status"
				var/input = "Bioscan complete.\n\nSensors indicate one remaining unknown lifeform signature in [get_area(X)]."
				log_ares_bioscan(name, input)
				marine_announcement(input, name, 'sound/AI/bioscan.ogg', logging = ARES_LOG_NONE)
				// Tell the xeno she is the last one.
				if(X.client)
					to_chat(X, SPAN_XENOANNOUNCE("Your carapace rattles with dread. You are all that remains of the hive!"))
				notify_ghosts(header = "Last Xenomorph", message = "There is only one Xenomorph left: [X.name].", source = X, action = NOTIFY_ORBIT)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_XENO_DEATH, src, gibbed)
	give_action(src, /datum/action/ghost/xeno)

/mob/living/carbon/xenomorph/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	var/obj/effect/decal/remains/xeno/remains = new(get_turf(src))
	remains.icon = icon
	remains.pixel_x = pixel_x //For 2x2.

	if(!caste)
		CRASH("CASTE ERROR: gib() was called without a caste. (name: [name], disposed: [QDELETED(src)], health: [health])")

	switch(caste.caste_type) //This will need to be changed later, when we have proper xeno pathing. Might do it on caste or something.
		if(XENO_CASTE_BOILER)
			var/mob/living/carbon/xenomorph/boiler/src_boiler = src
			visible_message(SPAN_DANGER("[src] begins to bulge grotesquely, and explodes in a cloud of corrosive gas!"))
			src_boiler.smoke.set_up(2, 0, get_turf(src), new_cause_data = src_boiler.smoke.cause_data)
			src_boiler.smoke.start()
			remains.icon_state = "gibbed-a-corpse"
		if(XENO_CASTE_RUNNER)
			remains.icon_state = "gibbed-a-corpse-runner"
		if(XENO_CASTE_LARVA, XENO_CASTE_PREDALIEN_LARVA)
			remains.icon_state = "larva_gib_corpse"
		else
			remains.icon_state = "gibbed-a-corpse"

	check_blood_splash(35, BURN, 65, 2) //Some testing numbers. 35 burn, 65 chance.

	..(cause)

/mob/living/carbon/xenomorph/gib_animation()
	var/to_flick = "gibbed-a"
	var/icon_path
	if(mob_size >= MOB_SIZE_BIG)
		icon_path = 'icons/mob/xenos/xenomorph_64x64.dmi'
	else
		icon_path = 'icons/mob/xenos/xenomorph_48x48.dmi'
	switch(caste.caste_type)
		if(XENO_CASTE_RUNNER)
			to_flick = "gibbed-a-runner"
		if(XENO_CASTE_LARVA, XENO_CASTE_PREDALIEN_LARVA)
			to_flick = "larva_gib"
	new /obj/effect/overlay/temp/gib_animation/xeno(loc, src, to_flick, icon_path)

/mob/living/carbon/xenomorph/spawn_gibs()
	xgibs(get_turf(src))

/mob/living/carbon/xenomorph/dust_animation()
	new /obj/effect/overlay/temp/dust_animation(loc, src, "dust-a")

/mob/living/carbon/xenomorph/revive()
	SEND_SIGNAL(src, COMSIG_XENO_REVIVED)
	..()
