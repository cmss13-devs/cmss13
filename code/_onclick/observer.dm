/client/var/inquisitive_ghost = 1
/mob/dead/observer/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Ghost"
	if(!client) return
	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		to_chat(src, SPAN_NOTICE(" You will now examine everything you click on."))
	else
		to_chat(src, SPAN_NOTICE(" You will no longer examine things you click on."))

/mob/dead/observer/click(var/atom/A, var/list/mods)
	if(..())
		return 1

	if(mods["ctrl"])
		if(A == src)
			if(!can_reenter_corpse || !mind || !mind.current)
				return
			if(alert(src, "Are you sure you want to re-enter your corpse?", "Confirm", "Yes", "No") == "Yes")
				reenter_corpse()
				return 1

		if(ismob(A) || isVehicle(A))
			if(isXeno(A) && ticker.mode.check_xeno_late_join(src))		//if it's a xeno and all checks are alright, we are gonna try to take their body
				var/mob/living/carbon/Xenomorph/X = A
				if(!X.client)
					if(X.stat == DEAD || is_admin_level(X.z))
						to_chat(src, SPAN_WARNING("You cannot join as [X]."))
						return
					if(!ticker.mode.xeno_bypass_timer)
						var/deathtime = world.time - timeofdeath
						var/deathtimeminutes = round(deathtime / MINUTES_1)
						var/deathtimeseconds = round((deathtime - deathtimeminutes * MINUTES_1) / 10,1)
						if(deathtime < MINUTES_5)
							var/message = "You have been dead for [deathtimeminutes >= 1 ? "[deathtimeminutes] minute\s and " : ""][deathtimeseconds] second\s."
							message = SPAN_WARNING("[message]")
							to_chat(src, message)
							to_chat(src, SPAN_WARNING("You must wait 5 minutes before rejoining the game!"))
							return 0
						if((!isXenoLarva(X) && X.away_timer < XENO_LEAVE_TIMER) || (isXenoLarva(X) && X.away_timer < XENO_LEAVE_TIMER_LARVA))
							var/to_wait = XENO_LEAVE_TIMER - X.away_timer
							if(isXenoLarva(X))
								to_wait = XENO_LEAVE_TIMER_LARVA - X.away_timer
							to_chat(src, SPAN_WARNING("That player hasn't been away long enough. Please wait [to_wait] second\s longer."))
							return 0
					if(alert(src, "Are you sure you want to transfer yourself into [X]?", "Confirm Transfer", "Yes", "No") == "No")
						return 0
					if(X.client || X.stat == DEAD) // Do it again, just in case
						to_chat(src, SPAN_WARNING("That xenomorph can no longer be controlled. Please try another."))
						return 0
					ticker.mode.transfer_xeno(src, X)
					return 1
			ManualFollow(A)
			return 1

		following = null
		loc = get_turf(A)
		return 1

	if(world.time <= next_move)
		return 1

	next_move = world.time + 8
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	if(!mods["shift"])
		A.attack_ghost(src)
	return 1

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/dead/observer/user)
	if(user.client && user.client.inquisitive_ghost)
		examine(user)

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/structure/machinery/teleport/hub/attack_ghost(mob/user as mob)
	var/atom/l = loc
	var/obj/structure/machinery/computer/teleporter/com = locate(/obj/structure/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(com && com.locked)
		user.loc = get_turf(com.locked)

/obj/effect/portal/attack_ghost(mob/user as mob)
	if(target)
		user.loc = get_turf(target)

/obj/structure/ladder/attack_ghost(mob/user as mob)
	if(up && down)
		switch( alert("Go up or down the ladder?", "Ladder", "Up", "Down", "Cancel") )
			if("Up")
				user.loc = get_turf(up)
			if("Down")
				user.loc = get_turf(down)
			if("Cancel")
				return

	else if(up)
		user.loc = get_turf(up)

	else if(down)
		user.loc = get_turf(down)

// -------------------------------------------
// This was supposed to be used by adminghosts
// I think it is a *terrible* idea
// but I'm leaving it here anyway
// commented out, of course.
/*
/atom/proc/attack_admin(mob/user as mob)
	if(!user || !user.client || !user.client.admin_holder)
		return
	attack_hand(user)

*/

/* This allows Observers to click on disconnected Larva and become them, but not all Larva are clickable due to hiding
/mob/living/carbon/Xenomorph/Larva/attack_ghost(mob/user as mob)
	if(!istype(src, /mob/living/carbon/Xenomorph/Larva))
		return

	// if(src.key || src.mind || !src.client.is_afk())
	if(src.client)
		return

	if(!can_mind_transfer) //away_timer is not high enough. Number below should match number in mob.dm.
		to_chat(user, "That player hasn't been away long enough. Please wait [60 - away_timer] more seconds.")
		return

	if (alert(user, "Are you sure you want to transfer yourself into this Alien Larva?", "Confirmation", "Yes", "No") == "Yes")
		src.client = user.client
		return*/
