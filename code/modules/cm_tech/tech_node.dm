/turf/open/blank
	name = "Blank"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	mouse_opacity = FALSE
	can_bloody = FALSE

/obj/effect/node
	name = "tech node"

	var/datum/tech/info

/obj/effect/node/Initialize(mapload, var/datum/tech/tech)
	. = ..()
	if(!tech)
		stack_trace("Tech node initialized without a tech to attach to! (Expected /datum/tech type, got [tech])")
		return INITIALIZE_HINT_QDEL

	info = tech
	name = tech.name
	tech.node = src
	tech.update_icon(src)

/obj/effect/node/update_icon()
	overlays.Cut()

	. = ..()
	info.update_icon(src)

/obj/effect/node/clicked(mob/user, list/mods)
	. = ..()

	tgui_interact(user)
	return TRUE

/obj/effect/node/tgui_interact(mob/user, datum/tgui/ui)
	if(!info)
		qdel(src)
		return

	info.tgui_interact(user, ui)
