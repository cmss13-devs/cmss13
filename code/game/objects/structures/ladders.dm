/obj/structure/ladder
	name = "ladder"
	desc = "A sturdy metal ladder."
	icon = 'icons/obj/structures/ladders.dmi'
	icon_state = "ladder11"
	var/id = null
	var/height = 0 //The 'height' of the ladder. higher numbers are considered physically higher
	var/obj/structure/ladder/down = null //The ladder below this one
	var/obj/structure/ladder/up = null //The ladder above this one
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = LADDER_LAYER
	var/is_watching = 0
	var/obj/structure/machinery/camera/cam
	var/busy = FALSE //Ladders are wonderful creatures, only one person can use it at a time
	var/static/list/direction_selection = list("up" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_ladder_up"), "down" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_ladder_down"))


/obj/structure/ladder/Initialize(mapload, ...)
	. = ..()
	cam = new /obj/structure/machinery/camera(src)
	cam.network = list(CAMERA_NET_LADDER)
	cam.c_tag = name

	GLOB.ladder_list += src
	return INITIALIZE_HINT_LATELOAD

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
	if(down)
		if(istype(down))
			down.up = null
		down = null
	if(up)
		if(istype(up))
			up.down = null
		up = null
	QDEL_NULL(cam)
	GLOB.ladder_list -= src
	. = ..()

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

	var/ladder_dir_name
	var/obj/structure/ladder/ladder_dest
	if(up && down)
		ladder_dest = lowertext(show_radial_menu(user, src, direction_selection, require_near = TRUE))
		if(ladder_dest == "up")
			ladder_dest = up
			ladder_dir_name = ("up")
		if(ladder_dest == "down")
			ladder_dest = down
			ladder_dir_name = ("down")
	else if(up)
		ladder_dir_name = "up"
		ladder_dest = up
	else if(down)
		ladder_dir_name = "down"
		ladder_dest = down
	else
		return FALSE //just in case

	if(!ladder_dest)
		return

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
	..()
	is_watching = 0
	user.reset_view(null)

//Peeking up/down
/obj/structure/ladder/MouseDrop(over_object, src_location, over_location, mob/user)
	//Are we capable of looking?
	if(usr.is_mob_incapacitated() || get_dist(usr, src) > 1 || usr.blinded ||  !usr.client)
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
			usr.set_interaction(src)
		if(looking_at == "down")
			looking_at = down
			is_watching = 1
			usr.set_interaction(src)
			usr.visible_message(SPAN_NOTICE("[usr] looks down [src]!"),
			SPAN_NOTICE("You look down [src]!"))
	else if(up)
		looking_at = up
		is_watching = 2
		usr.visible_message(SPAN_NOTICE("[usr] looks up [src]!"),
		SPAN_NOTICE("You look up [src]!"))
		usr.set_interaction(src)
	else if(down)
		looking_at = down
		is_watching = 1
		usr.set_interaction(src)
		usr.visible_message(SPAN_NOTICE("[usr] looks down [src]!"),
		SPAN_NOTICE("You look down [src]!"))
	else
		return FALSE //just in case

	if(!looking_at)
		return

	add_fingerprint(usr)

/obj/structure/ladder/ex_act(severity)
	return

//Throwing Shiet
/obj/structure/ladder/attackby(obj/item/W, mob/user)
	//Throwing Grenades
	if(istype(W,/obj/item/explosive/grenade))
		var/obj/item/explosive/grenade/G = W
		var/ladder_dir_name
		var/obj/structure/ladder/ladder_dest
		if(up && down)
			ladder_dest = lowertext(show_radial_menu(user, src, direction_selection, require_near = TRUE))
			if(ladder_dest == "up")
				ladder_dest = up
				ladder_dir_name = ("up")
			if(ladder_dest == "down")
				ladder_dest = down
				ladder_dir_name = ("down")
		else if(up)
			ladder_dir_name = "up"
			ladder_dest = up
		else if(down)
			ladder_dir_name = "down"
			ladder_dest = down
		else
			return FALSE //just in case

		if(!ladder_dest)
			return

		if(G.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(G, user))
			to_chat(user, SPAN_WARNING("\The [G.name]'s safe-area accident inhibitor prevents you from priming the grenade!"))
			// Let staff know, in case someone's actually about to try to grief
			msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
			return

		user.visible_message(SPAN_WARNING("[user] takes position to throw [G] [ladder_dir_name] [src]."),
		SPAN_WARNING("You take position to throw [G] [ladder_dir_name] [src]."))
		if(do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			user.visible_message(SPAN_WARNING("[user] throws [G] [ladder_dir_name] [src]!"),
			SPAN_WARNING("You throw [G] [ladder_dir_name] [src]"))
			user.drop_held_item()
			G.forceMove(ladder_dest.loc)
			G.setDir(pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
			step_away(G, src, rand(1, 5))
			if(!G.active)
				G.activate(user)

	//Throwing Flares and flashlights
	else if(istype(W,/obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = W
		var/ladder_dir_name
		var/obj/structure/ladder/ladder_dest
		if(up && down)
			ladder_dest = lowertext(show_radial_menu(user, src, direction_selection, require_near = TRUE))
			if(ladder_dest == "up")
				ladder_dest = up
				ladder_dir_name = ("up")
			if(ladder_dest == "down")
				ladder_dest = down
				ladder_dir_name = ("down")
		else if(up)
			ladder_dir_name = "up"
			ladder_dest = up
		else if(down)
			ladder_dir_name = "down"
			ladder_dest = down
		else
			return FALSE //just in case


		if(!ladder_dest)
			return

		user.visible_message(SPAN_WARNING("[user] takes position to throw [F] [ladder_dir_name] [src]."),
		SPAN_WARNING("You take position to throw [F] [ladder_dir_name] [src]."))
		if(do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			user.visible_message(SPAN_WARNING("[user] throws [F] [ladder_dir_name] [src]!"),
			SPAN_WARNING("You throw [F] [ladder_dir_name] [src]"))
			user.drop_held_item()
			F.forceMove(ladder_dest.loc)
			F.setDir(pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
			step_away(F,src,rand(1, 5))
	else
		return attack_hand(user)

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
