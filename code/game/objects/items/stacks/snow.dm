GLOBAL_LIST_INIT(snow_recipes, list(
	new /datum/stack_recipe("snow barricade", /obj/structure/barricade/snow, 3, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = TRUE, flags = RESULT_REQUIRES_SNOW),
	new /datum/stack_recipe("snowball", /obj/item/snowball, 1)
	))


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

/obj/item/stack/snow/Initialize(mapload, amount)
	recipes = GLOB.snow_recipes
	return ..()

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
	if(!proximity)
		return
	if(istype(target, /turf/open))
		if(user.action_busy)
			return
		var/turf/open/T = target
		if(istype(T,/turf/open/snow) || istype(T,/turf/open/auto_turf/snow))
			if(T.bleed_layer >= 3)
				to_chat(user, "This ground is already full of snow.")
				return
			to_chat(user, "You start putting some snow back on the ground.")
			if(!do_after(user, 15, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				to_chat(user, "You stop putting some snow back on the ground.")
				return
			if(T.bleed_layer >= 3)
				return
			to_chat(user, "You put a new snow layer on the ground.")
			if(istype(T,/turf/open/auto_turf/snow))
				var/turf/open/auto_turf/snow/AT = T
				AT.changing_layer(AT.bleed_layer += 1)
			else
				T.bleed_layer++
				T.update_icon(TRUE, FALSE)
			use(1)

/obj/item/snowball
	name = "snowball"
	desc = "A weapon of mass destruction, this perfectly crafted item can be used to decimate the enemy forces, provided there isn't a shoebill to block your shot..."
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "snowball"
	item_state = "latex"
	flags_atom = ITEM_UNCATCHABLE
	force = 0
	w_class = SIZE_SMALL
	throwforce = 0
	throw_speed = SPEED_AVERAGE
	throw_range = 7
	attack_verb = list("smashed", "smacked", "slugged")
	flags_equip_slot = SLOT_STORE // tactical snowball

/obj/item/snowball/attack(mob/living/M, mob/living/user)
	. = ..()
	M.apply_effect(2, SLOW)
	M.apply_effect(2, DAZE)
	qdel(src)

/obj/item/snowball/launch_impact(atom/hit_atom)
	. = ..()
	qdel(src)

/obj/item/snowball/mob_launch_collision(mob/living/L)
	. = ..()
	L.apply_effect(2, SLOW)
	L.apply_effect(2, DAZE)
