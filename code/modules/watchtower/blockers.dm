/// Invisible Blocker Walls, they link up with the watchtower and collapse with it
/obj/structure/blocker/watchtower
	name = "Watchtower Blocker"
	icon = 'icons/obj/structures/barricades.dmi'
	icon_state = "folding_0" // for map editing only
	flags_atom = ON_BORDER
	invisibility = INVISIBILITY_MAXIMUM
	density = TRUE
	opacity = FALSE // Unfortunately this doesn't behave as we'd want with ON_BORDER so we can't make tent opaque
	throwpass = TRUE // Needs this so xenos can attack through the blocker and hit the tents or people inside
	/// The watchtower this blocker relates to, will be destroyed along with it
	var/obj/structure/watchtower/linked_watchtower

/obj/structure/blocker/watchtower/Initialize(mapload, ...)
	. = ..()
	icon_state = null
	linked_watchtower = locate(/obj/structure/watchtower) in loc
	if(!linked_watchtower)
		return INITIALIZE_HINT_QDEL
	RegisterSignal(linked_watchtower, COMSIG_PARENT_QDELETING, PROC_REF(collapse))

/obj/structure/blocker/watchtower/Destroy(force)
	. = ..()
	linked_watchtower = null

/obj/structure/blocker/watchtower/proc/collapse()
	SIGNAL_HANDLER
	qdel(src)

/obj/structure/blocker/watchtower/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = NONE
		PF.flags_can_pass_front = NONE
		PF.flags_can_pass_behind = NONE

/obj/structure/blocker/watchtower/get_projectile_hit_boolean(obj/projectile/P)
	. = ..()
	return FALSE // Always fly through the watchtower

//Blocks all direction, basically an invisible wall
/obj/structure/blocker/watchtower/full_tile
	flags_atom = NO_FLAGS
	icon = 'icons/landmarks.dmi'
	icon_state = "invisible_wall"
