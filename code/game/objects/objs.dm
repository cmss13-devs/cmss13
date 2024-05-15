/obj
	/// Used to store information about the contents of the object.
	var/list/matter
	/// determines whether or not the object can be destroyed by an explosion
	var/indestructible = FALSE
	var/health = null
	/// Used by SOME devices to determine how reliable they are.
	var/reliability = 100
	var/crit_fail = 0
	/// universal "unacidabliness" var, here so you can use it in any obj.
	unacidable = FALSE
	animate_movement = 2
	var/throwforce = 1
	/// If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/in_use = FALSE
	var/mob/living/buckled_mob
	/// Bed-like behaviour, forces mob.lying = buckle_lying if not set to [NO_BUCKLE_LYING].
	var/buckle_lying = NO_BUCKLE_LYING
	var/can_buckle = FALSE
	/**Applied to surgery times for mobs buckled prone to it or lying on the same tile, if the surgery
	cares about surface conditions. The lowest multiplier of objects on the tile is used.**/
	var/surgery_duration_multiplier = SURGERY_SURFACE_MULT_AWFUL

	/// an object's "projectile_coverage" var indicates the maximum probability of blocking a projectile, assuming density and throwpass. Used by barricades, tables and window frames
	var/projectile_coverage = 0
	/// set to true if the item is garbage and should be deleted after awhile
	var/garbage = FALSE

	var/list/req_access = null
	var/list/req_one_access = null
	var/req_access_txt = null
	var/req_one_access_txt = null
	///Whether or not this instance is using accesses different from initial code. Used for easy locating in map files.
	var/access_modified = FALSE

	var/flags_obj = NO_FLAGS
	/// set when a player uses a pen on a renamable object
	var/renamedByPlayer = FALSE


/obj/Initialize(mapload, ...)
	. = ..()
	if(garbage)
		add_to_garbage(src)

/obj/Destroy(force)
	if(buckled_mob)
		unbuckle()
	. = ..()
	remove_from_garbage(src)

/obj/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_EXPLODE, "Trigger Explosion")
	VV_DROPDOWN_OPTION(VV_HK_EMPULSE, "Trigger EM Pulse")
	VV_DROPDOWN_OPTION(VV_HK_SETMATRIX, "Set Base Matrix")
	VV_DROPDOWN_OPTION("", "-----OBJECT-----")
	VV_DROPDOWN_OPTION(VV_HK_MASS_DEL_TYPE, "Delete all of type")

/obj/vv_do_topic(list/href_list)
	. = ..()

	if(href_list[VV_HK_SETMATRIX])
		if(!check_rights(R_DEBUG|R_ADMIN|R_VAREDIT))
			return

		if(!LAZYLEN(usr.client.stored_matrices))
			to_chat(usr, "You don't have any matrices stored!")
			return

		var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (usr.client.stored_matrices + "Revert to Default" + "Cancel"))
		if(!matrix_name || matrix_name == "Cancel")
			return
		else if (matrix_name == "Revert to Default")
			base_transform = null
			transform = matrix()
			disable_pixel_scaling()
			return

		var/matrix/MX = LAZYACCESS(usr.client.stored_matrices, matrix_name)
		if(!MX)
			return

		base_transform = MX
		transform = MX

		if (alert(usr, "Would you like to enable pixel scaling?", "Confirm", "Yes", "No") == "Yes")
			enable_pixel_scaling()


// object is being physically reduced into parts
/obj/proc/deconstruct(disassembled = TRUE)
	density = FALSE
	qdel(src)

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/process()
	STOP_PROCESSING(SSobj, src)
	return 0

/obj/proc/set_pixel_location()
	return

/obj/item/proc/get_examine_line(mob/user)
	if(blood_color)
		. = SPAN_WARNING("[icon2html(src, user)] [gender==PLURAL?"some":"a"] <font color='[blood_color]'>stained</font> [src.name]")
	else
		. = "[icon2html(src, user)] \a [src]"

/obj/item/proc/get_examine_location(mob/living/carbon/human/wearer, mob/examiner, slot, t_He = "They", t_his = "their", t_him = "them", t_has = "have", t_is = "are")
	switch(slot)
		if(WEAR_HEAD)
			return "on [t_his] head"
		if(WEAR_L_EAR)
			return "on [t_his] left ear"
		if(WEAR_R_EAR)
			return "on [t_his] right ear"
		if(WEAR_EYES)
			return "covering [t_his] eyes"
		if(WEAR_FACE)
			return "on [t_his] face"
		if(WEAR_BODY)
			return "wearing [get_examine_line(examiner)]"
		if(WEAR_JACKET)
			return "wearing [get_examine_line(examiner)]"
		if(WEAR_WAIST)
			return "about [t_his] waist"
		if(WEAR_ID)
			return "wearing [get_examine_line(examiner)]"
		if(WEAR_BACK)
			return "on [t_his] back"
		if(WEAR_J_STORE)
			return "[wearer.wear_suit ? "on [t_his] [wearer.wear_suit.name]" : "around [t_his] back"]"
		if(WEAR_HANDS)
			return "on [t_his] hands"
		if(WEAR_L_HAND)
			return "in [t_his] left hand"
		if(WEAR_R_HAND)
			return "in [t_his] right hand"
		if(WEAR_FEET)
			return "on [t_his] feet"
	return "...somewhere?"

/obj/proc/updateUsrDialog(mob/user)
	if(!user)
		user = usr
	if(!in_use || !user)
		return

	var/is_in_use = FALSE
	var/list/nearby = viewers(1, src)
	for(var/mob/cur_mob in nearby)
		if(cur_mob.client && cur_mob.interactee == src)
			is_in_use = TRUE
			attack_hand(cur_mob)
	if(isSilicon(user))
		if(!(user in nearby))
			if(user.client && user.interactee == src) // && M.interactee == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
				is_in_use = TRUE
				attack_remote(user)

	in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(!in_use)
		return

	var/is_in_use = FALSE
	var/list/nearby = viewers(1, src)
	for(var/mob/cur_mob in nearby)
		if(cur_mob.client && cur_mob.interactee == src)
			is_in_use = TRUE
			interact(cur_mob)

	in_use = is_in_use

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

/obj/proc/update_health(damage = 0)
	if(damage)
		health -= damage
	if(health <= 0)
		qdel(src)

/obj/proc/alter_health()
	return 1

/obj/proc/hide(h)
	return


/obj/proc/hear_talk(mob/living/M as mob, msg, verb="says", datum/language/speaking, italics = 0)
	return

/obj/proc/see_emote(mob/living/M as mob, emote, audible = FALSE)
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
	handle_rotation() // To be removed when we have full dir support in set_buckled
	SEND_SIGNAL(src, COMSIG_OBJ_AFTER_BUCKLE, buckled_mob)
	if(!buckled_mob)
		UnregisterSignal(M, COMSIG_PARENT_QDELETING)
	else
		RegisterSignal(buckled_mob, COMSIG_PARENT_QDELETING, PROC_REF(unbuckle))
	return buckled_mob

/obj/proc/unbuckle()
	SIGNAL_HANDLER
	if(buckled_mob && buckled_mob.buckled == src)
		buckled_mob.clear_alert(ALERT_BUCKLED)
		buckled_mob.set_buckled(null)
		buckled_mob.anchored = initial(buckled_mob.anchored)

		var/M = buckled_mob
		REMOVE_TRAITS_IN(buckled_mob, TRAIT_SOURCE_BUCKLE)
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
	if (!ismob(M) || (get_dist(src, user) > 1) || user.is_mob_restrained() || user.stat || buckled_mob || M.buckled || !isturf(user.loc))
		return

	if (isxeno(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do that, try a nest."))
		return
	if (iszombie(user))
		return

	// mobs that become immobilized should not be able to buckle themselves.
	if(M == user && HAS_TRAIT(user, TRAIT_IMMOBILIZED))
		to_chat(user, SPAN_WARNING("You are unable to do this in your current state."))
		return

	if(density)
		density = FALSE
		if(!step(M, get_dir(M, src)) && loc != M.loc)
			density = TRUE
			return
		density = TRUE
	else
		if(M.loc != src.loc)
			step_towards(M, src) //buckle if you're right next to it
			if(M.loc != src.loc)
				return
			. = buckle_mob(M)
	if (M.mob_size <= MOB_SIZE_XENO)
		if ((M.stat == DEAD && istype(src, /obj/structure/bed/roller) || HAS_TRAIT(M, TRAIT_OPPOSABLE_THUMBS)))
			do_buckle(M, user)
			return
	if ((M.mob_size > MOB_SIZE_HUMAN))
		to_chat(user, SPAN_WARNING("[M] is too big to buckle in."))
		return
	do_buckle(M, user)

// the actual buckling proc
// Yes I know this is not style but its unreadable otherwise
/obj/proc/do_buckle(mob/living/target, mob/user)
	send_buckling_message(target, user)
	if (src && src.loc)
		target.throw_alert(ALERT_BUCKLED, /atom/movable/screen/alert/buckled)
		target.set_buckled(src)
		target.forceMove(src.loc)
		target.setDir(dir)
		src.buckled_mob = target
		src.add_fingerprint(user)
		afterbuckle(target)
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
	SEND_SIGNAL(buckled_mob, COMSIG_MOB_MOVE_OR_LOOK, TRUE, direct, direct)
	return TRUE

/obj/BlockedPassDirs(atom/movable/mover, target_dir)
	if(mover == buckled_mob) //can't collide with the thing you're buckled to
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/bullet_act(obj/projectile/P)
	//Tasers and the like should not damage objects.
	if(P.ammo.damage_type == HALLOSS || P.ammo.damage_type == TOX || P.ammo.damage_type == CLONE || P.damage == 0)
		return 0
	bullet_ping(P)
	if(P.ammo.damage)
		update_health(floor(P.ammo.damage / 2))
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
		if(slot == WEAR_L_HAND)
			mob_state = "[mob_state]_l"
		if(slot == WEAR_R_HAND)
			mob_state = "[mob_state]_r"
	else if(use_spritesheet(bodytype, slot, mob_state))
		spritesheet = TRUE
		mob_icon = sprite_sheets[bodytype]
	else if(contained_sprite)
		mob_icon = icon
	else if(LAZYISIN(item_icons, slot))
		mob_icon = item_icons[slot]
	else
		mob_icon = GLOB.default_onmob_icons[slot]

	var/image/overlay_img

	if(user_human)
		overlay_img = user_human.species.get_offset_overlay_image(spritesheet, mob_icon, mob_state, color, slot)
	else
		overlay_img = overlay_image(mob_icon, mob_state, color, RESET_COLOR)

	var/inhands = slot == (WEAR_L_HAND || WEAR_R_HAND)

	var/offset_x = worn_x_dimension
	var/offset_y = worn_y_dimension
	if(inhands)
		offset_x = inhand_x_dimension
		offset_y = inhand_y_dimension

	center_image(overlay_img, offset_x, offset_y)

	return overlay_img

/obj/item/proc/use_spritesheet(bodytype, slot, icon_state)
	if(!LAZYISIN(sprite_sheets, bodytype))
		return FALSE
	if(slot == WEAR_R_HAND || slot == WEAR_L_HAND)
		return FALSE

	if(icon_state in icon_states(sprite_sheets[bodytype]))
		return TRUE

	return (slot != WEAR_JACKET && slot != WEAR_HEAD)

// Adding a text string at the end of the object
/obj/proc/add_label(obj/O, user)
	var/label = copytext(reject_bad_text(input(user,"Label text?", "Set label", "")), 1, MAX_NAME_LEN)

	// Checks for valid labelling/name length
	if(!label || !length(label))
		to_chat(user, SPAN_NOTICE("Invalid text."))
		return
	if((length(O.name) + length(label)) > MAX_NAME_LEN * 1.5)
		to_chat(user, SPAN_NOTICE("You cannot fit any more labels on this item."))
		return

	O.name += " ([label])"

/obj/proc/extinguish()
	return

/obj/handle_flamer_fire(obj/flamer_fire/fire, damage, delta_time)
	. = ..()
	flamer_fire_act(damage, fire.weapon_cause_data)

///returns time or -1 if unmeltable
/obj/proc/get_applying_acid_time()
	if(unacidable)
		return -1

	if(density)//dense objects are big, so takes longer to melt.
		return 4 SECONDS

	return 1 SECONDS

/obj/proc/set_origin_name_prefix(name_prefix)
	return

/// override for subtypes that require extra behaviour when spawned from a vendor
/obj/proc/post_vendor_spawn_hook(mob/living/carbon/human/user)
	return
