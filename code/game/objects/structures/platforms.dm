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
	layer = ABOVE_MOB_LAYER
	breakable = TRUE
	flags_atom = ON_BORDER
	unacidable = TRUE
	climb_delay = CLIMB_DELAY_SHORT
	projectile_coverage = PROJECTILE_COVERAGE_NONE
	var/stat = 0
	var/creaking_sound
	var/breaking_sound

/obj/structure/platform/stair_cut
	icon_state = "platform_stair"//icon will be honked in all dirs except (1), that's because the behavior breaks if it ain't (1)
	dir = 1

/obj/structure/platform/stair_cut/alt
	icon_state = "platform_stair_alt"
	dir = 1

/obj/structure/platform/Initialize()
	. = ..()
	var/image/I = image(icon, src, "platform_overlay", LADDER_LAYER, dir)//ladder layer puts us just above weeds.
	switch(dir)
		if(SOUTH)
			I.pixel_y = -16
		if(NORTH)
			I.pixel_y = 16
		if(EAST)
			I.pixel_x = 16
		if(WEST)
			I.pixel_x = -16
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
	if(indestructible)
		return
	switch(severity)
		if(EXPLOSION_THRESHOLD_VLOW to EXPLOSION_THRESHOLD_LOW)
			if (prob(15))
				broken()
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_HIGH)
			if (prob(35))
				broken()
				return
		if(EXPLOSION_THRESHOLD_HIGH to INFINITY)
			broken()
			return
	return

/obj/structure/platform/get_examine_text(mob/user)
	. = ..()
	if(!stat)
		return

	if(stat & BROKEN)
		. += SPAN_WARNING("It look destroyed.")

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
		user.visible_message(SPAN_WARNING("[user] starts dragging \the [user.pulling] onto \the [src]"),\
		SPAN_WARNING("You start dragging \the [user.pulling] onto \the [src]."))
		if(!do_after(user, 3 SECONDS * user.get_skill_duration_multiplier(SKILL_FIREMAN), INTERRUPT_ALL, BUSY_ICON_HOSTILE, user.pulling, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		if(user.pulling)
			if(!can_climb(user))
				return
			var/turf/move_to_turf = get_step(get_turf(src), dir)
			user.visible_message(SPAN_WARNING("[user] finishes dragging \the [user.pulling] onto \the [src]"),\
			SPAN_WARNING("You finish dragging \the [user.pulling] onto \the [src]."))
			user.pulling.forceMove(move_to_turf)

/obj/structure/platform/attack_alien(mob/living/carbon/xenomorph/user)
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("Its already destroyed!"))
		return XENO_NO_DELAY_ACTION

	if(stat & indestructible)
		to_chat(user, SPAN_WARNING("Its too strong for us!"))
		return XENO_NO_DELAY_ACTION

	if(user.action_busy)
		return XENO_NO_DELAY_ACTION
	if(user.a_intent != INTENT_DISARM)
		user.set_interaction(src)
		tgui_interact(user)
		return XENO_ATTACK_ACTION
	user.visible_message(SPAN_WARNING("[user] begins to lean against [src]."), \
	SPAN_WARNING("You start to pressure [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(loc, creaking_sound, 30, 1)

	var/shove_time = 90
	if(istype(user,/mob/living/carbon/xenomorph/lesser_drone))
		shove_time = 300 //They are very light and weak, thats why they will take 30s to break one edge.
	if(istype(user,/mob/living/carbon/xenomorph/defender))
		shove_time = 70
	if(istype(user,/mob/living/carbon/xenomorph/burrower))
		shove_time = 50
	if(istype(user,/mob/living/carbon/xenomorph/boiler))
		shove_time = 40
	if(user.mob_size >= MOB_SIZE_BIG)
		shove_time = 30
	if(istype(user,/mob/living/carbon/xenomorph/queen))
		shove_time = 15 //Queen is just too fat for it to keep her weight.

	xeno_attack_delay(user) //Adds delay here and returns nothing because otherwise it'd cause lag *after* finishing the shove.

	if(do_after(user, shove_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		user.animation_attack_on(src)
		user.visible_message(SPAN_DANGER("[user] collapses [src] down!"), \
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
	layer = ABOVE_MOB_LAYER
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE

/obj/structure/platform_decoration/Initialize()
	. = ..()

/obj/structure/platform_decoration/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform_decoration/ex_act()
	return

//Map variants//

//Parent to attach sounds depending on material they are made from.
/obj/structure/platform/metal
	icon_state = "strata_metalplatform"
	creaking_sound = 'sound/effects/metal_creaking.ogg'
	breaking_sound = 'sound/effects/metalhit.ogg'

/obj/structure/platform/stone
	icon_state = "kutjevo_rock"
	creaking_sound = 'sound/effects/rock_creaking.ogg'
	breaking_sound = 'sound/effects/meteorimpact.ogg'

//Strata purple ice//
/obj/structure/platform_decoration/strata
	name = "ice rock corner"
	desc = "A solid chunk of desolate rocks and ice."
	icon_state = "strata_platform_deco"

/obj/structure/platform/strata
	name = "ice rock edge"
	desc = "A solid chunk of desolate rocks and ice. Looks like you could climb it with some difficulty."
	icon_state = "strata_platform"

//Strata wall metal platforms
/obj/structure/platform_decoration/strata/metal
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco"

/obj/structure/platform/strata/metal
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform"

//Kutjevo metal platforms

/obj/structure/platform/kutjevo
	icon_state = "kutjevo_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform_decoration/kutjevo
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_deco"


/obj/structure/platform/kutjevo/smooth
	icon_state = "kutjevo_platform_sm"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/kutjevo/smooth/stair_plate
	icon_state = "kutjevo_stair_plate"

/obj/structure/platform_decoration/kutjevo/smooth
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_sm_deco"

/obj/structure/platform/kutjevo/rock
	icon_state = "kutjevo_rock"
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

/obj/structure/platform_decoration/kutjevo/rock
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1-meter-long lengths of perfectly climbable chest high walls."
	icon_state = "kutjevo_rock_deco"


/obj/structure/platform/mineral
	icon_state = "stone"
/obj/structure/platform_decoration/mineral
	icon_state = "stone_deco"

/obj/structure/platform/mineral/sandstone
	name = "sandstone platform"
	desc = "A platform supporting elevated ground, made of sandstone. Has what seem to be ancient hieroglyphs on its side."
	color = "#c6a480"

/obj/structure/platform/mineral/sandstone/runed
	name = "sandstone temple platform"
	color = "#b29082"



/obj/structure/platform_decoration/mineral/sandstone
	name = "sandstone platform corner"
	desc = "A platform corner supporting elevated ground, made of sandstone. Has what seem to be ancient hieroglyphs on its side."
	color = "#c6a480"

/obj/structure/platform/shiva/catwalk
	icon_state = "shiva"
	name = "raised rubber cord platform"
	desc = "Reliable steel and a polymer rubber substitute. Doesn't crack under cold weather."

/obj/structure/platform_decoration/shiva/catwalk
	icon_state = "shiva_deco"
	name = "raised rubber cord platform"
	desc = "Reliable steel and a polymer rubber substitute. Doesn't crack under cold weather."

/obj/structure/platform_decoration/mineral/sandstone/runed
	name = "sandstone temple platform corner"
	color = "#b29082"



//Metal based Platforms
/obj/structure/platform/metal/kutjevo
	icon_state = "kutjevo_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/metal/kutjevo/smooth
	icon_state = "kutjevo_platform_sm"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/metal/kutjevo/smooth/stair_plate
	icon_state = "kutjevo_stair_plate"

//Rock based Platforms
/obj/structure/platform/stone/kutjevo/rock
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

//Metal based Platforms "decoration"
/obj/structure/platform_decoration/metal/kutjevo
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_deco"

/obj/structure/platform_decoration/metal/kutjevo/smooth
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_sm_deco"

//Rock based Platforms "decoration"
/obj/structure/platform_decoration/stone/kutjevo/rock
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1-meter-long lengths of perfectly climbable chest high walls."
	icon_state = "kutjevo_rock_deco"
