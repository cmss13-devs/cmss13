//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	flags_equip_slot = SLOT_HEAD

/obj/item/holder/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/holder/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/holder/process()

	if(istype(loc,/turf) || !(length(contents)))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		qdel(src)

/obj/item/holder/attackby(obj/item/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/holder/proc/show_message(message, m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

/obj/item/holder/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]."
	if(desc)
		. += desc
	if(desc_lore)
		. += SPAN_NOTICE("This has an <a href='byond://?src=\ref[src];desc_lore=1'>extended lore description</a>.")


//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(mob/living/carbon/grabber)
	if(!holder_type)
		return
	if(isxeno(grabber))
		to_chat(grabber, SPAN_WARNING("You leave [src] alone. It cannot be made a host, so there is no use for it."))
		return
	if(locate(/obj/item/explosive/plastic) in contents)
		to_chat(grabber, SPAN_WARNING("You leave [src] alone. It's got live explosives on it!"))
		return

	var/obj/item/holder/mob_holder = new holder_type(loc)
	forceMove(mob_holder)
	mob_holder.name = name
	mob_holder.desc = desc
	mob_holder.gender = gender
	mob_holder.attack_hand(grabber)

	to_chat(grabber, "You scoop up [src].")
	to_chat(src, "[grabber] scoops you up.")
	grabber.status_flags |= PASSEMOTES
	return

//Mob specific holders.

/obj/item/holder/drone
	name = "maintenance drone"
	desc = "It's a small maintenance robot."
	icon_state = "drone"

/obj/item/holder/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon_state = "cat2"

/obj/item/holder/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"

/obj/item/holder/cat/Jones
	name = "\improper Jones"
	desc = "A tough, old stray whose origin no one seems to know."

/obj/item/holder/cat/blackcat
	name = "black cat"
	desc = "It's a cat, now in black!"
	icon_state = "cat"

/obj/item/holder/cat/blackcat/Runtime
	name = "\improper Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."

/obj/item/holder/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "cat2"

/obj/item/holder/mouse
	name = "mouse"
	desc = "It's a small mouse."
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_white"
	w_class = SIZE_TINY;
	flags_equip_slot = null

/obj/item/holder/mouse/white
	icon_state = "mouse_white"

/obj/item/holder/mouse/gray
	icon_state = "mouse_gray"

/obj/item/holder/mouse/brown
	icon_state = "mouse_brown"

/obj/item/holder/mouse/white/Doc
	name = "Doc"
	desc = "Senior researcher of the Almayer. Likes: cheese, experiments, explosions."

/obj/item/holder/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."
