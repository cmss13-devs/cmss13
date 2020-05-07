/obj/structure/machinery/defenses
	name = "Don't see this"
	desc = "Call for help."
	icon = 'icons/obj/structures/machinery/defenses.dmi'
	icon_state = "defense_base_off"
	anchored = TRUE
	unacidable = TRUE
	density = TRUE
	layer = ABOVE_MOB_LAYER //So you can't hide it under corpses
	use_power = FALSE
	stat = DEFENSE_FUNCTIONAL
	health = 200
	var/belonging_to_faction = list(FACTION_MARINE)
	var/health_max = 200
	var/turned_on = FALSE
	var/owner_mob = null
	var/defense_icon = "uac_sentry"
	var/handheld_type = /obj/item/defenses/handheld
	var/disassemble_time = 20
	var/static = FALSE

/obj/structure/machinery/defenses/New(var/loc, var/faction)
	..(loc)
	if(!isnull(faction))
		if(islist(faction))
			belonging_to_faction = faction
		else
			belonging_to_faction = list(faction)

/obj/structure/machinery/defenses/update_icon()
	if(turned_on)
		icon_state = "defense_base"
	else
		icon_state = "defense_base_off"

/obj/structure/machinery/defenses/examine(mob/user)
	. = ..()
	
	if(ishuman(user))
		var/message = ""
		message += SPAN_INFO("Multitool is used to disassemble it.")
		message += "\n"
		message += SPAN_INFO("It has [SPAN_HELPFUL("[health]/[health_max]")] health.")
		to_chat(user, message)

/obj/structure/machinery/defenses/proc/power_on()
	if(stat == DEFENSE_DAMAGED)
		return FALSE

	turned_on = TRUE
	power_on_action()
	update_icon()

/obj/structure/machinery/defenses/proc/power_off()
	turned_on = FALSE
	power_off_action()
	update_icon()

/obj/structure/machinery/defenses/start_processing()
	if(!machine_processing)
		machine_processing = TRUE
		fast_machines += src

/obj/structure/machinery/defenses/stop_processing()
	if(machine_processing)
		machine_processing = FALSE
		fast_machines -= src


/obj/structure/machinery/defenses/attackby(var/obj/item/O as obj, mob/user as mob)
	if(isnull(O)) 
		return

	if(ismultitool(O))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_METAL))
			to_chat(user, SPAN_WARNING("You don't have the training to do this."))
			return

		if(health < health_max)
			to_chat(user, SPAN_WARNING("[src] is too damaged to disassemble. Repair it with a welder first."))
			return

		if(static)
			to_chat(user, SPAN_WARNING("[src] is not meant to be removed."))
			return

		user.visible_message(SPAN_NOTICE("[user] begins disassembling [src]."), SPAN_NOTICE("You begin disassembling [src]."))

		if(!do_after(user, disassemble_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			return
		
		user.visible_message(SPAN_NOTICE("[user] disassembles [src]."), SPAN_NOTICE("You disassemble [src]."))

		new handheld_type(loc)
		playsound(loc, 'sound/mecha/mechmove04.ogg', 30, 1)
		qdel(src)
		return

	if(iswrench(O))
		if(anchored)
			if(turned_on)
				to_chat(user, SPAN_WARNING("[src] is currently active. The motors will prevent you from unanchoring it safely."))
				return

			user.visible_message(SPAN_NOTICE("[user] begins unanchoring [src] from the ground."),
			SPAN_NOTICE("You begin unanchoring [src] from the ground."))

			if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				return
			user.visible_message(SPAN_NOTICE("[user] unanchors [src] from the ground."),
			SPAN_NOTICE("You unanchor [src] from the ground."))
			anchored = FALSE
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			return
		else
			user.visible_message(SPAN_NOTICE("[user] begins securing [src] to the ground."),
			SPAN_NOTICE("You begin securing [src] to the ground."))

			if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				return
			user.visible_message(SPAN_NOTICE("[user] secures [src] to the ground."),
			SPAN_NOTICE("You secure [src] to the ground."))
			anchored = TRUE
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			return

	if(iswelder(O))
		var/obj/item/tool/weldingtool/WT = O
		if(health < 0)
			to_chat(user, SPAN_WARNING("[src]'s internal circuitry is ruined, there's no way you can salvage this on the go."))
			return

		if(health >= health_max)
			to_chat(user, SPAN_WARNING("[src] isn't in need of repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing [src]."),
			SPAN_NOTICE("You begin repairing [src]."))
			if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs [src]."),
				SPAN_NOTICE("You repair [src]."))
				if(stat == DEFENSE_DAMAGED)
					stat &= ~DEFENSE_DAMAGED
				update_health(-50)
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		return

	return TRUE

/obj/structure/machinery/defenses/attack_hand(var/mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_PLASTEEL))
		to_chat(user, SPAN_WARNING("You don't have the training to do this."))
		return

	if(isYautja(user))
		to_chat(user, SPAN_WARNING("You punch [src] but nothing happens."))
		return
		
	add_fingerprint(user)

	if(!anchored)
		to_chat(user, SPAN_WARNING("It must be anchored to the ground before you can activate it."))
		return

	if(!turned_on)
		power_on()
	else
		power_off()
	return

/obj/structure/machinery/defenses/proc/power_on_action(var/mob/user)
	return

/obj/structure/machinery/defenses/proc/power_off_action(var/mob/user)
	return

// DAMAGE HANDLING
/obj/structure/machinery/defenses/update_health(var/damage = 0) //Negative damage restores health.
	health -= damage

	if(health > health_max)
		health = health_max

	if(health <= 0 && stat != DEFENSE_DESTROYED)
		stat |= DEFENSE_DESTROYED
		destroyed_action()
		return

	if(stat == DEFENSE_FUNCTIONAL && damage > 0)
		damaged_action(damage)

	if(stat == DEFENSE_DAMAGED)
		density = 0
	else
		density = initial(density)

	update_icon()

/obj/structure/machinery/defenses/proc/destroyed_action()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_WARNING("The [name] starts to blink rapidly!")]")
	playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)

	sleep(5)

	cell_explosion(loc, 10, 10, null, "defense explosion")
	if(!disposed)
		qdel(src)

/obj/structure/machinery/defenses/proc/damaged_action(var/damage)
	if(prob(5 + round(damage/5)))
		visible_message(SPAN_DANGER("[htmlicon(src, viewers(src))] The [name] cracks and breaks apart!"))
		stat |= DEFENSE_DAMAGED
		turned_on = FALSE

/obj/structure/machinery/defenses/emp_act(var/severity)
	if(turned_on)
		if(prob(50))
			visible_message("[htmlicon(src, viewers(src))] <span class='danger'>[src] beeps and buzzes wildly, flashing odd symbols on its screen before shutting down!</span>")
			playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)
			for(var/i = 1 to 6)
				dir = pick(1, 2, 3, 4)
				sleep(2)
			turned_on = FALSE
	if(health > 0)
		update_health(25)
	return

/obj/structure/machinery/defenses/ex_act(var/severity)
	if(health <= 0)
		return
	update_health(severity)

/obj/structure/machinery/defenses/bullet_act(var/obj/item/projectile/P)
	bullet_ping(P)
	visible_message(SPAN_WARNING("[src] is hit by the [P.name]!"))
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & AMMO_XENO_ACID) //Fix for xenomorph spit doing baby damage.
		update_health(round(P.damage/3))
	else
		update_health(round(P.damage/10))
	return TRUE
// DAMAGE HANDLING OVER

//Fixes a bug with power changes in the area.
/obj/structure/machinery/defenses/power_change()
	return

/obj/structure/machinery/defenses/Dispose()
	if(owner_mob)
		owner_mob = null

	. = ..()