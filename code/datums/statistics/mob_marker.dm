// Marker mob spawned when a mob is gibbed. Invisible and uninteractable
/mob/dead/mob_marker
	name = "gib marker"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	stat = DEAD

/mob/dead/mob_marker/Initialize(mapload, mob/inheriting)
	. = ..()
	name = inheriting.name
	faction = inheriting.faction
	GLOB.marker_mob_list += src

/mob/dead/mob_marker/Destroy()
	GLOB.marker_mob_list -= src
	return ..()
