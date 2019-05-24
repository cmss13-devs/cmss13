/obj
	//Used to store information about the contents of the object.
	var/list/matter
	var/health = null
	var/origin_tech = null	//Used by R&D to determine what research bonuses it grants.
	var/reliability = 100	//Used by SOME devices to determine how reliable they are.
	var/crit_fail = 0
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	animate_movement = 2
	var/throwforce = 1
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!

	var/mob/living/buckled_mob
	var/buckle_lying = FALSE //Is the mob buckled in a lying position
	var/can_buckle = FALSE

	var/explosion_resistance = 0
	var/projectile_coverage = 0 //an object's "projectile_coverage" var indicates the maximum probability of blocking a projectile, assuming density and throwpass. Used by barricades, tables and window frames

/obj/New()
	..()
	object_list += src

/obj/Dispose()
	. = ..()
	object_list -= src


/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/proc/process()
	processing_objects.Remove(src)
	return 0


/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.interactee == src))
				is_in_use = 1
				src.attack_hand(M)
		if (ishighersilicon(usr))
			if (!(usr in nearby))
				if (usr.client && usr.interactee==src) // && M.interactee == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.interactee == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/proc/interact(mob/user)
	return

/obj/proc/update_icon()
	return



/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.interactee == src)
		src.attack_self(M)


/obj/proc/alter_health()
	return 1

/obj/proc/hide(h)
	return


/obj/proc/hear_talk(mob/M, text)
	return

/obj/Dispose()
	if(buckled_mob) unbuckle()
	. = ..()

/obj/attack_paw(mob/user)
	if(can_buckle) return src.attack_hand(user)
	else . = ..()

/obj/attack_hand(mob/user)
	if(can_buckle) manual_unbuckle(user)
	else . = ..()

/obj/attack_ai(mob/user)
	if(can_buckle) manual_unbuckle(user)
	else . = ..()

/obj/proc/handle_rotation()
	return

/obj/MouseDrop(atom/over_object)
	if(!can_buckle)
		. = ..()

/obj/MouseDrop_T(mob/M, mob/user)
	if(can_buckle)
		if(!istype(M)) return
		buckle_mob(M, user)
	else . = ..()

/obj/proc/afterbuckle(mob/M as mob) // Called after somebody buckled / unbuckled
	handle_rotation()
	return buckled_mob

/obj/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()

			var/M = buckled_mob
			buckled_mob = null

			afterbuckle(M)


/obj/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					SPAN_NOTICE("[buckled_mob.name] was unbuckled by [user.name]!"),\
					SPAN_NOTICE("You were unbuckled from [src] by [user.name]."),\
					SPAN_NOTICE("You hear metal clanking."))
			else
				buckled_mob.visible_message(\
					SPAN_NOTICE("[buckled_mob.name] unbuckled \himself!"),\
					SPAN_NOTICE("You unbuckle yourself from [src]."),\
					SPAN_NOTICE("You hear metal clanking"))
			unbuckle()
			src.add_fingerprint(user)
			return 1

	return 0


//trying to buckle a mob
/obj/proc/buckle_mob(mob/M, mob/user)
	if ( !ismob(M) || (get_dist(src, user) > 1) || user.is_mob_restrained() || user.lying || user.stat || buckled_mob || M.buckled )
		return

	if (M.mob_size > MOB_SIZE_HUMAN)
		to_chat(user, "<span class='warning'>[M] is too big to buckle in.</span>")
		return
	if (isXeno(user))
		to_chat(user, "<span class='warning'>You don't have the dexterity to do that, try a nest.</span>")
		return
	if (iszombie(user))
		return

	if(density)
		density = 0
		if(!step(M, get_dir(M, src)) && loc != M.loc)
			density = 1
			return
		density = 1
	else
		if(M.loc != src.loc)
			return
	do_buckle(M, user)

// the actual buckling proc
// Yes I know this is not style but its unreadable otherwise
/obj/proc/do_buckle(mob/target, mob/user)
	send_buckling_message(target, user)
	if (src && src.loc)
		target.buckled = src
		target.loc = src.loc
		target.dir = src.dir
		target.update_canmove()
		src.buckled_mob = target
		src.add_fingerprint(user)
		afterbuckle(target)

/obj/proc/send_buckling_message(mob/M, mob/user)
	if (M == user)
		M.visible_message(\
			SPAN_NOTICE("[M] buckles in!"),\
			SPAN_NOTICE("You buckle yourself to [src]."),\
			SPAN_NOTICE("You hear metal clanking."))
	else
		M.visible_message(\
			SPAN_NOTICE("[M] is buckled in to [src] by [user]!"),\
			SPAN_NOTICE("You are buckled in to [src] by [user]."),\
			SPAN_NOTICE("You hear metal clanking"))

/obj/Move(NewLoc, direct)
	. = ..()
	handle_rotation()
	if(. && buckled_mob && !handle_buckled_mob_movement(loc,direct)) //movement fails if buckled mob's move fails.
		. = 0

/obj/proc/handle_buckled_mob_movement(NewLoc, direct)
	if(!(direct & (direct - 1))) //not diagonal move. the obj's diagonal move is split into two cardinal moves and those moves will handle the buckled mob's movement.
		if(!buckled_mob.Move(NewLoc, direct))
			loc = buckled_mob.loc
			last_move_dir = buckled_mob.last_move_dir
			buckled_mob.inertia_dir = last_move_dir
			return 0
	return 1

/obj/CanPass(atom/movable/mover, turf/target)
	if(mover == buckled_mob) //can't collide with the thing you're buckled to
		return TRUE
	. = ..()

/obj/proc/wall_check() //used at roundstart to automatically detect and remove walls that overlap. Called by windows and airlocks
	spawn(10)
		if(ticker.current_state == GAME_STATE_PREGAME)
			var/turf/T = get_turf(src)
			if( istype( T,/turf/closed/wall ) )
				message_admins("Overlap of [src] with [T] detected and fixed in area [T.loc.name] ([T.x],[T.y],[T.z]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)")
				log_game("Overlap of [src] with [T] detected and fixed in area [T.loc.name] ([T.x],[T.y],[T.z])")
				var/turf/closed/wall/W = T
				if(!W.hull)
					W.ChangeTurf(/turf/open/floor/plating, TRUE)

/obj/bullet_act(obj/item/projectile/P)
	//Tasers and the like should not damage objects.
	if(P.ammo.damage_type == HALLOSS || P.ammo.damage_type == TOX || P.ammo.damage_type == CLONE || P.damage == 0)
		return 0
	bullet_ping(P)
	if(P.ammo.damage)
		src.health -= round(P.ammo.damage / 2)
	if(src.health <= 0)
		qdel(src)
	return 1