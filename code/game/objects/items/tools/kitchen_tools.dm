/* Kitchen tools
 * Contains:
 *		Utensils
 *		Spoons
 *		Forks
 *		Knives
 *		Kitchen knives
 *		Butcher's cleaver
 *		Rolling Pins
 *		Trays
 */

/obj/item/tool/kitchen
	icon = 'icons/obj/items/kitchen_tools.dmi'

/*
 * Utensils
 */
/obj/item/tool/kitchen/utensil
	force = 5
	w_class = SIZE_TINY
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	flags_atom = FPRINT|CONDUCT
	
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = 0
	var/loaded      //Descriptive string for currently loaded food object.

/obj/item/tool/kitchen/utensil/Initialize()
	. = ..()
	if (prob(60))
		src.pixel_y = rand(0, 4)

	create_reagents(5)
	return

/obj/item/tool/kitchen/utensil/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if(user.a_intent != INTENT_HELP)
		return ..()

	if (reagents.total_volume > 0)
		reagents.set_source_mob(user)
		reagents.trans_to_ingest(M, reagents.total_volume)
		if(M == user)
			for(var/mob/O in viewers(M, null))
				O.show_message(SPAN_NOTICE("[user] eats some [loaded] from \the [src]."), 1)
				M.reagents.add_reagent("nutriment", 1)
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(SPAN_NOTICE("[user] feeds [M] some [loaded] from \the [src]"), 1)
				M.reagents.add_reagent("nutriment", 1)
		playsound(M.loc,'sound/items/eatfood.ogg', 15, 1)
		overlays.Cut()
		return
	else
		..()

/obj/item/tool/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"

/obj/item/tool/kitchen/utensil/pfork
	name = "plastic fork"
	desc = "Yay, no washing up to do."
	icon_state = "pfork"

/obj/item/tool/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")

/obj/item/tool/kitchen/utensil/pspoon
	name = "plastic spoon"
	desc = "It's a plastic spoon. How dull."
	icon_state = "pspoon"
	attack_verb = list("attacked", "poked")

/*
 * Knives
 */
/obj/item/tool/kitchen/utensil/knife
	name = "knife"
	desc = "Can cut through any food."
	icon_state = "knife"
	force = 10.0
	throwforce = 10.0
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = 1

/obj/item/tool/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 5)

/obj/item/tool/kitchen/utensil/pknife
	name = "plastic knife"
	desc = "The bluntest of blades."
	icon_state = "pknife"
	force = 10.0
	throwforce = 10.0

/obj/item/tool/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 5)

/*
 * Kitchen knives
 */
/obj/item/tool/kitchen/knife
	name = "kitchen knife"
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	flags_atom = FPRINT|CONDUCT
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = 1
	force = 10.0
	w_class = SIZE_MEDIUM
	throwforce = 6.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	matter = list("metal" = 12000)
	
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/*
 * Bucher's cleaver
 */
/obj/item/tool/kitchen/knife/butcher
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	flags_atom = FPRINT|CONDUCT
	force = 15.0
	w_class = SIZE_SMALL
	throwforce = 8.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	matter = list("metal" = 12000)
	
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = 1

/obj/item/tool/kitchen/knife/butcher/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 5)

/*
 * Rolling Pins
 */

/obj/item/tool/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	force = 8.0
	throwforce = 10.0
	throw_speed = SPEED_FAST
	throw_range = 7
	w_class = SIZE_MEDIUM
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked") //I think the rollingpin attackby will end up ignoring this anyway.

/obj/item/tool/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	M.last_damage_source = initial(name)
	M.last_damage_mob = user
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [key_name(user)]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [key_name(M)]</font>")
	msg_admin_attack("[key_name(user)] used the [src.name] to attack [key_name(M)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	var/t = user:zone_selected
	if (t == "head")
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/head_protection = H.head
			if (H.stat < 2 && H.health < 50 && prob(90))
				// ******* Check
				if (istype(head_protection) && head_protection.flags_inventory & BLOCKSHARPOBJ  && prob(80))
					to_chat(H, SPAN_DANGER("The helmet protects you from being hit hard in the head!"))
					return
				var/time = rand(2, 6)
				if (prob(75))
					H.KnockOut(time)
				else
					H.Stun(time)
				if(H.stat != 2)	H.stat = 1
				user.visible_message(SPAN_DANGER("<B>[H] has been knocked unconscious!</B>"), SPAN_DANGER("<B>You knock [H] unconscious!</B>"))
				return
			else
				H.visible_message(SPAN_DANGER("[user] tried to knock [H] unconscious!"), SPAN_DANGER("[user] tried to knock you unconscious!"))
				H.eye_blurry += 3
	return ..()

/*
 * Trays - Agouri
 */
/obj/item/tool/kitchen/tray
	name = "tray"
	icon = 'icons/obj/items/kitchen_tools.dmi'
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	throwforce = 12.0
	throwforce = 10.0
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	flags_atom = FPRINT|CONDUCT
	matter = list("metal" = 3000)
	var/cooldown = 0	//shield bash cooldown. based on world.time

/obj/item/tool/kitchen/tray/attack(mob/living/carbon/M, mob/living/carbon/user)
	to_chat(user, SPAN_WARNING("You accidentally slam yourself with the [src]!"))
	user.KnockDown(1)
	user.take_limb_damage(2)

	playsound(M, 'sound/items/trayhit2.ogg', 25, 1) //sound playin'
	return //it always returns, but I feel like adding an extra return just for safety's sakes. EDIT; Oh well I won't :3

/obj/item/tool/kitchen/tray/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [W]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 25, 1)
			cooldown = world.time
	else
		..()