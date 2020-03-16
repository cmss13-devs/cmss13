//Eggmorpher - Basically a big reusable egg
/obj/effect/alien/resin/special/eggmorph
	name = XENO_STRUCTURE_EGGMORPH
	desc = "A disgusting, organic processor that reeks of rotting flesh. Capable of melting even bones into something far more useful."
	icon_state = "eggmorph"
	health = 300
	var/last_spawned = 0
	var/spawn_cooldown = SECONDS_20
	var/stored_huggers = 0
	var/huggers_to_grow = 0
	var/huggers_to_grow_max = 6
	var/list/egg_triggers = list()
	var/image/captured_mob

/obj/effect/alien/resin/special/eggmorph/New(loc, var/hive_ref)
	create_egg_triggers()
	..(loc, hive_ref)

/obj/effect/alien/resin/special/eggmorph/Dispose()
	delete_egg_triggers()
	. = ..()

/obj/effect/alien/resin/special/eggmorph/examine(mob/user)
	..()
	if(isXeno(user) || isobserver(user))
		to_chat(user, "It has [stored_huggers] facehuggers within, with [huggers_to_grow] more to grow.")

/obj/effect/alien/resin/special/eggmorph/proc/create_egg_triggers()
	for(var/turf/T in orange(src, 7))
		var/obj/effect/egg_trigger/ET = new /obj/effect/egg_trigger(src, null, src)
		ET.loc = T
		egg_triggers += ET

/obj/effect/alien/resin/special/eggmorph/proc/delete_egg_triggers()
	for(var/atom/trigger in egg_triggers)
		egg_triggers -= trigger
		qdel(trigger)

/obj/effect/alien/resin/special/eggmorph/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/grab))
		if(!isXeno(user)) return
		var/obj/item/grab/G = I
		if(iscarbon(G.grabbed_thing))
			var/mob/living/carbon/M = G.grabbed_thing
			if(M.buckled)
				to_chat(user, SPAN_XENOWARNING("Unbuckle first!"))
				return
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.is_revivable())
					to_chat(user, SPAN_XENOWARNING("This one is not suitable yet!"))
					return
			if(isXeno(M))
				return
			if(huggers_to_grow >= huggers_to_grow_max)
				to_chat(user, SPAN_XENOWARNING("\The [src] is already full! Using this one now would be a waste..."))
				return
			if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				return
			visible_message(SPAN_DANGER("\The [src] churns as it begins digest \the [M], spitting out foul smelling fumes!"))
			playsound(src, "alien_drool", 25)
			M.dir = SOUTH
			captured_mob = image(getFlatIcon(M))
			captured_mob.pixel_x = 16
			captured_mob.pixel_y = 16
			huggers_to_grow = huggers_to_grow_max
			update_icon()
			qdel(M)
		return
	if(istype(I, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = I
		if(F.stat != DEAD)
			if(stored_huggers >= huggers_to_grow_max)
				to_chat(user, SPAN_XENOWARNING("\The [src] is full of children."))
				return
			if(user)
				visible_message(SPAN_XENOWARNING("[user] slides [F] back into [src]."), \
					SPAN_XENONOTICE("You place the child back into [src]."))
				user.temp_drop_inv_item(F)
			else
				visible_message(SPAN_XENOWARNING("[F] crawls back into [src]!"))
			stored_huggers = min(huggers_to_grow_max, stored_huggers + 1)
			qdel(F)
		else to_chat(user, SPAN_XENOWARNING("This child is dead."))
		return
	return ..(I, user)

/obj/effect/alien/resin/special/eggmorph/update_icon()
	..()
	overlays.Cut()
	underlays.Cut()
	if(captured_mob)
		underlays += captured_mob
		overlays += "[icon_state]_overlay"
	underlays += "[icon_state]_underlay"

/obj/effect/alien/resin/special/eggmorph/process()
	if(!linked_hive || !captured_mob || world.time < (last_spawned + spawn_cooldown))
		return
	last_spawned = world.time
	if(huggers_to_grow > 0)
		huggers_to_grow -= 1
		stored_huggers = min(huggers_to_grow_max, stored_huggers + 1)
		if(huggers_to_grow <= 0)
			visible_message(SPAN_DANGER("\The [src] groans as its contents are reduced to nothing!"))
			captured_mob = null
			update_icon()


/obj/effect/alien/resin/special/eggmorph/HasProximity(atom/movable/AM as mob|obj)
	if(!stored_huggers || !CanHug(AM) || isSynth(AM))
		return
	stored_huggers = max(0, stored_huggers - 1)
	var/obj/item/clothing/mask/facehugger/child = new(loc)
	if(linked_hive)
		child.hivenumber = linked_hive.hivenumber
	child.leap_at_nearest_target()

/obj/effect/alien/resin/special/eggmorph/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!istype(M))
		return attack_hand(M)
	if(linked_hive && (M.hivenumber != linked_hive.hivenumber))
		return ..(M)
	if(stored_huggers)
		to_chat(M, SPAN_XENONOTICE("You retrieve a child."))
		stored_huggers = max(0, stored_huggers - 1)
		new /obj/item/clothing/mask/facehugger(loc)
		return
	..()
