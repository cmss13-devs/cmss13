




/////////////////////// Hand Labeler ////////////////////////////////

/atom/proc/set_name_label(var/new_label)
	name_label = new_label
	name = initial(name)
	if(name_label)
		name += " ([name_label])"

/obj/item/tool/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 50
	var/mode = 0	//off or on.
	var/label_sound = 'sound/items/component_pickup.ogg'
	var/remove_label_sound = 'sound/items/paper_ripped.ogg'

	matter = list("metal" = 125)

/obj/item/tool/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(!mode)	//if it's off, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(!labels_left)
		to_chat(user, SPAN_NOTICE("No labels left."))
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, SPAN_NOTICE("Label too big."))
		return
	if(isliving(A) || istype(A, /obj/item/holder))
		to_chat(user, SPAN_NOTICE("You can't label living beings."))
		return
	if((istype(A, /obj/item/reagent_container/glass)) && (!(istype(A, /obj/item/reagent_container/glass/minitank))))
		to_chat(user, SPAN_NOTICE("The label will not stick to [A]. Use a pen instead."))
		return
	if(istype(A, /obj/item/tool/surgery) || istype(A, /obj/item/reagent_container/pill))
		to_chat(user, SPAN_NOTICE("That wouldn't be sanitary."))
		return
	if((istype(A, /obj/vehicle/multitile)) || (istype(A, /obj/structure))) // disallow naming structures
		to_chat(user, SPAN_NOTICE("The label won't stick to that."))
		return
	if(isturf(A))
		to_chat(user, SPAN_NOTICE("The label won't stick to that."))
		return
	if(!label || !length(label))
		remove_label(A, user)
		return
	if(A.name_label == label)
		to_chat(user, SPAN_NOTICE("It already has the same label."))
		return

	user.visible_message(SPAN_NOTICE("[user] labels [A] as \"[label]\"."), \
	SPAN_NOTICE("You label [A] as \"[label]\"."))

	log_admin("[user] has labeled [A.name] with label \"[label]\". (CKEY: ([user.ckey]))")

	A.set_name_label(label)

	playsound(A, label_sound, 20, TRUE)

	labels_left--

/obj/item/tool/hand_labeler/attack_self(mob/user)
	..()
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
		//Now let them choose the text.
		var/str = copytext(reject_bad_text(input(user,"Label text?", "Set label", "")), 1, MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(user, SPAN_NOTICE("Label text cleared. You can now remove labels."))
			label = null
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))



/*
	Allow the user of the labeler to remove a label, if there is no text set
	@A object trying to remove the label
	@user the player using the labeler

*/

/obj/item/tool/hand_labeler/proc/remove_label(var/atom/A, var/mob/user)
	if(A.name == initial(A.name))
		to_chat(user, SPAN_NOTICE("There is no label to remove."))
		return
	user.visible_message(SPAN_NOTICE("[user] removes label from [A]."), \
						 SPAN_NOTICE("You remove the label from [A]."))

	log_admin("[user] has removed label from [A.name]. (CKEY: ([user.ckey]))")

	A.set_name_label(null)

	playsound(A, remove_label_sound, 20, TRUE)

/**
    Allow the user to refill the labeller
    @I what is the item trying to be used
    @user what is using paper on the handler
*/

/obj/item/tool/hand_labeler/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/paper))
		if(labels_left != initial(labels_left))
			to_chat(user, SPAN_NOTICE("You insert [I] into [src]."))
			qdel(I) //delete the paper item
			labels_left = initial(labels_left)
		else
			to_chat(user, SPAN_NOTICE("The [src] is already full."))

/*
    Instead of updating labels_left to user every label used,
    Have the user examine it to show them.
*/
/obj/item/tool/hand_labeler/get_examine_text(mob/user)
    . = ..()
    . += SPAN_NOTICE("It has [labels_left] out of [initial(labels_left)] labels left.")
    . += SPAN_HELPFUL("Use paper to refill it.")


/*
 * Pens
 */
/obj/item/tool/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "pen"
	item_state = "pen"
	flags_equip_slot = SLOT_WAIST|SLOT_EAR|SLOT_SUIT_STORE
	throwforce = 0
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	matter = list("metal" = 10)
	var/pen_colour = "black"	//what colour the ink is!
	var/on = TRUE
	var/clicky = FALSE

/obj/item/tool/pen/attack_self(mob/living/carbon/human/user)
	..()
	on = !on
	to_chat(user, SPAN_WARNING("You click the pen [on? "on": "off"]."))
	if(clicky)
		playsound(user.loc, "sound/items/pen_click_[on? "on": "off"].ogg", 100, 1, 5)
	update_pen_state()

/obj/item/tool/pen/Initialize()
	. = ..()
	update_pen_state()

/obj/item/tool/pen/proc/update_pen_state()
	overlays.Cut()
	if(on)
		overlays += "+[pen_colour]_tip"

/obj/item/tool/pen/clicky
	desc = "It's a WY brand extra clicky black ink pen."
	name = "WY pen"
	clicky = TRUE

/obj/item/tool/pen/blue
	desc = "It's a normal blue ink pen."
	pen_colour = "blue"

/obj/item/tool/pen/blue/clicky
	desc = "It's a WY brand extra clicky blue ink pen."
	name = "WY blue pen"
	clicky = TRUE

/obj/item/tool/pen/red
	desc = "It's a normal red ink pen."
	pen_colour = "red"

/obj/item/tool/pen/red/clicky
	desc = "It's a WY brand extra clicky red ink pen."
	name = "WY red pen"
	clicky = TRUE

/obj/item/tool/pen/green
	desc = "It's a normal green ink pen."
	pen_colour = "green"

/obj/item/tool/pen/green/clicky
	desc = "It's a WY brand extra clicky green ink pen."
	name = "WY green pen"
	clicky = TRUE

/obj/item/tool/pen/invisible
	desc = "It's an invisible pen marker."
	pen_colour = "white"


/obj/item/tool/pen/attack(mob/M as mob, mob/user as mob)
	if(!ismob(M))
		return
	to_chat(user, SPAN_WARNING("You stab [M] with the pen."))
//	to_chat(M, SPAN_WARNING("You feel a tiny prick!")) //That's a whole lot of meta!
	M.last_damage_data = create_cause_data(initial(name), user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stabbed with [name] by [key_name(user)]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to stab [key_name(M)]</font>")
	msg_admin_attack("[key_name(user)] Used the [name] to stab [key_name(M)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
	return


/*
 * Sleepy Pens
 */
/obj/item/tool/pen/sleepypen
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\""
	flags_atom = FPRINT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST



/obj/item/tool/pen/sleepypen/Initialize()
	. = ..()
	create_reagents(30) //Used to be 300
	reagents.add_reagent("chloralhydrate", 22)	//Used to be 100 sleep toxin//30 Chloral seems to be fatal, reducing it to 22./N
	..()
	return


/obj/item/tool/pen/sleepypen/attack(mob/M as mob, mob/user as mob)
	if(!(istype(M,/mob)))
		return
	..()
	if(reagents.total_volume)
		if(M.reagents) reagents.trans_to(M, 50) //used to be 150
	return


/*
 * Parapens
 */
/obj/item/tool/pen/paralysis
	flags_atom = FPRINT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST



/obj/item/tool/pen/paralysis/attack(mob/living/M as mob, mob/user as mob)
	if(!(istype(M)))
		return
	..()
	if(M.can_inject(user, TRUE))
		if(reagents.total_volume)
			if(M.reagents) reagents.trans_to(M, 50)

/obj/item/tool/pen/paralysis/Initialize()
	. = ..()
	create_reagents(50)
	reagents.add_reagent("zombiepowder", 10)
	reagents.add_reagent("cryptobiolin", 15)

/obj/item/tool/stamp
	name = "rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "stamp-def"
	item_state = "stamp"
	throwforce = 0
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	matter = list("metal" = 60)
	attack_verb = list("stamped")

/obj/item/tool/stamp/captain
	name = "captain's rubber stamp"
	icon_state = "stamp-cap"

/obj/item/tool/stamp/hop
	name = "head of personnel's rubber stamp"
	icon_state = "stamp-hop"

/obj/item/tool/stamp/hos
	name = "head of security's rubber stamp"
	icon_state = "stamp-hos"

/obj/item/tool/stamp/ce
	name = "chief engineer's rubber stamp"
	icon_state = "stamp-ce"

/obj/item/tool/stamp/rd
	name = "research director's rubber stamp"
	icon_state = "stamp-rd"

/obj/item/tool/stamp/cmo
	name = "chief medical officer's rubber stamp"
	icon_state = "stamp-cmo"

/obj/item/tool/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"

/obj/item/tool/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"

/obj/item/tool/stamp/internalaffairs
	name = "internal affairs rubber stamp"
	icon_state = "stamp-intaff"

/obj/item/tool/stamp/centcomm
	name = "centcomm rubber stamp"
	icon_state = "stamp-cent"

/obj/item/tool/stamp/ro
	name = "requisitions officer's rubber stamp"
	icon_state = "stamp-ro"
