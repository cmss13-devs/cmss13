//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * 		Wrench
 * 		Screwdriver
 * 		Wirecutters
 * 		Blowtorch
 * 		Crowbar
 */

/*
 * Wrench
 */
/obj/item/tool/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "wrench"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 5.0
	throwforce = 7.0
	w_class = SIZE_SMALL
	matter = list("metal" = 150)
	
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")


/*
 * Screwdriver
 */
/obj/item/tool/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "screwdriver"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 5.0
	w_class = SIZE_TINY
	throwforce = 5.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 75)
	attack_verb = list("stabbed")

/obj/item/tool/screwdriver/Initialize()
	. = ..()
	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	return

/obj/item/tool/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))	
		return ..()
	if(user.zone_selected != "eyes") // && user.zone_selected != "head")
		return ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			var/safety = H.get_eye_protection()
			if(!safety)
				to_chat(user, SPAN_DANGER("You stab [H] in the eyes with the [src]!"))
				visible_message(SPAN_DANGER("[user] stabs [H] in the eyes with the [src]!"))
				E.damage += rand(8,20)
	return ..()

/*
 * Wirecutters
 */
/obj/item/tool/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "cutters"
	item_state = "cutters"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 6.0
	throw_speed = SPEED_FAST
	throw_range = 9
	w_class = SIZE_SMALL
	matter = list("metal" = 80)
	
	attack_verb = list("pinched", "nipped")
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 1


/obj/item/tool/wirecutters/attack(mob/living/carbon/C, mob/user)
	if((C.handcuffed) && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		user.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		C.handcuff_update()
		return
	else
		..()

/*
 * Blowtorch
 */
/obj/item/tool/weldingtool
	name = "blowtorch"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "welder"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL

	//Cost to make in the autolathe
	matter = list("metal" = 70, "glass" = 30)

	//R&D tech level
	

	//blowtorch specific stuff
	var/welding = 0 	//Whether or not the blowtorch is off(0), on(1) or currently welding(2)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold
	var/weld_tick = 0	//Used to slowly deplete the fuel when the tool is left on.

/obj/item/tool/weldingtool/Initialize()
	. = ..()
	create_reagents(max_fuel)
	reagents.add_reagent("fuel", max_fuel)
	return


/obj/item/tool/weldingtool/Dispose()
	if(welding)
		if(ismob(loc))
			loc.SetLuminosity(-2)
		else
			SetLuminosity(0)
		processing_objects.Remove(src)
	. = ..()

/obj/item/tool/weldingtool/examine(mob/user)
	..()
	to_chat(user, "It contains [get_fuel()]/[max_fuel] units of fuel!")



/obj/item/tool/weldingtool/process()
	if(disposed)
		processing_objects.Remove(src)
		return
	if(welding)
		if(++weld_tick >= 20)
			weld_tick = 0
			remove_fuel(1)
	else //should never be happening, but just in case
		toggle(TRUE)


/obj/item/tool/weldingtool/attack(mob/M, mob/user)

	if(hasorgans(M))
		var/mob/living/carbon/human/H = M
		var/obj/limb/S = H.get_limb(user.zone_selected)

		if (!S) return
		if(!(S.status & LIMB_ROBOT) || user.a_intent != "help")
			return ..()

		if(user.action_busy)
			return
		var/self_fixing = FALSE
		
		if(H.species.flags & IS_SYNTHETIC && M == user)
			self_fixing = TRUE

		if(S.brute_dam && welding)
			remove_fuel(1,user)
			if(self_fixing)
				user.visible_message(SPAN_WARNING("\The [user] begins fixing some dents on their [S.display_name]."), \
					SPAN_WARNING("You begin to carefully patch some dents on your [S.display_name] so as not to void your warranty."))
				if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
					return

			S.heal_damage(15,0,0,1)
			H.pain.recalculate_pain()
			H.UpdateDamageIcon()
			user.visible_message(SPAN_WARNING("\The [user] patches some dents on \the [H]'s [S.display_name] with \the [src]."), \
								SPAN_WARNING("You patch some dents on \the [H]'s [S.display_name] with \the [src]."))
			return
		else
			to_chat(user, SPAN_WARNING("Nothing to fix!"))

	else
		return ..()

/obj/item/tool/weldingtool/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		if(!welding)
			O.reagents.trans_to(src, max_fuel)
			weld_tick = 0
			user.visible_message(SPAN_NOTICE("[user] refills [src]."), \
			SPAN_NOTICE("You refill [src]."))
			playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
		else
			message_staff("[key_name_admin(user)] triggered a fueltank explosion with a blowtorch.")
			log_game("[key_name(user)] triggered a fueltank explosion with a blowtorch.")
			to_chat(user, SPAN_DANGER("You begin welding on the fueltank, and in a last moment of lucidity realize this might not have been the smartest thing you've ever done."))
			var/obj/structure/reagent_dispensers/fueltank/tank = O
			tank.explode()
		return
	if (welding)
		remove_fuel(1)

		if(isliving(O))
			var/mob/living/L = O
			if (raiseEventSync(L, EVENT_PREIGNITION_CHECK) != HALTED)
				L.IgniteMob()
	return


/obj/item/tool/weldingtool/attack_self(mob/user as mob)
	toggle()
	return

//Returns the amount of fuel in the welder
/obj/item/tool/weldingtool/proc/get_fuel()
	if(!reagents)
		return 0
	return reagents.get_reagent_amount("fuel")


//Removes fuel from the blowtorch. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/tool/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding || !check_fuel())
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		check_fuel()
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			to_chat(M, SPAN_NOTICE("You need more welding fuel to complete this task."))
		return 0

//Returns whether or not the blowtorch is currently on.
/obj/item/tool/weldingtool/proc/isOn()
	return src.welding

//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/tool/weldingtool/proc/check_fuel()
	if((get_fuel() <= 0) && welding)
		toggle(TRUE)
		return 0
	return 1


//Toggles the welder off and on
/obj/item/tool/weldingtool/proc/toggle(var/message = 0)
	var/mob/M
	if(ismob(loc))
		M = loc
	if(!welding)
		if(get_fuel() > 0)
			playsound(loc, 'sound/items/weldingtool_on.ogg', 25)
			welding = 1
			if(M)
				to_chat(M, SPAN_NOTICE("You switch [src] on."))
				M.SetLuminosity(2)
			else
				SetLuminosity(2)
			weld_tick += 8 //turning the tool on does not consume fuel directly, but it advances the process that regularly consumes fuel.
			force = 15
			damtype = "fire"
			icon_state = "welder1"
			w_class = SIZE_LARGE
			heat_source = 3800
			processing_objects.Add(src)
		else
			if(M)
				to_chat(M, SPAN_WARNING("[src] needs more fuel!"))
			return
	else
		playsound(loc, 'sound/items/weldingtool_off.ogg', 25)
		force = 3
		damtype = "brute"
		icon_state = "welder"
		welding = 0
		w_class = initial(w_class)
		heat_source = 0
		if(M)
			if(!message)
				to_chat(M, SPAN_NOTICE("You switch [src] off."))
			else
				to_chat(M, SPAN_WARNING("[src] shuts off!"))
			M.SetLuminosity(-2)
			if(M.r_hand == src)
				M.update_inv_r_hand()
			if(M.l_hand == src)
				M.update_inv_l_hand()
		else
			SetLuminosity(0)
		processing_objects.Remove(src)

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/tool/weldingtool/proc/eyecheck(mob/user)
	if(!iscarbon(user))	return 1
	var/safety = user.get_eye_protection()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(!E)
			return
		if(E.robotic == ORGAN_ROBOT)
			return
		switch(safety)
			if(1)
				to_chat(user, SPAN_DANGER("Your eyes sting a little."))
				E.damage += rand(1, 2)
				if(E.damage > 12)
					H.eye_blurry += rand(3,6)
			if(0)
				to_chat(user, SPAN_WARNING("Your eyes burn."))
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4,10)
			if(-1)
				to_chat(user, SPAN_WARNING("Your thermals intensify [src]'s glow. Your eyes itch and burn severely."))
				H.eye_blurry += rand(12,20)
				E.damage += rand(12, 16)
		if(safety<2)

			if (E.damage >= E.min_broken_damage)
				to_chat(H, SPAN_WARNING("You go blind! Maybe welding without protection wasn't such a great idea..."))
				return

			if (E.damage >= E.min_bruised_damage)
				to_chat(H, SPAN_WARNING("Your vision starts blurring and your eyes hurt terribly!"))
				return

			if(E.damage > 5)
				to_chat(H, SPAN_WARNING("Your eyes are really starting to hurt. This can't be good for you!"))
				return



/obj/item/tool/weldingtool/pickup(mob/user)
	if(welding && loc != user)
		SetLuminosity(0)
		user.SetLuminosity(2)


/obj/item/tool/weldingtool/dropped(mob/user)
	if(welding && loc != user)
		user.SetLuminosity(-2)
		SetLuminosity(2)
	return ..()


/obj/item/tool/weldingtool/largetank
	name = "industrial blowtorch"
	max_fuel = 40
	matter = list("metal" = 70, "glass" = 60)
	

/obj/item/tool/weldingtool/hugetank
	name = "high-capacity industrial blowtorch"
	max_fuel = 80
	w_class = SIZE_MEDIUM
	matter = list("metal" = 70, "glass" = 120)
	

/obj/item/tool/weldingtool/experimental
	name = "experimental blowtorch"
	max_fuel = 40 //?
	w_class = SIZE_MEDIUM
	matter = list("metal" = 70, "glass" = 120)
	
	var/last_gen = 0

/obj/item/tool/weldingtool/experimental/proc/fuel_gen()//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
	var/gen_amount = ((world.time-last_gen)/25)
	reagents += (gen_amount)
	if(reagents > max_fuel)
		reagents = max_fuel

/*
 * Crowbar
 */

/obj/item/tool/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "crowbar"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 5.0
	throwforce = 7.0
	item_state = "crowbar"
	w_class = SIZE_SMALL
	matter = list("metal" = 50)
	
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	pry_capable = IS_PRY_CAPABLE_CROWBAR

/obj/item/tool/crowbar/red
	icon = 'icons/obj/items/items.dmi'
	icon_state = "red_crowbar"
	item_state = "red_crowbar"





/*
 Welding backpack
*/

/obj/item/tool/weldpack
	name = "Welding kit"
	desc = "A heavy-duty, portable welding fluid carrier."
	flags_equip_slot = SLOT_BACK
	icon = 'icons/obj/items/items.dmi'
	icon_state = "welderpack"
	w_class = SIZE_LARGE
	var/max_fuel = 600 //Because the marine backpack can carry 260, and still allows you to take items, there should be a reason to still use this one.

/obj/item/tool/weldpack/Initialize()
	. = ..()
	create_reagents(max_fuel) //Lotsa refills
	reagents.add_reagent("fuel", max_fuel)

/obj/item/tool/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/T = W
		if(T.welding & prob(50))
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			to_chat(user, SPAN_DANGER("That was stupid of you."))
			explosion(get_turf(src),-1,0,2)
			if(src)
				qdel(src)
			return
		else
			if(T.welding)
				to_chat(user, SPAN_DANGER("That was close!"))
			src.reagents.trans_to(W, T.max_fuel)
			to_chat(user, SPAN_NOTICE(" Welder refilled!"))
			playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
			return
	if(istype(W, /obj/item/ammo_magazine/flamer_tank))
		return
	to_chat(user, SPAN_NOTICE("You cannot figure out how to use \the [W] with [src]."))
	return

/obj/item/tool/weldpack/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,O) <= 1 checks used previously
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to(src, max_fuel)
		to_chat(user, SPAN_NOTICE(" You crack the cap off the top of the pack and fill it back up again from the tank."))
		playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume == max_fuel)
		to_chat(user, SPAN_NOTICE(" The pack is already full!"))
		return

/obj/item/tool/weldpack/examine(mob/user)
	..()
	to_chat(user, "[reagents.total_volume] units of welding fuel left!")
