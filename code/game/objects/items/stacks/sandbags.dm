//Empty sandbags
/obj/item/stack/sandbags_empty
	name = "empty sandbags"
	desc = "Some empty sandbags, best to fill them up if you want to use them."
	singular_name = "sandbag"
	icon = 'icons/obj/items/marine-items.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/material_stacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/material_stacks_righthand.dmi',
	)
	icon_state = "sandbag_stack"
	item_state = "sandbag_stack"
	w_class = SIZE_SMALL
	force = 2
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 50
	attack_verb = list("hit", "slapped", "whacked")
	stack_id = "empty sandbags"

/obj/item/stack/sandbags_empty/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/tool/shovel))
		var/obj/item/tool/shovel/ET = W
		if(ET.dirt_amt)
			ET.dirt_amt--
			ET.update_icon()
			var/obj/item/stack/sandbags/new_bags = new(user.loc)
			new_bags.add_to_stacks(user)
			var/obj/item/stack/sandbags_empty/E = src
			src = null
			var/replace = (user.get_inactive_hand() == E)
			playsound(user.loc, "rustle", 30, 1, 6)
			E.use(1)
			if(!E && replace)
				user.put_in_hands(new_bags)

	else if (istype(W, /obj/item/stack/snow))
		var/obj/item/stack/S = W
		var/obj/item/stack/sandbags/new_bags = new(user.loc)
		new_bags.add_to_stacks(user)
		S.use(1)
		use(1)
	else
		return ..()


//half a max stack
/obj/item/stack/sandbags_empty/small_stack
	amount = STACK_10

/obj/item/stack/sandbags_empty/half
	amount = 25

//full stack
/obj/item/stack/sandbags_empty/full
	amount = STACK_50

//Full sandbags
/obj/item/stack/sandbags
	name = "sandbags"
	desc = "Some bags filled with sand. For now, just cumbersome, but soon to be used for fortifications."
	singular_name = "sandbag"
	icon = 'icons/obj/items/marine-items.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/material_stacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/material_stacks_righthand.dmi',
	)
	icon_state = "sandbag_pile"
	item_state = "sandbag_pile"
	w_class = SIZE_LARGE
	force = 9
	throwforce = 15
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 25
	attack_verb = list("hit", "bludgeoned", "whacked")
	stack_id = "sandbags"

/obj/item/stack/sandbags/large_stack
	amount = 25

/obj/item/stack/sandbags/small_stack
	amount = 5

/obj/item/stack/sandbags/attack_self(mob/living/user)
	..()
	add_fingerprint(user)

	if(!isturf(user.loc))
		return
	if(istype(user.loc, /turf/open/shuttle))
		to_chat(user, SPAN_WARNING("No. This area is needed for the dropships and personnel."))
		return
	if(istype(user.loc, /turf/open))
		var/turf/open/OT = user.loc
		var/area/area = get_area(user)
		if(!OT.allow_construction || !area.allow_construction)
			to_chat(user, SPAN_WARNING("The sandbag barricade must be constructed on a proper surface!"))
			return

	//Using same safeties as other constructions
	for(var/obj/O in user.loc) //Objects, we don't care about mobs. Turfs are checked elsewhere
		var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in usr.loc // for M2C HMG, look at smartgun_mount.dm
		if(O.density)
			if(O.flags_atom & ON_BORDER)
				if(O.dir == user.dir)
					to_chat(user, SPAN_WARNING("There is already \a [O.name] in this direction!"))
					return
			else
				to_chat(user, SPAN_WARNING("You need a clear, open area to build the sandbag barricade!"))
				return
		if(AC)
			to_chat(usr, SPAN_WARNING("The [O.name] cannot be built here!"))
			return

	if(user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user] starts assembling a sandbag barricade."),
	SPAN_NOTICE("You start assembling a sandbag barricade."))

	if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	for(var/obj/O in user.loc) //Objects, we don't care about mobs. Turfs are checked elsewhere
		if(O.density)
			if(!(O.flags_atom & ON_BORDER) || O.dir == user.dir)
				return

	var/build_stack = amount
	if(amount >= 5)
		build_stack = 5

	var/obj/structure/barricade/sandbags/SB = new(user.loc, user, user.dir, build_stack)
	user.visible_message(SPAN_NOTICE("[user] assembles a sandbag barricade."),
	SPAN_NOTICE("You assemble a sandbag barricade."))
	SB.setDir(user.dir)
	SB.add_fingerprint(user)
	use(build_stack)
