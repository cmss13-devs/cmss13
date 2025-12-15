/obj/item/paper/carbon
	name = "paper"
	icon_state = "paper_stack"
	item_state = "paper"
	var/copied = FALSE
	var/iscopy = FALSE

/obj/item/paper/carbon/update_icon()
	if(iscopy)
		if(info)
			icon_state = "cpaper_words"
			return
		icon_state = "cpaper"
	else if (copied)
		if(info)
			icon_state = "paper_words"
			return
		icon_state = "paper"
	else
		if(info)
			icon_state = "paper_stack_words"
			return
		icon_state = "paper_stack"

/obj/item/paper/carbon/verb/removecopy()
	set name = "Remove carbon-copy"
	set category = "Object"
	set src in usr

	if (!copied && !iscopy)
		var/obj/item/paper/carbon/c = src
		var/copycontents = html_decode(c.info)
		var/obj/item/paper/carbon/copy = new /obj/item/paper/carbon (usr.loc)
		copycontents = replacetext(copycontents, "<font face=\"[c.deffont]\" color=", "<font face=\"[c.deffont]\" nocolor=") //state of the art techniques in action
		copycontents = replacetext(copycontents, "<font face=\"[c.crayonfont]\" color=", "<font face=\"[c.crayonfont]\" nocolor=") //This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
		copy.info += copycontents
		copy.info += "</font>"
		copy.name = "Copy - " + c.name
		copy.fields = c.fields
		copy.updateinfolinks()
		to_chat(usr, SPAN_NOTICE("You tear off the carbon-copy!"))
		c.copied = TRUE
		copy.iscopy = TRUE
		copy.update_icon()
		c.update_icon()
	else
		to_chat(usr, "There are no more carbon copies attached to this paper!")

/obj/item/paper/prefab/carbon
	name = "paper"
	icon_state = "paper_stack"
	item_state = "paper"
	var/copied = FALSE
	var/iscopy = FALSE

/obj/item/paper/prefab/carbon/update_icon()
	if(iscopy)
		if(info)
			icon_state = "cpaper_words"
			return
		icon_state = "cpaper"
	else if (copied)
		if(info)
			icon_state = "paper_words"
			return
		icon_state = "paper"
	else
		if(info)
			icon_state = "paper_stack_words"
			return
		icon_state = "paper_stack"

/obj/item/paper/prefab/carbon/verb/removecopy()
	set name = "Remove carbon-copy"
	set category = "Object"
	set src in usr

	if (!copied && !iscopy)
		var/obj/item/paper/prefab/carbon/this_doc = src
		var/copycontents = html_decode(this_doc.info)
		var/obj/item/paper/carbon/copy = new /obj/item/paper/carbon (usr.loc)
		copycontents = replacetext(copycontents, "<font face=\"[this_doc.deffont]\" color=", "<font face=\"[this_doc.deffont]\" nocolor=") //state of the art techniques in action
		copycontents = replacetext(copycontents, "<font face=\"[this_doc.crayonfont]\" color=", "<font face=\"[this_doc.crayonfont]\" nocolor=") //This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
		copy.info += copycontents
		copy.info += "</font>"
		copy.name = "Copy - " + this_doc.name
		copy.fields = this_doc.fields
		copy.updateinfolinks()
		to_chat(usr, SPAN_NOTICE("You tear off the carbon-copy!"))
		this_doc.copied = TRUE
		copy.iscopy = TRUE
		copy.update_icon()
		this_doc.update_icon()
	else
		to_chat(usr, "There are no more carbon copies attached to this paper!")
