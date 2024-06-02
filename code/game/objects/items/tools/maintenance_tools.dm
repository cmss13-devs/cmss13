//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * Wrench
 * Screwdriver
 * Wirecutters
 * Blowtorch
 * Crowbar
 */

/*
 * Wrench
 */
/obj/item/tool/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "wrench"
	pickup_sound = 'sound/handling/wrench_pickup.ogg'
	drop_sound = 'sound/handling/wrench_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 7
	w_class = SIZE_SMALL
	matter = list("metal" = 150)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	inherent_traits = list(TRAIT_TOOL_WRENCH)


/*
 * Screwdriver
 */
/obj/item/tool/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwy with this."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "screwdriver"
	pickup_sound = 'sound/handling/multitool_pickup.ogg'
	drop_sound = 'sound/handling/screwdriver_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST | SLOT_EAR | SLOT_FACE
	force = 5
	w_class = SIZE_TINY
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 75)
	attack_verb = list("stabbed")
	flags_item = CAN_DIG_SHRAPNEL
	inherent_traits = list(TRAIT_TOOL_SCREWDRIVER)



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
				user.visible_message(SPAN_DANGER("[user] stabs [H] in the eyes with [src]!"),
					SPAN_DANGER("You stab [H] in the eyes with [src]!"))
				E.take_damage(rand(8,20))
	return ..()
/obj/item/tool/screwdriver/tactical
	name = "tactical screwdriver"
	desc = "Sharp, matte black, and deadly. In a pinch this will substitute for a pencil in a fight."
	force = MELEE_FORCE_TIER_2
	throwforce = MELEE_FORCE_NORMAL

/obj/item/tool/screwdriver/tactical/Initialize()
	. = ..()
	icon_state = "tac_screwdriver"

/*
 * Wirecutters
 */
/obj/item/tool/wirecutters
	name = "wirecutters"
	gender = PLURAL
	desc = "This cuts wires."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "cutters"
	item_state = "cutters"
	pickup_sound = 'sound/handling/wirecutter_pickup.ogg'
	drop_sound = 'sound/handling/wirecutter_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 6
	throw_speed = SPEED_FAST
	throw_range = 9
	w_class = SIZE_SMALL
	matter = list("metal" = 80)

	attack_verb = list("pinched", "nipped")
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 1
	inherent_traits = list(TRAIT_TOOL_WIRECUTTERS)

/obj/item/tool/wirecutters/tactical
	name = "tactical wirecutters"
	desc = "This heavy-duty pair seems more fit for cutting barbed wire, but it'll work splendidly on electrical wires."
	icon_state = "tac_cutters"

/obj/item/tool/wirecutters/attack(mob/living/carbon/C, mob/user)
	if((C.handcuffed) && (istype(C.handcuffed, /obj/item/restraint/adjustable/cable)))
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
	pickup_sound = 'sound/handling/weldingtool_pickup.ogg'
	drop_sound = 'sound/handling/weldingtool_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	var/base_icon_state = ""

	//Amount of OUCH when it's thrown
	force = 3
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL

	//Cost to make in the autolathe
	matter = list("metal" = 70, "glass" = 30)

	inherent_traits = list(TRAIT_TOOL_BLOWTORCH)

	light_range = 2
	light_power = 2

	//blowtorch specific stuff

	/// Whether or not the blowtorch is off(0), on(1) or currently welding(2)
	var/welding = 0
	/// The max amount of fuel the welder can hold
	var/max_fuel = 40
	/// Used to slowly deplete the fuel when the tool is left on.
	var/weld_tick = 0
	var/has_welding_screen = FALSE

/obj/item/tool/weldingtool/Initialize()
	. = ..()
	create_reagents(max_fuel)
	reagents.add_reagent("fuel", max_fuel)
	base_icon_state = initial(icon_state)
	return

/obj/item/tool/weldingtool/Destroy()
	if(welding)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/tool/weldingtool/get_examine_text(mob/user)
	. = ..()
	. += "It contains [get_fuel()]/[max_fuel] units of fuel!"

/obj/item/tool/weldingtool/process()
	if(QDELETED(src))
		STOP_PROCESSING(SSobj, src)
		return
	if(welding)
		if(++weld_tick >= 20)
			weld_tick = 0
			remove_fuel(1)
	else //should never be happening, but just in case
		toggle(TRUE)

/obj/item/tool/weldingtool/attack(mob/target, mob/user)

	if(ishuman(target))
		var/mob/living/carbon/human/human = target
		var/obj/limb/limb = human.get_limb(user.zone_selected)

		if (!limb) return
		if(!(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)) || user.a_intent != INTENT_HELP)
			return ..()

		if(user.action_busy)
			return
		var/self_fixing = FALSE

		if(human.species.flags & IS_SYNTHETIC && target == user)
			self_fixing = TRUE

		if(limb.brute_dam && welding)
			remove_fuel(1,user)
			if(self_fixing)
				user.visible_message(SPAN_WARNING("\The [user] begins fixing some dents on their [limb.display_name]."), \
					SPAN_WARNING("You begin to carefully patch some dents on your [limb.display_name] so as not to void your warranty."))
				if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
					return

			limb.heal_damage(15, 0, TRUE)
			human.pain.recalculate_pain()
			human.UpdateDamageIcon()
			user.visible_message(SPAN_WARNING("\The [user] patches some dents on \the [human]'s [limb.display_name] with \the [src]."), \
								SPAN_WARNING("You patch some dents on \the [human]'s [limb.display_name] with \the [src]."))
			return
		else
			to_chat(user, SPAN_WARNING("Nothing to fix!"))

	else
		if(ismob(target))
			remove_fuel(1)
		return ..()

/obj/item/tool/weldingtool/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if (istype(target, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,target) <= 1)
		if(!welding)
			target.reagents.trans_to(src, max_fuel)
			weld_tick = 0
			user.visible_message(SPAN_NOTICE("[user] refills [src]."), \
			SPAN_NOTICE("You refill [src]."))
			playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion with a blowtorch.")
			log_game("[key_name(user)] triggered a fueltank explosion with a blowtorch.")
			to_chat(user, SPAN_DANGER("You begin welding on the fueltank, and in a last moment of lucidity realize this might not have been the smartest thing you've ever done."))
			var/obj/structure/reagent_dispensers/fueltank/tank = target
			tank.explode()
		return
	if (welding)
		if(isliving(target))
			var/mob/living/L = target
			L.IgniteMob()


/obj/item/tool/weldingtool/attack_self(mob/user)
	..()
	toggle()

/obj/item/tool/weldingtool/turn_light(mob/user, toggle_on)
	. = ..()
	if(. == NO_LIGHT_STATE_CHANGE)
		return

	set_light_on(toggle_on)

//Returns the amount of fuel in the welder
/obj/item/tool/weldingtool/proc/get_fuel()
	if(!reagents)
		return 0
	return reagents.get_reagent_amount("fuel")


//Removes fuel from the blowtorch. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/tool/weldingtool/proc/remove_fuel(amount = 1, mob/M)
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
/obj/item/tool/weldingtool/proc/toggle(message = 0)
	var/mob/M
	if(ismob(loc))
		M = loc
	if(!welding)
		if(get_fuel() > 0)
			playsound(loc, 'sound/items/weldingtool_on.ogg', 25)
			welding = 1
			if(M)
				to_chat(M, SPAN_NOTICE("You switch [src] on."))
			turn_light((M ? M : null), toggle_on = TRUE)
			weld_tick += 8 //turning the tool on does not consume fuel directly, but it advances the process that regularly consumes fuel.
			force = 15
			damtype = "fire"
			icon_state = base_icon_state + "_on"
			w_class = SIZE_LARGE
			heat_source = 3800
			START_PROCESSING(SSobj, src)
		else
			if(M)
				to_chat(M, SPAN_WARNING("[src] needs more fuel!"))
			return
	else
		playsound(loc, 'sound/items/weldingtool_off.ogg', 25)
		force = 3
		damtype = "brute"
		icon_state = base_icon_state
		welding = 0
		w_class = initial(w_class)
		heat_source = 0
		if(M)
			if(!message)
				to_chat(M, SPAN_NOTICE("You switch [src] off."))
			else
				to_chat(M, SPAN_WARNING("[src] shuts off!"))
			if(M.r_hand == src)
				M.update_inv_r_hand()
			if(M.l_hand == src)
				M.update_inv_l_hand()

		turn_light((M ? M : null), toggle_on = FALSE)

		STOP_PROCESSING(SSobj, src)

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/tool/weldingtool/proc/eyecheck(mob/user)
	if(has_welding_screen || !iscarbon(user))
		return TRUE
	var/safety = user.get_eye_protection()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(!E)
			return
		if(E.robotic == ORGAN_ROBOT)
			return
		switch(safety)
			if(EYE_PROTECTION_FLASH)
				to_chat(user, SPAN_DANGER("You see a bright light in the corner of your vision."))
				E.take_damage(rand(0, 1), TRUE)
				if(E.damage > 10)
					E.take_damage(rand(3, 5), TRUE)
			if(EYE_PROTECTION_FLAVOR)
				to_chat(user, SPAN_DANGER("Your eyes sting a little."))
				E.take_damage(rand(1, 2), TRUE)
				if(E.damage > 8) // dont abuse your funny flavor glasses
					E.take_damage(2, TRUE)
			if(EYE_PROTECTION_NONE)
				to_chat(user, SPAN_WARNING("Your eyes burn."))
				E.take_damage(rand(3, 4), TRUE)
				if(E.damage > 10)
					E.take_damage(rand(4, 10), TRUE)
			if(EYE_PROTECTION_NEGATIVE)
				to_chat(user, SPAN_WARNING("Your thermals intensify [src]'s glow. Your eyes itch and burn severely."))
				H.AdjustEyeBlur(12,20)
				E.take_damage(rand(12, 16), TRUE)

		if(safety < EYE_PROTECTION_WELDING)
			if (E.damage >= E.min_broken_damage)
				to_chat(H, SPAN_WARNING("You go blind! Maybe welding without protection wasn't such a great idea..."))
				return FALSE
			if (E.damage >= E.min_bruised_damage)
				to_chat(H, SPAN_WARNING("Your vision starts blurring and your eyes hurt terribly!"))
				return FALSE
			if(E.damage > 5)
				to_chat(H, SPAN_WARNING("Your eyes are really starting to hurt. This can't be good for you!"))
				return FALSE

/obj/item/tool/weldingtool/largetank
	name = "industrial blowtorch"
	max_fuel = 60
	matter = list("metal" = 70, "glass" = 60)
	icon_state = "welder_c"


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

/obj/item/tool/weldingtool/simple
	name = "\improper ME3 hand welder"
	desc = "A compact, handheld welding torch used by the marines of the United States Colonial Marine Corps for cutting and welding jobs on the field. Due to the small size and slow strength, its function is limited compared to a full-sized technician's blowtorch."
	max_fuel = 5
	has_welding_screen = TRUE
	inherent_traits = list(TRAIT_TOOL_SIMPLE_BLOWTORCH)
	icon_state = "welder_b"

/*
 * Crowbar
 */

/obj/item/tool/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "crowbar"
	pickup_sound = 'sound/handling/crowbar_pickup.ogg'
	drop_sound = 'sound/handling/crowbar_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 7
	item_state = "crowbar"
	w_class = SIZE_SMALL
	matter = list("metal" = 50)

	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	inherent_traits = list(TRAIT_TOOL_CROWBAR)
	pry_capable = IS_PRY_CAPABLE_CROWBAR

/obj/item/tool/crowbar/red
	icon = 'icons/obj/items/items.dmi'
	icon_state = "red_crowbar"
	item_state = "red_crowbar"

/obj/item/tool/crowbar/tactical
	name = "tactical prybar"
	desc = "Holding this makes you want to raid a townhouse filled with terrorists. Also doubles as a blunt weapon."
	icon_state = "tac_prybar"
	force = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_NORMAL

/obj/item/maintenance_jack
	name = "\improper K92 Maintenance Jack"
	desc = "A combination crowbar, wrench, and generally large bludgeoning device that comes in handy in emergencies. Can be used to disengage door jacks. Pretty hefty, though."
	icon_state = "maintenance_jack"
	item_state = "maintenance_jack"
	hitsound = "swing_hit"
	w_class = SIZE_LARGE
	force = MELEE_FORCE_STRONG
	flags_equip_slot = SLOT_SUIT_STORE
	flags_atom = FPRINT|QUICK_DRAWABLE
	pry_capable = IS_PRY_CAPABLE_FORCE //but not really
	///Whether the Maintenance Jack is on crowbar or wrench mode
	var/crowbar_mode = TRUE //False for wrench mode
	///Whether you need the "super strength" trait to pry open doors
	var/requires_superstrength_pry = TRUE
	///Whether you get the speed penalty from not having engi 3
	var/requires_skills_unbolt = TRUE
	///How long it takes (in seconds) to pry open an airlock
	var/prying_time = 3 SECONDS
	///How long it takes (in seconds) to pry open a resin door
	var/resin_prying_time = 5 SECONDS
	///How long it takes (in seconds) to unbolt an airlock
	var/unbolt_time = 5 SECONDS
	///How long extra will it take (in seconds) people who do not have engi 3 (if requires_skills_unbolt is true)
	var/unskilled_unbolt_time = 15 SECONDS

/obj/item/maintenance_jack/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_ATTACK_AIRLOCK, PROC_REF(handle_airlock_attack))

/obj/item/maintenance_jack/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Interact with the Maintenance Jack to change modes.")
	if(crowbar_mode)
		. += SPAN_NOTICE("It is set to crowbar mode, allowing you to pry open doors, provided you are strong enough. Maybe you could even use this side for surgery...")
	else
		. += SPAN_NOTICE("It is set to wrench mode, allowing you to unbolt doors, provided you are smart enough to know how.")

/obj/item/maintenance_jack/attack_self(mob/living/user)
	. = ..()
	playsound(src, 'sound/weapons/punchmiss.ogg', 15, TRUE, 3)
	if(crowbar_mode) //Switch to wrench mode | Remove bolts
		user.visible_message(SPAN_INFO("[user] changes their grip on [src]. They will now use it as a wrench."),
		SPAN_NOTICE("You change your grip on [src]. You will now use it as a wrench."))
		crowbar_mode = FALSE
		animate(src, transform = matrix(0, MATRIX_ROTATE), time = 2, easing = EASE_IN)
		animate(transform = matrix(90, MATRIX_ROTATE), time = 1)
		animate(transform = matrix(180, MATRIX_ROTATE), time = 2, easing = EASE_OUT)
		REMOVE_TRAIT(src, TRAIT_TOOL_CROWBAR, TRAIT_SOURCE_INHERENT)
		ADD_TRAIT(src, TRAIT_TOOL_WRENCH, TRAIT_SOURCE_INHERENT)
		return

	//Switch to crowbar mode | Pry open doors if super strong trait
	user.visible_message(SPAN_INFO("[user] changes their grip on [src]. They will now use it as a crowbar."),
	SPAN_NOTICE("You change your grip on [src]. You will now use it as a crowbar."))
	crowbar_mode = TRUE
	animate(src, transform = matrix(180, MATRIX_ROTATE), time = 2, easing = EASE_IN)
	animate(transform = matrix(270, MATRIX_ROTATE), time = 1)
	animate(transform = matrix(360, MATRIX_ROTATE), time = 2, easing = EASE_OUT)
	REMOVE_TRAIT(src, TRAIT_TOOL_WRENCH, TRAIT_SOURCE_INHERENT)
	ADD_TRAIT(src, TRAIT_TOOL_CROWBAR, TRAIT_SOURCE_INHERENT)

/obj/item/maintenance_jack/proc/handle_airlock_attack(source, obj/structure/machinery/door/airlock/attacked_door, mob/user)
	. = COMPONENT_CANCEL_AIRLOCK_ATTACK
	if(crowbar_mode)
		if(attacked_door.locked) //Bolted
			to_chat(user, SPAN_DANGER("You can't pry open [attacked_door] while it is bolted shut."))
			return

		if(requires_superstrength_pry)
			if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG)) //basically IS_PRY_CAPABLE_CROWBAR
				return
		if(attacked_door.heavy) //Unopenable
			to_chat(usr, SPAN_DANGER("You cannot force [attacked_door] open."))
			return
		if(user.action_busy)
			return
		if(!attacked_door.density && !attacked_door.arePowerSystemsOn()) //If its open and unpowered
			attacked_door.close(TRUE)
			return
		if(attacked_door.density && !attacked_door.arePowerSystemsOn()) // if its closed and unpowered
			attacked_door.open(TRUE)
			return
		if(!attacked_door.density) //If its open
			return

		user.visible_message(SPAN_DANGER("[user] jams [src] into [attacked_door] and starts to pry it open."),
		SPAN_DANGER("You jam [src] into [attacked_door] and start to pry it open."))
		playsound(src, "pry", 15, TRUE)
		if(!do_after(user, prying_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return

		if(!attacked_door.density)
			return
		if(attacked_door.locked)
			user.visible_message(SPAN_DANGER("[user] fails to force [attacked_door] open with [src]."),
			SPAN_DANGER("You fail to force [attacked_door] open with [src]."))
			return

		user.visible_message(SPAN_DANGER("[user] forces [attacked_door] open with [src]."),
		SPAN_DANGER("You force [attacked_door] open with [src]."))
		attacked_door.open(TRUE)
		return

	//Wrench Mode
	if(!attacked_door.locked)
		to_chat(user, SPAN_NOTICE("You cannot disable bolts on a door that is already unbolted."))
		return

	if(requires_skills_unbolt)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_MASTER)) //Engi 3 is much faster
			user.visible_message(SPAN_DANGER("[user] begins to search for [attacked_door]'s bolts!"),\
			SPAN_NOTICE("You search for [attacked_door]'s bolts."))
			if(!do_after(user, unskilled_unbolt_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL)) //Otherwise it takes an extra 15 seconds
				to_chat(user, SPAN_WARNING("You fail to find the bolts on [attacked_door]."))
				return

	user.visible_message(SPAN_DANGER("[user] begins to disable [attacked_door]'s bolts!"),\
	SPAN_NOTICE("You start to disable [attacked_door]'s bolts."))
	playsound(attacked_door, "pry", 25, TRUE)

	if(!do_after(user, unbolt_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
		to_chat(user, SPAN_WARNING("You decide not to disable the bolts on [attacked_door]."))
		return

	user.visible_message(SPAN_DANGER("[user] disables the bolts on [attacked_door]."),\
	SPAN_NOTICE("You unbolt [attacked_door]."))
	attacked_door.unlock(TRUE)
	return

/obj/item/maintenance_jack/afterattack(atom/attacked_obj, mob/living/user, proximity)
	if(!proximity)
		return

	if(istype(attacked_obj, /obj/structure/mineral_door/resin))
		var/obj/structure/mineral_door/resin/resin_door = attacked_obj

		if(resin_door)
			if(crowbar_mode)
				if(requires_superstrength_pry)
					if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG)) //basically IS_PRY_CAPABLE_CROWBAR
						return ..()
				if(resin_door.isSwitchingStates)
					return
				if(!resin_door.density || user.action_busy || user.a_intent == INTENT_HARM)
					return

				user.visible_message(SPAN_DANGER("[user] jams [src] into [resin_door] and starts to pry it open."),
				SPAN_DANGER("You jam [src] into [resin_door] and start to pry it open."))
				playsound(user, 'sound/weapons/wristblades_hit.ogg', 15, TRUE)

				if(!do_after(user, resin_prying_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					to_chat(user, SPAN_NOTICE("You stop prying [resin_door] open."))
					return

				user.visible_message(SPAN_DANGER("[user] forces [resin_door] open with [src]."),
				SPAN_DANGER("You force [resin_door] open with [src]."))
				resin_door.Open()
				return

	else if(istype(attacked_obj, /turf/open/floor))
		var/turf/open/floor/flooring = attacked_obj

		if(crowbar_mode && user.a_intent == INTENT_HELP) //Only pry flooring on help intent
			if(flooring.hull_floor) //no interaction for hulls
				return
			if(flooring.weeds)
				return attackby(src, user)

			to_chat(user, SPAN_WARNING("You forcefully pry off [flooring], destroying it in the process."))
			playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
			flooring.make_plating()
			return
	return ..()
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
	/// More robust liner I guess
	health = 75
	/// placeholder value to be replaced in init
	var/original_health = 1
	/// Because the marine backpack can carry 260, and still allows you to take items, there should be a reason to still use this one.
	var/max_fuel = 600

/obj/item/tool/weldpack/Initialize()
	. = ..()
	create_reagents(max_fuel) //Lotsa refills
	reagents.add_reagent("fuel", max_fuel)
	original_health = health

/obj/item/tool/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/T = W
		if(T.welding & prob(50))
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			to_chat(user, SPAN_DANGER("That was stupid of you."))
			reagents.source_mob = WEAKREF(user)
			if(reagents.handle_volatiles())
				qdel(src)
			return
		else
			if(T.reagents.total_volume == T.max_fuel)
				to_chat(user, SPAN_NOTICE(" \The [src] is already full!"))
				return
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

/obj/item/tool/weldpack/afterattack(obj/target as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,target) <= 1 checks used previously
		return
	if(istype(target, /obj/structure/reagent_dispensers))
		if(!(istypestrict(target, /obj/structure/reagent_dispensers/fueltank)))
			to_chat(user, SPAN_NOTICE("This must be filled with a fuel tank."))
			return
		if(reagents.total_volume < max_fuel)
			target.reagents.trans_to(src, max_fuel)
			to_chat(user, SPAN_NOTICE("You crack the cap off the top of \the [src] and fill it back up again from the tank."))
			playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
			return
		if (reagents.total_volume >= max_fuel)
			to_chat(user, SPAN_NOTICE("[src] is already full!"))
			return
	..()

/obj/item/tool/weldpack/get_examine_text(mob/user)
	. = ..()
	. += "[reagents.total_volume] units of welding fuel left!"
	if(original_health > health)
		. += "\The [src] appears to have been damaged, as the self sealing liner has been exposed."
	else
		. += "No punctures are seen on \the [src] upon closer inspection."

/obj/item/tool/weldpack/bullet_act(obj/projectile/P)
	var/damage = P.damage
	health -= damage
	..()
	healthcheck()
	return 1

/obj/item/tool/weldpack/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/item/tool/weldpack/proc/explode()
	if(reagents.handle_volatiles())
		qdel(src)
	return



/obj/item/tool/weldpack/minitank
	name = "ES-11 fuel canister"
	desc = "A robust little pressurized canister that is small enough to fit in most bags and made for use with welding fuel. Upon closer inspection there is faded text on the red tape wrapped around the tank 'WARNING: Contents under pressure! Do not puncture!' "
	icon_state = "welderpackmini"
	/// Just barely enough to be better than the satchel
	max_fuel = 120
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM
	health = 50
