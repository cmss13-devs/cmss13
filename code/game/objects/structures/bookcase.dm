
/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/structures/bookshelf.dmi'
	icon_state = "book-0"
	anchored = TRUE
	density = TRUE
	opacity = TRUE

/obj/structure/bookcase/deconstruct(disassembled)
	new /obj/item/stack/sheet/metal(loc)
	return ..()

/obj/structure/bookcase/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HARM)
		if(unslashable)
			return
		xeno.animation_attack_on(src)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		deconstruct(FALSE)
		return XENO_ATTACK_ACTION
	else
		attack_hand(xeno)
		return XENO_NONCOMBAT_ACTION

/obj/structure/bookcase/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.forceMove(src)
	update_icon()

/obj/structure/bookcase/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/book))
		user.drop_held_item()
		O.forceMove(src)
		update_icon()
	else if(HAS_TRAIT(O, TRAIT_TOOL_PEN))
		var/newname = stripped_input(user, "What would you like to title this bookshelf?")
		if(!newname)
			return
		else
			name = ("bookcase ([strip_html(newname)])")
			playsound(src, "paper_writing", 15, TRUE)
	else if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		if(do_after(user, 1 SECONDS, INTERRUPT_MOVED, BUSY_ICON_FRIENDLY, src))
			user.visible_message("[user] deconstructs [src].",
				"You deconstruct [src].", "You hear a noise.")
			deconstruct(FALSE)
	else
		. = ..()

/obj/structure/bookcase/attack_hand(mob/user as mob)
	if(length(contents))
		var/obj/item/book/choice = input("Which book would you like to remove from the shelf?") as null|obj in contents
		if(choice)
			if(user.is_mob_incapacitated() || !in_range(loc, user))
				return
			if(ishuman(user))
				if(!user.get_active_hand())
					user.put_in_hands(choice)
			else
				choice.forceMove(get_turf(src))
			update_icon()

/obj/structure/bookcase/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(50))
				for(var/obj/item/book/b in contents)
					b.forceMove((get_turf(src)))
				deconstruct(FALSE)
			return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			contents_explosion(severity)
			deconstruct(FALSE)
			return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			contents_explosion(severity)
			deconstruct(FALSE)
			return

/obj/structure/bookcase/update_icon()
	if(length(contents) < 5)
		icon_state = "book-[length(contents)]"
	else
		icon_state = "book-5"


/obj/structure/bookcase/manuals/medical
	name = "medical manuals bookcase"

/obj/structure/bookcase/manuals/medical/Initialize()
	. = ..()
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	update_icon()


/obj/structure/bookcase/manuals/engineering
	name = "engineering manuals bookcase"

/obj/structure/bookcase/manuals/engineering/Initialize()
	. = ..()
	new /obj/item/book/manual/engineering_construction(src)
	new /obj/item/book/manual/engineering_hacking(src)
	new /obj/item/book/manual/engineering_guide(src)
	new /obj/item/book/manual/atmospipes(src)
	new /obj/item/book/manual/evaguide(src)
	update_icon()

/obj/structure/bookcase/manuals/research_and_development
	name = "\improper R&D manuals bookcase"

/obj/structure/bookcase/manuals/research_and_development/Initialize()
	. = ..()
	new /obj/item/book/manual/research_and_development(src)
	update_icon()
