/*
 * Platforms
 */
/obj/structure/platform
	name = "platform"
	desc = "A square metal surface resting on four legs."
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "platform"
	climbable = TRUE
	anchored = TRUE
	density = TRUE
	throwpass = TRUE //You can throw objects over this, despite its density.
	layer = OBJ_LAYER
	breakable = TRUE
	flags_atom = ON_BORDER
	unacidable = TRUE
	climb_delay = CLIMB_DELAY_SHORT
	projectile_coverage = PROJECTILE_COVERAGE_NONE
	var/stat = 0
	var/creaking_sound
	var/breaking_sound
	var/shove_time

/obj/structure/platform/Initialize()
	. = ..()
	var/image/I = image(icon, src, "platform_overlay", LADDER_LAYER, dir)//ladder layer puts us just above weeds.
	switch(dir)
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
			I.pixel_y = -16
		if(NORTH)
			I.pixel_y = 16
		if(EAST)
			I.pixel_x = 16
			layer = MOB_LAYER
		if(WEST)
			I.pixel_x = -16
			layer = MOB_LAYER
	overlays += I

/obj/structure/platform/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform/Collided(atom/movable/AM)
	if(ismob(AM))
		do_climb(AM)
	..()

/obj/structure/platform/BlockedPassDirs(atom/movable/mover, target_dir)
	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable objects allow you to universally climb over others
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/platform/ex_act(severity)
	if(explo_proof)
		return
	switch(severity)
		if(EXPLOSION_THRESHOLD_VLOW to EXPLOSION_THRESHOLD_LOW)
			if(prob(15))
				broken()
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_HIGH)
			if(prob(30))
				broken()
				return
		if(EXPLOSION_THRESHOLD_HIGH to INFINITY)
			broken()
			return
	return

/obj/structure/platform/get_examine_text(mob/user)
	. = ..()

	if(stat & BROKEN)
		. += SPAN_WARNING("It looks destroyed.")

/obj/structure/platform/update_icon()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]_broken"

/obj/structure/platform/proc/broken()
	stat |= BROKEN
	density = FALSE
	layer = ABOVE_BLOOD_LAYER //lets hope it will appear under everything except weeds and blood.
	update_icon()

/obj/structure/platform/attackby(obj/item/W, mob/user)
	. = ..()
	if(user.pulling)
		if(!can_climb(user))
			return
		user.visible_message(SPAN_WARNING("[user] starts dragging \the [user.pulling] onto \the [src]"),
		SPAN_WARNING("You start dragging \the [user.pulling] onto \the [src]."))
		if(!do_after(user, 3 SECONDS * user.get_skill_duration_multiplier(SKILL_FIREMAN), INTERRUPT_ALL, BUSY_ICON_HOSTILE, user.pulling, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		if(user.pulling)
			if(!can_climb(user))
				return
			var/turf/move_to_turf = get_step(get_turf(src), dir)
			user.visible_message(SPAN_WARNING("[user] finishes dragging \the [user.pulling] onto \the [src]"),
			SPAN_WARNING("You finish dragging \the [user.pulling] onto \the [src]."))
			user.pulling.forceMove(move_to_turf)

/obj/structure/platform/attack_alien(mob/living/carbon/xenomorph/user)
	if(user.action_busy)
		return XENO_NO_DELAY_ACTION
	if(user.a_intent != INTENT_DISARM)
		return XENO_NO_DELAY_ACTION

	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("Its already destroyed!"))
		return XENO_NO_DELAY_ACTION

	if(stat & explo_proof)
		to_chat(user, SPAN_WARNING("Its too strong for us!"))
		return XENO_NO_DELAY_ACTION

	user.visible_message(SPAN_WARNING("[user] begins to lean against [src]."),
	SPAN_WARNING("You start to stomp and pressure [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(loc, creaking_sound, 30, 1)

	var/shove_time
	switch(user.mob_size)
		if(MOB_SIZE_XENO_VERY_SMALL)
			shove_time = 30 SECONDS
		if(MOB_SIZE_XENO_SMALL)
			shove_time = 9 SECONDS
		if(MOB_SIZE_XENO)
			shove_time = 7 SECONDS
		if(MOB_SIZE_BIG)
			shove_time = 4 SECONDS
		if(MOB_SIZE_IMMOBILE)
			shove_time = 2 SECONDS

	xeno_attack_delay(user) //Adds delay here and returns nothing because otherwise it'd cause lag *after* finishing the shove.

	if(!do_after(user, shove_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, numticks = shove_time * 0.1))
		return
	user.animation_attack_on(src)
	user.visible_message(SPAN_DANGER("[user] collapses [src] down!"),
	SPAN_DANGER("You collapse [src] down!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(loc, breaking_sound, 25, 1)
	broken()
	return XENO_NO_DELAY_ACTION

/obj/structure/platform_decoration
	name = "platform"
	desc = "A square metal surface resting on four legs."
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "platform_deco"
	anchored = TRUE
	density = FALSE
	throwpass = TRUE
	layer = OBJ_LAYER
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE

/obj/structure/platform_decoration/Initialize()
	. = ..()
	switch(dir)
		if (NORTH)
			layer = OBJ_LAYER+0.1
		if (SOUTH)
			layer = ABOVE_MOB_LAYER+0.1
		if (SOUTHEAST)
			layer = ABOVE_MOB_LAYER+0.1
		if (SOUTHWEST)
			layer = ABOVE_MOB_LAYER+0.1
		if (EAST)
			layer = MOB_LAYER+0.1
		if (WEST)
			layer = MOB_LAYER+0.1

/obj/structure/platform_decoration/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform_decoration/ex_act()
	return

//Map variants//

//
//Parent used to attach sounds depending on material they are made from.//
//

/obj/structure/platform/metal
	icon_state = "platform"
	creaking_sound = 'sound/effects/metal_creaking.ogg'
	breaking_sound = 'sound/effects/metalhit.ogg'

/obj/structure/platform/stone
	icon_state = "kutjevo_rock"
	creaking_sound = 'sound/effects/rock_creaking.ogg'
	breaking_sound = 'sound/effects/meteorimpact.ogg'

//------------------------------//
//    Metal Stairs Platforms    //
//------------------------------//

/obj/structure/platform/metal/stair_cut
	icon_state = "platform_stair" //icon will be honked in all dirs except (1 = NORTH), that's because the behavior breaks if it ain't (1), don't use (2) its made as mapping tool visual indicator.
	dir = NORTH

/obj/structure/platform/metal/stair_cut/platform_left
	icon_state = "platform_stair"

/obj/structure/platform/metal/stair_cut/platform_right
	icon_state = "platform_stair_alt"

/obj/structure/platform/metal/stair_cut/kutjevo_smooth_left
	icon_state = "kutjevo_platform_sm_stair"

/obj/structure/platform/metal/stair_cut/kutjevo_smooth_right
	icon_state = "kutjevo_platform_sm_stair_alt"

/obj/structure/platform/metal/stair_cut/strata_left
	icon_state = "strata_metalplatform_stair"

/obj/structure/platform/metal/stair_cut/strata_right
	icon_state = "strata_metalplatform_stair_alt"

/obj/structure/platform/metal/stair_cut/shiva_left
	icon_state = "shiva_stair"

/obj/structure/platform/metal/stair_cut/shiva_right
	icon_state = "shiva_stair_alt"

//------------------------------//
//    Stone Stairs Platforms    //
//------------------------------//

/obj/structure/platform/stone/stair_cut
	icon_state = "kutjevo_rock_stair" //icon will be honked in all dirs except (1 = NORTH), that's because the behavior breaks if it ain't (1), don't use (2) its made as mapping tool visual indicator.
	dir = NORTH

/obj/structure/platform/stone/stair_cut/shiva_left
	icon_state = "strata_platform_stair"

/obj/structure/platform/stone/stair_cut/shiva_right
	icon_state = "strata_platform_stair_alt"

/obj/structure/platform/stone/stair_cut/kutjevo_left
	icon_state = "kutjevo_rock_stair"

/obj/structure/platform/stone/stair_cut/kutjevo_right
	icon_state = "kutjevo_rock_stair_alt"

/obj/structure/platform/stone/stair_cut/stone_left
	icon_state = "stone_stair"

/obj/structure/platform/stone/stair_cut/stone_right
	icon_state = "stone_stair_alt"

/obj/structure/platform/stone/stair_cut/sandstone_left
	icon_state = "sandstone_stair"
	color = "#c6a480"

/obj/structure/platform/stone/stair_cut/sandstone_right
	icon_state = "sandstone_stair_alt"
	color = "#c6a480"

/obj/structure/platform/stone/stair_cut/runed_sandstone_left
	icon_state = "stone_stair"
	color = "#b29082"

/obj/structure/platform/stone/stair_cut/runed_sandstone_right
	icon_state = "stone_stair_alt"
	color = "#b29082"

//------------------------------------//
//       Metal based Platforms        //
//------------------------------------//

/obj/structure/platform/metal/almayer/north //I didn't have good name so... they will be called almayer for now as replacement for "platform".
	dir = NORTH
/obj/structure/platform/metal/almayer/east
	dir = EAST
/obj/structure/platform/metal/almayer/west
	dir = WEST


/obj/structure/platform/metal/kutjevo
	icon_state = "kutjevo_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/metal/kutjevo/north
	dir = NORTH
/obj/structure/platform/metal/kutjevo/east
	dir = EAST
/obj/structure/platform/metal/kutjevo/west
	dir = WEST


/obj/structure/platform/metal/kutjevo_smooth
	icon_state = "kutjevo_platform_sm"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/metal/kutjevo_smooth/north
	dir = NORTH
/obj/structure/platform/metal/kutjevo_smooth/east
	dir = EAST
/obj/structure/platform/metal/kutjevo_smooth/west
	dir = WEST


/obj/structure/platform/metal/kutjevo_smooth/stair_plate
	icon_state = "kutjevo_stair_plate"


/obj/structure/platform/metal/shiva
	icon_state = "shiva"
	name = "raised rubber cord platform"
	desc = "Reliable steel and a polymer rubber substitute. Doesn't crack under cold weather."

/obj/structure/platform/metal/shiva/north
	dir = NORTH
/obj/structure/platform/metal/shiva/east
	dir = EAST
/obj/structure/platform/metal/shiva/west
	dir = WEST


/obj/structure/platform/metal/strata
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform"

/obj/structure/platform/metal/strata/north
	dir = NORTH
/obj/structure/platform/metal/strata/east
	dir = EAST
/obj/structure/platform/metal/strata/west
	dir = WEST

// Hunter Platforms

/obj/structure/platform/metal/hunter
	icon_state = "hunter_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/metal/hunter/north
	dir = NORTH
/obj/structure/platform/metal/hunter/east
	dir = EAST
/obj/structure/platform/metal/hunter/west
	dir = WEST

/obj/structure/prop/hunter/fake_platform/hunter/stair_cut/hunter_left
	icon_state = "hunter_platform_stair"

/obj/structure/prop/hunter/fake_platform/hunter/stair_cut/hunter_right
	icon_state = "hunter_platform_stair_alt"

//------------------------------------//
//       Rock based Platforms         //
//------------------------------------//

/obj/structure/platform/stone/kutjevo
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

/obj/structure/platform/stone/kutjevo/north
	dir = NORTH
/obj/structure/platform/stone/kutjevo/east
	dir = EAST
/obj/structure/platform/stone/kutjevo/west
	dir = WEST


/obj/structure/platform/stone/strata
	name = "ice rock edge"
	desc = "A solid chunk of desolate rocks and ice. Looks like you could climb it with some difficulty."
	icon_state = "strata_platform"

/obj/structure/platform/stone/strata/north
	dir = NORTH
/obj/structure/platform/stone/strata/east
	dir = EAST
/obj/structure/platform/stone/strata/west
	dir = WEST


/obj/structure/platform/stone/mineral
	icon_state = "stone"

/obj/structure/platform/stone/mineral/north
	dir = NORTH
/obj/structure/platform/stone/mineral/east
	dir = EAST
/obj/structure/platform/stone/mineral/west
	dir = WEST


/obj/structure/platform/stone/sandstone
	name = "sandstone platform"
	desc = "A platform supporting elevated ground, made of sandstone. Has what seem to be ancient hieroglyphs on its side."
	icon_state = "sandstone"
	color = "#c6a480"

/obj/structure/platform/stone/sandstone/north
	dir = NORTH
/obj/structure/platform/stone/sandstone/east
	dir = EAST
/obj/structure/platform/stone/sandstone/west
	dir = WEST


/obj/structure/platform/stone/runed_sandstone
	name = "sandstone temple platform"
	icon_state = "stone"
	color = "#b29082"

/obj/structure/platform/stone/runed_sandstone/north
	dir = NORTH
/obj/structure/platform/stone/runed_sandstone/east
	dir = EAST
/obj/structure/platform/stone/runed_sandstone/west
	dir = WEST

//------------------------------------//
// Metal based Platforms "decoration" //
//------------------------------------//

/obj/structure/platform_decoration/metal/almayer/north
	dir = NORTH
/obj/structure/platform_decoration/metal/almayer/east
	dir = EAST
/obj/structure/platform_decoration/metal/almayer/west
	dir = WEST
/obj/structure/platform_decoration/metal/almayer/northeast
	dir = NORTHEAST
/obj/structure/platform_decoration/metal/almayer/northwest
	dir = NORTHWEST
/obj/structure/platform_decoration/metal/almayer/southeast
	dir = SOUTHEAST
/obj/structure/platform_decoration/metal/almayer/southwest
	dir = SOUTHWEST


/obj/structure/platform_decoration/metal/kutjevo
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_deco"

/obj/structure/platform_decoration/metal/kutjevo/north
	dir = NORTH
/obj/structure/platform_decoration/metal/kutjevo/east
	dir = EAST
/obj/structure/platform_decoration/metal/kutjevo/west
	dir = WEST


/obj/structure/platform_decoration/metal/kutjevo_smooth
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_sm_deco"

/obj/structure/platform_decoration/metal/kutjevo_smooth/north
	dir = NORTH
/obj/structure/platform_decoration/metal/kutjevo_smooth/east
	dir = EAST
/obj/structure/platform_decoration/metal/kutjevo_smooth/west
	dir = WEST


/obj/structure/platform_decoration/metal/shiva
	icon_state = "shiva_deco"
	name = "raised rubber cord platform"
	desc = "Reliable steel and a polymer rubber substitute. Doesn't crack under cold weather."

/obj/structure/platform_decoration/metal/shiva/north
	dir = NORTH
/obj/structure/platform_decoration/metal/shiva/east
	dir = EAST
/obj/structure/platform_decoration/metal/shiva/west
	dir = WEST


/obj/structure/platform_decoration/metal/strata
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco"

/obj/structure/platform_decoration/metal/strata/north
	dir = NORTH
/obj/structure/platform_decoration/metal/strata/east
	dir = EAST
/obj/structure/platform_decoration/metal/strata/west
	dir = WEST

// Hunter Deco

/obj/structure/platform_decoration/metal/hunter
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "hunter_platform_deco"
	layer = LOWER_ITEM_LAYER

/obj/structure/platform_decoration/metal/hunter/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hunter/east
	dir = EAST
/obj/structure/platform_decoration/metal/hunter/west
	dir = WEST

//------------------------------------//
// Rock based Platforms "decoration"  //
//------------------------------------//

/obj/structure/platform_decoration/stone/kutjevo
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1-meter-long lengths of perfectly climbable chest high walls."
	icon_state = "kutjevo_rock_deco"

/obj/structure/platform_decoration/stone/kutjevo/north
	dir = NORTH
/obj/structure/platform_decoration/stone/kutjevo/east
	dir = EAST
/obj/structure/platform_decoration/stone/kutjevo/west
	dir = WEST


/obj/structure/platform_decoration/stone/strata
	name = "ice rock corner"
	desc = "A solid chunk of desolate rocks and ice."
	icon_state = "strata_platform_deco"

/obj/structure/platform_decoration/stone/strata/north
	dir = NORTH
/obj/structure/platform_decoration/stone/strata/east
	dir = EAST
/obj/structure/platform_decoration/stone/strata/west
	dir = WEST


/obj/structure/platform_decoration/stone/mineral
	icon_state = "stone_deco"

/obj/structure/platform_decoration/stone/mineral/north
	dir = NORTH
/obj/structure/platform_decoration/stone/mineral/east
	dir = EAST
/obj/structure/platform_decoration/stone/mineral/west
	dir = WEST


/obj/structure/platform_decoration/stone/sandstone
	name = "sandstone platform corner"
	desc = "A platform corner supporting elevated ground, made of sandstone. Has what seem to be ancient hieroglyphs on its side."
	icon_state = "sandstone_deco"
	color = "#c6a480"

/obj/structure/platform_decoration/stone/sandstone/north
	dir = NORTH
/obj/structure/platform_decoration/stone/sandstone/east
	dir = EAST
/obj/structure/platform_decoration/stone/sandstone/west
	dir = WEST

/obj/structure/platform_decoration/stone/runed_sandstone
	name = "sandstone temple platform corner"
	icon_state = "stone_deco"
	color = "#b29082"

/obj/structure/platform_decoration/stone/runed_sandstone/north
	dir = NORTH
/obj/structure/platform_decoration/stone/runed_sandstone/east
	dir = EAST
/obj/structure/platform_decoration/stone/runed_sandstone/west
	dir = WEST

/// Hybrisa Platforms

/obj/structure/platform/metal/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform/metal/hybrisa/engineer
	icon_state = "engineer_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."
	climb_delay = 10
	layer = TURF_LAYER

/obj/structure/platform/metal/hybrisa/engineer/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/engineer/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/engineer/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform1
	icon_state = "hybrisametal"
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/metal/hybrisa/metalplatform1/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform1/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform1/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform2
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform2"

/obj/structure/platform/metal/hybrisa/metalplatform2/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform2/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform2/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform3
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform3"

/obj/structure/platform/metal/hybrisa/metalplatform3/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform3/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform3/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform4
	icon_state = "hybrisaplatform"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/metal/hybrisa/metalplatform4/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform4/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform4/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform5
	icon_state = "hybrisaplatform2"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/metal/hybrisa/metalplatform5/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform5/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform5/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform6
	icon_state = "hybrisaplatform3"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/metal/hybrisa/metalplatform6/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform6/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform6/west
	dir = WEST


/obj/structure/platform/stone/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform/stone/hybrisa/rockdark
	icon_state = "kutjevo_rockdark"
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

/obj/structure/platform/stone/hybrisa/rockdark/north
	dir = NORTH
/obj/structure/platform/stone/hybrisa/rockdark/east
	dir = EAST
/obj/structure/platform/stone/hybrisa/rockdark/west
	dir = WEST



/obj/structure/platform_decoration/metal/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform_decoration/metal/hybrisa/engineer_corner
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "engineer_platform_deco"
	layer = TURF_LAYER

/obj/structure/platform_decoration/metal/hybrisa/engineer_corner/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/engineer_corner/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/engineer_corner/west
	dir = WEST


/obj/structure/platform_decoration/metal/hybrisa/engineer_cornerbits
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "engineer_platform_platformcorners"
	layer = TURF_LAYER

/obj/structure/platform_decoration/metal/hybrisa/engineer_cornerbits/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/engineer_cornerbits/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/engineer_cornerbits/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco1
	icon_state = "hybrisametal_deco"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco1/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco1/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco1/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco2
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco2"

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco2/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco2/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco2/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco3
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco3"

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco3/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco3/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco3/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco4
	icon_state = "hybrisaplatform_deco"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco4/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco4/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco4/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco5
	icon_state = "hybrisaplatform_deco2"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco5/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco5/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco5/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco6
	icon_state = "hybrisaplatform_deco3"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco6/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco6/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco6/west
	dir = WEST


/obj/structure/platform_decoration/stone/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform_decoration/stone/hybrisa/rockdark
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1-meter-long lengths of perfectly climbable chest high walls."
	icon_state = "kutjevo_rock_decodark"

/obj/structure/platform_decoration/stone/hybrisa/rockdark/north
	dir = NORTH
/obj/structure/platform_decoration/stone/hybrisa/rockdark/east
	dir = EAST
/obj/structure/platform_decoration/stone/hybrisa/rockdark/west
	dir = WEST



/obj/structure/platform/metal/stair_cut/hybrisa_metal_left
	icon_state = "hybrisaplatform_stair"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	dir = NORTH

/obj/structure/platform/metal/stair_cut/hybrisa_metal_right
	icon_state = "hybrisaplatform_stair_alt"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	dir = NORTH

/obj/structure/platform_decoration/stone/runed_sandstone/north
	dir = NORTH
/obj/structure/platform_decoration/stone/runed_sandstone/east
	dir = EAST
/obj/structure/platform_decoration/stone/runed_sandstone/west
	dir = WEST
