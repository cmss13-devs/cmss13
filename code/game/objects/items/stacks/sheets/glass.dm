/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		Phoron Glass Sheets
 *		Reinforced Phoron Glass Sheets (AKA Holy fuck strong windows)
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
/obj/item/stack/sheet/glass
	name = "glass"
	desc = "Glass is a non-crystalline solid, made out of silicate, the primary constituent of sand. It is valued for its transparency, albeit it is not too resistant to damage."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	matter = list("glass" = 3750)

	stack_id = "glass sheet"
	var/created_window = /obj/structure/window
	var/created_full_window = /obj/structure/window/full
	var/is_reinforced = 0
	var/list/construction_options = list("One Direction", "Full Window")

/obj/item/stack/sheet/glass/small_stack
	amount = STACK_10

/obj/item/stack/sheet/glass/medium_stack
	amount = STACK_25

/obj/item/stack/sheet/glass/large_stack
	amount = STACK_50

/obj/item/stack/sheet/glass/cyborg
	matter = null

/obj/item/stack/sheet/glass/attack_self(mob/user as mob)
	construct_window(user)

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user)
	..()
	if(!is_reinforced)
		if(istype(W,/obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/CC = W
			if (get_amount() < 1 || CC.get_amount() < 5)
				to_chat(user, SPAN_WARNING("You need five lengths of coil and one sheet of glass to make wired glass."))
				return

			CC.use(5)
			new /obj/item/stack/light_w(user.loc, 1)
			use(1)
			to_chat(user, SPAN_NOTICE("You attach wire to the [name]."))
		else if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/V  = W
			if (V.get_amount() < 1 || get_amount() < 1)
				to_chat(user, SPAN_WARNING("You need one rod and one sheet of glass to make reinforced glass."))
				return

			var/obj/item/stack/sheet/glass/reinforced/RG = new (user.loc)
			RG.add_fingerprint(user)
			RG.add_to_stacks(user)
			var/obj/item/stack/sheet/glass/G = src
			src = null
			var/replace = (user.get_inactive_hand()==G)
			V.use(1)
			G.use(1)
			if (!G && replace)
				user.put_in_hands(RG)

/obj/item/stack/sheet/glass/proc/construct_window(mob/user)
	if(!user || !src)	return 0
	if(!istype(user.loc,/turf)) return 0
	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_DANGER("You don't have the dexterity to do this!"))
		return 0
	if(ishuman(user) && !skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_ENGI))
		to_chat(user, SPAN_WARNING("You are not trained to build with [src]..."))
		return 0
	var/title = "Sheet-[name]"
	title += " ([src.amount] sheet\s left)"
	switch(tgui_input_list(user, title, "What would you like to construct?", construction_options))
		if("One Direction")
			if(!src)	return 1
			if(src.loc != user)	return 1

			var/list/directions = new/list(cardinal)
			var/i = 0
			for (var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					to_chat(user, SPAN_DANGER("There are too many windows in this location."))
					return 1
				directions-=win.dir
				if(!(win.dir in cardinal))
					to_chat(user, SPAN_DANGER("Can't let you do that."))
					return 1

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list( user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break
			var/obj/structure/window/WD = new created_window(user.loc)
			WD.set_constructed_window(dir_to_set)
			src.use(1)
		if("Full Window")
			if(!src)	return 1
			if(src.loc != user)	return 1
			if(src.amount < 4)
				to_chat(user, SPAN_DANGER("You need more glass to do that."))
				return 1
			if(locate(/obj/structure/window) in user.loc)
				to_chat(user, SPAN_DANGER("There is a window in the way."))
				return 1
			var/obj/structure/window/WD = new created_full_window(user.loc)
			WD.set_constructed_window()
			src.use(4)
		if("Windoor")
			if(!is_reinforced) return 1

			if(!src || src.loc != user) return 1

			if(isturf(user.loc) && locate(/obj/structure/windoor_assembly/, user.loc))
				to_chat(user, SPAN_DANGER("There is already a windoor assembly in that location."))
				return 1

			if(isturf(user.loc) && locate(/obj/structure/machinery/door/window/, user.loc))
				to_chat(user, SPAN_DANGER("There is already a windoor in that location."))
				return 1

			if(src.amount < 5)
				to_chat(user, SPAN_DANGER("You need more glass to do that."))
				return 1

			new /obj/structure/windoor_assembly(user.loc, user.dir, 1)
			src.use(5)

	return 0


/*
 * Reinforced glass sheets
 */
/obj/item/stack/sheet/glass/reinforced
	name = "reinforced glass"
	desc = "Reinforced glass is made out of squares of regular silicate glass layered on a metallic rod matrice. This glass is more resistant to direct impacts, even if it may crack."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	stack_id = "reinf glass sheet"

	matter = list("metal" = 1875,"glass" = 3750)


	created_window = /obj/structure/window/reinforced
	created_full_window = /obj/structure/window/reinforced/full
	is_reinforced = 1
	construction_options = list("One Direction", "Full Window", "Windoor")

/obj/item/stack/sheet/glass/reinforced/cyborg
	matter = null

/*
 * Phoron Glass sheets
 */
/obj/item/stack/sheet/glass/phoronglass
	name = "phoron glass"
	desc = "Phoron glass is a silicate-phoron alloy turned into a non-crystalline solid. It is transparent just like glass, even if visibly tainted pink, and very resistant to damage and heat."
	singular_name = "phoron glass sheet"
	icon_state = "sheet-phoronglass"
	matter = list("glass" = 7500)

	created_window = /obj/structure/window/phoronbasic
	created_full_window = /obj/structure/window/phoronbasic/full

/obj/item/stack/sheet/glass/phoronglass/attackby(obj/item/W, mob/user)
	..()
	if( istype(W, /obj/item/stack/rods) )
		var/obj/item/stack/rods/V  = W
		var/obj/item/stack/sheet/glass/phoronrglass/RG = new (user.loc)
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		V.use(1)
		var/obj/item/stack/sheet/glass/G = src
		src = null
		var/replace = (user.get_inactive_hand()==G)
		G.use(1)
		if (!G && !RG && replace)
			user.put_in_hands(RG)
	else
		return ..()

/*
 * Reinforced phoron glass sheets
 */
/obj/item/stack/sheet/glass/phoronrglass
	name = "reinforced phoron glass"
	desc = "Reinforced phoron glass is made out of squares of silicate-phoron alloy glass layered on a metallic rod matrice. It is insanely resistant to both physical shock and heat."
	singular_name = "reinforced phoron glass sheet"
	icon_state = "sheet-phoronrglass"
	matter = list("glass" = 7500,"metal" = 1875)


	created_window = /obj/structure/window/phoronreinforced
	created_full_window = /obj/structure/window/phoronreinforced/full
	is_reinforced = 1
