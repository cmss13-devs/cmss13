/* Toys!
 * Contains:
 * Balloons
 * Fake telebeacon
 * Fake singularity
 * Toy mechs
 * Crayons
 * Snap pops
 * Water flower
 * Therapy dolls
 * Inflatable duck
 * Other things
 */

//recreational items

/obj/item/toy
	icon = 'icons/obj/items/toy.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/toys_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/toys_righthand.dmi'
	)
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	force = 0
	black_market_value = 5

/*
 * Balloons
 */
/obj/item/toy/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"

/obj/item/toy/balloon/Initialize()
	. = ..()
	create_reagents(10)

/obj/item/toy/balloon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/balloon/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_NOTICE("You fill the balloon with the contents of [A]."))
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/balloon/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_container/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, SPAN_WARNING("[O] is empty."))
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent("pacid", 1))
					to_chat(user, SPAN_WARNING("The acid chews through the balloon!"))
					O.reagents.reaction(user)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, SPAN_NOTICE("You fill the balloon with the contents of [O]."))
					O.reagents.trans_to(src, 10)
	src.update_icon()
	return

/obj/item/toy/balloon/launch_impact(atom/hit_atom)
	if(src.reagents.total_volume >= 1)
		src.visible_message(SPAN_DANGER("[src] bursts!"),"You hear a pop and a splash.")
		src.reagents.reaction(get_turf(hit_atom))
		for(var/atom/A in get_turf(hit_atom))
			src.reagents.reaction(A)
		src.icon_state = "burst"
		spawn(5)
			if(src)
				qdel(src)
	return

/obj/item/toy/balloon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/obj/item/toy/syndicateballoon
	name = "syndicate balloon"
	desc = "There is a tag on the back that reads \"FUK WY!11!\"."
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	force = 0
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "syndballoon"
	item_state = "syndballoon"
	w_class = SIZE_LARGE

/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "electronic blink toy game"
	desc = "Blink.  Blink.  Blink. Ages 8 and up."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "beacon"
	item_state = "signaller"

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "Gravitational Singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/structures/props/singularity.dmi'
	icon_state = "singularity_s1"


/*
 * Crayons
 */

/obj/item/toy/crayon
	name = "crayon"
	desc = "A colorful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/items/paint.dmi'
	icon_state = "crayonred"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/crayons.dmi',
		)
	w_class = SIZE_TINY
	attack_verb = list("attacked", "colored")
	black_market_value = 5
	var/crayon_color = COLOR_RED
	var/shade_color = "#220000"
	/// 0 for unlimited uses
	var/uses = 30
	var/instant = 0
	var/colorName = "red" //for updateIcon purposes

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon_state = "snappop"
	w_class = SIZE_TINY

/obj/item/toy/snappop/launch_impact(atom/hit_atom)
	..()
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	new /obj/effect/decal/cleanable/ash(src.loc)
	src.visible_message(SPAN_DANGER("The [src.name] explodes!"),SPAN_DANGER("You hear a snap!"))
	playsound(src, 'sound/effects/snap.ogg', 25, 1)
	qdel(src)

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		to_chat(M, SPAN_WARNING("You step on the snap pop!"))

		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 0, src)
		s.start()
		new /obj/effect/decal/cleanable/ash(src.loc)
		src.visible_message(SPAN_DANGER("The [src.name] explodes!"),SPAN_DANGER("You hear a snap!"))
		playsound(src, 'sound/effects/snap.ogg', 25, 1)
		qdel(src)

/*
 * Water flower
 */
/obj/item/toy/waterflower
	name = "Water Flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	var/empty = 0
	flags

/obj/item/toy/waterflower/Initialize()
	. = ..()
	create_reagents(10)
	reagents.add_reagent("water", 10)

/obj/item/toy/waterflower/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/waterflower/afterattack(atom/A as mob|obj, mob/user as mob)

	if (istype(A, /obj/item/storage/backpack ))
		return

	else if (locate (/obj/structure/surface/table, src.loc))
		return

	else if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_NOTICE(" You refill your flower!"))
		return

	else if (src.reagents.total_volume < 1)
		src.empty = 1
		to_chat(user, SPAN_NOTICE(" Your flower has run dry!"))
		return

	else
		src.empty = 0


		var/obj/effect/decal/D = new/obj/effect/decal/(get_turf(src))
		D.name = "water"
		D.icon = 'icons/obj/items/chemistry.dmi'
		D.icon_state = "chempuff"
		D.create_reagents(5)
		src.reagents.trans_to(D, 1)
		playsound(src.loc, 'sound/effects/spray3.ogg', 15, 1, 3)

		spawn(0)
			for(var/i=0, i<1, i++)
				step_towards(D,A)
				D.reagents.reaction(get_turf(D))
				for(var/atom/T in get_turf(D))
					D.reagents.reaction(T)
					if(ismob(T) && T:client)
						to_chat(T:client, SPAN_WARNING("[user] has sprayed you with water!"))
				sleep(4)
			qdel(D)

		return

/obj/item/toy/waterflower/get_examine_text(mob/user)
	. = ..()
	. += "[reagents.total_volume] units of water left!"


/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon_state = "ripleytoy"
	var/cooldown = 0
	w_class = SIZE_TINY

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user)
	..()

	if(cooldown < world.time - 8)
		to_chat(user, SPAN_NOTICE("You play with [src]."))
		playsound(user, 'sound/mecha/mechstep.ogg', 15, 1)
		cooldown = world.time

/obj/item/toy/prize/attack_hand(mob/user)
	if(loc == user)
		if(cooldown < world.time - 8)
			to_chat(user, SPAN_NOTICE("You play with [src]."))
			playsound(user, 'sound/mecha/mechturn.ogg', 15, 1)
			cooldown = world.time
			return
	..()

/obj/item/toy/prize/ripley
	name = "toy ripley"
	desc = "Mini-Mecha action figure! Collect them all! 1/11."

/obj/item/toy/prize/fireripley
	name = "toy firefighting ripley"
	desc = "Mini-Mecha action figure! Collect them all! 2/11."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deathsquad ripley"
	desc = "Mini-Mecha action figure! Collect them all! 3/11."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "toy gygax"
	desc = "Mini-Mecha action figure! Collect them all! 4/11."
	icon_state = "gygaxtoy"


/obj/item/toy/prize/durand
	name = "toy durand"
	desc = "Mini-Mecha action figure! Collect them all! 5/11."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mecha action figure! Collect them all! 6/11."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy marauder"
	desc = "Mini-Mecha action figure! Collect them all! 7/11."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy seraph"
	desc = "Mini-Mecha action figure! Collect them all! 8/11."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy mauler"
	desc = "Mini-Mecha action figure! Collect them all! 9/11."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy odysseus"
	desc = "Mini-Mecha action figure! Collect them all! 10/11."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy phazon"
	desc = "Mini-Mecha action figure! Collect them all! 11/11."
	icon_state = "phazonprize"


/obj/item/toy/inflatable_duck
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"
	icon = 'icons/obj/items/clothing/belts/misc.dmi'
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/misc.dmi'
	)
	flags_equip_slot = SLOT_WAIST
	black_market_value = 20

/obj/item/toy/beach_ball
	name = "beach ball"
	icon_state = "beachball"
	item_state = "beachball"
	density = FALSE
	anchored = FALSE
	w_class = SIZE_SMALL
	force = 0
	throwforce = 0
	throw_speed = SPEED_SLOW
	throw_range = 20

/obj/item/toy/beach_ball/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	user.drop_held_item()
	throw_atom(target, throw_range, throw_speed, user)

/obj/item/toy/dice
	name = "d6"
	desc = "A die with six sides."
	icon = 'icons/obj/items/dice.dmi'
	icon_state = "d66"
	w_class = SIZE_TINY
	var/sides = 6
	attack_verb = list("diced")

/obj/item/toy/dice/Initialize()
	. = ..()
	icon_state = "[name][rand(1, sides)]"

/obj/item/toy/dice/d20
	name = "d20"
	desc = "A die with twenty sides."
	icon_state = "d2020"
	sides = 20

/obj/item/toy/dice/attack_self(mob/user)
	..()
	var/result = rand(1, sides)
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[name][result]"
	user.visible_message(SPAN_NOTICE("[user] has thrown [src]. It lands on [result]. [comment]"),
						SPAN_NOTICE("You throw [src]. It lands on a [result]. [comment]"),
						SPAN_NOTICE("You hear [src] landing on a [result]. [comment]"))

/obj/item/toy/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	attack_verb = list("HONKED")
	black_market_value = 25
	var/spam_flag = 0
	var/sound_effect = 'sound/items/bikehorn.ogg'

/obj/item/toy/bikehorn/attack_self(mob/user)
	..()

	if (!spam_flag)
		spam_flag = TRUE
		playsound(src.loc, sound_effect, 25, 1)
		src.add_fingerprint(user)
		addtimer(VARSET_CALLBACK(src, spam_flag, FALSE), 2 SECONDS)

// rubber duck
/obj/item/toy/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~" //thanks doohl
	icon_state = "rubberducky"
	item_state = "rubberducky"

/obj/item/computer3_part
	name = "computer part"
	desc = "Holy jesus you donnit now"
	gender = PLURAL
	icon = 'icons/obj/structures/machinery/stock_parts.dmi'
	icon_state = "hdd1"
	w_class = SIZE_SMALL
	crit_fail = 0

/obj/item/computer3_part/toybox
	var/list/prizes = list( /obj/item/storage/box/snappops = 2,
							/obj/item/toy/blink = 2,
							/obj/item/toy/sword = 2,
							/obj/item/toy/gun = 2,
							/obj/item/toy/crossbow = 2,
							/obj/item/clothing/suit/syndicatefake = 2,
							/obj/item/storage/fancy/crayons = 2,
							/obj/item/toy/spinningtoy = 2,
							/obj/item/toy/prize/ripley = 1,
							/obj/item/toy/prize/fireripley = 1,
							/obj/item/toy/prize/deathripley = 1,
							/obj/item/toy/prize/gygax = 1,
							/obj/item/toy/prize/durand = 1,
							/obj/item/toy/prize/honk = 1,
							/obj/item/toy/prize/marauder = 1,
							/obj/item/toy/prize/seraph = 1,
							/obj/item/toy/prize/mauler = 1,
							/obj/item/toy/prize/odysseus = 1,
							/obj/item/toy/prize/phazon = 1,
							/obj/item/clothing/shoes/slippers = 1,
							/obj/item/clothing/shoes/slippers_worn = 1,
							/obj/item/clothing/head/collectable/tophat/super = 1,
							)

/obj/item/toy/festivizer
	name = "\improper C92 pattern 'Festivizer' decorator"
	desc = "State of the art, WY-brand, high tech... ah who are we kidding, it's just a festivizer. You spot a label on it that says: <i> Attention: This device does not cover item in festive wire, but rather paints it a festive color. </i> What a rip!"
	icon = 'icons/obj/items/marine-items_christmas.dmi'
	icon_state = "festive_wire"
	attack_speed = 0.8 SECONDS

/obj/item/toy/festivizer/get_examine_text(mob/user)
	. = ..()
	. += SPAN_BOLDNOTICE("You see another label on \the [src] that says: <i> INCLUDES SUPPORT FOR FOREIGN BIOFORMS! </i> You're not sure you like the sound of that.")

/obj/item/toy/festivizer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!target.Adjacent(user))
		return
	if(ismob(target) || isVehicle(target))
		to_chat(user, SPAN_NOTICE("\The [src] is not able to festivize lifeforms or vehicles for safety concerns."))
		return
	if(target.color)
		to_chat(user, SPAN_NOTICE("\The [target] is already colored, don't be greedy!"))
		return
	var/red = prob(50)
	target.color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, red? 0.2 : 0,!red? 0.2 : 0,0,0)
	target.visible_message(SPAN_GREEN("\The [target] has been festivized by [user]! Merry Christmas!"))
	to_chat(user, SPAN_GREEN("You festivize \the [target]! Merry Christmas!"))
	playsound(user, pick(95;'sound/items/jingle_short.wav', 5;'sound/items/jingle_long.wav'), 25, TRUE)
	if(prob(5))
		playsound(target, pick('sound/voice/alien_queen_xmas.ogg', 'sound/voice/alien_queen_xmas_2.ogg'), 25, TRUE)
	user.festivizer_hits_total++

/obj/item/toy/festivizer/attack_alien(mob/living/carbon/xenomorph/M)
	attack_hand(M) //xenos can use them too.
	return XENO_NONCOMBAT_ACTION

/obj/item/toy/festivizer/xeno
	name = "strange resin-covered festivizer decorator"
	desc = "This bizarre festivizer is covered in goopy goop and schmuck. Ew! It's so sticky, *anything* could grab onto it! Grab it and touch other things to festivize them!"

/obj/item/toy/plush
	name = "generic plushie"
	desc = "perfectly generic"
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "debug"
	w_class = SIZE_SMALL
	COOLDOWN_DECLARE(last_hug_time)
	black_market_value = 10

/obj/item/toy/plush/attack_self(mob/user)
	..()
	if(!COOLDOWN_FINISHED(src, last_hug_time))
		return
	user.visible_message(SPAN_NOTICE("[user] hugs [src] tightly!"), SPAN_NOTICE("You hug [src]."))
	playsound(user, "plush", 25, TRUE)
	COOLDOWN_START(src, last_hug_time, 2.5 SECONDS)

/obj/item/toy/plush/farwa
	name = "Farwa plush"
	desc = "A Farwa plush doll. It's soft and comforting!"
	icon_state = "farwa"
	item_state = "farwaplush"
	black_market_value = 25

/obj/item/toy/plush/barricade
	name = "plushie barricade"
	desc = "Great for squeezing whenever you're scared. Or lightly hurt. Or in any other situation."
	icon_state = "barricade"
	item_state = "plushie_cade"

/obj/item/toy/plush/shark //A few more generic plushies to increase the size of the plushie loot pool
	name = "shark plush"
	desc = "A plushie depicting a somewhat cartoonish shark. The tag notes that it was made by an obscure furniture manufacturer in Scandinavia."
	icon_state = "shark"

/obj/item/toy/plush/bee
	name = "bee plush"
	desc = "A cute toy that awakens the warrior spirit in the most reserved marine."
	icon_state = "bee"

/obj/item/toy/plush/rock
	name = "rock plush"
	desc = "It says it is a plush on the tag, at least."
	icon_state = "rock"

/obj/item/toy/plush/gnarp
	name = "gnarp plush"
	desc = "gnarp gnarp."
	icon_state = "gnarp"

/obj/item/toy/plush/gnarp/alt
	name = "gnarp plush"
	desc = "gnarp gnarp."
	icon_state = "gnarp_alt"

/obj/item/toy/plush/therapy
	name = "therapy plush"
	desc = "A therapeutic toy to assist marines in recovering from mental and behavioral disorders after experiencing the trauma of battles."
	icon_state = "therapy"

/obj/item/toy/plush/therapy/red
	name = "red therapy plush"
	color = "#FC5274"

/obj/item/toy/plush/therapy/blue
	name = "blue therapy plush"
	color = "#9EBAE0"

/obj/item/toy/plush/therapy/green
	name = "green therapy plush"
	color = "#A3C940"

/obj/item/toy/plush/therapy/orange
	name = "orange therapy plush"
	color = "#FD8535"

/obj/item/toy/plush/therapy/purple
	name = "purple therapy plush"
	color = "#A26AC7"

/obj/item/toy/plush/therapy/yellow
	name = "yellow therapy plush"
	color = "#FFE492"

/obj/item/toy/plush/therapy/random_color
	///Hexadecimal 0-F (0-15)
	var/static/list/hexadecimal = list("0", "1", "2", "3" , "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F")

/obj/item/toy/plush/therapy/random_color/Initialize(mapload, ...)
	. = ..()
	var/color_code = "#[pick(hexadecimal)][pick(hexadecimal)][pick(hexadecimal)][pick(hexadecimal)][pick(hexadecimal)][pick(hexadecimal)]" //This is dumb and I hope theres a better way I'm missing
	color = color_code
	desc = "A custom therapy plush, in a unique color."

/obj/item/toy/plush/random_plushie //Not using an effect so it can fit into storage from loadout
	name = "random plush"
	desc = "This plush looks awfully standard and bland. Is it actually yours?"
	/// Standard plushies for the spawner to pick from
	var/list/plush_list = list(
		/obj/item/toy/plush/farwa,
		/obj/item/toy/plush/barricade,
		/obj/item/toy/plush/bee,
		/obj/item/toy/plush/shark,
		/obj/item/toy/plush/gnarp,
		/obj/item/toy/plush/gnarp/alt,
		/obj/item/toy/plush/rock,
	)
	///Therapy plushies left separately to not flood the entire list
	var/list/therapy_plush_list = list(
		/obj/item/toy/plush/therapy,
		/obj/item/toy/plush/therapy/red,
		/obj/item/toy/plush/therapy/blue,
		/obj/item/toy/plush/therapy/green,
		/obj/item/toy/plush/therapy/orange,
		/obj/item/toy/plush/therapy/purple,
		/obj/item/toy/plush/therapy/yellow,
		/obj/item/toy/plush/therapy/random_color,
	)

/obj/item/toy/plush/random_plushie/Initialize(mapload, ...)
	. = ..()
	if(mapload) //Placed in mapping, will be randomized instantly on spawn
		create_plushie()
		return INITIALIZE_HINT_QDEL

/obj/item/toy/plush/random_plushie/pickup(mob/user, silent)
	. = ..()
	RegisterSignal(user, COMSIG_POST_SPAWN_UPDATE, PROC_REF(create_plushie), override = TRUE)

///The randomizer picking and spawning a plushie on either the ground or in the humans backpack. Needs var/source due to signals
/obj/item/toy/plush/random_plushie/proc/create_plushie(datum/source)
	SIGNAL_HANDLER
	if(source)
		UnregisterSignal(source, COMSIG_POST_SPAWN_UPDATE)
	var/turf/spawn_location = get_turf(src)
	var/plush_list_variety = pick(60; plush_list, 40; therapy_plush_list)
	var/random_plushie = pick(plush_list_variety)
	var/obj/item/toy/plush/plush = new random_plushie(spawn_location) //Starts on floor by default
	var/mob/living/carbon/human/user = source

	if(!user) //If it didn't spawn on a humanoid
		qdel(src)
		return

	var/obj/item/storage/backpack/storage = locate() in user //If the user has a backpack, put it there
	if(storage?.can_be_inserted(plush, user, stop_messages = TRUE))
		storage.attempt_item_insertion(plush, TRUE, user)
	if(plush.loc == spawn_location) // Still on the ground
		user.put_in_hands(plush, drop_on_fail = TRUE)
	qdel(src)

//Admin plushies
/obj/item/toy/plush/yautja
	name = "strange plush"
	desc = "A plush doll depicting some sort of tall humanoid biped..?"
	icon_state = "yautja"
	black_market_value = 100

/obj/item/toy/plush/runner
	name = "\improper XX-121 therapy plush"
	desc = "Don't be sad! Be glad (that you're alive)!"
	icon_state = "runner"
	/// If the runner is wearing a beret
	var/beret = FALSE

/obj/item/toy/plush/runner/Initialize(mapload, ...)
	. = ..()
	if(beret)
		update_icon()

/obj/item/toy/plush/runner/attackby(obj/item/attacking_object, mob/user)
	. = ..()
	if(beret)
		return
	if(!istypestrict(attacking_object, /obj/item/clothing/head/beret/marine/mp))
		return
	var/beret_attack = attacking_object
	to_chat(user, SPAN_NOTICE("You put [beret_attack] on [src]."))
	qdel(beret_attack)
	beret = TRUE
	update_icon()

/obj/item/toy/plush/runner/update_icon()
	. = ..()
	if(beret)
		icon_state = "runner_beret"
		return
	icon_state = "runner"
