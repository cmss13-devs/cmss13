#define BLOCK_NOTHING 0
#define BLOCK_SPECIAL_STRUCTURES 1
#define BLOCK_ALL_STRUCTURES 2

/obj/effect/alien/weeds
	name = "weeds"
	desc = "Weird black weeds..."
	icon = 'icons/mob/xenos/weeds.dmi'
	icon_state = "base"

	gender = PLURAL
	anchored = TRUE
	density = FALSE
	layer = WEED_LAYER
	plane = FLOOR_PLANE
	unacidable = TRUE
	health = WEED_HEALTH_STANDARD
	var/weed_strength = WEED_LEVEL_STANDARD
	var/node_range = WEED_RANGE_STANDARD
	var/secreting = FALSE

	var/hibernate = FALSE

	var/fruit_growth_multiplier = 1
	var/spread_on_semiweedable = FALSE
	var/block_structures = BLOCK_NOTHING

	var/datum/hive_status/linked_hive = null
	var/hivenumber = XENO_HIVE_NORMAL
	var/turf/weeded_turf

	// Which node is responsible for keeping this weed patch alive?
	var/obj/effect/alien/weeds/node/parent = null

/obj/effect/alien/weeds/Initialize(mapload, obj/effect/alien/weeds/node/node, use_node_strength=TRUE, do_spread=TRUE)
	. = ..()

	if(node)
		linked_hive = node.linked_hive
		if(use_node_strength)
			weed_strength = node.weed_strength
		node_range = node.node_range
		if(weed_strength >= WEED_LEVEL_HIVE)
			name = "hive [name]"
			health = WEED_HEALTH_HIVE
		node.add_child(src)
		hivenumber = linked_hive.hivenumber
		spread_on_semiweedable = node.spread_on_semiweedable
		if(weed_strength == WEED_LEVEL_HARDY && spread_on_semiweedable)
			name = "hardy [name]"
			health = WEED_HEALTH_HARDY
		block_structures = node.block_structures
		fruit_growth_multiplier = node.fruit_growth_multiplier
	else
		linked_hive = GLOB.hive_datum[hivenumber]

	set_hive_data(src, hivenumber)
	if(spread_on_semiweedable && weed_strength == WEED_LEVEL_HARDY)
		if(color)
			var/list/RGB = ReadRGB(color)
			RGB[1] = clamp(RGB[1] + 35, 0, 255)
			RGB[2] = clamp(RGB[2] + 35, 0, 255)
			RGB[3] = clamp(RGB[3] + 35, 0, 255)
			color = rgb(RGB[1], RGB[2], RGB[3])
		else
			color = "#a1a1a1"

	update_icon()
	update_neighbours()
	if(node && node.loc)
		if(get_dist(node, src) >= node.node_range)
			SEND_SIGNAL(parent, COMSIG_WEEDNODE_GROWTH_COMPLETE)
		else if(!hibernate && do_spread)
			addtimer(CALLBACK(src, PROC_REF(weed_expand)), WEED_BASE_GROW_SPEED / max(weed_strength, 1))

	var/turf/turf = get_turf(src)
	if(turf)
		turf.weeds = src
		weeded_turf = turf
		SEND_SIGNAL(turf, COMSIG_WEEDNODE_GROWTH) // Currently for weed_food wakeup

	RegisterSignal(src, list(
		COMSIG_ATOM_TURF_CHANGE,
		COMSIG_MOVABLE_TURF_ENTERED
	), PROC_REF(set_turf_weeded))
	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

	var/area/area = get_area(src)
	if(area && area.linked_lz)
		AddComponent(/datum/component/resin_cleanup)

/obj/effect/alien/weeds/proc/set_turf_weeded(datum/source, turf/T)
	SIGNAL_HANDLER
	if(weeded_turf)
		weeded_turf.weeds = null

	T.weeds = src

/obj/effect/alien/weeds/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)
		linked_hive = GLOB.hive_datum[XENO_HIVE_FORSAKEN]

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/obj/effect/alien/weeds/initialize_pass_flags(datum/pass_flags_container/PF)
	. = ..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_WEEDS

/obj/effect/alien/weeds/proc/on_weed_expand(obj/effect/alien/weeds/spread_from, list/new_weeds)
	if(!length(new_weeds) && parent)
		SEND_SIGNAL(parent, COMSIG_WEEDNODE_CANNOT_EXPAND_FURTHER)

/obj/effect/alien/weeds/weak
	name = "weak weeds"
	alpha = 127

/obj/effect/alien/weeds/weak/Initialize(mapload, obj/effect/alien/weeds/node/node)
	. = ..()
	name = initial(name)
	weed_strength = WEED_LEVEL_WEAK

	update_icon()

/obj/effect/alien/weeds/node/weak
	name = "weak weed node"
	health = WEED_HEALTH_STANDARD
	alpha = 127

/obj/effect/alien/weeds/node/weak/Initialize(mapload, obj/effect/alien/weeds/node/node, mob/living/carbon/xenomorph/X, datum/hive_status/hive)
	. = ..()
	name = initial(name)
	weed_strength = WEED_LEVEL_WEAK

	update_icon()

/obj/effect/alien/weeds/node/weak/on_weed_expand(obj/effect/alien/weeds/spread_from, list/new_weeds)
	..()
	var/atom/to_copy = /obj/effect/alien/weeds/weak
	for(var/i in new_weeds)
		var/obj/effect/alien/weeds/W = i
		W.name = initial(to_copy.name)
		W.alpha = initial(to_copy.alpha)


/obj/effect/alien/weeds/Destroy()
	if(parent)
		if(istype(parent, /obj/effect/alien/weeds/node/pylon))
			var/obj/effect/alien/weeds/node/pylon/P = parent
			P.set_parent_damaged()
		parent.remove_child(src)

	var/oldloc = loc
	parent = null

	if(weeded_turf)
		weeded_turf.weeds = null

	weeded_turf = null
	. = ..()
	update_neighbours(oldloc)

/obj/effect/alien/weeds/get_examine_text(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	if(istype(T, /turf/open))
		var/ceiling_info = T.ceiling_desc(user)
		if(ceiling_info)
			. += ceiling_info


/obj/effect/alien/weeds/Crossed(atom/movable/atom_movable)
	if(!isliving(atom_movable))
		return

	var/mob/living/crossing_mob = atom_movable

	var/weed_slow = weed_strength
	if(crossing_mob.ally_of_hivenumber(linked_hive.hivenumber))
		if( (crossing_mob.hivenumber != linked_hive.hivenumber) && prob(7)) // small chance for allied mobs to get a message indicating this
			to_chat(crossing_mob, SPAN_NOTICE("The weeds seem to reshape themselves around your feet as you walk on them."))
		return

	var/list/slowdata = list("movement_slowdown" = weed_slow)
	SEND_SIGNAL(crossing_mob, COMSIG_MOB_WEED_SLOWDOWN, slowdata, src)
	var/final_slowdown = slowdata["movement_slowdown"]

	crossing_mob.next_move_slowdown = max(crossing_mob.next_move_slowdown, POSITIVE(final_slowdown))

// Uh oh, we might be dying!
// I know this is bad proc naming but it was too good to pass on and it's only used in this file anyways
// If you're still confused, scroll aaaall the way down to the bottom of the file.
// that's /obj/effect/alien/weeds/node/Destroy().
/obj/effect/alien/weeds/proc/avoid_orphanage()
	var/parent_type = /obj/effect/alien/weeds/node
	if(weed_strength >= WEED_LEVEL_HIVE)
		parent_type = /obj/effect/alien/weeds/node/pylon

	var/obj/effect/alien/weeds/node/found = locate(parent_type) in orange(node_range, get_turf(src))
	if(found)
		found.add_child(src)

	// NO MORE FOOD ON THE TABLE. WE DIE
	if(!parent)
		qdel(src)

/obj/effect/alien/weeds/proc/weed_expand()
	if(!parent)
		return

	var/obj/effect/alien/weeds/node/node = parent
	var/turf/U = get_turf(src)

	if(!istype(U))
		return

	var/list/weeds = list()
	for(var/dirn in GLOB.cardinals)
		var/turf/T = get_step(src, dirn)
		if(!istype(T))
			continue
		var/is_weedable = T.is_weedable()
		if(!is_weedable)
			continue
		if(!spread_on_semiweedable && is_weedable < FULLY_WEEDABLE)
			continue
		T.clean_cleanables()

		var/obj/effect/alien/resin/fruit/old_fruit

		var/obj/effect/alien/weeds/W = locate() in T
		if(W)
			if(W.explo_proof)
				continue
			else if(W.weed_strength >= WEED_LEVEL_HIVE)
				continue
			else if (W.linked_hive == node.linked_hive && W.weed_strength >= node.weed_strength)
				continue

			old_fruit = locate() in T

			if(old_fruit)
				old_fruit.unregister_weed_expiration_signal()

			qdel(W)

		if(!istype(T, /turf/closed/wall/resin) && T.density)
			if(istype(T, /turf/closed/wall))
				weeds.Add(new /obj/effect/alien/weeds/weedwall(T, node))
				continue
			else if( istype(T, /turf/closed))
				weeds.Add(new /obj/effect/alien/weeds(T, node, TRUE, FALSE))
				continue

		if(!weed_expand_objects(T, dirn))
			continue

		var/obj/effect/alien/weeds/new_weed = new(T, node)
		weeds += new_weed

		if(old_fruit)
			old_fruit.register_weed_expiration_signal(new_weed)

	on_weed_expand(src, weeds)
	if(parent)
		parent.on_weed_expand(src, weeds)

	return weeds

/obj/effect/alien/weeds/proc/weed_expand_objects(turf/T, direction)
	for(var/obj/structure/platform/P in src.loc)
		if(P.dir == reverse_direction(direction))
			return FALSE
	for(var/obj/structure/barricade/from_blocking_cade in loc) //cades on tile we're coming from
		if(from_blocking_cade.density && from_blocking_cade.dir == direction && from_blocking_cade.health >= (from_blocking_cade.maxhealth / 4))
			return FALSE

	for(var/obj/O in T)
		if(istype(O, /obj/structure/platform))
			if(O.dir == direction)
				return FALSE

		if(istype(O, /obj/structure/barricade)) //cades on tile we're trying to expand to
			var/obj/structure/barricade/to_blocking_cade = O
			if(to_blocking_cade.density && to_blocking_cade.dir == GLOB.reverse_dir[direction] && to_blocking_cade.health >= (to_blocking_cade.maxhealth / 4))
				return FALSE

		if(istype(O, /obj/structure/window/framed))
			new /obj/effect/alien/weeds/weedwall/window(T, parent)
			return FALSE
		else if(istype(O, /obj/structure/window_frame))
			new /obj/effect/alien/weeds/weedwall/frame(T, parent)
			return FALSE
		else if(istype(O, /obj/structure/machinery/door) && O.density && (!(O.flags_atom & ON_BORDER) || O.dir != direction))
			return FALSE
	return TRUE

/obj/effect/alien/weeds/proc/update_neighbours(turf/U)
	if(!U)
		U = loc
	if(istype(U))
		for(var/dirn in GLOB.cardinals)
			var/turf/T = get_step(U, dirn)

			if(!istype(T))
				continue

			var/obj/effect/alien/weeds/W = locate() in T
			if(W)
				W.update_icon()

/obj/effect/alien/weeds/update_icon()
	overlays.Cut()

	var/my_dir = 0
	for(var/check_dir in GLOB.cardinals)
		var/turf/check = get_step(src, check_dir)

		if(!istype(check))
			continue
		if(istype(check, /turf/closed/wall/resin))
			my_dir |= check_dir

		else if (locate(/obj/effect/alien/weeds) in check)
			my_dir |= check_dir

	// big brain the icon dir by letting -15 represent the base icon,
	// 0-15 be for omnidirectional and -1 to -14 be the rest

	var/icon_dir = -15
	if(my_dir == 15) //weeds in all four directions
		icon_dir = rand(0,15)
		icon_state = "weed[icon_dir]"
		if(weed_strength >= WEED_LEVEL_HIVE)
			icon_state = "hive_[icon_state]"
	else if(my_dir == 0) //no weeds in any direction
		icon_state = "base"
	else
		icon_dir = -my_dir
		icon_state = "weed_dir[my_dir]"

	if(secreting)
		var/image/secretion

		if(icon_dir >= 0)
			secretion = image('icons/mob/xenos/effects.dmi', "secrete[icon_dir]")
		else if(icon_dir == -15)
			secretion = image('icons/mob/xenos/effects.dmi', "secrete_base")
		else
			secretion = image('icons/mob/xenos/effects.dmi', "secrete_dir[-icon_dir]")

		overlays += secretion

/obj/effect/alien/weeds/ex_act(severity)
	if(explo_proof)
		return
	take_damage(severity * WEED_EXPLOSION_DAMAGEMULT)

/obj/effect/alien/weeds/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)
	if(!explo_proof && !HIVE_ALLIED_TO_HIVE(attacking_xeno.hivenumber, hivenumber))
		attacking_xeno.animation_attack_on(src)
		attacking_xeno.visible_message(SPAN_DANGER("\The [attacking_xeno] slashes [src]!"),
		SPAN_DANGER("You slash [src]!"), null, 5)
		playsound(loc, "alien_resin_break", 25)
		take_damage(attacking_xeno.melee_damage_lower*WEED_XENO_DAMAGEMULT)
		return XENO_ATTACK_ACTION

/obj/effect/alien/weeds/attackby(obj/item/attacking_item, mob/living/user)
	if(explo_proof)
		return FALSE

	if(QDELETED(attacking_item) || QDELETED(user) || (attacking_item.flags_item & NOBLUDGEON))
		return 0

	if(istype(src, /obj/effect/alien/weeds/node)) //The pain is real
		to_chat(user, SPAN_WARNING("You hit \the [src] with \the [attacking_item]."))
	else
		to_chat(user, SPAN_WARNING("You cut \the [src] away with \the [attacking_item]."))

	var/damage = (attacking_item.force * attacking_item.demolition_mod) / 3
	playsound(loc, "alien_resin_break", 25)

	if(iswelder(attacking_item))
		var/obj/item/tool/weldingtool/WT = attacking_item
		if(WT.remove_fuel(2))
			damage = WEED_HEALTH_STANDARD
			playsound(loc, 'sound/items/Welder.ogg', 25, 1)
	else
		playsound(loc, "alien_resin_break", 25)


	user.animation_attack_on(src)

	take_damage(damage)
	return (ATTACKBY_HINT_NO_AFTERATTACK|ATTACKBY_HINT_UPDATE_NEXT_MOVE)

/obj/effect/alien/weeds/proc/take_damage(damage)
	if(explo_proof)
		return

	health -= damage
	if(health <= 0)
		deconstruct(FALSE)

/obj/effect/alien/weeds/flamer_fire_act(dam)
	if(explo_proof)
		return

	. = ..()
	if(!QDELETED(src))
		QDEL_IN(src, rand(1 SECONDS, 2 SECONDS)) // 1-2 seconds

/obj/effect/alien/weeds/acid_spray_act()
	if(explo_proof)
		return

	. = ..()
	take_damage(20 * WEED_XENO_DAMAGEMULT)

/obj/effect/alien/weeds/weedwall
	layer = RESIN_STRUCTURE_LAYER
	plane = GAME_PLANE
	icon_state = "weedwall"
	var/list/wall_connections = list("0", "0", "0", "0")
	hibernate = TRUE

/obj/effect/alien/weeds/weedwall/attackby(obj/item/attacking_item, mob/living/user)
	. = ..()
	if(isxeno(user) && istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/attacking_grab = attacking_item
		var/mob/living/carbon/xenomorph/user_as_xenomorph = user
		user_as_xenomorph.do_nesting_host(attacking_grab.grabbed_thing, src)

/obj/effect/alien/weeds/weedwall/MouseDrop_T(mob/current_mob, mob/user)
	. = ..()

	if(!ismob(current_mob))
		return

	if(isxeno(user) && istype(user.get_active_hand(), /obj/item/grab))
		var/mob/living/carbon/xenomorph/user_as_xenomorph = user
		user_as_xenomorph.do_nesting_host(current_mob, src)

/obj/effect/alien/weeds/weedwall/update_icon()
	if(istype(loc, /turf/closed/wall))
		var/turf/closed/wall/W = loc
		wall_connections = W.wall_connections
		icon_state = null
		var/image/I
		for(var/i = 1 to 4)
			I = image(icon, "weedwall[wall_connections[i]]", dir = 1<<(i-1))
			overlays += I

/obj/effect/alien/weeds/weedwall/window
	layer = ABOVE_TABLE_LAYER

/obj/effect/alien/weeds/weedwall/window/update_icon()
	var/obj/structure/window/framed/F = locate() in loc
	if(F && F.junction)
		icon_state = "weedwindow[F.junction]"

/obj/effect/alien/weeds/weedwall/frame
	layer = ABOVE_TABLE_LAYER

/obj/effect/alien/weeds/weedwall/frame/update_icon()
	var/obj/structure/window_frame/WF = locate() in loc
	if(WF && WF.junction)
		icon_state = "weedframe[WF.junction]"


/obj/effect/alien/weeds/node
	name = "weed node"
	desc = "A weird, pulsating node."
	icon_state = "weednode"
	// Weed nodes start out with normal weed health and become stronger once they've stopped spreading
	health = NODE_HEALTH_GROWING
	flags_atom = OPENCONTAINER
	layer = ABOVE_BLOOD_LAYER
	plane = FLOOR_PLANE
	var/static/staticnode
	var/overlay_node = TRUE

	// Which weeds are being kept alive by this node?
	var/list/obj/effect/alien/weeds/children = list()

/obj/effect/alien/weeds/node/proc/add_child(obj/effect/alien/weeds/weed)
	if(!weed || !istype(weed))
		return
	weed.parent = src
	children += weed

/obj/effect/alien/weeds/node/proc/remove_child(obj/effect/alien/weeds/weed)
	if(!weed || !istype(weed) || !(weed in children))
		return
	weed.parent = null
	children -= weed

/obj/effect/alien/weeds/node/proc/replace_child(turf/T, weed_type)
	if(!T || !istype(T) || QDELETED(src))
		return
	var/obj/effect/alien/weeds/replacement_child = new weed_type(T, src)
	add_child(replacement_child)

/obj/effect/alien/weeds/node/update_icon()
	..()
	if(overlay_node)
		overlays += staticnode

/obj/effect/alien/weeds/node/proc/trap_destroyed()
	SIGNAL_HANDLER
	overlay_node = TRUE
	overlays += staticnode

/obj/effect/alien/weeds/node/Initialize(mapload, obj/effect/alien/weeds/node/node, mob/living/carbon/xenomorph/xeno, datum/hive_status/hive)
	if (istype(hive))
		linked_hive = hive
	else if (istype(xeno) && xeno.hive)
		linked_hive = xeno.hive
	else
		linked_hive = GLOB.hive_datum[hivenumber]

	for(var/obj/effect/alien/weeds/weed in loc)
		if(weed != src)
			if(weed.weed_strength > WEED_LEVEL_HIVE)
				qdel(src)
				return
			qdel(weed) //replaces the previous weed
			break

	. = ..(mapload, src)

	if(!staticnode)
		staticnode = image('icons/mob/xenos/weeds.dmi', "weednode", ABOVE_OBJ_LAYER)

	var/obj/effect/alien/resin/trap/trap = locate() in loc
	if(trap)
		RegisterSignal(trap, COMSIG_PARENT_PREQDELETED, PROC_REF(trap_destroyed))
		overlay_node = FALSE
		overlays -= staticnode

	if(xeno)
		add_hiddenprint(xeno)
		weed_strength = max(weed_strength, xeno.weed_level)
		if (weed_strength < WEED_LEVEL_STANDARD)
			weed_strength = WEED_LEVEL_STANDARD

		node_range = node_range + weed_strength - 1//stronger weeds expand further!
		if(weed_strength >= WEED_LEVEL_HIVE)
			name = "hive node sac"

	create_reagents(30)
	reagents.add_reagent(PLASMA_PURPLE, 30)

	RegisterSignal(src, list(
		COMSIG_WEEDNODE_GROWTH_COMPLETE,
		COMSIG_WEEDNODE_CANNOT_EXPAND_FURTHER,
	), PROC_REF(complete_growth))

	update_icon()

/obj/effect/alien/weeds/node/Destroy()
	// When the node is removed, weeds should start dying out
	// Make all the children look for a new parent node
	for(var/X in children)
		var/obj/effect/alien/weeds/W = X
		remove_child(W)
		addtimer(CALLBACK(W, PROC_REF(avoid_orphanage)), WEED_BASE_DECAY_SPEED + rand(0, 1 SECONDS)) // Slight variation whilst decaying

	. = ..()

/obj/effect/alien/weeds/node/proc/complete_growth()
	SIGNAL_HANDLER

	UnregisterSignal(src, list(
		COMSIG_WEEDNODE_GROWTH_COMPLETE,
		COMSIG_WEEDNODE_CANNOT_EXPAND_FURTHER,
	))
	health = NODE_HEALTH_STANDARD

/obj/effect/alien/weeds/node/alpha
	hivenumber = XENO_HIVE_ALPHA

/obj/effect/alien/weeds/node/feral
	hivenumber = XENO_HIVE_FERAL

/obj/effect/alien/weeds/node/forsaken
	hivenumber = XENO_HIVE_FORSAKEN

/obj/effect/alien/weeds/node/pylon
	health = WEED_HEALTH_HIVE
	weed_strength = WEED_LEVEL_HIVE
	node_range = WEED_RANGE_PYLON
	overlay_node = FALSE
	spread_on_semiweedable = TRUE
	var/obj/effect/alien/resin/special/resin_parent

/obj/effect/alien/weeds/node/pylon/proc/set_parent_damaged()
	if(!resin_parent)
		return

	var/obj/effect/alien/resin/special/pylon/parent_pylon = resin_parent
	parent_pylon.damaged = TRUE

/obj/effect/alien/weeds/node/pylon/core
	node_range = WEED_RANGE_CORE

/obj/effect/alien/weeds/node/pylon/Destroy()
	resin_parent = null
	return ..()

/obj/effect/alien/weeds/node/pylon/ex_act(severity)
	return

/obj/effect/alien/weeds/node/pylon/attackby(obj/item/W, mob/living/user)
	return

/obj/effect/alien/weeds/node/pylon/attack_alien(mob/living/carbon/xenomorph/X)
	return

/obj/effect/alien/weeds/node/pylon/flamer_fire_act(dam)
	return

/obj/effect/alien/weeds/node/pylon/acid_spray_act()
	return

/obj/effect/alien/weeds/node/pylon/cluster
	spread_on_semiweedable = TRUE

/obj/effect/alien/weeds/node/pylon/cluster/set_parent_damaged()
	if(!resin_parent)
		return

	var/obj/effect/alien/resin/special/cluster/parent_cluster = resin_parent
	parent_cluster.damaged = TRUE

/obj/effect/resin_construct
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/mob/xenos/effects.dmi'

/obj/effect/resin_construct/door
	icon_state = "DoorConstruct"

/obj/effect/resin_construct/thickdoor
	icon_state = "ThickDoorConstruct"

/obj/effect/resin_construct/thick
	icon_state = "ThickConstruct"

/obj/effect/resin_construct/weak
	icon_state = "WeakConstruct"

/obj/effect/resin_construct/transparent/thick
	icon_state = "ThickTransparentConstruct"

/obj/effect/resin_construct/transparent/weak
	icon_state = "WeakTransparentConstruct"

#undef WEED_BASE_GROW_SPEED
