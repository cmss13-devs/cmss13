//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	var/open = 0 //if the lid is up
	var/cistern = 0 //if the cistern bit is open
	var/w_items = 0 //the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null //the mob being given a swirlie
	var/list/buckling_y = list("north" = 1, "south" = 4, "east" = 0, "west" = 0)
	var/list/buckling_x = list("north" = 0, "south" = 0, "east" = -5, "west" = 4)
	var/atom/movable/overlay/cistern_overlay



/obj/structure/toilet/Initialize()
	..()
	open = round(rand(0, 1))
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

	if(open && (do_after(user, 1 SECONDS)))
		switch(user.nutrition)
			if((1 + NUTRITION_NORMAL) to NUTRITION_MAX)
				to_chat(user, SPAN_NOTICE("The toilet starts flushing. You start feeling a bit more hungry."))
				user.nutrition = ((NUTRITION_LOW + NUTRITION_NORMAL) * 0.5)
			if((1 + NUTRITION_LOW) to NUTRITION_NORMAL)
				to_chat(user, SPAN_NOTICE("The toilet starts flushing. You could go for some food right now."))
				user.nutrition = ((NUTRITION_VERYLOW + NUTRITION_LOW) * 0.5)
			if((1 + NUTRITION_VERYLOW) to NUTRITION_LOW)
				to_chat(user, SPAN_NOTICE("The toilet starts flushing. Your stomach growls and you feel a little thinner."))
				user.nutrition = NUTRITION_VERYLOW * 0.5
			else
				to_chat(user, SPAN_NOTICE("The toilet starts flushing. You feel starved. Go grab something to eat!"))
				user.nutrition = 0

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
	if(istype(I, /obj/item/tool/crowbar))
		to_chat(user, SPAN_NOTICE("You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]."))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25, 1)
		if(do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!"), SPAN_NOTICE("You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!"), "You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
			return

	if(istype(I, /obj/item/grab))
		if(isxeno(user)) return
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
					user.visible_message(SPAN_DANGER("[user] slams [GM.name] into the [src]!"), SPAN_NOTICE("You slam [GM.name] into the [src]!"))
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



/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/urinal/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/grab))
		if(isxeno(user)) return
		var/obj/item/grab/G = I
		if(isliving(G.grabbed_thing))
			var/mob/living/GM = G.grabbed_thing
			if(user.grab_level > GRAB_PASSIVE)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name] needs to be on the urinal."))
					return
				user.visible_message(SPAN_DANGER("[user] slams [GM.name] into the [src]!"), SPAN_NOTICE("You slam [GM.name] into the [src]!"))
				GM.apply_damage(8, BRUTE)
			else
				to_chat(user, SPAN_NOTICE("You need a tighter grip."))



/obj/structure/machinery/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2050s by the Weyland Hygiene Division."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_NONE
	var/on = 0
	var/obj/effect/mist/mymist = null
	var/ismist = 0 //needs a var so we can make it linger~
	var/watertemp = "normal" //freezing, normal, or boiling
	var/mobpresent = 0 //true if there is a mob on the shower's loc, this is to ease process()
	var/is_washing = 0

/obj/structure/machinery/shower/Initialize()
	. = ..()
	create_reagents(2)

//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "mist"
	layer = FLY_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/machinery/shower/attack_hand(mob/M as mob)
	on = !on
	update_icon()
	if(on)
		start_processing()
		if (M.loc == loc)
			wash(M)
			check_heat(M)
		for (var/atom/movable/G in src.loc)
			G.clean_blood()
	else
		stop_processing()

/obj/structure/machinery/shower/attackby(obj/item/I as obj, mob/user as mob)
	if(I.type == /obj/item/device/analyzer)
		to_chat(user, SPAN_NOTICE("The water temperature seems to be [watertemp]."))
	if(HAS_TRAIT(I, TRAIT_TOOL_WRENCH))
		to_chat(user, SPAN_NOTICE("You begin to adjust the temperature valve with \the [I]."))
		if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			switch(watertemp)
				if("normal")
					watertemp = "freezing"
				if("freezing")
					watertemp = "boiling"
				if("boiling")
					watertemp = "normal"
			user.visible_message(SPAN_NOTICE("[user] adjusts the shower with \the [I]."), SPAN_NOTICE("You adjust the shower with \the [I]."))
			add_fingerprint(user)

/obj/structure/machinery/shower/update_icon() //this is terribly unreadable, but basically it makes the shower mist up
	overlays.Cut() //once it's been on for a while, in addition to handling the water overlay.
	QDEL_NULL(mymist)

	if(on)
		overlays += image('icons/obj/structures/props/watercloset.dmi', src, "water", MOB_LAYER + 1, dir)
		if(watertemp == "freezing")
			return
		if(!ismist)
			spawn(50)
				if(src && on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else
			ismist = 1
			mymist = new /obj/effect/mist(loc)
	else if(ismist)
		ismist = 1
		mymist = new /obj/effect/mist(loc)
		spawn(250)
			if(src && !on)
				QDEL_NULL(mymist)
				ismist = 0

/obj/structure/machinery/shower/Crossed(atom/movable/O)
	..()
	wash(O)
	if(ismob(O))
		mobpresent++
		check_heat(O)

/obj/structure/machinery/shower/Uncrossed(atom/movable/O)
	if(ismob(O))
		mobpresent--
	..()

//Yes, showers are super powerful as far as washing goes.
/obj/structure/machinery/shower/proc/wash(atom/movable/O as obj|mob)
	if(!on) return


	if(isliving(O))
		var/mob/living/L = O
		L.ExtinguishMob()
		L.fire_stacks = -20 //Douse ourselves with water to avoid fire more easily
		to_chat(L, SPAN_WARNING("You've been drenched in water!"))
		if(iscarbon(O))
			var/mob/living/carbon/M = O
			if(M.r_hand)
				M.r_hand.clean_blood()
			if(M.l_hand)
				M.l_hand.clean_blood()
			if(M.back)
				if(M.back.clean_blood())
					M.update_inv_back(0)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/washgloves = 1
				var/washshoes = 1
				var/washmask = 1
				var/washears = 1
				var/washglasses = 1

				if(H.wear_suit)
					washgloves = !(H.wear_suit.flags_inv_hide & HIDEGLOVES)
					washshoes = !(H.wear_suit.flags_inv_hide & HIDESHOES)

				if(H.head)
					washmask = !(H.head.flags_inv_hide & HIDEMASK)
					washglasses = !(H.head.flags_inv_hide & HIDEEYES)
					washears = !(H.head.flags_inv_hide & HIDEEARS)

				if(H.wear_mask)
					if (washears)
						washears = !(H.wear_mask.flags_inv_hide & HIDEEARS)
					if (washglasses)
						washglasses = !(H.wear_mask.flags_inv_hide & HIDEEYES)

				if(H.head)
					if(H.head.clean_blood())
						H.update_inv_head()
				if(H.wear_suit)
					if(H.wear_suit.clean_blood())
						H.update_inv_wear_suit()
				else if(H.w_uniform)
					if(H.w_uniform.clean_blood())
						H.update_inv_w_uniform()
				if(H.gloves && washgloves)
					if(H.gloves.clean_blood())
						H.update_inv_gloves()
				if(H.shoes && washshoes)
					if(H.shoes.clean_blood())
						H.update_inv_shoes()
				if(H.wear_mask && washmask)
					if(H.wear_mask.clean_blood())
						H.update_inv_wear_mask()
				if(H.glasses && washglasses)
					if(H.glasses.clean_blood())
						H.update_inv_glasses()
				if((H.wear_l_ear || H.wear_r_ear) && washears)
					if((H.wear_l_ear && H.wear_l_ear.clean_blood()) ||(H.wear_r_ear && H.wear_r_ear.clean_blood()))
						H.update_inv_ears()
				if(H.belt)
					if(H.belt.clean_blood())
						H.update_inv_belt()
				H.clean_blood(washshoes)
			else
				if(M.wear_mask) //if the mob is not human, it cleans the mask without asking for bitflags
					if(M.wear_mask.clean_blood())
						M.update_inv_wear_mask()
				M.clean_blood()
		else
			O.clean_blood()

	if(isturf(loc))
		var/turf/tile = loc
		tile.clean_blood()
		for(var/obj/effect/E in tile)
			if(istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
				qdel(E)

/obj/structure/machinery/shower/process()
	if(!on) return
	wash_floor()
	if(!mobpresent) return
	for(var/mob/living/carbon/C in loc)
		check_heat(C)

/obj/structure/machinery/shower/proc/wash_floor()
	if(!ismist && is_washing)
		return
	is_washing = 1
	var/turf/T = get_turf(src)
// reagents.add_reagent("water", 2)
	T.clean(src)
	addtimer(VARSET_CALLBACK(src, is_washing, FALSE), 10 SECONDS)

/obj/structure/machinery/shower/proc/check_heat(mob/M as mob)
	if(!on || watertemp == "normal") return
	if(iscarbon(M))
		var/mob/living/carbon/C = M

		if(watertemp == "freezing")
			C.bodytemperature = max(80, C.bodytemperature - 80)
			C.recalculate_move_delay = TRUE
			to_chat(C, SPAN_WARNING("The water is freezing!"))
			return
		if(watertemp == "boiling")
			C.bodytemperature = min(500, C.bodytemperature + 35)
			C.recalculate_move_delay = TRUE
			C.apply_damage(5, BURN)
			to_chat(C, SPAN_DANGER("The water is searing!"))
			return



/obj/item/toy/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~" //thanks doohl
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"



/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "sink_emptied_animation"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	var/busy = FALSE //Something's being washed at the moment

/obj/structure/sink/Initialize()
	..()
	if(prob(50))
		icon_state = "sink_emptied"



/obj/structure/sink/proc/stop_flow() //sets sink animation to normal sink (without running water)

	if(prob(50))
		icon_state = "sink_emptied_animation"
	else
		icon_state = "sink_emptied"
	flick("sink_animation_empty", src)



/obj/structure/sink/attack_hand(mob/user)
	if(isRemoteControlling(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, SPAN_DANGER("Someone's already washing here."))
		return

	to_chat(usr, SPAN_NOTICE(" You start washing your hands."))
	flick("sink_animation_fill", src) //<- play the filling animation then automatically switch back to the loop
	icon_state = "sink_animation_fill_loop" //<- set it to the loop
	addtimer(CALLBACK(src, PROC_REF(stop_flow)), 6 SECONDS)
	playsound(loc, 'sound/effects/sinkrunning.ogg', 25, TRUE)

	busy = TRUE
	sleep(40)
	busy = FALSE

	if(!Adjacent(user)) return //Person has moved away from the sink

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in viewers(src, null))
		V.show_message(SPAN_NOTICE("[user] washes their hands using \the [src]."), SHOW_MESSAGE_VISIBLE)


/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob)
	if(busy)
		to_chat(user, SPAN_DANGER("Someone's already washing here."))
		return

	var/obj/item/reagent_container/RG = O
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message(SPAN_NOTICE("[user] fills \the [RG] using \the [src]."),SPAN_NOTICE("You fill \the [RG] using \the [src]."))
		return

	else if (istype(O, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.apply_effect(10, STUN)
				user.stuttering = 10
				user.apply_effect(10, WEAKEN)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				user.visible_message( \
					SPAN_DANGER("[user] was stunned by \his wet [O]!"), \
					SPAN_DANGER("You were stunned by your wet [O]!"))
				return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, SPAN_NOTICE(" You start washing \the [I]."))

	busy = TRUE
	sleep(40)
	busy = FALSE

	if(user.loc != location) return //User has moved
	if(!I) return //Item's been destroyed while washing
	if(user.get_active_hand() != I) return //Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		SPAN_NOTICE("[user] washes \a [I] using \the [src]."), \
		SPAN_NOTICE("You wash \a [I] using \the [src]."))


/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"


/obj/structure/sink/puddle //splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"

/obj/structure/sink/puddle/attack_hand(mob/M as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/sink/puddle/attackby(obj/item/O as obj, mob/user as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"
