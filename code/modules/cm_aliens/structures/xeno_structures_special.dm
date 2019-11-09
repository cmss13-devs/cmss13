/*
 * Special Structures
 */

/proc/get_xeno_structure_desc(var/name)
	var/message
	switch(name)
		if(XENO_STRUCTURE_POOL)
			message = "<B>[XENO_STRUCTURE_POOL]</B> - Respawns xenomorphs that fall in battle."
		if(XENO_STRUCTURE_EGGMORPH)
			message = "<B>[XENO_STRUCTURE_EGGMORPH]</B> - Processes hatched hosts into new eggs."
	return message

/obj/effect/alien/resin/special
	name = "Special Resin Structure"
	icon = 'icons/mob/xenos/structures64x64.dmi'
	pixel_x = -16
	pixel_y = -16
	health = 200
	density = 1
	var/datum/hive_status/linked_hive
	var/delete_on_hijack = TRUE

/obj/effect/alien/resin/special/New(loc, var/hive_ref)
	..()
	if(hive_ref)
		linked_hive = hive_ref
		if(!linked_hive.add_special_structure(src))
			qdel(src)
			return
	fast_objects.Add(src)
	update_icon()

/obj/effect/alien/resin/special/Dispose()
	if(linked_hive)
		linked_hive.remove_special_structure(src)
		if(linked_hive.living_xeno_queen)
			xeno_message("Hive: \A [name] has been destroyed at [sanitize(get_area(src))]!", 3, linked_hive.hivenumber)
	linked_hive = null
	fast_objects.Remove(src)
	..()

/obj/effect/alien/resin/special/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.can_destroy_special())
		return ..()

//Spawn Pool - Respawns dead xenos

/obj/effect/alien/resin/special/pool
	name = XENO_STRUCTURE_POOL
	desc = "A pool of primordial goop, reeking of sour smells. Home to many small, wriggling masses."
	icon_state = "pool"
	health = 200
	var/last_spawned = 0
	var/spawn_cooldown = SECONDS_45
	var/spawn_buffer = 3 //How many respawns does the pool start with on construction
	var/spawn_buffer_max = 6 //How many respawns it can store in total at a time
	var/image/melting_body
	unacidable = TRUE
	luminosity = 3

/obj/effect/alien/resin/special/pool/update_icon()
	..()
	overlays.Cut()
	underlays.Cut()
	if(melting_body)
		underlays += melting_body
	underlays += "[icon_state]_underlay"
	overlays += image(icon, "[icon_state]_overlay", layer = ABOVE_MOB_LAYER)
	if(spawn_buffer > 0)
		overlays += "[icon_state]_bubbling"

/obj/effect/alien/resin/special/pool/New(loc, var/hive_ref)
	last_spawned = world.time
	..(loc, hive_ref)

/obj/effect/alien/resin/special/pool/examine(mob/user)
	..()
	if(isXeno(user) || isobserver(user))
		var/message = "It has [spawn_buffer] more larvae to grow"
		if(linked_hive)
			message += ", with [linked_hive.spawn_list.len] minds waiting"
		message += "."
		to_chat(user, message)

/obj/effect/alien/resin/special/pool/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/grab) || !isXeno(user))
		return ..(I, user)

	var/obj/item/grab/G = I
	if(!iscarbon(G.grabbed_thing))
		return
	var/mob/living/carbon/M = G.grabbed_thing
	if(M.buckled)
		to_chat(user, SPAN_WARNING("Unbuckle first!"))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.is_revivable())
			to_chat(user, SPAN_WARNING("This one is not suitable yet!"))
			return
	if(isXeno(M))
		return
	if(spawn_buffer >= spawn_buffer_max)
		to_chat(user, SPAN_WARNING("\The [src] is already full! Using this one now would be a waste..."))
		return
	if(melting_body)
		to_chat(user, SPAN_WARNING("\The [src] is already processing a host! Using this one now would be a waste..."))
		return
	if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
		return
	visible_message(SPAN_DANGER("\The [src] splashes loudly as \the [M] is tossed in, bubbling uncontrollably!"))
	M.dir = SOUTH
	var/icon/mob_icon = getFlatIcon(M)
	mob_icon.Turn(90)
	melting_body = image(mob_icon)
	melting_body.pixel_x = 16
	melting_body.pixel_y = 16
	update_icon()
	new /obj/effect/overlay/temp/acid_pool_splash(loc)
	playsound(src, 'sound/effects/slosh.ogg', 25, 1)
	spawn_buffer += 1
	qdel(M)
	melt_body()

/obj/effect/alien/resin/special/pool/process()
	if(!linked_hive || !linked_hive.living_xeno_queen || !linked_hive.spawn_list.len || world.time < (last_spawned + spawn_cooldown) || spawn_buffer <= 0)
		return

	var/datum/mind/picked_mind = linked_hive.pick_from_spawn_list()
	if(!picked_mind)
		return

	var/mind_ckey = picked_mind.ckey
	if(!directory[mind_ckey])
		return

	var/client/C = directory[mind_ckey]
	var/mob/M = C.mob
	if(isliving(M) && (M.stat != DEAD))
		linked_hive.spawn_list.Remove(picked_mind)
		return

	if(isobserver(M))
		var/mob/dead/observer/ghost = M
		if((C.admin_holder && (C.admin_holder.rights & R_MOD)) && ghost.adminlarva == 0)
			linked_hive.spawn_list.Remove(picked_mind)
			linked_hive.spawn_list.Add(picked_mind)
			return

	last_spawned = world.time
	var/mob/living/carbon/Xenomorph/Larva/new_xeno = new(loc)
	new_xeno.ckey = mind_ckey
	new_xeno.visible_message(SPAN_DANGER("\The [new_xeno] emerges from \the [src]!"), SPAN_HELPFUL("You emerge from \the [src], reborn!"))
	playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 25, 1)
	spawn_buffer -= 1
	linked_hive.spawn_list.Remove(picked_mind)
	if(spawn_buffer <= 0)
		visible_message(SPAN_DANGER("\The [src] hisses faintly as it stops bubbling, indicating it requires more matter!"))
		update_icon()

/obj/effect/alien/resin/special/pool/proc/melt_body(var/iterations = 3)
	if(!melting_body)
		return
	for(var/x in 1 to iterations)
		sleep(SECONDS_2)
		melting_body.pixel_y -= 1
		playsound(src, 'sound/bullets/acid_impact1.ogg', 25)
		update_icon()
	melting_body = null
	playsound(src, 'sound/bullets/acid_impact1.ogg', 25)
	update_icon()

//Eggmorpher - Basically a big reusable egg

/obj/effect/alien/resin/special/eggmorph
	name = XENO_STRUCTURE_EGGMORPH
	desc = "A disgusting, organic processor that reeks of rotting flesh. Capable of melting even bones into something far more useful."
	icon_state = "eggmorph"
	health = 50
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
	..()

/obj/effect/alien/resin/special/eggmorph/examine(mob/user)
	..()
	if(isXeno(user) || isobserver(user))
		to_chat(user, "It has [stored_huggers] facehuggers within, with [huggers_to_grow] more to grow.")

/obj/effect/alien/resin/special/eggmorph/proc/create_egg_triggers()
	for(var/turf/T in orange(src, 3))
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
				to_chat(user, SPAN_WARNING("Unbuckle first!"))
				return
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.is_revivable())
					to_chat(user, SPAN_WARNING("This one is not suitable yet!"))
					return
			if(isXeno(M))
				return
			if(huggers_to_grow >= huggers_to_grow_max)
				to_chat(user, SPAN_WARNING("\The [src] is already full! Using this one now would be a waste..."))
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
			visible_message(SPAN_DANGER("\The [src] groans as its contents are reduce to nothing!"))
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

//Evolution Pod - Evolves Xenos

/obj/effect/alien/resin/special/evopod
	name = XENO_STRUCTURE_EVOPOD
	desc = "A green fleshy orb, faintly humming an ominous tune. It calls for you."
	icon_state = "evopod"
	health = 25
	luminosity = 2
	var/eaten = FALSE
	var/eating = FALSE

/obj/effect/alien/resin/special/evopod/attack_alien(mob/living/carbon/Xenomorph/M)
	if(linked_hive && (M.hivenumber != linked_hive.hivenumber))
		return ..(M)
	if(eating)
		to_chat(M, SPAN_XENONOTICE("Someone is already consuming this!"))
		return
	if(isnull(M.caste.evolves_to))
		to_chat(M, SPAN_XENONOTICE("You are already the apex of form and function. Go forth and spread the hive!"))
		return
	if(istype(M, /mob/living/carbon/Xenomorph/Larva))
		to_chat(M, SPAN_XENONOTICE("You can't reach the pod!"))
		return
	if(M.evolution_stored >= M.evolution_threshold)
		to_chat(M, SPAN_XENONOTICE("You are already ready to evolve!"))
		return
	if(alert("Consume \the [name]?",, "Yes", "No") == "No") return

	eating = TRUE
	if(!do_after(M, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY))
		eating = FALSE
		return
	if(eaten)
		return
	eaten = TRUE

	if(linked_hive && linked_hive.living_xeno_queen)
		var/area/current_area = get_area(src)
		xeno_message("Hive: \The [M] has consumed \a [src] at [sanitize(current_area)]!", 3, linked_hive.hivenumber)
	visible_message(SPAN_XENOWARNING("[M] consumes \the [src]."), \
					SPAN_XENONOTICE("You consume \the [src]."))
	M.evolution_stored = M.evolution_threshold
	qdel(src)
