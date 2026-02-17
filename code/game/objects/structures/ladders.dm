/obj/structure/ladder
	name = "ladder"
	desc = "A sturdy metal ladder."
	icon = 'icons/obj/structures/ladders.dmi'
	icon_state = "ladder11"
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = LADDER_LAYER
	/// Used to link up ladders that are above and below
	var/id = null
	/// The 'height' of the ladder. higher numbers are considered physically higher
	var/height = 0
	/// The ladder below this one
	var/obj/structure/ladder/down
	/// The ladder above this one
	var/obj/structure/ladder/up
	var/is_watching = 0
	var/obj/structure/machinery/camera/cam
	/// Ladders are wonderful creatures, only one person can use it at a time
	var/busy = FALSE
	var/static/list/direction_selection = list("up" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_ladder_up"), "down" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_ladder_down"))


/obj/structure/ladder/Initialize(mapload, ...)
	. = ..()
	cam = new /obj/structure/machinery/camera(src)
	cam.network = list(CAMERA_NET_LADDER)
	cam.c_tag = name

	GLOB.ladder_list += src
	return INITIALIZE_HINT_LATELOAD

/obj/structure/ladder/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Drag-click to look up or down [src].")
	. += SPAN_NOTICE("Ctrl-click to go up, Alt-click to go down.")
	if(ishuman(user))
		. += SPAN_NOTICE("Click [src] with unprimed grenades/flares to prime and toss it up or down.")
		. += SPAN_NOTICE("Ctrl-click or Alt-click with grenades/flares to throw in that direction.")

/obj/structure/ladder/LateInitialize()
	. = ..()

	for(var/i in GLOB.ladder_list)
		var/obj/structure/ladder/L = i
		if(L.id == id)
			if(L.height == (height - 1))
				down = L
				continue
			if(L.height == (height + 1))
				up = L
				continue

		if(up && down) //If both our connections are filled
			break
	update_icon()

/obj/structure/ladder/Destroy()
	if(istype(down))
		down.up = null
	if(istype(up))
		up.down = null
	down = null
	up = null
	QDEL_NULL(cam)
	GLOB.ladder_list -= src
	return ..()

/obj/structure/ladder/update_icon()
	if(up && down)
		icon_state = "ladder11"

	else if(up)
		icon_state = "ladder10"

	else if(down)
		icon_state = "ladder01"

	else //wtf make your ladders properly assholes
		icon_state = "ladder00"

/obj/structure/ladder/attack_hand(mob/living/user)
	if(user.stat || get_dist(user, src) > 1 || user.blinded || user.body_position == LYING_DOWN || user.buckled || user.anchored)
		return
	if(busy)
		to_chat(user, SPAN_WARNING("Someone else is currently using [src]."))
		return

	var/direction
	if(up && down)
		var/choice = lowertext(show_radial_menu(user, src, direction_selection, require_near = TRUE))
		if(choice == "up")
			direction = "up"
		else if(choice == "down")
			direction = "down"
		else
			return //User cancelled or invalid choice
	else if(up)
		direction = "up"
	else if(down)
		direction = "down"
	else
		return FALSE //No valid directions

	climb_ladder(user, direction)

//Helper function to handle climbing logic for both manual clicks and modifier clicks
/obj/structure/ladder/proc/climb_ladder(mob/living/user, direction)
	if(user.stat || get_dist(user, src) > 1 || user.blinded || user.body_position == LYING_DOWN || user.buckled || user.anchored || user.interactee)
		return FALSE
	if(busy)
		to_chat(user, SPAN_WARNING("Someone else is currently using [src]."))
		return FALSE

	var/ladder_dir_name
	var/obj/structure/ladder/ladder_dest

	if(direction == "up")
		if(!up)
			return FALSE
		ladder_dir_name = "up"
		ladder_dest = up
	else if(direction == "down")
		if(!down)
			return FALSE
		ladder_dir_name = "down"
		ladder_dest = down
	else
		return FALSE

	if(!ladder_dest)
		return FALSE

	step(user, get_dir(user, src))
	user.visible_message(SPAN_NOTICE("[user] starts climbing [ladder_dir_name] [src]."),
	SPAN_NOTICE("You start climbing [ladder_dir_name] [src]."))
	busy = TRUE
	if(do_after(user, 20, INTERRUPT_INCAPACITATED|INTERRUPT_OUT_OF_RANGE|INTERRUPT_RESIST, BUSY_ICON_GENERIC, src, INTERRUPT_NONE))
		if(!user.is_mob_incapacitated() && get_dist(user, src) <= 1 && !user.blinded && user.body_position != LYING_DOWN && !user.buckled && !user.anchored)
			visible_message(SPAN_NOTICE("[user] climbs [ladder_dir_name] [src].")) //Hack to give a visible message to the people here without duplicating user message
			user.visible_message(SPAN_NOTICE("[user] climbs [ladder_dir_name] [src]."),
			SPAN_NOTICE("You climb [ladder_dir_name] [src]."))
			ladder_dest.add_fingerprint(user)
			user.trainteleport(ladder_dest.loc)
	busy = FALSE
	add_fingerprint(user)
	if(ladder_dest.up && ladder_dest.down) // Make sure it has a up and down before opening the radial wheel, otherwise it sends you
		ladder_dest.attack_hand(user)
	return TRUE

//Alt click to go down
/obj/structure/ladder/proc/alt_click_action(mob/user)
	if(!isliving(user))
		return
	climb_ladder(user, "down")

//Ctrl click to go up
/obj/structure/ladder/proc/ctrl_click_action(mob/user)
	if(!isliving(user))
		return
	climb_ladder(user, "up")

//Override clicked to handle modifier clicks
/obj/structure/ladder/clicked(mob/user, list/mods)
	// If user is holding a throwable item, let attackby handle the modifier clicks
	if(isliving(user))
		var/mob/living/living_user = user
		var/obj/item/held_item = living_user.get_active_hand()
		if(held_item && (istype(held_item, /obj/item/explosive/grenade) || istype(held_item, /obj/item/device/flashlight)))
			return FALSE // Let attackby handle this

	if(mods[ALT_CLICK])
		alt_click_action(user)
		return TRUE
	if(mods[CTRL_CLICK])
		ctrl_click_action(user)
		return TRUE
	return ..()

/obj/structure/ladder/check_eye(mob/living/user)
	//Are we capable of looking?
	if(user.is_mob_incapacitated() || get_dist(user, src) > 1 || user.blinded || user.body_position == LYING_DOWN || !user.client)
		user.unset_interaction()

	//Are ladder cameras ok?
	else if (is_watching == 1)
		if (istype(down) && down.cam && !down.cam.can_use()) //Camera doesn't work or is gone
			user.unset_interaction()
	else if (is_watching == 2)
		if (istype(up) && up.cam && !up.cam.can_use()) //Camera doesn't work or is gone
			user.unset_interaction()



/obj/structure/ladder/on_set_interaction(mob/user)
	if (is_watching == 1)
		if (istype(down) && down.cam && down.cam.can_use()) //Camera works
			user.reset_view(down.cam)
			return
	else if (is_watching == 2)
		if (istype(up) && up.cam && up.cam.can_use())
			user.reset_view(up.cam)
			return

	user.unset_interaction() //No usable cam, we stop interacting right away



/obj/structure/ladder/on_unset_interaction(mob/user)
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	..()
	is_watching = 0
	user.reset_view(null)

/obj/structure/ladder/proc/handle_move(mob/moved_mob, oldLoc, direct)
	SIGNAL_HANDLER
	moved_mob.unset_interaction()

//Peeking up/down
/obj/structure/ladder/MouseDrop(over_object, src_location, over_location, mob/user)
	//Are we capable of looking?
	if(usr.is_mob_incapacitated() || get_dist(usr, src) > 1 || usr.blinded || !usr.client)
		return


	if(isliving(usr))
		var/mob/living/living_usr = usr
		if(living_usr.body_position == LYING_DOWN)
			return

	var/obj/structure/ladder/looking_at
	if(up && down)
		looking_at = lowertext(show_radial_menu(usr, src, direction_selection, require_near = TRUE))
		if(looking_at == "up")
			looking_at = up
			is_watching = 2
			usr.visible_message(SPAN_NOTICE("[usr] looks up [src]!"),
			SPAN_NOTICE("You look up [src]!"))
			RegisterSignal(usr, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
			usr.set_interaction(src)
		if(looking_at == "down")
			looking_at = down
			is_watching = 1
			usr.visible_message(SPAN_NOTICE("[usr] looks down [src]!"), SPAN_NOTICE("You look down [src]!"))
			RegisterSignal(usr, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
			usr.set_interaction(src)
	else if(up)
		looking_at = up
		is_watching = 2
		usr.visible_message(SPAN_NOTICE("[usr] looks up [src]!"),
		SPAN_NOTICE("You look up [src]!"))
		RegisterSignal(usr, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
		usr.set_interaction(src)
	else if(down)
		looking_at = down
		is_watching = 1
		usr.visible_message(SPAN_NOTICE("[usr] looks down [src]!"),
		SPAN_NOTICE("You look down [src]!"))
		RegisterSignal(usr, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
		usr.set_interaction(src)
	else
		return FALSE //just in case

	if(!looking_at)
		return

	add_fingerprint(usr)

/obj/structure/ladder/ex_act(severity)
	return

//Helper function to handle throwing items up/down ladders
/obj/structure/ladder/proc/throw_item_ladder(obj/item/item, mob/user, direction)
	var/ladder_dir_name
	var/obj/structure/ladder/ladder_dest

	if(direction == "up")
		if(!up)
			return FALSE
		ladder_dir_name = "up"
		ladder_dest = up
	else if(direction == "down")
		if(!down)
			return FALSE
		ladder_dir_name = "down"
		ladder_dest = down
	else
		return FALSE

	if(!ladder_dest)
		return FALSE

	// Handle grenade-specific logic
	if(istype(item, /obj/item/explosive/grenade))
		var/obj/item/explosive/grenade/G = item
		if(G.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(G, user))
			to_chat(user, SPAN_WARNING("\The [G.name]'s safe-area accident inhibitor prevents you from priming the grenade!"))
			msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
			return FALSE

	user.visible_message(SPAN_WARNING("[user] takes position to throw [item] [ladder_dir_name] [src]."),
	SPAN_WARNING("You take position to throw [item] [ladder_dir_name] [src]."))

	if(do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		user.visible_message(SPAN_WARNING("[user] throws [item] [ladder_dir_name] [src]!"),
		SPAN_WARNING("You throw [item] [ladder_dir_name] [src]"))
		user.drop_held_item()
		item.forceMove(ladder_dest.loc)
		item.setDir(pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		step_away(item, src, rand(1, 5))

		// Handle grenade activation
		if(istype(item, /obj/item/explosive/grenade))
			var/obj/item/explosive/grenade/G = item
			if(!G.active)
				G.activate(user)

		// Handle flare activation
		if(istype(item, /obj/item/device/flashlight/flare))
			var/obj/item/device/flashlight/flare/the_flare = item
			if(!the_flare.on)
				the_flare.turn_on()

	return TRUE

//Throwing Shiet
/obj/structure/ladder/attackby(obj/item/W, mob/user, list/mods)
	// Check if this is a throwable item (grenades or flashlights)
	if(!istype(W, /obj/item/explosive/grenade) && !istype(W, /obj/item/device/flashlight))
		return attack_hand(user)

	var/direction

	// Check for modifier keys first
	if(mods && mods[CTRL_CLICK] && up)
		direction = "up"
	else if(mods && mods[ALT_CLICK] && down)
		direction = "down"
	// If no modifier or invalid direction, use menu/auto-select
	else if(up && down)
		var/choice = lowertext(show_radial_menu(user, src, direction_selection, require_near = TRUE))
		if(choice == "up")
			direction = "up"
		else if(choice == "down")
			direction = "down"
		else
			return // User cancelled
	else if(up)
		direction = "up"
	else if(down)
		direction = "down"
	else
		return FALSE // No valid directions

	// Use the helper function to throw the item
	throw_item_ladder(W, user, direction)

/obj/structure/ladder/fragile_almayer //goes away on hijack
	name = "rickety ladder"
	desc = "A slightly less stable-looking ladder, installed out of dry dock by some enterprising maintenance tech. Looks like it could collapse at any moment."

/obj/structure/ladder/fragile_almayer/Initialize()
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_IMPACTED, PROC_REF(deconstruct))

/obj/structure/ladder/fragile_almayer/deconstruct()
	new /obj/structure/prop/broken_ladder(loc)
	return ..()

/obj/structure/prop/broken_ladder
	name = "rickety ladder"
	desc = "Well, it was only a matter of time."
	icon = 'icons/obj/structures/ladders.dmi'
	icon_state = "ladder00"
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = LADDER_LAYER

/obj/structure/ladder/multiz/LateInitialize()
	. = ..()

	up = locate(/obj/structure/ladder) in SSmapping.get_turf_above(get_turf(src))
	down = locate(/obj/structure/ladder) in SSmapping.get_turf_below(get_turf(src))

	update_icon()

/obj/structure/ladder/yautja
	name = "ladder"
	desc = "A sturdy metal ladder, made from an unknown metal, adorned with glowing runes."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
