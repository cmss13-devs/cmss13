/obj/item/device/assembly/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	matter = list("metal" = 500, "glass" = 50, "waste" = 10)

	heat_source = 1000 //Can ignite Thermite.
	secured = 1
	wires = WIRE_RECEIVE

/obj/item/device/assembly/igniter/activate()
	if(!..())
		return FALSE//Cooldown check

	if(holder) 
		if(istype(holder.loc,/obj/item/explosive))
			var/obj/item/explosive/explosive = holder.loc
			explosive.prime()

		else if(istype(holder.loc, /obj/structure/reagent_dispensers/fueltank))
			var/obj/structure/reagent_dispensers/fueltank/tank = holder.loc

			if(tank && !tank.exploding)
				playsound(get_turf(tank), 'sound/machines/twobeep.ogg', 75, 1)
				tank.exploding = TRUE
				addtimer(CALLBACK(tank, /obj/structure/reagent_dispensers/fueltank/.proc/explode), 3 SECONDS)

				tank.update_icon()

		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	return TRUE

/obj/item/device/assembly/igniter/attack_self(mob/user as mob)
	activate()
	add_fingerprint(user)
	return
