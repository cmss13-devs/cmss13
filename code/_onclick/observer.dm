/client/var/inquisitive_ghost = 1
/mob/dead/observer/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Ghost.Settings"
	if(!client) return
	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		to_chat(src, SPAN_NOTICE(" You will now examine everything you click on."))
	else
		to_chat(src, SPAN_NOTICE(" You will no longer examine things you click on."))

/mob/dead/observer/click(atom/target, list/mods)
	if(..())
		return TRUE

	if (mods["shift"] && mods["middle"])
		point_to(target)
		return TRUE

	if(mods["ctrl"])
		if(target == src)
			if(!can_reenter_corpse || !mind || !mind.current)
				return
			if(alert(src, "Are you sure you want to re-enter your corpse?", "Confirm", "Yes", "No") == "Yes")
				reenter_corpse()
				return TRUE

		if(ismob(target) || isVehicle(target))
			if(isxeno(target) && SSticker.mode.check_xeno_late_join(src)) //if it's a xeno and all checks are alright, we are gonna try to take their body
				var/mob/living/carbon/xenomorph/xeno = target
				if(xeno.stat == DEAD || should_block_game_interaction(xeno) || xeno.aghosted)
					to_chat(src, SPAN_WARNING("You cannot join as [xeno]."))
					do_observe(xeno)
					return FALSE

				if(!SSticker.mode.xeno_bypass_timer)
					if((!islarva(xeno) && xeno.away_timer < XENO_LEAVE_TIMER) || (islarva(xeno) && xeno.away_timer < XENO_LEAVE_TIMER_LARVA))
						var/to_wait = XENO_LEAVE_TIMER - xeno.away_timer
						if(islarva(xeno))
							to_wait = XENO_LEAVE_TIMER_LARVA - xeno.away_timer
						if(to_wait > 60 SECONDS) // don't spam for clearly non-AFK xenos
							to_chat(src, SPAN_WARNING("That player hasn't been away long enough. Please wait [to_wait] second\s longer."))
						do_observe(target)
						return FALSE

					var/deathtime = world.time - timeofdeath
					if(deathtime < GLOB.xeno_join_dead_larva_time)
						var/message = "You have been dead for [DisplayTimeText(deathtime)]."
						message = SPAN_WARNING("[message]")
						to_chat(src, message)
						to_chat(src, SPAN_WARNING("You must wait at least 2.5 minutes before rejoining the game!"))
						do_observe(target)
						return FALSE

				if(xeno.hive)
					for(var/mob_name in xeno.hive.banished_ckeys)
						if(xeno.hive.banished_ckeys[mob_name] == ckey)
							to_chat(src, SPAN_WARNING("You are banished from the [xeno.hive], you may not rejoin unless the Queen re-admits you or dies."))
							do_observe(target)
							return FALSE

				if(alert(src, "Are you sure you want to transfer yourself into [xeno]?", "Confirm Transfer", "Yes", "No") != "Yes")
					return FALSE
				if(((!islarva(xeno) && xeno.away_timer < XENO_LEAVE_TIMER) || (islarva(xeno) && xeno.away_timer < XENO_LEAVE_TIMER_LARVA)) || xeno.stat == DEAD) // Do it again, just in case
					to_chat(src, SPAN_WARNING("That xenomorph can no longer be controlled. Please try another."))
					return FALSE
				SSticker.mode.transfer_xeno(src, xeno)
				return TRUE
			do_observe(target)
			return TRUE

		if(!istype(target, /atom/movable/screen))
			following = null
			abstract_move(get_turf(target))
			return TRUE

	if(world.time <= next_move)
		return TRUE

	next_move = world.time + 8
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	if(!mods["shift"])
		target.attack_ghost(src)
	return FALSE

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
		user.forceMove(get_turf(com.locked))

/obj/effect/portal/attack_ghost(mob/user as mob)
	if(target)
		user.forceMove(get_turf(target))

/obj/structure/ladder/attack_ghost(mob/user as mob)
	if(up && down)
		switch( alert("Go up or down the ladder?", "Ladder", "Up", "Down", "Cancel") )
			if("Up")
				user.forceMove(get_turf(up))
			if("Down")
				user.forceMove(get_turf(down))
			if("Cancel")
				return

	else if(up)
		user.forceMove(get_turf(up))

	else if(down)
		user.forceMove(get_turf(down))

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
/mob/living/carbon/xenomorph/larva/attack_ghost(mob/user as mob)
	if(!istype(src, /mob/living/carbon/xenomorph/larva))
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
