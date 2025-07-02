




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
	if(!proximity)
		return

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
	if(istype(A, /obj/vehicle/multitile) || (istype(A, /obj/structure) && !istype(A, /obj/structure/closet/crate))) // disallow naming structures and vehicles, but not crates!
		to_chat(user, SPAN_WARNING("The label won't stick to that."))
		return
	if(isturf(A))
		to_chat(user, SPAN_WARNING("The label won't stick to that."))
		return
	if(istype(A, /obj/item/storage/pill_bottle))
		var/obj/item/storage/pill_bottle/target_pill_bottle = A
		target_pill_bottle.choose_color(user)

	if(!label || !length(label))
		remove_label(A, user)
		return

	var/datum/component/label/labelcomponent = A.GetComponent(/datum/component/label)
	if(labelcomponent && labelcomponent.has_label())
		if(labelcomponent.label_name == label)
			to_chat(user, SPAN_WARNING("The label already says \"[label]\"."))
			return

	user.visible_message(SPAN_NOTICE("[user] labels [A] as \"[label]\"."),
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
		to_chat(user, SPAN_NOTICE("You turn on [src]."))
		//Now let them choose the text.
		var/str = copytext(reject_bad_text(tgui_input_text(user, "Label text?", "Set label", "", MAX_NAME_LEN, ui_state=GLOB.not_incapacitated_state)), 1, MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(user, SPAN_NOTICE("Label text cleared. You can now remove labels."))
			label = null
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
		return

	to_chat(user, SPAN_NOTICE("You turn off [src]."))
	return

/*
	Allow the user of the labeler to remove a label, if there is no text set
	@A object trying to remove the label
	@user the player using the labeler

*/

/obj/item/tool/hand_labeler/proc/remove_label(atom/target, mob/user)
	var/datum/component/label/label = target.GetComponent(/datum/component/label)
	if(label && label.has_label())
		user.visible_message(SPAN_NOTICE("[user] removes label from [target]."),
						SPAN_NOTICE("You remove the label from [target]."))
		log_admin("[key_name(usr)] has removed label from [target].")
		label.clear_label()
		playsound(target, remove_label_sound, 20, TRUE)
		return

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
			to_chat(user, SPAN_NOTICE("[src] is already full."))

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
	item_state_slots = list(WEAR_AS_GARB = "pen_black")
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
	)
	flags_equip_slot = SLOT_WAIST|SLOT_EAR|SLOT_SUIT_STORE
	throwforce = 0
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	matter = list("metal" = 10)
	inherent_traits = list(TRAIT_TOOL_PEN)
	/// what color the ink is!
	var/pen_color = "black"
	var/on = TRUE
	var/clicky = FALSE

/obj/item/tool/pen/attack_self(mob/living/carbon/human/user)
	..()
	on = !on
	to_chat(user, SPAN_WARNING("You click the pen [on? "on": "off"]."))
	if(clicky)
		playsound(user.loc, "sound/items/pen_click_[on? "on": "off"].ogg", 100, 1, 5)
	update_pen_state()

/obj/item/tool/pen/Initialize(mapload, ...)
	. = ..()
	update_pen_state()

/obj/item/tool/pen/proc/update_pen_state()
	overlays.Cut()
	if(on)
		overlays += "+[pen_color]_tip"

/obj/item/tool/pen/attack(mob/living/target, mob/living/user)
	if(!ismob(target))
		return
	to_chat(user, SPAN_WARNING("You stab [target] with the pen."))
	target.last_damage_data = create_cause_data(initial(name), user)
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stabbed with [name] by [key_name(user)]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to stab [key_name(target)]</font>")
	msg_admin_attack("[key_name(user)] Used the [name] to stab [key_name(target)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
	return

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
				msg_admin_niche("[key_name(usr)] changed [src]'s name to [input] [ADMIN_JMP(src)]")
				target.AddComponent(/datum/component/rename, input, target.desc)
				var/datum/component/label/label = target.GetComponent(/datum/component/label)
				if(label)
					label.clear_label()
					label.apply_label()
				to_chat(user, SPAN_NOTICE("You have successfully renamed [oldname] to [target]."))
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
				label.clear_label()
				label.apply_label()

			to_chat(user, SPAN_NOTICE("You have successfully reset [target]'s name and description."))
			obj_target.renamedByPlayer = FALSE

/obj/item/tool/pen/clicky
	desc = "It's a W-Y brand extra clicky black ink pen."
	name = "WY pen"
	clicky = TRUE

/obj/item/tool/pen/blue
	desc = "It's a normal blue ink pen."
	item_state_slots = list(WEAR_AS_GARB = "pen_blue")
	pen_color = "blue"

/obj/item/tool/pen/blue/clicky
	desc = "It's a W-Y brand extra clicky blue ink pen."
	name = "WY blue pen"
	clicky = TRUE

/obj/item/tool/pen/red
	desc = "It's a normal red ink pen."
	item_state_slots = list(WEAR_AS_GARB = "pen_red")
	pen_color = "red"

/obj/item/tool/pen/red/clicky
	desc = "It's a W-Y brand extra clicky red ink pen."
	name = "WY red pen"
	clicky = TRUE

/obj/item/tool/pen/green
	desc = "It's a normal green ink pen."
	pen_color = "green"

/obj/item/tool/pen/green/clicky
	desc = "It's a W-Y brand extra clicky green ink pen."
	name = "WY green pen"
	clicky = TRUE

/obj/item/tool/pen/white
	desc = "It's a rare white ink pen."
	pen_color = "white"

/obj/item/tool/pen/white/clicky
	desc = "It's a WY brand extra clicky white ink pen."
	name = "WY white pen"
	clicky = TRUE

/obj/item/tool/pen/multicolor
	name = "multicolor pen"
	desc = "A color switching pen!"
	var/list/colour_list = list("red", "blue", "black")
	var/current_colour_index = 1

/obj/item/tool/pen/multicolor/attack_self(mob/living/carbon/human/user)
	if(!on)
		return ..()

	current_colour_index = (current_colour_index % length(colour_list)) + 1
	pen_color = colour_list[current_colour_index]
	balloon_alert(user,"you twist the pen and change the ink color to [pen_color].")
	if(clicky)
		playsound(user.loc, 'sound/items/pen_click_on.ogg', 100, 1, 5)
	update_pen_state()

/obj/item/tool/pen/multicolor/fountain
	desc = "A lavish testament to the ingenuity of ARMAT's craftsmanship, this fountain pen is a paragon of design and functionality. Detailed with golden accents and intricate mechanics, the pen allows for a swift change between a myriad of ink colors with a simple twist. A product of precision engineering, each mechanism inside the pen is designed to provide a seamless, effortless transition from one color to the next, creating an instrument of luxurious versatility."
	desc_lore = "More than just a tool for writing, ARMAT's fountain pen is a symbol of distinction and authority within the ranks of the United States Colonial Marine Corps (USCM). It is a legacy item, exclusively handed out to the top-tier command personnel, each pen a tribute to the recipient's leadership and dedication.\n \nARMAT, renowned for their weapons technology, took a different approach in crafting this piece. The fountain pen, though seemingly a departure from their usual field, is deeply ingrained with the company's engineering philosophy, embodying precision, functionality, and robustness.\n \nThe golden accents are not mere embellishments; they're an identifier, setting apart these pens and their owners from the rest. The gold is meticulously alloyed with a durable metallic substance, granting it resilience to daily wear and tear. Such resilience is symbolic of the tenacity and perseverance required of USCM command personnel.\n \nEach pen is equipped with an intricate color changing mechanism, allowing the user to switch between various ink colors. This feature, inspired by the advanced targeting systems of ARMAT's weaponry, uses miniaturized actuators and precision-ground components to smoothly transition the ink flow. A simple twist of the pen's body activates the change, rotating the internal ink cartridges into place with mechanical grace, ready for the user's command.\n \nThe ink colors are not chosen arbitrarily. Each represents a different echelon within the USCM, allowing the pen's owner to write in the hue that corresponds with their rank or the rank of the recipient of their written orders. This acts as a silent testament to the authority of their words, as if each stroke of the pen echoes through the halls of USCM authority.\n \nDespite its ornate appearance, the pen is as robust as any ARMAT weapon, reflecting the company's commitment to reliability and durability. The metal components are corrosion-resistant, ensuring the pen's longevity, even under the challenging conditions often faced by USCM high command.\n \nThe fusion of luxury and utility, the blend of gold and metal, is an embodiment of the hard-won elegance of command, of the fusion between power and grace. It's more than a writing instrument - it's an emblem of leadership, an accolade to the dedication and strength of those who bear it. ARMAT's fountain pen stands as a monument to the precision, integrity, and courage embodied by the USCM's highest-ranking officers."
	name = "fountain pen"
	icon_state = "fountain_pen"
	item_state = "fountain_pen"
	item_state_slots = list(WEAR_AS_GARB = "fountain_pen")
	matter = list("metal" = 20, "gold" = 10)
	colour_list = list("red", "blue", "green", "yellow", "purple", "pink", "brown", "black", "orange") // Can add more colors as required
	var/owner_name

/obj/item/tool/pen/multicolor/fountain/pickup(mob/user, silent)
	. = ..()
	if(!owner_name)
		RegisterSignal(user, COMSIG_POST_SPAWN_UPDATE, PROC_REF(set_owner), override = TRUE)

///Sets the owner of the pen to who it spawns with, requires var/source for signals
/obj/item/tool/pen/multicolor/fountain/proc/set_owner(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_POST_SPAWN_UPDATE)
	var/mob/living/carbon/human/user = source
	owner_name = user.name

/obj/item/tool/pen/multicolor/fountain/get_examine_text(mob/user)
	. = ..()
	if(owner_name)
		. += "There's a laser engraving of [owner_name] on it."

/obj/item/tool/pen/multicolor/provost
	name = "provost pen"
	desc = "A sleek black shell pen with the Provost Office sigil engraved into the side. It can change colors as needed for various functions within the Provost and Military Police."
	icon_state = "provost_pen"
	colour_list = list("blue", "green", "black", "orange", "red", "white")

/*
 * Antag pens
 */
/obj/item/tool/pen/sleepypen
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\""
	flags_atom = FPRINT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST

/obj/item/tool/pen/sleepypen/Initialize()
	. = ..()
	create_reagents(30)
	reagents.add_reagent("chloralhydrate", 15)

/obj/item/tool/pen/sleepypen/attack(mob/M as mob, mob/user as mob)
	if(!(istype(M,/mob)))
		return
	..()
	if(reagents.total_volume)
		if(M.reagents)
			reagents.trans_to(M, 50)
	return

/obj/item/tool/pen/paralysis
	flags_atom = FPRINT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST

/obj/item/tool/pen/paralysis/attack(mob/living/M as mob, mob/user as mob)
	if(!(istype(M)))
		return
	..()
	if(M.can_inject(user, TRUE))
		if(reagents.total_volume)
			if(M.reagents)
				reagents.trans_to(M, 50)

/obj/item/tool/pen/paralysis/Initialize()
	. = ..()
	create_reagents(50)
	reagents.add_reagent("zombiepowder", 10)
	reagents.add_reagent("cryptobiolin", 15)

/*
 * Stamps
 */
/obj/item/tool/stamp
	name = "rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/items/paper.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
	)
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

/obj/item/tool/stamp/approved
	name = "\improper APPROVED rubber stamp"
	icon_state = "stamp-approve"

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
