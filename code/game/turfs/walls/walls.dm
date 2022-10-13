/turf/closed/wall
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "0"
	opacity = 1
	var/hull = 0 //1 = Can't be deconstructed by tools or thermite. Used for Sulaco walls
	var/walltype = WALL_METAL
	var/junctiontype //when walls smooth with one another, the type of junction each wall is.
	var/thermite = 0
	var/melting = FALSE
	var/claws_minimum = CLAW_TYPE_SHARP

	tiles_with = list(
		/turf/closed/wall,
		/obj/structure/window/framed,
		/obj/structure/window_frame,
		/obj/structure/girder,
		/obj/structure/machinery/door)

	var/damage = 0
	var/damage_cap = HEALTH_WALL //Wall will break down to girders if damage reaches this point

	var/damage_overlay
	var/global/damage_overlays[8]

	var/current_bulletholes = null
	var/image/bullet_overlay = null
	var/list/wall_connections = list("0", "0", "0", "0")
	var/neighbors_list = 0
	var/max_temperature = 1800 //K, walls will take damage if they're next to a fire hotter than this
	var/repair_materials = list("wood"= 0.075, "metal" = 0.15, "plasteel" = 0.3) //Max health % recovered on a nailgun repair

	var/d_state = 0 //Normal walls are now as difficult to remove as reinforced walls

	var/obj/effect/acid_hole/acided_hole //the acid hole inside the wall
	var/acided_hole_dir = SOUTH

	var/special_icon = 0
	var/list/blend_turfs = list(/turf/closed/wall)
	var/list/noblend_turfs = list(/turf/closed/wall/mineral, /turf/closed/wall/almayer/research/containment) //Turfs to avoid blending with
	var/list/blend_objects = list(/obj/structure/machinery/door, /obj/structure/window_frame, /obj/structure/window/framed) // Objects which to blend with
	var/list/noblend_objects = list(/obj/structure/machinery/door/window) //Objects to avoid blending with (such as children of listed blend objects.

/turf/closed/wall/Initialize(mapload, ...)
	. = ..()
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


/turf/closed/wall/ChangeTurf(newtype, ...)
	QDEL_NULL(acided_hole)

	. = ..()
	if(.) //successful turf change
		var/turf/T
		for(var/i in cardinal)
			T = get_step(src, i)

			//nearby glowshrooms updated
			for(var/obj/effect/glowshroom/shroom in T)
				if(!shroom.floor) //shrooms drop to the floor
					shroom.floor = 1
					shroom.icon_state = "glowshroomf"
					shroom.pixel_x = 0
					shroom.pixel_y = 0

		for(var/obj/O in src) //Eject contents!
			if(istype(O, /obj/structure/sign/poster))
				var/obj/structure/sign/poster/P = O
				P.roll_and_drop(src)
			if(istype(O, /obj/effect/alien/weeds))
				qdel(O)

/turf/closed/wall/MouseDrop_T(mob/M, mob/user)
	if(acided_hole)
		if(M == user && isXeno(user))
			acided_hole.use_wall_hole(user)
			return
	..()

/turf/closed/wall/attack_alien(mob/living/carbon/Xenomorph/user)
	if(acided_hole && user.mob_size >= MOB_SIZE_BIG)
		acided_hole.expand_hole(user) //This proc applies the attack delay itself.
		return XENO_NO_DELAY_ACTION

	if(!hull && user.claw_type >= claws_minimum && !acided_hole)
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

	switch(d_state)
		if(WALL_STATE_WELD)
			. += SPAN_INFO("The outer plating is intact. A blowtorch should slice it open.")
		if(WALL_STATE_SCREW)
			. += SPAN_INFO("The outer plating has been sliced open. A screwdriver should remove the support lines.")
		if(WALL_STATE_WIRECUTTER)
			. += SPAN_INFO("The support lines have been removed. Wirecutters will take care of the hydraulic lines.")
		if(WALL_STATE_WRENCH)
			. += SPAN_INFO("The hydralic lines have been cut. A wrench will remove the anchor bolts.")
		if(WALL_STATE_CROWBAR)
			. += SPAN_INFO("The anchor bolts have been removed. A crowbar will pry apart the connecting rods.")

//Damage
/turf/closed/wall/proc/take_damage(dam, var/mob/M)
	if(hull) //Hull is literally invincible
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
	if(hull) //Hull is literally invincible
		return
	if(devastated)
		make_girder(TRUE)
	else if (explode)
		make_girder(TRUE)
	else
		make_girder(FALSE)

	ScrapeAway()

/turf/closed/wall/ex_act(severity, explosion_direction, datum/cause_data/cause_data)
	if(hull)
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
	if(hull)
		return 1000000

	return (damage_cap - damage)/EXPLOSION_DAMAGE_MULTIPLIER_WALL

/turf/closed/wall/proc/thermitemelt(mob/user)
	if(melting)
		to_chat(user, SPAN_WARNING("The wall is already burning with thermite!"))
		return
	if(hull)
		return
	melting = TRUE

	var/obj/effect/overlay/O = new/obj/effect/overlay(src)
	O.name = "thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "red_3"
	O.anchored = 1
	O.density = 1
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
			var/timereduction = round((thermite - (damage_cap - damage)/100)/5) // Every 5 units over the required amount reduces the sleep by 0.1s
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
		if((istype(src, /turf/closed/wall/r_wall)) || hull)
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


/turf/closed/wall/attackby(obj/item/W, mob/user)

	if(!ishuman(user) && !isrobot(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(W.heat_source >= 1000)
			if(hull)
				to_chat(user, SPAN_WARNING("[src] is much too tough for you to do anything to it with [W]."))
			else
				if(iswelder(W))
					var/obj/item/tool/weldingtool/WT = W
					WT.remove_fuel(0,user)
				thermitemelt(user)
			return

	if(istype(W, /obj/item/weapon/melee/twohanded/breacher))
		if(user.action_busy)
			return
		if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
			to_chat(user, SPAN_WARNING("You can't use \the [W] properly!"))
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

	if(istype(W,/obj/item/frame/apc))
		var/obj/item/frame/apc/AH = W
		AH.try_build(src)
		return

	if(istype(W,/obj/item/frame/air_alarm))
		var/obj/item/frame/air_alarm/AH = W
		AH.try_build(src)
		return

	if(istype(W,/obj/item/frame/fire_alarm))
		var/obj/item/frame/fire_alarm/AH = W
		AH.try_build(src)
		return

	if(istype(W,/obj/item/frame/light_fixture))
		var/obj/item/frame/light_fixture/AH = W
		AH.try_build(src)
		return

	if(istype(W,/obj/item/frame/light_fixture/small))
		var/obj/item/frame/light_fixture/small/AH = W
		AH.try_build(src)
		return

	//Poster stuff
	if(istype(W,/obj/item/poster))
		place_poster(W,user)
		return

	if(hull)
		to_chat(user, SPAN_WARNING("[src] is much too tough for you to do anything to it with [W]."))
		return

	if(try_weldingtool_usage(W, user) || try_nailgun_usage(W, user))
		return

	if(!istype(src, /turf/closed/wall))
		return

	//DECONSTRUCTION
	switch(d_state)
		if(WALL_STATE_WELD)
			if(iswelder(W))
				if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
					return
				var/obj/item/tool/weldingtool/WT = W
				try_weldingtool_deconstruction(WT, user)

		if(WALL_STATE_SCREW)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				user.visible_message(SPAN_NOTICE("[user] begins removing the support lines."),
				SPAN_NOTICE("You begin removing the support lines."))
				playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WIRECUTTER
				user.visible_message(SPAN_NOTICE("[user] removes the support lines."), SPAN_NOTICE("You remove the support lines."))
				return

		if(WALL_STATE_WIRECUTTER)
			if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
				user.visible_message(SPAN_NOTICE("[user] begins uncrimping the hydraulic lines."),
				SPAN_NOTICE("You begin uncrimping the hydraulic lines."))
				playsound(src, 'sound/items/Wirecutter.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WRENCH
				user.visible_message(SPAN_NOTICE("[user] finishes uncrimping the hydraulic lines."), SPAN_NOTICE("You finish uncrimping the hydraulic lines."))
				return

		if(WALL_STATE_WRENCH)
			if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
				user.visible_message(SPAN_NOTICE("[user] starts loosening the anchoring bolts securing the support rods."),
				SPAN_NOTICE("You start loosening the anchoring bolts securing the support rods."))
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_CROWBAR
				user.visible_message(SPAN_NOTICE("[user] removes the bolts anchoring the support rods."), SPAN_NOTICE("You remove the bolts anchoring the support rods."))
				return

		if(WALL_STATE_CROWBAR)
			if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
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

	var/obj/item/tool/weldingtool/WT = W
	if(WT.remove_fuel(0, user))
		user.visible_message(SPAN_NOTICE("[user] starts repairing the damage to [src]."),
		SPAN_NOTICE("You start repairing the damage to [src]."))
		playsound(src, 'sound/items/Welder.ogg', 25, 1)
		if(do_after(user, max(5, round(damage / 5) * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && istype(src, /turf/closed/wall) && WT && WT.isOn())
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
		to_chat(user, SPAN_WARNING("You seems to have misplaced the repair material!"))
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
	return !hull
