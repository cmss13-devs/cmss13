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

	if(holder && istype(holder.loc,/obj/item/explosive))
		var/obj/item/explosive/explosive = holder.loc
		explosive.prime()
	else
		if(istype(src.loc,/obj/item/device/assembly_holder))
			if(istype(src.loc.loc, /obj/structure/reagent_dispensers/fueltank/))
				var/obj/structure/reagent_dispensers/fueltank/tank = src.loc.loc
				if(tank && tank.modded)
					tank.explode()

		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	return TRUE

/obj/item/device/assembly/igniter/attack_self(mob/user as mob)
	activate()
	add_fingerprint(user)
	return