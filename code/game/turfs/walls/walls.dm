/turf/closed/wall
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "0"
	opacity = TRUE
	layer = WALL_LAYER
	is_weedable = FULLY_WEEDABLE
	/// 1 = Can't be deconstructed by tools or thermite. Used for Sulaco walls
	var/walltype = WALL_METAL
	/// when walls smooth with one another, the type of junction each wall is.
	var/junctiontype
	var/thermite = 0
	var/melting = FALSE
	var/claws_minimum = CLAW_TYPE_SHARP

	tiles_with = list(
		/turf/closed/wall,
		/obj/structure/window/framed,
		/obj/structure/window_frame,
		/obj/structure/girder,
		/obj/structure/machinery/door,
	)

	var/damage = 0
	/// Wall will break down to girders if damage reaches this point
	var/damage_cap = HEALTH_WALL

	var/damage_overlay
	var/global/damage_overlays[8]

	var/current_bulletholes = null
	var/image/bullet_overlay = null
	var/list/wall_connections = list("0", "0", "0", "0")
	var/neighbors_list = 0
	var/repair_materials = list("wood"= 0.075, "metal" = 0.15, "plasteel" = 0.3) //Max health % recovered on a nailgun repair

	var/d_state = 0 //Normal walls are now as difficult to remove as reinforced walls

	/// the acid hole inside the wall
	var/obj/effect/acid_hole/acided_hole
	var/acided_hole_dir = SOUTH

	var/special_icon = 0
	var/list/blend_turfs = list(/turf/closed/wall)
	var/list/noblend_turfs = list(/turf/closed/wall/mineral, /turf/closed/wall/almayer/research/containment) //Turfs to avoid blending with
	var/list/blend_objects = list(/obj/structure/machinery/door, /obj/structure/window_frame, /obj/structure/window/framed) // Objects which to blend with
	var/list/noblend_objects = list(/obj/structure/machinery/door/window) //Objects to avoid blending with (such as children of listed blend objects.

	var/list/hiding_humans = list()

/turf/closed/wall/Initialize(mapload, ...)
	. = ..()
	is_weedable = initial(is_weedable) //so we can spawn weeds on the wall

	// Defer updating based on neighbors while we're still loading map
	if(mapload && . != INITIALIZE_HINT_QDEL)
		return INITIALIZE_HINT_LATELOAD
	// Otherwise do it now, but defer icon update to late if it's going to happen
	update_connections(TRUE)
	if(. != INITIALIZE_HINT_LATELOAD)
		update_icon()


/turf/closed/wall/LateInitialize()
	. = ..()
	// By default this assumes being used for map late init
	// We update without cascading changes as each wall will be updated individually
	update_connections(FALSE)
	update_icon()


/turf/closed/wall/setDir(newDir)
	..()
	update_connections(FALSE)
	update_icon()

/turf/closed/wall/ChangeTurf(newtype, ...)
	QDEL_NULL(acided_hole)

	. = ..()
	if(.) //successful turf change
		var/turf/T
		for(var/i in GLOB.cardinals)
			T = get_step(src, i)

			if(istype(T, /turf/closed/wall))
				var/turf/closed/wall/neighbour_wall = T

				neighbour_wall.update_connections()
				neighbour_wall.update_icon()

			//nearby glowshrooms updated
			for(var/obj/effect/glowshroom/shroom in T)
				if(!shroom.floor) //shrooms drop to the floor
					shroom.floor = 1
					shroom.icon_state = "glowshroomf"
					shroom.pixel_x = 0
					shroom.pixel_y = 0

		for(var/obj/found_object in src) //Eject contents!
			if(istype(found_object, /obj/structure/sign/poster))
				var/obj/structure/sign/poster/found_poster = found_object
				found_poster.roll_and_drop(src)
			if(istype(found_object, /obj/effect/alien/weeds/weedwall))
				qdel(found_object)

		var/list/turf/cardinal_neighbors = list(get_step(src, NORTH), get_step(src, SOUTH), get_step(src, EAST), get_step(src, WEST))
		for(var/turf/cardinal_turf as anything in cardinal_neighbors)
			for(var/obj/structure/bed/nest/found_nest in cardinal_turf)
				if(found_nest.dir == get_dir(found_nest, src) && !density)
					qdel(found_nest) //nests are built on walls, no walls, no nest

/turf/closed/wall/MouseDrop_T(mob/current_mob, mob/user)
	if(!ismob(current_mob))
		return

	if(acided_hole)
		if(current_mob == user && isxeno(user))
			acided_hole.use_wall_hole(user)
			return

	if(isxeno(user) && istype(user.get_active_hand(), /obj/item/grab))
		var/mob/living/carbon/xenomorph/user_as_xenomorph = user
		user_as_xenomorph.do_nesting_host(current_mob, src)

	// wall leaning by androbetel
	if(!ishuman(current_mob))
		return

	if(current_mob != user)
		return
	var/mob/living/carbon/hiding_human = current_mob
	var/can_lean = TRUE

	if(istype(user.l_hand, /obj/item/grab) || istype(user.r_hand, /obj/item/grab))
		to_chat(user, SPAN_WARNING("You can't lean while grabbing someone!"))
		can_lean = FALSE
	if(current_mob.is_mob_incapacitated())
		to_chat(user, SPAN_WARNING("You can't lean while incapacitated!"))
		can_lean = FALSE
	if(current_mob.resting)
		to_chat(user, SPAN_WARNING("You can't lean while resting!"))
		can_lean = FALSE
	if(current_mob.buckled)
		to_chat(user, SPAN_WARNING("You can't lean while buckled!"))
		can_lean = FALSE

	var/direction = get_dir(src, current_mob)
	var/shift_pixel_x = 0
	var/shift_pixel_y = 0

	if(!can_lean)
		return
	switch(direction)
		if(NORTH)
			shift_pixel_y = -10
		if(SOUTH)
			shift_pixel_y = 16
		if(WEST)
			shift_pixel_x = 10
		if(EAST)
			shift_pixel_x = -10
		else
			return

	for(var/mob/living/carbon/human/hiding in hiding_humans)
		if(hiding_humans[hiding] == direction)
			return

	hiding_humans += current_mob
	hiding_humans[current_mob] = direction
	hiding_human.Moved() //just to be safe
	hiding_human.setDir(direction)
	animate(hiding_human, pixel_x = shift_pixel_x, pixel_y = shift_pixel_y, time = 1)
	if(direction == NORTH)
		hiding_human.add_filter("cutout", 1, alpha_mask_filter(icon = icon('icons/effects/effects.dmi', "cutout")))
	ADD_TRAIT(hiding_human, TRAIT_UNDENSE, WALL_HIDING_TRAIT)
	RegisterSignal(hiding_human, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOB_RESISTED, COMSIG_MOB_ANIMATING), PROC_REF(unhide_human), hiding_human)
	..()

/turf/closed/wall/proc/unhide_human(mob/living/carbon/human/to_unhide)
	SIGNAL_HANDLER
	if(!to_unhide)
		return

	REMOVE_TRAIT(to_unhide, TRAIT_UNDENSE, WALL_HIDING_TRAIT)
	to_unhide.pixel_x = initial(to_unhide.pixel_x)
	to_unhide.pixel_y = initial(to_unhide.pixel_y)
	to_unhide.layer = initial(to_unhide.layer)
	to_unhide.apply_effect(1, SUPERSLOW)
	to_unhide.apply_effect(2, SLOW)
	hiding_humans -= to_unhide
	UnregisterSignal(to_unhide, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOB_RESISTED, COMSIG_MOB_ANIMATING))
	to_chat(to_unhide, SPAN_WARNING("You couldn't sit still so you stop leaning on the wall!"))
	to_unhide.remove_filter("cutout")

/turf/closed/wall/Destroy()
	if(hiding_humans.len)
		for(var/mob/living/carbon/human/human in hiding_humans)
			unhide_human(human)

	return ..()


/turf/closed/wall/attack_alien(mob/living/carbon/xenomorph/user)
	if(acided_hole && user.mob_size >= MOB_SIZE_BIG)
		acided_hole.expand_hole(user) //This proc applies the attack delay itself.
		return XENO_NO_DELAY_ACTION

	if(!(turf_flags & TURF_HULL) && user.claw_type >= claws_minimum && !acided_hole && user.a_intent == INTENT_HARM)
		user.animation_attack_on(src)
		playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
		if(damage >= (damage_cap - (damage_cap / XENO_HITS_TO_DESTROY_WALL)))
			var/dir_to = get_dir(user, src)
			switch(dir_to)
				if(WEST, EAST, NORTH, SOUTH)
					acided_hole_dir = dir_to
				if(NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST)
					var/turf/closed/wall/wall_north_turf = get_step(src, NORTH)
					var/turf/closed/wall/wall_south_turf = get_step(src, SOUTH)
					var/turf/closed/wall/wall_east_turf = get_step(src, EAST)
					var/turf/closed/wall/wall_west_turf = get_step(src, WEST)

					if(!istype(wall_north_turf) && !istype(wall_south_turf) && !istype(wall_east_turf) && !istype(wall_west_turf))
						acided_hole_dir = dir_to & (NORTH|SOUTH)
					else if(!istype(wall_north_turf) && !istype(wall_south_turf))
						acided_hole_dir = dir_to & (NORTH|SOUTH)
					else if(!istype(wall_east_turf) && !istype(wall_west_turf))
						acided_hole_dir = dir_to & (EAST|WEST)
					else
						acided_hole_dir = dir_to & (NORTH|SOUTH)
			new /obj/effect/acid_hole(src)
		else
			take_damage(damage_cap / XENO_HITS_TO_DESTROY_WALL)
		return XENO_ATTACK_ACTION

	. = ..()

//Appearance
/turf/closed/wall/get_examine_text(mob/user)
	. = ..()

	if(turf_flags & TURF_HULL)
		.+= SPAN_WARNING("You don't think you have any tools able to even scratch this.")
		return //If it's indestructable, we don't want to give the wrong impression by saying "you can decon it with a welder"

	if(!damage)
		if (acided_hole)
			. += SPAN_WARNING("It looks fully intact, except there's a large hole that could've been caused by some sort of acid.")
		else
			. += SPAN_NOTICE("It looks fully intact.")
	else
		var/dam = damage / damage_cap
		if(dam <= 0.3)
			. += SPAN_WARNING("It looks slightly damaged.")
		else if(dam <= 0.6)
			. += SPAN_WARNING("It looks moderately damaged.")
		else
			. += SPAN_DANGER("It looks heavily damaged.")

		if (acided_hole)
			. += SPAN_WARNING("There's a large hole in the wall that could've been caused by some sort of acid.")

	if(turf_flags & TURF_ORGANIC)
		return // Skip the part below. 'Organic' walls aren't deconstructable with tools.

	switch(d_state)
		if(WALL_STATE_WELD)
			. += SPAN_INFO("The outer plating is intact. If you are not on help intent, a blowtorch should slice it open.")
		if(WALL_STATE_SCREW)
			. += SPAN_INFO("The outer plating has been sliced open. A screwdriver should remove the support lines.")
		if(WALL_STATE_WIRECUTTER)
			. += SPAN_INFO("The support lines have been removed. Wirecutters will take care of the hydraulic lines.")
		if(WALL_STATE_WRENCH)
			. += SPAN_INFO("The hydralic lines have been cut. A wrench will remove the anchor bolts.")
		if(WALL_STATE_CROWBAR)
			. += SPAN_INFO("The anchor bolts have been removed. A crowbar will pry apart the connecting rods.")

//Damage
/turf/closed/wall/proc/take_damage(dam, mob/M)
	if(turf_flags & TURF_HULL) //Hull is literally invincible
		return
	if(!dam)
		return

	damage = max(0, damage + dam)

	if(damage >= damage_cap)
		if(M && istype(M))
			M.count_niche_stat(STATISTICS_NICHE_DESTRUCTION_WALLS, 1)
			SEND_SIGNAL(M, COMSIG_MOB_DESTROY_WALL, src)
		// Xenos used to be able to crawl through the wall, should suggest some structural damage to the girder
		if (acided_hole)
			dismantle_wall(1)
		else
			dismantle_wall()
	else
		update_icon()


/turf/closed/wall/proc/make_girder(destroyed_girder = FALSE)
	var/obj/structure/girder/G = new /obj/structure/girder(src)
	G.icon_state = "girder[junctiontype]"
	G.original = src.type

	if (destroyed_girder)
		G.dismantle()



// Devastated and Explode causes the wall to spawn a damaged girder
// Walls no longer spawn a metal sheet when destroyed to reduce clutter and
// improve visual readability.
/turf/closed/wall/proc/dismantle_wall(devastated = 0, explode = 0)
	if(turf_flags & TURF_HULL) //Hull is literally invincible
		return
	if(devastated)
		make_girder(TRUE)
	else if (explode)
		make_girder(TRUE)
	else
		make_girder(FALSE)

	ScrapeAway()

/turf/closed/wall/ex_act(severity, explosion_direction, datum/cause_data/cause_data)
	if(turf_flags & TURF_HULL)
		return
	var/location = get_step(get_turf(src), explosion_direction) // shrapnel will just collide with the wall otherwise
	var/exp_damage = severity*EXPLOSION_DAMAGE_MULTIPLIER_WALL
	var/mob/mob
	if(cause_data)
		mob = cause_data.resolve_mob()

	if (damage + exp_damage > damage_cap*2)
		if(mob)
			SEND_SIGNAL(mob, COMSIG_MOB_EXPLODED_WALL, src)
		dismantle_wall(FALSE, TRUE)
		if(!istype(src, /turf/closed/wall/resin))
			create_shrapnel(location, rand(2,5), explosion_direction, , /datum/ammo/bullet/shrapnel/light, cause_data)
	else
		if(istype(src, /turf/closed/wall/resin))
			exp_damage *= RESIN_EXPLOSIVE_MULTIPLIER
		else if (prob(25))
			if(prob(50)) // prevents spam in close corridors etc
				src.visible_message(SPAN_WARNING("The explosion causes shards to spall off of [src]!"))
			create_shrapnel(location, rand(2,5), explosion_direction, , /datum/ammo/bullet/shrapnel/spall, cause_data)
		take_damage(exp_damage, mob)

	return

/turf/closed/wall/get_explosion_resistance()
	if(turf_flags & TURF_HULL)
		return 1000000

	return (damage_cap - damage)/EXPLOSION_DAMAGE_MULTIPLIER_WALL

/turf/closed/wall/proc/thermitemelt(mob/user)
	if(melting)
		to_chat(user, SPAN_WARNING("The wall is already burning with thermite!"))
		return
	if(turf_flags & TURF_HULL)
		return
	melting = TRUE

	var/obj/effect/overlay/O = new/obj/effect/overlay(src)
	O.name = "thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "red_3"
	O.anchored = TRUE
	O.density = TRUE
	O.layer = FLY_LAYER

	to_chat(user, SPAN_WARNING("The thermite starts melting through [src]."))

	var/turf/closed/wall/W = src
	while(W.thermite > 0)
		if(!istype(src, /turf/closed/wall) || QDELETED(src))
			break

		thermite--
		take_damage(100, user)

		if(!istype(src, /turf/closed/wall) || QDELETED(src))
			break

		if(thermite > (damage_cap - damage)/100) // Thermite gains a speed buff when the amount is overkill
			var/timereduction = floor((thermite - (damage_cap - damage)/100)/5) // Every 5 units over the required amount reduces the sleep by 0.1s
			sleep(max(2, 20 - timereduction))
		else
			sleep(20)

		if(!istype(src, /turf/closed/wall) || QDELETED(src))
			break

	if(O || !QDELETED(O))
		qdel(O)

	if(istype(W))
		W.melting = FALSE


//Interactions
/turf/closed/wall/attack_animal(mob/living/M as mob)
	if(M.wall_smash)
		if((istype(src, /turf/closed/wall/r_wall)) || turf_flags & TURF_HULL)
			to_chat(M, SPAN_WARNING("This [name] is far too strong for you to destroy."))
			return
		else
			if((prob(40)))
				M.visible_message(SPAN_DANGER("[M] smashes through [src]."),
				SPAN_DANGER("You smash through the wall."))
				dismantle_wall(1)
				return
			else
				M.visible_message(SPAN_WARNING("[M] smashes against [src]."),
				SPAN_WARNING("You smash against the wall."))
				take_damage(rand(25, 75), M)
				return


/turf/closed/wall/attackby(obj/item/attacking_item, mob/user)
	if(isxeno(user) && istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/attacker_grab = attacking_item
		var/mob/living/carbon/xenomorph/user_as_xenomorph = user
		user_as_xenomorph.do_nesting_host(attacker_grab.grabbed_thing, src)

	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(attacking_item.heat_source >= 1000)
			if(turf_flags & TURF_HULL)
				to_chat(user, SPAN_WARNING("[src] is much too tough for you to do anything to it with [attacking_item]."))
			else
				if(iswelder(attacking_item))
					var/obj/item/tool/weldingtool/WT = attacking_item
					WT.remove_fuel(0,user)
				thermitemelt(user)
			return

	if(istype(attacking_item, /obj/item/weapon/twohanded/breacher))
		var/obj/item/weapon/twohanded/breacher/current_hammer = attacking_item
		if(user.action_busy)
			return
		if(!(HAS_TRAIT(user, TRAIT_SUPER_STRONG) || !current_hammer.really_heavy))
			to_chat(user, SPAN_WARNING("You can't use \the [current_hammer] properly!"))
			return
		if(turf_flags & TURF_HULL)
			to_chat(user, SPAN_WARNING("Even with your immense strength, you can't bring down \the [src]."))
			return

		to_chat(user, SPAN_NOTICE("You start taking down \the [src]."))
		if(!do_after(user, 5 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("You stop taking down \the [src]."))
			return
		to_chat(user, SPAN_NOTICE("You tear down \the [src]."))

		playsound(src, 'sound/effects/meteorimpact.ogg', 40, 1)
		playsound(src, 'sound/effects/ceramic_shatter.ogg', 40, 1)

		take_damage(damage_cap)
		return

	if(istype(attacking_item,/obj/item/frame/apc))
		var/obj/item/frame/apc/AH = attacking_item
		AH.try_build(src)
		return

	if(istype(attacking_item,/obj/item/frame/air_alarm))
		var/obj/item/frame/air_alarm/AH = attacking_item
		AH.try_build(src)
		return

	if(istype(attacking_item,/obj/item/frame/fire_alarm))
		var/obj/item/frame/fire_alarm/AH = attacking_item
		AH.try_build(src)
		return

	if(istype(attacking_item,/obj/item/frame/light_fixture))
		var/obj/item/frame/light_fixture/AH = attacking_item
		AH.try_build(src)
		return

	if(istype(attacking_item,/obj/item/frame/light_fixture/small))
		var/obj/item/frame/light_fixture/small/AH = attacking_item
		AH.try_build(src)
		return

	//Poster stuff
	if(istype(attacking_item,/obj/item/poster))
		place_poster(attacking_item, user)
		return

	if(istype(attacking_item, /obj/item/prop/torch_frame))
		to_chat(user, SPAN_NOTICE("You place the torch down on the wall."))
		new /obj/structure/prop/brazier/frame/full/torch(src)
		qdel(attacking_item)

	if(turf_flags & TURF_HULL)
		to_chat(user, SPAN_WARNING("[src] is much too tough for you to do anything to it with [attacking_item]."))
		return

	if(try_weldingtool_usage(attacking_item, user) || try_nailgun_usage(attacking_item, user))
		return

	if(!istype(src, /turf/closed/wall))
		return

	//DECONSTRUCTION
	switch(d_state)
		if(WALL_STATE_WELD)
			if(iswelder(attacking_item))
				if(!HAS_TRAIT(attacking_item, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
					return
				var/obj/item/tool/weldingtool/WT = attacking_item
				try_weldingtool_deconstruction(WT, user)

		if(WALL_STATE_SCREW)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
				user.visible_message(SPAN_NOTICE("[user] begins removing the support lines."),
				SPAN_NOTICE("You begin removing the support lines."))
				playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WIRECUTTER
				user.visible_message(SPAN_NOTICE("[user] removes the support lines."), SPAN_NOTICE("You remove the support lines."))
				return

		if(WALL_STATE_WIRECUTTER)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WIRECUTTERS))
				user.visible_message(SPAN_NOTICE("[user] begins uncrimping the hydraulic lines."),
				SPAN_NOTICE("You begin uncrimping the hydraulic lines."))
				playsound(src, 'sound/items/Wirecutter.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WRENCH
				user.visible_message(SPAN_NOTICE("[user] finishes uncrimping the hydraulic lines."), SPAN_NOTICE("You finish uncrimping the hydraulic lines."))
				return

		if(WALL_STATE_WRENCH)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WRENCH))
				user.visible_message(SPAN_NOTICE("[user] starts loosening the anchoring bolts securing the support rods."),
				SPAN_NOTICE("You start loosening the anchoring bolts securing the support rods."))
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_CROWBAR
				user.visible_message(SPAN_NOTICE("[user] removes the bolts anchoring the support rods."), SPAN_NOTICE("You remove the bolts anchoring the support rods."))
				return

		if(WALL_STATE_CROWBAR)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
				user.visible_message(SPAN_NOTICE("[user] struggles to pry apart the connecting rods."),
				SPAN_NOTICE("You struggle to pry apart the connecting rods."))
				playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				user.visible_message(SPAN_NOTICE("[user] pries apart the connecting rods."), SPAN_NOTICE("You pry apart the connecting rods."))
				new /obj/item/stack/rods(src)
				dismantle_wall()
				return

	return attack_hand(user)

/turf/closed/wall/proc/try_weldingtool_usage(obj/item/W, mob/user)
	if(!damage || !iswelder(W))
		return FALSE
	if(user.a_intent != INTENT_HELP)
		return FALSE

	var/obj/item/tool/weldingtool/WT = W
	if(WT.remove_fuel(0, user))
		user.visible_message(SPAN_NOTICE("[user] starts repairing the damage to [src]."),
		SPAN_NOTICE("You start repairing the damage to [src]."))
		playsound(src, 'sound/items/Welder.ogg', 25, 1)
		if(do_after(user, max(5, floor(damage / 5) * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && istype(src, /turf/closed/wall) && WT && WT.isOn())
			user.visible_message(SPAN_NOTICE("[user] finishes repairing the damage to [src]."),
			SPAN_NOTICE("You finish repairing the damage to [src]."))
			take_damage(-damage)
	else
		to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))

	return TRUE

/turf/closed/wall/proc/try_weldingtool_deconstruction(obj/item/tool/weldingtool/WT, mob/user)
	if(!WT.isOn())
		to_chat(user, SPAN_WARNING("\The [WT] needs to be on!"))
		return
	if(!(WT.remove_fuel(0, user)))
		to_chat(user, SPAN_WARNING("You need more welding fuel!"))
		return
	if(user.a_intent == INTENT_HELP)
		return

	playsound(src, 'sound/items/Welder.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] begins slicing through the outer plating."),
	SPAN_NOTICE("You begin slicing through the outer plating."))
	if(!WT || !WT.isOn())
		return
	if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	d_state = WALL_STATE_SCREW
	user.visible_message(SPAN_NOTICE("[user] slices through the outer plating."), SPAN_NOTICE("You slice through the outer plating."))
	return

/turf/closed/wall/proc/try_nailgun_usage(obj/item/W, mob/user)
	if((!damage && !acided_hole) || !istype(W, /obj/item/weapon/gun/smg/nailgun))
		return FALSE

	var/obj/item/weapon/gun/smg/nailgun/NG = W
	var/amount_needed = acided_hole ? 3 : 1

	if(!NG.in_chamber || !NG.current_mag || NG.current_mag.current_rounds < (4*amount_needed-1))
		to_chat(user, SPAN_WARNING("You require at least [4*amount_needed] nails to complete this task!"))
		return FALSE

	// Check if either hand has a metal stack by checking the weapon offhand
	// Presume the material is a sheet until proven otherwise.
	var/obj/item/stack/sheet/material = null
	if(user.l_hand == NG)
		material = user.r_hand
	else
		material = user.l_hand

	if(!istype(material, /obj/item/stack/sheet/))
		to_chat(user, SPAN_WARNING("You'll need some adequate repair material in your other hand to patch up [src]!"))
		return FALSE

	var/repair_value = 0
	for(var/validSheetType in repair_materials)
		if(validSheetType == material.sheettype)
			repair_value = repair_materials[validSheetType]
			break

	if(repair_value == 0)
		to_chat(user, SPAN_WARNING("You'll need some adequate repair material in your other hand to patch up [src]!"))
		return FALSE

	if(!material || material.amount < amount_needed)
		to_chat(user, SPAN_WARNING("You need [amount_needed] sheets of material to fix this!"))
		return FALSE

	for(var/i = 1 to amount_needed)
		var/soundchannel = playsound(src, NG.repair_sound, 25, 1)
		if(!do_after(user, NG.nailing_speed, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
			playsound(src, null, channel = soundchannel)
			return FALSE


	// Check again for presence of objects
	if(!material || (material != user.l_hand && material != user.r_hand) || material.amount <= 0)
		to_chat(user, SPAN_WARNING("You seem to have misplaced the repair material!"))
		return FALSE

	if(!NG.in_chamber || !NG.current_mag || NG.current_mag.current_rounds < (4*amount_needed-1))
		to_chat(user, SPAN_WARNING("You require at least [4*amount_needed] nails to complete this task!"))
		return FALSE

	if(acided_hole)
		qdel(acided_hole)
		acided_hole = null
		take_damage(-0.05*damage_cap)
		to_chat(user, SPAN_WARNING("You barricade the hole with [material], slightly raising the integrity of [src], and blocking the hole!"))
	else
		take_damage(-repair_value*damage_cap)
		to_chat(user, SPAN_WARNING("You reinforce the fissures in [src], raising its integrity!"))

	material.use(amount_needed)
	NG.current_mag.current_rounds -= (4*amount_needed-1)
	NG.in_chamber = null
	NG.load_into_chamber()
	update_icon()

	return TRUE

/turf/closed/wall/can_be_dissolved()
	return !(turf_flags & TURF_HULL)
