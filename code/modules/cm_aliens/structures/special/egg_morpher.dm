#define EGGMORPG_RANGE 2

//Eggmorpher - Basically a big reusable egg
/obj/effect/alien/resin/special/eggmorph
	name = XENO_STRUCTURE_EGGMORPH
	desc = "A disgusting biomass generator that reeks of rotting flesh. Capable of producing facehuggers on its own."
	icon_state = "eggmorph"
	health = 300
	appearance_flags = KEEP_TOGETHER
	layer = FACEHUGGER_LAYER

	///How many huggers are stored in the egg morpher currently.
	var/stored_huggers = 0
	///Max amount of huggers that can be stored in the egg morpoher.
	var/huggers_max_amount = 12
	///Max amount of huggers that can grow by itself.
	var/huggers_to_grow_max = 6
	///How many huggers are reserved from observers.
	var/huggers_reserved = 0
	///Datum used for mob detection.
	var/datum/shape/range_bounds
	///How long it takes to generate one facehugger.
	var/spawn_cooldown_length = 120 SECONDS
	///How long it takes to generate one facehugger if queen is on ovi.
	var/spawn_cooldown_length_ovi = 60 SECONDS
	COOLDOWN_DECLARE(spawn_cooldown)


/obj/effect/alien/resin/special/eggmorph/Initialize(mapload, hive_ref)
	. = ..()
	COOLDOWN_START(src, spawn_cooldown, get_egg_cooldown())
	range_bounds = SQUARE(x, y, EGGMORPG_RANGE)
	update_minimap_icon()

/obj/effect/alien/resin/special/eggmorph/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, get_minimap_flag_for_faction(linked_hive?.hivenumber), "morpher")

/obj/effect/alien/resin/special/eggmorph/Destroy()
	if(stored_huggers && linked_hive)
		//Hugger explosion, like a carrier
		var/obj/item/clothing/mask/facehugger/F
		var/chance = 60
		visible_message(SPAN_XENOWARNING("The chittering mass of tiny aliens is trying to escape [src]!"))
		for(var/i in 1 to stored_huggers)
			if(prob(chance))
				F = new(loc, linked_hive.hivenumber)
				step_away(F,src,1)

	range_bounds = null
	SSminimaps.remove_marker(src)
	. = ..()

/obj/effect/alien/resin/special/eggmorph/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user) || isobserver(user))
		. += SPAN_NOTICE("\nIt has <b>[stored_huggers] facehuggers within</b>, with [max(0, huggers_to_grow_max - stored_huggers)] more to grow and a total capacity of [huggers_max_amount] facehuggers (reserved: [huggers_reserved]).")

		var/current_hugger_count = linked_hive.get_current_playable_facehugger_count();
		. += SPAN_NOTICE("There are currently [current_hugger_count] facehuggers in the hive. The hive can support a total of [linked_hive.playable_hugger_limit] facehuggers at present.")
		if(stored_huggers < huggers_to_grow_max)
			. += SPAN_NOTICE("It'll grow another facehugger in <b>[COOLDOWN_SECONDSLEFT(src, spawn_cooldown)] seconds.</b>")
	if(isxeno(user))
		var/mob/living/carbon/xenomorph/xeno = user
		if(xeno.caste_type == XENO_CASTE_CARRIER)
			. += SPAN_NOTICE("<b>Using our Retrieve Egg ability, we can easily transfer our eggs into [src].</b>")

/obj/effect/alien/resin/special/eggmorph/attackby(obj/item/item, mob/user)
	if(!isxeno(user))
		return

	if(istype(item, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/hugger = item
		if(hugger.stat != DEAD)
			if(stored_huggers >= huggers_max_amount)
				to_chat(user, SPAN_XENOWARNING("\The [src] is full of children."))
				return
			if(user)
				visible_message(SPAN_XENOWARNING("[user] slides [hugger] back into \the [src]."),
					SPAN_XENONOTICE("You place the child back into \the [src]."))
				user.temp_drop_inv_item(hugger)
			else
				visible_message(SPAN_XENOWARNING("[hugger] crawls back into \the [src]!"))
			stored_huggers = min(huggers_max_amount, stored_huggers + 1)
			qdel(hugger)
		else
			to_chat(user, SPAN_XENOWARNING("This child is dead."))
		return

	//refill egg morpher from an egg
	if(istype(item, /obj/item/xeno_egg))
		var/obj/item/xeno_egg/egg = item
		if(stored_huggers >= huggers_max_amount)
			to_chat(user, SPAN_XENOWARNING("\The [src] is full of children."))
			return
		if(user)
			visible_message(SPAN_XENOWARNING("[user] slides a facehugger out of \the [egg] into \the [src]."),
				SPAN_XENONOTICE("You place the child from an egg into \the [src]."))
			user.temp_drop_inv_item(egg)
		stored_huggers = min(huggers_max_amount, stored_huggers + 1)
		playsound(src.loc, "sound/effects/alien_egg_move.ogg", 25)
		qdel(egg)
		return

	return ..(item, user)

/obj/effect/alien/resin/special/eggmorph/update_icon()
	..()
	appearance_flags |= KEEP_TOGETHER
	overlays.Cut()
	underlays.Cut()
	underlays += "[icon_state]_underlay"

/obj/effect/alien/resin/special/eggmorph/process()
	check_facehugger_target()

	if(!linked_hive || !COOLDOWN_FINISHED(src, spawn_cooldown) || stored_huggers == huggers_to_grow_max)
		return
	COOLDOWN_START(src, spawn_cooldown, get_egg_cooldown())
	if(stored_huggers < huggers_to_grow_max)
		stored_huggers = min(huggers_to_grow_max, stored_huggers + 1)

/obj/effect/alien/resin/special/eggmorph/proc/check_facehugger_target()
	if(!range_bounds)
		range_bounds = SQUARE(x, y, EGGMORPG_RANGE)

	var/list/targets = SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if(isnull(targets) || !length(targets))
		return

	for(var/mob/living/carbon/xenomorph/xeno in targets)
		targets -= xeno //Don't add xenomorphs to the list of possible players we hug.


	if(!length(targets))
		return
	var/target = pick(targets)
	if(isnull(target))
		return

	HasProximity(target)

/obj/effect/alien/resin/special/eggmorph/HasProximity(atom/movable/AM as mob|obj)
	if(!stored_huggers || issynth(AM))
		return

	if (!linked_hive)
		return

	if(!can_hug(AM, linked_hive.hivenumber))
		return

	stored_huggers = max(0, stored_huggers - 1)

	var/obj/item/clothing/mask/facehugger/child = new(loc, linked_hive.hivenumber)
	child.leap_at_nearest_target()

/obj/effect/alien/resin/special/eggmorph/attack_alien(mob/living/carbon/xenomorph/M)
	if(!istype(M))
		return attack_hand(M)
	if(!linked_hive || (M.hivenumber != linked_hive.hivenumber))
		return ..(M)
	if(stored_huggers)
		//this way another hugger doesn't immediately spawn after we pick one up
		if(stored_huggers == huggers_to_grow_max)
			COOLDOWN_START(src, spawn_cooldown, get_egg_cooldown())

		to_chat(M, SPAN_XENONOTICE("You retrieve a child."))
		stored_huggers = max(0, stored_huggers - 1)
		var/obj/item/clothing/mask/facehugger/hugger = new(loc, linked_hive.hivenumber)
		SEND_SIGNAL(M, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER, hugger)
		return XENO_NONCOMBAT_ACTION
	..()

/obj/effect/alien/resin/special/eggmorph/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Hugger but wants info
	join_as_facehugger_from_this(user)

/obj/effect/alien/resin/special/eggmorph/proc/get_egg_cooldown()
	if(linked_hive?.living_xeno_queen?.ovipositor)
		return spawn_cooldown_length_ovi
	return spawn_cooldown_length

/obj/effect/alien/resin/special/eggmorph/proc/join_as_facehugger_from_this(mob/dead/observer/user)
	if(stored_huggers <= huggers_reserved)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return
	if(!linked_hive.can_spawn_as_hugger(user))
		return
	//Need to check again because time passed due to the confirmation window
	if(stored_huggers <= huggers_reserved)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return
	linked_hive.spawn_as_hugger(user, src)
	stored_huggers--

/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher(obj/effect/alien/resin/special/eggmorph/morpher in oview(1))
	set name = "Set Hugger Reserve"
	set desc = "Set Hugger Reserve"
	set category = null

	if(!istype(morpher))
		return

	if(morpher.linked_hive)
		if(hivenumber != morpher.linked_hive.hivenumber)
			to_chat(usr, SPAN_WARNING("This belongs to another Hive! Yuck!"))
			return

	morpher.huggers_reserved = tgui_input_number(usr, "How many facehuggers would you like to keep safe from Observers wanting to join as facehuggers?", "How many to reserve?", 0, morpher.huggers_max_amount, morpher.huggers_reserved)

	to_chat(usr, SPAN_XENONOTICE("You reserved [morpher.huggers_reserved] facehuggers for your sisters."))

#undef EGGMORPG_RANGE
