

/obj/effect/alien/resin/special/xenomorpher
	name = XENO_STRUCTURE_XENOMORPHER
	desc = "A xenomorph structure that allows them to change their nature in exchange for biomass. Sometimes leads to unexpected results."
	icon_state = "pool_preview"
	health = 400
	var/list/mutate_options = list("Health", "Armor", "Plasma", "Damage", "Resting regeneration", "Walking regeneration", "Plasma regeneration", "Innate healing", "Pheromone strength", "Fire immunity", "Ignite immunity")
	var/mob/captured_mob
	var/xenomorpher_charges = 0


/obj/effect/alien/resin/special/xenomorpher/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user) || isobserver(user))
		if(xenomorpher_charges == 1)
			. += "Curently contains [xenomorpher_charges] body."
		else
			. += "Curently contains [xenomorpher_charges] bodies."


obj/effect/alien/resin/special/xenomorpher/proc/mutate(mob/living/carbon/xenomorph/xeno, selected_mutation)

	var/mutation_price = 1
	switch(selected_mutation)
		if("Health")
			if(xeno.maxHealth >= (xeno.caste.max_health * 1.5))
				to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
				return
			xeno.maxHealth = (xeno.caste.max_health / 20) + xeno.maxHealth

		if("Armor")
			if(xeno.armor_deflection >= 20)
				if(xeno.armor_deflection > (xeno.caste.armor_deflection * 1.5))
					to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
					return
			xeno.armor_deflection = xeno.armor_deflection + 1

		if("Plasma")
			if(xeno.plasma_max >= (xeno.caste.plasma_max * 1.5))
				to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
				return
			xeno.plasma_max = (xeno.caste.plasma_max / 20) + xeno.plasma_max

		if("Damage")
			if(xeno.melee_damage_upper >= (xeno.caste.melee_damage_upper * 1.5))
				to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
				return
			xeno.melee_damage_upper = xeno.melee_damage_upper + 1

		if("Resting regeneration")
			if(xeno.mob_heal_resting >= (xeno.caste.heal_resting * 2))
				to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
				return
			xeno.mob_heal_resting = 0.1 + xeno.mob_heal_resting

		if("Walking regeneration")
			if(xeno.mob_heal_standing >= (xeno.caste.heal_standing * 2))
				to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
				return
			xeno.mob_heal_standing = 0.1 + xeno.mob_heal_standing

		if("Innate healing")
			mutation_price += 2
			if(xenomorpher_charges < mutation_price)
				to_chat(xeno, SPAN_XENONOTICE("Not enough biomass stored for [selected_mutation] mutation. You need atleast [mutation_price] bodies stored."))
				return
			if(xeno.need_weeds == FALSE)
				to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
				return
			xeno.need_weeds = FALSE

		if("Plasma regeneration")
			if(xeno.plasma_gain >= (xeno.caste.plasma_gain * 2))
				to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
				return
			xeno.plasma_gain = 0.5 + xeno.plasma_gain

		if("Pheromone strength")
			mutation_price += 1
			if(xenomorpher_charges < mutation_price)
				to_chat(xeno, SPAN_XENONOTICE("Not enough biomass stored for [selected_mutation] mutation. You need atleast [mutation_price] bodies stored."))
				return
			if(xeno.aura_strength >= 4)
				to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated too much."))
				return
			xeno.aura_strength = 0.5 + xeno.aura_strength

	to_chat(xeno, SPAN_XENONOTICE("Your [selected_mutation] has been mutated."))
	xenomorpher_charges -= mutation_price
	if(xenomorpher_charges <= 0)
		qdel(captured_mob)
	update_icon()


obj/effect/alien/resin/special/xenomorpher/attack_alien(mob/living/carbon/xenomorph/user)
	if(isxeno(user))
		if(user.a_intent == INTENT_HARM)
			return ..()
		var/mutation_confirm = alert(user, "Are you sure you want to mutate?", "Confirmation", "No", "Yes")
		if(mutation_confirm == "Yes")
			if(xenomorpher_charges < 1 )
				to_chat(user, SPAN_XENONOTICE("Not enough biomass stored to mutate."))
				return
			if(isqueen(user))
				to_chat(user, SPAN_XENONOTICE("Don't try. You're perfect."))
				return
			if(islarva(user))
				to_chat(user, SPAN_XENONOTICE("You feel you are too weak."))
				return
			if(isfacehugger(user) || islesserdrone(user))
				to_chat(user, SPAN_XENOWARNING("Why would you do this!"))
				user.apply_damage(user.maxHealth, BURN)
				playsound(loc, 'sound/effects/acidpool.ogg', 25, 1)
				return
			var/choice = tgui_input_list(user, "Choose desired mutation", "Mutation types", mutate_options, theme = "hive_status")
			if(!choice)
				return XENO_NONCOMBAT_ACTION
			if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				return XENO_NONCOMBAT_ACTION
			if(choice)
				mutate(user, choice)

	return XENO_NONCOMBAT_ACTION


/obj/effect/alien/resin/special/xenomorpher/attack_hand(mob/living/carbon/human/user)
	user.apply_damage((user.maxHealth / 2), BURN)
	to_chat(user, SPAN_WARNING("You are splashing your hand in the acid pool, definitely bad idea"))
	playsound(loc, 'sound/effects/acidpool.ogg', 25, 1)


obj/effect/alien/resin/special/xenomorpher/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(!isxeno(user))
			if(iscarbon(G.grabbed_thing))
				to_chat(user, SPAN_WARNING("You feel that it is a bad idea."))
				return
			if(isobj(G.grabbed_thing))
				var/obj/item/O = G.grabbed_thing
				var/can_melt = 0
				can_melt = O.get_applying_acid_time()
				if(can_melt == -1)
					to_chat(user, SPAN_WARNING("You feel that it is a bad idea."))
					return
				else
					to_chat(user, SPAN_WARNING("You put [O] in the pit of acid, and watch it melts."))
					playsound(loc, 'sound/effects/acidpool.ogg', 40, 1)
					qdel(O)
			return
		if(iscarbon(G.grabbed_thing))
			var/mob/living/carbon/M = G.grabbed_thing
			if(M.buckled)
				to_chat(user, SPAN_XENOWARNING("Unbuckle first!"))
				return
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.is_revivable())
					to_chat(user, SPAN_XENOWARNING("This one is not suitable yet!"))
					return
			if(isxeno(M) && (M.stat != DEAD))
				M.apply_damage((M.maxHealth / 2), BURN)
				to_chat(M, SPAN_DANGER("\The [user] shoves you in to the pool. IT HURTS!"))
				to_chat(user, SPAN_XENOWARNING("This one is alive, it will take more time to finish the job!"))
				if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
					to_chat(M, SPAN_XENOWARNING("You have managed to escape!"))
					to_chat(user, SPAN_XENOWARNING("You lost your grip!"))
					return
			if(isxeno(M) && (M.stat == DEAD))
				to_chat(user, SPAN_XENOWARNING("This one is dead, it is of no use!"))
				return
			if(isfacehugger(M) || islesserdrone(M))
				to_chat(user, SPAN_XENOWARNING("This useless critters don't deserve to live!"))
				M.gib()
				return
			if(isqueen(M))
				to_chat(user, SPAN_XENOWARNING("You better be joking!"))
				return
			if(M == captured_mob)
				to_chat(user, SPAN_XENOWARNING("[src] is already digesting [M]!"))
				return
			if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				return
			if(ishuman(M))
				if(prob(10))
					playsound(loc, 'sound/effects/acidpool.ogg', 40, 1)
					to_chat(user, SPAN_XENOWARNING("Something went wrong!"))
					M.gib()
					return
			visible_message(SPAN_DANGER("\The [src] churns as it begins digest \the [M], spitting out foul-smelling fumes!"))
			playsound(loc, 'sound/effects/acidpool.ogg', 40, 1)
			M.death(create_cause_data("Killed in xenomorpher by [user]"))
			if(captured_mob)
				qdel(captured_mob)//Get rid of what we have there, we're overwriting it
			captured_mob = M
			captured_mob.setDir(SOUTH)
			captured_mob.moveToNullspace()
			var/matrix/MX = matrix()
			captured_mob.apply_transform(MX)
			captured_mob.pixel_x = 16
			captured_mob.pixel_y = 16
			vis_contents += captured_mob
			user.stop_pulling() // Automatically remove the grab
			xenomorpher_charges += 1
			update_icon()
		return

	return ..(I, user)