/obj/structure/catwalk
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating_catwalk"
	var/base_state = "catwalk" //Post mapping
	name = "catwalk"
	desc = "Cats really don't like these things."
	var/covered = 1 //1 for theres the cover, 0 if there isn't.
	unslashable = TRUE
	unacidable = TRUE
	layer = CATWALK_LAYER

/obj/structure/catwalk/Initialize()
	. = ..()
	update_icon()

/obj/structure/catwalk/update_icon()
	..()
	icon_state = base_state

/obj/structure/catwalk/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if (. & ATTACK_HINT_BREAK_ATTACK)
		return
	if (HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR) && covered)
		var/obj/item/stack/catwalk/catwalk_stack = new(usr.loc)
		catwalk_stack.add_to_stacks(usr)
		covered = FALSE
		return
	if(istype(attacking_item, /obj/item/stack/catwalk) && !covered)
		var/obj/item/stack/catwalk/to_use = attacking_item
		to_use.use(1)
		covered = TRUE
		return

/obj/structure/catwalk/prison
	icon = 'icons/turf/floors/prison.dmi'
	icon_state = "plating_catwalk"
	base_state = "catwalk"

/obj/structure/catwalk/prison/alt
	icon_state = "plating_catwalk_alt"
	base_state = "catwalk_alt"

/obj/structure/catwalk/bigred
	icon = 'icons/turf/floors/catwalks.dmi'
	icon_state = "catwalk0"
	base_state = "catwalk0"
