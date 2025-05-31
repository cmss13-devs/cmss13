//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/mob/animal.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/critters.dmi',
		WEAR_L_EAR = 'icons/mob/humans/onmob/clothing/critters_shoulder.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/clothing/critters_shoulder.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/critters_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/critters_righthand.dmi'
	)
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

/obj/item/holder/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon_state = "cat2_rest"
	item_state = "cat2"
	item_state_slots = list(WEAR_HEAD = "cat2")

/obj/item/holder/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten_rest"

/obj/item/holder/cat/Jones
	name = "\improper Jones"
	desc = "A tough, old stray whose origin no one seems to know."

/obj/item/holder/cat/blackcat
	name = "black cat"
	desc = "It's a cat, now in black!"
	icon_state = "cat_rest"
	item_state = "cat"
	item_state_slots = list(WEAR_HEAD = "cat")

/obj/item/holder/cat/blackcat/Runtime
	name = "\improper Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."

/obj/item/holder/mouse
	name = "mouse"
	desc = "It's a small mouse."
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_white"
	w_class = SIZE_TINY
	flags_equip_slot = SLOT_HEAD|SLOT_EAR

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

/obj/item/holder/corgi
	name = "corgi"
	desc = "It's a corgi."
	icon_state = "corgi"

/obj/item/holder/corgi/Ian
	name = "Ian"

/obj/item/holder/corgi/Lisa
	name = "Ian"
	icon_state = "lisa"

/obj/item/holder/corgi/puppy
	name = "puppy"
	icon_state = "puppy"
	item_state_slots = list(WEAR_HEAD = "puppy")

// Rat

/obj/item/holder/rat
	name = "rat"
	desc = "It's a big rat."
	icon = 'icons/mob/animal.dmi'
	icon_state = "rat_gray"
	w_class = SIZE_TINY
	flags_equip_slot = SLOT_EAR

/obj/item/holder/rat/white
	icon_state = "rat_white"

/obj/item/holder/rat/gray
	icon_state = "rat_gray"

/obj/item/holder/rat/brown
	icon_state = "rat_brown"

/obj/item/holder/rat/black
	icon_state = "rat_black"


/obj/item/holder/rat/white/Milky
	name = "Milky"
	desc = "An escaped test rat from the Weyland-Yutani Research Facility. Hope it doesn't have some sort of genetically engineered disease or something..."

/obj/item/holder/rat/brown/Old_Timmy
	name = "Old Timmy"
	desc = "An ancient looking rat from the old days of the colony."

/obj/item/holder/rat/pet
	name = "Pet Rat"
	desc = "This is someone's pet rat. I wonder what it's doing here."

/obj/item/holder/rat/pet/marvin
	name = "Marvin"
	desc = "A sleek well kept rat with a tiny collar around it's neck, it must belong to someone. For a rodent it appears remarkably clean and hygenic."
	icon_state = "rat_black"

/obj/item/holder/rat/pet/ikit
	name = "Ikit"
	desc = "An albino rat with a tiny collar around it's neck, it must belong to someone. Hope it doesn't have some sort of genetically engineered disease or something..."
	icon_state = "rat_white"
