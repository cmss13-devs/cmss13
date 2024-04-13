/* Kitchen tools
 * Contains:
 * Utensils
 * Spoons
 * Forks
 * Knives
 * Kitchen knives
 * Butcher's cleaver
 * Rolling Pins
 * Trays
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
	/// Descriptive string for currently loaded food object.
	var/loaded

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
		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(fullness > NUTRITION_HIGH)
			to_chat(user, SPAN_WARNING("[user == M ? "You" : "They"] don't feel like eating more right now."))
			return ..()
		reagents.set_source_mob(user)
		reagents.trans_to_ingest(M, reagents.total_volume)
		if(M == user)
			for(var/mob/O in viewers(M, null))
				O.show_message(SPAN_NOTICE("[user] eats some [loaded] from \the [src]."), SHOW_MESSAGE_VISIBLE)
				M.reagents.add_reagent("nutriment", 1)
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(SPAN_NOTICE("[user] feeds [M] some [loaded] from \the [src]"), SHOW_MESSAGE_VISIBLE)
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
	force = 10
	throwforce = 10
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
	force = 10
	throwforce = 10

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
	force = MELEE_FORCE_TIER_4
	w_class = SIZE_MEDIUM
	throwforce = 6
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
	force = MELEE_FORCE_NORMAL
	w_class = SIZE_SMALL
	throwforce = 8
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
	force = 8
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 7
	w_class = SIZE_MEDIUM
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")

/obj/item/tool/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	var/obj/limb/affecting = user.zone_selected
	var/drowsy_threshold = 0

	drowsy_threshold = CLOTHING_ARMOR_MEDIUM - M.getarmor(affecting, ARMOR_MELEE)

	if(affecting == "head" && istype(M, /mob/living/carbon/) && !isxeno(M))
		for(var/mob/O in viewers(user, null))
			if(M != user)
				O.show_message(text(SPAN_DANGER("<B>[M] has been hit over the head with a [name] by [user]!</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[M] hit \himself with a [name] on the head!</B>")), SHOW_MESSAGE_VISIBLE)
		if(drowsy_threshold > 0)
			M.apply_effect(min(drowsy_threshold, 10) , DROWSY)

		M.apply_damage(force, BRUTE, affecting, sharp=0) //log and damage the custom hit
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by  [key_name(user)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	else //Regular attack text
		. = ..()

	return

/*
 * Trays - Agouri
 */
/obj/item/tool/kitchen/tray
	name = "tray"
	icon = 'icons/obj/items/kitchen_tools.dmi'
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	throwforce = 12
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	flags_atom = FPRINT|CONDUCT
	matter = list("metal" = 3000)
	/// shield bash cooldown. based on world.time
	var/cooldown = 0

/obj/item/tool/kitchen/tray/attack(mob/living/carbon/M, mob/living/carbon/user)
	to_chat(user, SPAN_WARNING("You accidentally slam yourself with [src]!"))
	user.apply_effect(1, WEAKEN)
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
