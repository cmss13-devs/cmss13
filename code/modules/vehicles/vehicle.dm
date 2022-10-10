/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles/vehicles.dmi'
	layer = ABOVE_MOB_LAYER //so it sits above objects including mobs
	density = 1
	anchored = 1
	animate_movement = 1
	luminosity = 2
	can_buckle = TRUE

	// The mobs that are in each position/seat of the vehicle
	var/list/mob/seats = list(
		VEHICLE_DRIVER = null
	)

	var/attack_log = null
	var/on = 0
	health = 100
	var/maxhealth = 100
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	var/open = 0	//Maint panel
	var/locked = TRUE
	var/stat = 0
	var/powered = 0		//set if vehicle is powered and should use fuel when moving
	var/move_delay = 1	//set this to limit the speed of the vehicle
	var/buckling_y = 0

	var/obj/item/cell/cell
	var/charge_use = 5	//set this to adjust the amount of power the vehicle uses per move
	can_block_movement = TRUE

//-------------------------------------------
// Standard procs
//-------------------------------------------

/obj/vehicle/initialize_pass_flags(var/datum/pass_flags_container/PF)
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
				health -= W.force * fire_dam_coeff
			if("brute")
				health -= W.force * brute_dam_coeff
		playsound(src.loc, "smash.ogg", 25, 1)
		user.visible_message(SPAN_DANGER("[user] hits [src] with [W]."),SPAN_DANGER("You hit [src] with [W]."))
		healthcheck()
	else
		..()

/obj/vehicle/attack_animal(var/mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)	return
	health -= M.melee_damage_upper
	src.visible_message(SPAN_DANGER("<B>[M] has [M.attacktext] [src]!</B>"))
	M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	healthcheck()

/obj/vehicle/bullet_act(var/obj/item/projectile/P)
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

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/proc/set_seated_mob(var/seat, var/mob/living/M)
	seats[seat] = M

	// Checked here because we want to be able to null the mob in a seat
	if(!istype(M))
		return

	M.forceMove(src)
	M.set_interaction(src)

/obj/vehicle/proc/turn_on()
	if(stat)
		return 0
	if(powered && cell.charge < charge_use)
		return 0
	on = 1
	SetLuminosity(initial(luminosity))
	update_icon()
	return 1

/obj/vehicle/proc/turn_off()
	on = 0
	SetLuminosity(0)
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

/obj/vehicle/proc/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	if(cell)
		return
	if(!istype(C))
		return

	H.drop_inv_item_to_loc(C, src)
	cell = C
	powercheck()
	to_chat(usr, SPAN_NOTICE("You install [C] in [src]."))

/obj/vehicle/proc/remove_cell(var/mob/living/carbon/human/H)
	if(!cell)
		return

	to_chat(usr, SPAN_NOTICE("You remove [cell] from [src]."))
	cell.forceMove(get_turf(H))
	H.put_in_hands(cell)
	cell = null
	powercheck()

/obj/vehicle/proc/RunOver(var/mob/living/carbon/human/H)
	return		//write specifics for different vehicles


/obj/vehicle/afterbuckle(mob/M)
	. = ..()
	if(. && buckled_mob == M)
		M.pixel_y = buckling_y
		M.old_y = buckling_y
	else
		M.pixel_x = initial(buckled_mob.pixel_x)
		M.pixel_y = initial(buckled_mob.pixel_y)
		M.old_y = initial(buckled_mob.pixel_y)

/obj/vehicle/afterbuckle(var/mob/M)
	. = ..()
	if(seats[VEHICLE_DRIVER] == null)
		seats[VEHICLE_DRIVER] = M

/obj/vehicle/unbuckle()
	. = ..()
	seats[VEHICLE_DRIVER] = null

/obj/vehicle/Destroy()
	SetLuminosity(0)
	. = ..()

//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return

///Soutomobile
/obj/vehicle/souto
	name = "\improper Soutomobile"
	icon_state = "soutomobile"
	desc = "Almost, but not quite, the best ride in the universe."
	move_delay = 3 //The speed of a fed but shoeless pajamarine, or a bit slower than a heavy-armour marine.
	buckling_y = 4
	layer = ABOVE_LYING_MOB_LAYER //Allows it to drive over people, but is below the driver.

/obj/vehicle/souto/Initialize()
	. = ..()
	var/image/I = new(icon = 'icons/obj/vehicles/vehicles.dmi', icon_state = "soutomobile_overlay", layer = ABOVE_MOB_LAYER) //over mobs
	overlays += I

/obj/vehicle/souto/manual_unbuckle(mob/user)
	if(buckled_mob && buckled_mob != user)
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			..()
	else ..()

/obj/vehicle/souto/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated()) return
	if(world.time > l_move_time + move_delay)
		. = step(src, direction)


/obj/vehicle/souto/super
	desc = "The best ride in the universe, for the one-and-only Souto Man!"
	health = 1000
	locked = FALSE
	unacidable = TRUE
	indestructible = TRUE

/obj/vehicle/souto/super/explode()
	for(var/mob/M as anything in viewers(7, src))
		M.show_message("Somehow, [src] still looks as bright and shiny as a new can of Souto Classic.")
	health = initial(health) //Souto Man never dies, and neither does his bike.

/obj/vehicle/souto/super/buckle_mob(mob/M, mob/user)
	if(!locked) //Vehicle is unlocked until first being mounted, since the Soutomobile is faction-locked and otherwise Souto Man cannot automatically buckle in on spawn as his equipment is spawned before his ID.
		locked = TRUE
	else if(M == user && M.faction != FACTION_SOUTO && locked == TRUE) //Are you a cool enough dude to drive this bike? Nah, nobody's THAT cool.
		to_chat(user, SPAN_WARNING("Somehow, as you take hold of the handlebars, [src] manages to glare at you. You back off. We didn't sign up for haunted motorbikes, man."))
		return
	..()
