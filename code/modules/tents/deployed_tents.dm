/// Structures serving as landmarks and providing a buff to its users.
/// A notable code feature is that they use a separate roof image that phases out when you enter the tent.
/obj/structure/tent
	name = "tent"
	icon = 'icons/obj/structures/tents_deployed.dmi'
	opacity = FALSE // Seems only the initial turf blocks light, not all of the multitile. Therefore, useless.
	layer = INTERIOR_ROOF_LAYER // This should be below FLY_LAYER but just thank chairs and other bs
	health = 150

	/// Turf dimensions along the X axis, beginning from left, at ground level
	var/x_dim = 2
	/// Turf dimensions along the Y axis, beginning from bottom, at ground level
	var/y_dim = 4

	/// Roof display icon_state or null to disable
	var/roof_state
	/// Roof image displayed on the roof plane
	var/image/roof_image

/obj/structure/tent/Initialize(mapload, ...)
	. = ..()
	bound_width = x_dim * world.icon_size
	bound_height = y_dim * world.icon_size

	if(roof_state)
		for(var/turf/turf in locs)
			RegisterSignal(turf, COMSIG_TURF_ENTERED, PROC_REF(movable_entering_tent))
		roof_image = image(icon, src, roof_state)
		roof_image.plane = TENT_ROOF_PLANE
		roof_image.appearance_flags = KEEP_APART
		src.overlays += roof_image

/obj/structure/tent/proc/movable_entering_tent(turf/hooked, atom/movable/subject)
	SIGNAL_HANDLER
	if(!ismob(subject))
		return
	var/mob/subject_mob = subject
	RegisterSignal(subject_mob, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(mob_moved), override = TRUE) // Must override because we can't know if mob was already inside tent without keeping an awful ref list
	var/atom/movable/screen/plane_master/tent_roof/roof_plane = subject_mob.hud_used.plane_masters["[TENT_ROOF_PLANE]"]
	roof_plane?.invisibility = INVISIBILITY_MAXIMUM

/obj/structure/tent/proc/mob_moved(mob/subject, turf/target_turf)
	SIGNAL_HANDLER
	if(!(target_turf in locs)) // Exited the tent
		mob_exited_tent(subject)

/obj/structure/tent/proc/mob_exited_tent(mob/subject)
	UnregisterSignal(subject, COMSIG_MOVABLE_TURF_ENTERED)
	var/atom/movable/screen/plane_master/tent_roof/roof_plane = subject.hud_used.plane_masters["[TENT_ROOF_PLANE]"]
	roof_plane?.invisibility = 0

/obj/structure/tent/attack_alien(mob/living/carbon/xenomorph/M)
	if(unslashable)
		return
	health -= 20
	if(health <= 0)
		visible_message(SPAN_BOLDWARNING("The [src] collapses!"))
		qdel(src)


/// Command tent, providing basics for field command: a phone, and an overwatch console
/obj/structure/tent/cmd
	icon_state = "cmd_interior"
	roof_state = "cmd_top"
