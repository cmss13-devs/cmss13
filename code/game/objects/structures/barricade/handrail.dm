/obj/structure/barricade/handrail
	name = "handrail"
	desc = "A railing, for your hands. Woooow."
	icon = 'icons/obj/structures/handrail.dmi'
	icon_state = "handrail_a_0"
	barricade_type = "handrail"
	health = 30 
	maxhealth = 30
	climb_delay = CLIMB_DELAY_SHORT
	stack_type = /obj/item/stack/sheet/metal
	debris = list(/obj/item/stack/sheet/metal)
	stack_amount = 2
	destroyed_stack_amount = 1
	crusher_resistant = FALSE
	can_wire = FALSE
	barricade_hitsound = "sound/effects/metalhit.ogg"
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	var/build_state = BARRICADE_BSTATE_SECURED 
	var/reinforced = FALSE	//Reinforced to be a cade or not

/obj/structure/barricade/handrail/update_icon()
	overlays.Cut()
	switch(dir)
		if(SOUTH) 
			layer = ABOVE_MOB_LAYER
		else if(NORTH) 
			layer = initial(layer) - 0.01
		else 
			layer = initial(layer)
	if(!anchored)
		layer = initial(layer)
	if(build_state == BARRICADE_BSTATE_FORTIFIED)
		if(reinforced)
			overlays += image('icons/obj/structures/handrail.dmi', icon_state = "[barricade_type]_reinforced_[damage_state]")
		else
			overlays += image('icons/obj/structures/handrail.dmi', icon_state = "[barricade_type]_welder_step")
			
	for(var/datum/effects/E in effects_list)
		if(E.icon_path && E.obj_icon_state_path)
			overlays += image(E.icon_path, icon_state = E.obj_icon_state_path)

/obj/structure/barricade/handrail/examine(mob/user)
	..()
	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			to_chat(user, SPAN_INFO("The [barricade_type] is safely secured to the ground."))
		if(BARRICADE_BSTATE_UNSECURED)
			to_chat(user, SPAN_INFO("The bolts nailing it to the ground has been unsecured."))
		if(BARRICADE_BSTATE_FORTIFIED)
			if(reinforced)
				to_chat(user, SPAN_INFO("The [barricade_type] has been reinforced with metal."))
			else
				to_chat(user, SPAN_INFO("Metal has been laid across the [barricade_type]. Weld it to secure it."))

/obj/structure/barricade/handrail/proc/reinforce()
	if(reinforced)
		if(health == maxhealth)	// Drop metal if full hp when unreinforcing
			new /obj/item/stack/sheet/metal(loc)	
		health = initial(health)
		maxhealth = initial(maxhealth)
		projectile_coverage = initial(projectile_coverage)
	else
		health = 350
		maxhealth = 350
		projectile_coverage = PROJECTILE_COVERAGE_HIGH
	reinforced = !reinforced
	update_icon()

/obj/structure/barricade/handrail/attackby(obj/item/W, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED) //Non-reinforced. Wrench to unsecure. Screwdriver to disassemble into metal. 1 metal to reinforce.
			if(iswrench(W)) // Make unsecure
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to unsecure [src]..."))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] loosens [src]'s anchor bolts."),
				SPAN_NOTICE("You loosen [src]'s anchor bolts."))
				anchored = FALSE
				build_state = BARRICADE_BSTATE_UNSECURED
				update_icon()
				return
			if(istype(W, /obj/item/stack/sheet/metal)) // Start reinforcing
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to reinforce [src]..."))
					return
				var/obj/item/stack/sheet/metal/M = W
				playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, 1)
				if(M.amount >= 1 && do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) //Shouldnt be possible, but doesnt hurt to check
					if(!M.use(1))
						return
					build_state = BARRICADE_BSTATE_FORTIFIED
					update_icon()
				else
					to_chat(user, SPAN_WARNING("You need at least one metal sheet to do this."))
				return

		if(BARRICADE_BSTATE_UNSECURED) 
			if(iswrench(W)) // Secure again
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to secure [src]..."))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] tightens [src]'s anchor bolts."),
				SPAN_NOTICE("You tighten [src]'s anchor bolts."))
				anchored = TRUE
				build_state = BARRICADE_BSTATE_SECURED
				update_icon()
				return
			if(isscrewdriver(W)) // Disassemble into metal
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to disassemble [src]..."))
					return
				user.visible_message(SPAN_NOTICE("[user] starts unscrewing [src]'s panels."),
				SPAN_NOTICE("You remove [src]'s panels and start taking it apart."))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] takes apart [src]."),
				SPAN_NOTICE("You take apart [src]."))
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				destroy(TRUE) 
				return
			
		if(BARRICADE_BSTATE_FORTIFIED) 
			if(reinforced)
				if(iscrowbar(W)) // Un-reinforce
					if(user.action_busy)
						return
					if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
						to_chat(user, SPAN_WARNING("You are not trained to unreinforce [src]..."))
						return
					playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
					if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
					user.visible_message(SPAN_NOTICE("[user] pries off [src]'s extra metal panel."),
					SPAN_NOTICE("You pry off [src]'s extra metal panel."))
					build_state = BARRICADE_BSTATE_SECURED
					reinforce()
					return
			else
				if(iswelder(W))	// Finish reinforcing
					if(user.action_busy)
						return
					if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
						to_chat(user, SPAN_WARNING("You are not trained to reinforce [src]..."))
						return
					playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
					if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
					user.visible_message(SPAN_NOTICE("[user] secures [src]'s metal panel."),
					SPAN_NOTICE("You secure [src]'s metal panel."))
					reinforce()
					return
	. = ..()

/obj/structure/barricade/handrail/type_b
	icon_state = "handrail_b_0"

/obj/structure/barricade/handrail/strata
	icon_state = "handrail_strata"

/obj/structure/barricade/handrail/medical
	icon_state = "handrail_med"

/obj/structure/barricade/handrail/kutjevo
	icon_state = "hr_kutjevo"