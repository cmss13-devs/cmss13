/obj/item/weapon/gun/proc/full_auto_start(var/atom/A, var/params)
	if(!ismob(loc) || !A)
		return
	var/mob/user = loc

	// No FA with mods
	if(params["shift"] || params["ctrl"] || params["alt"])
		return

	// No shooting the 4th wall
	if(istype(A, /obj/screen))
		return

	// No FA on attachables
	if(active_attachable)
		return

	if(user.get_active_hand() != src)
		return

	if(user.throw_mode)
		return

	// Don't open fire on adjacent targets. Let normal attack code handle this
	if(A.Adjacent(user) && user.a_intent != INTENT_HARM)
		return

	if(user.client.prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY && user.a_intent == INTENT_HELP)
		if(world.time % 3) // Limits how often this message pops up, saw this somewhere else and thought it was clever
			to_chat(user, SPAN_NOTICE("You consider shooting at [A], but do not follow through."))
		return

	fa_firing = TRUE
	fa_shots = 0
	fa_target = A
	fa_params = params

	// Ward off spamclickin fellas
	if(world.time < last_fired + fa_delay)
		if(world.time % 3) // Limits how often this message pops up, saw this somewhere else and it's fucking stupid
			to_chat(user, SPAN_WARNING("[src] is not ready to fire again!"))
		return

	// Kick off the full-auto
	repeat_fire(user)

/obj/item/weapon/gun/proc/full_auto_stop(var/atom/A, var/params)
	fa_target = null
	fa_params = null

/obj/item/weapon/gun/proc/full_auto_new_target(var/atom/start, var/atom/hovered, var/params)
	if(!ismob(loc))
		return
	var/mob/user = loc

	if(istype(hovered, /obj/screen))
		return

	if(get_turf(hovered) == get_turf(user))
		return

	fa_target = hovered
	fa_params = params

/obj/item/weapon/gun/proc/repeat_fire(var/mob/user)
	if(!fa_target)
		return

	// fun is ended
	if(active_attachable)
		return

	// fun's over
	if(!in_chamber && !current_mag)
		click_empty(user)
		return

	// fun's also over
	if(!user.canmove || user.stat || user.is_mob_restrained() || !user.loc || !isturf(user.loc))
		return

	// you abandoned the f u n
	if(user.get_active_hand() != src || loc != user)
		return

	if(user.throw_mode)
		return

	user.face_atom(fa_target)
	if(user.gun_mode && !(fa_target in target))
		PreFire(fa_target, user, fa_params)
	else
		Fire(fa_target, user, fa_params)

	add_timer(CALLBACK(src, .proc/repeat_fire, user), fa_delay)

// Make sure we're not trying to start full auto when the gun isn't even held by anyone
/obj/item/weapon/gun/dropped(var/mob/user)
	..()

	if(!user.client)
		return

	unregisterListener(user.client, EVENT_LMBDOWN, "fa_\ref[src]")
	unregisterListener(user.client, EVENT_LMBUP, "fa_\ref[src]")
	unregisterListener(user.client, EVENT_LMBDRAG, "fa_\ref[src]")

// Also make sure it's registered when held in any hand and full-auto is on
/obj/item/weapon/gun/equipped(var/mob/user, var/slot)
	..()

	if(!user.client)
		return

	// If it was equipped to anything but the hands, make sure we're not registered
	if(slot != WEAR_R_HAND && slot != WEAR_L_HAND)
		unregisterListener(user.client, EVENT_LMBDOWN, "fa_\ref[src]")
		unregisterListener(user.client, EVENT_LMBUP, "fa_\ref[src]")
		unregisterListener(user.client, EVENT_LMBDRAG, "fa_\ref[src]")
		return

	if(flags_gun_features & GUN_FULL_AUTO_ON)
		registerListener(user.client, EVENT_LMBDOWN, "fa_\ref[src]", CALLBACK(src, .proc/full_auto_start))
		registerListener(user.client, EVENT_LMBUP, "fa_\ref[src]", CALLBACK(src, .proc/full_auto_stop))
		registerListener(user.client, EVENT_LMBDRAG, "fa_\ref[src]", CALLBACK(src, .proc/full_auto_new_target))
