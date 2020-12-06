#define DELETE_TIME	1800

/mob/living/carbon/Xenomorph/death(var/cause, var/gibbed)
	var/msg = "lets out a waning guttural screech, green blood bubbling from its maw."
	. = ..(cause, gibbed, msg)
	if(!.)
		return //If they're already dead, it will return.

	GLOB.living_xeno_list -= src

	if(is_zoomed)
		zoom_out()

	if(map_tag == MAP_WHISKEY_OUTPOST)
		ghostize()

	SetLuminosity(0)

	if(pulledby)
		pulledby.stop_pulling()

	if(!gibbed)
		if(hud_used && hud_used.healths)
			hud_used.healths.icon_state = "health_dead"
		if(hud_used && hud_used.alien_plasma_display)
			hud_used.alien_plasma_display.icon_state = "power_display_empty"
		update_icons()

	if(!is_admin_level(z)) //so xeno players don't get death messages from admin tests
		if(isXenoQueen(src))
			var/mob/living/carbon/Xenomorph/Queen/XQ = src
			playsound(loc, 'sound/voice/alien_queen_died.ogg', 75, 0)
			if(XQ.observed_xeno)
				XQ.overwatch(XQ.observed_xeno, TRUE)
			if(XQ.ovipositor)
				XQ.dismount_ovipositor(TRUE)

			if(hive_datum[hivenumber].stored_larva)
				hive_datum[hivenumber].stored_larva = round(hive_datum[hivenumber].stored_larva * 0.5) //Lose half on dead queen
				var/turf/larva_spawn
				var/list/players_with_xeno_pref = get_alien_candidates()
				while(hive_datum[hivenumber].stored_larva > 0 && istype(hive_datum[hivenumber].spawn_pool, /obj/effect/alien/resin/special/pool)) // stil some left
					larva_spawn = get_turf(hive_datum[hivenumber].spawn_pool)
					if(players_with_xeno_pref && players_with_xeno_pref.len)
						var/mob/xeno_candidate = pick(players_with_xeno_pref)
						var/mob/living/carbon/Xenomorph/Larva/new_xeno = new /mob/living/carbon/Xenomorph/Larva(larva_spawn)
						new_xeno.set_hive_and_update(hivenumber)

						new_xeno.generate_name()
						if(!ticker.mode.transfer_xeno(xeno_candidate, new_xeno))
							qdel(new_xeno)
							return
						new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly burrows out of the ground!"),
						SPAN_XENODANGER("You burrow out of the ground after feeling an immense tremor through the hive, which quickly fades into complete silence..."))

					hive_datum[hivenumber].stored_larva--
					hive_datum[hivenumber].hive_ui.update_pooled_larva()

			if(hive && hive.living_xeno_queen == src)
				xeno_message(SPAN_XENOANNOUNCE("A sudden tremor ripples through the hive... the Queen has been slain! Vengeance!"),3, hivenumber)
				hive.slashing_allowed = XENO_SLASH_ALLOWED
				hive.set_living_xeno_queen(null)
				//on the off chance there was somehow two queen alive
				for(var/mob/living/carbon/Xenomorph/Queen/Q in GLOB.living_xeno_list)
					if(!QDELETED(Q) && Q != src && Q.hivenumber == hivenumber)
						hive.set_living_xeno_queen(Q)
						break
				hive.handle_xeno_leader_pheromones()
				if(ticker && ticker.mode)
					ticker.mode.check_queen_status(hive.queen_time, hivenumber)
					LAZYADD(ticker.mode.dead_queens, "<br>[!isnull(src.key) ? src.key : "?"] was [src] [SPAN_BOLDNOTICE("(DIED)")]")

		else
			playsound(loc, prob(50) == 1 ? 'sound/voice/alien_death.ogg' : 'sound/voice/alien_death2.ogg', 25, 1)
		var/area/A = get_area(src)
		if(hive && hive.living_xeno_queen)
			xeno_message("Hive: [src] has <b>died</b>[A? " at [sanitize(A.name)]":""]! [banished ? "They were banished from the hive." : ""]", 3, hivenumber)

	if(hive && IS_XENO_LEADER(src))	//Strip them from the Xeno leader list, if they are indexed in here
		hive.remove_hive_leader(src)
		if(hive.living_xeno_queen)
			to_chat(hive.living_xeno_queen, SPAN_XENONOTICE("A leader has fallen!")) //alert queens so they can choose another leader

	hud_update() //updates the overwatch hud to remove the upgrade chevrons, gold star, etc

	for(var/atom/movable/A in stomach_contents)
		stomach_contents.Remove(A)
		A.acid_damage = 0 //Reset the acid damage
		A.forceMove(loc)

	// Banished xeno provide a pooled larva on death to compensate
	if(banished)
		hive_datum[hivenumber].stored_larva++
		hive_datum[hivenumber].hive_ui.update_pooled_larva()

	if(hive)
		hive.remove_xeno(src)
		// Finding the last xeno for anti-delay.
		if(LAZYLEN(hive.totalXenos) == 1)
			var/mob/living/carbon/Xenomorph/X = LAZYACCESS(hive.totalXenos, 1)
			// Tell the marines where the last one is.
			var/name = "[MAIN_AI_SYSTEM] Bioscan Status"
			var/input = "Bioscan complete.\n\nSensors indicate one remaining unknown lifeform signature in [get_area(X)]."
			marine_announcement(input, name, 'sound/AI/bioscan.ogg')
			// Tell the xeno she is the last one.
			if(X.client)
				to_chat(X, SPAN_XENOANNOUNCE("Your carapace rattles with dread. You are all that remains of the hive!"))

	if(hardcore)
		QDEL_IN(src, 3 SECONDS)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_XENO_DEATH, src, gibbed)

/mob/living/carbon/Xenomorph/gib(var/cause = "gibbing")
	var/obj/effect/decal/remains/xeno/remains = new(get_turf(src))
	remains.icon = icon
	remains.pixel_x = pixel_x //For 2x2.

	if(!caste)
		CRASH("CASTE ERROR: gib() was called without a caste. (name: [name], disposed: [QDELETED(src)], health: [health])")

	switch(caste.caste_name) //This will need to be changed later, when we have proper xeno pathing. Might do it on caste or something.
		if("Boiler")
			var/mob/living/carbon/Xenomorph/Boiler/B = src
			visible_message(SPAN_DANGER("[src] begins to bulge grotesquely, and explodes in a cloud of corrosive gas!"))
			B.smoke.set_up(2, 0, get_turf(src))
			B.smoke.start()
			remains.icon_state = "gibbed-a-corpse"
		if("Runner")
			remains.icon_state = "gibbed-a-corpse-runner"
		if("Bloody Larva","Predalien Larva")
			remains.icon_state = "larva_gib_corpse"
		else
			remains.icon_state = "gibbed-a-corpse"

	check_blood_splash(35, BURN, 65, 2) //Some testing numbers. 35 burn, 65 chance.

	..(cause)

/mob/living/carbon/Xenomorph/gib_animation()
	var/to_flick = "gibbed-a"
	var/icon_path = get_icon_from_source(CONFIG_GET(string/alien_gib_48x48))
	if(mob_size >= MOB_SIZE_BIG)
		icon_path = get_icon_from_source(CONFIG_GET(string/alien_gib_64x64))
	switch(caste.caste_name)
		if("Runner")
			to_flick = "gibbed-a-runner"
		if("Bloody Larva","Predalien Larva")
			to_flick = "larva_gib"
	new /obj/effect/overlay/temp/gib_animation/xeno(loc, src, to_flick, icon_path)

/mob/living/carbon/Xenomorph/spawn_gibs()
	xgibs(get_turf(src))

/mob/living/carbon/Xenomorph/dust_animation()
	new /obj/effect/overlay/temp/dust_animation(loc, src, "dust-a")
