//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(var/cause = "gibbing")
	gibbing = TRUE
	death(istype(cause, /datum/cause_data) ? cause : create_cause_data(cause), TRUE)
	gib_animation()
	if (!SSticker?.mode?.hardcore)
		spawn_gibs()

	// You're not coming back from being gibbed. Stop tracking here
	SSround_recording.recorder.stop_tracking(src)

	qdel(src)

/mob/proc/async_gib(var/cause)
	gibbing = TRUE
	INVOKE_ASYNC(src, .proc/gib, cause)


/mob/proc/gib_animation()
	return

/mob/proc/spawn_gibs()
	hgibs(loc, viruses, src)





//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust(var/cause = "dusting")
	death(cause, 1)
	dust_animation()
	spawn_dust_remains()
	qdel(src)


/mob/proc/spawn_dust_remains()
	new /obj/effect/decal/cleanable/ash(loc)

/mob/proc/dust_animation()
	return

/mob/proc/death(var/datum/cause_data/cause_data, var/gibbed = 0, var/deathmessage = "seizes up and falls limp...")
	if(stat == DEAD)
		return 0

	if(!gibbed)
		visible_message("<b>\The [src.name]</b> [deathmessage]")

	if(cause_data && !istype(cause_data))
		stack_trace("death called with string cause ([cause_data]) instead of datum")
		cause_data = create_cause_data(cause_data)

	stat = DEAD

	update_canmove()

	dizziness = 0
	jitteriness = 0

	if(client)
		client.change_view(world_view_size) //just so we never get stuck with a large view somehow

	if(s_active) //Close inventory screens.
		s_active.storage_close(src)

	hide_fullscreens()

	update_sight()

	drop_r_hand()
	drop_l_hand()

	if(hud_used && hud_used.healths)
		hud_used.healths.icon_state = "health7"

	if(hud_used && hud_used.pulse_line)
		hud_used.pulse_line.icon_state = "pulse_dead"

	timeofdeath = world.time
	life_time_total = world.time - life_time_start
	if(mind) mind.store_memory("Time of death: [worldtime2text()]", 0)
	GLOB.alive_mob_list -= src
	GLOB.dead_mob_list += src

	if(client && client.player_data)
		record_playtime(client.player_data, job, type)

	track_death_calculations()

	INVOKE_ASYNC(src, .proc/handle_death_cause, cause_data, get_turf(src))

	med_hud_set_health()
	med_hud_set_armor()
	med_hud_set_status()

	update_icons()
	SEND_SIGNAL(src, COMSIG_MOB_DEATH)
	return 1

/mob/proc/handle_death_cause(var/datum/cause_data/cause_data, var/turf/death_loc)
	track_mob_death(cause_data, death_loc)
	if(cause_data && istype(cause_data))
		var/obj/O = cause_data.resolve_cause()
		if(isdefenses(O))
			var/obj/structure/machinery/defenses/TR = O
			TR.earn_kill()
		var/mob/cause_mob = cause_data.resolve_mob()
		if(cause_mob)
			if(isYautja(cause_mob) && cause_mob.client && cause_mob != src)
				INVOKE_ASYNC(cause_mob.client, /client.proc/add_honor, max(life_kills_total, default_honor_value))

			if(isXeno(cause_mob))
				var/mob/living/carbon/Xenomorph/X = cause_mob
				X.behavior_delegate.on_kill_mob(src)
