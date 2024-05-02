/datum/game_mode
	var/population_min = null
	var/population_max = null

	var/planet_nuked = NUKE_NONE

/datum/game_mode/proc/on_nuclear_diffuse(obj/structure/machinery/nuclearbomb/bomb, mob/living/carbon/xenomorph/xenomorph)
	return FALSE

/datum/game_mode/proc/on_nuclear_explosion(datum/source, list/z_levels = SSmapping.levels_by_trait(ZTRAIT_GROUND))
	planet_nuked = NUKE_INPROGRESS
	marine_announcement("DANGER. DANGER. Planetary Nuke Activated. DANGER. DANGER. Activation in progress. DANGER. DANGER.", "Priority Alert", sound('sound/effects/explosionfar.ogg', 'sound/theme/nuclear_detonation1.ogg','sound/theme/nuclear_detonation2.ogg'), "Everyone (-Yautja)")
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/game_mode, play_cinematic), z_levels, list("intro_planet", "intro_planet", "planet_nuke", "planet_end"), create_cause_data("взрыва ядерной боеголовки", source))
	addtimer(VARSET_CALLBACK(src, planet_nuked, NUKE_COMPLETED), 5 SECONDS)

/datum/game_mode/proc/play_cinematic(list/z_levels = SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP), cinematic_icons = list("intro_ship", "intro_nuke", "ship_spared", "summary_spared"), datum/cause_data/cause_data, explosion_sound = list('sound/effects/explosionfar.ogg'))
	var/L1[] = new //Everyone who will be destroyed on the zlevel(s).
	var/L2[] = new //Everyone who only needs to see the cinematic.
	var/mob/mob
	var/turf/T
	var/atom/movable/screen/cinematic/explosion/cinematic = new
	cinematic.icon_state = cinematic_icons[1]
	world << sound('sound/effects/explosionfar.ogg')
	for(mob in GLOB.player_list) //This only does something cool for the people about to die, but should prove pretty interesting.
		if(!mob || !mob.loc || !mob.client)
			continue //In case something changes when we sleep().
		if(mob.stat == DEAD)
			L2 |= mob
			mob << sound(pick(explosion_sound))
			mob.client.screen |= cinematic
		else if(mob.z in z_levels)
			L1 |= mob
			mob << sound(pick(explosion_sound))
			mob.client.screen |= cinematic
			shake_camera(mob, 110, 2)

	sleep(1.5 SECONDS)
	flick(cinematic_icons[2], cinematic)
	sleep(3.5 SECONDS)
	for(mob in L1)
		if(mob && mob.loc) //Who knows, maybe they escaped, or don't exist anymore.
			T = get_turf(mob)
			if(T.z in z_levels)
				mob.death(cause_data)
			else
				mob.client.screen -= cinematic //those who managed to escape the z level at last second shouldn't have their view obstructed.

	flick(cinematic_icons[3], cinematic)
	cinematic.icon_state = cinematic_icons[4]

	sleep(2 SECONDS)
	for(mob in L1 + L2)
		if(mob && mob.client)
			mob.client.screen -= cinematic //They may have disconnected in the mean time.
	qdel(cinematic)
