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
	density = 1
	throwpass = TRUE //You can throw objects over this, despite its density.
	layer = OBJ_LAYER
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE

/obj/structure/platform/Initialize()
	. = ..()
	var/image/I = image(icon, src, "platform_overlay", LADDER_LAYER, dir)//ladder layer puts us just above weeds.
	switch(dir)
		if(SOUTH)
			layer = ABOVE_MOB_LAYER+0.1
			I.pixel_y = -16
		if(NORTH)
			I.pixel_y = 16
		if(EAST)
			I.pixel_x = 16
			layer = ABOVE_MOB_LAYER+0.1
		if(WEST)
			I.pixel_x = -16
			layer = ABOVE_MOB_LAYER+0.1
	overlays += I

/obj/structure/platform/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform/BlockedPassDirs(atom/movable/mover, target_dir)
	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable objects allow you to universally climb over others
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/platform/ex_act()
	return

obj/structure/platform_decoration
	name = "platform"
	desc = "A square metal surface resting on four legs."
	icon = 'icons/obj/structures/props//platforms.dmi'
	icon_state = "platform_deco"
	anchored = TRUE
	density = 0
	throwpass = TRUE
	layer = OBJ_LAYER
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE

/obj/structure/platform_decoration/Initialize()
	. = ..()
	switch(dir)
		if (NORTH)
			layer = ABOVE_MOB_LAYER+0.2
		if (SOUTH)
			layer = ABOVE_MOB_LAYER+0.2
		if (SOUTHEAST)
			layer = ABOVE_MOB_LAYER+0.2
		if (SOUTHWEST)
			layer = ABOVE_MOB_LAYER+0.2

/obj/structure/platform_decoration/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform_decoration/ex_act()
	return

//Map variants//

//Strata purple ice//
/obj/structure/platform_decoration/strata
	name = "ice rock corner"
	desc = "A solid chunk of desolate rocks and ice."
	icon_state = "strata_platform_deco"

/obj/structure/platform/strata
	name = "ice rock edge"
	desc = "A solid chunk of desolate rocks and ice. Looks like you could climb it with some difficulty."
	icon_state = "strata_platform"
	climb_delay = CLIMB_DELAY_SHORT //Lowered climb speed for both sides since people complained. Half of the base climb delay since these are in combat zones. To-Do, specific climb speeds for up and down, xenos, climb verb, macro, auto-climb client pref.

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
	climb_delay = 10

/obj/structure/platform_decoration/kutjevo
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_deco"


/obj/structure/platform/kutjevo/smooth
	icon_state = "kutjevo_platform_sm"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/kutjevo/smooth/stair_plate
	icon_state = "kutjevo_stair_plate"

/obj/structure/platform/kutjevo/smooth/stair_cut
	icon_state = "kutjevo_stair_cm_stair"


/obj/structure/platform_decoration/kutjevo/smooth
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_sm_deco"

/obj/structure/platform/kutjevo/rock
	icon_state = "kutjevo_rock"
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

/obj/structure/platform_decoration/kutjevo/rock
	icon_state = "kutjevo_rock_deco"
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1 meter long lengths of perfectly climbable chest high walls."
