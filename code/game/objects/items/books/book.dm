/*
 * Book
 */
/obj/item/book
	name = "book"
	icon = 'icons/obj/items/books.dmi'
	icon_state = "book"
	item_state = "book_dark"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/books_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/books_righthand.dmi',
	)
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
	if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
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
					playsound(src, "paper_writing", 15, TRUE)
			if("Contents")
				var/content = strip_html(input(usr, "Write your book's contents (HTML NOT allowed):"),8192)
				if(!content)
					to_chat(usr, "The content is invalid.")
					return
				else
					src.dat += content
					playsound(src, "paper_writing", 15, TRUE)
			if("Author")
				var/newauthor = stripped_input(usr, "Write the author's name:")
				if(!newauthor)
					to_chat(usr, "The name is invalid.")
					return
				else
					src.author = newauthor
					playsound(src, "paper_writing", 15, TRUE)
			else
				return

	else if(istype(W, /obj/item/tool/kitchen/knife) || HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		if(carved)
			return
		to_chat(user, SPAN_NOTICE("You begin to carve out [title]."))
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_NOTICE("You carve out the pages from [title]! You didn't want to read it anyway."))
			carved = 1
			return
	else
		..()

/obj/item/book/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_selected == "eyes")
		user.visible_message(SPAN_NOTICE("You open up the book and show it to [M]. "),
			SPAN_NOTICE(" [user] opens up a book and shows it to [M]. "))
		show_browser(M, "<body class='paper'><TT><I>Penned by [author].</I></TT> <BR>[dat]</body>", "window=book")

/obj/item/lore_book
	name = "book"
	icon = 'icons/obj/items/books.dmi'
	icon_state = "book"
	item_state = "book_dark"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/books_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/books_righthand.dmi',
	)
	w_class = SIZE_MEDIUM
	attack_verb = list("bashed", "whacked", "educated")
	pickup_sound = 'sound/handling/book_pickup.ogg'
	drop_sound = 'sound/handling/book_pickup.ogg'

	var/book_title = "A guide to unreality"
	var/book_author = "Notreal FakeDude"
	var/book_contents = @{"
		# This book's not written in! It shouldn't exist! Aah!

		Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

		At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.

		## Some subtitle!

		```
		Code block! Code block! For emphasis and quotes! Like the tech manual!
		```

		This is some text! **This is some bold text!** And *this text* is in italics!

		This is a list:
		- It has elements!
		- It has another one! Woah!

		Image:
		![Alt text](/test.png)

	"}

	var/live_preview = FALSE

/obj/item/lore_book/attack_self(mob/user)
	. = ..()

	tgui_interact(user)

/obj/item/lore_book/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(ui)
		return

	ui = new(user, src, "Book", book_title)
	ui.set_autoupdate(FALSE)
	ui.open()

/obj/item/lore_book/ui_state(mob/user, datum/ui_state/state)
	return GLOB.human_adjacent_state

/obj/item/lore_book/ui_static_data(mob/user)
	. = ..()

	.["title"] = book_title
	.["author"] = book_author
	.["contents"] = book_contents

	.["preview"] = live_preview

/obj/item/lore_book/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(!live_preview)
		return

	var/new_contents = params["contents"]
	if(!new_contents)
		return

	book_contents = new_contents
	return TRUE

/obj/item/lore_book/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/simple/paper)
	. += get_asset_datum(/datum/asset/directory/book_assets)

/obj/item/lore_book/debug
	book_title = "Writing for Dummies: Book Authorship in the 22nd Century"
	book_contents = @{"
		Thank you for wanting to contribute to our library! This book will serve as a reference to the syntax we use in books - Markdown, as well as a guide on how to write new books.

		## Markdown and You

		Markdown allows us to make pretty looking pages very simply, with easy to understand syntax. It's also what Discord uses, so you probably know it already. It looks a bit like this:

		```
		# This is some big text!

		This is some normal text!

		## This is a slightly smaller header.
		```

		If you press "Preview" in the top right - you'll open the live editor. This allows you to make changes to the Markdown and get a preview live. If you press Enter, you'll save this to the book in the game - so you won't lose your work if you exit!

		## Headings

		These are indicated by placing a # before your text. The largest heading is only 1 #, increasing numbers will decrease the size of the heading.

		# Big heading!

		## Smaller heading!

		### Smaller still!

		## Images

		These are fun! You need to first add your image files to `html/book_assets`. Then, you can reference them using the Markdown syntax for images.

		```
		![Some dice](/test.png)
		```

		![Some dice](/test.png)

		## Text Emphasis

		We can emphasise text using double asterisks, so **this text** is bold. We can also make text italics with *single asterisks*.

		## Blockquotes

		Created by placing a > before your line, these can be used to add quotations into text. An alternative to codeblocks, which we'll discussl ater.

		> This is inside a blockquote!

		## Lists

		We can create lists using - before your sentences, so:
		- This is an element of a list.
		- And this is another.

		This also works with numbers:
		1. This is the first element.
		2. And this is the second.

		## Code blocks

		We use these for big blocks, like the tech manual. This is 3 backticks (`) before and after. Note: you'll have to manually insert linebreaks into these, as they are considered pre-rendered, and can go off the page.

		```
		Hi! I'm in a codeblock!
		```
	"}
	live_preview = TRUE
