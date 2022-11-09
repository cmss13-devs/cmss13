#define BLOCK_NOTHING 				0
#define BLOCK_SPECIAL_STRUCTURES	1
#define BLOCK_ALL_STRUCTURES		2

/obj/effect/alien/weeds
	name = "weeds"
	desc = "Weird black weeds..."
	icon = 'icons/mob/hostiles/weeds.dmi'
	icon_state = "base"

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

/obj/effect/alien/weeds/Initialize(mapload, obj/effect/alien/weeds/node/node)
	. = ..()
	if(node)
		linked_hive = node.linked_hive
		weed_strength = node.weed_strength
		node_range = node.node_range
		if(weed_strength >= WEED_LEVEL_HIVE)
			name = "hive [name]"
			health = WEED_HEALTH_HIVE
		node.add_child(src)
		hivenumber = linked_hive.hivenumber
		spread_on_semiweedable = node.spread_on_semiweedable
		if(weed_strength < WEED_LEVEL_HIVE && spread_on_semiweedable)
			name = "hardy [name]"
			health = WEED_HEALTH_HARDY
		block_structures = node.block_structures
		fruit_growth_multiplier = node.fruit_growth_multiplier
	else
		linked_hive = GLOB.hive_datum[hivenumber]

	set_hive_data(src, hivenumber)
	if(spread_on_semiweedable)
		if(color)
			var/list/RGB = ReadRGB(color)
			RGB[1] = Clamp(RGB[1] + 35, 0, 255)
			RGB[2] = Clamp(RGB[2] + 35, 0, 255)
			RGB[3] = Clamp(RGB[3] + 35, 0, 255)
			color = rgb(RGB[1], RGB[2], RGB[3])
		else
			color = "#a1a1a1"

	update_icon()
	update_neighbours()
	if(node && node.loc)
		if(get_dist(node, src) >= node.node_range)
			SEND_SIGNAL(parent, COMSIG_WEEDNODE_GROWTH_COMPLETE)
		else if(!hibernate)
			addtimer(CALLBACK(src, .proc/weed_expand), WEED_BASE_GROW_SPEED / max(weed_strength, 1))

	var/turf/T = get_turf(src)
	T.weeds = src
	weeded_turf = T

	RegisterSignal(src, list(
		COMSIG_ATOM_TURF_CHANGE,
		COMSIG_MOVABLE_TURF_ENTERED
	), .proc/set_turf_weeded)

/obj/effect/alien/weeds/proc/set_turf_weeded(var/datum/source, var/turf/T)
	SIGNAL_HANDLER
	if(weeded_turf)
		weeded_turf.weeds = null

	T.weeds = src

/obj/effect/alien/weeds/initialize_pass_flags(var/datum/pass_flags_container/PF)
	. = ..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_WEEDS

/obj/effect/alien/weeds/proc/on_weed_expand(var/obj/effect/alien/weeds/spread_from, var/list/new_weeds)
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
	name = "weak resin node"
	health = WEED_HEALTH_STANDARD
	alpha = 127

/obj/effect/alien/weeds/node/weak/Initialize(mapload, obj/effect/alien/weeds/node/node, var/mob/living/carbon/Xenomorph/X, var/datum/hive_status/hive)
	. = ..()
	name = initial(name)
	weed_strength = WEED_LEVEL_WEAK

	update_icon()

/obj/effect/alien/weeds/node/weak/on_weed_expand(var/obj/effect/alien/weeds/spread_from, var/list/new_weeds)
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


/obj/effect/alien/weeds/Crossed(atom/movable/AM)
	if (ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if (!isYautja(H) && !H.ally_of_hivenumber(linked_hive.hivenumber)) // predators are immune to weed slowdown effect
			H.next_move_slowdown = H.next_move_slowdown + weed_strength
	else if (isXeno(AM))
		var/mob/living/carbon/Xenomorph/X = AM
		if (!linked_hive.is_ally(X))
			X.next_move_slowdown = X.next_move_slowdown + (weed_strength*WEED_XENO_SPEED_MULT)

// Uh oh, we might be dying!
// I know this is bad proc naming but it was too good to pass on and it's only used in this file anyways
// If you're still confused, scroll aaaall the way down to the bottom of the file.
// that's /obj/effect/alien/weeds/node/Destroy().
/obj/effect/alien/weeds/proc/avoid_orphanage()
	for(var/obj/effect/alien/weeds/node/N in orange(node_range, get_turf(src)))
		// WE FOUND A NEW MOMMY
		N.add_child(src)
		break

	// NO MORE FOOD ON THE TABLE. WE DIE
	if(!parent || weed_strength > WEED_LEVEL_STANDARD)
		qdel(src)

/obj/effect/alien/weeds/proc/weed_expand()
	if(!parent)
		return

	var/obj/effect/alien/weeds/node/node = parent
	var/turf/U = get_turf(src)

	if(!istype(U))
		return

	var/list/weeds = list()
	for(var/dirn in cardinal)
		var/turf/T = get_step(src, dirn)
		if(!istype(T))
			continue
		var/is_weedable = T.is_weedable()
		if(!is_weedable)
			continue
		if(!spread_on_semiweedable && is_weedable < FULLY_WEEDABLE)
			continue

		var/obj/effect/alien/weeds/W = locate() in T
		if(W)
			if(W.indestructible)
				continue
			else if(W.weed_strength >= WEED_LEVEL_HIVE)
				continue
			else if (W.linked_hive == node.linked_hive && W.weed_strength >= node.weed_strength)
				continue
			qdel(W)

		if(istype(T, /turf/closed/wall/resin))
			continue

		if(istype(T, /turf/closed/wall) && T.density)
			weeds.Add(new /obj/effect/alien/weeds/weedwall(T, node))
			continue

		if(!weed_expand_objects(T, dirn))
			continue

		weeds.Add(new /obj/effect/alien/weeds(T, node))

	on_weed_expand(src, weeds)
	if(parent)
		parent.on_weed_expand(src, weeds)

	return weeds

/obj/effect/alien/weeds/proc/weed_expand_objects(var/turf/T, var/direction)
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
			if(to_blocking_cade.density && to_blocking_cade.dir == reverse_dir[direction] && to_blocking_cade.health >= (to_blocking_cade.maxhealth / 4))
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
		for(var/dirn in cardinal)
			var/turf/T = get_step(U, dirn)

			if(!istype(T))
				continue

			var/obj/effect/alien/weeds/W = locate() in T
			if(W)
				W.update_icon()

/obj/effect/alien/weeds/update_icon()
	overlays.Cut()

	var/my_dir = 0
	for(var/check_dir in cardinal)
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
			secretion = image('icons/mob/hostiles/Effects.dmi', "secrete[icon_dir]")
		else if(icon_dir == -15)
			secretion = image('icons/mob/hostiles/Effects.dmi', "secrete_base")
		else
			secretion = image('icons/mob/hostiles/Effects.dmi', "secrete_dir[-icon_dir]")

		overlays += secretion

/obj/effect/alien/weeds/ex_act(severity)
	if(indestructible)
		return
	take_damage(severity * WEED_EXPLOSION_DAMAGEMULT)

/obj/effect/alien/weeds/attack_alien(mob/living/carbon/Xenomorph/X)
	if(!indestructible && !HIVE_ALLIED_TO_HIVE(X.hivenumber, hivenumber))
		X.animation_attack_on(src)
		X.visible_message(SPAN_DANGER("\The [X] slashes [src]!"), \
		SPAN_DANGER("You slash [src]!"), null, 5)
		playsound(loc, "alien_resin_break", 25)
		take_damage(X.melee_damage_lower*WEED_XENO_DAMAGEMULT)
		return XENO_ATTACK_ACTION


/obj/effect/alien/weeds/attackby(obj/item/W, mob/living/user)
	if(indestructible)
		return FALSE

	if(QDELETED(W) || QDELETED(user) || (W.flags_item & NOBLUDGEON))
		return 0

	if(istype(src, /obj/effect/alien/weeds/node)) //The pain is real
		to_chat(user, SPAN_WARNING("You hit \the [src] with \the [W]."))
	else
		to_chat(user, SPAN_WARNING("You cut \the [src] away with \the [W]."))

	var/damage = W.force / 3
	playsound(loc, "alien_resin_break", 25)

	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(2))
			damage = WEED_HEALTH_STANDARD
			playsound(loc, 'sound/items/Welder.ogg', 25, 1)
	else
		playsound(loc, "alien_resin_break", 25)


	user.animation_attack_on(src)

	take_damage(damage)
	return TRUE //don't call afterattack

/obj/effect/alien/weeds/proc/take_damage(var/damage)
	if(indestructible)
		return

	health -= damage
	if(health <= 0)
		qdel(src)

/obj/effect/alien/weeds/flamer_fire_act(dam)
	if(indestructible)
		return

	. = ..()
	if(!QDELETED(src))
		QDEL_IN(src, rand(1 SECONDS, 2 SECONDS)) // 1-2 seconds

/obj/effect/alien/weeds/acid_spray_act()
	if(indestructible)
		return

	. = ..()
	take_damage(20 * WEED_XENO_DAMAGEMULT)

/obj/effect/alien/weeds/weedwall
	layer = RESIN_STRUCTURE_LAYER
	plane = GAME_PLANE
	icon_state = "weedwall"
	var/list/wall_connections = list("0", "0", "0", "0")
	hibernate = TRUE

/obj/effect/alien/weeds/weedwall/update_icon()
	if(istype(loc, /turf/closed/wall))
		var/turf/closed/wall/W = loc
		wall_connections = W.wall_connections
		icon_state = ""
		var/image/I
		for(var/i = 1 to 4)
			I = image(icon, "weedwall[wall_connections[i]]", dir = 1<<(i-1))
			overlays += I

/obj/effect/alien/weeds/weedwall/window
	layer = ABOVE_TABLE_LAYER

/obj/effect/alien/weeds/weedwall/window/update_icon()
	var/obj/structure/window/framed/F = locate() in loc
	if(F && F.junction)
		icon_state = "weedwall[F.junction]"

/obj/effect/alien/weeds/weedwall/frame
	layer = ABOVE_TABLE_LAYER

/obj/effect/alien/weeds/weedwall/frame/update_icon()
	var/obj/structure/window_frame/WF = locate() in loc
	if(WF && WF.junction)
		icon_state = "weedframe[WF.junction]"


/obj/effect/alien/weeds/node
	name = "resin node"
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

/obj/effect/alien/weeds/node/proc/add_child(var/obj/effect/alien/weeds/weed)
	if(!weed || !istype(weed))
		return
	weed.parent = src
	children += weed

/obj/effect/alien/weeds/node/proc/remove_child(var/obj/effect/alien/weeds/weed)
	if(!weed || !istype(weed) || !(weed in children))
		return
	weed.parent = null
	children -= weed

/obj/effect/alien/weeds/node/proc/replace_child(var/turf/T, var/weed_type)
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

/obj/effect/alien/weeds/node/Initialize(mapload, obj/effect/alien/weeds/node/node, mob/living/carbon/Xenomorph/X, datum/hive_status/hive)
	if (istype(hive))
		linked_hive = hive
	else if (istype(X) && X.hive)
		linked_hive = X.hive
	else
		linked_hive = GLOB.hive_datum[hivenumber]

	for(var/obj/effect/alien/weeds/W in loc)
		if(W != src)
			if(W.weed_strength > WEED_LEVEL_HIVE)
				qdel(src)
				return
			qdel(W) //replaces the previous weed
			break

	. = ..(mapload, src)

	if(!staticnode)
		staticnode = image('icons/mob/hostiles/weeds.dmi', "weednode", ABOVE_OBJ_LAYER)

	var/obj/effect/alien/resin/trap/TR = locate() in loc
	if(TR)
		RegisterSignal(TR, COMSIG_PARENT_PREQDELETED, .proc/trap_destroyed)
		overlay_node = FALSE
		overlays -= staticnode

	if(X)
		add_hiddenprint(X)
		weed_strength = X.weed_level
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
	), .proc/complete_growth)

	update_icon()

/obj/effect/alien/weeds/node/Destroy()
	// When the node is removed, weeds should start dying out
	// Make all the children look for a new parent node
	for(var/X in children)
		var/obj/effect/alien/weeds/W = X
		remove_child(W)
		addtimer(CALLBACK(W, .proc/avoid_orphanage), WEED_BASE_DECAY_SPEED + rand(0, 1 SECONDS)) // Slight variation whilst decaying

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
	var/obj/effect/alien/resin/special/resin_parent

/obj/effect/alien/weeds/node/pylon/proc/set_parent_damaged()
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

/obj/effect/alien/weeds/node/pylon/attack_alien(mob/living/carbon/Xenomorph/X)
	return

/obj/effect/alien/weeds/node/pylon/flamer_fire_act(dam)
	return

/obj/effect/alien/weeds/node/pylon/acid_spray_act()
	return

/obj/effect/alien/weeds/node/pylon/cluster/set_parent_damaged()
	var/obj/effect/alien/resin/special/cluster/parent_cluster = resin_parent
	parent_cluster.damaged = TRUE

/obj/effect/resin_construct
	mouse_opacity = 0
	icon = 'icons/mob/hostiles/Effects.dmi'

/obj/effect/resin_construct/door
	icon_state = "DoorConstruct"

/obj/effect/resin_construct/thick
	icon_state = "ThickConstruct"

/obj/effect/resin_construct/weak
	icon_state = "WeakConstruct"

/obj/effect/resin_construct/transparent/thick
	icon_state = "ThickTransparentConstruct"

/obj/effect/resin_construct/transparent/weak
	icon_state = "WeakTransparentConstruct"

#undef WEED_BASE_GROW_SPEED
