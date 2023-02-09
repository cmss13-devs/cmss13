
/obj/structure/machinery/gibber
	name = "Gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "grinder"
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/mob/living/occupant // Mob who has been put inside
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 500

/obj/structure/machinery/gibber/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

//auto-gibs anything that bumps into it
/obj/structure/machinery/gibber/autogibber
	var/turf/input_plate

/obj/structure/machinery/gibber/autogibber/New()
	..()
	spawn(5)
		for(var/i in cardinal)
			var/obj/structure/machinery/mineral/input/input_obj = locate( /obj/structure/machinery/mineral/input, get_step(loc, i) )
			if(input_obj)
				if(isturf(input_obj.loc))
					input_plate = input_obj.loc
					qdel(input_obj)
					break

		if(!input_plate)
			log_misc("a [src] didn't find an input plate.")
			return

/obj/structure/machinery/gibber/autogibber/Collided(atom/A)
	if(!input_plate) return

	if(ismob(A))
		var/mob/M = A

		if(M.loc == input_plate
		)
			M.forceMove(src)
			M.gib()


/obj/structure/machinery/gibber/New()
	..()
	overlays += image('icons/obj/structures/machinery/kitchen.dmi', "grjam")

/obj/structure/machinery/gibber/update_icon()
	overlays.Cut()
	if (dirty)
		overlays += image('icons/obj/structures/machinery/kitchen.dmi', "grbloody")
	if(inoperable())
		return
	if (!occupant)
		overlays += image('icons/obj/structures/machinery/kitchen.dmi', "grjam")
	else if (operating)
		overlays += image('icons/obj/structures/machinery/kitchen.dmi', "gruse")
	else
		overlays += image('icons/obj/structures/machinery/kitchen.dmi', "gridle")

/obj/structure/machinery/gibber/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE)) return
	go_out()


/obj/structure/machinery/gibber/attack_hand(mob/user as mob)
	if(inoperable())
		return
	if(operating)
		to_chat(user, SPAN_DANGER("It's locked and running"))
		return
	else
		startgibbing(user)

/obj/structure/machinery/gibber/attackby(obj/item/grab/G as obj, mob/user as mob)
	if(occupant)
		to_chat(user, SPAN_WARNING("The gibber is full, empty it first!"))
		return

	if(HAS_TRAIT(G, TRAIT_TOOL_WRENCH))
		. = ..()
		return

	if(!(istype(G, /obj/item/grab)) )
		to_chat(user, SPAN_WARNING("This item is not suitable for the gibber!"))
		return

	if( !iscarbon(G.grabbed_thing) && !istype(G.grabbed_thing, /mob/living/simple_animal) )
		to_chat(user, SPAN_WARNING("This item is not suitable for the gibber!"))
		return
	var/mob/living/M = G.grabbed_thing
	if(user.grab_level < GRAB_AGGRESSIVE && !istype(G.grabbed_thing, /mob/living/carbon/xenomorph))
		to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
		return

	if(M.abiotic(1))
		to_chat(user, SPAN_WARNING("Subject may not have abiotic items on."))
		return

	user.visible_message(SPAN_DANGER("[user] starts to put [M] into the gibber!"))
	add_fingerprint(user)
	if(do_after(user, 3 SECONDS * user.get_skill_duration_multiplier(SKILL_DOMESTIC), INTERRUPT_ALL, BUSY_ICON_HOSTILE) && G && G.grabbed_thing && !occupant)
		user.visible_message(SPAN_DANGER("[user] stuffs [M] into the gibber!"))
		M.forceMove(src)
		occupant = M
		update_icon()

/obj/structure/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "Empty Gibber"
	set src in oview(1)

	if (usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)
	return

/obj/structure/machinery/gibber/proc/go_out()
	if (!occupant)
		return
	for(var/obj/O in src)
		O.forceMove(loc)
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	update_icon()
	return


/obj/structure/machinery/gibber/proc/startgibbing(mob/user as mob)
	if(operating)
		return
	if(!occupant)
		visible_message(SPAN_DANGER("You hear a loud metallic grinding sound."))
		return
	use_power(1000)
	visible_message(SPAN_DANGER("You hear a loud squelchy grinding sound."))
	operating = 1
	update_icon()

	var/totalslabs = 2

	var/obj/item/reagent_container/food/snacks/meat/meat_template = /obj/item/reagent_container/food/snacks/meat/monkey
	if(istype(occupant, /mob/living/carbon/xenomorph))
		var/mob/living/carbon/xenomorph/X = occupant
		meat_template = /obj/item/reagent_container/food/snacks/meat/xenomeat
		totalslabs = 1
		if(X.caste_type == XENO_CASTE_QUEEN)//have to do queen and predalien first because they are T0 and T1
			totalslabs = 5
		else
			if(X.caste_type == XENO_CASTE_PREDALIEN)
				totalslabs = 6
			else
				totalslabs += X.tier
	else
		if(istypestrict(occupant, /mob/living/carbon/human))
			meat_template = /obj/item/reagent_container/food/snacks/meat/human
			totalslabs = 3

	var/obj/item/reagent_container/food/snacks/meat/allmeat[totalslabs]
	for(var/i in 1 to totalslabs)
		var/obj/item/reagent_container/food/snacks/meat/newmeat
		newmeat = new meat_template
		newmeat.made_from_player = occupant.real_name + "-"
		newmeat.name = newmeat.made_from_player + newmeat.name
		allmeat[i] = newmeat

		if(src.occupant.client) // Gibbed a cow with a client in it? log that shit
			src.occupant.attack_log += "\[[time_stamp()]\] Was gibbed by <b>[key_name(user)]</b>"
			user.attack_log += "\[[time_stamp()]\] Gibbed <b>[key_name(occupant)]</b>"
			msg_admin_attack("[key_name(user)] gibbed [key_name(occupant)] in [user.loc.name] ([user.x], [user.y], [user.z]).", user.x, user.y, user.z)

		src.occupant.death(create_cause_data("gibber", user), TRUE)
		src.occupant.ghostize()

	QDEL_NULL(occupant)

	addtimer(CALLBACK(src, PROC_REF(create_gibs), totalslabs, allmeat), gibtime)

/obj/structure/machinery/gibber/proc/create_gibs(totalslabs, list/obj/item/reagent_container/food/snacks/allmeat)
	playsound(loc, 'sound/effects/splat.ogg', 25, 1)
	operating = FALSE
	for (var/i in 1 to totalslabs)
		var/obj/item/meatslab = allmeat[i]
		var/turf/Tx = locate(x - i, y, z)
		meatslab.forceMove(loc)
		meatslab.throw_atom(Tx, i, SPEED_FAST, src)
		if (!Tx.density)
			if(istype(meatslab, /obj/item/reagent_container/food/snacks/meat/xenomeat))
				new /obj/effect/decal/cleanable/blood/gibs/xeno(Tx)
			else
				new /obj/effect/decal/cleanable/blood/gibs(Tx)
	operating = FALSE
	update_icon()


