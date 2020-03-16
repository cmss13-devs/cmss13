//Spawn Pool - Respawns dead xenos
/obj/effect/alien/resin/special/pool
	name = XENO_STRUCTURE_POOL
	desc = "A pool of primordial goop, reeking of sour smells. Home to many small, wriggling masses."
	icon_state = "pool"
	health = 900
	var/last_spawned = 0
	var/spawn_cooldown = SECONDS_45
	var/spawn_buffer = 3 //How many respawns does the pool start with on construction
	var/spawn_buffer_max = 6 //How many respawns it can store in total at a time
	var/image/melting_body
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
		to_chat(user, SPAN_XENOWARNING("Unbuckle first!"))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.is_revivable())
			to_chat(user, SPAN_XENOWARNING("This one is not suitable yet!"))
			return
	if(isXeno(M))
		return
	if(spawn_buffer >= spawn_buffer_max)
		to_chat(user, SPAN_XENOWARNING("\The [src] is already full! Using this one now would be a waste..."))
		return
	if(melting_body)
		to_chat(user, SPAN_XENOWARNING("\The [src] is already processing a host! Using this one now would be a waste..."))
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
		update_icon()
		return
	melting_body.pixel_y -= 1
	playsound(src, 'sound/bullets/acid_impact1.ogg', 25)
	iterations -= 1
	if(!iterations)
		melting_body = null
	else
		add_timer(CALLBACK(src, /obj/effect/alien/resin/special/pool/proc/melt_body, iterations), SECONDS_2)
	update_icon()
