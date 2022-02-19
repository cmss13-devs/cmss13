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

	if(istype(loc,/turf) || !(contents.len))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		qdel(src)

/obj/item/holder/attackby(obj/item/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/holder/proc/show_message(var/message, var/m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(var/mob/living/carbon/grabber)
	if(!holder_type)
		return
	var/obj/item/holder/H = new holder_type(loc)
	src.forceMove(H)
	H.name = loc.name
	H.attack_hand(grabber)

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
	desc = "It's a cat. Meow."
	icon_state = "cat"

/obj/item/holder/Jones
	name = "Jones"
	desc = "A tough, old stray whose origin no one seems to know."
	icon_state = "cat2"

/obj/item/holder/mouse
	name = "mouse"
	desc = "It's a small mouse."
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_white"
	w_class = SIZE_TINY;
	flags_equip_slot = null

/obj/item/holder/mouse/Doc
	name = "Doc"
	desc = "Senior researcher of the Almayer. Likes: cheese, experiments, explosions."
