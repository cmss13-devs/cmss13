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
	climb_delay = 20 //Leaping a barricade is universally much faster than clumsily climbing on a table or rack
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE

/obj/structure/platform/New()
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
	..()

/obj/structure/platform/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_OVER)

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
	layer = 3.5
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE

/obj/structure/platform_decoration/New()
	switch(dir)
		if (NORTH)
			layer = ABOVE_MOB_LAYER+0.1
		if (SOUTH)
			layer = ABOVE_MOB_LAYER+0.1
		if (SOUTHEAST)
			layer = ABOVE_MOB_LAYER+0.1
		if (SOUTHWEST)
			layer = ABOVE_MOB_LAYER+0.1
	.. ()

/obj/structure/platform_decoration/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_OVER)

/obj/structure/platform/ex_act()
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
	climb_delay = 10 //Lowered climb speed for both sides since people complained. Half of the base climb delay since these are in combat zones. To-Do, specific climb speeds for up and down, xenos, climb verb, macro, auto-climb client pref.
//Strata wall metal platforms
/obj/structure/platform_decoration/strata/metal
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco"

/obj/structure/platform/strata/metal
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform"