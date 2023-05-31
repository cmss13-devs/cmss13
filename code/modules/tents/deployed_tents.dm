/// Structures serving as landmarks and providing a buff to its users.
/// A notable code feature is that they use a separate roof image that phases out when you enter the tent.
/obj/structure/tent
	name = "tent"
	icon = 'icons/obj/structures/tents_deployed.dmi'

	/// Turf dimensions along the X axis, beginning from left, at ground level
	var/x_dim = 2
	/// Turf dimensions along the Y axis, beginning from bottom, at ground level
	var/y_dim = 4

	/// Roof display icon_state or null to disable
	var/roof_state
	/// Roof image displayed on the roof plane
	var/image/roof_image

	/// Items belonging to this tent, mostly for destruction etc
	var/list/obj/children = list()

	/// Type to fold back to TODO (or not)
	var/folded_type

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
	roof_plane?.alpha = 100

/obj/structure/tent/proc/mob_moved(mob/subject, turf/target_turf)
	SIGNAL_HANDLER
	if(!(target_turf in locs)) // Exited the tent
		mob_exited_tent(subject)

/obj/structure/tent/proc/mob_exited_tent(mob/subject)
	UnregisterSignal(subject, COMSIG_MOVABLE_TURF_ENTERED)
	var/atom/movable/screen/plane_master/tent_roof/roof_plane = subject.hud_used.plane_masters["[TENT_ROOF_PLANE]"]
	roof_plane?.alpha = 255

/// Requisitions tent - provides a restockable vendor and a permanent landing pad for Reqs
/obj/structure/tent/reqs
	icon_state = "req"
	roof_state = "req_roof"
/obj/structure/tent/reqs/Initialize()
	. = ..()
	if(x)
		var/turf/ext_turf = locate(x + 2, y + 1, z)
		var/obj/structure/tent/reqs_pad/extension_pad = new(ext_turf)
		children += extension_pad
		ext_turf = locate(x + 2, y + 2, z)
		var/obj/structure/tent/reqs_ext/extension = new(ext_turf)
		children += extension

/// Tent extension for reqs tent
/obj/structure/tent/reqs_ext
	roof_state = "req_ext_roof"
	x_dim = 2
	y_dim = 3
/obj/structure/tent/reqs_pad
/// Landing pad for reqs tent
	icon_state = "req_pad"
	x_dim = 2
	y_dim = 2
	density = TRUE
