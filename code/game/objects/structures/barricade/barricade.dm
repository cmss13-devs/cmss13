// Snow, wood, sandbags, metal, plasteel

/obj/structure/barricade
	icon = 'icons/obj/structures/barricades.dmi'
	climbable = TRUE
	anchored = TRUE
	density = 1
	throwpass = TRUE //You can throw objects over this, despite its density.
	layer = BELOW_OBJ_LAYER
	flags_atom = ON_BORDER
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
	var/upgraded
	var/brute_multiplier = 1
	var/burn_multiplier = 1
	var/explosive_multiplier = 1

/obj/structure/barricade/New(loc, mob/user)
	..(loc)
	if(user)
		user.count_niche_stat(STATISTICS_NICHE_CADES)
	addtimer(CALLBACK(src, .proc/update_icon), 0)

/obj/structure/barricade/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = null
		PF.flags_can_pass_front = SETUP_LIST_FLAGS(LIST_FLAGS_REMOVE(PASS_OVER, PASS_OVER_ACID_SPRAY, PASS_OVER_THROW_MOB))
		PF.flags_can_pass_behind = SETUP_LIST_FLAGS(LIST_FLAGS_REMOVE(PASS_OVER, PASS_OVER_ACID_SPRAY, PASS_OVER_THROW_MOB))
	flags_can_pass_front_temp = SETUP_LIST_FLAGS(PASS_OVER_THROW_MOB)
	flags_can_pass_behind_temp = SETUP_LIST_FLAGS(PASS_OVER_THROW_MOB)

/obj/structure/barricade/examine(mob/user)
	..()
	to_chat(user, SPAN_INFO("It is recommended to stand flush to a barricade or more than four tiles away for maximum efficiency."))
	if(is_wired)
		to_chat(user, SPAN_INFO("There is a length of wire strewn across the top of this barricade."))
	switch(damage_state)
		if(BARRICADE_DMG_NONE)
			to_chat(user, SPAN_INFO("It appears to be in good shape."))
		if(BARRICADE_DMG_SLIGHT)
			to_chat(user, SPAN_WARNING("It's slightly damaged, but still very functional."))
		if(BARRICADE_DMG_MODERATE)
			to_chat(user, SPAN_WARNING("It's quite beat up, but it's holding together."))
		if(BARRICADE_DMG_HEAVY)
			to_chat(user, SPAN_WARNING("It's crumbling apart, just a few more blows will tear it apart."))

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

	if(upgraded)
		switch(upgraded)
			if(BARRICADE_UPGRADE_BURN)
				overlays += image('icons/obj/structures/barricades.dmi', icon_state = "+burn_upgrade_[damage_state]")
			if(BARRICADE_UPGRADE_BRUTE)
				overlays += image('icons/obj/structures/barricades.dmi', icon_state = "+brute_upgrade_[damage_state]")
			if(BARRICADE_UPGRADE_EXPLOSIVE)
				overlays += image('icons/obj/structures/barricades.dmi', icon_state = "+explosive_upgrade_[damage_state]")

	if(is_wired)
		if(!closed)
			overlays += image('icons/obj/structures/barricades.dmi', icon_state = "[src.barricade_type]_wire")
		else
			overlays += image('icons/obj/structures/barricades.dmi', icon_state = "[src.barricade_type]_closed_wire")

	..()

/obj/structure/barricade/hitby(atom/movable/AM)
	if(AM.throwing && is_wired)
		if(iscarbon(AM) && !isXenoCrusher(AM))
			var/mob/living/carbon/C = AM
			C.visible_message(SPAN_DANGER("The barbed wire slices into [C]!"),
			SPAN_DANGER("The barbed wire slices into you!"))
			C.apply_damage(10)
			C.KnockDown(2) //Leaping into barbed wire is VERY bad
	..()

/obj/structure/barricade/Collided(atom/movable/AM)
	..()

	if(istype(AM, /mob/living/carbon/Xenomorph/Crusher))
		var/mob/living/carbon/Xenomorph/Crusher/C = AM

		if (!C.throwing)
			return

		if(crusher_resistant)
			take_damage( 100 )

		else if(!C.stat)
			visible_message(SPAN_DANGER("[C] smashes through [src]!"))
			destroy()

/*
 *	Checks whether an atom can leave its current turf through the barricade.
 *	Returns the blocking direction.
 *		If the atom's movement is not blocked, returns 0.
 *		If the object is completely solid, returns ALL
 */
/obj/structure/barricade/BlockedExitDirs(atom/movable/mover, target_dir)
	if(closed)
		return NO_BLOCKED_MOVEMENT

	return ..()

/*
 *	Checks whether an atom can pass through the barricade into its target turf.
 *	Returns the blocking direction.
 *		If the atom's movement is not blocked, returns 0.
 *		If the object is completely solid, returns ALL
 *
 *	Would be worth checking whether it is really necessary to have this CanPass
 *	proc be specific to barricades. Instead, have flags for blocking specific
 *  mobs.
 */
/obj/structure/barricade/BlockedPassDirs(atom/movable/mover, target_dir)
	if(closed)
		return NO_BLOCKED_MOVEMENT

	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable objects allow you to universally climb over others
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/barricade/handle_barrier_chance()
	if(!anchored)
		return FALSE
	return prob(max(30,(100.0*health)/maxhealth))

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
				flags_can_pass_front_temp = LIST_FLAGS_REMOVE(flags_can_pass_front_temp, PASS_OVER_THROW_MOB)
				flags_can_pass_behind_temp = LIST_FLAGS_REMOVE(flags_can_pass_behind_temp, PASS_OVER_THROW_MOB)
				climbable = FALSE
				update_icon()
		return

	if(istype(W, /obj/item/tool/wirecutters))
		if(is_wired)
			user.visible_message(SPAN_NOTICE("[user] begin removing the barbed wire on [src]."),
			SPAN_NOTICE("You begin removing the barbed wire on [src]."))
			if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				if(!is_wired)
					return

				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] removes the barbed wire on [src]."),
				SPAN_NOTICE("You remove the barbed wire on [src]."))
				maxhealth -= 50
				update_health(50)
				can_wire = TRUE
				is_wired = FALSE
				flags_can_pass_front_temp = LIST_FLAGS_REMOVE(flags_can_pass_front_temp, PASS_OVER_THROW_MOB)
				flags_can_pass_behind_temp = LIST_FLAGS_REMOVE(flags_can_pass_behind_temp, PASS_OVER_THROW_MOB)
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

	if(P.ammo.damage_type == BURN)
		P.damage = P.damage * burn_multiplier
	else
		P.damage = P.damage * brute_multiplier

	if(istype(P.ammo, /datum/ammo/xeno/boiler_gas))
		take_damage(round(50 * burn_multiplier))

	else if(P.ammo.flags_ammo_behavior & AMMO_ANTISTRUCT)
		take_damage(P.damage * ANTISTRUCT_DMG_MULT_BARRICADES)

	take_damage(round(P.damage/bullet_divider))

	return TRUE

/obj/structure/barricade/destroy(deconstruct)
	if(deconstruct && is_wired)
		new /obj/item/stack/barbed_wire(loc)
	if(stack_type)
		var/stack_amt
		if(!deconstruct && destroyed_stack_amount)
			stack_amt = destroyed_stack_amount
		else
			stack_amt = round(stack_amount * (health/maxhealth)) //Get an amount of sheets back equivalent to remaining health. Obviously, fully destroyed means 0
		if(upgraded)
			stack_amt += round(2 * (health/maxhealth))
			
		if(stack_amt) 
			new stack_type (loc, stack_amt)
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
		update_health(round(severity * explosive_multiplier))

/obj/structure/barricade/get_explosion_resistance(direction)
	if(!density || direction == turn(dir, 90) || direction == turn(dir, -90))
		return 0
	else
		return min(health, 40)

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

obj/structure/barricade/acid_spray_act()
	take_damage(rand(20, 30) * burn_multiplier)

/obj/structure/barricade/flamer_fire_act(var/dam = config.min_burnlevel)
	take_damage(dam * burn_multiplier)

/obj/structure/barricade/proc/hit_barricade(obj/item/I)
	take_damage(I.force * 0.5 * brute_multiplier)

obj/structure/barricade/proc/take_damage(var/damage)
	for(var/obj/structure/barricade/B in get_step(src,dir)) //discourage double-stacking barricades by removing health from opposing barricade
		if(B.dir == reverse_direction(dir))
			B.update_health(damage)

	update_health(damage)

/obj/structure/barricade/proc/take_acid_damage(var/damage)
	take_damage(damage * burn_multiplier)

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