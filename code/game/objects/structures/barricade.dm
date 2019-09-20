// Snow, wood, sandbags, metal, plasteel

/obj/structure/barricade
	icon = 'icons/obj/structures/barricades.dmi'
	climbable = TRUE
	anchored = TRUE
	density = 1
	throwpass = TRUE //You can throw objects over this, despite its density.
	layer = BELOW_OBJ_LAYER
	flags_atom = ON_BORDER
	climb_delay = 20 //Leaping a barricade is universally much faster than clumsily climbing on a table or rack
	var/stack_type //The type of stack the barricade dropped when disassembled if any.
	var/stack_amount = 5 //The amount of stack dropped when disassembled at full health
	var/destroyed_stack_amount //to specify a non-zero amount of stack to drop when destroyed
	health = 100 //Pretty tough. Changes sprites at 300 and 150
	var/maxhealth = 100 //Basic code functions
	var/crusher_resistant = TRUE //Whether a crusher can ram through it.
	var/barricade_resistance = 5 //How much force an item needs to even damage it at all.
	var/barricade_hitsound
	var/barricade_type = "barricade" //"metal", "plasteel", etc.
	var/can_change_dmg_state = TRUE
	var/damage_state = BARRICADE_DMG_NONE
	var/closed = FALSE
	var/can_wire = FALSE
	var/is_wired = FALSE
	var/bullet_divider = 10
	flags_barrier = HANDLE_BARRIER_CHANCE
	projectile_coverage = PROJECTILE_COVERAGE_HIGH

/obj/structure/barricade/New(loc, mob/user)
	..(loc)
	if(user)
		user.count_niche_stat(STATISTICS_NICHE_CADES)
	add_timer(CALLBACK(src, .proc/update_icon), 0)

/obj/structure/barricade/handle_barrier_chance(mob/living/M)
	return prob(max(30,(100.0*health)/maxhealth))

/obj/structure/barricade/examine(mob/user)
	..()

	if(is_wired)
		to_chat(user, SPAN_INFO("There is a length of wire strewn across the top of this barricade."))
	switch(damage_state)
		if(BARRICADE_DMG_NONE) to_chat(user, SPAN_INFO("It appears to be in good shape."))
		if(BARRICADE_DMG_SLIGHT) to_chat(user, SPAN_WARNING("It's slightly damaged, but still very functional."))
		if(BARRICADE_DMG_MODERATE) to_chat(user, SPAN_WARNING("It's quite beat up, but it's holding together."))
		if(BARRICADE_DMG_HEAVY) to_chat(user, SPAN_WARNING("It's crumbling apart, just a few more blows will tear it apart."))

/obj/structure/barricade/hitby(atom/movable/AM)
	if(AM.throwing && is_wired)
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			C.visible_message(SPAN_DANGER("The barbed wire slices into [C]!"),
			SPAN_DANGER("The barbed wire slices into you!"))
			C.apply_damage(10)
			C.KnockDown(2) //Leaping into barbed wire is VERY bad
	..()

/obj/structure/barricade/Bumped(atom/A)
	..()

	if(istype(A, /mob/living/carbon/Xenomorph/Crusher))

		var/mob/living/carbon/Xenomorph/Crusher/C = A

		if(C.charge_speed < C.charge_speed_max/2)
			return

		if(crusher_resistant)
			take_damage( 100 )

		else if(!C.stat)
			visible_message(SPAN_DANGER("[C] smashes through [src]!"))
			destroy()

/obj/structure/barricade/CheckExit(atom/movable/O, turf/target)
	if(closed)
		return 1

	if(O.throwing)
		if(is_wired && iscarbon(O)) //Leaping mob against barbed wire fails
			if(get_dir(loc, target) & dir)
				return 0
		return 1

	if(get_dir(loc, target) & dir)
		return 0
	else
		return 1

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target)
	if(closed)
		return 1

	if(mover && mover.throwing)
		if(is_wired && iscarbon(mover)) //Leaping mob against barbed wire fails
			if(get_dir(loc, target) & dir)
				return 0
		return 1

	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable objects allow you to universally climb over others
		return 1

	if(get_dir(loc, target) & dir)
		return 0
	else
		return 1

/obj/structure/barricade/attack_robot(mob/user as mob)
	return attack_hand(user)

/obj/structure/barricade/attack_animal(mob/user as mob)
	return attack_alien(user)

/obj/structure/barricade/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/zombie_claws))
		user.visible_message(SPAN_DANGER("The zombie smashed at the [src.barricade_type] barricade!"),
		SPAN_DANGER("You smack the [src.barricade_type] barricade!"))
		if(barricade_hitsound)
			playsound(src, barricade_hitsound, 25, 1)
		hit_barricade(W)
		return

	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	if(istype(W, /obj/item/stack/barbed_wire))
		var/obj/item/stack/barbed_wire/B = W
		if(can_wire)
			user.visible_message(SPAN_NOTICE("[user] starts setting up [W.name] on [src]."),
			SPAN_NOTICE("You start setting up [W.name] on [src]."))
			if(do_after(user, 20, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src) && can_wire)
				// Make sure there's still enough wire in the stack
				if(!B.use(1))
					return

				playsound(src.loc, 'sound/effects/barbed_wire_movement.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] sets up [W.name] on [src]."),
				SPAN_NOTICE("You set up [W.name] on [src]."))

				maxhealth += 50
				update_health(-50)
				can_wire = FALSE
				is_wired = TRUE
				climbable = FALSE
				update_icon()
		return

	if(istype(W, /obj/item/tool/wirecutters))
		if(is_wired)
			user.visible_message(SPAN_NOTICE("[user] begin removing the barbed wire on [src]."),
			SPAN_NOTICE("You begin removing the barbed wire on [src]."))
			if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] removes the barbed wire on [src]."),
				SPAN_NOTICE("You remove the barbed wire on [src]."))
				maxhealth -= 50
				update_health(50)
				can_wire = TRUE
				is_wired = FALSE
				climbable = TRUE
				update_icon()
				new/obj/item/stack/barbed_wire( src.loc )
		return

	if(W.force > barricade_resistance)
		..()
		if(barricade_hitsound)
			playsound(src, barricade_hitsound, 25, 1)
		hit_barricade(W)

/obj/structure/barricade/bullet_act(obj/item/projectile/P)
	bullet_ping(P)

	if (istype(P.ammo, /datum/ammo/xeno/boiler_gas))
		take_damage(50)

	else if (P.ammo.flags_ammo_behavior & AMMO_ANTISTRUCT)
		take_damage(P.damage*ANTISTRUCT_DMG_MULT_BARRICADES)

	take_damage(round(P.damage/bullet_divider))

	return TRUE

/obj/structure/barricade/destroy(deconstruct)
	if(deconstruct && is_wired)
		new /obj/item/stack/barbed_wire(loc)
	if(stack_type)
		var/stack_amt
		if(!deconstruct && destroyed_stack_amount) stack_amt = destroyed_stack_amount
		else stack_amt = round(stack_amount * (health/maxhealth)) //Get an amount of sheets back equivalent to remaining health. Obviously, fully destroyed means 0

		if(stack_amt) new stack_type (loc, stack_amt)
	qdel(src)


/obj/structure/barricade/ex_act(severity, direction)
	for(var/obj/structure/barricade/B in get_step(src,dir)) //discourage double-stacking barricades by removing health from opposing barricade
		if(B.dir == reverse_direction(dir))
			spawn(1)
			if(B)
				B.ex_act(severity, direction)
	if(health <= 0)
		var/location = get_turf(src)
		handle_debris(severity, direction)
		if(prob(50)) // no message spam pls
			src.visible_message(SPAN_WARNING("[src] blows apart in the explosion, sending shards flying!"))
		qdel(src)
		create_shrapnel(location, rand(2,5), direction, , /datum/ammo/bullet/shrapnel/light)
	else
		update_health(severity)

/obj/structure/barricade/get_explosion_resistance(direction)
	if(!density || direction == turn(dir, 90) || direction == turn(dir, -90))
		return 0
	else
		return min(health, 40)


/obj/structure/barricade/update_icon()
	overlays.Cut()
	if(!closed)
		if(can_change_dmg_state)
			icon_state = "[barricade_type]_[damage_state]"
		else
			icon_state = "[barricade_type]"
		switch(dir)
			if(SOUTH) 
				layer = ABOVE_MOB_LAYER
			else if(NORTH) 
				layer = initial(layer) - 0.01
			else 
				layer = initial(layer)
		if(!anchored)
			layer = initial(layer)
	else
		if(can_change_dmg_state)
			icon_state = "[barricade_type]_closed_[damage_state]"
		else
			icon_state = "[barricade_type]_closed"
		layer = OBJ_LAYER

	if(is_wired)
		if(!closed)
			overlays += image('icons/obj/structures/barricades.dmi', icon_state = "[src.barricade_type]_wire")
		else
			overlays += image('icons/obj/structures/barricades.dmi', icon_state = "[src.barricade_type]_closed_wire")

	..()

// This proc is called whenever the cade is moved, so I thought it was appropriate,
// especially since the barricade's direction needs to be handled when moving
// diagonally.
// However, will look into fixing bugs w/diagonal movement different if this is
// to hacky.
/obj/structure/barricade/handle_rotation()
	if (dir & EAST)
		dir = EAST
	else if(dir & WEST)
		dir = WEST
	update_icon()

/obj/structure/barricade/proc/hit_barricade(obj/item/I)
	if(istype(I, /obj/item/weapon/zombie_claws))
		take_damage( I.force * 0.5 )
	take_damage( I.force * 0.5 )

obj/structure/barricade/proc/take_damage(var/damage)
	for(var/obj/structure/barricade/B in get_step(src,dir)) //discourage double-stacking barricades by removing health from opposing barricade
		if(B.dir == reverse_direction(dir))
			B.update_health(damage)

	update_health(damage)

/obj/structure/barricade/update_health(damage, nomessage)
	health -= damage
	health = Clamp(health, 0, maxhealth)

	if(!health)
		if(!nomessage)
			visible_message(SPAN_DANGER("[src] falls apart!"))
		destroy()
		return

	update_damage_state()
	update_icon()

/obj/structure/barricade/proc/update_damage_state()
	var/health_percent = round(health/maxhealth * 100)
	switch(health_percent)
		if(0 to 25) damage_state = BARRICADE_DMG_HEAVY
		if(25 to 50) damage_state = BARRICADE_DMG_MODERATE
		if(50 to 75) damage_state = BARRICADE_DMG_SLIGHT
		if(75 to INFINITY) damage_state = BARRICADE_DMG_NONE

/obj/structure/barricade/proc/acid_smoke_damage(var/obj/effect/particle_effect/smoke/S)
	take_damage( 15 )

/obj/structure/barricade/verb/rotate()
	set name = "Rotate Barricade Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(isobserver(usr))
		return

	if(anchored)
		to_chat(usr, SPAN_WARNING("It is fastened to the floor, you can't rotate it!"))
		return 0

	dir = turn(dir, 90)
	update_icon()
	return

/obj/structure/barricade/verb/revrotate()
	set name = "Rotate Barricade Clockwise"
	set category = "Object"
	set src in oview(1)

	if(isobserver(usr))
		return

	if(anchored)
		to_chat(usr, SPAN_WARNING("It is fastened to the floor, you can't rotate it!"))
		return 0

	dir = turn(dir, 270)
	update_icon()
	return


/*----------------------*/
// SNOW
/*----------------------*/

/obj/structure/barricade/snow
	name = "snow barricade"
	desc = "A mound of snow shaped into a sloped wall. Statistically better than thin air as cover."
	icon_state = "snow_0"
	barricade_type = "snow"
	health = 75 //Actual health depends on snow layer
	maxhealth = 75
	stack_type = /obj/item/stack/snow
	debris = list(/obj/item/stack/snow)
	stack_amount = 3
	destroyed_stack_amount = 0
	can_wire = FALSE
	bullet_divider = 2

/obj/structure/barricade/snow/New(loc, mob/user, direction)
	if(direction)
		dir = direction
	..(loc, user)



//Item Attack
/obj/structure/barricade/snow/attackby(obj/item/W, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return
	//Removing the barricades
	if(istype(W, /obj/item/tool/shovel) && user.a_intent != "hurt")
		var/obj/item/tool/shovel/ET = W
		if(ET.folded)
			return
		if(user.action_busy)
			to_chat(user, SPAN_WARNING("You are already shoveling!"))
			return
		user.visible_message("[user.name] starts clearing out \the [src].","You start removing \the [src].")
		if(!do_after(user, ET.shovelspeed, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			return
		if(!ET.folded)
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [src]."))
			destroy(TRUE)
		return
	else
		. = ..()

/obj/structure/barricade/snow/hit_barricade(obj/item/I)
	switch(I.damtype)
		if("fire")
			take_damage( I.force * 0.6 )
		if("brute")
			take_damage( I.force * 0.3 )

	return


/*----------------------*/
// WOOD
/*----------------------*/

/obj/structure/barricade/wooden
	name = "wooden barricade"
	desc = "A wall made out of wooden planks nailed together. Not very sturdy, but can provide some concealment."
	icon_state = "wooden"
	health = 100
	maxhealth = 100
	layer = OBJ_LAYER
	stack_type = /obj/item/stack/sheet/wood
	debris = list(/obj/item/stack/sheet/wood)
	stack_amount = 5
	destroyed_stack_amount = 3
	barricade_hitsound = "sound/effects/woodhit.ogg"
	can_change_dmg_state = 0
	barricade_type = "wooden"
	can_wire = FALSE
	bullet_divider = 2

/obj/structure/barricade/wooden/attackby(obj/item/W as obj, mob/user as mob)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return
	if(istype(W, /obj/item/stack/sheet/wood))
		var/obj/item/stack/sheet/wood/D = W
		if(health < maxhealth)
			if(D.get_amount() < 1)
				to_chat(user, SPAN_WARNING("You need one plank of wood to repair [src]."))
				return
			visible_message(SPAN_NOTICE("[user] begins to repair [src]."))
			if(do_after(user,20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src) && health < maxhealth)
				if (D.use(1))
					health = maxhealth
					visible_message(SPAN_NOTICE("[user] repairs [src]."))
		return
	. = ..()

/obj/structure/barricade/wooden/hit_barricade(obj/item/I)
	switch(I.damtype)
		if("fire")
			take_damage( I.force * 1.5 )
		if("brute")
			take_damage( I.force * 0.75 )


/*----------------------*/
// METAL
/*----------------------*/

/obj/structure/barricade/metal
	name = "metal barricade"
	desc = "A sturdy and easily assembled barricade made of metal plates, often used for quick fortifications. Use a blowtorch to repair."
	icon_state = "metal_0"
	health = 275
	maxhealth = 275
	crusher_resistant = TRUE
	barricade_resistance = 10
	stack_type = /obj/item/stack/sheet/metal
	debris = list(/obj/item/stack/sheet/metal)
	stack_amount = 4
	destroyed_stack_amount = 2
	barricade_hitsound = "sound/effects/metalhit.ogg"
	barricade_type = "metal"
	can_wire = TRUE
	bullet_divider = 5
	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines

/obj/structure/barricade/metal/examine(mob/user)
	..()
	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			to_chat(user, SPAN_INFO("The protection panel is still tighly screwed in place."))
		if(BARRICADE_BSTATE_UNSECURED)
			to_chat(user, SPAN_INFO("The protection panel has been removed, you can see the anchor bolts."))
		if(BARRICADE_BSTATE_MOVABLE)
			to_chat(user, SPAN_INFO("The protection panel has been removed and the anchor bolts loosened. It's ready to be taken apart."))

/obj/structure/barricade/metal/attackby(obj/item/W, mob/user)

	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	if(iswelder(W))
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_METAL))
			to_chat(user, SPAN_WARNING("You're not trained to repair [src]..."))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(health <= maxhealth * 0.3)
			to_chat(user, SPAN_WARNING("[src] has sustained too much structural damage to be repaired."))
			return

		if(health == maxhealth)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
			SPAN_NOTICE("You begin repairing the damage to [src]."))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			if(do_after(user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
				SPAN_NOTICE("You repair [src]."))
				user.count_niche_stat(STATISTICS_NICHE_REPAIR_CADES)
				update_health(-150)
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		return

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED) //Fully constructed step. Use screwdriver to remove the protection panels to reveal the bolts
			if(isscrewdriver(W))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
					to_chat(user, SPAN_WARNING("You are not trained to disassemble [src]..."))
					return
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] removes [src]'s protection panel."),
				SPAN_NOTICE("You remove [src]'s protection panels, exposing the anchor bolts."))
				build_state = BARRICADE_BSTATE_UNSECURED
				return
		if(BARRICADE_BSTATE_UNSECURED) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			if(isscrewdriver(W))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
					to_chat(user, SPAN_WARNING("You are not trained to disassemble [src]..."))
					return
				user.visible_message(SPAN_NOTICE("[user] starts unseating [src]'s panels."),
				SPAN_NOTICE("You start unseating [src]'s panels."))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					user.visible_message(SPAN_NOTICE("[user] takes [src]'s panels apart."),
					SPAN_NOTICE("You take [src]'s panels apart."))
					playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
					destroy(TRUE) //Note : Handles deconstruction too !
				return

	. = ..()


/*----------------------*/
// DEPLOYABLE
/*----------------------*/

/obj/structure/barricade/deployable
	name = "portable composite barricade"
	desc = "A plasteel-carbon composite barricade. Resistant to most acids while being simple to repair. There are two pushplates that allow this barricade to fold into a neat package. Use a blowtorch to repair."
	icon_state = "folding_0"
	health = 400
	maxhealth = 400
	crusher_resistant = TRUE
	barricade_resistance = 15
	barricade_hitsound = "sound/effects/metalhit.ogg"
	barricade_type = "folding"
	can_wire = FALSE
	can_change_dmg_state = 1
	climbable = FALSE
	unacidable = 1
	anchored = TRUE
	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines

/obj/structure/barricade/deployable/examine(mob/user)
	..()
	to_chat(user, SPAN_INFO("Drag its sprite onto yourself to undeploy."))

/obj/structure/barricade/deployable/attackby(obj/item/W, mob/user)

	if(iswelder(W))
		if(user.action_busy)
			return
		var/obj/item/tool/weldingtool/WT = W
		if(health == maxhealth)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
			SPAN_NOTICE("You begin repairing the damage to [src]."))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			if(do_after(user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
				SPAN_NOTICE("You repair [src]."))
				if(health < maxhealth)
					maxhealth -= 50
					user.visible_message(SPAN_NOTICE("[src]'s structural integrity weakens."))

				update_health(-(maxhealth*0.4))
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		return
	else if(iswrench(W))
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
			to_chat(user, SPAN_WARNING("You do not know where the loosening bolts are on [src]..."))
			return
		else
			if(build_state == BARRICADE_BSTATE_UNSECURED)
				to_chat(user, SPAN_NOTICE("You tighten the bolts on [src]."))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				build_state = BARRICADE_BSTATE_SECURED
			else
				to_chat(user, SPAN_NOTICE("You loosen the bolts on [src]."))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				build_state = BARRICADE_BSTATE_UNSECURED

	else if(iscrowbar(W))
		if(build_state != BARRICADE_BSTATE_UNSECURED)
			return
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
			to_chat(user, SPAN_WARNING("You do not know how to collapse [src] using a crowbar..."))
			return
		else
			user.visible_message(SPAN_NOTICE("[user] starts collapsing [src]."), \
				SPAN_NOTICE("You begin collapsing [src]..."))
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			if(do_after(user, SECONDS_2, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				collapse(usr)
			else
				to_chat(user, SPAN_WARNING("You stop collapsing [src]."))
	. = ..()

/obj/structure/barricade/deployable/MouseDrop(obj/over_object as obj)
	if(!ishuman(usr))
		return

	if(usr.lying)
		return

	if(over_object == usr && Adjacent(usr))
		usr.visible_message(SPAN_NOTICE("[usr] starts collapsing [src]."),
			SPAN_NOTICE("You begin collapsing [src]."))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
		if(do_after(usr, SECONDS_8, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
			collapse(usr)
		else
			to_chat(usr, SPAN_WARNING("You stop collapsing [src]."))

/obj/structure/barricade/deployable/proc/collapse(mob/living/carbon/human/user)
	var/obj/item/folding_barricade/FB = new(loc)
	FB.health = health
	FB.maxhealth = maxhealth
	if(istype(user))
		user.visible_message(SPAN_NOTICE("[user] collapses [src]."),
			SPAN_NOTICE("You collapse [src]."))
		user.put_in_active_hand(FB)
	qdel(src)


//CADE IN HANDS
/obj/item/folding_barricade
	name = "MB-6 Folding Barricade"
	desc = "A folding barricade that can be used to quickly deploy an all-round resistant barricade."
	health = 400
	var/maxhealth = 400
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	icon_state = "folding"
	icon = 'icons/obj/items/marine-items.dmi'

/obj/item/folding_barricade/attack_self(mob/user as mob)
	for(var/obj/structure/barricade/B in loc)
		if(B != src && B.dir == dir)
			to_chat(user, SPAN_WARNING("There's already a barricade here."))
			return
	var/turf/open/OT = usr.loc
	if(!OT.allow_construction)
		to_chat(usr, SPAN_WARNING("The [src] must be constructed on a proper surface!"))
		return
	user.visible_message(SPAN_NOTICE("[user] begins deploying [src]."),
			SPAN_NOTICE("You begin deploying [src]."))
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	user.visible_message(SPAN_NOTICE("[user] has finished deploying [src]."),
			SPAN_NOTICE("You finish deploying [src]."))
	var/obj/structure/barricade/deployable/cade = new(user.loc)
	cade.dir = user.dir
	cade.health = health
	cade.maxhealth = maxhealth
	qdel(src)

/*----------------------*/
// PLASTEEL
/*----------------------*/

/obj/structure/barricade/plasteel
	name = "plasteel barricade"
	desc = "A very sturdy barricade made out of plasteel panels, the pinnacle of strongpoints. Use a blowtorch to repair. Can be flipped down to create a path."
	icon_state = "plasteel_closed_0"
	health = 600
	maxhealth = 600
	crusher_resistant = TRUE
	barricade_resistance = 20
	stack_type = /obj/item/stack/sheet/plasteel
	debris = list(/obj/item/stack/sheet/plasteel)
	stack_amount = 5
	destroyed_stack_amount = 2
	barricade_hitsound = "sound/effects/metalhit.ogg"
	barricade_type = "plasteel"
	density = 0
	closed = TRUE
	can_wire = TRUE

	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines
	var/tool_cooldown = 0 //Delay to apply tools to prevent spamming
	var/busy = 0 //Standard busy check
	var/linked = 0
	var/recentlyflipped = FALSE

/obj/structure/barricade/plasteel/update_icon()
	..()
	if(linked)
		for(var/direction in cardinal)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade.linked && cade.closed == src.closed)
					if(closed)
						overlays += image('icons/obj/structures/barricades.dmi', icon_state = "[src.barricade_type]_closed_connection_[get_dir(src, cade)]")
					else
						overlays += image('icons/obj/structures/barricades.dmi', icon_state = "[src.barricade_type]_connection_[get_dir(src, cade)]")
					continue


/obj/structure/barricade/plasteel/handle_barrier_chance(mob/living/M)
	if(!closed) // Closed = gate down for plasteel for some reason
		return ..()
	else
		return 0

/obj/structure/barricade/plasteel/examine(mob/user)
	..()

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			to_chat(user, SPAN_INFO("The protection panel is still tighly screwed in place."))
		if(BARRICADE_BSTATE_UNSECURED)
			to_chat(user, SPAN_INFO("The protection panel has been removed, you can see the anchor bolts."))
		if(BARRICADE_BSTATE_MOVABLE)
			to_chat(user, SPAN_INFO("The protection panel has been removed and the anchor bolts loosened. It's ready to be taken apart."))

/obj/structure/barricade/plasteel/attackby(obj/item/W, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	if(iswelder(W))
		if(busy || tool_cooldown > world.time)
			return
		tool_cooldown = world.time + 10
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_METAL))
			to_chat(user, SPAN_WARNING("You're not trained to repair [src]..."))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(health <= maxhealth * 0.3)
			to_chat(user, SPAN_WARNING("[src] has sustained too much structural damage to be repaired."))
			return

		if(health == maxhealth)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
			SPAN_NOTICE("You begin repairing the damage to [src]."))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			busy = 1
			if(do_after(user, 50, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				busy = 0
				user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
				SPAN_NOTICE("You repair [src]."))
				update_health(-150)
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			else busy = 0
		return

	switch(build_state)
		if(2) //Fully constructed step. Use screwdriver to remove the protection panels to reveal the bolts
			if(isscrewdriver(W))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return

				for(var/obj/structure/barricade/B in loc)
					if(B != src && B.dir == dir)
						to_chat(user, SPAN_WARNING("There's already a barricade here."))
						return
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] removes [src]'s protection panel."),
				SPAN_NOTICE("You remove [src]'s protection panels, exposing the anchor bolts."))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				build_state = BARRICADE_BSTATE_UNSECURED
				return
			if(iscrowbar(W))
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
					to_chat(user, SPAN_WARNING("You are not trained to modify [src]..."))
					return
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(linked)
					user.visible_message(SPAN_NOTICE("[user] removes the linking on [src]."),
					SPAN_NOTICE("You remove the linking on [src]."))
				else
					user.visible_message(SPAN_NOTICE("[user] sets up [src] for linking."),
					SPAN_NOTICE("You set up [src] for linking."))
				linked = !linked
				for(var/direction in cardinal)
					for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
						cade.update_icon()
				update_icon()
		if(1) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			if(isscrewdriver(W))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] set [src]'s protection panel back."),
				SPAN_NOTICE("You set [src]'s protection panel back."))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				build_state = BARRICADE_BSTATE_SECURED
				return
			if(iswrench(W))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] loosens [src]'s anchor bolts."),
				SPAN_NOTICE("You loosen [src]'s anchor bolts."))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				anchored = FALSE
				build_state = BARRICADE_BSTATE_MOVABLE
				update_icon() //unanchored changes layer
				return

		if(0) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to rescure anchor bolts
			if(iswrench(W))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user] secures [src]'s anchor bolts."),
				SPAN_NOTICE("You secure [src]'s anchor bolts."))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				anchored = TRUE
				build_state = BARRICADE_BSTATE_UNSECURED
				update_icon() //unanchored changes layer
				return
			if(iscrowbar(W))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				user.visible_message(SPAN_NOTICE("[user] starts unseating [src]'s panels."),
				SPAN_NOTICE("You start unseating [src]'s panels."))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				busy = 1
				if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					busy = 0
					user.visible_message(SPAN_NOTICE("[user] takes [src]'s panels apart."),
					SPAN_NOTICE("You take [src]'s panels apart."))
					playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
					destroy(TRUE) //Note : Handles deconstruction too !
				else busy = 0
				return

	. = ..()

/obj/structure/barricade/plasteel/attack_hand(mob/user as mob)
	if(isXeno(user))
		return

	if(closed)
		if(recentlyflipped)
			to_chat(user, SPAN_NOTICE("The [src] has been flipped too recently!"))
			return
		user.visible_message(SPAN_NOTICE("[user] flips [src] open."),
		SPAN_NOTICE("You flip [src] open."))
		open(src)
		recentlyflipped = TRUE
		spawn(10)
			if(istype(src, /obj/structure/barricade/plasteel))
				recentlyflipped = FALSE

	else
		if(recentlyflipped)
			to_chat(user, SPAN_NOTICE("The [src] has been flipped too recently!"))
			return
		user.visible_message(SPAN_NOTICE("[user] flips [src] closed."),
		SPAN_NOTICE("You flip [src] closed."))
		close(src)
		recentlyflipped = TRUE
		spawn(10)
			if(istype(src, /obj/structure/barricade/plasteel))
				recentlyflipped = FALSE

/obj/structure/barricade/plasteel/proc/open(var/obj/structure/barricade/plasteel/origin)
	if(!closed)
		return
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	closed = 0
	density = 1
	if(linked)
		for(var/direction in cardinal)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade != origin && cade.linked)
					cade.open(src)
	update_icon()

/obj/structure/barricade/plasteel/proc/close(var/obj/structure/barricade/plasteel/origin)
	if(closed)
		return
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	closed = 1
	density = 0
	if(linked)
		for(var/direction in cardinal)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade != origin && cade.linked)
					cade.close(src)
	update_icon()


/*----------------------*/
// SANDBAGS
/*----------------------*/

/obj/structure/barricade/sandbags
	name = "sandbag barricade"
	desc = "A bunch of bags filled with sand, stacked into a small wall. Surprisingly sturdy, albeit labour intensive to set up. Trusted to do the job since 1914."
	icon_state = "sandbag_0"
	barricade_resistance = 15
	health = 400
	maxhealth = 400
	stack_type = /obj/item/stack/sandbags
	debris = list(/obj/item/stack/sandbags, /obj/item/stack/sandbags)
	barricade_hitsound = "sound/weapons/Genhit.ogg"
	barricade_type = "sandbag"
	can_wire = TRUE

/obj/structure/barricade/sandbags/New(loc, mob/user, direction)
	if(direction)
		dir = direction

	if(dir == SOUTH)
		pixel_y = -7
	else if(dir == NORTH)
		pixel_y = 7
	..(loc, user)


/obj/structure/barricade/sandbags/attackby(obj/item/W, mob/user)

	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	if(istype(W, /obj/item/tool/shovel) && user.a_intent != "hurt")
		var/obj/item/tool/shovel/ET = W
		if(!ET.folded)
			user.visible_message(SPAN_NOTICE("[user] starts disassembling [src]."), \
			SPAN_NOTICE("You start disassembling [src]."))
			if(do_after(user, ET.shovelspeed, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				user.visible_message(SPAN_NOTICE("[user] disassembles [src]."),
				SPAN_NOTICE("You disassemble [src]."))
				destroy(TRUE)
		return 1

	if(istype(W, stack_type))
		var/obj/item/stack/sandbags/SB = W
		if(user.action_busy)
			return
		if(health <= maxhealth * 0.3)
			to_chat(user, SPAN_WARNING("[src] has sustained too much structural damage to be repaired."))
			return
		if(health == maxhealth)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts repairing damage to [src]."), \
			SPAN_NOTICE("You start repairing damage to [src]."))
		if(do_after(user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, src))
			user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."), \
				SPAN_NOTICE("You repair [src]."))
			var/amount = SB.amount
			var/health_per_sandbag = maxhealth/5 // 5 sandbags to make a barricade
			amount = Clamp(amount, 0, Ceiling((maxhealth-health)/health_per_sandbag))
			SB.use(amount)
			update_health(-(health_per_sandbag*amount))
		return
	else
		. = ..()


/*----------------------*/
// HANDRAILS
/*----------------------*/

/obj/structure/barricade/handrail
	name = "handrail"
	desc = "A railing, for your hands. Woooow."
	icon = 'icons/obj/structures/handrail.dmi'
	icon_state = "handrail_a_0"
	barricade_type = "handrail"
	health = 30 
	maxhealth = 30
	climb_delay = 5
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
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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
					if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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
					if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_METAL))
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


/*----------------------*/
// WIRED STATES
/*----------------------*/

/obj/structure/barricade/sandbags/wired/New()
	maxhealth += 50
	update_health(-50)
	can_wire = FALSE
	is_wired = TRUE
	update_icon()
	climbable = FALSE
	. = ..()


/obj/structure/barricade/plasteel/wired/New()
	maxhealth += 50
	update_health(-50)
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()
	. = ..()
/obj/structure/barricade/metal/wired/New()
	maxhealth += 50
	update_health(-50)
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()
	. = ..()