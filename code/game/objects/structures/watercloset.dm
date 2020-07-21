//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "toilet00"
	density = 0
	anchored = 1
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/toilet/New()
	..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/toilet/attack_hand(mob/living/user as mob)
	if(swirlie)
		user.visible_message(SPAN_DANGER("[user] slams the toilet seat onto [swirlie.name]'s head!"), SPAN_NOTICE("You slam the toilet seat onto [swirlie.name]'s head!"), "You hear reverberating porcelain.")
		swirlie.apply_damage(8, BRUTE)
		return

	if(cistern && !open)
		if(!contents.len)
			to_chat(user, SPAN_NOTICE("The cistern is empty."))
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.loc = get_turf(src)
			to_chat(user, SPAN_NOTICE("You find \an [I] in the cistern."))
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/toilet/update_icon()
	icon_state = "toilet[open][cistern]"

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
		if(isXeno(user)) return
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
		I.loc = src
		w_items += I.w_class
		to_chat(user, "You carefully place \the [I] into the cistern.")
		return



/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "urinal"
	density = 0
	anchored = 1

/obj/structure/urinal/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/grab))
		if(isXeno(user)) return
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
	desc = "The HS-451. Installed in the 2050s by the Weston Hygiene Division."
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "shower"
	density = 0
	anchored = 1
	use_power = 0
	var/on = 0
	var/obj/effect/mist/mymist = null
	var/ismist = 0				//needs a var so we can make it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/mobpresent = 0		//true if there is a mob on the shower's loc, this is to ease process()
	var/is_washing = 0

/obj/structure/machinery/shower/Initialize()
	..()
	create_reagents(2)

//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "mist"
	layer = FLY_LAYER
	anchored = 1
	mouse_opacity = 0

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
	if(istype(I, /obj/item/tool/wrench))
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

/obj/structure/machinery/shower/update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	overlays.Cut()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		qdel(mymist)
		mymist = null

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
				qdel(mymist)
				mymist = null
				ismist = 0

/obj/structure/machinery/shower/Crossed(atom/movable/O)
	..()
	wash(O)
	if(ismob(O))
		mobpresent += 1
		check_heat(O)

/obj/structure/machinery/shower/Uncrossed(atom/movable/O)
	if(ismob(O))
		mobpresent -= 1
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
				if(H.wear_ear && washears)
					if(H.wear_ear.clean_blood())
						H.update_inv_ears()
				if(H.belt)
					if(H.belt.clean_blood())
						H.update_inv_belt()
				H.clean_blood(washshoes)
			else
				if(M.wear_mask)						//if the mob is not human, it cleans the mask without asking for bitflags
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
	if(!mobpresent)	return
	for(var/mob/living/carbon/C in loc)
		check_heat(C)

/obj/structure/machinery/shower/proc/wash_floor()
	if(!ismist && is_washing)
		return
	is_washing = 1
	var/turf/T = get_turf(src)
//	reagents.add_reagent("water", 2)
	T.clean(src)
	spawn(100)
		is_washing = 0

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
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"



/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = 1
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/sink/attack_hand(mob/user)
	if(isremotecontrolling(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, SPAN_DANGER("Someone's already washing here."))
		return

	to_chat(usr, SPAN_NOTICE(" You start washing your hands."))

	busy = 1
	sleep(40)
	busy = 0

	if(!Adjacent(user)) return		//Person has moved away from the sink

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in viewers(src, null))
		V.show_message(SPAN_NOTICE("[user] washes their hands using \the [src]."))


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
				user.Stun(10)
				user.stuttering = 10
				user.KnockDown(10)
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

	busy = 1
	sleep(40)
	busy = 0

	if(user.loc != location) return				//User has moved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		SPAN_NOTICE("[user] washes \a [I] using \the [src]."), \
		SPAN_NOTICE("You wash \a [I] using \the [src]."))


/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"


/obj/structure/sink/puddle	//splishy splashy ^_^
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
