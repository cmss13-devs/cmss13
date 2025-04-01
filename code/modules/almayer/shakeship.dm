/**
 * Shakes the ship around
 *
 * Shakes the ship around and has the ship
 * make sounds because of it, including
 * warning klaxons it it's a big hit
 * despite being in /almayer, this thing should work in any shipmap.
 * Arguments:
 * * sstrength - How hard the camera shakes, and how hard the rocking on the ship is
 * * stime - For how long the camera shakes
 * * drop - If the shaking can make people fall, or be thrown away if sstrength is above 7
 * * osound - not included in the admin verb! Can be set to FALSE if you don't want it's original sounds to play in case you want something different
 */
/proc/shakeship(sstrength, stime, drop, osound = TRUE)
	for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
		if(!is_mainship_level(current_mob.z))
			continue
		shake_camera(current_mob, stime, sstrength)
		if(drop)
			current_mob.apply_effect(3, WEAKEN)
		if(sstrength <= 2)
			to_chat(current_mob, SPAN_DANGER("The whole deck jumps and the ship rocks!"))
			if(current_mob.client && osound)
				playsound_client(current_mob.client, 'sound/machines/bonk.ogg', 100 )
		if(sstrength > 2 && sstrength <= 7)
			to_chat(current_mob, SPAN_BOLDANNOUNCE("The deck violently shakes and vibrates with the impact!"))
			if(current_mob.client && osound)
				playsound_client(current_mob.client, 'sound/machines/bonk.ogg', 100 )
				playsound_client(current_mob.client, 'sound/effects/meteorimpact.ogg', 100 )
				playsound_client(current_mob.client, 'sound/effects/slam2.ogg', 100 )
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/doorcreaky.ogg', 20), 1 SECONDS)
		if(sstrength > 7)
			if(current_mob.client && osound)
				playsound_client(current_mob.client, 'sound/effects/metal_crash.ogg', 100 )
				playsound_client(current_mob.client, 'sound/effects/bigboom3.ogg', 100)

			if(drop)
				INVOKE_ASYNC(current_mob,  TYPE_PROC_REF(/atom/movable, throw_atom), get_ranged_target_turf(current_mob, pick(GLOB.cardinals), sstrength-5), pick(GLOB.cardinals), sstrength)

			to_chat(current_mob, SPAN_HIGHDANGER("YOU ARE THROWN AROUND VIOLENTLY AND HIT THE DECK WITH FULL FORCE!!"))
			if(current_mob.client && osound)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/pry2.ogg', 20), 1 SECONDS)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/double_klaxon.ogg'), 2 SECONDS)

