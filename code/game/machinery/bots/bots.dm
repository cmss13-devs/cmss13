// AI (i.e. game AI, not the AI player) controlled bots

/obj/structure/machinery/bot
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	layer = MOB_LAYER
	light_system = MOVABLE_LIGHT
	light_range = 3
	use_power = USE_POWER_NONE
	needs_power = FALSE
	var/obj/item/card/id/botcard // the ID card that the bot "holds"
	var/on = 1
	unslashable = TRUE
	health = 0 //do not forget to set health for your bot!
	var/maxhealth = 0
	var/fire_dam_coeff = 1
	var/brute_dam_coeff = 1
	var/open = 0//Maint panel
	var/locked = 1

/obj/structure/machinery/bot/Initialize(mapload, ...)
	. = ..()

	if(light_range)
		set_light_on(TRUE)

/obj/structure/machinery/bot/Destroy()
	QDEL_NULL(botcard)
	. = ..()


/obj/structure/machinery/bot/proc/turn_on()
	if(stat)
		return 0
	on = 1
	set_light(initial(luminosity))
	return 1

/obj/structure/machinery/bot/proc/turn_off()
	on = 0
	set_light(0)

/obj/structure/machinery/bot/proc/explode()
	qdel(src)

/obj/structure/machinery/bot/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/machinery/bot/get_examine_text(mob/user)
	. = ..()
	if(health < maxhealth)
		if(health > maxhealth/3)
			. += SPAN_WARNING("[src]'s parts look loose.")
		else
			. += SPAN_DANGER("[src]'s parts look very loose!")

/obj/structure/machinery/bot/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		return
	health -= M.melee_damage_upper
	visible_message(SPAN_DANGER("<B>[M] has [M.attacktext] [src]!</B>"))
	M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	M.last_damage_data = create_cause_data(initial(name))
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	healthcheck()

/obj/structure/machinery/bot/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!locked)
			open = !open
			to_chat(user, SPAN_NOTICE("Maintenance panel is now [src.open ? "opened" : "closed"]."))
	else if(iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		if(health < maxhealth)
			if(open)
				health = min(maxhealth, health+10)
				user.visible_message(SPAN_DANGER("[user] repairs [src]!"),SPAN_NOTICE("You repair [src]!"))
			else
				to_chat(user, SPAN_NOTICE("Unable to repair with the maintenance panel closed."))
		else
			to_chat(user, SPAN_NOTICE("[src] does not need a repair."))
	else
		if(hasvar(W,"force") && hasvar(W,"damtype"))
			switch(W.damtype)
				if("fire")
					health -= W.force * W.demolition_mod * fire_dam_coeff
				if("brute")
					health -= W.force * W.demolition_mod * brute_dam_coeff
			. = ..()
			healthcheck()
		else
			. = ..()

/obj/structure/machinery/bot/bullet_act(obj/projectile/Proj)
	health -= Proj.ammo.damage
	..()
	healthcheck()
	return 1

/obj/structure/machinery/bot/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(50))
				health -= rand(1, 5)*fire_dam_coeff
				health -= rand(1, 5)*brute_dam_coeff
				healthcheck()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			health -= rand(5, 10)*fire_dam_coeff
			health -= rand(10, 20)*brute_dam_coeff
			healthcheck()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			explode()


/obj/structure/machinery/bot/emp_act(severity)
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

/obj/structure/machinery/bot/attack_remote(mob/user as mob)
	attack_hand(user)

/obj/structure/machinery/bot/attack_hand(mob/living/carbon/human/user)

	if(!istype(user))
		return ..()

	if(user.species.can_shred(user))
		src.health -= rand(15,30)*brute_dam_coeff
		src.visible_message(SPAN_DANGER("[user] has slashed [src]!"))
		playsound(src.loc, 'sound/weapons/slice.ogg', 25, 1)
		if(prob(10))
			new /obj/effect/decal/cleanable/blood/oil(src.loc)
		healthcheck()

//******************************************************************/
// Navigation procs
// Used for A-star pathfinding


// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(obj/item/card/id/ID)
	var/L[] = new()

	for(var/d in GLOB.cardinals)
		var/turf/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L

// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/card/id/ID)

	if(A == null || B == null)
		return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST))) //diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlockedWithAccess(A,iStep, ID) && !LinkBlockedWithAccess(iStep,B,ID))
			return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlockedWithAccess(A,pStep,ID) && !LinkBlockedWithAccess(pStep,B,ID))
			return 0
		return 1

	if(DirBlockedWithAccess(A,adir, ID))
		return 1

	if(DirBlockedWithAccess(B,rdir, ID))
		return 1

	for(var/obj/O in B)
		if(O.density && !istype(O, /obj/structure/machinery/door) && !(O.flags_atom & ON_BORDER))
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc, dir, obj/item/card/id/ID)
	for(var/obj/structure/window/D in loc)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return 1
		if(D.dir == dir)
			return 1

	for(var/obj/structure/machinery/door/D in loc)
		if(!D.density)
			continue
		if(istype(D, /obj/structure/machinery/door/window))
			if( dir & D.dir )
				return !D.check_access(ID)

			//if((dir & SOUTH) && (D.dir & (EAST|WEST))) return !D.check_access(ID)
			//if((dir & EAST ) && (D.dir & (NORTH|SOUTH))) return !D.check_access(ID)
		else
			return !D.check_access(ID) // it's a real, air blocking door
	return 0
