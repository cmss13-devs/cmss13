/obj
	//Used to store information about the contents of the object.
	var/list/matter
	var/health = null
	var/reliability = 100	//Used by SOME devices to determine how reliable they are.
	var/crit_fail = 0
	unacidable = FALSE //universal "unacidabliness" var, here so you can use it in any obj.
	animate_movement = 2
	var/throwforce = 1
	var/in_use = FALSE // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!

	var/mob/living/buckled_mob
	var/buckle_lying = FALSE //Is the mob buckled in a lying position
	var/can_buckle = FALSE

	var/projectile_coverage = 0 //an object's "projectile_coverage" var indicates the maximum probability of blocking a projectile, assuming density and throwpass. Used by barricades, tables and window frames
	var/garbage = FALSE //set to true if the item is garbage and should be deleted after awhile
	var/list/req_access = null
	var/list/req_one_access = null
	var/req_access_txt = null
	var/req_one_access_txt = null

/obj/Initialize(mapload, ...)
	. = ..()
	GLOB.object_list += src
	if(garbage)
		add_to_garbage(src)

/obj/Destroy()
	if(buckled_mob)
		unbuckle()
	. = ..()
	remove_from_garbage(src)
	GLOB.object_list -= src


/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/process()
	STOP_PROCESSING(SSobj, src)
	return 0

/obj/proc/set_pixel_location()
	return

/obj/item/proc/get_examine_line()
	if(blood_color)
		. = SPAN_WARNING("[icon2html(src)] [gender==PLURAL?"some":"a"] <font color='[blood_color]'>stained</font> [src]")
	else
		. = "[icon2html(src)] \a [src]"

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.interactee == src))
				is_in_use = 1
				attack_hand(M)
		if (ishighersilicon(usr))
			if (!(usr in nearby))
				if (usr.client && usr.interactee==src) // && M.interactee == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					attack_remote(usr)
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
	for(var/datum/effects/E in effects_list)
		if(E.icon_path && E.obj_icon_state_path)
			overlays += image(E.icon_path, icon_state = E.obj_icon_state_path)
	return



/obj/item/proc/updateSelfDialog()
	var/mob/M = loc
	if(istype(M) && M.client && M.interactee == src)
		attack_self(M)

/obj/proc/update_health(var/damage = 0)
	if(damage)
		health -= damage
	if(health <= 0)
		qdel(src)

/obj/proc/alter_health()
	return 1

/obj/proc/hide(h)
	return


/obj/proc/hear_talk(mob/M, text)
	return

/obj/attack_hand(mob/user)
	if(can_buckle) manual_unbuckle(user)
	else . = ..()

/obj/attack_remote(mob/user)
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
	if(buckled_mob && buckled_mob.buckled == src)
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
			unbuckle(buckled_mob)
			add_fingerprint(user)
			return 1

	return 0


//trying to buckle a mob
/obj/proc/buckle_mob(mob/M, mob/user)
	if (!ismob(M) || (get_dist(src, user) > 1) || user.is_mob_restrained() || user.lying || user.stat || buckled_mob || M.buckled)
		return

	if (isXeno(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do that, try a nest."))
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
	if (M.mob_size <= MOB_SIZE_XENO && M.stat == DEAD && istype(src, /obj/structure/bed/roller))
		do_buckle(M, user)
		return
	if (M.mob_size > MOB_SIZE_HUMAN)
		to_chat(user, SPAN_WARNING("[M] is too big to buckle in."))
		return
	do_buckle(M, user)

// the actual buckling proc
// Yes I know this is not style but its unreadable otherwise
/obj/proc/do_buckle(mob/target, mob/user)
	send_buckling_message(target, user)
	if (src && src.loc)
		target.buckled = src
		target.forceMove(src.loc)
		target.setDir(dir)
		target.update_canmove()
		src.buckled_mob = target
		src.add_fingerprint(user)
		afterbuckle(target)
		if(buckle_lying) // Make sure buckling to beds/nests etc only turns, and doesn't give a random offset
			var/matrix/M = matrix()
			M.Turn(90)
			target.apply_transform(M)
		return TRUE

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
		. = FALSE

/obj/forceMove(atom/dest)
	. = ..()

	// Bring the buckled_mob with us. No Move(), on_move callbacks, or any of this bullshit, we just got teleported
	if(buckled_mob && loc == dest)
		buckled_mob.forceMove(dest)

/obj/proc/handle_buckled_mob_movement(NewLoc, direct)
	if(!buckled_mob.Move(NewLoc, direct))
		forceMove(buckled_mob.loc)
		last_move_dir = buckled_mob.last_move_dir
		buckled_mob.inertia_dir = last_move_dir
		return FALSE

	// Even if the movement is entirely managed by the object, notify the buckled mob that it's moving for its handler.
	//It won't be called otherwise because it's a function of client_move or pulled mob, neither of which accounts for this.
	buckled_mob.on_movement()
	return TRUE

/obj/BlockedPassDirs(atom/movable/mover, target_dir)
	if(mover == buckled_mob) //can't collide with the thing you're buckled to
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/bullet_act(obj/item/projectile/P)
	//Tasers and the like should not damage objects.
	if(P.ammo.damage_type == HALLOSS || P.ammo.damage_type == TOX || P.ammo.damage_type == CLONE || P.damage == 0)
		return 0
	bullet_ping(P)
	if(P.ammo.damage)
		update_health(round(P.ammo.damage / 2))
	return 1

/obj/item/proc/get_mob_overlay(mob/user_mob, slot)
	var/bodytype = "Default"
	var/mob/living/carbon/human/user_human
	if(ishuman(user_mob))
		user_human = user_mob
		bodytype = user_human.species.get_bodytype(user_human)

	var/mob_state = get_icon_state(user_mob, slot)

	var/mob_icon
	var/spritesheet = FALSE
	if(icon_override)
		mob_icon = icon_override
		if(slot == 	WEAR_L_HAND)
			mob_state = "[mob_state]_l"
		if(slot == 	WEAR_R_HAND)
			mob_state = "[mob_state]_r"
	else if(use_spritesheet(bodytype, slot, mob_state))
		spritesheet = TRUE
		mob_icon = sprite_sheets[bodytype]
	else if(item_icons && item_icons[slot])
		mob_icon = item_icons[slot]
	else
		mob_icon = default_onmob_icons[slot]

	if(user_human)
		return user_human.species.get_offset_overlay_image(spritesheet, mob_icon, mob_state, color, slot)
	return overlay_image(mob_icon, mob_state, color, RESET_COLOR)

/obj/item/proc/use_spritesheet(var/bodytype, var/slot, var/icon_state)
	if(!sprite_sheets || !sprite_sheets[bodytype])
		return 0
	if(slot == WEAR_R_HAND || slot == WEAR_L_HAND)
		return 0

	if(icon_state in icon_states(sprite_sheets[bodytype]))
		return 1

	return (slot != WEAR_JACKET && slot != WEAR_HEAD)

// Adding a text string at the end of the object
/obj/proc/add_label(var/obj/O, user)
	var/label = copytext(reject_bad_text(input(user,"Label text?", "Set label", "")), 1, MAX_NAME_LEN)

	// Checks for valid labelling/name length
	if(!label || !length(label))
		to_chat(user, SPAN_NOTICE("Invalid text."))
		return
	if((length(O.name) + length(label)) > MAX_NAME_LEN * 1.5)
		to_chat(user, SPAN_NOTICE("You cannot fit any more labels on this item."))
		return

	O.name += " ([label])"
