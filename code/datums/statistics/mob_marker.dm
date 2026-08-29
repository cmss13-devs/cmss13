// Marker mob spawned when a mob is gibbed. Invisible and uninteractable
/mob/dead/mob_marker
	name = "gib marker"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	stat = DEAD
	mob_flags = MOB_ABSTRACT

/mob/dead/mob_marker/Initialize(mapload, mob/inheriting)
	. = ..()
	// Don't even add to the marker mob list if we're not inheriting from a mob.
	if(!inheriting)
		return INITIALIZE_HINT_QDEL
	name = inheriting.name
	faction = inheriting.faction
	GLOB.marker_mob_list += src

/mob/dead/mob_marker/Destroy()
	GLOB.marker_mob_list -= src
	return ..()
