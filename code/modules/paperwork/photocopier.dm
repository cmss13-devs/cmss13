/// Normal Photocopier, made by Seegson
/obj/structure/machinery/photocopier
	name = "photocopier"
	icon = 'icons/obj/structures/machinery/library.dmi'
	icon_state = "bigscanner"
	desc = "A photocopier used for copying... you know, photos! Also useful for copying documents on paper. This specific model has been manufactured by Seegson in a cheaper frame than most modern photocopiers. It uses more primitive copying technology resulting in more toner waste and less printing capabilities. Nonetheless, its cheap construction means cheaper costs, and for people that only need to print a paper or two most of the time, it becomes cost-effective."
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = POWER_CHANNEL_EQUIP
	var/obj/item/paper/copy = null //what's in the copier!
	var/obj/item/photo/photocopy = null
	var/obj/item/paper_bundle/bundle = null
	///how many copies to print!
	var/copies = 1
	///how much toner is left! woooooo~
	var/toner = 45
	///how many copies can be copied at once- idea shamelessly stolen from bs12's copier!
	var/maxcopies = 10
	///the flick state to use when inserting paper into the machine
	var/animate_state = "bigscanner1"


/obj/structure/machinery/photocopier/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/photocopier/attack_hand(mob/user as mob)
	user.set_interaction(src)

	var/dat
	if(copy || photocopy || bundle)
		dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Paper</a><BR>"
		if(toner)
			dat += "<a href='byond://?src=\ref[src];copy=1'>Copy</a><BR>"
			dat += "Printing: [copies] copies."
			dat += "<a href='byond://?src=\ref[src];min=1'>-</a> "
			dat += "<a href='byond://?src=\ref[src];add=1'>+</a><BR><BR>"
	else if(toner)
		dat += "Please insert paper to copy.<BR><BR>"
	dat += "Current toner level: [toner]"
	if(!toner)
		dat +="<BR>Please insert a new toner cartridge!"
	show_browser(user, dat, "Photocopier", "copier")
	return

/obj/structure/machinery/photocopier/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["copy"])
		if(copy)
			for(var/i = 0, i < copies, i++)
				if(toner > 0 && copy)
					copy(copy)
					sleep(15)
				else
					break
			updateUsrDialog()
		else if(photocopy)
			for(var/i = 0, i < copies, i++)
				if(toner > 0 && photocopy)
					photocopy(photocopy)
					sleep(15)
				else
					break
			updateUsrDialog()
		else if(bundle)
			for(var/i = 0, i < copies, i++)
				if(toner <= 0 || !bundle)
					break
				var/obj/item/paper_bundle/p = new /obj/item/paper_bundle (src)
				var/j = 0
				for(var/obj/item/W in bundle)
					if(toner <= 0)
						to_chat(usr, SPAN_NOTICE("The photocopier couldn't finish the printjob."))
						break
					else if(istype(W, /obj/item/paper))
						W = copy(W)
					else if(istype(W, /obj/item/photo))
						W = photocopy(W)
					W.forceMove(p)
					p.amount++
					j++
				p.amount--
				p.forceMove(src.loc)
				p.update_icon()
				p.icon_state = "paper_words"
				p.name = bundle.name
				sleep(15*j)
			updateUsrDialog()
	else if(href_list["remove"])
		if(copy)
			copy.forceMove(usr.loc)
			usr.put_in_hands(copy)
			to_chat(usr, SPAN_NOTICE("You take the paper out of \the [src]."))
			copy = null
			updateUsrDialog()
		else if(photocopy)
			photocopy.forceMove(usr.loc)
			usr.put_in_hands(photocopy)
			to_chat(usr, SPAN_NOTICE("You take the photo out of \the [src]."))
			photocopy = null
			updateUsrDialog()
		else if(bundle)
			bundle.forceMove(usr.loc)
			usr.put_in_hands(bundle)
			to_chat(usr, SPAN_NOTICE("You take the paper bundle out of \the [src]."))
			bundle = null
			updateUsrDialog()
	else if(href_list["min"])
		if(copies > 1)
			copies--
			updateUsrDialog()
	else if(href_list["add"])
		if(copies < maxcopies)
			copies++
			updateUsrDialog()

/obj/structure/machinery/photocopier/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/paper))
		if(!copy && !photocopy && !bundle)
			if(user.drop_inv_item_to_loc(O, src))
				copy = O
				to_chat(user, SPAN_NOTICE("You insert the paper into \the [src]."))
				flick(animate_state, src)
				updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("There is already something in \the [src]."))
	else if(istype(O, /obj/item/photo))
		if(!copy && !photocopy && !bundle)
			if(user.drop_inv_item_to_loc(O, src))
				photocopy = O
				to_chat(user, SPAN_NOTICE("You insert the photo into \the [src]."))
				flick(animate_state, src)
				updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("There is already something in \the [src]."))
	else if(istype(O, /obj/item/paper_bundle))
		if(!copy && !photocopy && !bundle)
			if(user.drop_inv_item_to_loc(O, src))
				bundle = O
				to_chat(user, SPAN_NOTICE("You insert the bundle into \the [src]."))
				flick(animate_state, src)
				updateUsrDialog()
	else if(istype(O, /obj/item/device/toner))
		if(toner == 0)
			if(user.temp_drop_inv_item(O))
				qdel(O)
				toner = initial(toner)
				to_chat(user, SPAN_NOTICE("You insert the toner cartridge into \the [src]."))
				updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("This cartridge is not yet ready for replacement! Use up the rest of the toner."))
	else if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))
	return

/obj/structure/machinery/photocopier/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(50))
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
			else
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
	return

/obj/structure/machinery/photocopier/proc/copy(obj/item/paper/original)
	var/obj/item/paper/copy = new /obj/item/paper (loc)
	if(toner > 10) //lots of toner, make it dark
		copy.info = "<font color = #101010>"
	else //no toner? shitty copies for you!
		copy.info = "<font color = #808080>"
	var/copied = original.info
	copied = replacetext(copied, "<font face=\"[copy.deffont]\" color=", "<font face=\"[copy.deffont]\" nocolor=") //state of the art techniques in action
	copied = replacetext(copied, "<font face=\"[copy.crayonfont]\" color=", "<font face=\"[copy.crayonfont]\" nocolor=") //This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
	copy.info += copied
	copy.info += "</font>"
	copy.name = original.name // -- Doohl
	copy.fields = original.fields
	copy.stamps = original.stamps
	copy.stamped = original.stamped
	copy.ico = original.ico
	copy.offset_x = original.offset_x
	copy.offset_y = original.offset_y
	copy.update_icon()

	//Iterates through stamps and puts a matching gray overlay onto the copy
	var/image/img //
	for (var/j = 1, j <= length(original.ico), j++)
		if (findtext(original.ico[j], "cap") || findtext(original.ico[j], "cent"))
			img = image('icons/obj/items/paper.dmi', "paper_stamp-circle")
		else if (findtext(original.ico[j], "deny"))
			img = image('icons/obj/items/paper.dmi', "paper_stamp-x")
		else
			img = image('icons/obj/items/paper.dmi', "paper_stamp-dots")
		img.pixel_x = original.offset_x[j]
		img.pixel_y = original.offset_y[j]
		copy.overlays += img
	copy.updateinfolinks()
	toner--
	return copy


/obj/structure/machinery/photocopier/on_stored_atom_del(atom/movable/AM)
	if(AM == copy)
		copy = null
	else if(AM == photocopy)
		photocopy = null
	else if(AM == bundle)
		bundle = null

/obj/structure/machinery/photocopier/proc/photocopy(obj/item/photo/photocopy)
	var/obj/item/photo/p = new /obj/item/photo (src.loc)
	var/icon/I = icon(photocopy.icon, photocopy.icon_state)
	var/icon/img = icon(photocopy.img)
	var/icon/tiny = icon(photocopy.tiny)
	if(toner > 10) //plenty of toner, go straight greyscale
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0)) //I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	else //not much toner left, lighten the photo
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
	p.icon = I
	p.img = img
	p.tiny = tiny
	p.name = photocopy.name
	p.desc = photocopy.desc
	p.scribble = photocopy.scribble
	toner -= 5 //photos use a lot of ink!
	if(toner < 0)
		toner = 0
	return p


/// Upgraded photocopier, straight upgrade from the normal photocopier, made by Weyland-Yutani
/obj/structure/machinery/photocopier/wyphotocopier
	name = "photocopier"
	icon = 'icons/obj/structures/machinery/library.dmi'
	icon_state = "bigscannerpro"
	desc = "A photocopier used for copying... you know, photos! Also useful for copying documents on paper. This specific model has been manufactured by Weyland-Yutani in a more modern and robust frame than the average photocopiers you see from smaller companies. It uses some of the most advanced technologies in the area of paper-printing such as bigger toner economy and much higher printing capabilities. All that makes it the favorite among consumers that need to print high amounts of paperwork for their daily duties."
	idle_power_usage = 50
	active_power_usage = 300
	copies = 1
	toner = 180
	maxcopies = 30
	animate_state = "bigscannerpro1"


/// The actual toner cartridge used in photcopiers
/obj/item/device/toner
	name = "toner cartridge"
	icon_state = "tonercartridge"
