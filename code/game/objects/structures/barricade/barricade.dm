// Snow, wood, sandbags, metal, plasteel

/obj/structure/barricade
	icon = 'icons/obj/structures/barricades.dmi'
	climbable = TRUE
	anchored = TRUE
	density = TRUE
	/// You can throw objects over this, despite its density.
	throwpass = TRUE
	layer = BELOW_OBJ_LAYER
	flags_atom = ON_BORDER
	/// The type of stack the barricade dropped when disassembled if any.
	var/stack_type
	/// The amount of stack dropped when disassembled at full health
	var/stack_amount = 5
	/// to specify a non-zero amount of stack to drop when destroyed
	var/destroyed_stack_amount
	health = 100 //Pretty tough. Changes sprites at 300 and 150
	var/maxhealth = 100
	/// Used for calculating some stuff related to maxhealth as it constantly changes due to e.g. barbed wire. set to 100 to avoid possible divisions by zero
	var/starting_maxhealth = 100
	/// Whether a crusher can ram through it.
	var/crusher_resistant = TRUE
	/// How much force an item needs to even damage it at all.
	var/force_level_absorption = 5
	var/barricade_hitsound
	var/barricade_type = "barricade" //"metal", "plasteel", etc.
	/// ! Icon file used for the wiring
	var/wire_icon = 'icons/obj/structures/barricades.dmi'
	var/can_change_dmg_state = TRUE
	var/damage_state = BARRICADE_DMG_NONE
	var/closed = FALSE
	var/can_wire = FALSE
	var/is_wired = FALSE
	flags_barrier = HANDLE_BARRIER_CHANCE
	projectile_coverage = PROJECTILE_COVERAGE_HIGH
	var/upgraded
	var/brute_multiplier = 1
	var/burn_multiplier = 1
	var/explosive_multiplier = 1
	var/brute_projectile_multiplier = 1
	var/burn_flame_multiplier = 1
	var/repair_materials = list()
	var/metallic = TRUE
	/// Lower limit of damage beyond which the barricade cannot be fixed by welder. Compared to damage_state. If null it can be repaired at any damage_state.
	var/welder_lower_damage_limit = null

/obj/structure/barricade/Initialize(mapload, mob/user)
	. = ..()
	if(health != maxhealth) //Update cades mapped with a custom health
		update_health(0, TRUE)
	if(user)
		user.count_niche_stat(STATISTICS_NICHE_CADES)
	addtimer(CALLBACK(src, PROC_REF(update_icon)), 0)
	starting_maxhealth = maxhealth

/obj/structure/barricade/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	..()
	if (pass_flags)
		pass_flags.flags_can_pass_all = NONE
		pass_flags.flags_can_pass_front = NONE
		pass_flags.flags_can_pass_behind = PASS_OVER^(PASS_OVER_ACID_SPRAY|PASS_OVER_THROW_MOB)
	flags_can_pass_front_temp = PASS_OVER_THROW_MOB
	flags_can_pass_behind_temp = PASS_OVER_THROW_MOB

/obj/structure/barricade/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("It is recommended to stand flush to a barricade or more than four tiles away for maximum efficiency.")
	if(is_wired)
		. += SPAN_INFO("There is a length of wire strewn across the top of this barricade.")
	switch(damage_state)
		if(BARRICADE_DMG_NONE)
			. += SPAN_INFO("It appears to be in good shape.")
		if(BARRICADE_DMG_SLIGHT)
			. += SPAN_WARNING("It's slightly damaged, but still very functional.")
		if(BARRICADE_DMG_MODERATE)
			. += SPAN_WARNING("It's quite beat up, but it's holding together.")
		if(BARRICADE_DMG_HEAVY)
			. += SPAN_WARNING("It's crumbling apart, just a few more blows will tear it apart.")

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
			if(NORTH)
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
			if(BARRICADE_UPGRADE_ANTIFF)
				overlays += image('icons/obj/structures/barricades.dmi', icon_state = "+explosive_upgrade_[damage_state]")

	if(is_wired)
		if(!closed)
			overlays += image(wire_icon, icon_state = "[barricade_type]_wire")
		else
			overlays += image(wire_icon, icon_state = "[barricade_type]_closed_wire")

	..()

/obj/structure/barricade/hitby(atom/movable/atom_movable)
	if(atom_movable.throwing && is_wired)
		if(iscarbon(atom_movable))
			var/mob/living/carbon/living_carbon = atom_movable
			if(living_carbon.mob_size <= MOB_SIZE_XENO)
				living_carbon.visible_message(SPAN_DANGER("The barbed wire slices into [living_carbon]!"),
				SPAN_DANGER("The barbed wire slices into you!"))
				living_carbon.apply_damage(10)
				living_carbon.apply_effect(2, WEAKEN) //Leaping into barbed wire is VERY bad
				playsound(living_carbon, "bonk", 75, FALSE)
	..()

/obj/structure/barricade/Collided(atom/movable/atom_movable)
	..()

	if(istype(atom_movable, /mob/living/carbon/xenomorph/crusher))
		var/mob/living/carbon/xenomorph/crusher/living_carbon = atom_movable

		if (!living_carbon.throwing)
			return

		if(crusher_resistant)
			visible_message(SPAN_DANGER("[living_carbon] smashes into [src]!"))
			take_damage(150)
			playsound(src, barricade_hitsound, 25, TRUE)

		else if(!living_carbon.stat)
			visible_message(SPAN_DANGER("[living_carbon] smashes through [src]!"))
			deconstruct(FALSE)
			playsound(src, barricade_hitsound, 25, TRUE)

/*
 * Checks whether an atom can leave its current turf through the barricade.
 * Returns the blocking direction.
 * If the atom's movement is not blocked, returns 0.
 * If the object is completely solid, returns ALL
 */
/obj/structure/barricade/BlockedExitDirs(atom/movable/mover, target_dir)
	if(closed)
		return NO_BLOCKED_MOVEMENT

	return ..()

/*
 * Checks whether an atom can pass through the barricade into its target turf.
 * Returns the blocking direction.
 * If the atom's movement is not blocked, returns 0.
 * If the object is completely solid, returns ALL
 *
 * Would be worth checking whether it is really necessary to have this CanPass
 * proc be specific to barricades. Instead, have flags for blocking specific
 *  mobs.
 */
/obj/structure/barricade/BlockedPassDirs(atom/movable/mover, target_dir)
	if(closed)
		return NO_BLOCKED_MOVEMENT

	var/obj/structure/structure = locate(/obj/structure) in get_turf(mover)
	if(structure && structure.climbable && !(structure.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable objects allow you to universally climb over others
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/barricade/handle_barrier_chance()
	if(!anchored)
		return FALSE
	return prob(max(30,(100.0*health)/maxhealth))

/obj/structure/barricade/attack_animal(mob/user as mob)
	return attack_alien(user)

/obj/structure/barricade/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/weapon/zombie_claws))
		user.visible_message(SPAN_DANGER("The zombie smashed at the [src.barricade_type] barricade!"),
		SPAN_DANGER("You smack the [src.barricade_type] barricade!"))
		if(barricade_hitsound)
			playsound(src, barricade_hitsound, 35, 1)
		hit_barricade(item)
		return

	for(var/obj/effect/xenomorph/acid/acid in src.loc)
		if(acid.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	if(istype(item, /obj/item/stack/barbed_wire))
		var/obj/item/stack/barbed_wire/barbed_wire = item
		if(can_wire)
			user.visible_message(SPAN_NOTICE("[user] starts setting up [item.name] on [src]."),
			SPAN_NOTICE("You start setting up [item.name] on [src]."))
			if(do_after(user, 20, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src) && can_wire)
				// Make sure there's still enough wire in the stack
				if(!barbed_wire.use(1))
					return

				playsound(src.loc, 'sound/effects/barbed_wire_movement.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] sets up [item.name] on [src]."),
				SPAN_NOTICE("You set up [item.name] on [src]."))

				maxhealth += 50
				update_health(-50)
				can_wire = FALSE
				is_wired = TRUE
				flags_can_pass_front_temp &= ~PASS_OVER_THROW_MOB
				flags_can_pass_behind_temp &= ~PASS_OVER_THROW_MOB
				climbable = FALSE
				update_icon()
		return

	if(HAS_TRAIT(item, TRAIT_TOOL_WIRECUTTERS))
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
				flags_can_pass_front_temp &= ~PASS_OVER_THROW_MOB
				flags_can_pass_behind_temp &= ~PASS_OVER_THROW_MOB
				climbable = TRUE
				update_icon()
				new/obj/item/stack/barbed_wire( src.loc )
		return

	if(item.force > force_level_absorption)
		. = ..()
		if(barricade_hitsound)
			playsound(src, barricade_hitsound, 35, 1)
		hit_barricade(item)

/obj/structure/barricade/bullet_act(obj/projectile/bullet)
	bullet_ping(bullet)

	if(bullet.ammo.damage_type == BURN)
		bullet.damage = bullet.damage * burn_multiplier
	else
		bullet.damage = bullet.damage * brute_projectile_multiplier
		playsound(src, barricade_hitsound, 35, 1)

	if(istype(bullet.ammo, /datum/ammo/xeno/boiler_gas))
		take_damage(floor(50 * burn_multiplier))

	else if(bullet.ammo.flags_ammo_behavior & AMMO_ANTISTRUCT)
		take_damage(bullet.damage * ANTISTRUCT_DMG_MULT_BARRICADES)

	take_damage(bullet.damage)

	return TRUE

/obj/structure/barricade/deconstruct(disassembled = TRUE)
	if(disassembled)
		if(is_wired)
			new /obj/item/stack/barbed_wire(loc)
		if(stack_type)
			var/stack_amt
			stack_amt = floor(stack_amount * (health/starting_maxhealth)) //Get an amount of sheets back equivalent to remaining health. Obviously, fully destroyed means 0
			if(upgraded)
				stack_amt += floor(2 * (health/starting_maxhealth))
			if(stack_amt)
				new stack_type(loc, stack_amt)
	else
		if(destroyed_stack_amount)
			new stack_type(loc, destroyed_stack_amount)
	return ..()


/obj/structure/barricade/ex_act(severity, direction, cause_data)
	for(var/obj/structure/barricade/barricade in get_step(src,dir)) //discourage double-stacking barricades by removing health from opposing barricade
		if(barricade.dir == reverse_direction(dir))
			spawn(1)
			if(barricade)
				barricade.ex_act(severity, direction)
	if(health <= 0)
		var/location = get_turf(src)
		handle_debris(severity, direction)
		if(prob(50)) // no message spam pls
			visible_message(SPAN_WARNING("[src] blows apart in the explosion, sending shards flying!"))
		deconstruct(FALSE)
		create_shrapnel(location, rand(2,5), direction, , /datum/ammo/bullet/shrapnel/light, cause_data)
	else
		update_health(floor(severity * explosive_multiplier))

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
		setDir(EAST)
	else if(dir & WEST)
		setDir(WEST)
	update_icon()

/obj/structure/barricade/acid_spray_act()
	take_damage(25 * burn_multiplier)
	visible_message(SPAN_WARNING("[src] is hit by the acid spray!"))
	new /datum/effects/acid(src, null, null)

/obj/structure/barricade/flamer_fire_act(dam = BURN_LEVEL_TIER_1)
	take_damage(dam * burn_flame_multiplier)

/obj/structure/barricade/proc/hit_barricade(obj/item/item)
	take_damage(item.force * item.demolition_mod * 0.5 * brute_multiplier)

/obj/structure/barricade/proc/take_damage(damage)
	for(var/obj/structure/barricade/barricade in get_step(src,dir)) //discourage double-stacking barricades by removing health from opposing barricade
		if(barricade.dir == reverse_direction(dir))
			barricade.update_health(damage)

	update_health(damage)

/obj/structure/barricade/proc/take_acid_damage(damage)
	take_damage(damage * burn_multiplier)

/obj/structure/barricade/update_health(damage, nomessage)
	health -= damage
	health = clamp(health, 0, maxhealth)

	if(!health)
		if(!nomessage)
			visible_message(SPAN_DANGER("[src] falls apart!"))
		deconstruct(FALSE)
		return

	update_damage_state()
	update_icon()

/obj/structure/barricade/proc/update_damage_state()
	var/health_percent = floor(health/maxhealth * 100)
	switch(health_percent)
		if(0 to 25)
			damage_state = BARRICADE_DMG_HEAVY
		if(25 to 50)
			damage_state = BARRICADE_DMG_MODERATE
		if(50 to 75)
			damage_state = BARRICADE_DMG_SLIGHT
		if(75 to INFINITY)
			damage_state = BARRICADE_DMG_NONE

/obj/structure/barricade/proc/try_weld_cade(obj/item/tool/weldingtool/welder, mob/user, repeat = TRUE, skip_check = FALSE)
	if(!skip_check && !can_weld(welder, user))
		return FALSE

	if(!(welder.remove_fuel(2, user)))
		return FALSE

	user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
	SPAN_NOTICE("You begin repairing the damage to [src]."))
	playsound(src.loc, 'sound/items/Welder2.ogg', 25, TRUE)

	var/welding_time = skillcheck(user, SKILL_CONSTRUCTION, 2) ? 5 SECONDS : 10 SECONDS
	if(!do_after(user, welding_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
		return FALSE

	user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
	SPAN_NOTICE("You repair [src]."))
	user.count_niche_stat(STATISTICS_NICHE_REPAIR_CADES)
	update_health(-200)
	playsound(src.loc, 'sound/items/Welder2.ogg', 25, TRUE)

	var/current_tool = user.get_active_hand()
	if(current_tool != welder)
		return TRUE // Swapped hands or tool
	if(repeat && can_weld(welder, user, silent = TRUE))
		// Assumption: The implementation of can_weld will return false if fully repaired
		if(!try_weld_cade(welder, user, repeat = TRUE, skip_check = TRUE))
			// If this returned false, then we were interrupted or ran out of fuel, so stop looping
			return TRUE

	return TRUE

/obj/structure/barricade/verb/count_rotate()
	set name = "Rotate Barricade Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	rotate(usr,1)

/obj/structure/barricade/verb/clock_rotate()
	set name = "Rotate Barricade Clockwise"
	set category = "Object"
	set src in oview(1)

	rotate(usr,-1)

/obj/structure/barricade/proc/rotate(mob/user, rotation_dir = -1)//-1 for clockwise, 1 for counter clockwise
	if(world.time <= user.next_move || !ishuman(user) || !Adjacent(user) || user.is_mob_incapacitated())
		return

	if(anchored)
		to_chat(usr, SPAN_WARNING("It is fastened to the floor, you can't rotate it!"))
		return

	user.next_move = world.time + 3 //slight spam prevention? you don't want every metal cade to turn into a doorway
	setDir(turn(dir, 90 * rotation_dir))
	update_icon()

/obj/structure/barricade/clicked(mob/user, list/mods)
	if(mods[ALT_CLICK])
		rotate(user)
		return TRUE

	return ..()

/obj/structure/barricade/proc/try_nailgun_usage(obj/item/item, mob/user)
	if(length(repair_materials) == 0 || health >= maxhealth || !istype(item, /obj/item/weapon/gun/smg/nailgun))
		return FALSE

	var/obj/item/weapon/gun/smg/nailgun/nailgun = item

	if(!nailgun.in_chamber || !nailgun.current_mag || nailgun.current_mag.current_rounds < 3)
		to_chat(user, SPAN_WARNING("You require at least 4 nails to complete this task!"))
		return FALSE

	// Check if either hand has a metal stack by checking the weapon offhand
	// Presume the material is a sheet until proven otherwise.
	var/obj/item/stack/sheet/material = null
	if(user.l_hand == nailgun)
		material = user.r_hand
	else
		material = user.l_hand

	if(!istype(material, /obj/item/stack/sheet/))
		to_chat(user, SPAN_WARNING("You'll need some adequate repair material in your other hand to patch up [src]!"))
		return FALSE

	if(material.amount < nailgun.material_per_repair)
		to_chat(user, SPAN_WARNING("You'll need more adequate repair material in your other hand to patch up [src]!"))
		return FALSE

	var/repair_value = 0
	for(var/validSheetType in repair_materials)
		if(validSheetType == material.sheettype)
			repair_value = repair_materials[validSheetType]
			break

	if(repair_value == 0)
		to_chat(user, SPAN_WARNING("You'll need some adequate repair material in your other hand to patch up [src]!"))
		return FALSE

	var/soundchannel = playsound(src, nailgun.repair_sound, 25, 1)
	if(!do_after(user, nailgun.nailing_speed, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
		playsound(src, null, channel = soundchannel)
		return FALSE

	if(!material || (material != user.l_hand && material != user.r_hand) || material.amount <= 0)
		to_chat(user, SPAN_WARNING("You seem to have misplaced the repair material!"))
		return FALSE

	if(!nailgun.in_chamber || !nailgun.current_mag || nailgun.current_mag.current_rounds < 3)
		to_chat(user, SPAN_WARNING("You require at least 4 nails to complete this task!"))
		return FALSE

	update_health(-repair_value*maxhealth)
	to_chat(user, SPAN_WARNING("You nail [material] to [src], restoring some of its integrity!"))
	update_damage_state()
	material.use(nailgun.material_per_repair)
	nailgun.current_mag.current_rounds -= 3
	nailgun.in_chamber = null
	nailgun.load_into_chamber()
	return TRUE

/obj/structure/barricade/proc/can_weld(obj/item/item, mob/user, silent)
	if(user.action_busy)
		return FALSE

	if(!metallic)
		if(!silent)
			user.visible_message(SPAN_WARNING("You can't weld \the [src]!"))
		return FALSE

	if(!HAS_TRAIT(item, TRAIT_TOOL_BLOWTORCH))
		if(!silent)
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
		return FALSE

	if(health == maxhealth)
		if(!silent)
			to_chat(user, SPAN_WARNING("[src] doesn't need repairs."))
		return FALSE

	if(!(isnull(damage_state)) && !(isnull(welder_lower_damage_limit)) && damage_state >= welder_lower_damage_limit)
		if(!silent)
			to_chat(user, SPAN_WARNING("[src] has sustained too much structural damage to be repaired."))
		return FALSE

	return TRUE
