/// Structures serving as landmarks and providing a buff to its users.
/// A notable code feature is that they use a separate roof image that phases out when you enter the tent.
/obj/structure/tent
	name = "tent"
	icon = 'icons/obj/structures/tents_deployed_classic.dmi'
	desc = "Can be torn down with an entrenching tool."
	opacity = FALSE // Seems only the initial turf blocks light, not all of the multitile. Therefore, useless.
	layer = INTERIOR_WALL_SOUTH_LAYER // This should be below FLY_LAYER but just thank chairs and other bs
	health = 200
	appearance_flags = TILE_BOUND

	/// Turf dimensions along the X axis, beginning from left, at ground level
	var/x_dim = 2
	/// Turf dimensions along the Y axis, beginning from bottom, at ground level
	var/y_dim = 4

	/// How much cold protection to add to entering humans - Full body clothing means complete (1) protection
	var/cold_protection_factor = 0.4

	/// Roof display icon_state or null to disable
	var/roof_state
	/// Roof image displayed on the roof plane
	var/image/roof_image

/obj/structure/tent/Initialize(mapload, ...)
	. = ..()
	bound_width = x_dim * world.icon_size
	bound_height = y_dim * world.icon_size
	register_turf_signals()
	RegisterSignal(src, COMSIG_ATOM_TURF_CHANGE, PROC_REF(register_turf_signals))

	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/structures/tents_deployed_jungle.dmi'
		if("desert")
			icon = 'icons/obj/structures/tents_deployed_desert.dmi'
		if("snow")
			icon = 'icons/obj/structures/tents_deployed_snow.dmi'
		if("urban")
			icon = 'icons/obj/structures/tents_deployed_urban.dmi'

	if(roof_state)
		roof_image = image(icon, src, roof_state)
		roof_image.plane = ROOF_PLANE
		roof_image.appearance_flags = KEEP_APART
		src.overlays += roof_image

/obj/structure/tent/proc/register_turf_signals()
	SIGNAL_HANDLER
	for(var/turf/turf in locs)
		RegisterSignal(turf, COMSIG_TURF_ENTERED, PROC_REF(movable_entering_tent), override = TRUE)

/obj/structure/tent/proc/movable_entering_tent(turf/hooked, atom/movable/subject)
	SIGNAL_HANDLER
	if(!ismob(subject))
		return
	var/mob/subject_mob = subject
	RegisterSignal(subject_mob, list(COMSIG_MOVABLE_TURF_ENTERED, COMSIG_GHOST_MOVED), PROC_REF(mob_moved), override = TRUE) // Must override because we can't know if mob was already inside tent without keeping an awful ref list
	subject_mob.RegisterSignal(src, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/mob, tent_deletion_clean_up), override = TRUE)
	var/atom/movable/screen/plane_master/roof/roof_plane = subject_mob.hud_used.plane_masters["[ROOF_PLANE]"]
	roof_plane?.invisibility = INVISIBILITY_MAXIMUM
	if(ishuman(subject))
		RegisterSignal(subject, COMSIG_HUMAN_COLD_PROTECTION_APPLY_MODIFIERS, PROC_REF(cold_protection), override = TRUE)

/obj/structure/tent/proc/cold_protection(mob/source, list/protection_data)
	SIGNAL_HANDLER
	protection_data["protection"] += cold_protection_factor

/obj/structure/tent/proc/mob_moved(mob/subject, turf/target_turf)
	SIGNAL_HANDLER
	if(!(target_turf in locs)) // Exited the tent
		mob_exited_tent(subject)

/obj/structure/tent/proc/mob_exited_tent(mob/subject)
	UnregisterSignal(subject, list(COMSIG_MOVABLE_TURF_ENTERED, COMSIG_GHOST_MOVED, COMSIG_HUMAN_COLD_PROTECTION_APPLY_MODIFIERS))
	subject.UnregisterSignal(src, COMSIG_PARENT_QDELETING)
	var/atom/movable/screen/plane_master/roof/roof_plane = subject.hud_used.plane_masters["[ROOF_PLANE]"]
	roof_plane?.invisibility = 0

/mob/proc/tent_deletion_clean_up(obj/structure/tent/deleting_tent)
	SIGNAL_HANDLER
	deleting_tent.mob_exited_tent(src)

/obj/structure/tent/attack_alien(mob/living/carbon/xenomorph/M)
	if(unslashable)
		return

	M.animation_attack_on(src)
	health -= rand(M.melee_damage_lower, M.melee_damage_upper)
	playsound(src, 'sound/items/paper_ripped.ogg', 25, 1)

	M.visible_message(SPAN_DANGER("[M] [M.slashes_verb] [src]!"),
	SPAN_DANGER("You [M.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)

	if(health <= 0)
		visible_message(SPAN_BOLDWARNING("[src] collapses!"))
		qdel(src)

	return XENO_ATTACK_ACTION

/obj/structure/tent/attackby(obj/item/item, mob/user)
	var/obj/item/tool/shovel/shovel = item
	if(!istype(shovel) || shovel.folded || user.action_busy)
		return
	visible_message(SPAN_HIGHDANGER("[user] is trying to tear down [src]"))
	playsound(src, 'sound/items/paper_ripped.ogg', 25, 1)

	if(!do_after(user, 150, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, src) || QDELETED(src))
		return

	visible_message(SPAN_HIGHDANGER("[user] tears down [src]"))
	playsound(src, 'sound/items/paper_ripped.ogg', 25, 1)
	qdel(src)

/obj/structure/tent/get_projectile_hit_boolean(obj/projectile/P)
	. = ..()
	return FALSE // Always fly through the tent

/// Command tent, providing basics for field command: a phone, and an overwatch console
/obj/structure/tent/cmd
	icon_state = "cmd_interior"
	roof_state = "cmd_top"
	desc = "A standard USCM Command Tent. This one comes equipped with a self-powered Overwatch Console and a Telephone. It is very frail, do not burn, expose to sharp objects, or explosives. Can be torn down with an entrenching tool."

/// Medical tent, procures a buff to surgery speed
/obj/structure/tent/med
	icon_state = "med_interior"
	roof_state = "med_top"
	desc = "A standard USCM Medical Tent. This one comes equipped with advanced field surgery facilities. It is very fragile however and won't withstand the rigors of war. Can be torn down with an entrenching tool."
	var/surgery_speed_mult = 0.9
	var/surgery_pain_reduction = 5

/obj/structure/tent/med/movable_entering_tent(turf/hooked, atom/movable/subject)
	. = ..()
	if(ishuman(subject))
		RegisterSignal(subject, COMSIG_HUMAN_SURGERY_APPLY_MODIFIERS, PROC_REF(apply_surgery_modifiers), override = TRUE)

/obj/structure/tent/med/mob_exited_tent(mob/subject)
	. = ..()
	UnregisterSignal(subject, COMSIG_HUMAN_SURGERY_APPLY_MODIFIERS)

/obj/structure/tent/med/proc/apply_surgery_modifiers(mob/living/carbon/human/source, list/surgery_data)
	SIGNAL_HANDLER
	surgery_data["surgery_speed"] *= surgery_speed_mult
	surgery_data["pain_reduction"] += surgery_pain_reduction

/// Big Tent. It's just Big. Use it for shelter or organization!
/obj/structure/tent/big
	icon_state = "big_interior"
	roof_state = "big_top"
	x_dim = 3
	y_dim = 4

/obj/structure/tent/reqs
	icon_state = "reqs_interior"
	roof_state = "reqs_top"
	x_dim = 4
	y_dim = 4

/obj/structure/tent/mess
	icon_state = "reqs_interior"
	roof_state = "mess_top"
	x_dim = 4
	y_dim = 4
