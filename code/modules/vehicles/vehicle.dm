/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles/vehicles.dmi'
	layer = ABOVE_MOB_LAYER //so it sits above objects including mobs
	density = TRUE
	anchored = TRUE
	animate_movement = 1
	can_buckle = TRUE

	// The mobs that are in each position/seat of the vehicle
	var/list/mob/seats = list(
		VEHICLE_DRIVER = null
	)

	var/attack_log = null
	var/on = 0
	health = 100
	var/maxhealth = 100
	var/fire_dam_coeff = 1
	var/brute_dam_coeff = 1
	///Maint panel
	var/open = 0
	var/locked = TRUE
	var/stat = 0
	///set if vehicle is powered and should use fuel when moving
	var/powered = 0
	///set this to limit the speed of the vehicle
	var/move_delay = 1
	var/buckling_y = 0

	var/obj/item/cell/cell
	///set this to adjust the amount of power the vehicle uses per move
	var/charge_use = 5
	can_block_movement = TRUE

//-------------------------------------------
// Standard procs
//-------------------------------------------

/obj/vehicle/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_OVER_THROW_ITEM

/obj/vehicle/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated()) return
	if(seats[VEHICLE_DRIVER] != user) return

	if(world.time > l_move_time + move_delay)
		if(on && powered && cell && cell.charge < charge_use)
			turn_off()
		else if(!on && powered)
			to_chat(user, SPAN_WARNING("Turn on the engine first."))
		else
			. = step(src, direction)

/obj/vehicle/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!locked)
			open = !open
			update_icon()
			to_chat(user, SPAN_NOTICE("Maintenance panel is now [open ? "opened" : "closed"]."))
	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR) && cell && open)
		remove_cell(user)

	else if(istype(W, /obj/item/cell) && !cell && open)
		insert_cell(W, user)
	else if(iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			if(health < maxhealth)
				user.visible_message(SPAN_NOTICE("[user] starts to repair [src]."),SPAN_NOTICE("You start to repair [src]"))
				if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
					if(!src || !WT.isOn())
						return
					health = min(maxhealth, health+10)
					user.visible_message(SPAN_NOTICE("[user] repairs [src]."),SPAN_NOTICE("You repair [src]."))
			else
				to_chat(user, SPAN_NOTICE("[src] does not need repairs."))

	else if(W.force)
		switch(W.damtype)
			if("fire")
				health -= W.force * W.demolition_mod * fire_dam_coeff
			if("brute")
				health -= W.force * W.demolition_mod * brute_dam_coeff
		playsound(loc, "smash.ogg", 25, 1)
		user.visible_message(SPAN_DANGER("[user] hits [src] with [W]."),SPAN_DANGER("You hit [src] with [W]."))
		healthcheck()
	else
		..()

/obj/vehicle/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0) return
	health -= M.melee_damage_upper
	src.visible_message(SPAN_DANGER("<B>[M] has [M.attacktext] [src]!</B>"))
	M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	healthcheck()

/obj/vehicle/bullet_act(obj/projectile/P)
	var/damage = P.damage
	health -= damage
	..()
	healthcheck()
	return 1

/obj/vehicle/ex_act(severity)
	health -= severity*0.05*fire_dam_coeff
	health -= severity*0.1*brute_dam_coeff
	healthcheck()
	return

/obj/vehicle/emp_act(severity)
	. = ..()
	var/was_on = on
	stat |= EMPED
	new /obj/effect/overlay/temp/emp_sparks (loc)
	if(on)
		turn_off()
	spawn(severity*300)
		stat &= ~EMPED
		if(was_on)
			turn_on()

/obj/vehicle/attack_remote(mob/user as mob)
	return

/obj/vehicle/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)
	if(attacking_xeno.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	if(attacking_xeno.mob_size < MOB_SIZE_XENO)
		to_chat(attacking_xeno, SPAN_XENOWARNING("You're too small to do any significant damage to this vehicle!"))
		return XENO_NO_DELAY_ACTION

	attacking_xeno.animation_attack_on(src)

	attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno] slashes [src]!"), SPAN_DANGER("You slash [src]!"))
	playsound(attacking_xeno, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)

	var/damage = (attacking_xeno.melee_vehicle_damage + rand(-5,5)) * brute_dam_coeff

	health -= damage

	healthcheck()

	return XENO_NONCOMBAT_ACTION

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/proc/set_seated_mob(seat, mob/living/M)
	seats[seat] = M

	// Checked here because we want to be able to null the mob in a seat
	if(!istype(M))
		return FALSE

	M.forceMove(src)
	M.set_interaction(src)
	return TRUE

/obj/vehicle/proc/turn_on()
	if(stat)
		return 0
	if(powered && cell.charge < charge_use)
		return 0
	on = 1
	set_light(initial(light_range))
	update_icon()
	return 1

/obj/vehicle/proc/turn_off()
	on = 0
	set_light(0)
	update_icon()

/obj/vehicle/proc/explode()
	src.visible_message(SPAN_DANGER("<B>[src] blows apart!</B>"), null, null, 1)
	var/turf/Tsec = get_turf(src)

	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)

	if(cell)
		cell.forceMove(Tsec)
		cell.update_icon()
		cell = null

	if(buckled_mob)
		buckled_mob.apply_effect(5, STUN)
		buckled_mob.apply_effect(5, WEAKEN)
		unbuckle()

	new /obj/effect/spawner/gibspawner/robot(Tsec)
	new /obj/effect/decal/cleanable/blood/oil(src.loc)

	qdel(src)

/obj/vehicle/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/vehicle/proc/powercheck()
	if(!cell && !powered)
		return

	if(!cell && powered)
		turn_off()
		return

	if(cell.charge < charge_use)
		turn_off()
		return

	if(cell && powered)
		turn_on()
		return

/obj/vehicle/proc/insert_cell(obj/item/cell/C, mob/living/carbon/human/H)
	if(cell)
		return
	if(!istype(C))
		return

	H.drop_inv_item_to_loc(C, src)
	cell = C
	powercheck()
	to_chat(usr, SPAN_NOTICE("You install [C] in [src]."))

/obj/vehicle/proc/remove_cell(mob/living/carbon/human/H)
	if(!cell)
		return

	to_chat(usr, SPAN_NOTICE("You remove [cell] from [src]."))
	cell.forceMove(get_turf(H))
	H.put_in_hands(cell)
	cell = null
	powercheck()

/obj/vehicle/proc/RunOver(mob/living/carbon/human/H)
	return //write specifics for different vehicles


/obj/vehicle/afterbuckle(mob/M)
	. = ..()
	if(. && buckled_mob == M)
		M.pixel_y = buckling_y
		M.old_y = buckling_y
	else
		M.pixel_x = initial(buckled_mob.pixel_x)
		M.pixel_y = initial(buckled_mob.pixel_y)
		M.old_y = initial(buckled_mob.pixel_y)

/obj/vehicle/afterbuckle(mob/M)
	. = ..()
	if(seats[VEHICLE_DRIVER] == null)
		seats[VEHICLE_DRIVER] = M

/obj/vehicle/unbuckle()
	. = ..()
	seats[VEHICLE_DRIVER] = null

//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return
