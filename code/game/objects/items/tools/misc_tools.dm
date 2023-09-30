




/////////////////////// Hand Labeler ////////////////////////////////


/// meant for use with qdelling/newing things to transfer labels between them
/atom/proc/transfer_label_component(atom/target)
	var/datum/component/label/src_label_component = GetComponent(/datum/component/label)
	if(src_label_component)
		var/target_label_text = src_label_component.label_name
		target.AddComponent(/datum/component/label, target_label_text)

/obj/item/tool/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 50
	/// off or on.
	var/mode = 0
	var/label_sound = 'sound/items/component_pickup.ogg'
	var/remove_label_sound = 'sound/items/paper_ripped.ogg'

	matter = list("metal" = 125)

/obj/item/tool/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return

	if(!mode) //if it's off, give up.
		to_chat(user, SPAN_WARNING("\The [src] isn't on."))
		return

	if(A == loc) // if placing the labeller into something (e.g. backpack)
		return // don't set a label

	if(!labels_left)
		to_chat(user, SPAN_WARNING("No labels left."))
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, SPAN_WARNING("Label too big."))
		return
	if(isliving(A) || istype(A, /obj/item/holder))
		to_chat(user, SPAN_WARNING("You can't label living beings."))
		return
	if((istype(A, /obj/item/reagent_container/glass)) && (!(istype(A, /obj/item/reagent_container/glass/minitank))))
		to_chat(user, SPAN_WARNING("The label will not stick to [A]. Use a pen instead."))
		return
	if(istype(A, /obj/item/tool/surgery) || istype(A, /obj/item/reagent_container/pill))
		to_chat(user, SPAN_WARNING("That wouldn't be sanitary."))
		return
	if((istype(A, /obj/vehicle/multitile)) || (istype(A, /obj/structure))) // disallow naming structures
		to_chat(user, SPAN_WARNING("The label won't stick to that."))
		return
	if(isturf(A))
		to_chat(user, SPAN_WARNING("The label won't stick to that."))
		return
	if(!label || !length(label))
		remove_label(A, user)
		return

	var/datum/component/label/labelcomponent = A.GetComponent(/datum/component/label)
	if(labelcomponent)
		if(labelcomponent.label_name == label)
			to_chat(user, SPAN_WARNING("It already has the same label."))
			return

	user.visible_message(SPAN_NOTICE("[user] labels [A] as \"[label]\"."), \
	SPAN_NOTICE("You label [A] as \"[label]\"."))

	log_admin("[user] has labeled [A.name] with label \"[label]\". (CKEY: ([user.ckey]))")

	A.AddComponent(/datum/component/label, label)

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

/obj/item/tool/hand_labeler/proc/remove_label(atom/A, mob/user)
	var/datum/component/label/label = A.GetComponent(/datum/component/label)
	if(label)
		user.visible_message(SPAN_NOTICE("[user] removes label from [A]."), \
						SPAN_NOTICE("You remove the label from [A]."))
		label.remove_label()
		log_admin("[user] has removed label from [A.name]. (CKEY: ([user.ckey]))")
		playsound(A, remove_label_sound, 20, TRUE)
		return
	else
		to_chat(user, SPAN_NOTICE("There is no label to remove."))
		return

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
	inherent_traits = list(TRAIT_TOOL_PEN)
	/// what color the ink is!
	var/pen_colour = "black"
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

/obj/item/tool/pen/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!isobj(target))
		return
	var/obj/obj_target = target
	//Changing name/description of items. Only works if they have the OBJ_UNIQUE_RENAME object flag set
	if(proximity_flag && (obj_target.flags_obj & OBJ_UNIQUE_RENAME))
		var/penchoice = tgui_input_list(user, "What would you like to edit?", "Pen Setting", list("Rename", "Description", "Reset"))
		if(QDELETED(target) || !CAN_PICKUP(user, obj_target))
			return
		if(penchoice == "Rename")
			var/input = tgui_input_text(user, "What do you want to name [target]?", "Object Name", "[target.name]", MAX_NAME_LEN)
			var/oldname = target.name
			if(QDELETED(target) || !CAN_PICKUP(user, obj_target))
				return
			if(input == oldname || !input)
				to_chat(user, SPAN_NOTICE("You changed [target] to... well... [target]."))
			else
				msg_admin_niche("[key_name(usr)] changed \the [src]'s name to [input] [ADMIN_JMP(src)]")
				target.AddComponent(/datum/component/rename, input, target.desc)
				var/datum/component/label/label = target.GetComponent(/datum/component/label)
				if(label)
					label.remove_label()
					label.apply_label()
				to_chat(user, SPAN_NOTICE("You have successfully renamed \the [oldname] to [target]."))
				obj_target.renamedByPlayer = TRUE
				playsound(target, "paper_writing", 15, TRUE)

		if(penchoice == "Description")
			var/input = tgui_input_text(user, "Describe [target]", "Description", "[target.desc]", 140)
			var/olddesc = target.desc
			if(QDELETED(target) || !CAN_PICKUP(user, obj_target))
				return
			if(input == olddesc || !input)
				to_chat(user, SPAN_NOTICE("You decide against changing [target]'s description."))
			else
				msg_admin_niche("[key_name(usr)] changed \the [src]'s description to [input] [ADMIN_JMP(src)]")
				target.AddComponent(/datum/component/rename, target.name, input)
				to_chat(user, SPAN_NOTICE("You have successfully changed [target]'s description."))
				obj_target.renamedByPlayer = TRUE
				playsound(target, "paper_writing", 15, TRUE)

		if(penchoice == "Reset")
			if(QDELETED(target) || !CAN_PICKUP(user, obj_target))
				return

			qdel(target.GetComponent(/datum/component/rename))

			//reapply any label to name
			var/datum/component/label/label = target.GetComponent(/datum/component/label)
			if(label)
				label.remove_label()
				label.apply_label()

			to_chat(user, SPAN_NOTICE("You have successfully reset [target]'s name and description."))
			obj_target.renamedByPlayer = FALSE

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

/obj/item/tool/pen/fountain
	desc = "A lavish testament to the ingenuity of ARMAT's craftsmanship, this fountain pen is a paragon of design and functionality. Detailed with golden accents and intricate mechanics, the pen allows for a swift change between a myriad of ink colors with a simple twist. A product of precision engineering, each mechanism inside the pen is designed to provide a seamless, effortless transition from one color to the next, creating an instrument of luxurious versatility."
	desc_lore = "More than just a tool for writing, ARMAT's fountain pen is a symbol of distinction and authority within the ranks of the United States Colonial Marine Corps (USCM). It is a legacy item, exclusively handed out to the top-tier command personnel, each pen a tribute to the recipient's leadership and dedication.\n \nARMAT, renowned for their weapons technology, took a different approach in crafting this piece. The fountain pen, though seemingly a departure from their usual field, is deeply ingrained with the company's engineering philosophy, embodying precision, functionality, and robustness.\n \nThe golden accents are not mere embellishments; they're an identifier, setting apart these pens and their owners from the rest. The gold is meticulously alloyed with a durable metallic substance, granting it resilience to daily wear and tear. Such resilience is symbolic of the tenacity and perseverance required of USCM command personnel.\n \nEach pen is equipped with an intricate color changing mechanism, allowing the user to switch between various ink colors. This feature, inspired by the advanced targeting systems of ARMAT's weaponry, uses miniaturized actuators and precision-ground components to smoothly transition the ink flow. A simple twist of the pen's body activates the change, rotating the internal ink cartridges into place with mechanical grace, ready for the user's command.\n \nThe ink colors are not chosen arbitrarily. Each represents a different echelon within the USCM, allowing the pen's owner to write in the hue that corresponds with their rank or the rank of the recipient of their written orders. This acts as a silent testament to the authority of their words, as if each stroke of the pen echoes through the halls of USCM authority.\n \nDespite its ornate appearance, the pen is as robust as any ARMAT weapon, reflecting the company's commitment to reliability and durability. The metal components are corrosion-resistant, ensuring the pen's longevity, even under the challenging conditions often faced by USCM high command.\n \nThe fusion of luxury and utility, the blend of gold and metal, is an embodiment of the hard-won elegance of command, of the fusion between power and grace. It's more than a writing instrument - it's an emblem of leadership, an accolade to the dedication and strength of those who bear it. ARMAT's fountain pen stands as a monument to the precision, integrity, and courage embodied by the USCM's highest-ranking officers."
	name = "fountain pen"
	icon_state = "fountain_pen"
	item_state = "fountain_pen"
	matter = list("metal" = 20, "gold" = 10)
	var/static/list/colour_list = list("red", "blue", "green", "yellow", "purple", "pink", "brown", "black", "orange") // Can add more colors as required
	var/current_colour_index = 1
	var/owner = "hard to read text"

/obj/item/tool/pen/fountain/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	var/turf/current_turf = get_turf(src)
	var/mob/living/carbon/human/new_owner = locate() in current_turf
	if(new_owner)
		owner = new_owner.real_name
	var/obj/structure/machinery/cryopod/new_owners_pod = locate() in current_turf
	if(new_owners_pod)
		owner = new_owners_pod.occupant?.real_name

/obj/item/tool/pen/fountain/get_examine_text(mob/user)
	. = ..()
	. += "There's a laser engraving of [owner] on it."

/obj/item/tool/pen/fountain/attack_self(mob/living/carbon/human/user)
	if(on)
		current_colour_index = (current_colour_index % length(colour_list)) + 1
		pen_colour = colour_list[current_colour_index]
		balloon_alert(user,"you twist the pen and change the ink color to [pen_colour].")
		if(clicky)
			playsound(user.loc, 'sound/items/pen_click_on.ogg', 100, 1, 5)
		update_pen_state()
	else
		..()

/obj/item/tool/pen/attack(mob/M as mob, mob/user as mob)
	if(!ismob(M))
		return
	to_chat(user, SPAN_WARNING("You stab [M] with the pen."))
// to_chat(M, SPAN_WARNING("You feel a tiny prick!")) //That's a whole lot of meta!
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
	create_reagents(30)
	reagents.add_reagent("chloralhydrate", 22)


/obj/item/tool/pen/sleepypen/attack(mob/M as mob, mob/user as mob)
	if(!(istype(M,/mob)))
		return
	..()
	if(reagents.total_volume)
		if(M.reagents) reagents.trans_to(M, 50)
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

/obj/item/tool/stamp/weyyu
	name = "WY rubber stamp"
	icon_state = "stamp-weyyu"

/obj/item/tool/stamp/uscm
	name = "USCM rubber stamp"
	icon_state = "stamp-uscm"

/obj/item/tool/stamp/cmb
	name = "CMB rubber stamp"
	icon_state = "stamp-cmb"

/obj/item/tool/stamp/ro
	name = "quartermaster's rubber stamp"
	icon_state = "stamp-ro"

/obj/item/tool/carpenters_hammer //doesn't do anything, yet
	name = "carpenter's hammer"
	icon_state = "carpenters_hammer" //yay, it now has a sprite.
	item_state = "carpenters_hammer"
	desc = "Can be used to thwack nails into wooden objects to repair them."
