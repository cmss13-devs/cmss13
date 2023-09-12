/obj/structure/vulture_spotter_tripod
	name = "\improper M707 spotting tripod"
	desc = "A tripod for an M707 anti-materiel rifle's spotting scope."
	icon_state = "vulture_tripod"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	/// Weakref to the associated rifle
	var/datum/weakref/bound_rifle
	/// Weakref to the scope user, if any
	var/datum/weakref/scope_user
	/// If the tripod has an attached spotting scope
	var/scope_attached = FALSE
	/// If the scope is currently being used
	var/scope_using = FALSE
	/// Ref to the action to give the user of the scope
	var/datum/action/vulture_tripod_unscope/unscope_action
	/// How far out the scope zooms
	var/scope_zoom = 10
	/// How much to increase the user's dark vision by
	var/darkness_view = 12
	/// The maximum distance this can be from the sniper scope
	var/max_sniper_distance = 7

/obj/structure/vulture_spotter_tripod/Initialize(mapload)
	. = ..()
	desc = initial(desc) + " Though, it doesn't seem to have one attached yet."

/obj/structure/vulture_spotter_tripod/Destroy()
	if(scope_user)
		var/mob/user = scope_user.resolve()
		user.unset_interaction()
	QDEL_NULL(unscope_action)
	return ..()

/obj/structure/vulture_spotter_tripod/deconstruct(disassembled)
	. = ..()
	if(scope_attached && bound_rifle)
		new /obj/item/device/vulture_spotter_scope(get_turf(src), bound_rifle)
	new /obj/item/device/vulture_spotter_tripod(get_turf(src))

/obj/structure/vulture_spotter_tripod/get_examine_text(mob/user)
	. = ..()
	if(scope_attached)
		. += SPAN_NOTICE("You can remove the scope from [src] with a <b>screwdriver</b>.")
	else
		. += SPAN_NOTICE("You can pick up [src] by <b>dragging it to your sprite</b>.")
	. += SPAN_NOTICE("You can rotate [src] with <b>Alt-click</b>.")

/obj/structure/vulture_spotter_tripod/attackby(obj/item/thing, mob/user)
	if(istype(thing, /obj/item/device/vulture_spotter_scope))
		on_scope_attach(user, thing)
		return

	if(HAS_TRAIT(thing, TRAIT_TOOL_SCREWDRIVER))
		on_screwdriver(user)
		return

	return ..()

/obj/structure/vulture_spotter_tripod/MouseDrop(over_object, src_location, over_location)
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr //this is us

	if(!HAS_TRAIT(user, TRAIT_VULTURE_USER))
		to_chat(user, SPAN_WARNING("You don't know how to use this!"))
		return

	if(!scope_attached)
		fold_up(user)
		return

	try_scope(user)

/obj/structure/vulture_spotter_tripod/on_set_interaction(mob/user)
	var/obj/item/attachable/vulture_scope/scope = get_vulture_scope()
	scope.spotter_spotting = TRUE
	to_chat(scope.scope_user, SPAN_NOTICE("You notice that [scope] drifts less."))
	RegisterSignal(scope, COMSIG_VULTURE_SCOPE_MOVED, PROC_REF(on_vulture_move))
	RegisterSignal(scope, COMSIG_VULTURE_SCOPE_UNSCOPED, PROC_REF(on_vulture_unscope))
	if(user.client)
		RegisterSignal(user.client, COMSIG_PARENT_QDELETING, PROC_REF(do_unscope))
		user.client.change_view(scope_zoom, src)
	RegisterSignal(user, list(COMSIG_MOB_PICKUP_ITEM, COMSIG_MOB_RESISTED), PROC_REF(do_unscope))
	user.see_in_dark += darkness_view
	user.lighting_alpha = 127
	user.sync_lighting_plane_alpha()
	user.overlay_fullscreen("vulture_spotter", /atom/movable/screen/fullscreen/vulture/spotter)
	user.freeze()
	user.status_flags |= IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] looks through [src]."),SPAN_NOTICE("You look through [src], ready to go!"))
	user.forceMove(loc)
	user.setDir(dir)
	scope_user = WEAKREF(user)
	update_pixels(TRUE)
	give_action(user, /datum/action/vulture_tripod_unscope, null, null, src)
	set_scope_loc(user, scope)

/obj/structure/vulture_spotter_tripod/on_unset_interaction(mob/user)
	user.status_flags &= ~IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] looks up from [src]."),SPAN_NOTICE("You look up from [src]."))
	user.unfreeze()
	user.reset_view(null)
	user.Move(get_step(src, reverse_direction(src.dir)))
	user.client?.change_view(world_view_size, src)
	user.setDir(dir) //set the direction of the player to the direction the gun is facing
	update_pixels(FALSE)
	remove_action(user, /datum/action/vulture_tripod_unscope)
	unscope()

/obj/structure/vulture_spotter_tripod/clicked(mob/user, list/mods)
	if(mods["alt"])
		if(in_range(src, user) && !user.is_mob_incapacitated())
			rotate(user)
		return TRUE
	return ..()

/// Rotates the tripod 90* counter-clockwise
/obj/structure/vulture_spotter_tripod/proc/rotate(mob/user)
	if(scope_using)
		to_chat(user, SPAN_WARNING("You can't rotate [src] while someone is using it!"))
		return FALSE

	playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message("[user] rotates [src].","You rotate [src].")
	setDir(turn(dir, -90))
	update_pixels(TRUE)

/// Updates the direction the operator should be facing, and their pixel offset
/obj/structure/vulture_spotter_tripod/proc/update_pixels(mounting = TRUE)
	if(!scope_user)
		return

	var/mob/user = scope_user.resolve()
	if(mounting)
		var/diff_x = 0
		var/diff_y = 0
		switch(dir)
			if(NORTH)
				diff_y = -16
			if(SOUTH)
				diff_y = 16
			if(EAST)
				diff_x = -16
			if(WEST)
				diff_x = 16

		user.pixel_x = diff_x
		user.pixel_y = diff_y
	else
		user.pixel_x = 0
		user.pixel_y = 0

/// Handler for when the scope is being attached to the tripod
/obj/structure/vulture_spotter_tripod/proc/on_scope_attach(mob/user, obj/structure/vulture_spotter_tripod/scope)
	if(scope_attached)
		return

	user.visible_message(SPAN_NOTICE("[user] attaches [scope] to [src]."), SPAN_NOTICE("You attach [scope] to [src]."))
	icon_state = "vulture_scope"
	setDir(user.dir)
	bound_rifle = scope.bound_rifle
	scope_attached = TRUE
	desc = initial(desc)
	qdel(scope)

/// Handler for when the scope is being detached from the tripod by screwdriver
/obj/structure/vulture_spotter_tripod/proc/on_screwdriver(mob/user)
	if(!scope_attached)
		to_chat(user, SPAN_NOTICE("You don't need a screwdriver to pick this up!"))
		return
	user.visible_message(SPAN_NOTICE("[user] unscrews the scope from [src] before detaching it."), SPAN_NOTICE("You unscrew the scope from [src], detaching it."))
	icon_state = initial(icon_state)
	unscope()
	scope_attached = FALSE
	desc = initial(desc) + " Though, it doesn't seem to have one attached yet."
	new /obj/item/device/vulture_spotter_scope(get_turf(src), bound_rifle)

/// Handler for user folding up the tripod, picking it up
/obj/structure/vulture_spotter_tripod/proc/fold_up(mob/user)
	user.visible_message(SPAN_NOTICE("[user] folds up [src]."), SPAN_NOTICE("You fold up [src]."))
	var/obj/item/device/vulture_spotter_tripod/tripod = new(get_turf(src))
	user.put_in_hands(tripod, TRUE)
	qdel(src)

/// Checks if the user is able to use the scope, uses it if so
/obj/structure/vulture_spotter_tripod/proc/try_scope(mob/living/carbon/human/user)
	if(!user.client)
		return

	if(user.l_hand || user.r_hand)
		to_chat(user, SPAN_WARNING("Your hands need to be free to use [src]!"))
		return

	var/obj/item/attachable/vulture_scope/scope = get_vulture_scope()
	if(!scope)
		return

	if(get_dist(get_turf(scope), get_turf(src)) > max_sniper_distance)
		to_chat(user, SPAN_WARNING("[src] needs to be closer to the M707 to be used!"))
		return

	if(!scope.scoping)
		to_chat(user, SPAN_WARNING("The M707's sight needs to be in use to be able to look through [src]!"))
		return

	user.set_interaction(src)

/// Handler for when the user should be unscoping
/obj/structure/vulture_spotter_tripod/proc/do_unscope()
	SIGNAL_HANDLER

	if(!scope_user)
		return

	var/mob/user = scope_user.resolve()
	user.unset_interaction()

/// Unscopes the user, cleaning up everything related
/obj/structure/vulture_spotter_tripod/proc/unscope()
	SIGNAL_HANDLER
	if(scope_user)
		var/mob/living/carbon/human/user = scope_user.resolve()
		user.see_in_dark -= darkness_view
		user.lighting_alpha = user.default_lighting_alpha
		user.sync_lighting_plane_alpha()
		user.clear_fullscreen("vulture_spotter")
		UnregisterSignal(user, list(COMSIG_MOB_PICKUP_ITEM, COMSIG_MOB_RESISTED))
		user.pixel_x = 0
		user.pixel_y = 0
		if(user.client)
			user.client.change_view(world_view_size, src)
			user.client.pixel_x = 0
			user.client.pixel_y = 0
			UnregisterSignal(user.client, COMSIG_PARENT_QDELETING)

	var/obj/item/attachable/vulture_scope/scope = get_vulture_scope()
	if(scope)
		scope.spotter_spotting = FALSE
		to_chat(scope.scope_user, SPAN_NOTICE("You notice that [scope] starts drifting more."))
		UnregisterSignal(scope, list(COMSIG_VULTURE_SCOPE_MOVED, COMSIG_VULTURE_SCOPE_UNSCOPED))

	QDEL_NULL(unscope_action)

/// Sets the scope's sight location to the same as the sniper's
/obj/structure/vulture_spotter_tripod/proc/set_scope_loc(mob/living/carbon/human/user, obj/item/attachable/vulture_scope/scope)
	if(!user.client || !scope)
		return

	var/turf/user_turf = get_turf(user)
	var/x_off = scope.scope_x - user_turf.x
	var/y_off = scope.scope_y - user_turf.y
	var/pixels_per_tile = 32

	user.client.pixel_x = x_off * pixels_per_tile
	user.client.pixel_y = y_off * pixels_per_tile

/// Handler for when the vulture spotter scope moves
/obj/structure/vulture_spotter_tripod/proc/on_vulture_move(datum/source)
	SIGNAL_HANDLER
	if(!scope_user)
		return

	set_scope_loc(scope_user.resolve(), get_vulture_scope())

/// Handler for when the sniper unscopes
/obj/structure/vulture_spotter_tripod/proc/on_vulture_unscope(datum/source)
	SIGNAL_HANDLER
	if(!scope_user)
		return

	var/mob/user = scope_user.resolve()

	to_chat(user, SPAN_WARNING("[src]'s sight disengages as the linked rifle unscopes."))
	unscope()

/// Getter for the vulture scope on the sniper
/obj/structure/vulture_spotter_tripod/proc/get_vulture_scope()
	RETURN_TYPE(/obj/item/attachable/vulture_scope)
	if(!bound_rifle)
		return

	var/obj/item/weapon/gun/boltaction/vulture/rifle = bound_rifle.resolve()
	if(!("rail" in rifle.attachments) || !istype(rifle.attachments["rail"], /obj/item/attachable/vulture_scope))
		return

	return rifle.attachments["rail"]

/datum/action/vulture_tripod_unscope
	name = "Stop Using Scope"
	action_icon_state = "vulture_tripod_close"
	/// Weakref to the tripod that this is linked to
	var/datum/weakref/tripod

/datum/action/vulture_tripod_unscope/New(Target, override_icon_state, obj/structure/vulture_spotter_tripod/spotting_tripod)
	. = ..()
	tripod = WEAKREF(spotting_tripod)

/datum/action/vulture_tripod_unscope/action_activate()
	if(!tripod)
		return

	var/obj/structure/vulture_spotter_tripod/spotting_tripod = tripod.resolve()
	spotting_tripod.do_unscope()
