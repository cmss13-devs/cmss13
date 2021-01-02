// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/grown // Grown things that are not edible
	name = "grown_weapon"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	var/plantname
	var/potency = 1

/obj/item/grown/Initialize()
	. = ..()

	create_reagents(50)

	// Fill the object up with the appropriate reagents.
	if(!isnull(plantname))
		var/datum/seed/S = seed_types[plantname]
		if(!S || !S.chems)
			return

		potency = S.potency

		for(var/rid in S.chems)
			var/list/reagent_data = S.chems[rid]
			var/rtotal = reagent_data[1]
			if(reagent_data.len > 1 && potency > 0)
				rtotal += round(potency/reagent_data[2])
			reagents.add_reagent(rid,max(1,rtotal))

/obj/item/grown/log
	name = "towercap"
	name = "tower-cap log"
	desc = "It's better than bad, it's good!"
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "logs"
	force = 5
	flags_atom = NO_FLAGS
	throwforce = 5
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_VERY_FAST
	throw_range = 3

	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

	attackby(obj/item/W as obj, mob/user as mob)
		if(W.sharp == IS_SHARP_ITEM_BIG)
			user.show_message(SPAN_NOTICE("You make planks out of \the [src]!"), 1)
			for(var/i=0,i<2,i++)
				var/obj/item/stack/sheet/wood/NG = new (user.loc)
				for (var/obj/item/stack/sheet/wood/G in user.loc)
					if(G==NG)
						continue
					if(G.amount>=G.max_amount)
						continue
					G.attackby(NG, user)
					to_chat(usr, "You add the newly-formed wood to the stack. It now contains [NG.amount] planks.")
			qdel(src)
			return

/obj/item/grown/sunflower // FLOWER POWER!
	plantname = "sunflowers"
	name = "sunflower"
	desc = "It's beautiful! A certain person might beat you to death if you trample these."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "sunflower"
	damtype = "fire"
	force = 0
	flags_atom = NO_FLAGS
	throwforce = 1
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	throw_range = 3

/obj/item/grown/sunflower/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<font color='green'><b> [user] smacks you with a sunflower!</font><font color='yellow'><b>FLOWER POWER<b></font>")
	to_chat(user, "<font color='green'> Your sunflower's </font><font color='yellow'><b>FLOWER POWER</b></font><font color='green'> strikes [M]</font>")

/obj/item/grown/nettle // -- Skie
	plantname = "nettle"
	desc = "It's probably <B>not</B> wise to touch it with bare hands..."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	name = "nettle"
	icon_state = "nettle"
	damtype = "fire"
	force = 15
	flags_atom = NO_FLAGS
	throwforce = 1
	w_class = SIZE_SMALL
	throw_speed = SPEED_FAST
	throw_range = 3

	attack_verb = list("stung")
	hitsound = ""

	var/potency_divisior = 5

/obj/item/grown/nettle/Initialize()
	. = ..()
	force = round((5+potency/potency_divisior), 1)

/obj/item/grown/nettle/pickup(mob/living/carbon/human/user as mob)
	. = ..()
	if(istype(user) && !user.gloves)
		to_chat(user, SPAN_DANGER("The nettle burns your bare hand!"))
		if(istype(user, /mob/living/carbon/human))
			var/organ = ((user.hand ? "l_":"r_") + "arm")
			var/obj/limb/affecting = user.get_limb(organ)
			if(affecting.take_damage(0,force))
				user.UpdateDamageIcon()
		else
			user.take_limb_damage(0,force)
		return 1
	return 0

/obj/item/grown/nettle/proc/lose_leaves(var/mob/user)
	if(force > 0)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1)
		force -= rand(1,(force/3)+1) // When you whack someone with it, leaves fall off

	sleep(1)

	if(force <= 0)
		if(user)
			to_chat(user, "All the leaves have fallen off \the [src] from violent whacking.")
			user.temp_drop_inv_item(src)
		qdel(src)

/obj/item/grown/nettle/death // -- Skie
	plantname = "deathnettle"
	desc = "The \red glowing \black nettle incites \red<B>rage</B>\black in you just from looking at it!"
	name = "deathnettle"
	icon_state = "deathnettle"

	potency_divisior = 2.5

/obj/item/grown/nettle/death/pickup(mob/living/carbon/human/user as mob)

	if(..() && prob(50))
		user.KnockOut(5)
		to_chat(user, SPAN_DANGER("You are stunned by the deathnettle when you try picking it up!"))

/obj/item/grown/nettle/attack(mob/living/carbon/M as mob, mob/user as mob)

	if(!..()) return

	lose_leaves(user)

/obj/item/grown/nettle/death/attack(mob/living/carbon/M as mob, mob/user as mob)

	if(!..()) return

	if(istype(M, /mob/living))
		to_chat(M, SPAN_WARNING("You are stunned by the powerful acid of the deathnettle!"))

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had the [src.name] used on them by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] on [key_name(M)]</font>")
		msg_admin_attack("[key_name(user)] used the [src.name] on [key_name(M)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		M.eye_blurry += force/7
		if(prob(20))
			M.KnockOut(force/6)
			M.KnockDown(force/15)
		M.drop_held_item()

/obj/item/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "corncob"
	item_state = "corncob"
	w_class = SIZE_SMALL
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/corncob/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp == IS_SHARP_ITEM_ACCURATE)
		to_chat(user, SPAN_NOTICE("You use [W] to fashion a pipe out of the corn cob!"))
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe (user.loc)
		qdel(src)
	else
		return ..()
