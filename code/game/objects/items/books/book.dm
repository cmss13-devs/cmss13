/*
 * Book
 */
/obj/item/book
	name = "book"
	icon = 'icons/obj/items/books.dmi'
	icon_state ="book"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	var/dat			 // Actual page content
	var/due_date = 0 // Game time in 1/10th seconds
	var/author		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/unique = 0   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title		 // The real name of the book.
	var/carved = 0	 // Has the book been hollowed out for use as a secret storage item?
	var/obj/item/store	//What's in the book?

/obj/item/book/attack_self(var/mob/user as mob)
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

/obj/item/book/attackby(obj/item/W as obj, mob/user as mob)
	if(carved)
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
	if(istype(W, /obj/item/tool/pen))
		if(unique)
			to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
			return
		var/choice = tgui_input_list(usr, "What would you like to change?", "Change Book", list("Title", "Contents", "Author", "Cancel"))
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(stripped_input(usr, "Write a new title:"))
				if(!newtitle)
					to_chat(usr, "The title is invalid.")
					return
				else
					src.name = newtitle
					src.title = newtitle
			if("Contents")
				var/content = strip_html(input(usr, "Write your book's contents (HTML NOT allowed):"),8192)
				if(!content)
					to_chat(usr, "The content is invalid.")
					return
				else
					src.dat += content
			if("Author")
				var/newauthor = stripped_input(usr, "Write the author's name:")
				if(!newauthor)
					to_chat(usr, "The name is invalid.")
					return
				else
					src.author = newauthor
			else
				return

	else if(istype(W, /obj/item/tool/kitchen/knife) || istype(W, /obj/item/tool/wirecutters))
		if(carved)	return
		to_chat(user, SPAN_NOTICE("You begin to carve out [title]."))
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_NOTICE("You carve out the pages from [title]! You didn't want to read it anyway."))
			carved = 1
			return
	else
		..()

/obj/item/book/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_selected == "eyes")
		user.visible_message(SPAN_NOTICE("You open up the book and show it to [M]. "), \
			SPAN_NOTICE(" [user] opens up a book and shows it to [M]. "))
		show_browser(M, "<body class='paper'><TT><I>Penned by [author].</I></TT> <BR>[dat]</body>", "window=book")


