/obj/structure/bigDelivery
	desc = "A big wrapped package."
	name = "large parcel"
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "deliverycloset"
	var/obj/wrapped = null
	density = TRUE
	var/sortTag = null
	var/examtext = null
	var/nameset = 0
	var/label_y
	var/label_x
	var/tag_x
	anchored = FALSE

/obj/structure/bigDelivery/attack_hand(mob/user as mob)
	if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.forceMove(get_turf(src.loc))
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.welded = 0
	qdel(src)

/obj/structure/bigDelivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, SPAN_NOTICE("You have labeled the destination as [O.currTag]."))
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src.loc, 'sound/machines/twobeep.ogg', 25, 1)
			else
				to_chat(user, SPAN_WARNING("The package is already labeled for [O.currTag]."))
		else
			to_chat(user, SPAN_WARNING("You need to set a destination first!"))

	else if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
			if("Title")
				var/str = trim(strip_html(input(usr,"Label text?","Set label","")))
				if(!str || !length(str))
					to_chat(usr, SPAN_WARNING(" Invalid text."))
					return
				user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",
				SPAN_NOTICE("You title \the [src]: \"[str]\""),
				"You hear someone scribbling a note.")
				name = "[name] ([str])"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1
			if("Description")
				var/str = trim(strip_html(input(usr,"Label text?","Set label","")))
				if(!str || !length(str))
					to_chat(usr, SPAN_DANGER("Invalid text."))
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",
				SPAN_NOTICE("You label \the [src]: \"[examtext]\""),
				"You hear someone scribbling a note.")

/obj/structure/bigDelivery/update_icon()
	overlays = new()
	if(nameset || examtext)
		var/image/I = new/image('icons/obj/structures/crates.dmi',"delivery_label")
		if(icon_state == "deliverycloset")
			I.pixel_x = 2
			if(label_y == null)
				label_y = rand(-6, 11)
			I.pixel_y = label_y
		else if(icon_state == "deliverycrate")
			if(label_x == null)
				label_x = rand(-8, 6)
			I.pixel_x = label_x
			I.pixel_y = -3
		overlays += I
	if(src.sortTag)
		var/image/I = new/image('icons/obj/structures/crates.dmi',"delivery_tag")
		if(icon_state == "deliverycloset")
			if(tag_x == null)
				tag_x = rand(-2, 3)
			I.pixel_x = tag_x
			I.pixel_y = 9
		else if(icon_state == "deliverycrate")
			if(tag_x == null)
				tag_x = rand(-8, 6)
			I.pixel_x = tag_x
			I.pixel_y = -3
		overlays += I

/obj/structure/bigDelivery/get_examine_text(mob/user)
	. = ..()
	if(get_dist(src, user) <= 4)
		if(sortTag)
			. += SPAN_NOTICE("It is labeled \"[sortTag]\"")
		if(examtext)
			. += SPAN_NOTICE("It has a note attached which reads, \"[examtext]\"")

/obj/item/smallDelivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "deliverycrate3"
	var/obj/item/wrapped = null
	var/sortTag = null
	var/examtext = null
	var/nameset = 0
	var/tag_x

/obj/item/smallDelivery/attack_self(mob/user)
	..()

	if (src.wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.forceMove(user.loc)
		if(ishuman(user))
			user.put_in_hands(wrapped)
		else
			wrapped.forceMove(get_turf(src))

	qdel(src)

/obj/item/smallDelivery/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, SPAN_NOTICE("You have labeled the destination as [O.currTag]."))
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src.loc, 'sound/machines/twobeep.ogg', 25, 1)
			else
				to_chat(user, SPAN_WARNING("The package is already labeled for [O.currTag]."))
		else
			to_chat(user, SPAN_WARNING("You need to set a destination first!"))

	else if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
			if("Title")
				var/str = trim(strip_html(input(usr,"Label text?","Set label","")))
				if(!str || !length(str))
					to_chat(usr, SPAN_WARNING(" Invalid text."))
					return
				user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",
				SPAN_NOTICE("You title \the [src]: \"[str]\""),
				"You hear someone scribbling a note.")
				name = "[name] ([str])"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1

			if("Description")
				var/str = trim(strip_html(input(usr,"Label text?","Set label","")))
				if(!str || !length(str))
					to_chat(usr, SPAN_DANGER("Invalid text."))
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",
				SPAN_NOTICE("You label \the [src]: \"[examtext]\""),
				"You hear someone scribbling a note.")
	return

/obj/item/smallDelivery/update_icon()
	overlays = new()
	if((nameset || examtext) && icon_state != "deliverycrate1")
		var/image/I = new/image('icons/obj/structures/crates.dmi',"delivery_label")
		if(icon_state == "deliverycrate5")
			I.pixel_y = -1
		overlays += I
	if(src.sortTag)
		var/image/I = new/image('icons/obj/structures/crates.dmi',"delivery_tag")
		switch(icon_state)
			if("deliverycrate1")
				I.pixel_y = -5
			if("deliverycrate2")
				I.pixel_y = -2
			if("deliverycrate3")
				I.pixel_y = 0
			if("deliverycrate4")
				if(tag_x == null)
					tag_x = rand(0,5)
				I.pixel_x = tag_x
				I.pixel_y = 3
			if("deliverycrate5")
				I.pixel_y = -3
		overlays += I

/obj/item/smallDelivery/get_examine_text(mob/user)
	. = ..()
	if(get_dist(src, user) <= 4)
		if(sortTag)
			. += SPAN_NOTICE("It is labeled \"[sortTag]\"")
		if(examtext)
			. += SPAN_NOTICE("It has a note attached which reads, \"[examtext]\"")

/obj/item/packageWrap
	name = "package wrapper"
	icon = 'icons/obj/items/tools.dmi'
	icon_state = "deliveryPaper"
	w_class = SIZE_MEDIUM
	var/amount = 50


/obj/item/packageWrap/afterattack(obj/target as obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!istype(target)) //this really shouldn't be necessary (but it is). -Pete
		return
	if(istype(target, /obj/item/smallDelivery) || istype(target,/obj/structure/bigDelivery) \
	|| istype(target, /obj/item/gift) || istype(target, /obj/item/evidencebag))
		return
	if(target.anchored)
		return
	if(target in user)
		return
	if(user in target) //no wrapping closets that you are inside - it's not physically possible
		return

	user.attack_log += text("\[[time_stamp()]\] <font color='blue'>Has used [src.name] on \ref[target]</font>")


	if (istype(target, /obj/item) && !(isstorage(target) && !istype(target,/obj/item/storage/box)))
		var/obj/item/O = target
		if (src.amount > 1)
			var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(O.loc)) //Aaannd wrap it up!
			if(!istype(O.loc, /turf))
				if(user.client)
					user.client.remove_from_screen(O)
			P.wrapped = O
			O.forceMove(P)
			P.w_class = O.w_class
			var/i = floor(P.w_class)
			if(i in list(1,2,3,4,5))
				P.icon_state = "deliverycrate[i]"
				switch(i)
					if(1)
						P.name = "tiny parcel"
					if(3)
						P.name = "normal-sized parcel"
					if(4)
						P.name = "large parcel"
					if(5)
						P.name = "huge parcel"
			if(i < 1)
				P.icon_state = "deliverycrate1"
				P.name = "tiny parcel"
			if(i > 5)
				P.icon_state = "deliverycrate5"
				P.name = "huge parcel"
			P.add_fingerprint(usr)
			O.add_fingerprint(usr)
			src.add_fingerprint(usr)
			src.amount--
			user.visible_message("[user] wraps [target] with [src].",
			SPAN_NOTICE("You wrap [target], leaving [amount] units of paper on [src]."),
			"You hear someone taping paper around a small object.")
	else if (istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/crate = target
		var/answer = tgui_alert(user, "Wrap the crate for delivery or customize it?", "Crate wrapping", list("Customize", "Wrap"))
		if(!answer || !user.Adjacent(target) || !target.z)
			return
		if(answer == "Customize")
			if(!length(crate.crate_customizing_types))
				to_chat(user, SPAN_WARNING("You cannot customize this kind of crate."))
				return
			var/label = tgui_input_text(user, "Give the crate a new logistic tag:", "Customizing")
			if(!label || !user.Adjacent(target) || !target.z)
				return
			var/chosen_type = tgui_input_list(user, "Select the kind of crate to make this into:", "Customizing", crate.crate_customizing_types)
			if(!chosen_type || !ispath(crate.crate_customizing_types[chosen_type]) || !user.Adjacent(target) || !target.z)
				return
			target.AddComponent(/datum/component/crate_tag, label, crate.crate_customizing_types[chosen_type])
			amount -= 3
		else
			if (amount > 3 && !crate.opened)
				var/obj/structure/bigDelivery/package = new /obj/structure/bigDelivery(get_turf(crate.loc))
				package.icon_state = "deliverycrate"
				package.wrapped = crate
				crate.forceMove(package)
				amount -= 3
				user.visible_message("[user] wraps [target] with [src].",
				SPAN_NOTICE("You wrap [target], leaving [amount] units of paper on [src]."),
				"You hear someone taping paper around a large object.")
			else if(amount < 3)
				to_chat(user, SPAN_WARNING("You need more paper."))
	else if (istype (target, /obj/structure/closet))
		var/obj/structure/closet/object = target
		if (amount > 3 && !object.opened)
			var/obj/structure/bigDelivery/package = new /obj/structure/bigDelivery(get_turf(object.loc))
			package.wrapped = object
			object.welded = 1
			object.forceMove(package)
			amount -= 3
			user.visible_message("[user] wraps [target] with [src].",
			SPAN_NOTICE("You wrap [target], leaving [amount] units of paper on [src]."),
			"You hear someone taping paper around a large object.")
		else if(amount < 3)
			to_chat(user, SPAN_WARNING("You need more paper."))
	else
		to_chat(user, SPAN_NOTICE(" The object you are trying to wrap is unsuitable for the sorting machinery!"))
	if (amount <= 0)
		new /obj/item/trash/c_tube( loc )
		qdel(src)
		return
	return

/obj/item/packageWrap/get_examine_text(mob/user)
	. = ..()
	if(get_dist(src, user) < 2)
		. += SPAN_NOTICE(" There are [amount] units of package wrap left!")


/obj/item/device/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon_state = "dest_tagger"
	icon = 'icons/obj/items/tools.dmi'
	var/currTag = 0

	w_class = SIZE_SMALL
	item_state = "electronic"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST

/obj/item/device/destTagger/proc/openwindow(mob/user)
	var/dat = "<tt><center><h1><b>TagMaster 2.3</b></h1></center>"

	dat += "<table style='width:100%; padding:4px;'><tr>"
	for(var/i = 1, i <= length(GLOB.tagger_locations), i++)
		dat += "<td><a href='byond://?src=\ref[src];nextTag=[GLOB.tagger_locations[i]]'>[GLOB.tagger_locations[i]]</a></td>"

		if (i%4==0)
			dat += "</tr><tr>"

	dat += "</tr></table><br>Current Selection: [currTag ? currTag : "None"]</tt>"

	user << browse(dat, "window=destTagScreen;size=450x350")
	onclose(user, "destTagScreen")

/obj/item/device/destTagger/attack_self(mob/user)
	..()
	openwindow(user)

/obj/item/device/destTagger/Topic(href, href_list)
	. = ..()
	if(.)
		return
	src.add_fingerprint(usr)
	if(href_list["nextTag"] && (href_list["nextTag"] in GLOB.tagger_locations))
		src.currTag = href_list["nextTag"]
	openwindow(usr)

/obj/structure/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = TRUE
	icon_state = "intake"

	var/c_mode = 0

/obj/structure/machinery/disposal/deliveryChute/New()
	..()
	spawn(5)
		trunk = locate() in src.loc
		if(trunk)
			trunk.linked = src // link the pipe trunk to self

/obj/structure/machinery/disposal/deliveryChute/interact()
	return

/obj/structure/machinery/disposal/deliveryChute/update()
	return

/obj/structure/machinery/disposal/deliveryChute/Collided(atom/movable/AM) //Go straight into the chute
	if(istype(AM, /obj/projectile) || istype(AM, /obj/effect))
		return
	switch(dir)
		if(NORTH)
			if(AM.loc.y != src.loc.y+1)
				return
		if(EAST)
			if(AM.loc.x != src.loc.x+1)
				return
		if(SOUTH)
			if(AM.loc.y != src.loc.y-1)
				return
		if(WEST)
			if(AM.loc.x != src.loc.x-1)
				return

	if(istype(AM, /obj))
		var/obj/O = AM
		O.forceMove(src)
		src.flush()

/obj/structure/machinery/disposal/deliveryChute/flush()
	flushing = 1
	flick("intake-closing", src)
	var/obj/structure/disposalholder/H = new() // virtual holder object which actually
												// travels through the pipes.

	sleep(10)
	playsound(src, 'sound/machines/disposalflush.ogg', 25, 0)
	sleep(5) // wait for animation to finish

	H.init(src) // copy the contents of disposer to holder

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2) // if was ready,
		mode = 1 // switch to charging
	update()
	return

/obj/structure/machinery/disposal/deliveryChute/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return

	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		if(c_mode==0)
			c_mode=1
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(c_mode==1)
			c_mode=0
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(iswelder(I) && c_mode==1)
		if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/W = I
		if(W.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			to_chat(user, "You start slicing the floorweld off the delivery chute.")
			if(do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(!src || !W.isOn())
					return
				to_chat(user, "You sliced the floorweld off the delivery chute.")
				var/obj/structure/disposalconstruct/C = new (src.loc)
				C.ptype = 8 // 8 =  Delivery chute
				C.update()
				C.anchored = TRUE
				C.density = TRUE
				qdel(src)
			return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return
