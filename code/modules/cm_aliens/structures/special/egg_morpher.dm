#define EGGMORPG_RANGE 2

//Eggmorpher - Basically a big reusable egg
/obj/effect/alien/resin/special/eggmorph
	name = XENO_STRUCTURE_EGGMORPH
	desc = "A disgusting, organic processor that reeks of rotting flesh. Capable of melting even bones into something far more useful."
	icon_state = "eggmorph"
	health = 300
	var/last_spawned = 0
	var/spawn_cooldown = 20 SECONDS
	var/stored_huggers = 0
	var/huggers_to_grow = 0
	var/huggers_per_corpse = 6
	var/huggers_to_grow_max = 12
	var/mob/captured_mob
	var/datum/shape/rectangle/range_bounds

	var/hugger_timelock = 15 MINUTES

	var/last_marine_count = -5 MINUTES
	var/marine_count_cooldown = 2 MINUTES
	var/playable_hugger_limit = 4

	appearance_flags = KEEP_TOGETHER
	layer = LYING_BETWEEN_MOB_LAYER

/obj/effect/alien/resin/special/eggmorph/Initialize(mapload, var/hive_ref)
	. = ..()
	range_bounds = RECT(x, y, EGGMORPG_RANGE, EGGMORPG_RANGE)

/obj/effect/alien/resin/special/eggmorph/Destroy()
	if (stored_huggers && linked_hive)
		//Hugger explosion, like a carrier
		var/obj/item/clothing/mask/facehugger/F
		var/chance = 60
		visible_message(SPAN_XENOWARNING("The chittering mass of tiny aliens is trying to escape [src]!"))
		for(var/i in 0 to stored_huggers)
			if(prob(chance))
				F = new(loc, linked_hive.hivenumber)
				step_away(F,src,1)

	vis_contents.Cut()
	QDEL_NULL(captured_mob)

	. = ..()

/obj/effect/alien/resin/special/eggmorph/get_examine_text(mob/user)
	. = ..()
	if(isXeno(user) || isobserver(user))
		. += "It has [stored_huggers] facehuggers within, with [huggers_to_grow] more to grow."

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
			if(M == captured_mob)
				to_chat(user, SPAN_XENOWARNING("[src] is already digesting [M]!"))
				return
			if(huggers_to_grow + stored_huggers >= huggers_to_grow_max)
				to_chat(user, SPAN_XENOWARNING("\The [src] is already full! Using this one now would be a waste..."))
				return
			if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				return
			visible_message(SPAN_DANGER("\The [src] churns as it begins digest \the [M], spitting out foul-smelling fumes!"))
			playsound(src, "alien_drool", 25)
			if(captured_mob)
				//Get rid of what we have there, we're overwriting it
				qdel(captured_mob)
			captured_mob = M
			captured_mob.setDir(SOUTH)
			captured_mob.moveToNullspace()
			var/matrix/MX = matrix()
			captured_mob.apply_transform(MX)
			captured_mob.pixel_x = 16
			captured_mob.pixel_y = 16
			vis_contents += captured_mob
			user.stop_pulling() // Automatically remove the grab
			huggers_to_grow += huggers_per_corpse
			update_icon()
		return
	if(istype(I, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = I
		if(F.stat != DEAD)
			if(stored_huggers >= huggers_to_grow_max)
				to_chat(user, SPAN_XENOWARNING("\The [src] is full of children."))
				return
			if(user)
				visible_message(SPAN_XENOWARNING("[user] slides [F] back into \the [src]."), \
					SPAN_XENONOTICE("You place the child back into \the [src]."))
				user.temp_drop_inv_item(F)
			else
				visible_message(SPAN_XENOWARNING("[F] crawls back into \the [src]!"))
			stored_huggers = min(huggers_to_grow_max, stored_huggers + 1)
			qdel(F)
		else to_chat(user, SPAN_XENOWARNING("This child is dead."))
		return
	return ..(I, user)

/obj/effect/alien/resin/special/eggmorph/update_icon()
	..()
	appearance_flags |= KEEP_TOGETHER
	overlays.Cut()
	underlays.Cut()
	if(captured_mob)
		var/image/J = new(icon = icon, icon_state = "[icon_state]", layer = captured_mob.layer + 0.1)
		overlays += J
		var/image/I = new(icon = icon, icon_state = "[icon_state]_overlay", layer = captured_mob.layer + 0.2)
		overlays += I
	underlays += "[icon_state]_underlay"

/obj/effect/alien/resin/special/eggmorph/process()
	check_facehugger_target()

	if(!linked_hive || !captured_mob || world.time < (last_spawned + spawn_cooldown))
		return
	last_spawned = world.time
	if(huggers_to_grow > 0)
		huggers_to_grow--
		stored_huggers = min(huggers_to_grow_max, stored_huggers + 1)
		if(huggers_to_grow <= 0)
			visible_message(SPAN_DANGER("\The [src] groans as its contents are reduced to nothing!"))
			vis_contents.Cut()

			for(var/atom/movable/A in captured_mob.contents_recursive()) // Get rid of any intel objects so we don't delete them
				if(isitem(A))
					var/obj/item/item = A
					if(item.is_objective && item.unacidable)
						item.forceMove(get_step(loc, pick(alldirs)))

			QDEL_NULL(captured_mob)
			update_icon()

/obj/effect/alien/resin/special/eggmorph/proc/check_facehugger_target()
	if(!range_bounds)
		range_bounds = RECT(x, y, EGGMORPG_RANGE, EGGMORPG_RANGE)

	var/list/targets = SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if(isnull(targets) || !length(targets))
		return

	var/target = pick(targets)
	if(isnull(target))
		return

	HasProximity(target)

/obj/effect/alien/resin/special/eggmorph/HasProximity(atom/movable/AM as mob|obj)
	if(!stored_huggers || isSynth(AM))
		return

	if (!linked_hive)
		return

	if(!can_hug(AM, linked_hive.hivenumber))
		return

	stored_huggers = max(0, stored_huggers - 1)

	var/obj/item/clothing/mask/facehugger/child = new(loc, linked_hive.hivenumber)
	child.leap_at_nearest_target()

/obj/effect/alien/resin/special/eggmorph/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!istype(M))
		return attack_hand(M)
	if(!linked_hive || (M.hivenumber != linked_hive.hivenumber))
		return ..(M)
	if(stored_huggers)
		to_chat(M, SPAN_XENONOTICE("You retrieve a child."))
		stored_huggers = max(0, stored_huggers - 1)
		new /obj/item/clothing/mask/facehugger(loc, linked_hive.hivenumber)
		return XENO_NONCOMBAT_ACTION
	..()

/obj/effect/alien/resin/special/eggmorph/attack_ghost(mob/dead/observer/user)
	if(world.time < hugger_timelock)
		to_chat(user, SPAN_WARNING("The hive cannot support facehuggers yet..."))
		return
	if(world.time - user.timeofdeath < 3 MINUTES)
		var/time_left = round((user.timeofdeath + 3 MINUTES - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a facehugger until ([time_left] seconds has passed)"))
		return
	if(!stored_huggers)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return

	if(world.time > last_marine_count + marine_count_cooldown)
		var/marine_count = 0
		for(var/mob/mob as anything in GLOB.human_mob_list)
			if(mob.job in ROLES_MARINES)
				marine_count++
		playable_hugger_limit = round(marine_count / 5)

	var/current_hugger_count = 0
	for(var/mob/mob as anything in GLOB.living_xeno_list)
		if(isXenoFacehugger(mob))
			current_hugger_count++
	if(playable_hugger_limit <= current_hugger_count)
		to_chat(user, SPAN_WARNING("\The [src] cannot support more facehuggers! Limit: <b>[current_hugger_count]/[playable_hugger_limit]</b>"))
		return

	if(alert(user, "Are you sure you want to become a facehugger?", "Confirmation", "Yes", "No") == "No")
		return

	var/mob/living/carbon/Xenomorph/Facehugger/hugger = new /mob/living/carbon/Xenomorph/Facehugger(loc, null, linked_hive.hivenumber)
	user.mind.transfer_to(hugger, TRUE)
	hugger.visible_message(SPAN_XENODANGER("A facehugger suddenly emerges out of \the [src]!"), SPAN_XENODANGER("You emerge out of \the [src] and awaken from your slumber. For the Hive!"))
	playsound(hugger, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
	hugger.generate_name()
	stored_huggers--

#undef EGGMORPG_RANGE
