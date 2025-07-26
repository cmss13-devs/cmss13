/obj/item/shooting_target_rail
	name = "Target Rail"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "monorail"
	desc = "a rail that is used to place a shooting target on top. Once wrenched and a proper track is formed, allows practice target to move back and forth."

/obj/item/shooting_target_rail/attackby(obj/item/wrench, mob/user)
	. = ..()
	if(loc != get_turf(src))
		to_chat(user, SPAN_WARNING("The rail must be on the ground to set it up!"))
		return
	if(!HAS_TRAIT(wrench, TRAIT_TOOL_WRENCH))
		return
	if(locate(/obj/structure/shooting_target_rail) in get_turf(loc))
		to_chat(user, SPAN_WARNING("There is already an existing rail on this spot!"))
		return
	new /obj/structure/shooting_target_rail(loc)
	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	qdel(src)



