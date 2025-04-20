/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 0
	/// if the lid is up
	var/open = 0
	/// if the cistern bit is open
	var/cistern = 0
	/// the combined w_class of all the items in the cistern
	var/w_items = 0
	/// the mob being given a swirlie
	var/mob/living/swirlie = null
	var/list/buckling_y = list("north" = 1, "south" = 4, "east" = 0, "west" = 0)
	var/list/buckling_x = list("north" = 0, "south" = 0, "east" = -5, "west" = 4)
	var/atom/movable/overlay/cistern_overlay


/obj/structure/toilet/Initialize()
	. = ..()
	open = floor(rand(0, 1))
	cistern_overlay = new()
	cistern_overlay.icon = icon
	cistern_overlay.layer = ABOVE_MOB_LAYER
	cistern_overlay.vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_ID
	vis_contents += cistern_overlay
	update_icon()


/obj/structure/toilet/attack_hand(mob/living/user as mob)
	if(buckled_mob)
		manual_unbuckle(user)
		return

	if(swirlie)
		user.visible_message(SPAN_DANGER("[user] slams the toilet seat onto [swirlie.name]'s head!"), SPAN_NOTICE("You slam the toilet seat onto [swirlie.name]'s head!"), "You hear reverberating porcelain.")
		swirlie.apply_damage(8, BRUTE)
		return

	if(!open)
		if(cistern)
			if(!length(contents))
				to_chat(user, SPAN_NOTICE("The cistern is empty."))
				return
			else
				var/obj/item/I = pick(contents)
				if(ishuman(user))
					user.put_in_hands(I)
				else
					I.forceMove(get_turf(src))
				to_chat(user, SPAN_NOTICE("You find \an [I] in the cistern."))
				w_items -= I.w_class
				return
		else
			open = !open // Toggles open to opposite state
			update_icon()

	else // open
		if(user.action_busy) // Prevent spamming faster than do_after speed
			return
		if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			return

		playsound(loc, 'sound/effects/toilet_flush_new.ogg', 25, 1)
		flick("toilet1[cistern]_flush", src)
		if(dir == SOUTH)
			flick("cistern[cistern]_flush", cistern_overlay)


/obj/structure/toilet/send_buckling_message(mob/M, mob/user)
	if (M == user)
		to_chat(M, SPAN_NOTICE("You seat yourself onto the toilet"))
	else
		to_chat(user, SPAN_NOTICE("[M] has been seated onto the toilet by [user]."))
		to_chat(M, SPAN_NOTICE("You have been seated onto the toilet by [user]."))


/obj/structure/toilet/afterbuckle(mob/M)
	. = ..()

	if(. && buckled_mob == M)
		var/direction = dir2text(dir)
		M.pixel_y = buckling_y[direction] + pixel_y
		M.pixel_x = buckling_x[direction] + pixel_x
		density = TRUE

		if(dir == NORTH)
			if(cistern == 1)
				M.overlays += image("toilet01")
			else
				M.overlays += image("toilet00")
	else
		M.pixel_y = initial(buckled_mob.pixel_y)
		M.old_y = initial(buckled_mob.pixel_y)
		M.pixel_x = initial(buckled_mob.pixel_x)
		M.old_x = initial(buckled_mob.pixel_x)
		density = FALSE

		if(dir == NORTH)
			if(cistern == 1)
				M.overlays -= image("toilet01")
			else
				M.overlays -= image("toilet00")


/obj/structure/toilet/verb/flip_lid()
	set name = "Flip lid"
	set category = "Object"
	set src in view(1)

	open = !open
	update_icon()


/obj/structure/toilet/update_icon()
	icon_state = "toilet[open][cistern]"
	cistern_overlay.icon_state = "cistern[cistern]"


/obj/structure/toilet/attackby(obj/item/I, mob/living/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_CROWBAR))
		to_chat(user, SPAN_NOTICE("You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]."))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25, 1)
		if(do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!"), SPAN_NOTICE("You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!"), "You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
			return

	if(istype(I, /obj/item/grab))
		if(isxeno(user))
			return
		var/obj/item/grab/G = I

		if(isliving(G.grabbed_thing))
			var/mob/living/GM = G.grabbed_thing

			if(user.grab_level > GRAB_PASSIVE)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name] needs to be on the toilet."))
					return
				if(open && !swirlie)
					user.visible_message(SPAN_DANGER("[user] starts to give [GM.name] a swirlie!"), SPAN_NOTICE("You start to give [GM.name] a swirlie!"))
					swirlie = GM
					if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
						user.visible_message(SPAN_DANGER("[user] gives [GM.name] a swirlie!"), SPAN_NOTICE("You give [GM.name] a swirlie!"), "You hear a toilet flushing.")
						if(!GM.internal)
							GM.apply_damage(5, OXY)
					swirlie = null
				else
					user.visible_message(SPAN_DANGER("[user] slams [GM.name] into [src]!"), SPAN_NOTICE("You slam [GM.name] into [src]!"))
					GM.apply_damage(8, BRUTE)
			else
				to_chat(user, SPAN_NOTICE("You need a tighter grip."))

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > SIZE_MEDIUM)
			to_chat(user, SPAN_NOTICE("\The [I] does not fit."))
			return
		if(w_items + I.w_class > 5)
			to_chat(user, SPAN_NOTICE("The cistern is full."))
			return
		user.drop_held_item()
		I.forceMove(src)
		w_items += I.w_class
		to_chat(user, "You carefully place \the [I] into the cistern.")
		return
