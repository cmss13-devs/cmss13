//NOT using the existing /obj/structure/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness

/obj/structure/mineral_door
	name = "mineral door"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	health = HEALTH_DOOR

	icon = 'icons/obj/structures/doors/mineral_doors.dmi'
	icon_state = "metal"

	var/mineralType = "metal"
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/hardness = 1
	var/oreAmount = 7

/obj/structure/mineral_door/New(location)
	..()
	icon_state = mineralType
	name = "[mineralType] door"


/obj/structure/mineral_door/Collided(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)
	return

/obj/structure/mineral_door/attack_remote(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isRemoteControlling(user)) //so the AI can't open it
		return

/obj/structure/mineral_door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/mineral_door/BlockedPassDirs(atom/movable/mover, target_dir)
	if(istype(mover, /obj/effect/beam))
		if(!opacity)
			return NO_BLOCKED_MOVEMENT
		else
			return BLOCKED_MOVEMENT

	return ..()

/obj/structure/mineral_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()

/obj/structure/mineral_door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/mineral_door/proc/Open()
	isSwitchingStates = 1
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25, 1)
	flick("[mineralType]opening",src)
	sleep(10)
	density = FALSE
	opacity = FALSE
	state = 1
	update_icon()
	isSwitchingStates = 0


/obj/structure/mineral_door/proc/Close()
	isSwitchingStates = 1
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25, 1)
	flick("[mineralType]closing",src)
	sleep(10)
	density = TRUE
	opacity = TRUE
	state = 0
	update_icon()
	isSwitchingStates = 0


/obj/structure/mineral_door/update_icon()
	if(state)
		icon_state = "[mineralType]open"
	else
		icon_state = mineralType

/obj/structure/mineral_door/attackby(obj/item/W, mob/living/user)
	if(istype(W,/obj/item/tool/pickaxe))
		var/obj/item/tool/pickaxe/digTool = W
		to_chat(user, "You start digging the [name].")
		if(do_after(user,digTool.digspeed*hardness, INTERRUPT_ALL, BUSY_ICON_GENERIC) && src)
			to_chat(user, "You finished digging.")
			Dismantle()
	else if(!(W.flags_item & NOBLUDGEON) && W.force)
		user.animation_attack_on(src)
		hardness -= W.force/100 * W.demolition_mod
		to_chat(user, "You hit the [name] with your [W.name]!")
		CheckHardness()
	else
		attack_hand(user)
	return

/obj/structure/mineral_door/proc/CheckHardness()
	if(hardness <= 0)
		Dismantle(1)

/obj/structure/mineral_door/proc/Dismantle(devastated = 0)
	if(!devastated)
		if (mineralType == "metal")
			var/ore = /obj/item/stack/sheet/metal
			for(var/i = 1, i <= oreAmount, i++)
				new ore(get_turf(src))
		else
			var/ore = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
			for(var/i = 1, i <= oreAmount, i++)
				new ore(get_turf(src))
	else
		if (mineralType == "metal")
			var/ore = /obj/item/stack/sheet/metal
			for(var/i = 3, i <= oreAmount, i++)
				new ore(get_turf(src))
		else
			var/ore = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
			for(var/i = 3, i <= oreAmount, i++)
				new ore(get_turf(src))
	qdel(src)

/obj/structure/mineral_door/ex_act(severity)
	severity *= EXPLOSION_DAMAGE_MULTIPLIER_DOOR
	if(!density)
		severity *= EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN
	..()


/obj/structure/mineral_door/get_explosion_resistance()
	if(unacidable)
		return 1000000

	if(density)
		return health/EXPLOSION_DAMAGE_MULTIPLIER_DOOR //this should exactly match the amount of damage needed to destroy the door
	else
		return 0

/obj/structure/mineral_door/iron
	mineralType = "metal"
	hardness = 3

/obj/structure/mineral_door/silver
	mineralType = "silver"
	hardness = 3

/obj/structure/mineral_door/gold
	mineralType = "gold"

/obj/structure/mineral_door/uranium
	mineralType = "uranium"
	hardness = 3
	light_range = 2

/obj/structure/mineral_door/sandstone
	mineralType = "sandstone"
	hardness = 0.5

/obj/structure/mineral_door/transparent
	opacity = FALSE

/obj/structure/mineral_door/transparent/Close()
	..()
	opacity = FALSE

/obj/structure/mineral_door/transparent/phoron
	mineralType = "phoron"

/obj/structure/mineral_door/transparent/phoron/attackby(obj/item/W as obj, mob/user as mob)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			TemperatureAct(100)
	..()

/obj/structure/mineral_door/transparent/phoron/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		TemperatureAct(exposed_temperature)

/obj/structure/mineral_door/transparent/phoron/proc/TemperatureAct(temperature)


/obj/structure/mineral_door/transparent/diamond
	mineralType = "diamond"
	hardness = 10

/obj/structure/mineral_door/wood
	mineralType = "wood"
	hardness = 1

/obj/structure/mineral_door/wood/Open()
	isSwitchingStates = 1
	playsound(loc, 'sound/effects/doorcreaky.ogg', 25, 1)
	flick("[mineralType]opening",src)
	sleep(10)
	density = FALSE
	opacity = FALSE
	state = 1
	update_icon()
	isSwitchingStates = 0

/obj/structure/mineral_door/wood/Close()
	isSwitchingStates = 1
	playsound(loc, 'sound/effects/doorcreaky.ogg', 25, 1)
	flick("[mineralType]closing",src)
	sleep(10)
	density = TRUE
	opacity = TRUE
	state = 0
	update_icon()
	isSwitchingStates = 0

/obj/structure/mineral_door/wood/Dismantle(devastated = 0)
	if(!devastated)
		for(var/i = 1, i <= oreAmount, i++)
			new/obj/item/stack/sheet/wood(get_turf(src))
	qdel(src)

//Mapping instance
/obj/structure/mineral_door/wood/open
	density = FALSE
	opacity = FALSE
	state = 1
	icon_state = "woodopen"
