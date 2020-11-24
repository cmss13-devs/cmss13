/obj/structure/barricade/metal
	name = "metal barricade"
	desc = "A sturdy and easily assembled barricade made of metal plates, often used for quick fortifications. Use a blowtorch to repair."
	icon_state = "metal_0"
	health = 450
	maxhealth = 450
	crusher_resistant = TRUE
	barricade_resistance = 10
	stack_type = /obj/item/stack/sheet/metal
	debris = list(/obj/item/stack/sheet/metal)
	stack_amount = 5
	destroyed_stack_amount = 2
	barricade_hitsound = "sound/effects/metalhit.ogg"
	barricade_type = "metal"
	can_wire = TRUE
	bullet_divider = 5
	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines
	var/upgrade = null

/obj/structure/barricade/metal/examine(mob/user)
	..()
	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			to_chat(user, SPAN_INFO("The protection panel is still tighly screwed in place."))
		if(BARRICADE_BSTATE_UNSECURED)
			to_chat(user, SPAN_INFO("The protection panel has been removed, you can see the anchor bolts."))
		if(BARRICADE_BSTATE_MOVABLE)
			to_chat(user, SPAN_INFO("The protection panel has been removed and the anchor bolts loosened. It's ready to be taken apart."))

	switch(upgrade)
		if(BARRICADE_UPGRADE_BURN)
			to_chat(user, SPAN_NOTICE("The cade is protected by a biohazardous upgrade."))
		if(BARRICADE_UPGRADE_BRUTE)
			to_chat(user, SPAN_NOTICE("The cade is protected by a reinforced upgrade."))
		if(BARRICADE_UPGRADE_EXPLOSIVE)
			to_chat(user, SPAN_NOTICE("The cade is protected by an explosive upgrade."))

/obj/structure/barricade/metal/attackby(obj/item/W, mob/user)
	if(iswelder(W))
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("You're not trained to repair [src]..."))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(damage_state == BARRICADE_DMG_HEAVY)
			to_chat(user, SPAN_WARNING("[src] has sustained too much structural damage to be repaired."))
			return

		if(health == maxhealth)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		if(WT.remove_fuel(1, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
			SPAN_NOTICE("You begin repairing the damage to [src]."))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
				SPAN_NOTICE("You repair [src]."))
				user.count_niche_stat(STATISTICS_NICHE_REPAIR_CADES)
				update_health(-200)
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			else
				WT.remove_fuel(-1)
		return

	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED) //Fully constructed step. Use screwdriver to remove the protection panels to reveal the bolts
			if(isscrewdriver(W))
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to touch [src]..."))
					return
				if(user.action_busy)
					return
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] removes [src]'s protection panel."),
				SPAN_NOTICE("You remove [src]'s protection panels, exposing the anchor bolts."))
				build_state = BARRICADE_BSTATE_UNSECURED
				return

			if(istype(W, /obj/item/stack/sheet/metal))
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to touch [src]..."))
					return
				if(upgraded)
					to_chat(user, SPAN_NOTICE("This barricade is already upgraded."))
					return
				var/obj/item/stack/sheet/metal/M = W
				upgrade = input(user, "Choose an upgrade to apply to the barricade") in list(BARRICADE_UPGRADE_BURN, BARRICADE_UPGRADE_BRUTE, BARRICADE_UPGRADE_EXPLOSIVE, "cancel")
				if(!user.Adjacent(src))
					to_chat(user, SPAN_NOTICE("You are too far away!"))
					return
				if(upgraded)
					to_chat(user, SPAN_NOTICE("This barricade is already upgraded."))
					return
				if(M.get_amount() < 2)
					to_chat(user, SPAN_NOTICE("You lack the required metal."))
					return

				switch(upgrade)
					if(BARRICADE_UPGRADE_BURN)
						burn_multiplier = 0.5
						brute_multiplier = 1.5
						upgraded = BARRICADE_UPGRADE_BURN
						to_chat(user, SPAN_NOTICE("You applied a biohazardous upgrade."))
					if(BARRICADE_UPGRADE_BRUTE)
						brute_multiplier = 0.5
						burn_multiplier = 1.5
						upgraded = BARRICADE_UPGRADE_BRUTE
						to_chat(user, SPAN_NOTICE("You applied a reinforced upgrade."))
					if(BARRICADE_UPGRADE_EXPLOSIVE)
						explosive_multiplier = 0.5
						upgraded = BARRICADE_UPGRADE_EXPLOSIVE
						to_chat(user, SPAN_NOTICE("You applied an explosive upgrade."))
					if("cancel")
						return

				M.use(2)
				user.count_niche_stat(STATISTICS_NICHE_UPGRADE_CADES)
				update_icon()
				return

			if(ismultitool(W))
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to touch [src]..."))
					return
				if(user.action_busy || !upgraded)
					return
				if(!do_after(user, 5, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] strips off [src]'s upgrade."),
					SPAN_NOTICE("You strip off [src]'s upgrade, making it a normal cade."))
				upgraded = null
				explosive_multiplier = initial(explosive_multiplier)
				brute_multiplier = initial(brute_multiplier)
				burn_multiplier = initial(burn_multiplier)
				new stack_type (loc, 1)
				update_icon()
				return

		if(BARRICADE_BSTATE_UNSECURED) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			if(isscrewdriver(W))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] set [src]'s protection panel back."),
				SPAN_NOTICE("You set [src]'s protection panel back."))
				build_state = BARRICADE_BSTATE_SECURED
				return
			if(iswrench(W))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to disassemble [src]..."))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] loosens [src]'s anchor bolts."),
				SPAN_NOTICE("You loosen [src]'s anchor bolts."))
				anchored = FALSE
				build_state = BARRICADE_BSTATE_MOVABLE
				update_icon() //unanchored changes layer
				return
		if(BARRICADE_BSTATE_MOVABLE) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to resecure anchor bolts
			if(iswrench(W))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				for(var/obj/structure/barricade/B in loc)
					if(B != src && B.dir == dir)
						to_chat(user, SPAN_WARNING("There's already a barricade here."))
						return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] secures [src]'s anchor bolts."),
				SPAN_NOTICE("You secure [src]'s anchor bolts."))
				build_state = BARRICADE_BSTATE_UNSECURED
				anchored = TRUE
				update_icon() //unanchored changes layer
				return
			if(iscrowbar(W))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to disassemble [src]..."))
					return
				user.visible_message(SPAN_NOTICE("[user] starts unseating [src]'s panels."),
				SPAN_NOTICE("You start unseating [src]'s panels."))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					user.visible_message(SPAN_NOTICE("[user] takes [src]'s panels apart."),
					SPAN_NOTICE("You take [src]'s panels apart."))
					playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
					destroy(TRUE) //Note : Handles deconstruction too !
				return

	. = ..()


/obj/structure/barricade/metal/wired/New()
	maxhealth += 50
	update_health(-50)
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()
	. = ..()

/obj/structure/barricade/metal/wired/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	flags_can_pass_front_temp &= ~PASS_OVER_THROW_MOB
	flags_can_pass_behind_temp &= ~PASS_OVER_THROW_MOB
