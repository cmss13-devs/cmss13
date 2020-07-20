/obj/structure/girder
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = OBJ_LAYER
	unacidable = FALSE
	debris = list(/obj/item/stack/sheet/metal,/obj/item/stack/sheet/metal)
	var/state = 0
	var/dismantlectr = 0
	var/buildctr = 0
	health = 125
	var/repair_state = 0
	// To store what type of wall it used to be
	var/original

/obj/structure/girder/initialize_pass_flags()
	..()
	flags_can_pass_all = SETUP_LIST_FLAGS(PASS_THROUGH, PASS_HIGH_OVER_ONLY)

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	//Tasers and the like should not damage girders.
	if(Proj.ammo.damage_type == HALLOSS || Proj.ammo.damage_type == TOX || Proj.ammo.damage_type == CLONE || Proj.damage == 0)
		return 0
	var/dmg = 0
	if(Proj.ammo.damage_type == BURN)
		dmg = Proj.damage
	else
		dmg = round(Proj.ammo.damage / 2)
	if(dmg)
		health -= dmg
		bullet_ping(Proj)
	if(health <= 0)
		update_state()
	return 1


/obj/structure/girder/attackby(obj/item/W, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return
	if(user.action_busy)
		return TRUE //no afterattack
	if(health > 0)
		if(istype(W, /obj/item/tool/wrench))
			if(!anchored)
				if(istype(get_area(src.loc),/area/shuttle))
					to_chat(user, SPAN_WARNING("No. This area is needed for the dropships and personnel."))
					return
				if(!istype(loc, /turf/open/floor))
					to_chat(user, SPAN_WARNING("You can't secure that here, it needs sufficiently solid ground beneath it!"))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE(" Now securing the girder"))
				if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, SPAN_NOTICE(" You secured the girder!"))
					new/obj/structure/girder( src.loc )
					qdel(src)
			else if (dismantlectr %2 == 0)
				if(do_after(user,15, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					dismantlectr++
					health -= 15
					to_chat(user, SPAN_NOTICE(" You unfasten a bolt from the girder!"))
				return


		else if(istype(W, /obj/item/tool/pickaxe/plasmacutter))
			to_chat(user, SPAN_NOTICE(" Now slicing apart the girder"))
			if(do_after(user,30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				if(!src) return
				to_chat(user, SPAN_NOTICE(" You slice apart the girder!"))
				health = 0
				update_state()
		else if(istype(W, /obj/item/tool/pickaxe/diamonddrill))
			to_chat(user, SPAN_NOTICE(" You drill through the girder!"))
			dismantle()

		else if(istype(W, /obj/item/tool/screwdriver) && state == 2 && istype(src,/obj/structure/girder/reinforced))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE(" Now unsecuring support struts"))
			if(do_after(user,40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!src) return
				to_chat(user, SPAN_NOTICE(" You unsecured the support struts!"))
				state = 1

		else if(istype(W, /obj/item/tool/wirecutters) && istype(src,/obj/structure/girder/reinforced) && state == 1)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE(" Now removing support struts"))
			if(do_after(user,40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!src) return
				to_chat(user, SPAN_NOTICE(" You removed the support struts!"))
				new/obj/structure/girder( src.loc )
				qdel(src)

		else if(istype(W, /obj/item/tool/crowbar) && state == 0 && anchored )
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE(" Now dislodging the girder..."))
			if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!src) return
				to_chat(user, SPAN_NOTICE(" You dislodged the girder!"))
				new/obj/structure/girder/displaced( src.loc )
				qdel(src)

		else if(istype(W, /obj/item/stack/sheet) && buildctr %2 == 0)
			if(istype(get_area(src.loc),/area/shuttle))
				to_chat(user, SPAN_WARNING("No. This area is needed for the dropships and personnel."))
				return

			var/old_buildctr = buildctr

			var/obj/item/stack/sheet/S = W
			if(S.stack_id == "metal")
				if (anchored)
					if(S.get_amount() < 1) return ..()
					to_chat(user, SPAN_NOTICE("Now adding plating..."))
					if (do_after(user,60, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						if(disposed || buildctr != old_buildctr) return
						if (S.use(1))
							to_chat(user, SPAN_NOTICE("You added the plating!"))
							buildctr++
					return
			else if(S.stack_id == "plasteel")
				if (anchored)
					to_chat(user, SPAN_NOTICE("It doesn't look like the plasteel will do anything. Try metal."))
					return

			if(S.sheettype)
				var/M = S.sheettype
				if (anchored)
					if(S.amount < 2)
						return ..()
					to_chat(user, SPAN_NOTICE("Now adding plating..."))
					if (do_after(user,40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						if(disposed || buildctr != old_buildctr || S.amount < 2) return
						S.use(2)
						to_chat(user, SPAN_NOTICE("You added the plating!"))
						var/turf/Tsrc = get_turf(src)
						Tsrc.ChangeTurf(text2path("/turf/closed/wall/mineral/[M]"))
						for(var/turf/closed/wall/mineral/X in Tsrc.loc)
							if(X)	X.add_hiddenprint(usr)
						qdel(src)
					return

			add_hiddenprint(usr)

		else if(istype(W, /obj/item/tool/weldingtool) && buildctr %2 != 0)
			var/obj/item/tool/weldingtool/WT = W
			if (WT.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
				if(do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!WT.isOn()) return
					if (buildctr >= 5)
						build_wall()
						return
					buildctr++
					to_chat(user, SPAN_NOTICE(" You weld the metal to the girder!"))
			return
		else if(istype(W, /obj/item/tool/wirecutters) && dismantlectr %2 != 0)
			if(do_after(user,15, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if (dismantlectr >= 5)
					dismantle()
					dismantlectr = 0
					return
				health -= 15
				dismantlectr++
				to_chat(user, SPAN_NOTICE(" You cut away from structural piping!"))
			return

		else if(istype(W, /obj/item/pipe))
			var/obj/item/pipe/P = W
			if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
				user.drop_held_item()
				P.loc = src.loc
				to_chat(user, SPAN_NOTICE(" You fit the pipe into the [src]!"))
		else
	else
		if (repair_state == 0)
			if(istype(W, /obj/item/stack/sheet/metal))
				var/obj/item/stack/sheet/metal/M = W
				if(M.amount < 2)
					return ..()
				to_chat(user, SPAN_NOTICE("Now adding plating..."))
				if (do_after(user,40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(disposed || repair_state != 0 || !M || M.amount < 2) return
					M.use(2)
					to_chat(user, SPAN_NOTICE("You added the metal to the girder!"))
					repair_state = 1
				return
		if (repair_state == 1)
			if(istype(W, /obj/item/tool/weldingtool))
				if(do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(disposed || repair_state != 1) return
					to_chat(user, SPAN_NOTICE(" You weld the girder together!"))
					repair()
				return
		..()

/obj/structure/girder/proc/build_wall()
	if (buildctr == 5)
		var/turf/Tsrc = get_turf(src)
		if (original)
			Tsrc.ChangeTurf(text2path("[original]"))
		else
			Tsrc.ChangeTurf(/turf/closed/wall)
		for(var/turf/closed/wall/X in Tsrc.loc)
			if(X)	X.add_hiddenprint(usr)
		qdel(src)

/obj/structure/girder/examine(mob/user)
	..()
	if (health <= 0)
		to_chat(user, "It's broken, but can be mended by applying a metal plate then welding it together.")
	else
	//Build wall
		if (buildctr%2 == 0)
			to_chat(user, "To continue building the wall, add a metal plate to the girder.")
		else if (buildctr%2 != 0)
			to_chat(user, "Secure the metal plates to the wall by welding.")
		if (buildctr < 1)
			to_chat(user, "It needs 3 more metal plates.")
		else if (buildctr < 3)
			to_chat(user, "It needs 2 more metal plates.")
		else if (buildctr < 5)
			to_chat(user, "It needs 1 more metal plate.")
	//Decon girder
		if (dismantlectr%2 == 0)
			to_chat(user, "To continue dismantling the girder, unbolt a nut with the wrench.")
		else if (dismantlectr%2 != 0)
			to_chat(user, "To continue dismantling the girder, cut through some of structural piping with a wirecutter.")
		if (dismantlectr < 1)
			to_chat(user, "It needs 3 bolts removed.")
		else if (dismantlectr < 3)
			to_chat(user, "It needs 2 bolts removed.")
		else if (dismantlectr < 5)
			to_chat(user, "It needs 1 bolt removed.")

/obj/structure/girder/proc/dismantle()
	health = 0
	update_state()

/obj/structure/girder/proc/repair()
	health = initial(health)
	update_state()

/obj/structure/girder/proc/update_state()
	if (health <= 0)
		icon_state = "[icon_state]_damaged"
		density = 0
	else
		var/underscore_position =  findtext(icon_state,"_")
		var/new_state = copytext(icon_state, 1, underscore_position)
		icon_state = new_state
		density = 1
	buildctr = 0
	repair_state = 0

/obj/structure/girder/attack_animal(mob/living/simple_animal/user)
	if(user.wall_smash)
		visible_message(SPAN_DANGER("[user] smashes [src] apart!"))
		dismantle()
		return
	return ..()

/obj/structure/girder/ex_act(severity, direction)
	health -= severity
	if(health <= 0)
		var/location = get_turf(src)
		handle_debris(severity, direction)
		qdel(src)
		create_shrapnel(location, rand(2,5), direction, , /datum/ammo/bullet/shrapnel/light) // Shards go flying
	else
		update_state()




/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = 0
	health = 50

/obj/structure/girder/reinforced
	icon_state = "reinforced"
	state = 2
	health = 500
