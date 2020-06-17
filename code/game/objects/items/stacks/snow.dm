


/obj/item/stack/snow
	name = "snow pile"
	desc = "Some snow pile."
	singular_name = "layer"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "snow_stack"
	w_class = SIZE_HUGE
	force = 2
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 1
	max_amount = 25
	stack_id = "snow pile"


/obj/item/stack/snow/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/shovel))
		var/obj/item/tool/shovel/ET = W
		if(isturf(loc))
			if(ET.dirt_amt)
				if(ET.dirt_type == DIRT_TYPE_SNOW)
					if(amount < max_amount + ET.dirt_amt)
						amount += ET.dirt_amt
					else
						new /obj/item/stack/snow(loc, ET.dirt_amt)
					ET.dirt_amt = 0
					ET.update_icon()
			else
				to_chat(user, SPAN_NOTICE("You start taking snow from [src]."))
				playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)
				if(!do_after(user, ET.shovelspeed * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, SPAN_NOTICE("You stop taking snow from [src]."))
					return
				var/transf_amt = ET.dirt_amt_per_dig
				if(amount < ET.dirt_amt_per_dig)
					transf_amt = amount
				ET.dirt_amt = transf_amt
				ET.dirt_type = DIRT_TYPE_SNOW
				to_chat(user, SPAN_NOTICE("You take snow from [src]."))
				ET.update_icon()
				use(transf_amt)
				return TRUE
	else
		. = ..()




/obj/item/stack/snow/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /turf/open))
		if(user.action_busy)
			return
		var/turf/open/T = target
		if(T.get_dirt_type() == DIRT_TYPE_SNOW)
			if(T.slayer >= 3)
				to_chat(user, "This ground is already full of snow.")
				return
			to_chat(user, "You start putting some snow back on the ground.")
			if(!do_after(user, 15, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				to_chat(user, "You stop putting some snow back on the ground.")
				return
			if(T.slayer >= 3)
				return
			to_chat(user, "You put a new snow layer on the ground.")
			T.slayer += 1
			T.update_icon(TRUE, FALSE)
			use(1)

/obj/item/stack/snow/attack_self(mob/user)
	var/turf/T = get_turf(user)
	if(T.get_dirt_type() != DIRT_TYPE_SNOW)
		to_chat(user, SPAN_WARNING("You can't build a snow barricade at this location!"))
		return

	if(user.action_busy)
		return

	if(amount < 3)
		to_chat(user, SPAN_WARNING("You need 3 layers of snow to build a barricade."))
		return

	//Using same safeties as other constructions
	for(var/obj/O in user.loc) //Objects, we don't care about mobs. Turfs are checked elsewhere
		if(O.density)
			if(O.flags_atom & ON_BORDER)
				if(O.dir == user.dir)
					to_chat(user, SPAN_WARNING("There is already \a [O.name] in this direction!"))
					return
			else
				to_chat(user, SPAN_WARNING("You need a clear, open area to build the sandbag barricade!"))
				return

	user.visible_message(SPAN_NOTICE("[user] starts assembling a snow barricade."), \
		SPAN_NOTICE("You start assembling a snow barricade."))
	if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, "You stop assembling a snow barricade.")
		return
	if(amount < 3)
		return
	for(var/obj/O in user.loc) //Objects, we don't care about mobs. Turfs are checked elsewhere
		if(O.density)
			if(!(O.flags_atom & ON_BORDER) || O.dir == user.dir)
				return
	var/obj/structure/barricade/snow/SB = new(user.loc, user, user.dir)
	user.visible_message(SPAN_NOTICE("[user] assembles a sandbag barricade."),
	SPAN_NOTICE("You assemble a sandbag barricade."))
	SB.add_fingerprint(user)
	use(3)