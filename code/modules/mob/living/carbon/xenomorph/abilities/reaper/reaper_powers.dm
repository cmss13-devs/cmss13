/datum/action/xeno_action/activable/blockade/use_ability(atom/A) // blockade, this abiltiy should always either last a short time or the walls should be destructible in 1-3 hits.
	var/mob/living/carbon/xenomorph/queen/reaper = owner
	if(!reaper.check_state())
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if(reaper.action_busy)
		return FALSE

	var/width = initial(pillar_type.width)
	var/height = initial(pillar_type.height)

	var/turf/T = get_turf(A)
	if((locate (/obj/effect/alien/weeds/node/pylon/core) in T)) //core has resin node in it, wall ontop of resin node deletes it, wall ontop of hive core delets all hive weeds if put ontop of it.
		return FALSE
	if(T.density)
		to_chat(reaper, SPAN_XENOWARNING("We can only construct this blockade in open areas!"))
		return FALSE

	if(T.z != owner.z)
		to_chat(reaper, SPAN_XENOWARNING("That's too far away!"))
		return FALSE

	if(!T.weeds)
		to_chat(reaper, SPAN_XENOWARNING("We can only construct this blockade on weeds!"))
		return FALSE

	if(!reaper.check_plasma(plasma_cost))
		return


	if(!check_turf(reaper, T))
		return FALSE

	if(!check_and_use_plasma_owner())
		return

	var/turf/new_turf = locate(max(T.x - Floor(width/2), 1), max(T.y - Floor(height/2), 1), T.z)
	to_chat(reaper, SPAN_XENONOTICE("We raise a blockade!"))
	var/obj/effect/alien/resin/resin_pillar/RP = new pillar_type(new_turf)
	RP.start_decay(brittle_time, decay_time)
	apply_cooldown()
	return ..()



/datum/action/xeno_action/activable/blockade/proc/check_turf(mob/living/carbon/xenomorph/queen/reaper, turf/T)
	if(T.density)
		to_chat(reaper, SPAN_XENOWARNING("We can't place a blockade here."))
		return FALSE

	return TRUE




/datum/action/xeno_action/activable/weed_nade/use_ability(atom/A) // weed nade
	var/mob/living/carbon/xenomorph/reaper_spit = owner
	if (!reaper_spit.check_state() || reaper_spit.action_busy)
		return
	if (!action_cooldown_check())
		return
	if (!check_and_use_plasma_owner())
		return

	var/turf/current_turf = get_turf(reaper_spit)

	if (!current_turf)
		return

	if (!do_after(reaper_spit, explode_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(reaper_spit, SPAN_XENODANGER("We stop preparing a resin node in our glands."))
		return

	apply_cooldown()
	to_chat(reaper_spit, SPAN_XENOWARNING("We throw a resin node through the air."))

	var/obj/item/explosive/grenade/xeno_weed_grenade/reaper_grenade = new /obj/item/explosive/grenade/xeno_weed_grenade
	reaper_grenade.cause_data = create_cause_data(initial(reaper_spit.caste_type), reaper_spit)
	reaper_grenade.forceMove(get_turf(reaper_spit))
	reaper_grenade.throw_atom(A, 5, SPEED_SLOW, reaper_spit, TRUE)
	addtimer(CALLBACK(reaper_grenade, TYPE_PROC_REF(/obj/item/explosive, prime)), priming_delay)










