//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(var/cause = "gibbing")
	death(cause, 1)
	gib_animation()
	if (map_tag != MAP_WHISKEY_OUTPOST)
		spawn_gibs()

	// You're not coming back from being gibbed. Stop tracking here
	SSround_recording.recorder.stop_tracking(src)

	qdel(src)


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

/mob/proc/death(var/cause, var/gibbed = 0, var/deathmessage = "seizes up and falls limp...")
	if(stat == DEAD)
		return 0

	if(!gibbed)
		visible_message("<b>\The [src.name]</b> [deathmessage]")

	stat = DEAD

	update_canmove()

	dizziness = 0
	jitteriness = 0

	if(client)
		client.change_view(world_view_size) //just so we never get stuck with a large view somehow

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
	living_mob_list -= src
	dead_mob_list |= src

	track_death_calculations()
	track_mob_death(cause, last_damage_mob)

	if(isXeno(last_damage_mob))
		var/mob/living/carbon/Xenomorph/X = last_damage_mob
		X.behavior_delegate.on_kill_mob(src)

	med_hud_set_health()
	med_hud_set_armor()
	med_hud_set_status()

	update_icons()
	return 1
