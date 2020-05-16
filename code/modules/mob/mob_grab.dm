#define UPGRADE_COOLDOWN	40

/obj/item/grab
	name = "grab"
	icon_state = "reinforce"
	icon = 'icons/mob/hud/screen1.dmi'
	flags_atom = NO_FLAGS
	flags_item = NOBLUDGEON|DELONDROP|ITEM_ABSTRACT
	layer = ABOVE_HUD_LAYER
	item_state = "nothing"
	w_class = SIZE_HUGE
	var/atom/movable/grabbed_thing
	var/last_upgrade = 0 //used for cooldown between grab upgrades.


/obj/item/grab/New()
	..()
	last_upgrade = world.time

/obj/item/grab/dropped(mob/user)
	user.stop_pulling()
	. = ..()

/obj/item/grab/Dispose()
	grabbed_thing = null
	if(ismob(loc))
		var/mob/M = loc
		M.grab_level = 0
		M.stop_pulling()
	. = ..()

/obj/item/grab/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!user)
		return
	if(user.pulling == user.buckled) return //can't move the thing you're sitting on.
	if(istype(target, /obj/effect))//if you click a blood splatter with a grab instead of the turf,
		target = get_turf(target)	//we still try to move the grabbed thing to the turf.
	if(isturf(target))
		var/turf/T = target
		if(!T.density && T.Adjacent(user))
			step(user.pulling, get_dir(user.pulling.loc, T))
			var/mob/living/pmob = user.pulling
			if(istype(pmob))
				pmob.on_movement()


/obj/item/grab/attack_self(mob/user)
	if(!ismob(grabbed_thing) || world.time < (last_upgrade + UPGRADE_COOLDOWN))
		return

	if(!ishuman(user)) //only humans can reinforce a grab.
		if (isXeno(user))
			var/mob/living/carbon/Xenomorph/X = user
			X.pull_power(grabbed_thing)
		return
	var/mob/victim = grabbed_thing
	if(victim.mob_size > MOB_SIZE_HUMAN || !(victim.status_flags & CANPUSH))
		return //can't tighten your grip on big mobs and mobs you can't push.
	last_upgrade = world.time
	if(user.grab_level <= GRAB_KILL)
		user.grab_level++
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
		switch(user.grab_level)
			if(GRAB_KILL)
				icon_state = "disarm/kill1"
				user.visible_message(SPAN_DANGER("[user] has tightened \his grip on [victim]'s neck!"), null, null, 5)
				victim.last_damage_source = initial(user.name)
				victim.last_damage_mob = user
				victim.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been strangled (kill intent) by [key_name(user)]</font>"
				user.attack_log += "\[[time_stamp()]\] <font color='red'>Strangled (kill intent) [key_name(victim)]</font>"
				msg_admin_attack("[key_name(user)] strangled (kill intent) [key_name(victim)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			if(GRAB_NECK)
				icon_state = "disarm/kill"
				user.visible_message(SPAN_WARNING("[user] has reinforced \his grip on [victim] (now neck)!"), null, null, 5)
				victim.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their neck grabbed by [key_name(user)]</font>"
				user.attack_log += "\[[time_stamp()]\] <font color='red'>Grabbed the neck of [key_name(victim)]</font>"
				msg_admin_attack("[key_name(user)] grabbed the neck of [key_name(victim)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			if(GRAB_AGGRESSIVE)
				user.visible_message(SPAN_WARNING("[user] has grabbed [victim] aggressively (now hands)!"), null, null, 5)
		victim.update_canmove()

/obj/item/grab/attack(mob/living/M, mob/living/user, def_zone)
	if(M == user && user.pulling && isXeno(user))
		var/mob/living/carbon/Xenomorph/X = user
		var/mob/living/carbon/pulled = X.pulling
		if(!istype(pulled))
			return
		if(isXeno(pulled) || isSynth(pulled))
			to_chat(X, SPAN_WARNING("That wouldn't taste very good."))
			return 0
		if(pulled.buckled)
			to_chat(X, SPAN_WARNING("[pulled] is buckled to something."))
			return 0
		if(pulled.stat == DEAD)
			to_chat(X, SPAN_WARNING("Ew, [pulled] is already starting to rot."))
			return 0
		if(X.stomach_contents.len) //Only one thing in the stomach at a time, please
			to_chat(X, SPAN_WARNING("You already have something in your belly, there's no way that will fit."))
			return 0
			/* Saving this in case we want to allow devouring of dead bodies UNLESS their client is still online somewhere
			if(pulled.client) //The client is still inside the body
			else // The client is observing
				for(var/mob/dead/observer/G in player_list)
					if(ckey(G.mind.original.ckey) == pulled.ckey)
						to_chat(src, "You start to devour [pulled] but realize \he is already dead.")
						return */
		if(user.action_busy)
			to_chat(X, SPAN_WARNING("You are already busy with something."))
			return
		X.visible_message(SPAN_DANGER("[X] starts to devour [pulled]!"), \
		SPAN_DANGER("You start to devour [pulled]!"), null, 5)
		if(do_after(X, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			if(isXeno(pulled.loc) && !X.stomach_contents.len)
				to_chat(X, SPAN_WARNING("Someone already ate \the [pulled]."))
				return 0
			if(X.pulling == pulled && !pulled.buckled && pulled.stat != DEAD && !X.stomach_contents.len) //make sure you've still got them in your claws, and alive
				X.visible_message(SPAN_WARNING("[X] devours [pulled]!"), \
					SPAN_WARNING("You devour [pulled]!"), null, 5)
				
				//IMPORTANT CODER NOTE: Due to us using the old lighting engine, we need to hacky hack hard to get this working properly
				//So we're just going to get the lights out of here by forceMoving them to a far-away place
				//They will be recovered when regurgitating, since this also calls forceMove
				pulled.x = 1
				pulled.y = 1
				pulled.z = 2 //Centcomm
				pulled.forceMove(pulled.loc)

				//Then, we place the mob where it ought to be
				X.stomach_contents.Add(pulled)
				X.devour_timer = world.time + 500 + rand(0,200) // 50-70 seconds
				pulled.forceMove(X)
				return 1
		if(!(pulled in X.stomach_contents))
			to_chat(X, SPAN_WARNING("You stop devouring \the [pulled]. \He probably tasted gross anyways."))
		return 0
