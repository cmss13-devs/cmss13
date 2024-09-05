/*
 * Book
 */
/obj/item/book
	name = "book"
	icon = 'icons/obj/items/books.dmi'
	icon_state ="book"
	throw_speed = SPEED_FAST
	throw_range = 5
	/// upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	w_class = SIZE_MEDIUM
	attack_verb = list("bashed", "whacked", "educated")
	pickup_sound = "sound/handling/book_pickup.ogg"
	drop_sound = "sound/handling/book_pickup.ogg"
	black_market_value = 15 //mendoza likes to read
	/// Actual page content
	var/dat
	/// Game time in 1/10th seconds
	var/due_date = 0
	/// Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/author
	/// 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/unique = 0
	/// The real name of the book.
	var/title
	/// Has the book been hollowed out for use as a secret storage item?
	var/carved = 0
	/// What's in the book?
	var/obj/item/store

/obj/item/book/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_WRITABLE, TRAIT_SOURCE_INHERENT)

/obj/item/book/attack_self(mob/user as mob)
	..()
	if(carved)
		if(store)
			to_chat(user, SPAN_NOTICE("[store] falls out of [title]!"))
			store.forceMove(get_turf(src.loc))
			store = null
			return
		else
			to_chat(user, SPAN_NOTICE("The pages of [title] have been cut out!"))
			return
	if(src.dat)
		show_browser(user, "<body class='paper'><TT><I>Owner: [author].</I></TT> <BR>[dat]</body>", "window=book;size=800x600")
		user.visible_message("[user] opens \"[src.title]\".")
		onclose(user, "book")
	else
		to_chat(user, "This book is completely blank!")

/obj/item/book/write(obj/item/writer, mob/user, mods, color, crayon)
	INVOKE_ASYNC(src, PROC_REF(write_async), user)

/obj/item/book/proc/write_async(mob/user)
	if(unique)
		to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
		return
	var/choice = tgui_input_list(user, "What would you like to change?", "Change Book", list("Title", "Contents", "Author", "Cancel"))
	switch(choice)
		if("Title")
			var/newtitle = reject_bad_text(stripped_input(user, "Write a new title:"))
			if(!newtitle)
				to_chat(user, "The title is invalid.")
				return
			else
				name = newtitle
				title = newtitle
				playsound(src, "paper_writing", 15, TRUE)
		if("Contents")
			var/content = strip_html(stripped_input(user, "Write your book's contents (HTML NOT allowed):"),8192)
			if(!content)
				to_chat(user, "The content is invalid.")
				return
			else
				dat += content
				playsound(src, "paper_writing", 15, TRUE)
		if("Author")
			var/newauthor = stripped_input(user, "Write the author's name:")
			if(!newauthor)
				to_chat(user, "The name is invalid.")
				return
			else
				author = newauthor
				playsound(src, "paper_writing", 15, TRUE)

/obj/item/book/attackby(obj/item/W as obj, mob/user as mob)
	. = ..()
	if (. & ATTACK_HINT_BREAK_ATTACK)
		return

	if(carved)
		. |= ATTACK_HINT_NO_TELEGRAPH
		if(!store)
			if(W.w_class < SIZE_MEDIUM)
				user.drop_held_item()
				W.forceMove(src)
				store = W
				to_chat(user, SPAN_NOTICE("You put [W] in [title]."))
				return
			else
				to_chat(user, SPAN_NOTICE("[W] won't fit in [title]."))
				return
		else
			to_chat(user, SPAN_NOTICE("There's already something in [title]!"))
			return
	else if(istype(W, /obj/item/tool/kitchen/knife) || HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		. |= ATTACK_HINT_NO_TELEGRAPH
		if(carved) return
		to_chat(user, SPAN_NOTICE("You begin to carve out [title]."))
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_NOTICE("You carve out the pages from [title]! You didn't want to read it anyway."))
			carved = 1
			return

/obj/item/book/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_selected == "eyes")
		user.visible_message(SPAN_NOTICE("You open up the book and show it to [M]. "), \
			SPAN_NOTICE(" [user] opens up a book and shows it to [M]. "))
		show_browser(M, "<body class='paper'><TT><I>Penned by [author].</I></TT> <BR>[dat]</body>", "window=book")
