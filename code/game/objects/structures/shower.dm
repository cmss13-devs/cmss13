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
	/// needs a var so we can make it linger~
	var/ismist = 0
	/// freezing, normal, or boiling
	var/watertemp = "normal"
	/// true if there is a mob on the shower's loc, this is to ease process()
	var/mobpresent = 0
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
